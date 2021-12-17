(
SynthDef.new(\dirtlog, { |out, freq, gate=0.5, decay=1,detune, mres=0, mcut=10000, sawvol = 1, puvol = 1, sinvol = 1, detvol = 1, pwidth = 0.5, sustain=1, release=1,pan|
	var sig, vEnv,fEnv, volfunc;
	vEnv = EnvGen.ar(Env.perc(0.01,release,1,-4),timeScale:sustain,doneAction:2);
	//fEnv = XLine.kr(mcut,0.0001,decay,doneAction:2);
	fEnv = EnvGen.ar(Env.perc(0.01,release,1,-4),timeScale:sustain,doneAction:2);
	sig = (((SawDPW.ar(freq) + SawDPW.ar(freq + detune)*detvol)*sawvol) + ((Pulse.ar(freq,pwidth) + Pulse.ar(freq + detune,pwidth)*detvol)*puvol) + ((SinOsc.ar(freq) + SinOsc.ar(freq + detune)*detvol)*sinvol)) * vEnv;
	volfunc = (puvol+sawvol+sinvol+detvol);
	sig = MoogFF.ar(sig,fEnv*mcut,mres,0)/volfunc;
	Out.ar(out,Pan2.ar(sig,pan));
}).add;


SynthDef.new(\dirtfm, {
	|out, freq=440, gate=0.5,sustain=1,amp=1,pan=0,release=1,attack=1, mratio=2, mratio2=4|
	var env,sig;
	env=EnvGen.ar(Env.perc(0.01,release,1,-4),1,1,0.01,timeScale:sustain,doneAction:2);
	sig =  SinOsc.ar(freq*SinOsc.ar(freq/mratio));
	sig =  sig*SinOsc.ar(freq*SinOsc.ar(freq/mratio2));
	sig = sig*amp;
	sig = sig*env;
	Out.ar(out,Pan2.ar(sig,pan));
}).add;

SynthDef.new(\kraftsnare, {
	|out, freq, mcut=10000, mres, decay = 0.4, pan, amp = 1,release=1,pwidth=0.5,noisevol=1,puvol=1|
	var sig, nEnv, pEnv, nSig, pSig;
	nEnv = EnvGen.ar(Env.perc(0.01,decay,1,-4),timeScale:decay,doneAction:2);
	pEnv = EnvGen.ar(Env.perc(0.01,decay/2,1,-8),timeScale:decay,doneAction:2);
	nSig = (WhiteNoise.ar*nEnv)*noisevol;
	pSig = PulseDPW.ar(freq*4,pwidth)*pEnv*puvol;
	sig = MoogFF.ar(((nSig+pSig)*amp/2),mcut,mres);
	Out.ar(out,Pan2.ar(sig,pan));
}).add;

SynthDef.new(\kick, {
	|out, freq, mcut=10000, mres, decay = 1, pan, amp = 1,release=0.01,pwidth=0.5,noisevol=1,puvol=1|
	var sig, vEnv, pEnv, nSig, pSig;
	vEnv = EnvGen.ar(Env.perc(0.01,decay,1,-4),timeScale:decay,doneAction:2);
	pEnv = EnvGen.ar(Env.perc(0.01,decay/2,1,-8),timeScale:decay);
	sig = SinOscFB.ar(freq*pEnv);
	sig = sig*vEnv;
	Out.ar(out,Pan2.ar(sig,pan));
}).add;

SynthDef.new(\whitehat, {
	|out mfreq=8000,attack=0.01,release=1,amp=1,pan|
	var sig,env;
	env=EnvGen.ar(Env.perc(attack,release,1,-4),timeScale:0.25,doneAction:2);
	sig=WhiteNoise.ar;
	sig=sig*env;
	sig=sig*amp;
	sig=HPF.ar(sig,mfreq);
	Out.ar(out,Pan2.ar(sig,pan));
}).add;

SynthDef.new(\dirt101, { |out, freq, gate=0.5, decay=1,detune, mres=0, mcut=10000, sawvol = 1, puvol = 1, sinvol = 1, detvol = 1, pwidth = 0.5, sustain=1, release=1,pan|
		var sig, vEnv,fEnv, volfunc;
		vEnv = EnvGen.ar(Env.perc(0.01,release,1,-4),timeScale:sustain,doneAction:2);
		//fEnv = XLine.kr(mcut,0.0001,decay,doneAction:2);
		fEnv = EnvGen.ar(Env.perc(0.01,release,1,-4),timeScale:sustain,doneAction:2);
		sig = (((SawDPW.ar(freq) + SawDPW.ar(freq + detune)*detvol)*sawvol) + ((Pulse.ar(freq,pwidth) + Pulse.ar(freq + detune,pwidth)*detvol)*puvol)) * vEnv;
		volfunc = (puvol+sawvol+detvol);
		sig = MoogFF.ar(sig,fEnv*mcut,mres,0)/volfunc;
		Out.ar(out, Pan2.ar(sig,pan,vEnv));
	}).add;

)

(
s.boot;
p = ProxySpace.push(s);
p.makeTempoClock;
Server.default.waitForBoot({
	StageLimiter.activate;
	s.scope;
});
)


p.clock.tempo = 140/60

(
~kick = Pbind(\instrument,\kick,\root,-16,\note,7,\dur,Pbjorklund2(8,8),\amp,8);
~synhat = Pbind(\instrument,\whitehat,\dur,Pbjorklund2(3,8,inf)/2,\amp,Pseq([0.5,1],inf));
~snr=Pbind(\instrument,\kraftsnare,\dur,1,\amp,Pseq([0,1],inf),\decay,0.25);
~syn1 = Pbind(\instrument,\dirt101,\dur,0.25,\sinvol,1,\detune,2,\puvol,1,\sawvol,0,\note,Pseq([12,5,0,7].mirror1,inf)+Pseq([0,-12,12],inf)+7);
)

(
~synhat.play;
~kick.play;
~snr.play;
~syn1.play;
~tank.clear
)

~syn1
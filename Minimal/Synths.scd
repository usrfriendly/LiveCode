(
SynthDef.new(\dirtlog, { |out, freq, gate=0.5, decay=1,detune, mres=0, mcut=10000, sawvol = 1, puvol = 1, sinvol = 1, detvol = 1, pwidth = 0.5, sustain=1, release=1,pan|
	var sig, vEnv,fEnv, volfunc;
	vEnv = EnvGen.ar(Env.perc(0.01,release,1,-4),timeScale:sustain,doneAction:2);
	//fEnv = XLine.kr(mcut,0.0001,decay,doneAction:2);
	fEnv = EnvGen.ar(Env.perc(0.01,release,1,-4),timeScale:sustain,doneAction:2);
	sig = (((SawDPW.ar(freq) + SawDPW.ar(freq + detune)*detvol)*sawvol) + ((Pulse.ar(freq,pwidth) + Pulse.ar(freq + detune,pwidth)*detvol)*puvol) + ((SinOsc.ar(freq) + SinOsc.ar(freq + detune)*detvol)*sinvol)) * vEnv;
	volfunc = (puvol+sawvol+sinvol+detvol);
	sig = MoogFF.ar(sig,fEnv*mcut,mres,0)/volfunc;
	Out.ar(out,Pan2.ar(sig));
}).add;


SynthDef.new(\dirtfm, {
	|out, freq=440, gate=0.5,sustain=1,amp=1,pan=0,release=1,attack=1, mratio=2, mratio2=4|
	var env,sig;
	env=EnvGen.ar(Env.perc(0.01,release,1,-4),1,1,0.01,timeScale:sustain,doneAction:2);
	sig =  SinOsc.ar(freq*SinOsc.ar(freq/mratio));
	sig =  sig*SinOsc.ar(freq*SinOsc.ar(freq/mratio2));
	sig = sig*amp;
	sig = sig*env;
	Out.ar(out,Pan2.ar(sig));
}).add;

SynthDef.new(\kraftsnare, {
	|out, freq, mcut=10000, mres, decay = 0.4, pan, amp = 1,release=1,pwidth=0.5,noisevol=1,puvol=1|
	var sig, nEnv, pEnv, nSig, pSig;
	nEnv = EnvGen.ar(Env.perc(0.01,decay,1,-4),timeScale:decay,doneAction:2);
	pEnv = EnvGen.ar(Env.perc(0.01,decay/2,1,-8),timeScale:decay,doneAction:2);
	nSig = (WhiteNoise.ar*nEnv)*noisevol;
	pSig = PulseDPW.ar(freq*4,pwidth)*pEnv*puvol;
	sig = MoogFF.ar(((nSig+pSig)*amp/2),mcut,mres);
	Out.ar(out,Pan2.ar(sig));
}).add;

SynthDef.new(\kick, {
	|out, freq, mcut=10000, mres, decay = 1, pan, amp = 1,release=0.01,pwidth=0.5,noisevol=1,puvol=1|
	var sig, vEnv, pEnv, nSig, pSig;
	vEnv = EnvGen.ar(Env.perc(0.01,decay,1,-4),timeScale:decay,doneAction:2);
	pEnv = EnvGen.ar(Env.perc(0.01,decay/2,1,-8),timeScale:decay);
	sig = SinOscFB.ar(freq*pEnv);
	sig = sig*vEnv;
	Out.ar(out,Pan2.ar(sig));
}).add;
)

(
s.boot;
p = ProxySpace.push(s);
p.makeTempoClock;
StageLimiter.activate;
)

StageLimiter.deactivate;

p.clear;

p.clock.tempo = 80/120;

Quarks.gui

~sin1 = {SinOsc.kr(p.clock.tempo/8,0,5000,5000)};

p.clock.tempo;

s.scope;

(
~kick=Pbind(\instrument,\kick,\note,0,\dur,0.25,\amp,1);
~d101=Pbind(\instrument,\dirt101,\dur,Pbjorklund2(7,8)/8,\release,100,\sustain,0.01,\root,Pseq([0,4.75,7.25,9].mirror,inf)+[0,0.25],\note,Pseq([0,1,\,3,6].mirror,inf)-[16,-8],\sinvol,0,\scale,Scale.minor,\pwidth,Pseq((1..5)/10,inf),\mcut,~sin1,\mres,3,\amp,0.5);
~snr=Pbind(\instrument,\kraftsnare,\dur,0.25,\amp,Pseq([0,1],inf));
~verb1={FreeVerb.ar(~kick*2+~d101+~snr,0.4)};

~kick.stop;
~d101.stop;
~verb1.play;
~snr.stop;
)


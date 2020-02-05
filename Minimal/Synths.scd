(
SynthDef.new(\dirtlog, { |out, freq, gate=0.5, decay=1,detune, mres=0, mcut=10000, sawvol = 1, puvol = 1, sinvol = 1, detvol = 1, pwidth = 0.5, sustain=1, release=1,pan,amp=1|
	var sig, vEnv,fEnv, volfunc;
	vEnv = EnvGen.ar(Env.perc(0.01,release,1,-4),gate,timeScale:sustain,doneAction:2);
	fEnv = EnvGen.ar(Env.perc(0.01,release,1,-4),timeScale:sustain);
	sig = (((SawDPW.ar(freq) + SawDPW.ar(freq + detune)*detvol)*sawvol) + ((Pulse.ar(freq,pwidth) + Pulse.ar(freq + detune,pwidth)*detvol)*puvol) + ((SinOsc.ar(freq) + SinOsc.ar(freq + detune)*detvol)*sinvol)) * vEnv;
	volfunc = (puvol+sawvol+sinvol+detvol);
	sig = MoogFF.ar(sig,fEnv*mcut,mres,0)/volfunc;
	sig = sig*amp;
	Out.ar(out,Pan2.ar(sig));
}).add;

SynthDef.new(\pwm, {|out, freq, gate=0.5, decay=1, detune=0, pwidth=0.5, sustain=1, release=1, pan=0,amp=1|
	var sig, env;
	env = EnvGen.ar(Env.perc(0.01,release,1,-4),gate,timeScale:sustain,doneAction:2);
	sig = PulseDPW.ar(freq,pwidth);
	sig = sig + PulseDPW.ar(freq-detune,pwidth);
	sig = sig * env;
	sig = sig * amp;
	Out.ar(out,Pan2.ar(sig,pan));
}).add;

SynthDef.new(\saw, {|out, freq, gate=0.5, decay=1, detune=0, sustain=1, release=1, pan=0,amp=1|
	var sig, env;
	env = EnvGen.ar(Env.perc(0.01,release,1,-4),gate,timeScale:sustain,doneAction:2);
	sig = SawDPW.ar(freq);
	sig = sig + SawDPW.ar(freq-detune);
	sig = sig * env;
	sig = sig * amp;
	Out.ar(out,Pan2.ar(sig,pan));
}).add;

SynthDef.new(\dirtfm, {
	|out, freq=440, gate=0.5,sustain=1,amp=1,pan=0,release=1,attack=1, mratio=2, mratio2=4|
	var env,sig;
	env=EnvGen.ar(Env.perc(0.01,release,1,-4),timeScale:gate,doneAction:2);
	sig =  SinOsc.ar(freq*SinOsc.ar(freq/mratio));
	sig = sig*amp;
	sig = sig*env;
	Out.ar(out,Pan2.ar(sig,pan));
}).add;

SynthDef.new(\kraftsnare, {
	|out, freq, mcut=10000, mres, decay = 0.4, pan, amp = 1,release=1,pwidth=0.5,noisevol=1,puvol=1|
	var sig, nEnv, pEnv, nSig, pSig;
	nEnv = EnvGen.ar(Env.perc(0.01,decay,1,-4),timeScale:decay,doneAction:2);
	pEnv = EnvGen.ar(Env.perc(0.01,decay/2,1,-8),timeScale:decay);
	nSig = (WhiteNoise.ar*nEnv)*noisevol;
	pSig = PulseDPW.ar(freq*4,pwidth)*pEnv*puvol;
	sig = MoogFF.ar(((nSig+pSig)*amp),mcut,mres);
	Out.ar(out,Pan2.ar(sig));
}).add;

SynthDef.new(\whitehat, {
	|out, freq, mcut=8000, mres, decay = 0.4, pan, amp = 1,release=1|
	var sig,env,fEnv;
	env = EnvGen.ar(Env.perc(0.01,decay,1,-4),timeScale:decay,doneAction:2);
	fEnv = EnvGen.ar(Env.perc(0.01,decay,1,-4),timeScale:decay);
	sig = (WhiteNoise.ar*env);
	sig = BPF.ar(sig,freq=mcut)*amp;
	Out.ar(out,Pan2.ar(sig,pan));
}).add;

SynthDef.new(\kick, {
	|out, freq, mcut=10000, mres, decay = 1, pan, amp = 1,release=0.01,pwidth=0.5,noisevol=1,puvol=1|
	var sig, vEnv, pEnv, nSig, pSig;
	vEnv = EnvGen.ar(Env.perc(0.01,decay,1,-4),timeScale:decay,doneAction:2);
	pEnv = EnvGen.ar(Env.perc(0.01,decay/2,1,-8),timeScale:decay);
	sig = SinOscFB.ar(freq*pEnv);
	sig = sig*vEnv;
	sig = sig*amp;
	Out.ar(out,Pan2.ar(sig));
}).add;
)

(
s.boot;
p = ProxySpace.push(s);
p.makeTempoClock;
s.waitForBoot {
	StageLimiter.activate;
	s.scope;
}
)

StageLimiter.deactivate;

p.clear;




Quarks.gui


p.clock.tempo;

s.scope;

//lfos
//func field
//fx field
//play field
(
)

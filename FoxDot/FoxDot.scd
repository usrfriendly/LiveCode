Quarks.install("https://github.com/Qirky/FoxDotQuark.git")

include("BatLib")

(
SynthDef.new(\sawDetune,
	{
		arg amp = 1, freq = 110, atk = 0.01, dec = 0.5, pan = 0, out = 0, detune = 1;
		var env, sig;
		env = Env.perc(atk,dec,1).kr(doneAction: 2);
		sig = Saw.ar(freq) + Saw.ar(freq + detune);
		sig = sig * env;
		sig = sig * amp;
		Out.ar(out,Pan2.ar(sig,pan));
	}).add;


SynthDef.new(\sawMoog, {
	|out = 0, pan = 0, amp = 1, dec = 0.3, freq = 440,cut=1000,mgain=1|
	var sig;
	sig = MoogFF.ar([Saw.ar(freq) + (WhiteNoise.ar*0.01)],XLine.kr(cut,0.01,dec),mgain);
	sig = sig*XLine.kr(1,0.01,dec,doneAction: 2);
	sig = sig*amp;
	Out.ar(out,Pan2.ar(sig,SinOsc.kr(0.1).range([[1,0],[1,0]])));
}).add;

)

FoxDot.start;

s.scope;

Quarks.gui

//Porting to FoxDot

(
SynthDef.new(\dirtlog, { |out, freq, gate=0.5, decay=1,detune, mres=0, mcut=10000, sawvol = 1, puvol = 1, sinvol = 1, detvol = 1, pwidth = 0.5, attack=0.01, sustain=1, release=1,pan,bus=0,amp=1,dur=1|
	var osc, sig, vEnv,fEnv, volfunc;
	vEnv = EnvGen.ar(Env.adsr(attack,decay,sustain,release),timeScale:dur,doneAction:0);
	//fEnv = XLine.kr(mcut,0.0001,decay,doneAction:2);
	fEnv = EnvGen.ar(Env.perc(0.01,release,1,-4),timeScale:dur,doneAction:0);
	sig = (((SawDPW.ar(freq) + SawDPW.ar(freq + detune)*detvol)*sawvol) + ((Pulse.ar(freq,pwidth) + Pulse.ar(freq + detune,pwidth)*detvol)*puvol) + ((SinOsc.ar(freq) + SinOsc.ar(freq + detune)*detvol)*sinvol));
	sig=sig*vEnv;
	volfunc = puvol+sawvol+sinvol+detvol;
	sig=sig/10;
	sig = MoogFF.ar(sig,fEnv*mcut,mres,0);
	sig=sig*amp;
	osc = Pan2.ar(sig,pan,vEnv);
	ReplaceOut.ar(bus, osc)}).add;

SynthDef.new(\dirt101, { |out, freq, gate=0.5, decay=1,detune, mres=0, mcut=10000, sawvol = 1, puvol = 1, sinvol = 1, detvol = 1, pwidth = 0.5, attack=0.01,sustain=1, release=1,pan,bus=0,amp=1|
	var sig, vEnv,fEnv, volfunc, osc;
	vEnv = EnvGen.ar(Env.adsr(attack,decay,sustain,release),timeScale:sustain,doneAction:0);
	//fEnv = XLine.kr(mcut,0.0001,decay,doneAction:2);
	fEnv = EnvGen.ar(Env.perc(0.01,release,1,-4),timeScale:sustain,doneAction:0);
	sig = (((SawDPW.ar(freq) + SawDPW.ar(freq + detune)*detvol)*sawvol) + ((Pulse.ar(freq,pwidth) + Pulse.ar(freq + detune,pwidth)*detvol)*puvol)) * vEnv;
	volfunc = (puvol+sawvol+detvol);
	sig = MoogFF.ar(sig,fEnv*mcut,mres,0)/volfunc;
	sig=sig/volfunc;
	sig=sig*amp;
	osc = Pan2.ar(sig,pan,vEnv);
	ReplaceOut.ar(bus,osc);
	}).add;
)
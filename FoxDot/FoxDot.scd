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

FoxDot.start

Quarks.gui
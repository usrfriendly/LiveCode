Quarks.install("SuperDirt");

SuperDirt.start;

Quarks.install("BatLib");


(
var server = server ? Server.default;
server.options.memSize = 8192 * 16;
server.scope;
server.waitForBoot {
	//SuperDirt.loadSoundFile("E:/arinc/Documents/LiveCode/Tidal/Drums/*",appendToExisting:true);
	SuperDirt.postBadValues = false;
	SuperDirt.start(numOrbits:8, path:"E:/arinc/Documents/LiveCode/Tidal/Drums/*",);
(
SynthDef.new(\dirtlog, { |out, freq, gate=0.5, decay=1,detune, mres=0, mcut=10000, sawvol = 1, puvol = 1, sinvol = 1, detvol = 1, pwidth = 0.5, sustain=1, release=1,pan|
	var sig, vEnv,fEnv, volfunc;
	vEnv = EnvGen.ar(Env.perc(0.01,release,1,-4),timeScale:sustain,doneAction:2);
	//fEnv = XLine.kr(mcut,0.0001,decay,doneAction:2);
	fEnv = EnvGen.ar(Env.perc(0.01,release,1,-4),timeScale:sustain,doneAction:2);
	sig = (((SawDPW.ar(freq) + SawDPW.ar(freq + detune)*detvol)*sawvol) + ((Pulse.ar(freq,pwidth) + Pulse.ar(freq + detune,pwidth)*detvol)*puvol) + ((SinOsc.ar(freq) + SinOsc.ar(freq + detune)*detvol)*sinvol)) * vEnv;
	volfunc = (puvol+sawvol+sinvol+detvol);
	sig = MoogFF.ar(sig,fEnv*mcut,mres,0)/volfunc;
	OffsetOut.ar(out, DirtPan.ar(sig, ~dirt.numChannels,pan,vEnv));
}).add;

		SynthDef.new(\dirt101, { |out, freq, gate=0.5, decay=1,detune, mres=0, mcut=10000, sawvol = 1, puvol = 1, sinvol = 1, detvol = 1, pwidth = 0.5, sustain=1, release=1,pan|
	var sig, vEnv,fEnv, volfunc;
	vEnv = EnvGen.ar(Env.perc(0.01,release,1,-4),timeScale:sustain,doneAction:2);
	//fEnv = XLine.kr(mcut,0.0001,decay,doneAction:2);
	fEnv = EnvGen.ar(Env.perc(0.01,release,1,-4),timeScale:sustain,doneAction:2);
	sig = (((SawDPW.ar(freq) + SawDPW.ar(freq + detune)*detvol)*sawvol) + ((Pulse.ar(freq,pwidth) + Pulse.ar(freq + detune,pwidth)*detvol)*puvol)) * vEnv;
	volfunc = (puvol+sawvol+detvol);
	sig = MoogFF.ar(sig,fEnv*mcut,mres,0)/volfunc;
	OffsetOut.ar(out, DirtPan.ar(sig, ~dirt.numChannels,pan,vEnv));
}).add;


SynthDef.new(\dirtfm, {
	|out, freq=440, gate=0.5,sustain=1,gain=1,pan=0,release=1,attack=1, mratio=2, mratio2=4|
	var env,sig;
	env=EnvGen.ar(Env.perc(0.01,release,1,-4),timeScale:sustain,doneAction:2);
	sig =  SinOsc.ar(freq*SinOsc.ar(freq/mratio));
	OffsetOut.ar(sig,DirtPan.ar(sig,~dirt.numChannels,pan,env));
}).add;

SynthDef.new(\kraftsnare, {
	|out, freq, mcut, mres, decay = 0.4, pan, gain = 1,release=1,pwidth=0.5,noisevol=1,puvol=1|
	var sig, nEnv, pEnv, nSig, pSig;
	nEnv = EnvGen.ar(Env.perc(0.01,decay,1,-8),timeScale:decay,doneAction:2);
	pEnv = EnvGen.ar(Env.perc(0.01,decay/2,1,-8),timeScale:decay,doneAction:2);
	nSig = (WhiteNoise.ar*nEnv)*noisevol;
	pSig = PulseDPW.ar(freq*4,pwidth)*pEnv*puvol;
	sig = MoogFF.ar(((nSig+pSig)*gain/2),mcut,mres);
	OffsetOut.ar(out,DirtPan.ar(sig, ~dirt.numChannels,pan,1));
}).add;

)

}
)


Quarks.gui

//Couple of synths, one is a weird FM thing that needs work, one is a virtual analog.

(
SynthDef.new(\dirtlog, { |out, freq, gate=0.5, decay=1,detune, mres=0, mcut=10000, sawvol = 1, puvol = 1, sinvol = 1, detvol = 1, pwidth = 0.5, sustain=1, release=1,pan|
	var sig, vEnv,fEnv, volfunc;
	vEnv = EnvGen.ar(Env.perc(0.01,release,1,-4),timeScale:sustain,doneAction:2);
	//fEnv = XLine.kr(mcut,0.0001,decay,doneAction:2);
	fEnv = EnvGen.ar(Env.perc(0.01,release,1,-4),timeScale:sustain,doneAction:2);
	sig = (((SawDPW.ar(freq) + SawDPW.ar(freq + detune)*detvol)*sawvol) + ((Pulse.ar(freq,pwidth) + Pulse.ar(freq + detune,pwidth)*detvol)*puvol) + ((SinOsc.ar(freq) + SinOsc.ar(freq + detune)*detvol)*sinvol)) * vEnv;
	volfunc = (puvol+sawvol+sinvol+detvol);
	sig = MoogFF.ar(sig,fEnv*mcut,mres,0)/volfunc;
	OffsetOut.ar(out, DirtPan.ar(sig, ~dirt.numChannels,pan,vEnv));
}).add;


SynthDef.new(\dirtfm, {
	|out, freq=440, gate=0.5,sustain=1,gain=1,pan=0,release=1,attack=1, mratio=2, mratio2=4|
	var env,sig;
	env=EnvGen.ar(Env.perc(0.01,release,1,-4),timeScale:sustain,doneAction:2);
	sig =  SinOsc.ar(freq*SinOsc.ar(freq/mratio));
	OffsetOut.ar(sig,DirtPan.ar(sig,~dirt.numChannels,pan,env));
}).add;

)

(
SynthDef.new(\kraftsnare, {
	|out, freq, mcut, mres, decay = 0.4, pan, gain = 1,release=1,pwidth=0.5,noisevol=1,puvol=1|
	var sig, nEnv, pEnv, nSig, pSig;
	nEnv = EnvGen.ar(Env.perc(0.01,decay,1,-8),timeScale:decay,doneAction:2);
	pEnv = EnvGen.ar(Env.perc(0.01,decay/2,1,-8),timeScale:decay,doneAction:2);
	nSig = (WhiteNoise.ar*nEnv)*noisevol;
	pSig = PulseDPW.ar(freq*4,pwidth)*pEnv*puvol;
	sig = MoogFF.ar(((nSig+pSig)*gain/2),mcut,mres);
	OffsetOut.ar(sig,DirtPan.ar(sig, ~dirt.numChannels,pan,1));
}).add;
)
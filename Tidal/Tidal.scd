Quarks.install("SuperDirt");

SuperDirt.start;

Quarks.install("BatLib");

StageLimiter.activate;

Quarks.checkForUpdates({Quarks.install("SuperDirt", "v1.7.2"); thisProcess.recompile()})

Quarks.gui;

(
var server = server ? Server.default;
server.options.memSize = 8192 * 16;
server.scope;
server.waitForBoot {
	//SuperDirt.loadSoundFile("E:/arinc/Documents/LiveCode/Tidal/Drums/*",appendToExisting:true);

	SuperDirt.postBadValues = false;
	SuperDirt.start(path:"E:/arinc/Documents/LiveCode/Drums/*");

	SynthDef.new(\dirtlog, { |out, freq, gate=0.5, decay=1,detune, mres=0, mcut=10000, sawvol = 1, puvol = 1, sinvol = 1, detvol = 1, pwidth = 0.5, sustain=1, release=1,pan,detuneCents|
		var sig, vEnv,fEnv, volfunc;
		detuneCents = (freq/100)*detune;
		vEnv = EnvGen.ar(Env.perc(0.01,release,1,-4),timeScale:sustain,doneAction:2);
		//fEnv = XLine.kr(mcut,0.0001,decay,doneAction:2);
		fEnv = EnvGen.ar(Env.perc(0.01,release,1,-4),timeScale:sustain,doneAction:2);
		sig = (((SawDPW.ar(freq) + SawDPW.ar(freq + detuneCents)*detvol)*sawvol) + ((Pulse.ar(freq,pwidth) + Pulse.ar(freq + detuneCents,pwidth)*detvol)*puvol) + ((SinOsc.ar(freq) + SinOsc.ar(freq + detuneCents)*detvol)*sinvol)) * vEnv;
		volfunc = (puvol+sawvol+sinvol+detvol);
		sig = MoogFF.ar(sig,fEnv*mcut,mres,0)/volfunc;
		OffsetOut.ar(out, DirtPan.ar(sig, ~dirt.numChannels,pan,vEnv));
	}).add;

	SynthDef.new(\dirt101, { |out, freq, gate=0.5, decay=1,detune, mres=0, mcut=10000, sawvol = 1, puvol = 1, sinvol = 1, detvol = 1, pwidth = 0.5, sustain=1, release=1,pan|
		var sig, vEnv,fEnv, volfunc, detuneCents;
		detuneCents = (freq/100)*detune;
		vEnv = EnvGen.ar(Env.perc(0.01,release,1,-4),timeScale:sustain,doneAction:2);
		//fEnv = XLine.kr(mcut,0.0001,decay,doneAction:2);
		fEnv = EnvGen.ar(Env.perc(0.01,release,1,-4),timeScale:sustain,doneAction:2);
		sig = (((SawDPW.ar(freq) + SawDPW.ar(freq + detuneCents)*detvol)*sawvol) + ((Pulse.ar(freq,pwidth) + Pulse.ar(freq + detune,pwidth)*detvol)*puvol)) * vEnv;
		volfunc = (puvol+sawvol+detvol);
		sig = MoogFF.ar(sig,fEnv*mcut,mres,0)/volfunc;
		OffsetOut.ar(out, DirtPan.ar(sig, ~dirt.numChannels,pan,vEnv));
	}).add;


	SynthDef.new(\dirtfm, {
		|out, freq=440, gate=0.5,sustain=1,gain=1,pan=0,release=1,attack=1, mratio=2, mratio2=4|
		var env,sig;
		env=EnvGen.ar(Env.perc(0.01,release,1,-4),1,1,0.01,timeScale:sustain,doneAction:2);
		sig =  SinOsc.ar(freq*SinOsc.ar(freq/mratio));
		sig =  sig*SinOsc.ar(freq*SinOsc.ar(freq/mratio2));
		sig = sig*gain;
		sig = sig*env;
		OffsetOut.ar(out,DirtPan.ar(sig,~dirt.numChannels,pan,env));
	}).add;

	SynthDef.new(\kraftsnare, {
		|out, freq, mcut = 10000, mres, decay = 0.4, pan, gain = 1,release=1,pwidth=0.5,noisevol=1,puvol=1|
		var sig, nEnv, pEnv, nSig, pSig;
		nEnv = EnvGen.ar(Env.perc(0.01,decay,1,-8),timeScale:decay,doneAction:2);
		pEnv = EnvGen.ar(Env.perc(0.01,decay/2,1,-8),timeScale:decay,doneAction:2);
		nSig = (WhiteNoise.ar*nEnv)*noisevol;
		pSig = PulseDPW.ar(freq*4,pwidth)*pEnv*puvol;
		sig = MoogFF.ar(((nSig+pSig)*gain/2),mcut,mres);
		OffsetOut.ar(out,DirtPan.ar(sig, ~dirt.numChannels,pan,1));
	}).add;

	SynthDef.new(\sinkick, {
		|out, freq, mcut=10000, mres, decay = 1, pan, amp = 1,release=0.01,pwidth=0.5,noisevol=1,puvol=1|
		var sig, vEnv, pEnv, nSig, pSig;
		vEnv = EnvGen.ar(Env.perc(0.01,decay,1,-4),timeScale:decay,doneAction:2);
		pEnv = EnvGen.ar(Env.perc(0.01,decay/2,1,-8),timeScale:decay);
		sig = SinOscFB.ar(freq*pEnv);
		sig = sig*vEnv;
		OffsetOut.ar(out,DirtPan.ar(sig,~dirt.numChannels,pan,1));
	}).add;

	SynthDef.new(\whitehat, {
		|out mfreq=8000,attack=0.01,release=1,decay=1,amp=1,pan|
		var sig,env;
		env=EnvGen.ar(Env.perc(attack,release,1,-4),timeScale:decay,doneAction:2);
		sig=WhiteNoise.ar;
		sig=sig*env;
		sig=sig*amp;
		sig=HPF.ar(sig,mfreq);
		OffsetOut.ar(out,DirtPan.ar(sig,~dirt.numChannels,pan,1));
	}).add;

})


S

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
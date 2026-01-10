Quarks.install("SuperDirt");

SuperDirt.start;

Quarks.install("BatLib");

StageLimiter.activate;

//Quarks.checkForUpdates({Quarks.install("SuperDirt", "v1.7.2"); thisProcess.recompile()})

Quarks.gui;

Server.killAll;

(
var s = s ? Server.default;
s.options.memSize = 8192 * 16;
s.scope;
s.reboot { // server options are only updated on reboot
	// configure the sound server: here you could add hardware specific options
	// see http://doc.sccode.org/Classes/ServerOptions.html
	s.options.numBuffers = 1024 * 256; // increase this if you need to load more samples
	s.options.memSize = 8192 * 32; // increase this if you get "alloc failed" messages
	s.options.numWireBufs = 64; // increase this if you get "exceeded number of interconnect buffers" messages
	s.options.maxNodes = 1024 * 32; // increase this if you are getting drop outs and the message "too many nodes"
	s.options.numOutputBusChannels = 2; // set this to your hardware output channel size, if necessary
	s.options.numInputBusChannels = 2; // set this to your hardware output channel size, if necessary
	// boot the server and start SuperDirt
	s.waitForBoot {
		~dirt.stop; // stop any old ones, avoid duplicate dirt (if it is nil, this won't do anything)
		~dirt = SuperDirt(2, s); // two output channels, increase if you want to pan across more channels
		~dirt.loadSoundFiles;   // load samples (path containing a wildcard can be passed in)
		~dirt.loadSoundFiles("/home/arin/Documents/LiveCode/Drums/*");
		// for example: ~dirt.loadSoundFiles("/Users/myUserName/Dirt/samples/*");
		// s.sync; // optionally: wait for samples to be read
		~dirt.start(57120, 0 ! 12);   // start listening on port 57120, create two busses each sending audio to channel 0

		// optional, needed for convenient access from sclang:
		(
			~d1 = ~dirt.orbits[0]; ~d2 = ~dirt.orbits[1]; ~d3 = ~dirt.orbits[2];
			~d4 = ~dirt.orbits[3]; ~d5 = ~dirt.orbits[4]; ~d6 = ~dirt.orbits[5];
			~d7 = ~dirt.orbits[6]; ~d8 = ~dirt.orbits[7]; ~d9 = ~dirt.orbits[8];
			~d10 = ~dirt.orbits[9]; ~d11 = ~dirt.orbits[10]; ~d12 = ~dirt.orbits[11];
		);
	};

	s.latency = 0.3; // increase this if you get "late" messages


	SynthDef.new(\dirtlog, { |out, freq=440, gate=0.5, decay=1,detune, mres=0, mcut=10000, sawvol = 1, puvol = 1, sinvol = 1, detvol = 1, pwidth = 0.5, attack=0.01, sustain=1, release=1,pan,detuneCents|
		var sig, vEnv,fEnv, volfunc;
		detuneCents = (freq/100)*detune;
		vEnv = EnvGen.ar(Env.perc(attack,release,1,-4),timeScale:sustain,doneAction:2);
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
		|out, freq=440, gate=0.5,sustain=1,gain=1,pan=0,release=1,attack=1, mratio1=2, mratio2=4|
		var env,sig;
		env=EnvGen.ar(Env.perc(0.01,release,1,-4),1,1,0.01,timeScale:sustain,doneAction:2);
		sig =  SinOsc.ar(freq*SinOsc.ar(freq/mratio1));
		sig =  sig*SinOsc.ar(freq*SinOsc.ar(freq/mratio2));
		sig = sig*gain;
		sig = sig*env;
		OffsetOut.ar(out,DirtPan.ar(sig,~dirt.numChannels,pan,env));
	}).add;

	SynthDef.new(\kraftsnare, {
		|out, freq=220, mcut = 10000, mres, decay = 0.4, pan, gain = 1,release=1,pwidth=0.5,noisevol=1,puvol=1|
		var sig, nEnv, pEnv, nSig, pSig;
		nEnv = EnvGen.ar(Env.perc(0.01,decay,1,-8),timeScale:decay,doneAction:2);
		pEnv = EnvGen.ar(Env.perc(0.01,decay/2,1,-8),timeScale:decay,doneAction:2);
		nSig = (WhiteNoise.ar*nEnv)*noisevol;
		pSig = PulseDPW.ar(freq,pwidth)*pEnv*puvol;
		sig = MoogFF.ar(((nSig+pSig)*gain/2),mcut,mres);
		OffsetOut.ar(out,DirtPan.ar(sig, ~dirt.numChannels,pan,1));
	}).add;

	SynthDef.new(\sinkick, {
		|out, freq=440, mcut=10000, mres, decay = 1, pan, amp = 1,sustain=1,release=1,pwidth=0.5,noisevol=1,puvol=1|
		var sig, vEnv, pEnv, nSig, pSig;
		vEnv = EnvGen.ar(Env.perc(0.01,decay,1,-4),timeScale:sustain,doneAction:2);
		pEnv = EnvGen.ar(Env.perc(0.01,decay/2,1,-8),timeScale:sustain);
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

	~dirt.start(57120, 0 ! 12); // start superdirt, listening on port 57120, create two orbits each sending audio to channel 0
	StageLimiter.activate;

})
(
	SynthDef.new(\dirtfm2, {
	|out, freq=440, gate=0.5,sustain=1,gain=1,pan=0,release=1,attack=1, mratio1=2, mratio2=4, mratio3=8, mratio4=(1/16),accelerate,speed|
		var env,sig,osc1,osc2,osc3,osc4,basefreq;
		env=EnvGen.ar(Env.perc(0.01,release,1,-4),1,1,0.01,timeScale:sustain,doneAction:2);
		basefreq = freq*DirtFreqScale.kr(speed, accelerate, sustain);
		osc4 =  SinOsc.ar(basefreq,SinOsc.ar(basefreq/mratio4));
		osc3 =  osc4*SinOsc.ar(basefreq,SinOsc.ar(basefreq/mratio3));
   	        osc2 =  osc3*SinOsc.ar(basefreq,SinOsc.ar(basefreq/mratio2));
	        osc1 =  osc2*SinOsc.ar(basefreq,SinOsc.ar(basefreq/mratio1));
		sig = osc1*gain;
		sig = sig*env;
		OffsetOut.ar(out,DirtPan.ar(sig,~dirt.numChannels,pan,env));
	}).add;
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

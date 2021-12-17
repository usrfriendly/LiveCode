(
/*

lplay - a looping player for stereo samples that uses the dur value to automatically pitch samples for looping over a given number of beats. I built this to grab a bunch of drum loops and percussion loops at roughly the correct tempo and use them at the clock rate of my set.

out = channel out
buf = buffer index
amp = volume
pan = stereo panning
rel = release (mostly here to prevent runaway PlayBufs)
dur = duration, in beats, that you would like your sample scaled to. For example a sample played over 8 beats would have a dur of 8 specified. Note that this repitches the sample in order to scale it to the correct beat, so it could end up at a _very_ different pitch

*/
SynthDef(\lplay,
	{arg out = 0, buf = 0, amp = 0.5, pan = 0, rel=15, dur = 8;
		var sig,env ;
		sig = Mix.ar(PlayBuf.ar(2,buf,BufRateScale.ir(buf) * ((BufFrames.ir(buf)/s.sampleRate)*p.clock.tempo/dur),1,0,doneAction:2));
		env = EnvGen.ar(Env.linen(0.0,rel,0),doneAction:2);
		sig = sig * env;
		sig = sig * amp;
		Out.ar(out,Pan2.ar(sig,pan));
}).add;
)
//code from Ryan Kirkbride, https://www.youtube.com/watch?v=WLV4Rx6YhSY
//hoping to finally understand how to use TempoClocks
(
Quarks.install("https://github.com/jamshark70/ddwSnippets.git");
)

//Quarks.gui;

(
var tempo = 120;
t = TempoClock.new((140/60),4);
t.schedAbs(t.nextBar, {t.beatsPerBar_(4)});
p=ProxySpace.push(s.boot, clock: t);
Server.default.waitForBoot({
	3.wait;
	d = Dictionary.new;
	d.add(\foldernames -> PathName(thisProcess.nowExecutingPath.dirname +/+ "../Drums").entries);
	for (0, d[\foldernames].size-1,
		{arg i; d.add(d[\foldernames][i].folderName -> d[\foldernames][i].entries.collect({
			arg sf;
			Buffer.read(s,sf.fullPath);
		});
	)});
	StageLimiter.activate;
	s.scope;
	//DDWSnippets.enable;
	("SynthDefs.scd").loadRelative;
	("Samplers.scd").loadRelative;
	//("Snippets.scd").loadRelative;
});
)

//The samplers only respond to updates after tempo shifts
(
t.tempo=(80/60);
("./Samplers.scd").loadRelative;
)
t.clear;
(
t.schedAbs( t.nextBar,
	{
		~s1[0]=Pbind(\instrument,\dirt101,
			\dur,0.5,
			\scale,Scale.minor,
			\degree,Pseq([0,3,5],inf)+Pseq([0,1,2,3],inf),
			\puvol,1,
			\sawvol,1,
			\mcut,10000
		);
		~s1[1]=\filterIn -> {|in| FreeVerb.ar(in,0.3,0.6,0.6)};
		~s1.play;
	}
)
)

~s1.clear;
(
t.schedAbs( t.nextBar,
	{
		~k1[0]=Pbind(\instrument,\kick,
			\dur,Pbjorklund2(7,12)/2,
			\amp,4
		);
		~k1[1]=\filterIn -> {|in| FreeVerb.ar(in,0.3,0.1,2)};
		~k1.play;
	}
)
)
~k1.stop;
(
t.schedAbs( t.nextBar
	{
		~sn1=Pbind(
			\instrument,\snare,
			\dur,1/8,
			\amp,1
		);
		~sn1.play;
	}
)
)
s.scope;
(
t.schedAbs( t.nextBar,
	{
		~synth[0]=Pbind(\instrument,\dirt101,
			\dur,1/4,
			\scale,Scale.whole,
			\degree,Pseq([0,12,1,11,2,10,3,9,4,8,5,7,6].mirror2,inf),
			\puvol,1,
			\sawvol,0,
			\mcut,10000,
			\mres,0
			);
		~synth.play;
	}
)
)

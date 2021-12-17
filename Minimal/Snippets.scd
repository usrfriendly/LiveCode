(
DDWSnippets.put("dirt101",
	"(
t.schedAbs( t.nextBar,
	{
		~s1[0]=Pbind(\\instrument,\\dirt101,
			\\dur,1,
			\\note,0,
			\\puvol,1,
			\\sawvol,1);
		~s1.play;
	}
))");

DDWSnippets.put("kick",
	"(
t.schedAbs( t.nextBar,
	{
		~s1[0]=Pbind(\\instrument,\\dirt101,
			\\dur,1,
			\\note,0,
            \\amp,1,
			\\puvol,1,
			\\sawvol,1);
		~s1.play;
	}
))");

DDWSnippets.put("bjork",
"Pbjorklund2(8,8)");

)
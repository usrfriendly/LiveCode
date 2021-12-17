Clock.clear()
dirtlog = SynthDef("dirtlog")
dirt101 = SynthDef("dirt101")
Scale.default="minor"


s1 >> dirtlog(P[0,7,12,7,12]+P(0,5),dur=1/PFibMod()[2:5],mcut=sinvar([5000,10000],12),mix=(0,1),room=1,size=1).every(8,"mirror")
s2 >> dirt101(P[0,7,12],oct=[2,3],dur=PFibMod()[2:7]/8,release=1/4,amp=2,mcut=10000)
p1 >> play("X-",amp=2,sample=[1,0])

print(s1)

print(dirt101)

s1.stop()
p1.stop()

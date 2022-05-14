:set -XOverloadedStrings
:set prompt ""

import Sound.Tidal.Context

import System.IO (hSetEncoding, stdout, utf8)
hSetEncoding stdout utf8

-- total latency = oLatency + cFrameTimespan
tidal <- startTidal (superdirtTarget {oLatency = 0.5, oAddress = "127.0.0.1", oPort = 57120}) (defaultConfig {cVerbose = True, cFrameTimespan = 1/20})

:{
let only = (hush >>)
    p = streamReplace tidal
    hush = streamHush tidal
    panic = do hush
               once $ sound "superpanic"
    list = streamList tidal
    mute = streamMute tidal
    unmute = streamUnmute tidal
    unmuteAll = streamUnmuteAll tidal
    unsoloAll = streamUnsoloAll tidal
    solo = streamSolo tidal
    unsolo = streamUnsolo tidal
    once = streamOnce tidal
    first = streamFirst tidal
    asap = once
    nudgeAll = streamNudgeAll tidal
    all = streamAll tidal
    resetCycles = streamResetCycles tidal
    setcps = asap . cps
    getcps = streamGetcps tidal
    getnow = streamGetnow tidal
    xfade i = transition tidal True (Sound.Tidal.Transition.xfadeIn 4) i
    xfadeIn i t = transition tidal True (Sound.Tidal.Transition.xfadeIn t) i
    histpan i t = transition tidal True (Sound.Tidal.Transition.histpan t) i
    wait i t = transition tidal True (Sound.Tidal.Transition.wait t) i
    waitT i f t = transition tidal True (Sound.Tidal.Transition.waitT f t) i
    jump i = transition tidal True (Sound.Tidal.Transition.jump) i
    jumpIn i t = transition tidal True (Sound.Tidal.Transition.jumpIn t) i
    jumpIn' i t = transition tidal True (Sound.Tidal.Transition.jumpIn' t) i
    jumpMod i t = transition tidal True (Sound.Tidal.Transition.jumpMod t) i
    mortal i lifespan release = transition tidal True (Sound.Tidal.Transition.mortal lifespan release) i
    interpolate i = transition tidal True (Sound.Tidal.Transition.interpolate) i
    interpolateIn i t = transition tidal True (Sound.Tidal.Transition.interpolateIn t) i
    clutch i = transition tidal True (Sound.Tidal.Transition.clutch) i
    clutchIn i t = transition tidal True (Sound.Tidal.Transition.clutchIn t) i
    anticipate i = transition tidal True (Sound.Tidal.Transition.anticipate) i
    anticipateIn i t = transition tidal True (Sound.Tidal.Transition.anticipateIn t) i
    forId i t = transition tidal False (Sound.Tidal.Transition.mortalOverlay t) i
    d1 = p 1 . (|< orbit 0)
    d2 = p 2 . (|< orbit 1)
    d3 = p 3 . (|< orbit 2)
    d4 = p 4 . (|< orbit 3)
    d5 = p 5 . (|< orbit 4)
    d6 = p 6 . (|< orbit 5)
    d7 = p 7 . (|< orbit 6)
    d8 = p 8 . (|< orbit 7)
    d9 = p 9 . (|< orbit 8)
    d10 = p 10 . (|< orbit 9)
    d11 = p 11 . (|< orbit 10)
    d12 = p 12 . (|< orbit 11)
    d13 = p 13
    d14 = p 14
    d15 = p 15
    d16 = p 16
:}

:{
let getState = streamGet tidal
    setI = streamSetI tidal
    setF = streamSetF tidal
    setS = streamSetS tidal
    setR = streamSetR tidal
    setB = streamSetB tidal
:}

:{
let mcut = pF "mcut"
    mres = pF "mres"
    sawvol = pF "sawvol"
    puvol = pF "puvol"
    pwidth = pF "pwidth"
    sinvol = pF "sinvol"
    detvol = pF "detvol"
    mratio = pF "mratio"
    noisevol = pF "noisevol"
:}

:{    
just2semi j = 12 * (log j) / (log 2)
newscales = [
      ("justionian",     map just2semi [1,   9/8,   5/4,   4/3,   3/2,   5/3, 15/8]),
      ("justdorian",     map just2semi [1,   9/8,   6/5,   4/3,   3/2,   5/3, 16/9]),
      ("justphrygian",   map just2semi [1, 16/15,   6/5,   4/3,   3/2,   8/5, 16/9]),
      ("justlydian",     map just2semi [1,   9/8,   5/4, 45/32,   3/2,   5/3, 15/8]),
      ("justmixolydian", map just2semi [1,   9/8,   5/4,   4/3,   3/2,   5/3, 16/9]),
      ("justaeolian",    map just2semi [1,   9/8,   6/5,   4/3,   3/2,   8/5, 16/9]),
      ("justlocrian",    map just2semi [1, 16/15,   6/5,   4/3,   45/32, 8/5, 16/9]),
      ("edo5",          map just2semi [1, 8/7, 21/16, 3/2, 12/7]),
      ("edo6",           map just2semi [1,   8/7,   5/4,    7/5,  8/5,   9/5]),
      ("edo11",          map just2semi [1, 15/14, 8/7, 6/5, 9/7, 11/8, 16/11, 14/9, 5/3, 7/4, 15/8])
    ]
scale = getScale (scaleTable ++ newscales)
:}

:set prompt "tidal> "
:set prompt-cont ""

default (Pattern String, Integer, Double)

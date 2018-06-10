// SEAGULL sound 1 (semi def.)
(
s.boot;
s.meter;
s.plotTree;
s.freeAll;
)

// here we are creating an amplitude envelope.
(
~gull_levels_1 = Env.new([0.001, 1, 0.5, 1, 0.001], [0.035, 0.025,0.040, 0.060],\sine);
~gull_levels_1.plot;

// ...and defining the seagull synth
SynthDef.new(\seagull_A, {
	|levelscale=1, timescale=1|
	var sig, env, amp = 0.07;
	var out = 16;
	var pos= 0;
	var freqA = 1500;
	var freqB = freqA-300;
	sig = SinOsc.ar(Line.kr( freqA*(1..3), freqB*(1..3), 0.160*timescale) );
	env = EnvGen.kr(~gull_levels_1, levelScale:levelscales, timeScale:timescale, doneAction:2);
	sig = sig * env * amp;
	Out.ar(out, Pan2.ar(Splay.ar(sig, 0), pos));
}).add;
)

// create a verb
(
SynthDef.new(\verb, {
	arg mix=0.4, room=0.5, damp=0.2;
	var sig;
	var in = 16;
	sig = In.ar(in, 2);
	sig = FreeVerb2.ar(sig[0], sig[1],mix:mix, room:room, damp:damp);
	Out.ar(0, sig);
}).add;
)

v = Synth.new(\verb);    // place the verb in the node tree
g = Synth.new(\seagull_A); // test the seagull sound
g.free;
v.free;

// test the seagull sound in a pattern!
(
p = Pbind.new(
	\instrument, \seagull_A,
	\ls,  Pseq([1, 0.9, 0.7, 0.3, 0.1]),
	\ts,  Place([1,   0.75, Pseq([0.65], inf)]).trace, // 1
	\dur, Place([0.6, 0.5, Pseq([0.25], inf)]), // 0.6
	\sustain, 2,
).play;
)


(
p = Pbind.new(
	\instrument, \seagull_A,
	\ls,  Pseq([1, 0.9, 0.7, 0.3, 0.1]),
	\ts,  Place([1,   0.75, Pseq([0.65], inf)]).trace, // 1
	\dur, Place([0.6, 0.5, Pseq([0.25], inf)]), // 0.6
	\sustain, 2,
).play;
)
p.stop



// first experiments: basic seagull sound fx
(
SynthDef.new(\seagull, {
	var sig, env, amp = 0.25;
	var pos= 0;
	sig = SinOsc.ar(Line.kr([1598, 3122, 4612], [1209, 2571, 3802], 0.160));
	env = EnvGen.kr(Env.new([0.001, 1, 0.5, 1, 0.001], [0.035, 0.025,0.040, 0.060],\sine), doneAction:2);
	sig = sig * env * amp;
	Out.ar(0, Pan2.ar(Splay.ar(sig, 0), pos));
}).add;
)

x = Synth(\seagull);
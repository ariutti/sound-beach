// SEAGULL sound 2 (wip)

(
s.boot;
s.meter;
s.plotTree;
s.freeAll;
)

(
SynthDef.new(\seagull_B, {
	|fidx=1|
	var sig, env, amp = 0.05;
	var out = 16;
	var pos= 0;
	var freq = EnvGen.kr(Env.new(
		[3122, 3122, 4191, 4191, 4580, 4580, 5423, 5423, 4548, 4548, 3770, 3000]*fidx,
		[70, 4, 20, 2, 20,4, 189, 2, 205, 2, 98]/1000.0));
	env = EnvGen.kr(Env.new([0.8, 0.25, 1, 0], [96, 116, 404]/1000, [\sine, \sine, \sine]), doneAction:2 );
	sig = SinOscFB.ar( freq, 0.9);
	sig = HPF.ar(sig, 2000);

	sig = sig * env * amp;
	Out.ar(out, Pan2.ar(sig, pos));
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
e = Synth(\seagull_B);

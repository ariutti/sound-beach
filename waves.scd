// SEASHORE test 1
s.boot;
s.freeAll;
s.meter;
s.plotTree;
s.freqscope;
Env.perc(5,5,curve:0).plot


// The greater the coefficient (till 1.0)
// the more the LPF will affect the input sound.
// The lower the coefficient (till -1.0)
// the more energy will be given to the high frequencies
sig = OnePole.ar(in, coeff);


// the strongness of th esingle wave is inversely proportional to the decay.
// The more strong the wave is, the less it lasts.
(
SynthDef.new(\single_wave, {
	|pan=0, amp=0.9|
	var sig, env, coeff;

	var invstrenght = Rand(2, 10);
	var decay = invstrenght;
	env = EnvGen.ar(Env.perc(0.01,decay), doneAction:2);
	// select from 3 different noise sources
	sig = Select.ar(Rand(0,2).round(1), [
		BrownNoise.ar(),
		PinkNoise.ar(),
		WhiteNoise.ar()*0.3
	]);
	coeff = EnvGen.kr(Env.new([-0.99, 0.8], [invstrenght], curve:-2));
	sig = OnePole.ar(sig, coeff);
	sig = sig.clip2 * env * amp;
	Out.ar(0, Pan2.ar(sig, Rand(-0.5, 0.5)));
}).add;
)

~spot = Synth.new(\single_wave);
~spot.free;

// Continuos dynamic seashore
(
SynthDef.new(\continuos_seashore, {
	| gate=1, amp=0.125 |
	var sig, env, coeff, dynamics, osc;
	env = EnvGen.ar(Env.asr(5,1,5), gate, doneAction:2);
	sig = {PinkNoise.ar()}!2;
	// dynamics is varying the frency of the overall sea movement
	dynamics = LFNoise1.kr(1).linlin(-1, 1, 0.03, 0.1);
	coeff = SinOsc.kr(dynamics, mul:0.5);
	sig = OnePole.ar(sig, coeff);
	sig = sig.clip2 * env * amp;
	// the final audio in a weighted mix
	// between the original signal and a 'combfiltered' version of itself
	//
	sig = SelectX.ar(1,
		[
			sig,
			CombN.ar(sig, 0.01,
				SinOsc.kr(0.1).range(0.001, 0.002),
				LFNoise1.kr(0.13).range(0.007, 0.0001)
			)
		]);
	Out.ar(0, sig);
}).add;
)

~continuos = Synth.new(\continuos_seashore);
~continuos.set(\gate, 0);
~continuos.free;


// the lesser it the delay time the more accentuated is the flanger effect
{CombN.ar(WhiteNoise.ar()!2, 0.01, SinOsc.kr(0.1).range(0.001, 0.002).poll, 0.005); }.play;


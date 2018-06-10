// SEAGULL sound 1bis
// new study about a continuos
(
s.boot;
s.meter;
s.plotTree;
s.freeAll;
)

// here we are creating an amplitude envelope.
(
//~gull_levels_1 = Env.new([0.001, 1, 0.5, 1, 0.001], [0.035, 0.025,0.040, 0.060],\sine);
~gull_levels_1 = Env.new([-14, -7, -13, -4, -14].dbamp.normalize, [0.048, 0.338,0.222, 0.053],\sine);
~gull_freqs_1 = Env.new([1248, 1421, 1076], [0.522, 0.092], [\sine, \sine]);
~gull_levels_2 = Env.new([-14, -6, -7.3, -4.95, -14].dbamp.normalize, [0.01, 0.089, 0.065, 0.01],\sine);
~gull_freqs_2 = Env.new([1120, 1248, 947], [0.107, 0.069], [\sine, \sine]);
//~gull_levels_1.plot;
//~gull_freqs_1.plot;
//~gull_levels_2.plot;
//~gull_freqs_2.plot;

~envArray = ~envArray ? Array.newClear(2);
~envArray.put(0,  [~gull_levels_1, ~gull_freqs_1] );
~envArray.put(1,  [~gull_levels_2, ~gull_freqs_2] );
)
~envArray[0][0].plot;


(
SynthDef(\gull_voice_pt1, {
	|amp=0.25, timescale=1|
	var levelEnv= EnvGen.kr( ~envArray[ 0 ][0], timeScale:timescale, doneAction:2 );
	var freqEnv = EnvGen.kr( ~envArray[ 0 ][1], timeScale:timescale, );
	var sig = SinOsc.ar( [freqEnv, freqEnv*2.1, freqEnv*2.98] ) * levelEnv;
	sig = sig*amp;
	Out.ar(0, Mix.ar(sig)!2);
}).add;


SynthDef(\gull_voice_pt2, {
	|amp=0.25, timescale=1|
	var levelEnv= EnvGen.kr( ~envArray[ 1 ][0], timeScale:timescale, doneAction:2 );
	var freqEnv = EnvGen.kr( ~envArray[ 1 ][1], timeScale:timescale, );
	var sig = SinOsc.ar( [freqEnv, freqEnv*2.1, freqEnv*2.98] ) * levelEnv;
	sig = sig*amp;
	Out.ar(0, Mix.ar(sig)!2);
}).add;
)


// try the singular voices
(
x = Synth(\gull_voice_pt1);
x = Synth(\gull_voice_pt2);
)
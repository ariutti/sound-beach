s.boot;
s.meter;
s.plotTree;

// underwater rumble (a sorf of)
(
SynthDef(\rumble_1, {
	|q=0.25, fc=130|
	var sig, amp=0.10;
	sig = LFNoise1.ar( 1000 )!2;
	sig = BPF.ar( sig, fc, q);
	sig = sig * amp;
	Out.ar(0, sig);
}).add;
)

~noise = Synth.new(\rumble);
~noise.set(\q, 0.1);
~noise.set(\fc, 48.midicps);
~noise.set(\out, 0);
~noise.free();

// boat bell

(
~path = PathName.new("/home/nicola/Documenti/repos/sound-beach/samples/impact1.wav");
~path;
~boatbellsample = Buffer.read(s, ~path.fullPath);
)

(
SynthDef(\boatbell, {
	|amp=0.15, pan=0, rate=1, bufnum, dly=0.25|
	var sig, trigger;
	trigger = Impulse.kr(0);
	trigger = trigger + TDelay.kr(trigger, dly);
	sig = PlayBuf.ar(1, bufnum, BufRateScale.kr(bufnum) * rate, trigger, doneAction:2);
	sig = sig * amp;
	Out.ar(0, Pan2.ar(sig, pan));
}).add;
)

(
~boatbell = Synth(\boatbell, [
	\bufnum, ~boatbellsample,
	\dly, rrand(0.25, 0.5),
	\rate, rrand(0.85, 1.15),
	\amp, rrand(0.15, 0.5),
	\pos, rrand(-0.8, 0.8)
]);
)
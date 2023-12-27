"setup.scd".loadRelative;

(
// reverb
~reverbSynth.set(\reverbTime, 8.5);
~reverbSynth.set(\size, 2.4);
~reverbSynth.set(\earlyDiff, 0.2);
)

(
// sync
~sync = Pbindef(\metro, \instrument, \nuevokick,
	\freq, Pseq([440, 220, 220, 220], inf),
	\amp, 0.96);
)
~sync.play(t, quant: 4);
~sync.stop;
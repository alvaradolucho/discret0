(
SynthDef(\ambientillo, { | freq=220, amp=0.1, t_gate=1 |
	var env, gate, sig;

	gate = Trig1.kr(t_gate, \dur.kr(5));

	env = EnvGen.ar(
		Env.adsr(\atk.kr(3), \decay.kr(0.3), \sus.kr(0.5), \rel.kr(3)),
		gate, doneAction: 2
	);

	freq = freq!2 * 0.5;
	freq = freq * LFNoise1.kr(2).exprange(0.98, 1.01);
	sig = VarSaw.ar(freq, width: 0.1, mul: amp);

	32.do { |i|
		var width_noise = LFNoise1.kr(Rand(0.125, 2)).exprange(0.01, 0.5);
		var amp_sequence = amp / ((1 * i) + 1.3);
		var freq_sequence = freq * ((2 * i) + Rand(0.99, 1.01));
		var harmonic = VarSaw.ar(freq_sequence, width: width_noise, mul: amp_sequence);

		freq_sequence = freq_sequence * SinOsc.kr(Rand(0.25, 4), Rand(0, 2pi)).exprange(0.97, 1.01);

		harmonic = harmonic * SinOsc.kr({[0.25, 0.5, 1.0, 2.0, 4.0, 8.0].choose}).exprange(Rand(0.001, 0.5), 1.0);

		harmonic = Pan2.ar(harmonic, Rand(-1.0, 1.0));

		sig = sig + harmonic;

	};
	sig = DFM1.ar(sig, LFNoise1.kr(0.125).exprange(1200, 5500), \lpres.kr(0.7));
	sig = sig * env;

	Out.ar(~bus[\main], sig);
	Out.ar(~bus[\reverb], sig * \rsend.kr(0.5));
	Out.ar(~bus[\delay], sig * \dsend.kr(0.5));
}).add
)
(
SynthDef(\el_campo, { | freq=220, amp=0.1, t_gate=1 |
	var env, gate, sig;
	var foldosc;

	gate = Trig1.kr(t_gate, \dur.kr(0.12));

	env = EnvGen.ar(
		Env.adsr(
			ExpRand(\atk.kr(0.1), Rand(0.1, 0.5)),
			\decay.kr(0.15),
			\sus.kr(0.5),
			\rel.kr(1.6)),
		gate, doneAction: 2
	);

	freq = freq!2;
	freq = freq * LFNoise1.kr({
		[0.25, 0.5, 1.0, 1.5, 2.0, 3.0].choose
	}
		* l.tempo).exprange(0.985, 1.015);
	sig = SinOscFB.ar(freq, \feedback.kr(0.0), mul: amp);

	sig = sig * env;

	foldosc = AnalogFoldOsc.ar(freq * 2, amp: amp * 0.7);

	foldosc = foldosc * env;

	foldosc = foldosc * LFTri.ar(0.5 * l.tempo).exprange(0.4, 1.0);
	sig = sig + foldosc;

	sig = DFM1.ar(sig, LFNoise1.kr(0.25).exprange(800, 3500), LFNoise1.kr(0.5 * l.tempo).exprange(0.45, 0.75), noiselevel: 0.0);



	// sig = AnalogChew.ar(sig);

	Out.ar(~bus[\main], sig);
	Out.ar(~bus[\reverb], sig * \rsend.kr(0.0));
	Out.ar(~bus[\delay], sig * \dsend.kr(0.0));
}).add;
)
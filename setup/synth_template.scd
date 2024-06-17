(
SynthDef(\template, { | freq=220, amp=0.1, t_gate=1 |
	var env, gate, sig;

	gate = Trig1.kr(t_gate, \dur.kr(0.1));

	env = EnvGen.ar(
		Env.adsr(\atk.kr(0.1), \decay.kr(0.3), \sus.kr(0.5), \rel.kr(1.0)),
		gate, doneAction: 2
	);

	freq = freq!2;
	sig = SinOsc.ar(freq, mul: amp);

	sig = sig * env;

	Out.ar(~bus[\main], sig);
}).add
)
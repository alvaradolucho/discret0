(
SynthDef(\blip, { | freq=220, amp=0.1, t_gate=1 |
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
	Out.ar(~bus[\delay], sig * \dsend.kr(0.0));
}).add;

SynthDef(\blop, { | freq=220, amp=0.1, t_gate=1 |
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
	Out.ar(~bus[\reverb], sig * \rsend.kr(0.0));
}).add;

SynthDef(\padcito, { | freq=220, amp=0.1, t_gate=1 |
	var env, gate, sig;

	gate = Trig1.kr(t_gate, \dur.kr(1) * l.tempo);

	env = EnvGen.ar(
		Env.adsr(\atk.kr(1.0), \decay.kr(0.3), \sus.kr(0.5), \rel.kr(2.0)),
		gate, doneAction: 2
	);

	freq = freq * [1, \detune.kr(1.01)];

	sig = VarSaw.ar(freq, width: 0.01,mul: amp);

	sig = DFM1.ar(sig, \lpfreq.kr(3500), \lpres.kr(0.1));

	sig = sig * env;

	Out.ar(~bus[\main], sig);
	Out.ar(~bus[\reverb], sig * \rsend.kr(0.0));
}).add;
)
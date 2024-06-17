(
SynthDef(\claroquesi, { | freq=220, amp=0.1, t_gate=1 |
	var env, gate, sig;

	gate = Trig1.kr(t_gate, \dur.kr(0.1));

	env = EnvGen.ar(
		Env.adsr(\atk.kr(0.1), \decay.kr(0.3), \sus.kr(0.5), \rel.kr(1.0), curve: -6.0),
		gate, doneAction: 2
	);

	freq = freq!2;
	freq = freq * LFNoise1.kr(0.75).range(-0.2, 0.02).midiratio;
	sig = VarSaw.ar(freq, width: \width.kr(0.5), mul: amp);

	sig = sig * env;

	//sig = Balance2.ar(sig[0], sig[1], \pan.kr(0.0));
	sig = Splay.ar(sig);

	sig = sig * SinOsc.ar(
		\ampmodfreq.kr(0.25) * l.tempo
	).exprange(\ampmoddepth.kr(-20.dbamp), 1.0);
	sig = DFM1.ar(sig, \lpfreq.kr(6000), \lpres.kr(0.1));

	sig = HPF.ar(sig, \hpfreq.kr(60));

	sig = AnalogVintageDistortion.ar(sig, \drive.kr(0.0), \bias.kr(0.0), \low.kr(0.0), \high.kr(0.0)) * 0.1;



	Out.ar(~bus[\main], sig);
	Out.ar(~bus[\reverb], sig * \rsend.kr(0.0));
	Out.ar(~bus[\delay], sig * \dsend.kr(0.0));
}).add;


SynthDef(\nose, { | freq=220, amp=0.1, t_gate=1 |
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
}).add;
)
(
SynthDef(\tecno3, { |freq=220, amp=0.1, t_gate=1 |
	var env, envlpf;
	var sig;

	var gate = Trig1.kr(t_gate, \dur.kr(0.1));
	env = EnvGen.ar(
		Env.adsr(\atk.kr(0.01), \decay.kr(0.1), \sus.kr(0.5), \rel.kr(1.5)), gate, doneAction: 2
	);
	freq = freq * [1.0, 1.015];
	sig = SinOscFB.ar(freq, \feedback.kr(1.5),mul: amp);

	env = (env * env);

	sig = LPG.ar(
		sig,
		controlinput: env,
		controloffset: 0.1,
		controlscale: 1,
		vca: LFNoise1.kr(1, add: 0.001),
		resonance: 1.3,
		lowpassmode: 1,
		linearity: 1
	);

	sig = MoogVCF.ar(sig, \lpfreq.kr(5500), \lpres.kr(0.3));


	sig = AnalogVintageDistortion.ar(sig, \drive.kr(0.0), \bias.kr(0.0), \low.kr(0.0), \high.kr(0.0)) * 0.3;
	sig = Balance2.ar(sig[0], sig[1], \pan.kr(0.0));
	//sig = sig * (env);
	Out.ar(~bus[\main], sig);
	Out.ar(~bus[\delay], sig * \dsend.kr(0.0));
	Out.ar(~bus[\reverb], sig * \rsend.kr(0.0));

}).add;



SynthDef(\padstecno3, { | freq=220, amp=0.1, t_gate=1 |
	var env;
	var sig;

	var gate = Trig1.kr(t_gate, \dur.kr(0.6));
	env = EnvGen.ar(
		Env.adsr(\atk.kr(0.1), \decay.kr(0.4), \sus.kr(0.5), \rel.kr(4.5)), gate, doneAction: 2
	);
	freq = freq * [1.0, 1.015];
	freq = freq * LFNoise1.kr(2 * l.tempo).range(0.97, 1.01);
	sig = VarSaw.ar(freq, width: \width.kr(0.5), mul: amp);
	freq = freq * Rand(0.99, 1.01);
	sig = sig + Saw.ar(freq*1.5, mul: (amp * 0.35));

	env = (env * env);

	sig = LPG.ar(
		sig * 0.4,
		controlinput: env,
		controloffset: 0.2,
		controlscale: 1,
		vca: LFNoise1.kr(1, add: 0.000001),
		resonance: 1.2,
		lowpassmode: 1,
		linearity: 1
	);

	 sig = MoogVCF.ar(sig, \lpfreq.kr(3500), \lpres.kr(0.2));


	sig = AnalogVintageDistortion.ar(sig, \drive.kr(0.0), \bias.kr(0.0), \low.kr(0.0), \high.kr(0.07)) * 0.5;
	sig = Balance2.ar(sig[0], sig[1], \pan.kr(0.0));
	//sig = sig * (env);
	Out.ar(~bus[\main], sig);
	Out.ar(~bus[\delay], sig * \dsend.kr(0.0));
	Out.ar(~bus[\reverb], sig * \rsend.kr(0.0));
}).add;
)
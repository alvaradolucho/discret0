(
SynthDef(\datahack, { |freq=220, amp=0.1, t_gate=1 |
	var env, envlpf;
	var sig;

	var gate = Trig1.kr(t_gate, \dur.kr(0.1));
	env = EnvGen.ar(
		Env.adsr(\atk.kr(0.01), \decay.kr(0.1), \sus.kr(0.5), \rel.kr(1.5)), gate, doneAction: 2
	);
	freq = freq * [1.005, 0.995];
	sig = SinOscFB.ar(freq, \feedback.kr(1.5), mul: amp);

	env = (env * env);

	sig = LPG.ar(
		sig,
		controlinput: env,
		controloffset: 0,
		controlscale: 1,
		vca: LFNoise1.kr(1, add: 0.001),
		resonance: LFNoise1.kr(1).range(1.4, 1.51),
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

SynthDef(\vulnerabilidades, { |freq=220, amp=0.1, t_gate=1 |
	var env, envlpf;
	var sig;

	var gate = Trig1.kr(t_gate, \dur.kr(0.1));
	env = EnvGen.ar(
		Env.adsr(\atk.kr(0.01), \decay.kr(0.1), \sus.kr(0.5), \rel.kr(1.5)), gate, doneAction: 2
	);
	freq = freq * [1.005, 0.995];
	sig = SinOsc.ar(freq, mul: amp);

	env = (env * env);

	sig = LPG.ar(
		sig,
		controlinput: env,
		controloffset: 0,
		controlscale: 1,
		vca: LFNoise1.kr(1, add: 0.001),
		resonance: LFNoise1.kr(1).range(0.5, 0.9),
		lowpassmode: 1,
		linearity: 1
	);

	sig = MoogVCF.ar(sig, \lpfreq.kr(12500), \lpres.kr(0.3));


	sig = AnalogVintageDistortion.ar(sig, \drive.kr(0.0), \bias.kr(0.0), \low.kr(0.0), \high.kr(0.0)) * 0.3;
	sig = Balance2.ar(sig[0], sig[1], \pan.kr(0.0));
	//sig = sig * (env);
	Out.ar(~bus[\main], sig);
	Out.ar(~bus[\delay], sig * \dsend.kr(0.0));
	Out.ar(~bus[\reverb], sig * \rsend.kr(0.0));

}).add;
)
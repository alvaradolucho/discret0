(
SynthDef(\ola, { | amp=0.1, freq=220, t_trig=1 |
	var env, gate, sig, envFreq;

	gate = Trig1.kr(t_trig, \dur.kr(0.1));

	env = EnvGen.ar(
		Env.adsr(
			\atk.kr(0.001),
			\decay.kr(0.10),
			\sus.kr(0.15),
			\rel.kr(0.1)
		),
		gate, doneAction: 2
	);

	envFreq = EnvGen.ar(
		Env.adsr(
			\atkf.kr(1.9),
			\decayf.kr(5),
			\susf.kr(0.75),
			\relf.kr(4)
		),
		gate, doneAction: 2
	);

	freq = freq * [1.005, \detune.kr(1.01)] * envFreq.exprange(0.98, 1.08);
	sig = VarSaw.ar(freq, width: \width.kr(0.5), mul: amp);

	sig = sig * env;

	sig = sig * VarSaw.ar(sig * \fmod.kr(0.25), mul: amp);

	sig = LPG.ar(
		input: sig,
		controlinput: env.sqrt,
		controloffset: LFNoise2.kr(2).range(0.75,0.95),
		controlscale: 1,
		vca: 1,
		resonance: 0.8
	);

	sig = AnalogVintageDistortion.ar(
		sig,
		drivegain: 1.2,
		bias: 0.15,
		lowgain: 0.3,
		highgain: 0.4
	) * 0.2;

	sig = Balance2.ar(sig[0], sig[1], \pan.kr(0.0));

	Out.ar(~bus[\main], sig);
	Out.ar(~bus[\reverb], sig * \rsend.kr(0.0));
	Out.ar(~bus[\delay], sig * \dsend.kr(0.0));



}).add;
)



(
SynthDef(\aio, { | amp=0.1, freq=440, t_trig=1 |
	var env, gate, sig;

	gate = Trig1.kr(t_trig, \dur.kr(0.1));

	env = EnvGen.ar(
		Env.adsr(
			\atk.kr(0.001),
			\decay.kr(0.10),
			\sus.kr(0),
			\rel.kr(0.1)
		),
		gate, doneAction: 2
	);

	freq = freq * [1.005, \detune.kr(1.01)];

	sig = Pulse.ar(freq, width:0.6, mul: amp) * env;

	sig = SinOsc.ar(freq, sig.range(-0.05, 0.05), mul:amp) * env;

	sig = AnalogVintageDistortion.ar(sig,
		drivegain: 0.2,
		bias: 0.25,
		lowgain: 0.01,
		highgain: 0.3,
		shelvingfreq: 5000,
		oversample: 0
	) * 0.2;

	sig = Balance2.ar(sig[0], sig[1], \pan.kr(0.0));

	Out.ar(~bus[\main], sig);
	Out.ar(~bus[\reverb], sig * \rsend.kr(0.0));
	Out.ar(~bus[\delay], sig * \dsend.kr(0.0));

}).add;
)


(
SynthDef(\kicklz, { | freq=55, amp=0.1, t_gate=1, decay=0.25 |
	var env, gate, noise, sig;
	var pitchEnv;


	gate = Trig1.kr(t_gate, \dur.kr(0.1));

	env = EnvGen.ar(
		Env.adsr(\atk.kr(0.001), decay, \sus.kr(0.35), \rel.kr(0.25)),
		gate, doneAction: 2
	);

	pitchEnv = EnvGen.kr(
		Env.new(levels: [1, 0.5, 0], times: [0.005, decay],curve: 'lin'),
		gate,
		doneAction: 0
	);

	pitchEnv = ( (( pitchEnv * 75 ) + 25).poll ).midicps * 1.0;

	// freq = freq!2 * pitchEnv;
	//freq = freq !2;
	freq = pitchEnv!2;
	sig = Pulse.ar(freq, 0.5, mul: amp);
	noise = BrownNoise.ar(amp * \noise.kr(0.5));

	sig = sig + noise;
	sig = MoogVCF.ar(sig, pitchEnv * 1.0, \lpres.kr(0.55));

	sig = sig + SinOsc.ar(pitchEnv!2 * \pitchScale.kr(0.5), mul: amp);


	sig = sig * env;
	sig = AnalogVintageDistortion.ar(sig, \drive.kr(0.95), \bias.kr(0.3), \low.kr(0.15)) * 0.1;

	Out.ar(~bus[\main], sig);
}).add
)
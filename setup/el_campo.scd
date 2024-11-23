// el campo

(
SynthDef(\el_campo, { | freq=220, amp=0.1, t_gate=1 |
	var env, gate, sig;
	var foldosc;

	gate = Trig1.kr(t_gate, \dur.kr(0.1));

	env = EnvGen.ar(
		Env.adsr(\atk.kr(0.1), \decay.kr(0.3), \sus.kr(0.5), \rel.kr(1.0)),
		gate, doneAction: 2
	);

	freq = freq!2;
	freq = freq * LFNoise1.kr(2).exprange(0.985, 1.015);
	sig = SinOscFB.ar(freq, \feedback.kr(0.0), mul: amp);

	sig = sig * env;

	foldosc = AnalogFoldOsc.ar(freq * \octmod.kr(2), amp: amp * 0.65);
	foldosc = foldosc * LFTri.kr(4 * l.tempo).exprange(0.1, 1.0);
	sig = sig + foldosc;

	Out.ar(~bus[\main], sig);
	Out.ar(~bus[\reverb], sig * \rsend.kr(0.0));
	Out.ar(~bus[\delay], sig * \dsend.kr(0.0));
}).add;

SynthDef(\noisecito, { | freq=220, amp=0.1, t_gate=1 |
	var env, gate, sig;

	gate = Trig1.kr(t_gate, \dur.kr(0.1));

	env = EnvGen.ar(
		Env.adsr(\atk.kr(0.1), \decay.kr(0.3), \sus.kr(0.5), \rel.kr(1.0)),
		gate, doneAction: 2
	);

	freq = freq!2;
	sig = GrayNoise.ar(mul: amp)!2;

	sig = sig + BrownNoise.ar(mul: amp * 0.75);

	sig = sig * env;

	sig = MoogVCF.ar(sig, \lpfreq.kr(6500), \lpres.kr(0.3));

	sig = Balance2.ar(sig[0], sig[1], \pan.kr(0.0));

	sig = AnalogTape.ar(sig, 0.3, 0.4, 0.4);

	Out.ar(~bus[\main], sig);
	Out.ar(~bus[\reverb], sig * \rsend.kr(0.0));
	Out.ar(~bus[\delay], sig * \dsend.kr(0.0));
}).add;

SynthDef(\claroquesi, { | freq=220, amp=0.1, t_gate=1 |
	var env, gate, sig;
	var envlpfreq;

	gate = Trig1.kr(t_gate, \dur.kr(0.1));

	env = EnvGen.ar(
		Env.adsr(\atk.kr(0.1), \decay.kr(0.3), \sus.kr(0.5), \rel.kr(1.0), curve: -5.0),
		gate, doneAction: 2
	);

	freq = freq * [1.0, \detune.kr(1.0)];
	freq = freq * LFTri.kr(0.125 * l.tempo).range(-0.5, 0.01).midiratio;
	sig = VarSaw.ar(freq, width: \width.kr(0.5), mul: amp);

	sig = sig * env;

	sig = Balance2.ar(sig[0], sig[1], \pan.kr(0.0));
	//sig = Splay.ar(sig);

	//sig = sig * SinOsc.ar( 		\ampmodfreq.kr(1) * l.tempo  	).exprange(\ampmoddepth.kr(-20.dbamp), 1.0);

	envlpfreq = EnvGen.ar(
		Env.adsr(0.02, 0.5, 0.2, 0.1),
		gate,
		doneAction: 0
	);
	sig = DFM1.ar(sig, \lpfreq.kr(10000) * envlpfreq.range(0.125, 1), \lpres.kr(0.4));

	sig = HPF.ar(sig, \hpfreq.kr(60));

	sig = AnalogVintageDistortion.ar(sig, \drive.kr(0.0), \bias.kr(0.0), \low.kr(0.0), \high.kr(0.0)) * 0.1;



	Out.ar(~bus[\main], sig);
	Out.ar(~bus[\reverb], sig * \rsend.kr(0.0));
	Out.ar(~bus[\delay], sig * \dsend.kr(0.0));
}).add;

SynthDef(\noisecito2, { | freq=220, amp=0.1, t_gate=1 |
	var env, gate, sig;

	gate = Trig1.kr(t_gate, \dur.kr(0.1));

	env = EnvGen.ar(
		Env.adsr(\atk.kr(0.1), \decay.kr(0.3), \sus.kr(0.5), \rel.kr(1.0)),
		gate, doneAction: 2
	);


	env = env * LFNoise1.kr(1 * l.tempo).range(0.9, 1.1);
	sig = GrayNoise.ar(mul: amp)!2;

	sig = sig * env;

	sig = MoogVCF.ar(sig, \lpfreq.kr(6500), \lpres.kr(0.3));

	sig = HPF.ar(sig, 200);
	sig = AnalogTape.ar(sig, \bias.kr(0.5), \saturation.kr(0.85), \drive.kr(0.85), oversample: 2);

	Out.ar(~bus[\main], sig);
	Out.ar(~bus[\reverb], sig * \rsend.kr(0.0));
	Out.ar(~bus[\delay], sig * \dsend.kr(0.0));
}).add;

SynthDef(\noisecito3, { | freq=220, amp=0.1, t_gate=1 |
	var env, gate, sig;

	gate = Trig1.kr(t_gate, \dur.kr(0.1));

	env = EnvGen.ar(
		Env.adsr(\atk.kr(0.1), \decay.kr(0.3), \sus.kr(0.5), \rel.kr(1.0)),
		gate, doneAction: 2
	);


	env = env * LFNoise2.kr(4 * l.tempo).range(0.1, 1.1);

	freq = freq * LFNoise1.kr(2 * l.tempo).range(0.985, 1.015);
	freq = freq * [0.995, 1.005];

	sig = SinOscFB.ar(freq, \feedback.kr(0.5), mul: amp);

	sig = sig * env;

	sig = MoogVCF.ar(sig, \lpfreq.kr(6500), \lpres.kr(0.3));

	sig = HPF.ar(sig, 60);
	sig = AnalogTape.ar(sig, \bias.kr(0.5), \saturation.kr(0.85), \drive.kr(0.85), oversample: 2);

	Out.ar(~bus[\main], sig);
	Out.ar(~bus[\reverb], sig * \rsend.kr(0.0));
	Out.ar(~bus[\delay], sig * \dsend.kr(0.0));
}).add;

SynthDef(\noise_resonator, { | freq=220, amp=0.1, t_gate=1 |
	var env, gate, noise, sound;

	gate = Trig1.kr(t_gate, \dur.kr(0.3));

	env = EnvGen.ar(
		Env.adsr(\atk.kr(0.1), \decay.kr(0.3), \sus.kr(0.5), \rel.kr(1.0)),
		gate, doneAction: 2
	);

	freq = freq * [1, 1.01, 0.99, 1.5, 2.025];
	amp = Array.geom(freq.size, amp, 0.8);
	noise = GrayNoise.ar(amp);

	//sound = MoogVCF.ar(noise, freq, \lpres.kr(0.98));

	sound = Resonator.ar(
		input: noise,
		freq: freq,
		position: 0.02,
		resolution: \resolution.kr(20),
		structure: 0.6,
		brightness: 0.4,
		damping: \damp.kr(0.5)
	) * 0.25;

	sound = MoogVCF.ar(sound, \lpfreq.kr(3500), \lpres.kr(0.5));

	//sound = MoogFF.ar(in: sound, freq: freq, gain: 1);
	sound = sound * env;

	sound = Pan2.ar(sound.sum, \pan.kr(0.0));

	sound = HPF.ar(sound, 120);

	sound = AnalogVintageDistortion.ar(sound, \drive.kr(0.05), \bias.kr(0.01), \low.kr(0.05), \high.kr(0.05), oversample: 0) * 0.2;
	//sound = AnalogTape.ar(sound, \bias.kr(0.5), \saturation.kr(0.85), \drive.kr(0.85), oversample: 2);

	Out.ar(~bus[\main], sound);
	Out.ar(~bus[\reverb], sound * \rsend.kr(0.0));
	Out.ar(~bus[\delay], sound * \dsend.kr(0.0));
}).add;

SynthDef(\noise_resonator2, { | freq=220, amp=0.1, t_gate=1 |
	var env, gate, noise, sound;

	gate = Trig1.kr(t_gate, \dur.kr(0.3));

	env = EnvGen.ar(
		Env.adsr(\atk.kr(0.1), \decay.kr(0.3), \sus.kr(0.5), \rel.kr(1.0)),
		gate, doneAction: 2
	);

	freq = freq * [1, 1.01, 0.99, 1.5, 2.025, 3];
	freq = freq * SinOsc.kr(0.5 * l.tempo).range(0.975, 1.01);

	amp = Array.geom(freq.size, amp, 0.8);
	noise = GrayNoise.ar(amp);

	//sound = MoogVCF.ar(noise, freq, \lpres.kr(0.98));

	sound = Resonator.ar(
		input: noise,
		freq: freq,
		position: 0.001,
		resolution: \resolution.kr(20),
		structure: 0.5,
		brightness: 0.55,
		damping: \damp.kr(0.5)
	) * 0.25;

	sound = MoogVCF.ar(sound, \lpfreq.kr(3500) * 1.35, \lpres.kr(0.5) * 0.25);

	//sound = MoogFF.ar(in: sound, freq: freq, gain: 1);
	sound = sound * env;

	sound = Pan2.ar(sound.sum, \pan.kr(0.0));

	sound = HPF.ar(sound, 120);
	sound = AnalogTape.ar(sound, \bias.kr(0.2), \saturation.kr(0.25), \drive.kr(0.25), oversample: 2);

	Out.ar(~bus[\main], sound);
	Out.ar(~bus[\reverb], sound * \rsend.kr(0.0));
	Out.ar(~bus[\delay], sound * \dsend.kr(0.0));
}).add;

SynthDef(\ola, { | amp=0.1, freq=220, t_trig=1 |
	var env, gate, sig, envFreq;

	gate = Trig1.kr(t_trig, \dur.kr(0.1));

	env = EnvGen.ar(
		Env.adsr(
			\atk.kr(0.01),
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

	//sig = sig * VarSaw.ar(sig * \fmod.kr(0.25), mul: amp);

	sig = LPG.ar(
		input: sig,
		controlinput: env,
		controloffset: 0.1,
		controlscale: 1, vca: 1,
		resonance: 1.3
	);

	sig = AnalogVintageDistortion.ar(
		sig,
		drivegain: 0.8,
		bias: 0.15,
		lowgain: 0.1,
		highgain: 0.1
	) * 0.2;

	sig = HPF.ar(sig, 80);

	sig = Balance2.ar(sig[0], sig[1], \pan.kr(0.0));

	Out.ar(~bus[\main], sig);
	Out.ar(~bus[\reverb], sig * \rsend.kr(0.0));
	Out.ar(~bus[\delay], sig * \dsend.kr(0.0));



}).add;


SynthDef(\claroqueno, { | freq=220, amp=0.1, t_gate=1 |
	var env, gate, sig;

	gate = Trig1.kr(t_gate, \dur.kr(0.1));

	env = EnvGen.ar(
		Env.adsr(\atk.kr(0.1), \decay.kr(0.3), \sus.kr(0.5), \rel.kr(1.0), curve: -5.0),
		gate, doneAction: 2
	);

	freq = freq * ( \detune.kr(1.00) ).dup;
	freq = freq * LFTri.kr(0.125 * l.tempo).range(-0.5, 0.01).midiratio;
	sig = VarSaw.ar(freq, width: \width.kr(0.5), mul: amp);

	sig = sig * env;

	sig = Balance2.ar(sig[0], sig[1], \pan.kr(0.0));
	//sig = Splay.ar(sig);

	//sig = sig * SinOsc.ar( 		\ampmodfreq.kr(1) * l.tempo  	).exprange(\ampmoddepth.kr(-20.dbamp), 1.0);
	sig = DFM1.ar(sig, \lpfreq.kr(6000), \lpres.kr(0.1));

	sig = HPF.ar(sig, \hpfreq.kr(120));

	sig = AnalogVintageDistortion.ar(sig, \drive.kr(0.0), \bias.kr(0.0), \low.kr(0.0), \high.kr(0.0)) * 0.1;



	Out.ar(~bus[\main], sig);
	Out.ar(~bus[\reverb], sig * \rsend.kr(0.0));
	Out.ar(~bus[\delay], sig * \dsend.kr(0.0));
}).add;

SynthDef(\noise_resonator3, { | freq=220, amp=0.1, t_gate=1, cycle |
	var env, gate, noise, sound, phase;

	gate = Trig1.kr(t_gate, \dur.kr(0.1));

	env = EnvGen.ar(
		Env.adsr(\atk.kr(0.05), \decay.kr(0.4), \sus.kr(0.45), \rel.kr(0.2)),
		gate, doneAction: 2
	);

	freq = freq * [1.0, 1.01];
	freq = freq * 1.0;

	//phase = cycle / ( l.tempo);
	phase = cycle / (4 * 2pi);

	freq = freq * SinOsc.kr(0.25 * l.tempo, phase*0.25).range(0.95, 1.01);

	amp = Array.geom(freq.size, amp, 0.95);
	noise = GrayNoise.ar(amp);

	sound = Resonator.ar(
		input: noise * env,
		freq: freq,
		position: 0.0,
		resolution: \resolution.kr(11),
		structure: SinOsc.kr(0.5 * l.tempo, phase * 0.5).exprange(0.485, 0.505),
		brightness: SinOsc.kr(0.25 * l.tempo, phase.neg * 0.25).exprange(0.5, 0.7),
		damping: SinOsc.kr(0.125 * l.tempo, phase * 0.125).exprange(0.5, 0.7)
	) * 0.25;


	sound = MoogVCF.ar(sound, \lpfreq.kr(1250) * env.range(0.25, 3), \lpres.kr(0.5));

	//sound = MoogFF.ar(in: sound, freq: freq, gain: 1);
	//sound = sound * env;

	sound = Pan2.ar(sound.sum, \pan.kr(0.0));

	sound = HPF.ar(sound, 60);
	sound = AnalogTape.ar(sound, \bias.kr(0.5), \saturation.kr(0.2), \drive.kr(0.3), oversample: 2);

	Out.ar(~bus[\main], sound);
	Out.ar(~bus[\reverb], sound * \rsend.kr(0.0));
	Out.ar(~bus[\delay], sound * \dsend.kr(0.0));
}).add;

SynthDef(\ringz, { | freq=330, amp=0.1, t_gate=1, cycle |
	var env, gate, noise, sound, phase;

	gate = Trig1.kr(t_gate, \dur.kr(0.6));

	env = EnvGen.ar(
		Env.adsr(\atk.kr(0.008), \decay.kr(0.4), \sus.kr(0.45), \rel.kr(0.9)),
		gate, doneAction: 2
	);

	freq = freq * [1.0, 1.01];
	freq = freq * 1.0;

	//phase = cycle / ( l.tempo);
	phase = cycle / (4 * 2pi);

	freq = freq * SinOsc.kr(0.25 * l.tempo, phase*0.25).range(0.95, 1.01);

	amp = Array.geom(freq.size, amp, 0.95);
	noise = GrayNoise.ar(amp);

	sound = Ringz.ar(Impulse.ar(0.5 * l.tempo), freq, 0.5, 0.2);


	sound = MoogVCF.ar(sound * env, \lpfreq.kr(1250) * env.range(0.25, 3), \lpres.kr(0.5));

	//sound = MoogFF.ar(in: sound, freq: freq, gain: 1);
	//sound = sound * env;

	sound = Pan2.ar(sound.sum, \pan.kr(0.0));

	sound = HPF.ar(sound, 60);
	sound = AnalogTape.ar(sound, \bias.kr(0.5), \saturation.kr(0.5), \drive.kr(0.5), oversample: 2);

	Out.ar(~bus[\main], sound);
	Out.ar(~bus[\reverb], sound * \rsend.kr(0.0));
	Out.ar(~bus[\delay], sound * \dsend.kr(0.0));
}).add;

SynthDef(\FMpad, {
    arg freq=440, modFreq=100, amp = 0.01, t_gate=1;
    var carrier, modulator, sound, env;
	var trig = Trig1.kr(t_gate, \dur.kr(0.1));

    // Envelope para el volumen
    env = EnvGen.kr(
		Env.adsr(
			\atk.kr(0.1),
			\decay.kr(0.1),
			\sus.kr(0.1),
			\rel.kr(0.1)
	), gate: trig, doneAction: 2);

    // Oscilador modulador
    modulator = VarSaw.ar(freq, 0, 1);

	freq = freq * [1.0, \detune.kr(1.0)];

    // Oscilador portador
    carrier = VarSaw.ar(freq + modulator.range(0, freq * 4), width: \width.kr(0.5), mul: amp);

	sound = carrier * env;

	sound = MoogVCF.ar(sound, \lpfreq.kr(5500), \lpres.kr(0.1));


	sound = AnalogVintageDistortion.ar(sound, \drive.kr(0.5), \bias.kr(0.1), \low.kr(0.1), \high.kr(0.1), oversample: 2) * 0.1;
    // Salida

	Out.ar(~bus[\main], sound);
	Out.ar(~bus[\reverb], sound * \rsend.kr(0.0));
	Out.ar(~bus[\delay], sound * \dsend.kr(0.0));
}).add;

// Basado en droneFM01 de Óscar Recarte
// https://recarteblog.wordpress.com/

SynthDef(\droneFM, {
	arg f1Freq=0.1, f2Freq=1.1, f3Freq=2.2, freq=110, m1Ratio=1, m2Ratio=3, m3Ratio=2,
	amp=0.1, dur=20, ampM=0.84 , pan=0;
	var sound, car1, mod1, car2, mod2, car3, mod3, env, index;

	freq = freq * Rand(0.98, 1.02);
	index = LFNoise1.kr(2 * l.tempo).range(2, 10);
	env = EnvGen.kr(
		Env.new(
			[0, 0.70, 0.70, 0],
			[dur * 0.333, dur * 0.333, dur * 0.333]),
		doneAction:2
	);
	mod1 = SinOsc.ar([freq * m1Ratio, freq + (1 * m1Ratio)], mul:freq * m1Ratio * index) * ampM;
	car1 = SinOsc.ar(f1Freq + mod1);
	mod2 = SinOsc.ar([freq * m2Ratio, freq + ( 2 * m2Ratio)], mul:freq * m2Ratio * index) * ampM;
	car2 = SinOsc.ar(f2Freq + mod2);
	mod3 = SinOsc.ar([freq * m3Ratio, freq + (0.5 * m3Ratio)], mul:freq * m3Ratio * index) * ampM;
	car3 = SinOsc.ar(f3Freq + mod3) * 0.6;
	sound = ( car1 + car2 + car3 ) * env * amp;

	sound = sound * LFTri.ar(
		{[0.5, 4, 0.5, 0.5, 4, 4, 4, 4, 4, 4, 4].choose} * (\ampmodfreq.kr(1) * l.tempo)).exprange(
		LFNoise1.kr(l.tempo).exprange(-40.dbamp, -2.dbamp),
		0.dbamp
	);


	sound = MoogVCF.ar(sound, SinOsc.kr((0.125 * 0.125) * l.tempo).exprange(1200, 3800), LFNoise1.kr(0.25 * l.tempo).exprange(0.2, 0.5));
	sound = Pan2.ar(sound, pan);
	Out.ar(~bus[\main], sound);
	Out.ar(~bus[\reverb], sound * \rsend.kr(0.0));
	Out.ar(~bus[\delay], sound * \dsend.kr(0.0));
}).add;

SynthDef(\padstecno4, { | freq=220, amp=0.1, t_gate=1 |
	var env;
	var sig;

	var gate = Trig1.kr(t_gate, \dur.kr(0.6));
	env = EnvGen.ar(
		Env.adsr(\atk.kr(0.1), \decay.kr(0.4), \sus.kr(0.5), \rel.kr(4.5)), gate, doneAction: 2
	);
	freq = freq * [1.0, \detune.kr(1.015)];
	freq = freq * LFNoise1.kr(2 * l.tempo).range(0.98, 1.01);
	sig = VarSaw.ar(freq, width: \width.kr(0.5), mul: amp);
	freq = freq * Rand(0.985, 1.015);
	sig = sig + SawDPW.ar(freq * Rand(1.49, 1.51), mul: (amp * 0.85));

	//env = (env * env);

	sig = LPG.ar(
		sig * 0.7,
		controlinput: env,
		controloffset: 0.7,
		controlscale: 0.8,
		vca: 1.0,
		resonance: 1.5,
		lowpassmode: 1,
		linearity: 1
	);

	sig = sig * env;
	sig = MoogVCF.ar(sig, \lpfreq.kr(2100), \lpres.kr(0.6));
	sig = AnalogVintageDistortion.ar(sig, \drive.kr(0.0), \bias.kr(0.0), \low.kr(0.0), \high.kr(0.07)) * 0.3;

	sig = HPF.ar(sig, \hpfreq.kr(60));
	sig = Balance2.ar(sig[0], sig[1], \pan.kr(0.0));
	//sig = sig * (env);
	Out.ar(~bus[\main], sig);
	Out.ar(~bus[\delay], sig * \dsend.kr(0.0));
	Out.ar(~bus[\reverb], sig * \rsend.kr(0.0));
}).add;


SynthDef(\filmbass4, { | freq=220,  amp=0.1, pan=0.0, t_trig=1|
	var env, gate, sig;
	//env = Env.perc(\atk.kr(0.001), \rel.kr(0.5), curve: -8).ar(2);

	gate = Trig1.ar(t_trig, \dur.kr(0.05));
	env = EnvGen.ar(
		Env.adsr(\atk.kr(0.01), \decay.kr(0.1), \sus.kr(0.8), \rel.kr(0.15)),
		gate,
		doneAction: 2);
	freq = freq * [1, \detune.kr(1.015)];
	sig = SinOscFB.ar(freq, \feedback.kr(0.4), amp);

	sig = sig + VarSaw.ar(freq * 2, width: 0.1, mul: amp * 0.5);


	sig = MoogVCF.ar(sig, \lpfreq.kr(2000), \lpres.kr(0.6));

	sig = AnalogVintageDistortion.ar(sig, \drive.kr(0.1), \bias.kr(0.0), \low.kr(0.2), \high.kr(0.1)) * 0.2;
	sig = HPF.ar(sig, \hpfreq.kr(40));

	sig = Balance2.ar(sig[0], sig[1], pan);
	sig = sig * (env * env);
	sig = sig * \trim.kr(1.0);
	Out.ar(~bus[\main], sig);
	Out.ar(~bus[\reverb], sig * \rsend.kr(0.0));
	Out.ar(~bus[\delay], sig * \dsend.kr(0.0));


}).add;

SynthDef(\filmbass5, { | freq=220,  amp=0.1, pan=0.0, t_trig=1|
	var env, gate, sig;
	//env = Env.perc(\atk.kr(0.001), \rel.kr(0.5), curve: -8).ar(2);

	gate = Trig1.ar(t_trig, \dur.kr(0.05));
	env = EnvGen.ar(
		Env.adsr(\atk.kr(0.01), \decay.kr(0.1), \sus.kr(0.8), \rel.kr(0.15)),
		gate,
		doneAction: 2);
	freq = freq * [1, \detune.kr(1.015)];

	freq = freq * LFNoise0.kr(4 * l.tempo).range(0.985, 1.015);

	sig = SinOscFB.ar(freq, \feedback.kr(0.4), amp * 0.5);

	sig = sig + VarSaw.ar(freq * 1.5, width: 0.05, mul: amp * 0.9);


	sig = MoogVCF.ar(sig, SinOsc.kr((0.125 * 0.125) * l.tempo).exprange(500, 3200), \lpres.kr(0.6));

	sig = AnalogVintageDistortion.ar(sig, \drive.kr(0.1), \bias.kr(0.0), \low.kr(0.2), \high.kr(0.1)) * 0.2;
	sig = HPF.ar(sig, \hpfreq.kr(40));

	sig = Balance2.ar(sig[0], sig[1], pan);
	sig = sig * (env * env);
	sig = sig * \trim.kr(1.0);
	Out.ar(~bus[\main], sig);
	Out.ar(~bus[\reverb], sig * \rsend.kr(0.0));
	Out.ar(~bus[\delay], sig * \dsend.kr(0.0));


}).add;

SynthDef(\filmbass6, { | freq=220,  amp=0.1, pan=0.0, t_trig=1|
	var env, gate, sig;
	//env = Env.perc(\atk.kr(0.001), \rel.kr(0.5), curve: -8).ar(2);

	gate = Trig1.ar(t_trig, \dur.kr(0.05));
	env = EnvGen.ar(
		Env.adsr(\atk.kr(0.01), \decay.kr(0.1), \sus.kr(0.8), \rel.kr(0.15)),
		gate,
		doneAction: 2);
	freq = freq * [1, \detune.kr(1.015)];

	freq = freq * LFNoise1.kr(1 * l.tempo).range(0.985, 1.01);

	sig = SinOscFB.ar(freq, \feedback.kr(0.4), amp * 0.5);

	sig = sig + VarSaw.ar(freq * 1.5, width: \width.kr(0.05), mul: amp * 0.1);


	sig = MoogVCF.ar(sig, SinOsc.kr(0.125 * l.tempo).exprange(500, 2100), \lpres.kr(0.8));

	sig = AnalogVintageDistortion.ar(sig, \drive.kr(0.7), \bias.kr(0.25), \low.kr(0.2), \high.kr(0.1)) * 0.2;
	sig = HPF.ar(sig, \hpfreq.kr(40));

	sig = Balance2.ar(sig[0], sig[1], pan);
	sig = sig * (env * env);
	sig = sig * \trim.kr(1.0);
	Out.ar(~bus[\main], sig);
	Out.ar(~bus[\reverb], sig * \rsend.kr(0.0));
	Out.ar(~bus[\delay], sig * \dsend.kr(0.0));


}).add;
)

~bus[\main].scope;

// El espectro de un impulso puro es teóricamente como el del ruido blanco: energía uniforme en todas las frecuencias,
// por tanto podemos filtrarlo para colorearlo y darle hacer resonar una frecuencia concreta.
// Ringz es un resonador (análogo a una cavidad resonantes que retroalimenta ciertas frecuencias
{ Ringz.ar(Impulse.ar(2), 900, 0.1, 0.3)!2 }.play // hacemos resonar 900 Hz desde el impulso crudo
{ Ringz.ar(Impulse.ar(2), 900, 1.6, 0.3)!2 }.play // resonancia prolongada

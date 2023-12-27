(
SynthDef(\neutron, { | freq=220, amp=0.1, pan=0.0 |
	var env, sig;
	var freq_amp_coeff;
	var lfo1 = Ndef(\lfonoise).kr;
	freq = freq * LFNoise1.kr(4.2).range(-0.25, 0.001).midiratio;
	//freq = freq * lfo1.range(-0.25, 0.001).midiratio;
	env = Env.perc(\atk.kr(0.01), \rel.kr(0.25), curve: \curve.kr(-5.0)).ar(2);

	freq = freq * [1, 0.99];
	sig = SinOscFB.ar(freq, \feedback.kr(0.0), amp);

	sig = sig + SinOsc.ar(freq * 0.5, mul: (0.5 * amp));

	freq_amp_coeff = 270 * freq.reciprocal;
	amp = amp * freq_amp_coeff;
	sig = sig + VarSaw.ar((freq * \varharmonic.kr(0.2)) * rrand(0.997, 1.0015), {[0, pi / 2, pi, 3pi/ 4].choose}, \width.kr(0.5), amp * 0.15);


	sig = sig * LFPulse.kr(\ampmodfreq.kr(4.0)).exprange(\ampModDepth.kr(0.19), 0.99);
	//sig = Pan2.ar(sig, pan);
	sig = Balance2.ar(sig[0], sig[1], pan);
	//sig = (sig * \saturation.kr(1.0)).tanh * \attenuation.kr(1.0);

	sig = DFM1.ar(sig, \lpfreq.kr(2500, 0.01), \lpres.kr(0.01), noiselevel: 0.0) * 0.4;
	sig = AnalogVintageDistortion.ar(sig, drivegain: \drive.kr(0.0), bias: \bias.kr(0.0), lowgain: \lowgain.kr(0.0), highgain: \highgain.kr(0.0), oversample: 1) * 0.3;


	//sig = sig.tanh;
	sig = sig * env;
	Out.ar(~bus[\main], sig);

	Out.ar(~bus[\delay], sig * \dsend.kr(0.0));
	Out.ar(~bus[\reverb], sig * \rsend.kr(0.0));

}).add;

SynthDef(\ninin, { | freq=220, amp=0.1, t_gate=1 |
	var gate, lpgate;
	var env, sig;

	gate = Trig1.kr(t_gate, \dur.kr(0.1));

	env = EnvGen.ar(
		Env.adsr(
			attackTime: \atk.kr(0.1),
			decayTime: \decay.kr(0.4),
			sustainLevel: \sus.kr(0.25),
			releaseTime: \rel.kr(1.0)
		),
		gate,
		doneAction: 2
	);

	freq = freq * [1, \detune.kr(1.02)];
	freq = freq * LFNoise1.kr(4 * l.tempo).range(-0.25, 0.25).midiratio;
	sig = SinOscFB.ar(freq * 0.5, \feedback.kr(0.0), mul: amp);

	sig = sig + Pulse.ar(
		freq, \width.kr(0.04), mul: amp
	);

	lpgate = Env.perc(0.01,2).kr(0, gate: gate);

	sig = LPG.ar(sig, controlinput: lpgate, controloffset: 0.4, controlscale: 1.6, vca: LFNoise0.kr(l.tempo*2).range(-30.dbamp, 1.0),
		resonance: 1.5,
		lowpassmode: 1
	);

	sig = sig * env;

	sig = MoogVCF.ar(sig, \lpfreq.kr(4500), \lpres.kr(0.1));

	sig = AnalogVintageDistortion.ar(sig, \drive.kr(0.5), \bias.kr(0.1)) * 0.1;

	Out.ar(~bus[\main], sig);
	//Out.ar(~bus[\fbdelay], sig * \fbdelay.kr(0.0));
	Out.ar(~bus[\delay], sig * \dsend.kr(0.0));
}).add;
)
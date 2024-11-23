(
SynthDef(\blip, { | freq=220, amp=0.1, t_gate=1, orbit=1 |
	var env, gate, sig, out;

	gate = Trig1.kr(t_gate, \dur.kr(0.1));

	env = EnvGen.ar(
		Env.adsr(\atk.kr(0.1), \decay.kr(0.3), \sus.kr(0.5), \rel.kr(1.0)),
		gate, doneAction: 2
	);

	freq = freq * [1.0, \detune.kr(0.99)];
	sig = SinOsc.ar(freq, mul: amp);

	sig = sig * env;

	out = \d ++ orbit.asSymbol;
	Out.ar(~bus[out], sig);
}).add;

)

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

	foldosc = AnalogFoldOsc.ar(freq * \octmod.kr(2), amp: amp * 0.65) * env;
	foldosc = foldosc * LFTri.kr(4 * l.tempo).exprange(0.1, 1.0);
	sig = sig + foldosc;

	sig = Balance2.ar(sig[0], sig[1], \pan.kr(0.0));

	Out.ar(~bus[\d1], sig);
}).add;

SynthDef(\filmbass2, { | freq=220,  amp=0.1, pan=0.0, t_trig=1|
	var env, gate, sig;
	//env = Env.perc(\atk.kr(0.001), \rel.kr(0.5), curve: -8).ar(2);

	gate = Trig1.ar(t_trig, \dur.kr(0.05));
	env = EnvGen.ar(
		Env.adsr(\atk.kr(0.01), \decay.kr(0.1), \sus.kr(0.8), \rel.kr(0.15)),
		gate,
		doneAction: 2);
	freq = freq * [1, \detune.kr(1.015)];
	sig = SinOscFB.ar(freq, \feedback.kr(0.4), amp);

	sig = sig + SawDPW.ar(freq * 2, mul: amp * 0.5);


	sig = MoogVCF.ar(sig, \lpfreq.kr(5500), \lpres.kr(0.01));

	sig = AnalogVintageDistortion.ar(sig, \drive.kr(0.1), \bias.kr(0.0), \low.kr(0.1), \high.kr(0.1)) * 0.2;
	sig = HPF.ar(sig, \hpfreq.kr(40));
	sig = Balance2.ar(sig[0], sig[1], pan);
	sig = sig * (env * env);
	sig = sig * \trim.kr(1.0);
	Out.ar(~bus[\d1], sig);
}).add;
)
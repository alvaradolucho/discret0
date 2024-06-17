////// sala de pruebas

"setup.scd".loadRelative;

(
SynthDef(\discreet3, { | freq=220, t_gate=1, width=0.4 |
	var env, osc1, osc2, osc3, noise, sig, gate;
	var lfo1 = Ndef(\lfo1).ar;
	var amp;

	amp = min(\amp.kr(0.1), 0.1);

	freq = freq * [1, \detune.kr(1.005)];

	freq = freq * LFTri.kr(\vibratofreq.kr(2, 0.1) * l.tempo).bipolar(\vibratodepth.kr(0.0, 0.1)).midiratio;

	width = width * (lfo1 - \shiftwidth.kr(0, 0.5)).exprange(0.1, 1.0);

	//env = Env.new([0, 1, \sus.kr(0.5), 0], [\atk.kr(0.8), \decay.kr(0.25), \rel.kr(5.3)], 'squared').ar(2);

	gate = Trig1.kr(t_gate, \dur.kr(0.1));

	env = EnvGen.ar(
		Env.adsr(\atk.kr(0.1), \decay.kr(0.3), \sus.kr(0.5), \rel.kr(0.5), 1.0, \curve.kr(-4.0)),
		gate,
		doneAction: 2
	);

	osc3 = VarSaw.ar(freq / 128);

	osc1 = SinOsc.ar((freq * 1) * osc3.range(-0.2, 0.01).midiratio, mul: amp * 0.5) + VarSaw.ar(( freq  * 1) * osc3.range(-0.2, 0.01).midiratio, width: width, mul: amp * 0.5);
	osc1 = osc1 +  SinOsc.ar((freq * 2) * osc3.range(-0.2, 0.01).midiratio, mul: amp * 0.25) + VarSaw.ar(( freq  * 1.5) * osc3.range(-0.2, 0.01).midiratio, width: width, mul: amp * 0.25);
	osc2 = VarSaw.ar(freq * osc3.range(-0.2, 0.01).midiratio, width: width, mul: amp);

	noise = BrownNoise.ar(0.0005);



	sig = ( osc1 * \osc1.kr(1.0) ) + ( osc2 * \osc2.kr(1.0) ) + ( noise * \noise.kr(1.0) );

	sig = sig * SinOsc.ar(\tremolorate.kr(2.5, 0.1) * l.tempo).exprange(\tremolodepth.kr(0.99, 0.1), 1);
	sig = DFM1.ar( sig, \lpfreq.kr(2000) * lfo1.exprange(0.5, 1.5), \lpres.kr(0.01), noiselevel: \filternoise.kr(0.0000));
	sig = HPF.ar(sig, \hpfreq.kr(90.0));

	sig = AnalogVintageDistortion.ar(sig * 0.08, \drive.kr(0.0), \bias.kr(0.0), \low.kr(0.1), \high.kr(0.1));



	sig = sig * ( env );
	//sig = Pan2.ar(sig.sum, \pan.kr(0.0));
	sig = Balance2.ar(sig[0], sig[1], \pan.kr(0.0));
	Out.ar(~bus[\main], sig * \dryAmp.kr(1.0));
	Out.ar(~bus[\reverb], sig * \rsend.kr(0.0));
	Out.ar(~bus[\delay], sig * \dsend.kr(0.0));
	//Out.ar(~busChorus, sig * \chorusAmp.kr(0.0));

}).add;
)

(
SynthDef(\filmbassNuevo, { | freq=220,  amp=0.1, t_gate=1|
	var env, gate, sig;

	//env = Env.perc(\atk.kr(0.001), \rel.kr(0.5), curve: -8).ar(2);
	gate = Trig1.ar(t_gate, \dur.kr(0.1));
	env = EnvGen.ar(
		Env.adsr(
			attackTime: \atk.kr(0.01),
			decayTime: \decay.kr(0.3),
			sustainLevel: \sus.kr(0.5),
			releaseTime: \rel.kr(0.25)
		), gate, doneAction: 2
	);

	freq = freq * [1, \detune.kr(1.015)];
	sig = SinOscFB.ar(freq, \feedback.kr(0.0), amp);

	sig = sig + VarSaw.ar(freq * 2, width: \width.kr(0.5), mul: amp * 0.8);

	sig = sig * env;
	sig = MoogVCF.ar(sig, \lpfreq.kr(5500) * env.range(0, 1), \lpres.kr(0.01) * env.range(0, 1));

	sig = AnalogVintageDistortion.ar(sig, \drive.kr(0.1), \bias.kr(0.0), \low.kr(0.1), \high.kr(0.1)) * 0.25;
	sig = Balance2.ar(sig[0], sig[1], \pan.kr(0.0));
	Out.ar(~bus[\main], sig);
	Out.ar(~bus[\reverb], sig * \rsend.kr(0.0));
	Out.ar(~bus[\delay], sig * \dsend.kr(0.0));


}).add;
SynthDef(\filmbassNuevo2, { | freq=220,  amp=0.1, t_gate=1|
	var env, gate, sig;

	//env = Env.perc(\atk.kr(0.001), \rel.kr(0.5), curve: -8).ar(2);
	gate = Trig1.ar(t_gate, \dur.kr(0.1));
	env = EnvGen.ar(
		Env.adsr(
			attackTime: \atk.kr(0.01),
			decayTime: \decay.kr(0.3),
			sustainLevel: \sus.kr(0.5),
			releaseTime: \rel.kr(0.25)
		), gate, doneAction: 2
	);

	freq = freq * [1, \detune.kr(1.015)];
	sig = SinOscFB.ar(freq, \feedback.kr(0.0), amp);

	sig = sig + VarSaw.ar(freq * 2, width: \width.kr(0.01), mul: amp * 0.8);

	sig = sig * env;
	sig = MoogVCF.ar(sig, \lpfreq.kr(5500) * env.range(0, 1), \lpres.kr(0.01) * env.range(0, 1));

	sig = AnalogVintageDistortion.ar(sig, \drive.kr(0.1), \bias.kr(0.0), \low.kr(0.1), \high.kr(0.1)) * 0.25;
	sig = Balance2.ar(sig[0], sig[1], \pan.kr(0.0));
	Out.ar(~bus[\main], sig);
	Out.ar(~bus[\reverb], sig * \rsend.kr(0.0));
	Out.ar(~bus[\delay], sig * \dsend.kr(0.0));


}).add;
)


(
SynthDef(\fm1, { | freq=220, t_gate=1 |
	var env, opA, opB, sig, gate;
	var amp;

	// operator A is the modulator
	// operator B is the carrier

	amp = min(\amp.kr(0.1), 0.1);

	freq = freq * [1, \detune.kr(1.01)];

	gate = Trig1.kr(t_gate, \dur.kr(0.1));

	env = EnvGen.ar(
		Env.adsr(
			\atk.kr(0.01),
			\decay.kr(0.3),
			\sus.kr(0.5),
			\rel.kr(0.5),
			1.0,
			\curve.kr(-4.0)
		),
		gate,
		doneAction: 2
	);

	opA = SinOsc.ar(freq[0] * 5, mul: amp);

	opB = VarSaw.ar(
		(freq + ((opA * env)* 500)),
		width: 0.02
		, mul: amp);

	opB = opB + SinOsc.ar(
		freq * 0.5,
		mul: (amp + 0.35)
	);

	sig = DFM1.ar(
		opB,
		\lpfreq.kr(4000),
		\lpres.kr(0.01),
		noiselevel: \filternoise.kr(0.0000)
	);

	sig = HPF.ar(sig, \hpfreq.kr(60.0));

	sig = AnalogVintageDistortion.ar(
		sig * 0.3,
		\drive.kr(0.0),
		\bias.kr(0.0),
		\low.kr(0.1),
		\high.kr(0.1)
	);
	sig = sig * ( env * env );
	//sig = Pan2.ar(sig.sum, \pan.kr(0.0));
	sig = Balance2.ar(sig[0], sig[1], \pan.kr(0.0));
	Out.ar(~bus[\main], sig);
	Out.ar(~bus[\reverb], sig * \rsend.kr(0.0));
	Out.ar(~bus[\delay], sig * \dsend.kr(0.0));
}).add;
)


(
Ndef(\ndef1, { |t_gate|
	var amp, freq;
	var lpgenv;
	var gate, env, sig;
	amp = min(\amp.kr(0.1), 0.1);
	freq = \freq.kr(220, \glide.kr(0.5)) * [1, \detune.kr(1.01)];

	gate = Trig1.kr(t_gate, \dur.kr(0.1));

	env = EnvGen.ar(
		Env.adsr(\atk.kr(0.01), \decay.kr(0.3), \sustain.kr(0.5), \rel.kr(0.5)), gate
	);

	sig = VarSaw.ar(freq, width: \width.kr(0.5),mul: amp);

	//sig = MoogVCF.ar(sig, \lpfreq.kr(7500) * env, \lpres.kr(0.6));
	lpgenv = EnvGen.ar(
		Env.adsr(
			\atklpg.kr(0.01),
			\decaylpg.kr(0.6),
			\suslpg.kr(0.2),
			\rellpg.kr(0.5)), gate
	);
	//lpgate = Env.perc(0.01,0.2).kr(0, gate: gate);

	sig = LPG.ar(
		sig,
		controlinput: lpgenv,
		controloffset: \lpgoffset.kr(0.3),
		controlscale: 1.0, vca: 1,
		resonance: 1.5,
		lowpassmode: 1
	);

	sig = AnalogVintageDistortion.ar(
		sig * 0.3, \drive.kr(0.0), \bias.kr(0.0),
		\low.kr(0.1), \high.kr(0.1);
	);
	sig = Balance2.ar(sig[0], sig[1], \pan.kr(0.0));
	sig = sig * env;
});

)
Ndef(\ndef1).fadeTime_(7);
Ndef(\ndef1).play;
Ndef(\ndef1).free;

Ndef(\ndef1).set(\freq, 220, \amp, 0.1);

Ndef(\ndef1).clear;



(
Ndef(\ndef2, { |t_gate|
	var amp, freq;
	var lpgenv;
	var gate, env, sig;
	amp = min(\amp.kr(0.1), 0.1);
	freq = \freq.kr(110, \glide.kr(0.1)) * [1, \detune.kr(1.01)];

	gate = Trig1.kr(t_gate, \dur.kr(0.1));

	env = EnvGen.ar(
		Env.adsr(\atk.kr(0.01), \decay.kr(0.3), \sustain.kr(0.5), \rel.kr(0.5))
	);

	sig = VarSaw.ar(freq, width: \width.kr(0.5),mul: amp);

	sig = MoogVCF.ar(freq, \lpfreq.kr(2500), \lpres.kr(0.1));

	sig = AnalogVintageDistortion.ar(
		sig * 0.3, \drive.kr(0.0), \bias.kr(0.0),
		\low.kr(0.1), \high.kr(0.1);
	);
	sig = Balance2.ar(sig[0], sig[1], \pan.kr(0.0));
	sig = sig * 0.5;
});

)
Ndef(\ndef2).fadeTime_(7);
Ndef(\ndef2).play;
Ndef(\ndef2).free;



/////////////////// noise1 (wen ambient)


(
SynthDef(\noise1, { | freq=220, amp=0.1, t_gate=1 |
	var env, gate, sig;

	gate = Trig1.kr(t_gate, \dur.kr(0.05));

	env = EnvGen.ar(
		Env.adsr(\atk.kr(0.01), \decay.kr(0.1), \sus.kr(0.5), \rel.kr(0.25)),
		gate, doneAction: 2
	) * LFNoise2.ar(4 * l.tempo).range(0.0, 1.0);

	freq = ( freq * [0.995, 1.005] ) * LFNoise1.ar(4 * l.tempo).range(0.97, 1.01);
	sig = SinOsc.ar(freq, mul: amp) ;

	sig = sig + LFTri.ar(freq * 0.25, mul: (amp * 0.3));

	sig = DFM1.ar(sig, \lpfreq.kr(1500), \lpres.kr(0.1), noiselevel: \noise.kr(0.005));

	sig = Balance2.ar(sig[0], sig[1], \pan.kr(0.0));

	sig = sig * env;

	Out.ar(~bus[\main], sig);
	Out.ar(~bus[\reverb], sig * \rsend.kr(0.0));
	Out.ar(~bus[\delay], sig * \dsend.kr(0.0));
}).add
)


/////////////


(
var win = Window("LinkClock", Rect(200, 200, 500, 100)).front,
peersBox, tempoBox, barsBox, beatsBox,
font = Font.default.copy.size_(32),
boldFont = font.boldVariant,
controller, task;

win.layout = HLayout(
	StaticText().font_(font).string_("Peers:"),
	peersBox = NumberBox().font_(boldFont).align_(\center).fixedWidth_(80),
	StaticText().font_(font).string_("Tempo:"),
	tempoBox = NumberBox().font_(boldFont).align_(\center).fixedWidth_(120),
	StaticText().font_(font).string_("Now:"),
	barsBox = NumberBox().font_(boldFont).align_(\center).fixedWidth_(80),
	beatsBox = NumberBox().font_(boldFont).align_(\center).fixedWidth_(80)
);

[peersBox, barsBox, beatsBox].do { |view| view.enabled_(false) };

tempoBox.action = { |view| l.tempo = view.value / 60 };
tempoBox.value = l.tempo * 60;
peersBox.value = l.numPeers;

task = Routine {
	var bars, beats;
	loop {
		bars = l.bar;
		beats = l.beatInBar;
		{
			barsBox.value = bars;
			beatsBox.value = beats;
		}.defer(l.latency);
		1.0.wait;
	}
}.play(l, quant: 1);

controller = SimpleController(l)
.put(\tempo, {
	defer { tempoBox.value = l.tempo * 60 }
})
.put(\numPeers, {
	defer { peersBox.value = l.numPeers }
})
.put(\stop, { defer { win.close } });

win.onClose = { task.stop; controller.remove };
)



[0..2]

(-124).exp
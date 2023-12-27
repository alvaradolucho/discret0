(
SynthDef(\aaa, { | freq=220, amp=0.1 |
	var env, sig;

	freq = freq * [1.0, \detune.kr(1.015)] * LFNoise1.kr(\vibratofreq.kr(1.8)).range(\vibratodepth.kr(-0.2), 0.0).midiratio;
	freq = freq * LFSaw.kr(4 * l.tempo).exprange(1, 1).round(1);
	env = Env.perc(\atk.kr(0.001, 0.2), \rel.kr(0.15, 0.2), curve: \curve.kr(-3.0)).ar(2);

	sig = NeoVarSawOsc.ar(freq * 1, \pw.kr(0.5), \waveshape.kr(0.5)) * amp;
	//sig = ZOsc.ar(freq, \formantfreq.kr(91), \shape.kr(0.5)) * amp * 2.0;
	// sig = AnalogFoldOsc.ar(freq, \fold.kr(1.0)) * amp;
	//sig = sig +  HarmonicOsc.ar(freq, \firstharmonic.kr(1), Array.geom(16, 0.5, \grow.kr(0.85))) * amp * 0.5;

	sig = sig * env;

	sig = DFM1.ar(sig, \lpfreq.kr(2000), \lpres.kr(0.1));
	sig = HPF.ar(sig, 80);
	sig = Balance2.ar(sig[0], sig[1], \pan.kr(0.0));

	Out.ar(~bus[\main], sig);
	Out.ar(~bus[\delay], sig * \dsend.kr(0.0));
	Out.ar(~bus[\reverb], sig * \rsend.kr(0.0));
}).add;

SynthDef(\aaa2, { | freq=220, amp=0.1 |
	var env, sig;

	freq = freq * [1.0, \detune.kr(1.015)] * LFNoise1.kr(\vibratofreq.kr(1.8)).range(\vibratodepth.kr(-0.2), 0.0).midiratio;
	freq = freq * LFSaw.kr(4 * l.tempo).exprange(1, 1).round(1);
	env = Env.perc(\atk.kr(0.1, 0.2), \rel.kr(1.0, 0.2), curve: \curve.kr(-3.0)).ar(2);

	//sig = NeoVarSawOsc.ar(freq * 1, \pw.kr(0.5), \waveshape.kr(0.5)) * amp;
	sig = VarSaw.ar(freq, mul: amp);
	//sig = ZOsc.ar(freq, \formantfreq.kr(91), \shape.kr(0.5)) * amp * 2.0;
	// sig = AnalogFoldOsc.ar(freq, \fold.kr(1.0)) * amp;
	//sig = sig +  HarmonicOsc.ar(freq, \firstharmonic.kr(1), Array.geom(16, 0.5, \grow.kr(0.85))) * amp * 0.5;

	sig = sig * env;
	sig = sig * LFSaw.kr(4 * l.tempo).exprange(0.25, 1);
	sig = DFM1.ar(sig, \lpfreq.kr(2000), \lpres.kr(0.1));
	sig = Balance2.ar(sig[0], sig[1], \pan.kr(0.0));

	Out.ar(~bus[\main], sig);
	Out.ar(~bus[\delay], sig * \dsend.kr(0.0));
	Out.ar(~bus[\reverb], sig * \rsend.kr(0.0));
}).add;

SynthDef(\aer, { |freq=220, amp=0.1, gate=0.5 |
	var env, sig;

	freq = freq * [1, 1.001];
	freq = freq * LFNoise1.kr(l.tempo / 15).range(-0.125, 0.02).midiratio;
	env = Env.perc(\atk.kr(0.1), \rel.kr(2.0)).ar(2);
	/*env = EnvGen.ar(
		Env.adsr(\atk.kr(0.02), \decay.kr(0.7), \sus.kr(0.15), \rel.kr(1.0)
		),
		gate, doneAction: Done.freeSelf
	);*/
	sig = VarSaw.ar(freq, width: 0.1, mul: amp);

	sig = sig + VarSaw.ar(freq * Rand(0.99, 1.005)* 1.5, width: 0.05, mul: amp * 0.48);
	sig = sig + PulseDPW.ar(freq * Rand(0.992, 1.005) * 0.5, mul: amp * 0.68);

	sig = DFM1.ar(sig, \lpfreq.kr(2500), \lpres.kr(0.55), noiselevel: 0.0001);

	sig = sig * env;

	Out.ar(~bus[\main], sig * \msend.kr(1.0));
	Out.ar(~bus[\reverb], sig * \rsend.kr(0.0));
	Out.ar(~bus[\delay], sig * \dsend.kr(0.0));
}).add;

SynthDef(\costero, { | freq=220, vel=0.5, width=0.5, t_gate=1 |
	var vcaenv, vcfenv;
	var amp;
	var sig;


	amp = vel / 4;

	vcaenv = EnvGen.ar(
		Env.perc(
			attackTime: \vcaatk.kr(0.01) * (vel + 0.01).reciprocal,
			//decayTime: \vcadecay.kr(0.3) + vel,
			//sustainLevel: \vcasus.kr(0.5) * vel,
			releaseTime: \vcarel.kr(1.0),
			curve: \vcacurve.kr(-4.0) * vel),
		t_gate, doneAction: Done.freeSelf
	);

	vcfenv = EnvGen.ar(
		Env.adsr(
			attackTime: \vcfatk.kr(0.01) * (vel + 0.01).reciprocal,
			decayTime: \vcfdecay.kr(0.3) + vel,
			sustainLevel: \vcfsus.kr(0.5) * vel,
			releaseTime: \vcfrel.kr(1.0),
			curve: \vcfcurve.kr(-4.0) * vel),
		t_gate, doneAction: 0
	);

	freq = freq * SinOsc.kr(\flutterfreq.kr(0.25) * l.tempo).range(\flutterdepth.kr(-0.35), 0.01).midiratio;
	// freq = freq!2;
	freq = freq * [1, 1.005];
	sig = VarSaw.ar(freq, 0, ( width * (4 * vcfenv + 1) ), amp);
	sig = sig + VarSaw.ar(freq * 2.0, 0, ( width * (4 * vcfenv + 1) ), amp * 0.25);


	sig = MoogVCF.ar(sig, ( \lpfreq.kr(2000) * ( 10 * vcfenv + 1)), \lpres.kr(0.1));
	sig = sig * vcaenv * \trim.kr(1.0);

	Out.ar(~bus[\main], sig * \main.kr(1.0));
	Out.ar(~bus[\reverb], sig * \rsend.kr(0.0));
	Out.ar(~bus[\delay], sig * \dsend.kr(0.0));
}).add;

SynthDef(\analogfold, { | freq=220, amp=0.1 |
	var env, sig;

	freq = freq * [1.0, 1.005] * LFNoise1.kr(\vibratofreq.kr(1.8)).range(\vibratodepth.kr(-0.2), 0.0).midiratio;
	freq = freq * LFSaw.kr(4 * l.tempo).exprange(1, 2).round(1);
	env = Env.perc(\atk.kr(0.1, 0.2), \rel.kr(1.0, 0.2), curve: \curve.kr(-3.0)).ar(2);

	//sig = NeoVarSawOsc.ar(freq, \pw.kr(0.5), \waveshape.kr(0.5)) * amp;
	//sig = ZOsc.ar(freq, \formantfreq.kr(91), \shape.kr(0.5)) * amp;
	sig = AnalogFoldOsc.ar(freq, \fold.kr(1.0)) * amp;
	//sig = HarmonicOsc.ar(freq, \firstharmonic.kr(1), Array.geom(16, 0.5, \grow.kr(0.85))) * amp;

	sig = sig * env;

	sig = DFM1.ar(sig, \lpfreq.kr(2000), \lpres.kr(0.1));
	sig = Balance2.ar(sig[0], sig[1], \pan.kr(0.0));

	Out.ar(~bus[\main], sig);
	Out.ar(~bus[\delay], sig * \ampDelay.kr(0.0));
}).add;


SynthDef(\brown, { | amp=0.1 |
	var env, sig;

	env = Env.perc(\atk.kr(0.01), \rel.kr(0.25)).ar(2);

	sig = BrownNoise.ar(amp) * env;

	sig = BPF.ar(sig, \bpfreq.kr(440), \rq.kr(1.0));


	sig = Pan2.ar(sig, \pan.kr(0.0));
	Out.ar(~bus[\main], sig);
	Out.ar(~bus[\reverb], sig * \reverbAmp.kr(0.0));
}).add;

SynthDef(\complex, { | freq=220, amp=0.1, t_gate=1 |
	var gate, lpgate;
	var env, sig;

	gate = Trig1.kr(t_gate, \dur.kr(0.2));

	env = EnvGen.ar(
		Env.adsr(\atk.kr(0.01), \decay.kr(0.25), \sus.kr(0.5), \rel.kr(1.0)),
		gate,
		doneAction: 2
	);

	freq = freq * [1.0, \detune.kr(0.99)];

	freq = freq * LFNoise1.kr(1.5 * l.tempo).range(0.98, 1.01);

	sig = VarSaw.ar(freq, width: \width.kr(0.1), mul: amp);

	sig = Fold.ar(sig, -0.2, 0.5);


	lpgate = EnvGen.kr(Env.adsr(
		\atklpg.kr(0.3), 0.25, 0.3, 0.25), gate, doneAction: 0);
	sig = LPG.ar(sig, controlinput: lpgate, controloffset: 0.1, controlscale: 1.2, vca: 1, resonance: 1.7, lowpassmode: 1);


	sig = sig * env;
	sig = MoogVCF.ar(sig, \lpfreq.kr(1500), \lpres.kr(0.01));

	sig = AnalogVintageDistortion.ar(sig, drivegain: \drive.kr(0.6), bias: \bias.kr(0.1)) * 0.3;

	sig = Balance2.ar(sig[0], sig[1], \pan.kr(0.0));

	Out.ar(~bus[\main], sig);

	Out.ar(~bus[\reverb], sig * \rsend.kr(0.0));
	Out.ar(~bus[\delay], sig * \dsend.kr(0.0));
	//Out.ar(~bus[\fbdelay], sig * \fbdelay.kr(0.0));
}).add;

SynthDef(\filmbass, { | freq=220,  amp=0.1, pan=0.0, t_trig=1|
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
	Out.ar(~bus[\main], sig);
	Out.ar(~bus[\reverb], sig * \rsend.kr(0.0));
	Out.ar(~bus[\delay], sig * \dsend.kr(0.0));


}).add;

SynthDef(\filmbassOld, { | freq=220,  amp=0.1, pan=0.0|
	var env, sig;
	env = Env.perc(\atk.kr(0.001), \rel.kr(0.5), curve: -8).ar(2);

	freq = freq * [1, \detune.kr(1.015)];
	sig = SinOscFB.ar(freq, \feedback.kr(0.0), amp);

	sig = sig + VarSaw.ar(freq * 2, width: \width.kr(0.5), mul: amp * 0.5);

	sig = sig * env;
	sig = MoogVCF.ar(sig, \lpfreq.kr(5500), \lpres.kr(0.01));

	sig = AnalogVintageDistortion.ar(sig, \drive.kr(0.1), \bias.kr(0.0), \low.kr(0.1), \high.kr(0.1)) * 0.1;
	sig = Balance2.ar(sig[0], sig[1], pan);
	Out.ar(~bus[\main], sig);
	Out.ar(~bus[\reverb], sig * \rsend.kr(0.0));
	Out.ar(~bus[\delay], sig * \dsend.kr(0.0));


}).add;

SynthDef(\nuevokick, { | amp=0.1, t_trig=1 |
	var env, sig;
	env = Env.perc(\atk.kr(0.01, \rel.kr(0.25))).ar(2);

	// sig = AnalogSnareDrum.ar(trig: t_trig, infsustain: 0.8, accent: 0.1, freq: \freq.kr(200), tone: 0.5, decay: 0.5, snappy: 0.5) * amp;

	sig = AnalogBassDrum.ar(trig: t_trig, infsustain: 0.0, accent: \accent.kr(0.5), freq: \freq.kr(50), tone: 0.5, decay: 0.5, attackfm: 0.5, selffm: 0.35 ) * amp;
	sig = sig * env;
	sig = MoogVCF.ar(sig, \lpfreq.kr(3500), \lpres.kr(0.2));
	sig = AnalogVintageDistortion.ar(sig, drivegain: \drive.kr(0.1), bias: \bias.kr(0.2), lowgain: 0.8, highgain: 0.1, shelvingfreq: 50, oversample: 0) * 1.0;

	sig = Pan2.ar(sig, \pan.kr(0.0));

	Out.ar(~bus[\main], sig);

}).add;

SynthDef(\nuevosnare, { | amp=0.1, t_trig=1 |
	var env, sig;
	env = Env.perc(\atk.kr(0.001, \rel.kr(0.25))).ar(2);

	sig = AnalogSnareDrum.ar(trig: t_trig, infsustain: 0.8, accent: 0.1, freq: \freq.kr(300), tone: 0.5, decay: 0.5, snappy: 0.5) * amp;

	sig = sig * env;
	sig = DCompressor.ar(sig, ratio: \ratio.kr(4), threshold: \threshold.kr(-40), attack: \compatk.kr(0.1),release: \comprel.kr(100.0), makeup: \makeup.kr(0.5));
	sig = AnalogVintageDistortion.ar(sig, drivegain: \drive.kr(0.1), bias: 0.2, lowgain: 0.1, highgain: 0.1, shelvingfreq: 600, oversample: 0) * 0.1;

	sig = Pan2.ar(sig, \pan.kr(0.0));

	Out.ar(~bus[\main], sig);
	Out.ar(~bus[\reverb], sig * \rsend.kr(0.0));

}).add;

SynthDef(\discreet, { | freq=220, amp=0.1, t_gate=1, width=0.4 |
	var env, osc1, osc2, osc3, noise, sig;
	var lfo1 = Ndef(\lfo1).ar;


	freq = freq * [1, \detune.kr(1.005)];

	width = width * (lfo1 - \shiftwidth.kr(0, 0.5)).exprange(0.1, 1.0);

	env = Env.new([0, 1, \sus.kr(0.5), 0], [\atk.kr(0.8), \decay.kr(0.25), \rel.kr(5.3)], 'squared').ar(2);
	osc3 = VarSaw.ar(freq / 128);

	osc1 = SinOsc.ar((freq * 1) * osc3.range(-0.2, 0.01).midiratio, mul: amp * 0.5) + VarSaw.ar(( freq  * 1) * osc3.range(-0.2, 0.01).midiratio, width: width, mul: amp * 0.5);
	osc1 = osc1 +  SinOsc.ar((freq * 2) * osc3.range(-0.2, 0.01).midiratio, mul: amp * 0.25) + VarSaw.ar(( freq  * 1.5) * osc3.range(-0.2, 0.01).midiratio, width: width, mul: amp * 0.25);
	osc2 = VarSaw.ar(freq * osc3.range(-0.2, 0.01).midiratio, width: width, mul: amp);

	noise = BrownNoise.ar(0.0005);



	sig = ( osc1 * \osc1.kr(1.0) ) + ( osc2 * \osc2.kr(1.0) ) + ( noise * \noise.kr(1.0) );

	sig = sig * LFTri.ar(\ampmodfreq.kr(2.5, 0.2)).exprange(\ampmoddepth.kr(0.99, 0.5), 1);

	sig = DFM1.ar( sig, \lpfreq.kr(2000) * lfo1.exprange(0.5, 1.5), \lpres.kr(0.01), noiselevel: \filternoise.kr(0.0000));
	sig = HPF.ar(sig, \hpfreq.kr(90.0));

	sig = ( (sig * env) * \saturation.kr(1.0)).tanh * \attenuation.kr(1.0);

	sig = Pan2.ar(sig.sum, \pan.kr(0.0));
	Out.ar(~bus[\main], sig * \dryAmp.kr(1.0));
	Out.ar(~bus[\reverb], sig * \rsend.kr(0.0));
	Out.ar(~bus[\delay], sig * \dsend.kr(0.0));
	//Out.ar(~busChorus, sig * \chorusAmp.kr(0.0));

}).add;


SynthDef(\discreet2, { | freq=220, amp=0.1, t_gate=1, width=0.4 |
	var gate;
	var env, osc1, osc2, osc3, noise, sig;
	var lfo1 = Ndef(\lfo1).ar;


	freq = freq * [1, \detune.kr(1.005)];


	width = width * (lfo1 - \shiftwidth.kr(0, 0.5)).exprange(0.1, 1.0);

	gate = Trig1.kr(t_gate, \dur.kr(0.1));
	env = EnvGen.ar(
		Env.adsr(\atk.kr(0.1), \decay.kr(0.3), \sus.kr(0.3), \rel.kr(1.0)),
		gate, doneAction: 2
	);
	osc3 = VarSaw.ar(freq / 128);

	osc1 = SinOsc.ar((freq * 1) * osc3.range(-0.2, 0.01).midiratio, mul: amp * 0.5) + VarSaw.ar(( freq  * 1) * osc3.range(-0.2, 0.01).midiratio, width: width, mul: amp * 0.5);
	osc1 = osc1 +  SinOsc.ar((freq * 2) * osc3.range(-0.2, 0.01).midiratio, mul: amp * 0.25) + VarSaw.ar(( freq  * 1.5) * osc3.range(-0.2, 0.01).midiratio, width: width, mul: amp * 0.25);
	osc2 = VarSaw.ar(freq * osc3.range(-0.2, 0.01).midiratio, width: width, mul: amp);

	noise = BrownNoise.ar(0.0005);



	sig = ( osc1 * \osc1.kr(1.0) ) + ( osc2 * \osc2.kr(1.0) ) + ( noise * \noise.kr(1.0) );

	sig = sig * LFTri.ar(\ampmodfreq.kr(2.5, 0.2)).exprange(\ampmoddepth.kr(0.99, 0.5), 1);

	sig = DFM1.ar( sig, \lpfreq.kr(2000) * lfo1.exprange(0.5, 1.5), \lpres.kr(0.01), noiselevel: \filternoise.kr(0.0000));
	sig = HPF.ar(sig, \hpfreq.kr(90.0));

	//sig = ( (sig * env) * \saturation.kr(1.0)).tanh * \attenuation.kr(1.0);

	sig = AnalogVintageDistortion.ar(sig, \drive.kr(0.0), \bias.kr(0.0)) * 0.1;
	sig = Pan2.ar(sig.sum, \pan.kr(0.0));
	Out.ar(~bus[\main], sig * \dryAmp.kr(1.0));
	Out.ar(~bus[\reverb], sig * \rsend.kr(0.0));
	Out.ar(~bus[\delay], sig * \dsend.kr(0.0));
	//Out.ar(~busChorus, sig * \chorusAmp.kr(0.0));

}).add;

SynthDef(\discreet3, { | freq=220, amp=0.1, t_gate=1, width=0.4 |
	var env, osc1, osc2, osc3, noise, sig, gate;
	var lfo1 = Ndef(\lfo1).ar;


	freq = freq * [1, \detune.kr(1.005)];

	freq = freq * LFTri.kr(\vibratofreq.kr(2) * l.tempo).bipolar(\vibratodepth.kr(0.0)).midiratio;

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

	sig = sig * LFTri.ar(\ampmodfreq.kr(2.5, 0.2) * l.tempo).exprange(\ampmoddepth.kr(0.99, 0.5), 1);

	sig = DFM1.ar( sig, \lpfreq.kr(2000) * lfo1.exprange(0.5, 1.5), \lpres.kr(0.01), noiselevel: \filternoise.kr(0.0000));
	sig = HPF.ar(sig, \hpfreq.kr(90.0));

	sig = AnalogVintageDistortion.ar(sig * 0.08, \drive.kr(0.0), \bias.kr(0.0));

	sig = sig * ( env );
	sig = Pan2.ar(sig.sum, \pan.kr(0.0));
	Out.ar(~bus[\main], sig * \dryAmp.kr(1.0));
	Out.ar(~bus[\reverb], sig * \rsend.kr(0.0));
	Out.ar(~bus[\delay], sig * \dsend.kr(0.0));
	//Out.ar(~busChorus, sig * \chorusAmp.kr(0.0));

}).add;



SynthDef(\discreet4, { | freq=220, amp=0.1, t_gate=1, width=0.4 |
	var env, osc1, osc2, osc3, noise, sig, gate;
	var lfo1 = Ndef(\lfo1).ar;
	var phase =

	freq = freq * [1, \detune.kr(1.005)];

	freq = freq * LFSaw.kr(\arp.kr(0.5) * l.tempo).exprange(0.5, 2.5).round(0.5);

	freq = Select.kr(\modType.ir(0), [
		freq * LFTri.kr(\vibratofreq.kr(2) * l.tempo).bipolar(\vibratodepth.kr(0.0)).midiratio,
		freq * LFSaw.kr(\vibratofreq.kr(2) * l.tempo).bipolar(\vibratodepth.kr(0.0)).midiratio,
		freq * LFPulse.kr(\vibratofreq.kr(2) * l.tempo).bipolar(\vibratodepth.kr(0.0)).midiratio,
		freq * LFSaw.kr(\vibratofreq.kr(2) * l.tempo, 3.14).bipolar(\vibratodepth.kr(0.0)).midiratio,
		freq
	]);

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

	sig = sig * LFTri.ar(\ampmodfreq.kr(2.5, 0.2) * l.tempo).exprange(\ampmoddepth.kr(0.99, 0.5), 1);

	sig = DFM1.ar( sig, \lpfreq.kr(2000) * lfo1.exprange(0.5, 1.5), \lpres.kr(0.01), noiselevel: \filternoise.kr(0.0000));
	sig = HPF.ar(sig, \hpfreq.kr(90.0));

	sig = AnalogVintageDistortion.ar(sig * 0.08, \drive.kr(0.0), \bias.kr(0.0));

	sig = sig * ( env );
	sig = sig * \trim.kr(1.0);
	sig = Pan2.ar(sig.sum, \pan.kr(0.0));
	Out.ar(~bus[\main], sig * \dryAmp.kr(1.0));
	Out.ar(~bus[\reverb], sig * \rsend.kr(0.0));
	Out.ar(~bus[\delay], sig * \dsend.kr(0.0));
	//Out.ar(~busChorus, sig * \chorusAmp.kr(0.0));

}).add;


SynthDef(\dreamy, { | freq=220, amp=0.1, pan=0.0, nSynths=8 |
	var env, sig;
	env = Env.perc(\atk.kr(0.01), \rel.kr(0.5), curve: -4).ar(2);

	freq = ( freq * [1, \detune.kr(1.01)] ) * LFNoise1.kr(\flutter.kr(0.125)).range(\flutterDepth.kr(-0.3), 0.00).midiratio;

	//freq = freq * SinOsc.kr(\freqlfo.kr(1.125), Rand(0, 2pi)).range(\freqlfoDepth.kr(0.975), 1.005);

	//freq = freq * Env.perc(0.25, 2.7).kr(0).range(0.325, 0.0).midiratio;

	sig = VarSaw.ar(freq, 2pi, \width.kr(0.01), mul: amp);

	nSynths.do{ | i |

		freq = freq * rrand(-0.01, 0.01);
		sig = sig + LFPulse.ar(freq * ((1 * i) + 2),  width: \widthpulse.kr(0.1), mul: (amp / (i  + 0.5)))

	};



	//sig = Splay.ar(sig);
	//sig = Pan2.ar(sig.sum, pan);
	sig = sig * env;

	sig = sig * Saw.kr(\ampmodfreq.kr(2)).exprange(\ampmoddepth.kr(0.19), 0.99);
	//sig = (sig * \saturation.kr(1.0) * \saturationLC.kr(1.0)).tanh * \attenuation.kr(1.0);
	sig = MoogVCF.ar(sig, \lpfreq.kr(900) * Env.perc(0.1, 2.5).kr(0).exprange(10, 1), \lpres.kr(0.6));
	sig = HPF.ar(sig, 40);
	sig = AnalogVintageDistortion.ar(
		sig, \drive.kr(0.0), \bias.kr(0.0), \low.kr(0.0), \high.kr(0.0)
	) * 0.2;


	//sig = LeakDC.ar(sig);
	sig = Balance2.ar(sig[0], sig[1], pan);
	//Out.ar(\out.kr(0), sig);
	Out.ar(~bus[\main], sig);
	Out.ar(~bus[\reverb], sig * \rsend.kr(0.0));
	Out.ar(~bus[\delay], sig * \dsend.kr(0.0));

}).add;

SynthDef(\dreamy2, { | freq=220, amp=0.1, pan=0.0, nSynths=8, t_trig=1 |
	var env, sig;
	//env = Env.perc(\atk.kr(0.01), \rel.kr(0.5), curve: -4).ar(2);
	env = EnvGen.ar(
		Env.adsr(\atk.kr(0.01), \decay.kr(0.3), \sus.kr(0.5), \rel.kr(0.5)),
		Trig1.kr(t_trig, \dur.kr(0.25)),
		doneAction: 2
	);

	freq = ( freq * [1, \detune.kr(1.01)] ) * LFNoise1.kr(\flutter.kr(4) * l.tempo).range(\flutterDepth.kr(-0.5), 0.00).midiratio;

	//freq = freq * SinOsc.kr(\freqlfo.kr(1.125), Rand(0, 2pi)).range(\freqlfoDepth.kr(0.975), 1.005);

	//freq = freq * Env.perc(0.25, 2.7).kr(0).range(0.325, 0.0).midiratio;

	sig = VarSaw.ar(freq, 2pi, \width.kr(0.01), mul: amp);

	nSynths.do{ | i |

		freq = freq * rrand(-0.01, 0.01);
		sig = sig + LFPulse.ar(freq * ((1 * i) + 2),  width: \widthpulse.kr(0.6), mul: (amp / (i  + 0.5)))

	};



	//sig = Splay.ar(sig);
	//sig = Pan2.ar(sig.sum, pan);
	sig = sig * env;

	sig = sig * Saw.kr(\ampmodfreq.kr(2)).exprange(\ampmoddepth.kr(0.19), 0.99);
	//sig = (sig * \saturation.kr(1.0) * \saturationLC.kr(1.0)).tanh * \attenuation.kr(1.0);
	sig = MoogVCF.ar(sig, \lpfreq.kr(1500), \lpres.kr(0.1));
	sig = HPF.ar(sig, 40);
	sig = AnalogVintageDistortion.ar(
		sig, \drive.kr(0.0), \bias.kr(0.0), \low.kr(0.0), \high.kr(0.0)
	) * 0.2;


	//sig = LeakDC.ar(sig);
	sig = Balance2.ar(sig[0], sig[1], pan);
	//Out.ar(\out.kr(0), sig);
	Out.ar(~bus[\main], sig);
	Out.ar(~bus[\reverb], sig * \rsend.kr(0.0));
	Out.ar(~bus[\delay], sig * \dsend.kr(0.0));

}).add;

SynthDef(\dreamyChorus, { | freq=220, amp=0.1, pan=0.0, nSynths=0, numDelays=12 |
	var env, sig, envEnv;
	var rel = \rel.kr(0.5);
	var modulators;

	env = Env.perc(\atk.kr(0.01), rel, curve: -2).ar(0);
	envEnv = Env.perc(0.001, rel + 2.0).ar(2);

	freq = ( freq * [1, \detune.kr(1.001)] ) * LFNoise1.kr(\flutter.kr(0.125)).range(\flutterDepth.kr(-0.2), 0.01).midiratio;

	freq = freq * Env.perc.kr(0.5, 2.7).range(0.125, 0.0).midiratio;

	sig = VarSaw.ar(freq, Rand(0, 2pi), mul: amp);

	/*nSynths.do{ | i |
		sig = sig + VarSaw.ar(freq * (3 * i + 2), Rand(0, 2pi), Rand(0.01, 1), mul: (amp / (i + 1)))
	};
	*/
	nSynths.do{ | i |

		freq = freq * rrand(-0.01, 0.01);
		sig = sig + VarSaw.ar(freq * (1 * i + 5), Rand(0, 2pi), Rand(0.01, 1), mul: (amp / ((0.9 * i)  + 1.0)))
	};

	modulators = Array.fill(12, { |i|
		LFPar.kr(\chSpeed.kr(0.05), rrand(0.95, 1.03), \chDepth.kr(0.1), \chPredelay.kr(0.08));
	});

	//sig = DelayC.ar(sig, 0.5, modulators);
	//sig = Splay.ar(sig);

	//sig = Balance2.ar(sig[0], sig[1], pan);
	sig = sig * env;

	sig = sig * LFTri.kr(\ampModFreq.kr(2)).exprange(\ampModDepth.kr(0.99), 0.99);
	sig = sig * envEnv;
	sig = DelayC.ar(sig, 0.5, modulators);
	sig = Pan2.ar(sig.sum, pan);
	sig = MoogVCF.ar(sig, \lpfreq.kr(500) * Env.linen.kr(0.2, 4.5).exprange(4, 1), \lpres.kr(0.2));
	sig = HPF.ar(sig, 110);




	sig = (sig * \saturation.kr(1.0)).tanh * \attenuation.kr(1.0);



	Out.ar(0, sig);
	Out.ar(~bus[\reverb], sig * \reverbAmp.kr(0.0));
	Out.ar(~bus[\delay], sig * \delayAmp.kr(0.0));

}).add;


SynthDef(\bass, { | freq=220,  amp=0.1, pan=0.0|
	var env, sig;
	env = Env.perc(\atk.kr(0.001), \rel.kr(0.5), curve: -8).ar(2);

	freq = freq * [1, \detune.kr(1.015)];
	sig = SinOscFB.ar(freq, \feedback.kr(0.0), amp);

	sig = sig * env;
	sig = MoogVCF.ar(sig, \lpfreq.kr(5500), \lpres.kr(0.01));
	sig = (sig * \saturation.kr(1.0)).tanh * \attenuation.kr(1.0);
	sig = Balance2.ar(sig[0], sig[1], pan);
	Out.ar(~bus[\main], sig);
	Out.ar(~bus[\delay], sig * \delayAmp.kr(0.0));


}).add;

SynthDef(\infernoise1, { | freq=220, amp=0.1, t_trig=1 |
	var env, gate, sig;

	gate = Trig1.kr(t_trig, \dur.kr(2.2));

	env = EnvGen.ar(
		Env.adsr(\atk.kr(2.9), \decay.kr(0.4), \sus.kr(0.5), \rel.kr(4.5)),
		gate,
		doneAction: 2
	);

	freq = freq * Rand(0.9985, 1.0025);

	freq = freq * LFNoise1.ar(2 * l.tempo).range(0.98, 1.01);

	freq = freq * [14, 7, 0, 7, 14].midiratio;
	amp =  ( amp * [0.65, 0.8, 1.0, 0.8, 0.65]) * SinOsc.kr(\ampmodfreq.kr(1.0) * [4, 3, 2, 1, 2, 1, 4, 0.5] * l.tempo).exprange(-20.dbamp, 1.0);

	sig = VarSaw.ar(freq, width: SinOsc.kr(0.5 * l.tempo, Rand(0, 2pi)).range(0.01, 0.25), mul: amp);

	sig = Splay.ar(sig);

	sig = sig + BrownNoise.ar(amp * 0.02);
	sig = sig * env;
	sig = Balance2.ar(sig[0], sig[1], Rand(-0.5, 0.5));


	sig = MoogVCF.ar(sig, \lpfreq.kr(4000), \lpres.kr(0.1));

	sig = sig * SinOsc.ar(2 * l.tempo).exprange(-20.dbamp, 1.0);

	sig = AnalogVintageDistortion.ar(
		sig, \drive.kr(0.94), \bias.kr(0.05)
	) * 0.2;

	Out.ar(~bus[\main], sig);
	Out.ar(~bus[\reverb], sig * \rsend.kr(0.0));
	Out.ar(~bus[\delay], sig * \dsend.kr(1.2));

}).add;


SynthDef(\infernoise2, { | freq=220, amp=0.1, t_trig=1 |
	var env, gate, sig;

	gate = Trig1.kr(t_trig, \dur.kr(2.2));

	env = EnvGen.ar(
		Env.adsr(\atk.kr(2.9), \decay.kr(0.4), \sus.kr(0.5), \rel.kr(4.5)),
		gate,
		doneAction: 2
	);

	freq = freq * Rand(0.9985, 1.0025);

	freq = freq * LFNoise1.ar(2 * l.tempo).range(0.98, 1.01);
	freq = freq * [14, 7, 0, 7, 14].midiratio;
	amp =  ( amp * [0.65, 0.8, 1.0, 0.8, 0.65]) * SinOsc.kr(\ampmodfreq.kr(1.0) * [2, 1, 2, 1, 1, 1, 2] * l.tempo).exprange(-20.dbamp, 1.0);

	sig = Saw.ar(freq, mul: amp);

	sig = Splay.ar(sig);

	sig = sig + BrownNoise.ar(amp * 0.01);
	sig = sig * env;
	sig = Balance2.ar(sig[0], sig[1], Rand(-0.5, 0.5));


	sig = MoogVCF.ar(sig, \lpfreq.kr(4000), \lpres.kr(0.1));

	//sig = sig * SinOsc.ar(4.5).exprange(-10.dbamp, 1.0);

	sig = AnalogVintageDistortion.ar(
		sig, \drive.kr(0.94), \bias.kr(0.05)
	) * 0.2;

	Out.ar(~bus[\main], sig);
	Out.ar(~bus[\reverb], sig * \rsend.kr(0.0));
	Out.ar(~bus[\delay], sig * \dsend.kr(1.2));

}).add;

SynthDef(\kong, { | freq=220, amp=0.1 |
	var env, sig;
	var lfo = Ndef(\lfo1).ar;

	env = Env.perc(\atk.kr(0.01), \rel.kr(1.0)).ar(2);

	freq = freq * [1, \detune.kr(1.01)];
	//freq = freq * SinOsc.kr(0.35, Rand(0, pi)).range(-0.25, 0.05).midiratio;
	freq = freq * lfo.range(-0.45, 0.05).midiratio;

	sig = AnalogFoldOsc.ar(freq, \fold.kr(1.0));

	sig = AnalogVintageDistortion.ar(sig, drivegain: 1.2, bias: 0.4, lowgain: 0.3,highgain: 0.1, shelvingfreq: 600, oversample: 1 );
	sig = ( sig * amp) * env;

	sig = MoogVCF.ar(sig, \lpfreq.kr(2500), \lpres.kr(0.01));

	//sig = sig * LFTri.ar(\tremelospeed.kr(8) * l.tempo).exprange(\tremolodepth.kr(-12.dbamp), 1.0);

	sig = Balance2.ar(sig[0], sig[1], \pan.kr(0.0));

	//sig = ( sig * \saturation.kr(1.0) ).tanh * \attenuation.kr(1.0);

	Out.ar(~bus[\main], sig);
	Out.ar(~bus[\delay], sig * \delayAmp.kr(0.0));
	Out.ar(~bus[\reverb], sig * \reverbAmp.kr(0.0));

}).add;

SynthDef(\otroinvert, { | freq=220, amp=0.1 |
	var env, sig;

	env = Env.perc(\atk.kr(2.0), \rel.kr(0.1), curve: \curve.kr(-4.5)).ar(2);

	freq = freq * [1, \detune.kr(1.01)];
	freq = freq * SinOsc.ar(80.25, Rand(0, 2pi)).range(-2, 0.05).midiratio;
	sig = VarSaw.ar(freq, width: \width.kr(0.5), mul: amp);
	sig = sig + VarSaw.ar(freq * 1.5, Rand(0, 2pi), width: 0.5, mul: amp * 0.3);

	sig = sig + BrownNoise.ar(amp * 0.1);
	//sig = SinOsc.ar(freq, mul: amp);
	sig = MoogVCF.ar(sig, \lpfreq.kr(2500), \lpres.kr(0.1));

	sig = AnalogVintageDistortion.ar(
		sig,
		drivegain: \drive.kr(0.5),
		bias: \bias.kr(0.0),
		lowgain: 0.1,
		highgain: 0.1
	) * 1.4;
	sig = sig * env;

	sig = Pan2.ar(sig.mean, \pan.kr(0.0));
	sig = LeakDC.ar(sig);

	Out.ar(~bus[\main], sig);
	Out.ar(~bus[\reverb], sig * \rsend.kr(0.0));
	Out.ar(~bus[\delay], sig * \dsend.kr(0.0));

}).add;

SynthDef(\sinoscfb, { | freq=220,  amp=0.1, pan=0.0, feedback=0.0 |
	var env, sig;
	var lfo;

	lfo = Ndef(\lfo1).ar;
	env = Env.perc(\atk.kr(0.001), \rel.kr(0.5), curve: -8).ar(2);

	freq = freq * [1.0, \detune.kr(1.0)];
	sig = SinOscFB.ar(freq, feedback, amp);

	sig = sig + AnalogFoldOsc.ar(freq * \freqmulFold.kr(1.0), amp * \ampFold.kr(0.0));

	// sig = sig + SinOscFB.ar(freq * 1, feedback, amp * 0.15);

	sig = sig * env;
	sig = DCompressor.ar(input: sig, attack: 3.0, threshold: -20);
	sig = MoogVCF.ar(sig, \lpfreq.kr(5500) * lfo.exprange(0.25, 3.0), \lpres.kr(0.3) * lfo.range(1.5, 1));
	sig = AnalogVintageDistortion.ar(sig, \drive.kr(0.0), \bias.kr(0.0), \low.kr(0.0), \high.kr(0.0)) * 0.1;
	sig = Balance2.ar(sig[0], sig[1], pan);
	Out.ar(~bus[\main], sig);
	Out.ar(~bus[\delay], sig * \delayAmp.kr(0.0));


}).add;

SynthDef(\neutron, { | freq=220, amp=0.1, pan=0.0 |
	var env, sig;
	var freq_amp_coeff;
	var lfo1 = Ndef(\lfonoise).kr;
	freq = freq * LFNoise1.kr(4.2).range(-0.25, 0.001).midiratio;
	//freq = freq * lfo1.range(-0.25, 0.001).midiratio;
	env = Env.perc(\atk.kr(0.01), \rel.kr(0.25), curve: \curve.kr(-5.0)).ar(2);

	//freq = freq * [1, 0.99];
	sig = SinOscFB.ar(freq, \feedback.kr(0.0), amp);

	sig = sig + SinOsc.ar(freq * 0.5, mul: (0.125 * amp));

	freq_amp_coeff = 270 * freq.reciprocal;
	amp = amp * freq_amp_coeff;
	sig = sig + VarSaw.ar((freq * \varharmonic.kr(2.0)) * rrand(0.997, 1.0015), {[0, pi / 2, pi, 3pi/ 4].choose}, \width.kr(0.5), amp * 0.15);


	sig = sig * LFPulse.kr(\ampModFreq.kr(4.0)).exprange(\ampModDepth.kr(0.99), 0.99);
	sig = Pan2.ar(sig, pan);

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
			decayTime: \decay.kr(0.2),
			sustainLevel: \sus.kr(0.25),
			releaseTime: \rel.kr(1.0)
		),
		gate,
		doneAction: 2
	);

	freq = freq * [1, \detune.kr(1.01)];
	freq = freq * LFNoise1.kr(4 * l.tempo).range(-0.25, 0.25).midiratio;
	sig = SinOscFB.ar(freq * 0.5, \feedback.kr(0.0), mul: amp);

	sig = sig + Pulse.ar(
		freq, \width.kr(0.12), mul: amp
	);

	lpgate = Env.perc(0.01,0.7).kr(0, gate: t_gate);

	sig = LPG.ar(sig, controlinput: lpgate, controloffset: 0.3, controlscale: 0.8, vca: 1,
		resonance: 1.4,
		lowpassmode: 1
	);

	sig = sig * env;

	sig = MoogVCF.ar(sig, \lpfreq.kr(4500), \lpres.kr(0.1));

	sig = AnalogVintageDistortion.ar(sig, \drive.kr(0.1), \bias.kr(0.1)) * 0.4;

	Out.ar(~bus[\main], sig);
	//Out.ar(~bus[\fbdelay], sig * \fbdelay.kr(0.0));
	Out.ar(~bus[\delay], sig * \dsend.kr(0.0));
}).add;

SynthDef(\soft, { | freq=220, amp=0.1, gate=1 |

	var env, sig;
	var lpfreqEnv;

	env = EnvGen.ar(Env.perc(\atk.kr(0.01), \rel.kr(0.5)), gate, doneAction: 2);
	lpfreqEnv = EnvGen.ar(Env.perc(3, 4), gate).range(\freqmod.kr(1.51), 1);

	//freq = freq * [0.5, 1, \detune.kr(1.01), 1.5, [2, 3, 4].choose];
	freq = freq * [1, \detune.kr(1.01)] * lpfreqEnv;
	freq = freq * LFNoise2.kr(\flutter.kr(2.5) * l.tempo).exprange(\flutterdepth.kr(0.985), 1.005);
	sig = VarSaw.ar(freq, \width.kr(0.5), mul: env.squared);
	sig = sig.sum * amp;

	//sig = ( sig * \saturation.kr(1) ).tanh * \attenuation.kr(1);
	sig = HPF.ar( MoogVCF.ar(sig, \lpfreq.kr(2000) * lpfreqEnv, \lpres.kr( 0.01 )), 40);
	sig = AnalogVintageDistortion.ar(sig, \drive.kr(0.0), \bias.kr(0.0), \low.kr(0.0), \high.kr(0.0)) * 0.2;
	//sig = Balance2.ar(sig[0], sig[1], \pan.kr(0.0));
	sig = sig * Saw.kr(\ampmoddepth.kr(0.125) * l.tempo).exprange(\ampmodepth.kr(0.99), 1.0);
	sig = Pan2.ar(sig, \pan.kr(0.0));

	Out.ar(~bus[\main], sig);
	Out.ar(~bus[\reverb], sig * \rsend.kr(0.0));
	Out.ar(~bus[\delay], sig * \dsend.kr(0.0));

}).add;

SynthDef(\tecno1, { | freq=220, amp=0.1, t_trig=1 |
	var env, gate, sig;

	freq = freq * 2;
	freq = freq * LFNoise1.kr(7.5).range(-0.55, 0.1).midiratio;
	freq = freq * SinOsc.kr(l.tempo * 4).range(1, \vibratodepth.kr(2)).round(1.0) ;


	gate = Trig1.ar(t_trig, 8 * l.tempo);
	env = EnvGen.ar(
		Env.adsr(\atk.kr(8 * l.tempo), \decay.kr(0.1), \sus.kr(0.5), \rel.kr(0.0)),
		gate,
		doneAction: 2
	);

	sig = VarSaw.ar(freq, width: LFNoise1.kr(7.5).exprange(0.5, 0.9), mul: amp);
	sig = VadimFilter.ar(sig * env, LFSaw.ar(l.tempo / 32).exprange(220, 2500), LFNoise1.kr(2.5).exprange(0.05, 0.2), type: 1);
	sig = Pan2.ar(sig, \pan.kr(0.0));
	Out.ar(~bus[\main], sig);
	Out.ar(~bus[\reverb], sig * \rsend.kr(1.0));
}).add;

SynthDef(\tecno12, { | freq=220, amp=0.1, t_trig=1 |
	var env, gate, sig;

	freq = freq * 1;
	freq = freq * LFNoise1.kr(7.5).range(-0.55, 0.1).midiratio;
	freq = freq * LFSaw.kr(l.tempo * 4.0).range(1, 3).round(1.0);


	gate = Trig1.ar(t_trig, 8 * l.tempo);
	env = EnvGen.ar(
		Env.adsr(\atk.kr(8 * l.tempo), \decay.kr(4), \sus.kr(0.5), \rel.kr(2)),
		gate,
		doneAction: 2
	);

	sig = VarSaw.ar(freq, width: LFNoise1.kr(7.5).exprange(0.5, 0.9), mul: amp);
	sig = Splay.ar(sig);
	sig = VadimFilter.ar(sig * env, SinOsc.ar(l.tempo * 2).exprange(1020, 3000), LFNoise1.kr(2.5).exprange(0.05, 0.2), type: 1);
	//sig = Pan2.ar(sig, \pan.kr(0.0));
	Out.ar(~bus[\main], sig);
	Out.ar(~bus[\reverb], sig * \rsend.kr(1.0));
}).add;



// vangelis


SynthDef(\vangelis, { | freq=220, amp=0.1 |
	var vca1, vcf1env, vca2, vcf2env;
	var sig, osc1, osc2;
	var lfo1, lfo2;

	//lfo1 = Ndef(\vangelisLFO1).ar;
	//lfo2 = Ndef(\vangelisLFO2).ar;
	lfo1 = Ndef(\vangelisLFO1).ar;
	lfo2 = Ndef(\vangelisLFO2).ar;
	vca1 = Env.new([0, 1, \susvca1.kr(0.5), 0], [\atkvca1.kr(0.5), \decayvca1.kr(0.7), \relvca1.kr(5.3)], 'squared').ar(2);
	vca1 = vca1 * lfo1.exprange(\vca1moddepth.kr(0.99), 0.99);
	vcf1env = Env.perc(\atkvcf1.kr(1.0), \relvcf1.kr(2.5)).ar(0);

	vca2 = Env.new([0, 1, \susvca2.kr(0.5), 0], [\atkvca2.kr(0.5), \decayvca2.kr(0.7), \relvca2.kr(5.3)], 'squared').ar(0);
	vca2 = vca2 * lfo2.exprange(\vca2moddepth.kr(0.99), 0.99);
	vcf2env = Env.perc(\atkvcf2.kr(0.01), \relvcf2.kr(1.5)).ar(0);

	freq = ( freq * [1.0, \detune.kr(0.99)]) * lfo1.range(\freqmoddepth.kr(0.0), 0.01).midiratio;
	osc1 = SawDPW.ar(freq, mul: amp) * vca1;
	osc2 = SawDPW.ar(freq, mul: amp) * vca2;


	osc1 = DFM1.ar(osc1,  \lpfreq1.kr(500) * vcf1env.range(1, 2), \lpres1.kr(0.1), noiselevel: 0.00000001);
	osc2 = DFM1.ar(osc2,  \lpfreq2.kr(2500) * vcf2env.range(1, 2), \lpres2.kr(0.1), noiselevel: 0.00000001);

	sig = DFM1.ar(osc1 + osc2, \lpfreq.kr(10000), \lpres.kr(0.01));
	sig = HPF.ar(osc1 + osc2, \hpfreq.kr(100));

	//sig = AnalogTape.ar(sig, \bias.kr(0.5), \tapesat.kr(0.75), \drive.kr(0.5), \oversample.kr(1.0));

	//sig = sig * Env.perc(\atk.kr(0.01), \rel.kr(1.5)).ar(0);

	sig = AnalogVintageDistortion.ar(sig, \drive.kr(0.0), \bias.kr(0.0), \low.kr(0.4), \high.kr(0.1)) * 0.1;

	Out.ar(~bus[\main], sig * \dry.kr(1.0));
	Out.ar(~bus[\delay], sig * \dsend.kr(0.0));
	Out.ar(~bus[\reverb], sig * \rsend.kr(0.0));
	//Out.ar(~busChorus, sig * \chorusAmp.kr(0.0));
}).add;

SynthDef(\harmonic, { | freq=220, amp=0.1 |
	var env, sig;

	freq = freq * [1.0, 1.015] * LFNoise1.kr(1.8).range(-0.2, 0.0).midiratio;

	freq = freq * LFSaw.kr(2.0 * l.tempo).exprange(1,6);
	env = Env.perc(\atk.kr(0.1, 0.2), \rel.kr(1.0, 0.2), curve: \curve.kr(-3.0)).ar(2);

	//sig = NeoVarSawOsc.ar(freq, \pw.kr(0.5), \waveshape.kr(0.5)) * amp;
	//sig = ZOsc.ar(freq, \formantfreq.kr(91), \shape.kr(0.5)) * amp;
	//sig = AnalogFoldOsc.ar(freq, \fold.kr(1.0)) * amp;
	sig = HarmonicOsc.ar(freq, \firstharmonic.kr(1), Array.geom(16, 0.5, \grow.kr(0.25))) * amp;

	sig = sig * env * amp;

	sig = DFM1.ar(sig, \lpfreq.kr(1000) * LFTri.kr(8 * l.tempo).exprange(1,4), \lpres.kr(0.5));

	sig = Balance2.ar(sig[0], sig[1], \pan.kr(0.0));
	Out.ar(~bus[\main], sig);
	Out.ar(~bus[\delay], sig * \dsend.kr(0.0));
	Out.ar(~bus[\reverb], sig * \rsend.kr(0.0));

}).add;

SynthDef(\analogfold, { | freq=220, amp=0.1 |
	var env, sig;

	freq = freq * [1.0, 1.005] * LFNoise1.kr(\vibratofreq.kr(1.8)).range(\vibratodepth.kr(-0.2), 0.0).midiratio;
	env = Env.perc(\atk.kr(0.1, 0.2), \rel.kr(1.0, 0.2), curve: \curve.kr(-3.0)).ar(2);

	//sig = NeoVarSawOsc.ar(freq, \pw.kr(0.5), \waveshape.kr(0.5)) * amp;
	//sig = ZOsc.ar(freq, \formantfreq.kr(91), \shape.kr(0.5)) * amp;
	sig = AnalogFoldOsc.ar(freq, \fold.kr(1.0)) * amp;
	//sig = HarmonicOsc.ar(freq, \firstharmonic.kr(1), Array.geom(16, 0.5, \grow.kr(0.85))) * amp;

	sig = sig * env;

	sig = DFM1.ar(sig, \lpfreq.kr(2000), \lpres.kr(0.1));
	sig = Balance2.ar(sig[0], sig[1], \pan.kr(0.0));

	Out.ar(~bus[\main], sig);
	Out.ar(~bus[\delay], sig * \ampDelay.kr(0.0));
}).add;

SynthDef(\westcoast, { | freq=220, amp=0.1, t_gate=1 |
	var env, sig;

	env = Env.perc(\atk.kr(0.01), \rel.kr(0.5)).ar(2);

	freq = freq * [1, \detune.kr(1.0)];
	freq = freq * LFNoise1.kr(2.5).range(\flutter.kr(-0.2), 0.05).midiratio;

	//sig = SinOsc.ar(freq, mul: amp);
	sig = SinOscFB.ar(freq, \feedback.kr(0.1), mul: amp);

	//sig = sig + SinOsc.ar( freq * 1.5 , mul: amp * 0.55);

	sig = SmoothFoldS2.ar(sig, \low.kr(-0.8), \high.kr(0.8));



	sig = Balance2.ar(sig[0], sig[1], \pan.kr(0.0));
	//sig = SmoothFoldQ.ar(sig, lo: -0.125, hi: 0.25, foldRange: SinOsc.kr(0.25).exprange(0.1, 1.0), smoothAmount: 0.2, delta: 1e-05);

	sig = DFM1.ar(sig, \lpfreq.kr(1000), \lpres.kr(0.1), noiselevel: \noiselevel.kr(0.00025));



	//sig = ( sig * \saturation.kr(1.0)) * \attenuation.kr(1.0);
	sig = AnalogVintageDistortion.ar(sig, \drive.kr(0.0), \bias.kr(0.0), \lowdist.kr(0.0), \highdist.kr(0.0)) * 0.7;
	//sig = HPF.ar(sig, 120);
	sig = sig * env;
	Out.ar(~bus[\main], sig);
	Out.ar(~bus[\reverb], sig * \rsend.kr(0.0));
	Out.ar(~bus[\delay], sig * \dsend.kr(0.0));


}).add;

"sintes".postln;
)


// nuevos sintes

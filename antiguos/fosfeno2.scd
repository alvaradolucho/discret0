// fosfeno 2
// nuevo 1

(
SynthDef(\nuevo1lead, { | freq=220, amp=0.1, pan=0.0 |
	var sig, mod, env;


	env = Env.perc(\atk.kr(0.01), \rel.kr(1.0), curve: \curve.kr(-4.0)).ar(2);

	freq = freq * [1.0, \detune.kr(1.0)];
	freq = freq * Rand(0.995, 1.005);
	freq = freq * LFTri.ar(4.5 / 8.0, Rand(0, 2pi)).range(-0.25, 0.0).midiratio;
	sig = ZOsc.ar(freq, \formantfreq.kr(91), \shape.kr(0.5)) * amp;
	sig = sig * env;
	sig = Balance2.ar(sig[0], sig[1], pan, amp);
	sig = MoogVCF.ar(sig, \lpfreq.kr(2500), \lpres.kr(0.01));
	sig = sig * LFTri.ar(4.5).range(0.15, 1.0);
	sig = HPF.ar(sig, 120);
	Out.ar(~bus[\main], sig);
	Out.ar(~bus[\reverb], sig * \rsend.kr(0.0));
	Out.ar(~bus[\delay], sig * \dsend.kr(0.0));
}).add;
)

// nuevo 2
~break2 = Buffer.readChannel(s, "C:/Users/Lucho Alvarado/Downloads/Dirt-Samples-master/Dirt-Samples-master/breaks125/015_sdstckbr.wav", channels:[0]);

(
SynthDef(\break, { | amp=0.6, t_gate=1, sustain=1, begin=0.0, end=1.0, freq=440,  speed=1, endSpeed=1, delta, cps, legato=1.0|
	var sig, env, bufnum;
	var rate, phase, sawrate, numFrames, startPos, bpm, dur;
	bufnum = ~break2.bufnum;
	bpm = cps * 60.0 * 4.0;
	rate = speed * BufRateScale.ir(bufnum);
	dur = delta / (3.3 * cps);
	dur = dur / rate;
	numFrames = max(BufFrames.ir(bufnum), 1);
	phase= Line.ar(begin, end, dur, doneAction: 0);
	 sig = BufRd.ar(
	 	numChannels: 1,
	 	bufnum: bufnum,
	 	phase: phase * numFrames,
	 	loop: 0,
	 	interpolation: 4 // cubic interpolation
	) * amp;
	// sig = sig.sum ;

	//rate.poll;
	// (end - begin).poll;
	// sig = PlayBuf.ar(1, bufnum, rate, startPos: (begin * numFrames), doneAction: 2);


	sig = MoogVCF.ar(sig,\lpfreq.kr(10000), \lpres.kr(0.02));
	env = EnvGen.ar(Env.linen(0, dur * legato, 0), doneAction: 2); // todo: check if control rate smoothens (shouldn't)

	sig = sig * env;
	sig = HPF.ar(sig, \hpfreq.kr(40));
	//sig = ( sig * \saturation.kr(0.dbamp)).tanh * \attenuation.kr(0.dbamp);
	sig = Pan2.ar(sig, \pan.kr(0.0));

	Out.ar(~bus[\main], sig);
	Out.ar(~bus[\reverb], sig * \rsend.kr(0.0));
	Out.ar(~bus[\delay], sig * \dsend.kr(0.0));
}).add;
)

~guitL = Buffer.readChannel(s, "C:/Users/Lucho Alvarado/Documents/Algos/set_mayo2022/samples/el_primero_original_130bpm/Chunks/guit_A.wav", channels:[0]);
~guitR = Buffer.readChannel(s, "C:/Users/Lucho Alvarado/Documents/Algos/set_mayo2022/samples/el_primero_original_130bpm/Chunks/guit_A.wav", channels:[1]);
~guitL_B = Buffer.readChannel(s, "C:/Users/Lucho Alvarado/Documents/Algos/set_mayo2022/samples/el_primero_original_130bpm/Chunks/guit_B.wav", channels:[0]);
~guitR_B = Buffer.readChannel(s, "C:/Users/Lucho Alvarado/Documents/Algos/set_mayo2022/samples/el_primero_original_130bpm/Chunks/guit_B.wav", channels:[1]);



(
SynthDef(\guitL, { | amp=0.6, t_gate=1, sustain=1, begin=0.0, end=1.0, freq=440,  speed=1, endSpeed=1, delta, cps, legato=1.0|
	var sig, env, bufnum;
	var rate, phase, sawrate, numFrames, startPos, bpm, dur;
	bufnum = ~guitL_B.bufnum;
	bpm = cps * 60.0 * 4.0;
	rate = speed * BufRateScale.ir(bufnum);
	dur = delta / (0.9 * cps);
	dur = dur / rate;
	numFrames = max(BufFrames.ir(bufnum), 1);
	phase= Line.ar(begin, end, dur, doneAction: 0);

	 sig = BufRd.ar(
	 	numChannels: 1,
	 	bufnum: bufnum,
	 	phase: phase * numFrames,
	 	loop: 0,
	 	interpolation: 4 // cubic interpolation
	) * amp;

	sig = MoogVCF.ar(sig,\lpfreq.kr(10000), \lpres.kr(0.02));
	env = EnvGen.ar(Env.linen(0.001, dur * legato, 0.01), doneAction: 2); // todo: check if control rate smoothens (shouldn't)

	sig = sig * env;
	sig = HPF.ar(sig, \hpfreq.kr(40));
	//sig = ( sig * \saturation.kr(0.dbamp)).tanh * \attenuation.kr(0.dbamp);
	sig = Pan2.ar(sig, \pan.kr(0.0));

	Out.ar(~bus[\main], sig);
	Out.ar(~bus[\reverb], sig * \rsend.kr(0.0));
	Out.ar(~bus[\delay], sig * \dsend.kr(0.0));
}).add;
SynthDef(\guitR, { | amp=0.6, t_gate=1, sustain=1, begin=0.0, end=1.0, freq=440,  speed=1, endSpeed=1, delta, cps, legato=1.0|
	var sig, env, bufnum;
	var rate, phase, sawrate, numFrames, startPos, bpm, dur;
	bufnum = ~guitR_B.bufnum;
	bpm = cps * 60.0 * 4.0;
	rate = speed * BufRateScale.ir(bufnum);
	dur = delta / (0.9 * cps);
	dur = dur / rate;
	numFrames = max(BufFrames.ir(bufnum), 1);
	phase= Line.ar(begin, end, dur, doneAction: 0);

	 sig = BufRd.ar(
	 	numChannels: 1,
	 	bufnum: bufnum,
	 	phase: phase * numFrames,
	 	loop: 0,
	 	interpolation: 4 // cubic interpolation
	) * amp;

	sig = MoogVCF.ar(sig,\lpfreq.kr(10000), \lpres.kr(0.02));
	env = EnvGen.ar(Env.linen(0, dur * legato, 0), doneAction: 2); // todo: check if control rate smoothens (shouldn't)

	sig = sig * env;
	sig = HPF.ar(sig, \hpfreq.kr(40));
	//sig = ( sig * \saturation.kr(0.dbamp)).tanh * \attenuation.kr(0.dbamp);
	sig = Pan2.ar(sig, \pan.kr(0.0));

	Out.ar(~bus[\main], sig);
	Out.ar(~bus[\reverb], sig * \rsend.kr(0.0));
	Out.ar(~bus[\delay], sig * \dsend.kr(0.0));
}).add;
)


~bajo = Buffer.readChannel(s, "C:/Users/Lucho Alvarado/Documents/Algos/set_mayo2022/samples/el_primero_original_130bpm/Chunks/bajo_A.wav", channels:[1]);
~bajo_B = Buffer.readChannel(s, "C:/Users/Lucho Alvarado/Documents/Algos/set_mayo2022/samples/el_primero_original_130bpm/Chunks/bajo_B.wav", channels:[1]);


(
SynthDef(\bajo, { | amp=0.6, t_gate=1, sustain=1, begin=0.0, end=1.0, freq=440,  speed=1, endSpeed=1, delta, cps, legato=1.0|
	var sig, env, bufnum;
	var rate, phase, sawrate, numFrames, startPos, bpm, dur;
	bufnum = ~bajo_B.bufnum;
	bpm = cps * 60.0 * 4.0;
	rate = speed * BufRateScale.ir(bufnum);
	dur = delta / (1.75 * cps);
	dur = dur / rate;
	numFrames = max(BufFrames.ir(bufnum), 1);
	phase= Line.ar(begin, end, dur, doneAction: 0);

	 sig = BufRd.ar(
	 	numChannels: 1,
	 	bufnum: bufnum,
	 	phase: phase * numFrames,
	 	loop: 0,
	 	interpolation: 4 // cubic interpolation
	) * amp;

	sig = MoogVCF.ar(sig,\lpfreq.kr(10000), \lpres.kr(0.02));
	env = EnvGen.ar(Env.linen(0, dur * legato, 0), doneAction: 2); // todo: check if control rate smoothens (shouldn't)

	sig = sig * env;
	sig = HPF.ar(sig, \hpfreq.kr(40));
	sig = ( sig * \saturation.kr(0.dbamp)).tanh * \attenuation.kr(0.dbamp);
	sig = Pan2.ar(sig, \pan.kr(0.0));

	Out.ar(~bus[\main], sig);
	Out.ar(~bus[\reverb], sig * \rsend.kr(0.0));
	Out.ar(~bus[\delay], sig * \dsend.kr(0.0));
}).add;
)

s.quit;
(
// audio desde input 3
~audioIn.free;

SynthDef(\audioin, { | amp = 0.1 |
	var sig;
	sig = SoundIn.ar(2);

	//sig = sig + (PitchShift.ar(sig,windowSize: 0.2, pitchRatio: 7,
	//	pitchDispersion: 0.1, timeDispersion: 0.1
	//) * 0.8);

	sig = Fold.ar(sig, -0.85, 0.85);
	sig = MoogVCF.ar(sig, \lpfreq.kr(10000), \lpres.kr(0.01));
	sig = Pan2.ar(sig, \pan.kr(0.0));

	sig = AnalogVintageDistortion.ar(
		input: sig * amp,
		drivegain: \drive.kr(0.1),
		bias: \bias.kr(0.0),
		lowgain: \low.kr(0.1),
		highgain: \high.kr(0.1)
	) * 0.05;




	Out.ar(~bus[\main], sig);
	Out.ar(~bus[\reverb], sig * \rsend.kr(0.0));
	Out.ar(~bus[\delay], sig * \dsend.kr(0.0));
}).add;

~audioIn = Synth(\audioin, [
	\amp, 1.2,
	\drive, 0.7,
	\bias, 0.05,
	\lpfreq, 10000, \lpres, 0.1,
	\low, 0.8, \high, 0.6,
	//\dsend, 0.9, \rsend, 0.9

],~src, 'addToHead')
)

s.quit;
(


)
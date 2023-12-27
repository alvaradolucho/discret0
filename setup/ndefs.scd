(
Ndef(\lfo1, { |freq=0.25|
	var sig;
	freq = freq * l.tempo;
	sig = SinOsc.ar(freq) * 0.5;

	});

Ndef(\lfonoise, { |freq=6.25|
	var sig;
	sig = LFNoise1.ar(freq);

	});

Ndef(\vangelisLFO1, { | freq=12.4 |
	var sig;
	sig = SinOsc.ar(freq);
	//sig = LFNoise1.ar(freq);
	sig;
});
Ndef(\vangelisLFO2, { | freq=12.4 |
	var sig;
	sig = SinOsc.ar(freq);
	//sig = LFPulse.ar(freq);
	//sig = LFNoise2.ar(freq);
	sig;
});

)

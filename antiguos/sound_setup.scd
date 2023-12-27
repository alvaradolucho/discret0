(
// main
~mainSynth.set(\drive, 0.3);
~mainSynth.set(\bias, 0.1);
~mainSynth.set(\saturation, 0.1);
~mainSynth.set(\lpfreq, 13000);


// reverb
// \damp, 0.25,
// \size 2.0,
// \earlyDiff, 0.707,
// \modDepth, 0.1,
// \modFreq, 2.0,
// \low, 1.0, \mid, 1.0, \high, 1.0,
// \lowcut, 300, \highcut, 8000
~reverbSynth.set(\reverbTime, 0.7);
~reverbSynth.set(\size, 0.5);
~reverbSynth.set(\damp, 0.4);



//\delayTime.kr(0.25),
//\damp.kr(0.1),
//\size.kr(1.0),
//\diff.kr(0.707),
//\feedback.kr(0.8),
//\modDepth.kr(0.01),
//\modFreq.kr(0.1)
~delaySynth.set(\delayTime, (0.125 / 2) * l.tempo);
~delaySynth.set(\feedback, 0.8);
~delaySynth.set(\damp, 0.2);
~delaySynth.set(\diff, 0.01);
~delaySynth.set(\modFreq, 2 * l.tempo);
~delaySynth.set(\modDepth, 0.15);
)
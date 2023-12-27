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
~reverbSynth.set(\reverbTime, 1.8);
~reverbSynth.set(\size, 0.9);
~reverbSynth.set(\damp, 0.01);



//\delayTime.kr(0.25),
//\damp.kr(0.1),
//\size.kr(1.0),
//\diff.kr(0.707),
//\feedback.kr(0.8),
//\modDepth.kr(0.01),
//\modFreq.kr(0.1)
~delaySynth.set(\delayTime, (0.125 / 4) * l.tempo);
~delaySynth.set(\feedback, 0.9255);
~delaySynth.set(\damp, 0.1);
~delaySynth.set(\diff, 0.2);
~delaySynth.set(\modFreq, 0.25 * l.tempo);
~delaySynth.set(\modDepth, 1.5);
)
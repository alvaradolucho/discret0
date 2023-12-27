(
DDWSnippets.put("discreet", "(
~discreetL = Pbindef(\\discreetL,
	\\instrument, \\discreet,
	\\midinote, Pseq([57, 41, 52, 47, 38, 38, 55, 45, 47, 40, 52, 57, 50, 47, 43, 47], inf) + [12, 24, 0].choose,
	\\dur, Pwhite(5.5, 9.5, inf),
	\\atk, 0.8, \\rel, Pexprand(4.5, 9.5, inf),
	\\pan, -1.0,
	\\lpfreq, Pwhite(300, 1500, inf),
	\\amp, Pwhite(-20.dbamp, -15.dbamp, inf),
);

~discreetR = Pbindef(\\discreetR,
	\\instrument, \\discreet,
	\\midinote, Pseq([57, 41, 52, 47, 38, 38, 55, 45, 47, 40, 52, 57, 50, 47, 43, 47], inf) + [12, 24, 0].choose,
	//\dur, Pseq([2.5, 0], inf),
	\\dur, Pwhite(5.5, 9.5, inf), \\pan, 1.0,
	\\atk, 0.8, \\rel, Pexprand(4.5, 9.5, inf),
	\\lpfreq, Pwhite(300, 1500, inf),
	\\amp, Pwhite(-20.dbamp, -15.dbamp, inf),
);
)
(
~discreetL.play(t.tempo); ~discreetR.play(t.tempo);)
");

DDWSnippets.put("vangelis", "(
~vangelis2 = Pbindef(\\vangelis,
	\\instrument, \\vangelis,
	\\midinote, Prand([62, 65, 67, 69, 50], inf),
	\\amp, Pwhite(-28.dbamp, -23.dbamp, inf),
	\\dur, 0.5,
	\\atkvca1, 1.0, \\atkvca2, 0.25,
	\\vca1moddepth, 0.1225,
	\\vca2moddepth, 0.125,
	\\lpfreq1, 400, \\lpfreq2, 900,
	\\delayAmp, -2.dbamp, \\revebAmp, -2.dbamp,
	\\group, ~src,
);
)");

DDWSnippets.put("newsynthdef", "(
SynthDef(\\newsynth, { | freq=220, amp=0.1 |
var env, sig;

env = Env.perc(\\atk.kr(0.01), \\rel.kr(1.0)).ar(2);

freq = freq * [1, 1.01];
sig = SinOsc.ar(freq, mul: amp);

sig = sig * env;

sig = MoogVCF.ar(sig, \\lpfreq.kr(2500), \\lpres.kr(0.01));

sig = Balance2.ar(sig[0], sig[1], \\pan.kr(0.0));

sig = ( sig * \\saturation.kr(1.0) ).tanh * \\attenuation.kr(1.0);

Out.ar(~bus[\\main], sig);
Out.ar(~bus[\\delay], sig * \\delayAmp.kr(0.0));
Out.ar(~bus[\\reverb], sig * \\reverbAmp.kr(0.0));

}).add;
)");

DDWSnippets.put("newsynth_pattern", "(
~newsynth = Pbindef(\\newsynth,
	\\instrument, \\newsynth,
	\\midinote, Prand([62, 65, 67, 69, 50], inf),
	\\amp, Pwhite(-28.dbamp, -23.dbamp, inf),
	\\dur, 0.5,
	\\atk, 0.01, \\rel, 1.0,
	\\lpfreq, 2200, \\lpres, 0.01,
	\\delayAmp, -80.dbamp, \\revebAmp, -80.dbamp,
	\\group, ~src,
);
)");
)


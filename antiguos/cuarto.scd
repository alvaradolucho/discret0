// --------------------- parte 1 -------------------------- //

(
t = TempoClock(145 / 60);
t.schedAbs(t.nextBar, {~printBar.(); 1});
//t.beats;
)

// --------------------- parte 1 -------------------------- //
(
Ndef(\continuo2, { | freq=220, amp=0.8 |
	var sig;

	freq = ( [52, 61, 60, 69] + 12).midicps * LFNoise0.kr(1*l.tempo).range(1,5).round(1);
	freq = freq * LFNoise1.kr(4.5).range(-0.35, 0.1).midiratio;
	freq = freq * LFSaw.kr(l.tempo * 1.0, pi).range(1, 4).round(1.0);
	sig = AnalogFoldOsc.ar(freq, LFSaw.ar(l.tempo * 4).exprange(0.1, 1.0))  * amp;
	sig = VadimFilter.ar(sig, LFSaw.ar(l.tempo / 8).exprange(520, 5200), LFNoise1.kr(2.5).exprange(0.4, 0.7), type: 1);
	sig = Splay.ar(sig);
	sig = sig * LFSaw.ar(l.tempo  / 8).exprange(-20.dbamp, 1.00);
	sig = sig + 0.49 * JPverb.ar(
		sig,
		\rtime.kr(4.25),
		\damp.kr(0.05),
		\size.kr(2.0),
		\earlyDiff.kr(0.807),
		\modDepth.kr(0.1),
		\modFreq.kr(4.0),
		\low.kr(0.5), \mid.kr(1.0), \high.kr(1.2),
		\lowcut.kr(300), \highcut.kr(10000)
	);
	sig;
}).fadeTime_(5);


Ndef(\continuo3, { | freq=220, amp=0.325 |
	var sig;

	freq = ( [55, 65, 62, 69, 72]).midicps * 2;
	freq = freq * LFNoise1.kr(7.5).range(-0.55, 0.1).midiratio;
	freq = freq * LFSaw.kr(l.tempo * 4.0).range(1,4).round(1.0);
	sig = VarSaw.ar(freq, width: LFNoise1.kr(7.5).exprange(0.5, 0.9), mul: amp);
	sig = VadimFilter.ar(sig, LFSaw.ar(l.tempo / 32).exprange(220, 3200), LFNoise1.kr(2.5).exprange(0.01, 0.2), type: 1);
	//sig = sig * LFSaw.ar(l.tempo  / 0.25).exprange(-20.dbamp, 1.00);
	sig = Splay.ar(sig);
	sig = sig * LFSaw.ar(l.tempo  / 0.125).exprange(-20.dbamp, 1.00);
	sig = sig + 0.729 * JPverb.ar(
		sig,
		\rtime.kr(2.25),
		\damp.kr(0.25),
		\size.kr(1.0),
		\earlyDiff.kr(0.207),
		\modDepth.kr(0.1),
		\modFreq.kr(4.0),
		\low.kr(0.5), \mid.kr(1.0), \high.kr(1.2),
		\lowcut.kr(300), \highcut.kr(10000)
	);
	sig;
}).fadeTime_(5);
)

~continuo = Ndef(\continuo2);
~continuo.play(group: ~src, fadeTime: 10);
~continuo.free(fadeTime: 20);
~continuo3 = Ndef(\continuo3);
~continuo3.play(group: ~src, fadeTime: 10);
~continuo3.clear(fadeTime: 40);
~continuo3.free(fadeTime: 20);
t.tempo

(
Ndef(\continuo2, { | freq=220, amp=0.335 |
	var sig;

	freq = ( [52, 61, 60, 69] + 12).midicps * 1.0;
	freq = freq * LFNoise1.kr(4.5).range(-0.35, 0.1).midiratio * 1;
	freq = freq * LFSaw.kr(l.tempo * 2.0, pi).range(1, 3).round(1.0);
	sig = AnalogFoldOsc.ar(freq, LFSaw.ar(l.tempo * 4).exprange(0.15, 1.0))  * amp;
	//sig = SinOscFB.ar(freq, 0.0, mul: amp) * 0.9;
	sig = VadimFilter.ar(sig, LFSaw.ar(l.tempo /4).exprange(520, 2200), LFNoise1.kr(2.5).exprange(0.4, 0.7), type: 1);
	sig = Splay.ar(sig);
	sig = sig * LFSaw.ar(l.tempo  / 0.25).exprange(-40.dbamp, 1.00);
	sig = sig + 0.72 * JPverb.ar(
		sig,
		\rtime.kr(8.25),
		\damp.kr(0.05),
		\size.kr(2.0),
		\earlyDiff.kr(0.807),
		\modDepth.kr(0.1),
		\modFreq.kr(4.0),
		\low.kr(0.5), \mid.kr(1.0), \high.kr(1.2),
		\lowcut.kr(300), \highcut.kr(10000)
	);
	Out.ar(~bus[\delay], sig * (-10.dbamp));
	sig;
}).fadeTime_(5);


Ndef(\continuo3, { | freq=220, amp=0.325 |
	var sig;

	freq = ( [55, 65, 62, 69, 72]).midicps ;
	freq = freq * LFNoise1.kr(7.5).range(-0.55, 0.1).midiratio * 1.0;
	freq = freq * SinOsc.kr(l.tempo * 2.0).range(1, 3).round(1.0) ;
	//sig = AnalogFoldOsc.ar(freq, LFSaw.ar(t.tempo * 4).exprange(0.15, 1.0))  * amp;
	//sig = SinOscFB.ar(freq, 0.0, mul: amp) * 0.9;
	sig = VarSaw.ar(freq, width: LFNoise1.kr(7.5).exprange(0.5, 0.9), mul: amp);
	sig = VadimFilter.ar(sig, LFSaw.ar(l.tempo * 0.5).exprange(420, 8200), LFNoise1.kr(2.5).exprange(0.05, 0.6), type: 1);
	sig = Splay.ar(sig);
	//sig = sig * LFSaw.ar(t.tempo / 16, pi).exprange(0.1, 1.00);
	// Out.ar(~bus[\delay], sig * 0.dbamp);
	// sig;
	sig = sig + (0.69 * JPverb.ar(
		sig,
		\rtime.kr(2.25),
		\damp.kr(0.25),
		\size.kr(1.0),
		\earlyDiff.kr(0.207),
		\modDepth.kr(0.1),
		\modFreq.kr(4.0),
		\low.kr(0.5), \mid.kr(1.0), \high.kr(1.2),
		\lowcut.kr(300), \highcut.kr(10000)
	));
	Out.ar(~bus[\delay], sig * (-15.dbamp));
	sig;
}).fadeTime_(10);
)

~continuo3 = Ndef(\continuo3);
~continuo3.play(group: ~src, fadeTime: 10);
~continuo3.free(fadeTime: 20);
~continuo.free(fadeTime: 20);

(
~continuo.free(fadeTime: 20);
~continuo3.free(fadeTime: 20);
)
~automat4.spooky;

///////////////////////////++


(
Ndef(\nreverb, {
	var in = \in.ar([0, 0]);
	var wet = JPverb.ar(
		in,
		\rtime.kr(8.25),
		\damp.kr(0.05),
		\size.kr(1.0),
		\earlyDiff.kr(0.707),
		\modDepth.kr(0.1),+
		\modFreq.kr(4.0),
		\low.kr(0.5), \mid.kr(1.0), \high.kr(1.2),
		\lowcut.kr(300), \highcut.kr(10000)
	);
	( in * \dry.kr(-50.dbamp)) + ( wet * \wet.kr(0.dbamp));
}).fadeTime_(5);
)
Ndef(\nreverb).play(group: ~nodefx, fadeTime: 10);
Ndef(\reverb).free;

Ndef(\nreverb) <<>.in ~continuo;
Ndef(\nreverb) <<>.in ~continuo2;


~nodefx = Group.after(~src);

s.quit;


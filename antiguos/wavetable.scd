(
~wt_buf.do(_.free);
~wt_sig = 10.collect({ | i |
	var numSegs = i.linexp(0, 9, 4, 40). round;

	Env(
		levels: [0] ++ ({1.0.rand}.dup(numSegs - 1) * [1, -1]).scramble ++ [0] ,
		times: { exprand(1, i.linexp(0, 9, 1, 50)) }.dup(numSegs),
		curve: {[\sine, 0, exprand(1, 20) * [1, -1].choose].wchoose([8 - i, 2, i].normalizeSum)}.dup(numSegs)
	).asSignal(1024);
});
~wt_buf = Buffer.allocConsecutive(10, s, 2048, 1, {
	arg buf, index;
	buf.setnMsg(0, ~wt_sig[index].asWavetable);
});

SynthDef(\wv, { | buf=5, freq=220, amp=0.1, t_gate=1 |
	var sig, env, detuneCtrl;

	env = EnvGen.ar(
		Env([0, 1, 1, 0], [\atk.kr(0.01), \decay.kr(0.25), \rel.kr(1.0), [\c0.kr(1.0), 0, \c1.kr(-1.0)]]),
		t_gate,
		doneAction: 2
	);
	detuneCtrl = LFNoise1.kr({4.0.rand}!8).bipolar(\det.kr(0.2)).midiratio;

	sig = Osc.ar(~wt_buf[2], freq * detuneCtrl, { Rand(0, 2pi) }!8);
	sig = Splay.ar(sig);

	sig = Balance2.ar(sig[0], sig[1], \pan.kr(0.0), amp);

	sig = DFM1.ar(sig, \lpfreq.kr(2500, 0.1), \lpres.kr(0.01, 0.1), noiselevel: 0.0001);
	sig = sig * LFTri.ar(\tremolofreq.kr(4)).exprange(\tremolodepth.kr(1.0), 1.0);
	sig = LeakDC.ar(sig);
	sig = sig * env;
	Out.ar(~bus[\main], sig);
	Out.ar(~bus[\reverb], sig * \rsend.kr(0.0));
}).add;
)
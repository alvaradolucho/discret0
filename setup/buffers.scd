(
// buffers
var filePath, thisPath, samplesPath;
var inst, instruments;
Buffer.freeAll;

filePath = thisProcess.nowExecutingPath.dirname.dirname;
samplesPath = filePath ++ "/samples/samples";
filePath = PathName.new(filePath);
samplesPath = PathName.new(samplesPath);

b = Dictionary.new;

samplesPath.entries.do({ | i |
	var folder = i.folderName.asSymbol;
	var inst;

	folder.postln;
	b.add(folder -> []);
	//i.entries.postln;
	i.entries.do({ |j|
		var fname, isWav;
		fname = j.fileName;
		isWav = fname.endsWith(".wav").or(
			j.fileName.endsWith(".WAV").or(fname.endsWith(".aif").or(fname.endsWith(".flac")))
		);
		if (isWav, {
			var synthName;
			var buf = b[folder].size;
			b[folder] = b[folder].add(
				Buffer.readChannel(s, j.fullPath, channels:[0])
			);
			synthName = folder ++ ("_" ++ buf).asSymbol;

			SynthDef(synthName, {
				| amp = 0.1, begin=0.0, end=1.0, delta=1.0, dur=1, t_trig=1,
				rate=1.0, speed=1.0, bufTempo=135, overlap=2, ngrains=80, unit='k' |
				var sig, trig, env;
				var sawrate, phasor;
				var startPos, endPos;
				var bufnum = b[folder][buf];
				var numFrames = max(BufFrames.ir(bufnum), 1);

				// quiero que bufTempo=(l.tempo * 60) ???
				// quiero que speed dependa del sample.


				speed = if(unit=='c', (l.tempo * 60) / bufTempo, 1);
				rate = ( rate * speed ) * BufRateScale.ir(bufnum);

				startPos = if(
					(rate < 0) * (begin <=0),
					numFrames,
					numFrames * begin);

				phasor = Phasor.ar(
					rate: rate,
					start: startPos,
					end: ( numFrames  * end ) * (rate > 0);
				);

				dur = ( (dur * speed.reciprocal) * ( (end - begin) ).abs) * BufDur.ir(bufnum);
				dur.poll;

				trig = Trig1.ar(t_trig, 0.97 * dur);
				//trig = Gate.kr(t_trig)
				sig = GrainBuf.ar(
					numChannels: 2,
					//trigger: trig,
					trigger: Impulse.ar(ngrains),
					dur: overlap / ngrains,
					sndbuf: bufnum,
					rate: rate,
					pos: phasor / numFrames,
					interp: 2,
					pan: \pan.kr(0.0);

				) * amp;

				env = Env.adsr(
					\atk.kr(0.0),
					\decay.kr(0.1),
					\sus.kr(1.0),
					\rel.kr(0.2) * dur
				);
				sig = sig * EnvGen.ar(
					env,
					trig,
					doneAction: 2
				);
				sig = MoogVCF.ar(sig, \lpfreq.kr(8000), \lpres.kr(0.1));
				sig = AnalogVintageDistortion.ar(sig,
					\drive.kr(0.0),
					\bias.kr(0.00),
					\low.kr(0.0),
					\high.kr(0.0)
				);
				sig = HPF.ar(sig, \hpfreq.kr(30));

				sig = LeakDC.ar(sig);


				Out.ar(~bus[\main], sig);
				Out.ar(~bus[\reverb], sig * \rsend.kr(0.0));
				Out.ar(~bus[\delay], sig * \dsend.kr(0.0));

			}).add;

		});

	});
});

"buffers cargados".postln;
)

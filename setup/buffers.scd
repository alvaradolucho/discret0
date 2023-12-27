(
// buffers
var filePath, samplesPath;
var inst, instruments;
Buffer.freeAll;


filePath = "C:/Users/Lucho Alvarado/Documents/automat4/dev/automat4_set_dev4_2024/";
filePath.postln;
samplesPath = filePath ++ "samples/samples";
//samplesPath = filePath ++ "samplestest/";
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
		if (j.fileName.endsWith(".wav").or(j.fileName.endsWith(".WAV").or(j.fileName.endsWith(".aif").or(j.fileName.endsWith(".flac")))), {
			var buf = b[folder].size;
			b[folder] = b[folder].add(
				Buffer.readChannel(s, j.fullPath, channels:[0])
			);
			inst = folder ++ ("_" ++ buf).asSymbol;
			SynthDef(inst, { | amp = 0.1, begin=0.0, end=1.0, delta=1.0, t_trig=1, dur=0.25, rate=1.0 |
				var sig, env;
				var bufnum, numFrames, sawrate, phase;
				var startPos, endPos, bufaux;
				endPos = min(max(end, dur), 1);
				startPos = 0;

				sig = PlayBuf.ar(
					1,
					b[folder][buf],
					rate * BufRateScale.ir(b[folder][buf]),
					t_trig,
					startPos,
					doneAction: 0
				) * amp;
				env = Env.adsr(
					\atk.kr(0.001),
					\decay.kr(0.1),
					\sus.kr(1.0),
					\rel.kr(0.1)
				);
				sig = MoogVCF.ar(sig, \lpfreq.kr(8000), \lpres.kr(0.1));
				sig = AnalogVintageDistortion.ar(sig,
					\drive.kr(0.0),
					\bias.kr(0.00),
					\low.kr(0.0),
					\high.kr(0.0)
				);
				sig = HPF.ar(sig, \hpfreq.kr(30));
				sig = sig * EnvGen.ar(env, Trig1.kr(t_trig, min(delta, dur)), doneAction: 2);
				sig = Pan2.ar(sig, \pan.kr(0.0));
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

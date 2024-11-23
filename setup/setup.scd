(
// full setup
s.options.sampleRate_(48000);
s.options.memSize_(65536 * 4);
s.options.numBuffers = 1024 * 16;
s.options.maxSynthDefs = 1024 * 16;
s.options.blockSize_(256); // default: 64
s.latency_(0.3);

//s.options.outDevice_("MME : Altavoces");
// s.options.outDevice = "ASIO : Model Mixer ASIO";
//s.options.outDevice = "ASIO : US-122 MKII / US-144 MKII";
//s.options.outDevice = "ASIO : JackRouter";
s.options.outDevice = "ASIO : ReaRoute ASIO (x64)";
//s.options.outDevice = "ASIO : SSL ASIO Driver 1";

s.options.numInputBusChannels_(2);
s.options.numOutputBusChannels_(2);

~out = 4;
~faders = Array.fill(8, 1);
~knobs = Array.fill(8, 1);

~makeBusses = {
	~bus = Dictionary.new;
	~bus.add(\main -> Bus.audio(s, 2));  // out 1-2
	~bus.add(\main2 -> Bus.audio(s, 2)); // out 3-4
	~bus.add(\reverb -> Bus.audio(s, 2));
	~bus.add(\delay -> Bus.audio(s, 2));
	//~bus.add(\chorus -> Bus.audio(s, 2));
	//~bus.add(\gateRev -> Bus.audio(s, 2));
	//~bus.add(\master);

};

~makeNodes = {
	~src = Group.new;
	~fx = Group.after(~src);

	~delaySynth.free;
	~delaySynth = Synth(\delay, [
		\in, ~bus[\delay],
		//\out, ~bus[\main]
		\out, 4
	], ~fx, \addToTail);

	~reverbSynth.free;
	~reverbSynth = Synth(\reverb, [
		\in, ~bus[\reverb],
		\out, ~bus[\main]
		//\out, 6
	], ~fx, \addToTail);

	~mainSynth.free;
	~mainSynth = Synth(\main, [\in, ~bus[\main], \out, 0], ~fx, \addToTail);
	~main2Synth.free;
	~main2Synth = Synth(\main2, [\in, ~bus[\main2], \out, 2], ~fx, \addToTail);

};

~cleanup = {
	"chau".postln;
	Window.closeAll;
	s.newBusAllocators;
	ServerBoot.removeAll;
	ServerTree.removeAll;
	ServerQuit.removeAll;
};


//////////////////// register functions
ServerBoot.add(~makeBusses);
ServerQuit.add(~cleanup);

s.waitForBoot({

	s.meter.window;
	s.scope.window;
	//s.freqscope.window;
	s.plotTree.window;
	s.sync;
	l = LinkClock.new.latency_(s.latency);
	l.tempo = 135/60;
	l.gui;
	s.sync;

	SynthDef(\reverb, {
		var sig = In.ar(\in.ir(0), 2);

		sig = JPverb.ar(
			sig,
			\reverbTime.kr(1.5),
			\damp.kr(0.25),
			\size.kr(2.0),
			\earlyDiff.kr(0.707),
			\modDepth.kr(0.1),
			\modFreq.kr(2.0),
			\low.kr(1.0), \mid.kr(1.0), \high.kr(1.0),
			\lowcut.kr(300), \highcut.kr(8000)
		);
		//sig = sig * \amp.kr(-3.dbamp);

		Out.ar(\out.ir(2), sig);
	}).add;

	SynthDef(\delay, {
		var sig = In.ar(\in.ir(0), 2);

		sig = Greyhole.ar(
			sig,
			\delayTime.kr(0.25 * l.tempo),
			\damp.kr(0.1),
			\size.kr(1.0),
			\diff.kr(0.707),
			\feedback.kr(0.8),
			\modDepth.kr(0.01),
			\modFreq.kr(0.1)
		);
		Out.ar(\out.ir(2), sig);
	}).add;


	SynthDef(\main, {
		var sig = In.ar(\in.ir(0), 2);

		sig = MoogVCF.ar(sig, \lpfreq.kr(20000, 0.2), \lpres.kr(0.01, 0.2));
		//sig = AnalogTape.ar(sig, \bias.kr(0.01, 0.1), \saturation.kr(0.1, 0.1), \drive.kr(0.1, 0.1));
		sig = Limiter.ar(sig, -1.dbamp, 0.01);
		sig = LeakDC.ar(sig);
		Out.ar(\out.ir(0), sig);
	}).add;

	SynthDef(\main2, {
		var sig = In.ar(\in.ir(0), 2);

		sig = MoogVCF.ar(sig, \lpfreq.kr(20000, 0.2), \lpres.kr(0.01, 0.2));
		//sig = AnalogTape.ar(sig, \bias.kr(0.01, 0.1), \saturation.kr(0.1, 0.1), \drive.kr(0.1, 0.1));
		sig = Limiter.ar(sig, -1.dbamp, 0.01);
		sig = LeakDC.ar(sig);
		Out.ar(\out.ir(2), sig);
	}).add;

	s.sync;
	ServerTree.add(~makeNodes);

	s.sync;
	//"snippets.scd".loadRelative;
	s.freeAll;
	s.sync;
	"buffers.scd".loadRelative;
	s.sync;
	"ndefs.scd".loadRelative;
	s.sync;
	"sintes.scd".loadRelative;
	s.sync;
	"funcs.scd".loadRelative;
	s.sync;
	"wavetable.scd".loadRelative;
	s.sync;
	"sound_setup.scd".loadRelative;
	s.sync;
	"osc_receiver.scd".loadRelative;

	"plei".postln;

});

)

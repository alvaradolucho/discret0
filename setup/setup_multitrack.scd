(
// importar funciones para el server
"server_options.scd".loadRelative();

~loadServerOptions.( outputDriver: "ASIO : ReaRoute ASIO (x64)", inChannels: 4, outChannels: 8 );

~faders = Array.fill(8, 1);
~knobs = Array.fill(8, 1);

~makeBusses = {
	~bus = Dictionary.new;
	~bus.add(\d1 -> Bus.audio(s, 2));
	~bus.add(\d2 -> Bus.audio(s, 2));
	~bus.add(\d3 -> Bus.audio(s, 2));
	~bus.add(\d4 -> Bus.audio(s, 2));
};

~makeNodes = {
	~tracksGroup.free;
	~tracksGroup = Group.new;
	~outputsGroup.free;
	~outputsGroup = Group.after(~tracksGroup);
	~d1Audio.free;
	~d1Audio = Synth(\d1audio, [
		\in, ~bus[\d1],
		\out, 0
	], ~outputsGroup, \addToTail);
	~d2Audio.free;
	~d2Audio = Synth(\d2audio, [
		\in, ~bus[\d2],
		\out, 2
	], ~outputsGroup, \addToTail);
};

ServerBoot.add(~makeBusses);
ServerQuit.add(~cleanup);

s.waitForBoot({
	Window.closeAll;
	l = LinkClock.new.latency_(s.latency);
	l.tempo = 135 / 60;
	~loadServerGUI.();
	s.sync;
	SynthDef(\d1audio, {
		var sig = In.ar(\in.ir(0), 2);
		Out.ar(\out.ir(0), sig);
	}).add;
	SynthDef(\d2audio, {
		var sig = In.ar(\in.ir(0), 2);
		Out.ar(\out.ir(2), sig);
	}).add;
	~loadAudioChannels.();
	s.sync;
	ServerTree.add(~makeNodes);
	s.sync;
	s.freeAll;
	//"sintes.scd".loadRelative;
	s.sync;
	"funcs.scd".loadRelative;
	s.sync;
	"osc_receiver.scd".loadRelative;
	s.sync;
	"plei".postln;
});
)
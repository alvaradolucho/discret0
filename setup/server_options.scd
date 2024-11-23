(
~cleanup = {
	"chau".postln;
	Window.closeAll;
	s.newBusAllocators;
	ServerBoot.removeAll;
	ServerTree.removeAll;
	ServerQuit.removeAll;
};

~loadAudioChannels = {

};

~loadServerGUI = {
	s.meter.window;
	s.scope.window;
	s.plotTree.window;
};

~loadServerOptions = {
	arg outputDriver="MME : Altavoces", inChannels=2, outChannels=2, sampleRate=48000, blockSize=256, latency=0.3;
	s.options.blockSize_(blockSize); // default 64
	s.options.memSize_(65536 * 4);
	s.options.numBuffers = 1024 * 16;
	s.options.maxSynthDefs = 1024 * 16;
	s.options.outDevice = outputDriver;
	s.options.sampleRate_(sampleRate);
	s.latency_(latency);
};
)
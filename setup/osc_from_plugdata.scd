(
var addrPlugData = NetAddr("127.0.0.1", 55999); // FROM plugdata
OSCFunc.trace(false);
// desde plugdata
OSCdef(\fader1, { |msg|
	msg.postln;
	~faders[0] = msg[1];
}, '/fader1', addrPlugData);

OSCdef(\fader2, { |msg|
	msg.postln;
	~faders[1] = msg[1];
}, '/fader2', addrPlugData);

OSCdef(\fader3, { |msg|
	msg.postln;
	~faders[2] = msg[1];
}, '/fader3', addrPlugData);

OSCdef(\fader4, { |msg|
	msg.postln;
	~faders[3] = msg[1];
}, '/fader4', addrPlugData);

OSCdef(\fader5, { |msg|
	msg.postln;
	~faders[4] = msg[1];
}, '/fader5', addrPlugData);

OSCdef(\fader6, { |msg|
	msg.postln;
	~faders[5] = msg[1];
}, '/fader6', addrPlugData);

OSCdef(\fader7, { |msg|
	msg.postln;
	~faders[6] = msg[1];
}, '/fader7', addrPlugData);

OSCdef(\fader8, { |msg|
	msg.postln;
	~faders[7] = msg[1];
}, '/fader8', addrPlugData);

OSCdef(\knob1, { |msg|
	msg.postln;
	~knobs[0] = msg[1];
}, '/knob1', addrPlugData);

OSCdef(\knob2, { |msg|
	msg.postln;
	~knobs[1] = msg[1];
}, '/knob2', addrPlugData);

OSCdef(\knob3, { |msg|
	msg.postln;
	~knobs[2] = msg[1];
}, '/knob3', addrPlugData);

OSCdef(\knob4, { |msg|
	msg.postln;
	~knobs[3] = msg[1];
}, '/knob4', addrPlugData);

OSCdef(\knob5, { |msg|
	msg.postln;
	~knobs[4] = msg[1];
}, '/knob5', addrPlugData);

OSCdef(\knob6, { |msg|
	msg.postln;
	~knobs[5] = msg[1];
}, '/knob6', addrPlugData);

OSCdef(\knob7, { |msg|
	msg.postln;
	~knobs[6] = msg[1];
}, '/knob7', addrPlugData);

OSCdef(\knob8, { |msg|
	msg.postln;
	~knobs[7] = msg[1];
}, '/knob8', addrPlugData);


OSCdef(\percu, { |msg|
	msg.postln;
}, '/percu', addrPlugData);
)
(
var parserTidal, parserTidalModular;
var parser;
var consolePrinter;
var addrOpenStageControl = NetAddr("127.0.0.1", 8085); // FROM open stage control0

thisProcess.openUDPPort(8080); // from tidalcycles
thisProcess.openUDPPort(8085); // from open stage control
thisProcess.openUDPPort(6010); // from superdirt
thisProcess.openUDPPort(49162);  // from orca
OSCFunc.trace(false);


// from tidalcycles

parserTidal = { | data |
	var dict = Dictionary.new;
	data = data[3..data.size];
	forBy (0, data.size-1, 2, { | i |

		// convertir nota midi a frecuencia en hz
		if (data[i].asSymbol == 'note', {
			data[i] = 'freq';
			data[i + 1] = data[i + 1].midicps;
		});


		// convertir buf a argumento de synthdef
		// ejemplo:
		// s: "dk2drumkit", buf: 5
		// queda
		// s: "dk2drumkit_5"
		if (data[i].asSymbol == 's', {
			if (data[i + 1] == 'wv', {}, {
				forBy (0, data.size-1, 2, { | j |
					if (data[j].asSymbol == 'buf', {
						var buf = data[j + 1];
						buf = buf.wrap(0, b[data[i + 1]].size - 1);
						buf = buf.asInteger;

						//data[i+1].asInteger.postln;
						data[i + 1] = data[i + 1] ++ ('_' ++ buf).asSymbol;
					});
				});
		});
		});

		dict.put(data[i].asSymbol, data[i+1]);
	});
	dict;
};


parserTidalModular = { | data |
	var dict = Dictionary.new;
	data = data[3..data.size];
	forBy (0, data.size-1, 2, { | i |

		// convertir nota midi a frecuencia en hz
		if (data[i].asSymbol == 'note', {
			data[i] = 'freq';
			data[i + 1] = data[i + 1].midicps;
		});


		// convertir buf a argumento de synthdef
		// ejemplo:
		// s: "dk2drumkit", buf: 5
		// queda
		// s: "dk2drumkit_5"
		if (data[i].asSymbol == 'ndef', {
			if (data[i + 1] == 'wv', {}, {
				forBy (0, data.size-1, 2, { | j |
					if (data[j].asSymbol == 'buf', {
						var buf = data[j + 1];
						buf = buf.wrap(0, b[data[i + 1]].size - 1);
						buf = buf.asInteger;

						//data[i+1].asInteger.postln;
						data[i + 1] = data[i + 1] ++ ('_' ++ buf).asSymbol;
					});
				});
		});
		});

		dict.put(data[i].asSymbol, data[i+1]);
	});
	dict;
};

consolePrinter = { |data|
	var toPrint = data.asSortedArray;
	"---".postln;
	(data['s'] ++ ': ').postln;
	toPrint.postln;
};

OSCdef(\tidal, { |...args|
	var data = args[0];
	var td, to_synth = [];
	var toPrint;
	td = parserTidal.(data);
	//consolePrinter.(td);
	Synth(td['s'], td.getPairs, ~src)
}, '/tidalcycles');

OSCdef(\tidalModular, { |...args|
	var td = [];
	var data = args[0];
	var toNdef;
	//var td, to_synth = [];
	//var toPrint;
	td = parserTidalModular.(data);
	//consolePrinter.(td);
	//Synth(td['s'], td.getPairs, ~src)
	toNdef = td.getPairs;
	toNdef.round(0.001).postln;
	Ndef(td['ndef']).set(*td.getPairs);
}, '/tidalModular');

"recibiendo OSC desde tidal".postln;

OSCdef(\dirt, { |...args|
	var data = args[0];
	var td, to_synth = [];
	//data.postln;
	td = parserTidal.(data);
	//td.postln;
	Synth(td['s'], td.getPairs, ~src)
//}, '/play', osc_tidal);
}, '/dirt/play');

// from orca

parser = { | data |
	var aux = data;
	var instrument;

	//aux.postln;
	instrument = case
	{ aux[1] == 20 }{ \nuevokick }
	{ aux[1] == 28 }{ \nuevosnare }
	{ aux[1] == 17 }{ \oh }
	{ aux[1] == 11 }{ \filmbass }
	{ aux[1] == 15 }{ \sinte1 }
	{ aux[1] == 29 }{ \sinte1 };
	//{ aux[1] == 28 }{ \oh };
	//instrument.postln;
	instrument;
};


OSCdef(\sinte1orca, { |...args|
	var inst, amp, rsend, note, pan, lpfreq, lpres;
	var data = args[0];
	data.postln;
	inst = parser.(data);
	note = (data[1] + 32).midicps;
	amp = data[2].linlin(0, 35, 0.0, 1.0);
	pan = data[3] / 35.0;
	lpfreq = data[4].linexp(0, 35, 500, 6500);
	lpres = data[5].linexp(0, 35, 0.001, 0.8);
	//rsend.postln;
	[note, amp, pan, lpfreq, lpres].postln;
	Synth(\sinte1,
		[
			\amp, amp * 0.1,
			//\rsend, rsend,
			\freq, note,
			\lpfreq, lpfreq,
			\lpres, lpres,

	], ~src);

}, '/s');
"recibiendo OSC desde orca".postln;



// desde open stage control



OSCdef(\fader_1, { |msg|
	msg.postln;
}, '/fader_1', addrOpenStageControl);

"recibiendo OSC desde Open Stage Control".postln;

)
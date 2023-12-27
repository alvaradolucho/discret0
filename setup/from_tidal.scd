// OSC desde TidalCycles.
// Modo de uso:
// 1 - escuchar puerto 8080, con trace true.
// 2 - darle play a TidalCycles
// 3 - si llega data, detener trace (false) y copiar puerto desde mensajes OSC.
// 4 - pegar puerto en arg 2 en var osc_tidal = NetAddr("127.0.01", aqui);
// 5 (opcional) - puedes comprobar activando línea td.postln;
// 6 - si hiciste 5, desactivar línea nuevamente, sino el boot fallará.



thisProcess.openUDPPort(8080); // from tidalcycles
thisProcess.openUDPPort(49162);  // from orca
OSCFunc.trace(false);

(
//var osc_tidal = NetAddr("127.0.0.1", 65102);

var parser = { | data |
	var dict = Dictionary.new;
	data = data[3..data.size];
	forBy (0, data.size-1, 2, { | i |
		if (data[i].asSymbol == 'note', {
			data[i] = 'freq';
			data[i + 1] = data[i + 1].midicps;

		});
		dict.put(data[i].asSymbol, data[i+1]);
	});
	dict;
};

OSCdef(\tidal, { |...args|
	var data = args[0];
	var td, to_synth = [];
	td = parser.(data);
	td.postln;
	Synth(td['s'], td.getPairs, ~src)
//}, '/play', osc_tidal);
}, '/tidalcycles');
)

NetAddr.localAddr;

(
var parser = { | data |
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
)

s.quit;


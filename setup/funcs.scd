(
// funciones y utilidades
~pattern = { | pat |
	var to_pat = [];
	pat.do({ | val |
		val = val.asString;
		if(val == "x", { to_pat = to_pat.add(1.0) });
		if(val == "-", { to_pat = to_pat.add(Rest(1.0)) });
	});
	to_pat;
};

~sinpattern = { | period, min=(-1.0), max=1.0, phase=0, type='lin' |
	var pat = ( (0..(period-1)) * 2pi * period.reciprocal + phase).sin;
	if ( type=='lin', { pat = pat.linlin(-1.0, 1.0, min, max); });
	if ( type=='exp', { pat = pat.linexp(-1.0, 1.0, min, max); });
	pat;

};

// musicales
~chords = (
	'cssus2': [61, 63, 68, 66],
	'dsus': [62, 67, 69, 72, 76],
	'fsus': [65, 69, 69, 74, 76],
	'gsus': [67, 71, 74, 62, 64],
	//'asus': [69, 71, 74, 62, 64],
	'fsusb': [65, 69, 71, 76, 79],
	'fsusb': [65, 69, 71, 76, 79],
);
)
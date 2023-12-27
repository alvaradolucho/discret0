// create a synchronized clock
l = LinkClock(1).latency_(Server.default.latency);

// GUI to watch status
(
var win = Window("LinkClock", Rect(200, 200, 500, 100)).front,
peersBox, tempoBox, barsBox, beatsBox,
font = Font.default.copy.size_(32),
boldFont = font.boldVariant,
bgColor = Color(0.0,0.0,0.0),
txtColor = Color(1.0,1.0,1.0),
controller, task;

win.alwaysOnTop();
win.background = bgColor;
win.alpha = 0.75;
win.layout = HLayout(
    StaticText().font_(font).stringColor_(txtColor).string_("Peers:"),
	peersBox = NumberBox().font_(boldFont).background_(bgColor).normalColor_(txtColor).align_(\center).fixedWidth_(80),
    StaticText().font_(font).stringColor_(txtColor).string_("Tempo:"),
    tempoBox = NumberBox().font_(boldFont).background_(bgColor).normalColor_(txtColor).align_(\center).fixedWidth_(120),
    StaticText().font_(font).stringColor_(txtColor).string_("Now:"),
	barsBox = NumberBox().font_(boldFont).background_(bgColor).normalColor_(txtColor).align_(\center).fixedWidth_(80),
    beatsBox = NumberBox().font_(boldFont).background_(bgColor).normalColor_(txtColor).align_(\center).fixedWidth_(80)
);

[peersBox, barsBox, beatsBox].do { |view| view.enabled_(false) };

tempoBox.action = { |view| l.tempo = view.value / 60 };
tempoBox.value = l.tempo * 60;
peersBox.value = l.numPeers;

task = Routine {
    var bars, beats;
    loop {
        bars = l.bar;
        beats = l.beatInBar;
        {
            barsBox.value = bars.mod(4) + 1;
            beatsBox.value = beats + 1;
        }.defer(l.latency);
        1.0.wait;
    }
}.play(l, quant: 1);

controller = SimpleController(l)
.put(\tempo, {
    defer { tempoBox.value = l.tempo * 60 }
})
.put(\numPeers, {
    defer { peersBox.value = l.numPeers }
})
.put(\stop, { defer { win.close } });

win.onClose = { task.stop; controller.remove };
)

l.tempo

(
q = nil;
~link = SimpleController(l)
.put(\linkStart, {
    if(q.isNil) {
		"q es nil".postln;
    }
})
.put(\tempo,  { ("tempo: " ++ ( l.tempo * 60 ).round(0.1).asString).postln }.defer(0))
.put(\linkStop, {
    q.stop;
    q = nil;
})
.put(\stop, { ~link.remove });  // clean up if clock stops
)

~link.remove;
~link.free;

c.remove;
c = nil;
​
p.stop;
r.stop;
l.stop;

LinkClock.free;
l.free;

l.stop;

l.play;
s0.initScreen()

src(o0)
.blend(
  src(s0), 0.9
)
.blend(
shape(2, 0.9).color(0.9, 0.1, 0.9)
//.repeat(1, 1)
.scrollY(0, 0.2), 0.199
)
.diff(
  shape([0.5, 2].fast(0.25).smooth(), 0.9).color(0.1, 0.1, 0.9), 0.3)
.modulate(src(s0), 0.3)
.saturate(1.3)
.hue(0.999)
.brightness(0.001)
.out()

////////////// setup ////

msg.setPort(57101);

var p5 = [];
for (let idx=0; idx < 5; idx++) {
  p5.push(new P5())
  p5[idx].clear();
}
s0.init({src: p5[0].canvas})
s1.init({src: p5[1].canvas})
s2.init({src: p5[2].canvas})
s3.init({src: p5[3].canvas})
//s4.init({src: p5[4].canvas})
var fromTidal;
function getDictFromTidal(data){
  let fromTid = {};
  for (let i=0; i < data.length; i += 2){
    if(isNaN(data[i + 1])) {
        fromTid[data[i]] = data[i + 1];
     } else {
       fromTid[data[i]] = Math.round(data[i + 1] * 1000) / 1000;
     }
  }
  return fromTid
}
function addLayer(lay, pfive, idx) {
  pfive.frameCount = 0;
  pfive.draw = () => {
    let count = 0;
    //let automat4 = h1['n'];
    //let cps = h1['cps']
    pfive.clear();
    pfive.stroke(0);
    pfive.textSize(17);
    //pfive.background('black');
    pfive.fill('palegreen');
    pfive.textFont('Courier New');
    //p51.text('bpm: ' + cps, 1200, 120);
    //p51.fontSize(32);
    //let h11 = deleteAlmostAll(h1);
    for (var key in lay){
      //if (key == "cps") {} {
        pfive.text(key + ': ', 800 + 280 * idx, 240 + count * 20);
        pfive.text(lay[key], 940 + 280 * idx, 240 + count * 20);
        count++;
      //};
    }
    let tiempo = pfive.frameCount / 60;
    let tiempoLayer = lay['rel'] + lay['dsend'];
    if(isNaN(tiempoLayer)) {tiempoLayer=0.5};
    //pfive.text(tiempo, 1000, 800);
    //pfive.text(tiempoLayer, 1400, 800);
    if (tiempo > tiempoLayer) {pfive.clear()}
    //pfive.clear();
    pfive.fill(255);
  }
}
msg.on('/hydra', (args) => {
  fromTidal = getDictFromTidal(args);
  fromTidal['cps'] = Math.round(fromTidal['cps'] * 60 * 4, 1);
  let idx = fromTidal['_id_'];
  addLayer(fromTidal, p5[idx], idx)
  //if (fromTidal['_id_'] == 1){ fromH1(fromTidal) };
  //if (fromTidal['_id_'] == 2){ fromH2(fromTidal) };
  //if (fromTidal['_id_'] == 3){ fromH3(fromTidal) };
})


///////////////////////////

p5 = new P5()
p5.rect(500, 100, 100, 100)

p5.text('automat4', 800, 100)
p5.fill('255')

p5.draw = () => {
  p5.fill(p5.mouseX/5, p5.mouseY/5, 255, 100)
  p5.rect(p5.mouseX, p5.mouseY, 30, 150)
}



s0.init({src: p51.canvas})
s1.init({src: p52.canvas})
s2.init({src: p53.canvas})





msg.setPort(57101);

function deleteAlmostAll(dict){
  let outdict = {}
  Object.assign(outdict, dict);
  //outdict['_sound_'] = dict['s']
  delete outdict["cycle"];
  //delete outdict["nudge"];
  delete outdict["delta"];
  delete outdict["n"];
  delete outdict["cps"];
  delete outdict["orbit"]
  //delete outdict["s"];
  //delete outdict["_id_"];
  //outdict["_id_"] = dict["s"];
  //outdict.sort();
  for (key in outdict){
    if (isNaN(outdict[key])) {} else {outdict[key] = Math.round(outdict[key] * 1000) / 1000;}
  }
  //dict["amp"] = Math.round(dict["amp"] * 100) / 100;
  return outdict
}
function getDictFromTidal(data){
  let fromTid = {};
  for (let i=0; i < data.length; i += 2){
    fromTid[data[i]] = data[i + 1];
  }
  return fromTid
}
function fromH1(h1) {
  p5.draw = () => {
    let count = 0;
    let automat4 = h1['n'];
    let cps = h1['cps']
    p51.clear();
    p51.stroke(0);
    p51.text('automat' + automat4, 1200, 100);
    p51.text('bpm: ' + cps, 1200, 120);
    //p51.fontSize(32);
    let h11 = deleteAlmostAll(h1);
    for (var key in h11){
      if (key == "cps") {} {
        p51.text(key + ': ', 1200, 240 + count * 20);
        p51.text(h11[key], 1280, 240 + count * 20);
        count++;
      };
    }
    p51.fill(255);
  }
}
function fromH2(h2) {
  p52.draw = () => {
    let count2 = 0;
    p52.clear();
    p52.stroke(0);
    let h22 = deleteAlmostAll(h2);
    for (var key in h22){
      p52.text(key + ': ', 1400, 240 + count2 * 20);
      p52.text(h22[key], 1480, 240 + count2 * 20);
      count2++;
    }
    p52.fill(255);
  }
}
function fromH3(h3) {
  p53.draw = () => {
    let count3 = 0;
    let h33 = {};
    p53.clear();
    p53.stroke(0);
    h33 = deleteAlmostAll(h3);
    for (var key in h33){
      p53.text(key + ': ', 1600, 240 + count3 * 20);
      p53.text(h33[key], 1680, 240 + count3 * 20);
      count3++;
    }
    p53.fill(255);
  }
}
var fromTidal;
msg.on('/hydra', (args) => {
  fromTidal = getDictFromTidal(args);
  fromTidal['cps'] = Math.round(fromTidal['cps'] * 60 * 4, 1);
  if (fromTidal['_id_'] == 1){ fromH1(fromTidal) };
  if (fromTidal['_id_'] == 2){ fromH2(fromTidal) };
  if (fromTidal['_id_'] == 3){ fromH3(fromTidal) };
})


src(o0)
.blend(
shape(4, 0.1).repeat(1, 5).diff(shape(1, 0.1).rotate(3.14/2).repeat(5, 1))
.scale(3)
.color(0.9, 0.01, 0.01)
.scrollY(0, 0.1).modulateRotate(osc(), 0.8).modulateRotate(noise(), 0.1)
.kaleid(0.5)
.scale(0.595), 0.6)
.modulate(src(o0), 0.015)
//.hue(0.54)
.layer(
src(s0)//.color(0.1, 0.1, 0.9).scale(1.1)//.scrollX(0.1).scrollY(0.5)
)
.layer(
src(s1)
)
.layer(
src(s2)
)
.layer(
src(s3)
)
.brightness(0.07)
.saturate(1.4)
.hue([0.1, 0.9].fast(0.125).smooth())
.out()

p51.free






// recreo



p5 = new P5();
s0.initScreen()
s1.init({src: p5.canvas})

let automat4 = 'automat4_'
let x = [900, 1000, 1100, 1200, 1300, 1400];
let y = [500, 600, 700, 800, 900, 1000];
p5.clear()
p5.draw = () => {
  p5.text(automat4, x[0], 50);
  p5.text(automat4, x[1], 200);
  p5.text(automat4, x[2], 350);
  p5.text(automat4, x[3], 500);
  //p5.fill(0, 0, 255);
  p5.text(automat4, x[4], 650);
  p5.text(automat4, x[5], 800);
  //p5.stroke(10)
  p5.fill(255, 0, 255);
  p5.textSize(60);
 }

src(o0)
.scale(1.1)
.brightness(-0.23)
.blend(
  src(s0)
  .diff(
    shape(1)
    .color(0.9, 0.1, 0.9)
    //.modulateScale(osc(100.1, 0.1, 0.1))
  ),
  0.2
)
.rotate(0, 0.1)
//.pixelate(50, 150)
.modulate(src(s0), 0.01)
.diff(
  shape(2.5, 0.9).rotate(3.14/2).repeat(2,1).scrollX(0, [0.2, -0.2].fast(0.25))//.repeat(1, 1)
  .color(0.2, 0.1, 0.9)
  .add(
    src(s1)
    .scrollY(0, 0.85)//.rotate(0, 0.1)
    //.modulateRotate(noise(10), 1.25)
  )
)
.diff(
  shape([1, 3].fast(0.25).smooth(), 0.2).repeat(3, 3).color(0.9, 0.1, 0.1)
)
.modulateHue(noise(20,20), 20)
.saturate(1.2)
.hue([-0.5, 0.5].fast(0.5).smooth())
//.modulatePixelate(noise(10, 10), 300)
.out()




///////////////////

src(o0)
.blend(
  src(s0)
  .modulateScale(osc(0.01, 0.5, 0.5)),
  0.8
)
.diff(
  shape(2, 0.125, 0.01)
  .color(0.9, 0.1, 0.7)
)
.rotate(0, 0.001)
.scrollY(0, 0.05)
.saturate(1.5)
.out()

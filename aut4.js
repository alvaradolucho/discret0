// hola

s0.initScreen(0)

var grid = shape(2, 0.01, 0.01)
  .rotate(Math.PI /2)
  .repeat(1).scale(0.02);
var blueLayer = shape(2, 0.2, 0.001)
  .rotate(Math.PI/2)
  .repeat(66, 1)
  .modulateScale(osc(4), 2)
  //.scale(6)
  .color(0.99, 0.1, 0.99)
  .modulateScale(noise(500, 500), 0.05);
src(o0)
.blend( blueLayer , 0.5 )
.modulate(src(s0), 0.01)
.saturate(1.6)
.hue(0.9)
//.rotate((180 / 180) * Math.PI)
//.rotate(()=>time * 0.01)
.out()

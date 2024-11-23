// hola

s0.initScreen(0)

osc(10)
.modulate(noise(10, 10), 0.1)
.out()

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




///////// el vidio


s0.initImage("https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTki08niqx5rv2mKDyw-KI1oetGyn7n25i8Rg&s")
s1.initScreen()

let bpm = 136.0;

//src(s1)
//.scale(0.9)
//.blend(
src(s0).brightness(0.1)
  	.color(0.15, 0.1, 0.95)
  	//.invert()
	.scale(0.25,0.5)
	.scrollY(0, 8.75 / bpm)
	.kaleid(1)
  //)
	.modulate(
  	src(s1),
  	()=>Math.sin(time * 0.125 * 0.5 ) * 0.2 + 0.21)
	//.hue(1.4)
	//)
  .out(o0)


// LIVE002

s0.initImage('https://scontent.cdninstagram.com/v/t51.2885-19/386465652_2215344605331189_2521854042936501713_n.jpg?stp=cp0_dst-jpg_s110x80&_nc_cat=101&ccb=1-7&_nc_sid=fcb8ef&_nc_ohc=4bWctF_EoX0Q7kNvgED-st4&_nc_ht=scontent.cdninstagram.com&oh=00_AYDLlUV8-pRAsOVEUv1wmKnhlp-bw2rbUBxNUt3lKNuSDQ&oe=66B32DAE')

src(o0)
.scale(1.1)
.brightness(-0.5)
.luma()
.layer(
  src(s0).scale(1.1, 9/16)
   .blend(osc(10).thresh(0.8)
      .blend(
      shape(3, 0.2, 0.1).scrollX(1.0, 0.5)
      .color(0.9, 0, 0)
      .repeat(3, 2)
    )).luma(0.1).invert().hue(()=> time * 0.1)
)
.repeat(2, 2)
.modulate(src(o0), 1)
.rotate(0, 0.0051)
.out()




// aut4 - cce_santiago

src(o0)
.scale(1.2)
.blend(
  shape([2, 3.4].fast(0.125).smooth(), 0.2)
  .color(0.1, 0.1, 0.9)
  .scrollY(0, 0.27),
  0.4
).rotate(0, 0.051)
.modulateScale(osc(0.5), 1)
.saturate(0.1)
.hue(0.9)
//.repeat(4, 3)
//.pixelate(100, 100)
.modulate(src(o0), 2)
.out()

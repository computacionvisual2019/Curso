//Este codigo corresponde al punto 5 del taller 1:
//    (solo para video) Medición de la eficiencia computacional para las operaciones realizadas.


import processing.video.*;
Movie colorMovie;
PGraphics colorPG, grayPG;
PImage grayMovie;

int w, h;
float r, g, b, p;

void setup() {
  size(1300, 800);
  frameRate(10);

  colorMovie = new Movie(this, "demo2.mp4");
  colorMovie.play();  
  w = 640;
  h = 360;

  grayMovie = createImage(w, h, RGB);

  colorPG = createGraphics(w, h);
  grayPG = createGraphics(w, h);
}

void draw() {
  colorPG.beginDraw();
  colorPG.image(colorMovie, 0, 0);
  colorPG.endDraw();
  image(colorPG, 0, 0);

  grayPG.beginDraw();
  grayPG.image(grayMovie, 0, 0);
  grayPG.endDraw();
  image(grayPG, 700, 0);
}

void movieEvent(Movie m) { 
  m.read();
  grayMovie = m.copy();
  grayMovie.loadPixels();
  //m.loadPixels();
  //  println(m.pixels[100], grayMovie.pixels[100]);
  int size = grayMovie.pixels.length;
  if (size != 0 ) {
    for (int i = 0; i < size; i++) {  
      r = red(m.pixels[i]);
      g = green(grayMovie.pixels[i]);
      b = blue(grayMovie.pixels[i]);       
      p = (0.2126*r+0.7152*g+0.0722*b);  //  Algoritmo LUMA                                       
      grayMovie.pixels[i] = color(p, p, p);
      //grayMovie.pixels[i] = color(14, 14, 14);
      //grayMovie.updatePixels();
    }
  }
  println(frameRate);
}

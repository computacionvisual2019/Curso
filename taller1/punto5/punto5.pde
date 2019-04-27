//Este codigo corresponde al punto 5 del taller 1: //<>// //<>// //<>// //<>// //<>// //<>//
//    (solo para video) Medición de la eficiencia computacional para las operaciones realizadas.


import processing.video.*;
Movie colorMovie;
PGraphics colorPG, grayPG;
PImage grayMovie;

int w, h;
float r, g, b, p;

void setup() {
  size(1300, 800);
  //frameRate(10);

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
  grayMovie.loadPixels();
  colorMovie.loadPixels();
  grayMovie = toGray(colorMovie, grayMovie);
  grayPG.image(grayMovie, 0, 0);
  grayPG.endDraw();
  image(grayPG, 700, 0);
}

void movieEvent(Movie m) { 
  m.read();
  println(frameRate);
}

PImage toGray (PImage original, PImage modified) {
  
  for (int i = 0; i < original.pixels.length; i++) {  
      r = red(original.pixels[i]);
      g = green(original.pixels[i]);
      b = blue(original.pixels[i]);       
      //p = (0.2126*r+0.7152*g+0.0722*b);  //  Algoritmo LUMA    
      p = ((r+g+b)/3);
      modified.pixels[i] = color(p,p,p);
      grayMovie.updatePixels();
    }
  return modified;
}

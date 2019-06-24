import processing.video.*;
Movie colorMovie;
PImage edgeImage;
PShape can;
float angle;

void setup() {
  size(640, 640, P3D);

  colorMovie = new Movie(this, "demo.mp4");
  colorMovie.play();

  edgeImage = createImage(1280, 720, RGB);
}

void draw() {    
  background(0);

  edgeImage = edges(colorMovie);
  can = createCan(200, 400, 32, edgeImage);

  translate(width/2, height/2);
  rotateY(angle);  
  shape(can);  
  angle += 0.01;
}

PShape createCan(float r, float h, int detail, PImage tex) {
  textureMode(NORMAL);
  PShape sh = createShape();
  sh.beginShape(QUAD_STRIP);
  sh.noStroke();
  sh.texture(tex);
  for (int i = 0; i <= detail; i++) {
    float angle = TWO_PI / detail;
    float x = sin(i * angle);  
    float z = cos(i * angle);
    float u = float(i) / detail;
    sh.normal(x, 0, z);
    sh.vertex(x * r, -h/2, z * r, u, 0);
    sh.vertex(x * r, +h/2, z * r, u, 1);
  }
  sh.endShape(); 
  return sh;
}

color tc0, tc1, tc2, tc3, tc4, tc5, tc6, tc7, tc8;
PImage edges(PImage colorImage) {
  colorImage.loadPixels();
  PImage aux = new PImage(1280, 720, RGB); 
  for (int i = 0; i < colorImage.pixels.length; ++i) {
    
    tc0 = colorImage.get(i-1, i-1);
    tc1 = colorImage.get(i, i-1);
    tc2 = colorImage.get(i+1, i-1);
    tc3 = colorImage.get(i-1, i);
    tc4 = colorImage.get(i, i);
    tc5 = colorImage.get(i+1, i);
    tc6 = colorImage.get(i-1, i+1);
    tc7 = colorImage.get(i, i+1);
    tc8 = colorImage.get(i+1, i+1);

    color sum = color(8, 8, 8) * tc4 - (tc0 + tc1 + tc2 + tc3 + tc5 + tc6 + tc7 + tc8);
    aux.pixels[i] = color(red(colorImage.pixels[i])*red(sum), green(colorImage.pixels[i])*green(sum), blue(colorImage.pixels[i])*blue(sum));
  }
  return aux;
}

void movieEvent(Movie m) {
  m.read();
}

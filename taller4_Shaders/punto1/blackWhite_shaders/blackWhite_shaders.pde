// Texture from Jason Liebig's FLICKR collection of vintage labels and wrappers:
// http://www.flickr.com/photos/jasonliebigstuff/3739263136/in/photostream/

import processing.video.*; 
PImage img;
Movie colorMovie;
PShape can;
float angle;

PShader bwShader;

void setup() {
  size(640, 640, P3D);  
  colorMovie = new Movie(this, "demo.mp4");
  colorMovie.play();
  img = colorMovie;
  can = createCan(200, 400, 32, img);
  bwShader = loadShader("bwfrag.glsl");
}

void draw() {    
  background(0);
  
  shader(bwShader);
    
  translate(width/2, height/2);
  rotateY(angle);  
  shape(can);  
  angle += 0.01;
  
  println(frameRate);
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

void movieEvent(Movie m) {
  m.read();
}

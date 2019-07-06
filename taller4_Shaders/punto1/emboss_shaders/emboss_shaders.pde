
import processing.video.*;
Movie colorMovie;
PImage label, img;
PShape can;
float angle;

PShader embossShader;

void setup() {
  size(640, 640, P3D);  
  colorMovie = new Movie(this, "demo.mp4");
  colorMovie.play();
  img = colorMovie;
  can = createCan(200, 400, 32, img);
  embossShader = loadShader("embossfrag.glsl");
}

void draw() {    
  background(0);
  
  shader(embossShader);
    
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

void movieEvent(Movie m) {
  m.read();
}

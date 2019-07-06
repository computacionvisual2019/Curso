
import processing.video.*; 
PImage img;
Movie colorMovie;
PShape can;
float angle;

int actual = 0;

PShader actualShader;

void setup() {
  size(640, 640, P3D);  
  colorMovie = new Movie(this, "demo.mp4");
  colorMovie.play();
  img = colorMovie;
  actualShader = loadShader("coloredfrag.glsl");
  can = createCan(200, 400, 32, img);
}

void draw() {    
  background(0);

  if (colorMovie.pixels.length != 0) {
    switch (actual) {
    case 0:
      actualShader = loadShader("coloredfrag.glsl");
      break ;
    case 1:
      actualShader = loadShader("bwfrag.glsl");
      break ;
    case 2:
      actualShader = loadShader("edgesfrag.glsl");
      break;
    case 3:
      actualShader = loadShader("embossfrag.glsl");
      break;
    }
  }

  shader(actualShader);
    
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

void keyPressed() {
  if (keyCode == '1') {
    actual = 0;
  } else if (keyCode == '2') {
    actual = 1;
  } else if (keyCode == '3') {
    actual = 2;
  } else if (keyCode == '4') {
    actual = 3;
  }
}


void movieEvent(Movie m) {
  m.read();
}

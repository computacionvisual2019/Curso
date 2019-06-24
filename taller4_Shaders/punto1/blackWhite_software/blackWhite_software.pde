import processing.video.*; 
PImage bwImage;
Movie colorMovie;
PShape can;
float angle;

void setup() {
  size(640, 640, P3D); 

  colorMovie = new Movie(this, "demo.mp4");
  colorMovie.play();

  bwImage = createImage(1280, 720, RGB);
}

void draw() {    
  background(0);
      
  bwImage = blackWhite(colorMovie);
  can = createCan(200, 400, 32, bwImage);

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

PImage blackWhite(PImage colorImage){
  colorImage.loadPixels();
  PImage aux = new PImage(1280, 720, RGB); 
  for (int i = 0; i < colorImage.pixels.length; ++i) {
    float r = red(colorImage.pixels[i]);
    float g = green(colorImage.pixels[i]);
    float b = blue(colorImage.pixels[i]);  
    float p = (0.299*r+0.587*g+0.114*b);
    if (127.5 < p) {
      aux.pixels[i] = color(255, 255, 255); //queda con el mismo color que entro
    } else {
      aux.pixels[i] = color(0, 0, 0); 
    }
  }
  return aux;
}

void movieEvent(Movie m) {
  m.read();
}

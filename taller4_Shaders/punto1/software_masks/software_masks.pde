import processing.video.*;
Movie colorMovie;
PImage newImage;
PShape can;
float angle;

int actual = 0;

//Border mask
float[][] maskB = { {-1, -1, -1}, {-1, 8, -1}, {-1, -1, -1} };

//Emboss mask
float[][] maskE = { { 0, -1, 0}, {-1, 5, -1}, { 0, -1, 0} };

float[][] usedMask;



void setup() {
  size(640, 640, P3D);

  colorMovie = new Movie(this, "demo.mp4");
  colorMovie.loop();

  newImage = createImage(1280, 720, RGB);
}

void draw() {    
  background(0);

  if (colorMovie.pixels.length != 0) {
    switch (actual) {
    case 0:
      newImage = colorMovie;
      break ;
    case 1:
      usedMask = maskB ;
      newImage = applyMatrix(colorMovie);
      break ;
    case 2:
      usedMask = maskE;
      newImage = applyMatrix(colorMovie);
      break;
    case 3:
      newImage = blackWhite(colorMovie);
      break;
    }
  }
  can = createCan(200, 400, 32, newImage);

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

PImage applyMatrix(PImage colorImage) {
  colorImage.loadPixels();
  PImage aux = new PImage(colorImage.width, colorImage.height, RGB); 

  int maskSize = usedMask.length;
  for (int x = 0; x < aux.width; x++) {
    for (int y = 0; y < aux.height; y++) {
      color c = convolution(x, y, usedMask, maskSize, colorImage);
      int index = x + (y*aux.width);      
      aux.pixels[index] = c;
    }
  }  
  aux.updatePixels();
  return aux;
}

color convolution(int x, int y, float[][] matrix, int matrixsize, PImage img) {
  float rtotal = 0.0;
  float gtotal = 0.0;
  float btotal = 0.0;
  int offset = matrixsize / 2;
  for (int i = 0; i < matrixsize; i++) {
    for (int j= 0; j < matrixsize; j++) {
      // What pixel are we testing
      int xloc = x+i-offset;
      int yloc = y+j-offset;
      int loc = xloc + img.width*yloc;
      // Make sure we haven't walked off our image, we could do better here
      loc = constrain(loc, 0, img.pixels.length-1);
      // Calculate the convolution
      rtotal += (red(img.pixels[loc]) * matrix[i][j]);
      gtotal += (green(img.pixels[loc]) * matrix[i][j]);
      btotal += (blue(img.pixels[loc]) * matrix[i][j]);
    }
  }
  // Make sure RGB is within range
  rtotal = constrain(rtotal, 0, 255);
  gtotal = constrain(gtotal, 0, 255);
  btotal = constrain(btotal, 0, 255);
  // Return the resulting color
  return color(rtotal, gtotal, btotal);
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

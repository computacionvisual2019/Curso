PImage normalImage1, colorImage1,
 normalImage2, colorImage2, 
 normalImage3, colorImage3,
 normalImage4, colorImage4,
 normalImage5, colorImage5 ;
PShape can;
float angle;

int selectImage = 1;

PShader texShader;

void setup() {
  size(700, 700, P3D);  
  normalImage1 = loadImage("brickwall1_normal.png");
  colorImage1 = loadImage("brickwall1_color.jpg");

  normalImage2 = loadImage("brickwall2_normal.jpg");
  colorImage2 = loadImage("brickwall2_color.jpg");

  normalImage3 = loadImage("stone1_normal.jpg");
  colorImage3 = loadImage("stone1_color.jpg");
  
  normalImage4 = loadImage("stone2_normal.jpg");
  colorImage4 = loadImage("stone2_color.jpg");
  
  normalImage5 = loadImage("brickwall3_normal.jpg");
  colorImage5 = loadImage("brickwall3_color.jpg");

  texShader = loadShader("texfrag.glsl", "texvert.glsl");
}

void draw() {    
  background(0);

  switch (selectImage) {
  case 1 :
    can = createCan(150, 300, 32, colorImage1);
    texShader.set("normalMap", normalImage1);
    break;	
  case 2 :
    can = createCan(150, 300, 32, colorImage2);
    texShader.set("normalMap", normalImage2);
    break;	
  case 3 :
    can = createCan(150, 300, 32, colorImage3);
    texShader.set("normalMap", normalImage3);
    break;
  case 4 :
    can = createCan(150, 300, 32, colorImage4);
    texShader.set("normalMap", normalImage4);
    break;
  case 5 :
    can = createCan(150, 300, 32, colorImage5);
    texShader.set("normalMap", normalImage5);
    break;
  }

  shader(texShader); 

  pointLight(255, 255, 255, width/2, height/2, 200); 

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

void keyPressed() {
  if (keyCode == '1') {
    selectImage = 1;
  } else if (keyCode == '2') {
    selectImage = 2;
  } else if (keyCode == '3') {
    selectImage = 3;
  } else if (keyCode == '4') {
    selectImage = 4;
  } else if (keyCode == '5') {
    selectImage = 5;
  }
}

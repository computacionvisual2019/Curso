/*
Seis iluciones opticas:
  2 estaticas, 2 en movimiento automatico y 2 interactivas.
  Para cambiar de ilusion utilice las flechas izquierda y derecha, 
    para revelar la ilusion (si asi lo admite la imagen) utilice la tecla de espacio  
*/
int FN = 0;
int actual = 0;
boolean show = true;
int Y = 40;
int s = 0;

void setup() {
  size(700, 700);
}

void draw() {
  background(255);
  switch (actual) {
  case 0:
    hering_illusion();
    break ;
  case 1:
    illusionPoints();
    break;
  case 2:
    illusion_structure();
    break;
  case 3:
    illusionSquares();
    break;
  case 4:
    break;
  case 5:  
    break;
  }
}

/* 
 Nombre: Hering_illusion. 
 Autor: Greg Wittmann  
 Descripcion: lineas que parecen curvarse al rededor de un punto central.
 Tomado y adaptado de https://www.openprocessing.org/sketch/168636/
 */

void hering_illusion() {
  colorMode(RGB, 255); 
  translate(width/2, height/2);
  stroke(0, 0, 100);
  strokeWeight(2);
  if (show) {
    for (int i=0; i<490; i+=10) {
      rotate(5);
      line(0, 0, 400, 400);
    }
    rotate(-245);
  }

  strokeWeight(4);
  stroke(200, 0, 0);
  translate(-width/2, -height/2);
  line(270, 0, 270, height);
  line(430, 0, 430, height);
}


/* 
 Nombre: Illusion Structures. 
 Autor:  Connor.
 Descripcion: Figura que se deforma sin un sentido racional.
 Tomado y adaptado de https://www.openprocessing.org/sketch/413457
 */


void illusion_structure() {
  colorMode(RGB, 255);
  rectMode(CENTER);
  strokeWeight(1);
  stroke(200, 0, 0);
  for (int j = 0; j < 50; j++) {
    float i = 0;
    while (i < 25) {
      fill(99, 80, 100);
      push();
      translate(width/2, i*15+j);
      scale(i * .08);
      rotate((radians(frameCount)));
      rect(0+j/i, i-j, 10*i, 20);
      pop();
      i++;
    }
    j++;
  }

  rectMode(CORNER);
}

void illusionPoints(){
  noStroke();
  strokeWeight(1);
  colorMode(HSB, 360, 255, 255);
  background(0, 0, 0);
  pushMatrix();
  translate(width/2, height/2);
  if (!show) {
    stroke(100);
    for (int i=0; i<20; i++) {
      rotate(TWO_PI/20);  
      line(250, 0, 5, 0);
    }
  }
  for (int i=0; i<20; i++) {
    rotate(TWO_PI/20);
    fill(360*i/20, 255, 255);
    ellipse(100*(1.1+1*cos(.075*FN+PI*6*i/20)), 0, 15, 15);
  }
  popMatrix();
  FN++;
}

void illusionSquares(){
  int side = 80;
  if (Y >= height-side/2) {
    s = 1;
  }
  if (Y == side/2) {
    s = 0;
  }
  if (s == 0) {
    Y++;
  } else {
    Y--;
  }
  
  rectMode(CORNER);
  noStroke();
  fill(0);
  if(show) {
    for (int y=0; y<700; y=y+40) {
      rect(0, y, 700, 20);
    }
  }
  
  rectMode(CENTER);
  fill(0, 0, 30);
  rect(320, Y, side, side);
  rect(640, Y, side, side);
  fill(255, 255, 0);
  rect(160, Y, side, side);
  rect(480, Y, side, side);
}

void keyPressed() {
  if (keyCode == LEFT) {
    actual = ((actual % 6) + 5) % 6 ;
    println(actual);
  } else if (keyCode == RIGHT) {
    actual = ((actual + 1) % 6);
    println(actual);
  } else if (key == ' ') {
    show = !show;
    println(show);
  }
}

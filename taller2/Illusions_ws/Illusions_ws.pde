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
boolean Ink = true;
int points=1000;



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
    crossed();
    break;
  case 5:  
    vanishingPoint();
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
}


/* 
 Nombre: Illusion. 
 Autor: Femto-physique  
 Descripcion: La estructura parece rotar en torno a un eje central estatico.
 Tomado y adaptado de https://www.openprocessing.org/sketch/707417
 */

void illusionPoints() {
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


/* 
 Nombre: Stepping Feet. 
 Autor: Greg Wittmann  
 Descripcion: Los cuadrados parecen estar avanzando en forma asincrona.
 Tomado y adaptado de https://www.openprocessing.org/sketch/168574
 */

void illusionSquares() {
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
  if (show) {
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


/*
Nombre: Impossible object
 Descripcion: Un objeto ambiguo en su parte superior e inferior
 Tomado de: https://www.imagenesmi.com/im%C3%A1genes/impossible-objects-illusions-fa.html
 */

void crossed() {
  stroke(200);
  background(25);
  line(448, 18, 115, 215);
  line(448, 18, 490, 50);
  line(490, 50, 180, 238);
  line(180, 238, 115, 215);
  line(115, 215, 115, 525);//
  line(115, 525, 430, 682);
  line(430, 682, 490, 650);
  line(490, 650, 490, 50);
  line(180, 238, 180, 470);
  line(180, 470, 380, 570);//
  line(180, 470, 235, 440);
  line(235, 440, 235, 260);
  line(235, 260, 430, 140);
  line(430, 682, 430, 140);
  line(380, 570, 380, 170);//
  line(235, 440, 380, 510);

  line(380, 170, 430, 140);

  stroke(300);                   
  colorMode( HSB, 340, 60, 90 );
  fill( 28, 100, 50 );
  beginShape();
  vertex(180, 470);
  vertex(235, 440);
  vertex(380, 510);
  vertex(380, 570);
  endShape();

  stroke(300);                   
  colorMode( HSB, 340, 60, 60 );
  fill( 28, 100, 50 );
  beginShape();
  vertex(448, 18); 
  vertex(115, 215);
  vertex(448, 18);
  vertex(490, 50);
  vertex(490, 50);
  vertex(180, 238);
  vertex(180, 238);
  vertex(115, 215);
  endShape();

  stroke(300);                   
  colorMode( HSB, 340, 60, 50 );
  fill( 28, 100, 50 );
  beginShape();
  vertex(490, 50);
  vertex(180, 238);
  vertex(180, 238);
  vertex(180, 470);
  vertex(180, 470);
  vertex(235, 440);
  vertex(235, 440);
  vertex(235, 260);
  vertex(235, 260);
  vertex(430, 140);
  vertex(430, 682);
  vertex(430, 140);
  vertex(430, 682);
  vertex(490, 650);
  vertex(490, 650);
  vertex(490, 50);
  endShape();
}


/*
Nombre: Vanishing point
 Autor: Shane Solari.
 Descripcion: Lineas que surgen desde un punto central y que siguen la dirección del mouse a medida que este se desplaza por la pantalla
 Tomado y adaptado de : https://www.openprocessing.org/sketch/523058
 */

void vanishingPoint() {

  if (Ink == true) {
    background(100);
    for (int x=200; x<points; x+=200) {
      for (int y=200; y<points; y+=200) {
        line(mouseX + x - 500, mouseY + y - 500, width/2, height/2);
      }
    }
  } else {
    noLoop();
  }
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

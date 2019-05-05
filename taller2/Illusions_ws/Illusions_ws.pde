/*
Seis iluciones opticas:
  2 estaticas, 2 en movimiento automatico y 2 interactivas.
  Para cambiar de ilusion utilice las flechas izquierda y derecha, 
    para revelar la ilusion (si asi lo admite la imagen) utilice la tecla de espacio  
*/

int actual = 0;
boolean show = true;

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
    break;
  case 2:
    illusion_structure();
    break;
  case 3:
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

  rectMode(CENTER);
  strokeWeight(1);
  
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



void keyPressed() {
  if (keyCode == LEFT) {
    actual = ((actual % 6) + 5) % 6 ;
    println(actual);
  } else if (keyCode == RIGHT) {
    actual = (actual % 5) + 1;
    println(actual);
  } else if (key == ' ') {
    show = !show;
    println(show);
  }
}

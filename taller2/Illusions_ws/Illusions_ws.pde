
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
 Hering_illusion. 
 Tomado y adaptado de https://www.openprocessing.org/sketch/168636/
 Autor: Greg Wittmann	
 Descripcion: lineas que parecen curvarse al rededor de un punto central.
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

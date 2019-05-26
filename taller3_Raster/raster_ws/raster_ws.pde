import nub.timing.*;
import nub.primitives.*;
import nub.core.*;
import nub.processing.*;

// 1. Nub objects
Scene scene;
Node node;
Vector v1, v2, v3;
// timing
TimingTask spinningTask;
boolean yDirection;
// scaling is a power of 2
int n = 4;

// 2. Hints
boolean triangleHint = true;
boolean gridHint = true;
boolean debug = true;

// 3. Use FX2D, JAVA2D, P2D or P3D
String renderer = P3D;

// 4. Window dimension
int dim = 10;



void settings() {
  size(int(pow(2, dim)), int(pow(2, dim)), renderer);
}



void setup() {
  scene = new Scene(this);
  if (scene.is3D())
    scene.setType(Scene.Type.ORTHOGRAPHIC);
  scene.setRadius(width/2);
  scene.fit(1);

  // not really needed here but create a spinning task
  // just to illustrate some nub.timing features. For
  // example, to see how 3D spinning from the horizon
  // (no bias from above nor from below) induces movement
  // on the node instance (the one used to represent
  // onscreen pixels): upwards or backwards (or to the left
  // vs to the right)?
  // Press ' ' to play it
  // Press 'y' to change the spinning axes defined in the
  // world system.
  spinningTask = new TimingTask() {
    @Override
      public void execute() {
      scene.eye().orbit(scene.is2D() ? new Vector(0, 0, 1) :
        yDirection ? new Vector(0, 1, 0) : new Vector(1, 0, 0), PI / 100);
    }
  };
  scene.registerTask(spinningTask);

  node = new Node();
  node.setScaling(width/pow(2, n));

  // init the triangle that's gonna be rasterized
  randomizeTriangle();
}



void draw() {
  background(0);
  stroke(0, 255, 0);
  if (gridHint)
    scene.drawGrid(scene.radius(), (int)pow(2, n));
  if (triangleHint)
    drawTriangleHint();
  pushMatrix();
  pushStyle();
  scene.applyTransformation(node);
  triangleRaster();
  popStyle();
  popMatrix();
}



// Implement this function to rasterize the triangle.
// Coordinates are given in the node system which has a dimension of 2^n
void triangleRaster() {
  // node.location converts points from world to node. Here we convert v1 to illustrate the idea
  //println("v0: ", node.location(v1).x(), node.location(v1).y(), "  v1: ", node.location(v2).x(), node.location(v2).y(), "  v2: ", node.location(v3).x(), node.location(v3).y());

  float det = ((node.location(v2).x()-node.location(v1).x())*(node.location(v3).y()-node.location(v1).y()))-((node.location(v3).x()-node.location(v1).x())*(node.location(v2).y()-node.location(v1).y()));
  for (int i=-floor(pow(2, n)/2); i<pow(2, n)/2; i++) {
    for (int j=-floor(pow(2, n)/2); j<pow(2, n)/2; j++) {
      if (f_12(i, j, det) && f_23(i, j, det) && f_31(i, j, det)) {
        pushStyle();
        strokeWeight(0.01);    
        rect(i, j, 1, 1);
        popStyle();
      }
    }
  }
  //println(f_23(-5, -5, det));
  //rect(-5,-5,1,1);

  if (debug) {
    pushStyle();
    stroke(255, 255, 0, 125);
    point(round(node.location(v1).x()), round(node.location(v1).y()));
    stroke(255, 0, 0, 125);
    point(round(node.location(v2).x()), round(node.location(v2).y()));
    popStyle();
  }
}



void randomizeTriangle() {
  int low = -width/2;
  int high = width/2;
  v1 = new Vector(random(low, high), random(low, high));
  v2 = new Vector(random(low, high), random(low, high));
  v3 = new Vector(random(low, high), random(low, high));
}



void drawTriangleHint() {
  pushStyle();
  noFill();
  strokeWeight(2);
  stroke(255, 0, 0);
  triangle(v1.x(), v1.y(), v2.x(), v2.y(), v3.x(), v3.y());
  strokeWeight(5);
  stroke(0, 255, 255);
  point(v1.x(), v1.y());
  point(v2.x(), v2.y());
  point(v3.x(), v3.y());
  popStyle();
}


// function from vertex 1 to 2 using the point p
boolean f_12(float px, float py, float det) {
  float first = (floor(node.location(v1).y())-floor(node.location(v2).y()))*px;
  //print("first: "+first);
  float second = (floor(node.location(v2).x())-floor(node.location(v1).x()))*py;
  //print("  second: "+second);
  float third = floor(node.location(v1).x())*floor(node.location(v2).y())-floor(node.location(v1).y())*floor(node.location(v2).x());
  //println("  third: "+third);
  float aux = first+second+third;

  if (det > 0) { //Si los vertices estan ordenados en sentido antihorario 
    if (aux > 0) { //Si p esta a la izquierda del segmento v1 v2
      return true;
    }
  } else {  //Si los vertices estan ordenados en sentido horario 
    if (aux < 0) {  //Si p esta a la derecha del segmento v1 v2
      return true;
    }
  }
  return false;
}


// function from vertex 2 to 3 using the point p
boolean f_23(float px, float py, float det) {
  float first = (floor(node.location(v2).y())-floor(node.location(v3).y()))*px;
  //print("first: "+first);
  float second = (floor(node.location(v3).x())-floor(node.location(v2).x()))*py;
  //print("  second: "+second);
  float third = floor(node.location(v2).x())*floor(node.location(v3).y())-floor(node.location(v2).y())*floor(node.location(v3).x());
  //println("  third: "+third);
  float aux = first+second+third;

  if (det > 0) { //Si los vertices estan ordenados en sentido antihorario 
    if (aux > 0) { //Si p esta a la izquierda del segmento v1 v2
      return true;
    }
  } else {  //Si los vertices estan ordenados en sentido horario 
    if (aux < 0) {  //Si p esta a la derecha del segmento v1 v2
      return true;
    }
  }
  return false;
}


// function from vertex 3 to 1 using the point p
boolean f_31(float px, float py, float det) {
  float first = (floor(node.location(v3).y())-floor(node.location(v1).y()))*px;
  //print("first: "+first);
  float second = (floor(node.location(v1).x())-floor(node.location(v3).x()))*py;
  //print("  second: "+second);
  float third = floor(node.location(v3).x())*floor(node.location(v1).y())-floor(node.location(v3).y())*floor(node.location(v1).x());
  //println("  third: "+third);
  float aux = first+second+third;

  if (det > 0) { //Si los vertices estan ordenados en sentido antihorario 
    if (aux > 0) { //Si p esta a la izquierda del segmento v1 v2
      return true;
    }
  } else {  //Si los vertices estan ordenados en sentido horario 
    if (aux < 0) {  //Si p esta a la derecha del segmento v1 v2
      return true;
    }
  }
  return false;
}



void keyPressed() {
  if (key == 'g')
    gridHint = !gridHint;
  if (key == 't')
    triangleHint = !triangleHint;
  if (key == 'd')
    debug = !debug;
  if (key == '+') {
    n = n < 7 ? n+1 : 2;
    node.setScaling(width/pow( 2, n));
  }
  if (key == '-') {
    n = n >2 ? n-1 : 7;
    node.setScaling(width/pow( 2, n));
  }
  if (key == 'r')
    randomizeTriangle();
  if (key == ' ')
    if (spinningTask.isActive())
      spinningTask.stop();
    else
      spinningTask.run(20);
  if (key == 'y')
    yDirection = !yDirection;
}

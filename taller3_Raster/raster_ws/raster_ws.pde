import java.util.ArrayList;
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
int dim = 9;

// Determinant
float det = 0;

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

  det = ((node.location(v2).x()-node.location(v1).x())*(node.location(v3).y()-node.location(v1).y()))-((node.location(v3).x()-node.location(v1).x())*(node.location(v2).y()-node.location(v1).y()));

  for (float i=-pow(2, n)/2; i<pow(2, n)/2; i++) {
    for (float j=-pow(2, n)/2; j<pow(2, n)/2; j++) {

      Result w0 = edgeFunction(v1, v2, i, j, det); 
      Result w1 = edgeFunction(v2, v3, i, j, det);
      Result w2 = edgeFunction(v3, v1, i, j, det);

      if (w0.getRender() && w1.getRender() && w2.getRender()) {

        float total = w0.getArea()+w1.getArea()+w2.getArea();
        w0.setNormalArea(w0.getArea()/total);
        w1.setNormalArea(w1.getArea()/total);
        w2.setNormalArea(w2.getArea()/total);

        float r = w0.getNormalArea() * 1 + w1.getNormalArea() * 0 + w2.getNormalArea() * 0; 
        float g = w0.getNormalArea() * 0 + w1.getNormalArea() * 1 + w2.getNormalArea() * 0;
        float b = w0.getNormalArea() * 0 + w1.getNormalArea() * 0 + w2.getNormalArea() * 1;

        pushStyle();
        strokeWeight(0.01);
        fill(r*255, g*255, b*255);
        rect(i, j, 1, 1);
        popStyle();

        if (w0.getArea() < tolerance(v1, v2)) {
          float average = border(int(i), int(j), w0.getVa(), w0.getVb());
          pushStyle();
          strokeWeight(0.01);
          fill(r*255*average, g*255*average, b*255*average);
          rect(i, j, 1, 1);
          popStyle();
        } else if (w1.getArea() < tolerance(v2, v3)) {
          float average = border(int(i), int(j), w1.getVa(), w1.getVb());           
          pushStyle();
          strokeWeight(0.01);
          fill(r*255*average, g*255*average, b*255*average);
          rect(i, j, 1, 1);
          popStyle();
        } else if (w2.getArea() < tolerance(v1, v2)) {
          float average = border(int(i), int(j), w2.getVa(), w2.getVb());
          pushStyle();
          strokeWeight(0.01);
          fill(r*255*average, g*255*average, b*255*average);
          rect(i, j, 1, 1);
          popStyle();
        }
      }
    }
  }

  if (debug) {
    pushStyle();
    stroke(255, 255, 0, 125);
    point(round(node.location(v1).x()), round(node.location(v1).y()));
    stroke(255, 0, 0, 125);
    point(round(node.location(v2).x()), round(node.location(v2).y()));
    popStyle();
  }
}


// tolerancia: area maxima permitida para el triangulo
float tolerance(Vector va, Vector vb) {
  float xVertex = pow((node.location(vb).x()-node.location(va).x()), 2);
  float yVertex = pow((node.location(vb).y()-node.location(va).y()), 2);
  return sqrt(xVertex+yVertex)/sqrt(2);
}



// tolerancia: area maxima permitida para el pixel
float tolerancePixel(Vector va, Vector vb) {
  float xVertex = pow((node.location(vb).x()-node.location(va).x()), 2);
  float yVertex = pow((node.location(vb).y()-node.location(va).y()), 2);
  return sqrt(xVertex+yVertex)*sqrt(0.125)/2;
}



float border(int px, int py, Vector va, Vector vb) {
  int count = 0;
  float n = 32;
  ArrayList<Float> steps = new ArrayList <Float>();
  for (int k = 0; k < n; ++k) {
     steps.add(k/n);
  }
  for (float i : steps) {
    for (float j : steps) {
      if (pixelEdge(va, vb, px+i, py+j, det)) {
        count ++;
      }
    }
  }

  return (count/pow(n, 2));
} 



//function from vertex a to b according to the point p and the determinant p
Result edgeFunction(Vector va, Vector vb, float px, float py, float det) {
  float first = (floor(node.location(va).y())-floor(node.location(vb).y()))*px;
  float second = (floor(node.location(vb).x())-floor(node.location(va).x()))*py;
  float third = floor(node.location(va).x())*floor(node.location(vb).y())-floor(node.location(va).y())*floor(node.location(vb).x());
  float aux = first+second+third;

  float tolerance = tolerance(va, vb);

  if (det > 0) { //Si los vertices estan ordenados en sentido antihorario 
    if (aux > -tolerance) { //Si p esta a la izquierda del segmento v1 v2
      return new Result(true, abs(aux), va, vb);
    }
  } else {  //Si los vertices estan ordenados en sentido horario 
    if (aux < tolerance) {  //Si p esta a la derecha del segmento v1 v2
      return new Result(true, abs(aux), va, vb);
    }
  }
  return new Result(false, abs(aux));
}



//function from vertex a to b according to the point p inside a pixel
boolean pixelEdge(Vector va, Vector vb, float px, float py, float det) {
  float first = (floor(node.location(va).y())-floor(node.location(vb).y()))*px;
  float second = (floor(node.location(vb).x())-floor(node.location(va).x()))*py;
  float third = floor(node.location(va).x())*floor(node.location(vb).y())-floor(node.location(va).y())*floor(node.location(vb).x());
  float aux = first+second+third;

  float tolerance = tolerancePixel(va, vb);

  if (det > 0) { //Si los vertices estan ordenados en sentido antihorario 
    if (aux > -tolerance) { //Si p esta a la izquierda del segmento v1 v2
      return true;
    }
  } else {  //Si los vertices estan ordenados en sentido horario 
    if (aux < tolerance) {  //Si p esta a la derecha del segmento v1 v2
      return true;
    }
  }
  return false;
}



void randomizeTriangle() {
  int low = -width/2;
  int high = width/2;
  v1 = new Vector(random(low, high), random(low, high));
  v2 = new Vector(random(low, high), random(low, high));
  v3 = new Vector(random(low, high), random(low, high));
  //v2 = new Vector(255, -120);
  //v1 = new Vector(-180, -220);
  //v3 = new Vector(-220, 100);
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


public class Result {
  private boolean render;
  private float area;
  private float normalArea = 0; 
  private Vector va;
  private Vector vb;

  public Result(boolean render, float area, Vector va, Vector vb) {
    this.va = va;
    this.vb = vb;
    this.render = render;
    this.area = area;
  }

  public Result(boolean render, float area) {
    this.render = render;
    this.area = area;
  }

  public boolean getRender() {
    return this.render;
  }

  public float getArea() {
    return abs(this.area);
  }

  public Vector getVa() {
    return this.va;
  }

  public Vector getVb() {
    return this.vb;
  }

  public float getNormalArea() {
    return this.normalArea;
  }

  public void setNormalArea(float normalArea) {
    this.normalArea = normalArea;
  }
}

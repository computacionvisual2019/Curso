import nub.timing.*;
import nub.primitives.*;
import nub.core.*;
import nub.processing.*;

// 1. Nub objects
Scene scene;
Node l1, l2, l3, can1;
color c1;
PShape sphere, sphere2, sphere3, can;
float angle;
PShader pixlightShader;

String renderer = P3D;

void settings() {
  size(1200, 700, P3D);
}

void setup() {
  scene = new Scene(this);
  if (scene.is3D())
    scene.setType(Scene.Type.ORTHOGRAPHIC);
  scene.setRadius(width/2);
  scene.fit();

  pixlightShader = loadShader("pixlightfrag.glsl", "pixlightvert.glsl");

  can = createCan(100, 200, 32);
  sphere = createShape(SPHERE, 50);  
  sphere2 = createShape(SPHERE, 50);  
  sphere3 = createShape(SPHERE, 50);  

  l1 = new Node(scene, sphere);
  l2 = new Node(scene, sphere2);
  l3 = new Node(scene, sphere3);
  can1 = new Node(scene.eye(), can);
  
  l1.setPosition(-200, -250);
  l2.setPosition(200, -250);
  l3.setPosition(0, 250);
  can1.setPosition(0, 0, 0);
  
  l1.setPickingThreshold(0);
  l2.setPickingThreshold(0);
  l3.setPickingThreshold(0);
}

void draw() {
  
  shader(pixlightShader);
  
  pointLight(255, 255, 255, l1.position().x(), l1.position().y(), 200);
  pointLight(255, 255, 255, l2.position().x(), l2.position().y(), 200);
  pointLight(255, 255, 255, l3.position().x(), l3.position().y(), 200);

  scene.render();
}

PShape createCan(float r, float h, int detail) {
  textureMode(NORMAL);
  PShape sh = createShape();
  sh.beginShape(QUAD_STRIP);
  sh.noStroke();
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

void mouseClicked() {
  scene.cast();
}

void mouseDragged() {
  if (scene.trackedNode() == null ) {
    scene.spin();
  } else {
    scene.translate();
  }
}

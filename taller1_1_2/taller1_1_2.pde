PGraphics dogColorPG, dogGreyPG, histoPG;
PImage colorImg, greyImg;


int w, h;
int[] histogram;
float r, g, b, p;


void setup() {
  size(1200, 700);

  colorImg = loadImage("data/colorfull.jpg");
  colorImg.loadPixels();
  w = colorImg.width;
  h = colorImg.height;

  greyImg = createImage(w, h, RGB);
  greyImg.loadPixels();

  histogram = new int[256];

  for (int i = 0; i < w*h; i++) {  
    r = red(colorImg.pixels[i]);
    g = green(colorImg.pixels[i]);
    b = blue(colorImg.pixels[i]);  
    p = (0.2126*r+0.7152*g+0.0722*b);  //  Algoritmo LUMA                                       
    greyImg.pixels[i] = color(p, p, p);  
    histogram[int(p)] ++ ;
  }

  fill(0);
  textSize(23);
  dogColorPG = createGraphics(w, h);
  text("Real image", 170, 40);
  dogGreyPG = createGraphics(w, h);
  text("Gray scale (LUMA)", 500, 40);
  histoPG = createGraphics(256, 256);
  text("Histogram", 880, 40);
  
}

void draw() {
  dogColorPG.beginDraw();
  dogColorPG.image(colorImg, 0, 0);
  dogColorPG.endDraw();
  image(dogColorPG, 100, 80);
  
  dogGreyPG.beginDraw();
  dogGreyPG.image(greyImg, 0, 0);
  dogGreyPG.endDraw();
  image(dogGreyPG, 450, 80);
  
  histoPG.beginDraw();
  histoPG.background(236);
  for (int i = 0; i < 256; i ++) {
    float aux = map(histogram[i], 0, max(histogram), 0, 255);
    histoPG.stroke(i);
    histoPG.line(i, 254-aux, i, 254);
  }
  histoPG.endDraw();
  image(histoPG, 800, 100);
}

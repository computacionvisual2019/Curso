PImage img, img2, img3, img4, img5, img6, img7;
PGraphics pg1, pg2, pg3, pg4, pg5, pg6, pg7;

int w, h;
float hue, saturation, brightness, lightness, r, g, b, p1, p2, p3, p4;

void setup() {

  size(1250, 700);

  img = loadImage("data/bright.jpg");
  w = img.width;
  h = img.height;
  img.loadPixels();

  img2 = createImage(w, h, RGB);
  img2.loadPixels();
  img3 = createImage(w, h, RGB);
  img3.loadPixels();
  img4 = createImage(w, h, RGB);
  img4.loadPixels();
  img5 = createImage(w, h, RGB);
  img5.loadPixels();
  img6 = createImage(w, h, RGB);
  img6.loadPixels();
  img7 = createImage(w, h, RGB);
  img7.loadPixels();

  for (int i = 0; i < img.pixels.length; i++) {
    brightness = brightness(img.pixels[i]);  //  = max(r,g,b)
    r = red(img.pixels[i]);
    g = green(img.pixels[i]);
    b = blue(img.pixels[i]);  
    lightness = (max(r, g, b) + min(r, g, b))/2;
    p1 = (r+g+b)/3;
    p2 = (0.299*r+0.587*g+0.114*b);
    p3 = (0.2126*r+0.7152*g+0.0722*b);
    p4 = (0.212*r+0.701*g+0.087*b);
    img2.pixels[i] = color(p1, p1, p1);
    img3.pixels[i] = color(brightness, brightness, brightness);  //  HSV
    img4.pixels[i] = color(lightness, lightness, lightness);
    img5.pixels[i] = color(p2, p2, p2);
    img6.pixels[i] = color(p3, p3, p3);
    img7.pixels[i] = color(p4, p4, p4);

  }

  fill(0);
  textSize(23);
  pg1 = createGraphics(w, h);  
  text("Real image", 120, 40);
  pg2 = createGraphics(w, h);   
  text("Mean", 450, 40);
  pg3 = createGraphics(w, h);
  text("HSV", 760, 40);
  pg4 = createGraphics(w, h);
  text("HSL", 1050, 40);
  pg5 = createGraphics(w, h);
  text("Luma CCIR_601", 230, 680);
  pg6 = createGraphics(w, h);
  text("Luma BT. 709 de la ITU-R", 475, 680);
  pg7 = createGraphics(w, h);
  text("Luma SMPTE 240M", 820, 680);
  
  
  print(red(img.pixels[100]), green(img.pixels[100]), blue(img.pixels[100]), brightness(img.pixels[100]));
}

void draw() {
  pg1.beginDraw();
  pg1.image(img, 0, 0);  
  pg1.endDraw();
  image(pg1, 20, 50);

  pg2.beginDraw();
  pg2.image(img2, 0, 0);  
  pg2.endDraw();
  image(pg2, 320, 50);

  pg3.beginDraw();
  pg3.image(img3, 0, 0);  
  pg3.endDraw();
  image(pg3, 620, 50);

  pg4.beginDraw();
  pg4.image(img4, 0, 0);  
  pg4.endDraw();
  image(pg4, 920, 50);

  pg5.beginDraw();
  pg5.image(img5, 0, 0);  
  pg5.endDraw();
  image(pg5, 170, 350);
  
  pg6.beginDraw();
  pg6.image(img6, 0, 0);  
  pg6.endDraw();
  image(pg6, 470, 350);
  
  pg7.beginDraw();
  pg7.image(img7, 0, 0);  
  pg7.endDraw();
  image(pg7, 770, 350);
}

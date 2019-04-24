PGraphics dogColorPG, dogGrayPG, histogramPG, focusImgPG, histoRGBPG, originalImageTitlePG, grayTitlePG, grayHistogramPG, rgbHistoPG, focusPG;
PImage dogColor, dogGray, focusImg, originalImageTitle, grayTitle, grayHistogram, rgbHisto, focus;

int[] histogram;
int[] histoGreen;
int[] histoRed;
int[] histoBlue;

float r, g, b, p = 0.0;  //  Variables para asignar los colores de cada pixel
int w, h;  //  variables de ancho y alto de la imagen

void settings() {
  size(900,700);
}

void setup() {

  dogColor = loadImage("data/colorfull.jpg");
  dogColor.loadPixels();
  w = dogColor.width;
  h = dogColor.height;
  dogGray = createImage(w, h, RGB);  //  Imagen vacia para replicar en escala de grises 
  dogGray.loadPixels();
  focusImg = createImage(w, h, RGB);  //  Imagen vacia para replicar con mascara de enfoque
  focusImg.loadPixels();
  
  originalImageTitle = loadImage("data/original.jpg");
  grayTitle = loadImage("data/grayImage.jpg");
  grayHistogram = loadImage("data/grayHistogram.jpg");
  rgbHisto = loadImage("data/rgb.jpg");
  focus = loadImage("data/focus.jpg");
  
  histogram = new int [256];  
  histoGreen = new int [256];
  histoRed = new int [256];
  histoBlue = new int [256];
  

  //  Creacion de la imagen en escala de grises
  grayScale(dogColor.pixels, dogGray.pixels);
  
  //  Creacion de la imagen con mascara de enfoque
  focusMask(dogColor.pixels, focusImg.pixels);


  //  Creacion de los objetos PGraphics para cada imagen
  dogColorPG = createGraphics(w, h);  // imagen color
  originalImageTitlePG = createGraphics(originalImageTitle.width, originalImageTitle.height);
  grayTitlePG = createGraphics(grayTitle.width, grayTitle.height);
  grayHistogramPG = createGraphics(grayHistogram.width, grayHistogram.height);
  rgbHistoPG = createGraphics(rgbHisto.width, rgbHisto.height);
  focusPG = createGraphics(focus.width, focus.height);
  dogGrayPG = createGraphics(w, h);  // imagen gris  
  histogramPG = createGraphics(255, 255); //histograma
  histoRGBPG = createGraphics(255,255); //histograma verde
  focusImgPG = createGraphics(w, h); //focus mask
}


void draw() {
  stroke(#F71131);
  strokeWeight(3);
  line(625, 0, 625, 700);
  line(0, 340, 622, 340);
  
  originalImageTitlePG.beginDraw();
  originalImageTitlePG.image(originalImageTitle,0,0);
  originalImageTitlePG.endDraw();
  image(originalImageTitlePG, 30,2 );
  
  grayTitlePG.beginDraw();
  grayTitlePG.image(grayTitle,0,0);
  grayTitlePG.endDraw();
  image(grayTitlePG, 370,2);
  
  grayHistogramPG.beginDraw();
  grayHistogramPG.image(grayHistogram,0,0);
  grayHistogramPG.endDraw();
  image(grayHistogramPG, 635,2);
  
  rgbHistoPG.beginDraw();
  rgbHistoPG.image(rgbHisto,0,0);
  rgbHistoPG.endDraw();
  image(rgbHistoPG, 655,360);
  
  focusPG.beginDraw();
  focusPG.image(focus,0,0);
  focusPG.endDraw();
  image(focusPG, 70,345);
  
  dogColorPG.beginDraw();
  dogColorPG.image(dogColor, 0, 0);  //  Asignacion de la imagen a color al primer objeto PGraphic
  dogColorPG.endDraw();
  image(dogColorPG, 10, (height-2*h)/3);  //  Dibujo de la imagen a color

  dogGrayPG.beginDraw();
  dogGrayPG.image(dogGray, 0, 0);  //  Asignacion de la imagen en escala de grises al segundo objeto PGraphic
  dogGrayPG.endDraw();
  image(dogGrayPG, 320, (height-2*h)/3);  //  Dibujo de la segunda imagen en escala de grises

  histogramPG.beginDraw();
  histogramPG.stroke(0);
  histogramPG.background(255);
  for (int i = 0; i < 256; i ++) {
    float aux = map(histogram[i], 0, max(histogram), 0, 255);
    histogramPG.line(i, 254-aux, i, 254);
  } 
  histogramPG.endDraw();
  image(histogramPG, 630, (height-2*histogramPG.height)/3);
  
  histoRGBPG.beginDraw();
  histoRGBPG.stroke(#268304);
  histoRGBPG.background(255);
  for (int i = 0; i < 256; i ++) {
    float aux = map(histoGreen[i], 0, max(histoGreen), 0, 255);
    histoRGBPG.line(i, 254-aux, i, 254);
  } 
  histoRGBPG.stroke(#F71131);
  for (int i = 0; i < 256; i ++) {
    float auxRed = map(histoRed[i], 0, max(histoRed), 0, 255);
    histoRGBPG.line(i, 254-auxRed, i, 254);
  }
  histoRGBPG.stroke(#113EF7);
  for (int i = 0; i < 256; i ++) {
    float auxBlue = map(histoBlue[i], 0, max(histoBlue), 0, 255);
    histoRGBPG.line(i, 254-auxBlue, i, 254);
  }
  
  histoRGBPG.endDraw();
  image(histoRGBPG, 630, 350 + (height-2*histoRGBPG.height)/3);
  
  focusImgPG.beginDraw();
  focusImgPG.image(focusImg, 0, 0);
  focusImgPG.endDraw();
  image(focusImgPG, 10, 15+((height-2*h)*2/3)+h);
}


void grayScale(int[] originalImg, int[] newImage) {
  for (int i = 0; i < originalImg.length; i++) {  
    //  Extraccion de los colores rgb de los pixeles de la imagen a color
    r = red(originalImg[i]);
    g = green(originalImg[i]);
    b = blue(originalImg[i]);  
    p = int((0.2126*r+0.7152*g+0.0722*b));  //  Algoritmo LUMA                                       
    newImage[i] = color(p, p, p);  
    histogram[int(p)] ++ ;
    histoGreen[int(g)] ++;
    histoRed[int(r)] ++;
    histoBlue[int(b)] ++;
  }
}

void focusMask(int[] originalImg, int[] newImage){
  for (int i = 0; i < originalImg.length; i ++){
    
  }
}

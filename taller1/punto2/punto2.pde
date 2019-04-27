// Este codigo corresponde al punto 2 del taller 1:
//    Aplicación de algunas máscaras de convolución.


PGraphics dogColorPG, dogGreyPG, histoPG;
PImage colorImg, greyImg, aclaradoImg, blurImg;


int w, h;
int[] histogram;
float r, g, b, p;
float [][] sharpen = { { 0, -1, 0 },
                     { -1,  5, -1 },
                     { 0, -1, 0 } }; 

float [][] blurred = { { 1, 1, 1 },
                     { 1,  1, 1 },
                     { 1, 1, 1 } }; 

void setup() {
  size(1200, 730);
  colorImg = loadImage("data/colorfull.jpg");
  colorImg.loadPixels();
  w = colorImg.width;
  h = colorImg.height;
  
  //pasa la imagen a una matriz
  aclaradoImg = loadImage("data/colorfull.jpg");//sharp
  blurImg = loadImage("data/colorfull.jpg");//blurred
  
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
  text("Real image", 170, 20);
  dogGreyPG = createGraphics(w, h);
  text("Gray scale (LUMA)", 500, 20);
  histoPG = createGraphics(256, 236);
  text("Histogram", 880, 20);
  text("Convolution mask (Sharp)",35,395);
  
  
}

void draw() {
  dogColorPG.beginDraw();
  dogColorPG.image(colorImg, 0, 0);
  dogColorPG.endDraw();
  image(dogColorPG, 100, 50);
  
  dogGreyPG.beginDraw();
  dogGreyPG.image(greyImg, 0, 0);
  dogGreyPG.endDraw();
  image(dogGreyPG, 450, 50);
  
  histoPG.beginDraw();
  histoPG.background(236);
  for (int i = 0; i < 256; i ++) {
    float aux = map(histogram[i], 0, max(histogram), 0, 255);
    histoPG.stroke(i);
    histoPG.line(i, 254-aux, i, 254);
  }
  histoPG.endDraw();
  image(histoPG, 800, 70);
  
  image(aclaradoImg,20,410);
  int matrixsize = sharpen.length;
  aclaradoImg.loadPixels();
  for(int x = 0; x < aclaradoImg.width; x++){
    for(int y = 0; y < aclaradoImg.height; y++){
      color c = convolucion(x,y, sharpen, matrixsize, aclaradoImg, 1);
      int loc = x + y*aclaradoImg.width;
      aclaradoImg.pixels[loc] = c;
    }
  }
  aclaradoImg.updatePixels();
  
  image(blurImg,20,410);
  matrixsize = blurred.length;
  blurImg.loadPixels();
  int divisor = 9;
  for(int x = 0; x < blurImg.width; x++){
    for(int y = 0; y < blurImg.height; y++){
      color c = convolucion(x,y, sharpen, matrixsize, aclaradoImg, divisor);
      int loc = x + y*aclaradoImg.width;
      aclaradoImg.pixels[loc] = c;
    }
  }
  aclaradoImg.updatePixels();
}


color convolucion(int x, int y, float[][] matrix, int matrixsize, PImage img, int divisor)
{
  float rtotal = 0.0;
  float gtotal = 0.0;
  float btotal = 0.0;
  int offset = matrixsize / 2;
  for (int i = 0; i < matrixsize; i++){
    for (int j= 0; j < matrixsize; j++){
      //ver el pixel que se va a modificar
      int xloc = x+i-offset;
      int yloc = y+j-offset;
      int loc = xloc + img.width*yloc;
      // asegurar que no se sale del margen
      loc = constrain(loc,0,img.pixels.length-1);
      // aplicar la convolucion del filtro
      rtotal += (red(img.pixels[loc]) * matrix[i][j]) / divisor;
      gtotal += (green(img.pixels[loc]) * matrix[i][j]) / divisor;
      btotal += (blue(img.pixels[loc]) * matrix[i][j]) / divisor;
    }
  }
  // ver que si este en el rango
  rtotal = constrain(rtotal, 0, 255);
  gtotal = constrain(gtotal, 0, 255);
  btotal = constrain(btotal, 0, 255);
  // Return the resulting color
  return color(rtotal, gtotal, btotal);
}

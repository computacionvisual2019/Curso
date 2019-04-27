PGraphics dogColorPG, dogGreyPG, histoPG;
PImage colorImg, greyImg, aclaradoImg, blurImg, edgesImg, embossImg;


int w, h;
int[] histogram;
int matrixsize = 0;
int divisor = 0;
float r, g, b, p;
float [][] sharpen = { { 0, -1, 0 },
                     { -1,  5, -1 },
                     { 0, -1, 0 } }; 

float [][] blurred = { { 0.0625, 0.125, 0.0625 },
                     { 0.125,  0.25, 0.125 },
                     { 0.0625, 0.125, 0.0625 } }; 
                     
float [][] edges = { { -1, -1, -1 },
                     { -1,  8, -1 },
                     { -1, -1, -1 } }; 
                     
float [][] emboss = { { -2, -1, 0 },
                     { -1,  -1, 1},
                     { 0, 1, -2 } }; 

void setup() {
  size(1200, 730);
  colorImg = loadImage("data/colorfull.jpg");
  colorImg.loadPixels();
  w = colorImg.width;
  h = colorImg.height;
  
  //pasa la imagen a una matriz
  aclaradoImg = loadImage("data/colorfull.jpg");//sharp
  blurImg = loadImage("data/colorfull.jpg");//blurred
  edgesImg = loadImage("data/colorfull.jpg");//edge
  embossImg = loadImage("data/colorfull.jpg");//emboss
  
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
  textSize(20);
  text("Convolution mask(Sharp)",0,395);
  text("Convolution mask(Blur)",300,395);
  text("Convolution mask(Edges)",590,395);
  text("Convolution mask(Emboss)",870,395);
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
  
  image(aclaradoImg,0,410);
  matrixsize = sharpen.length;
  aclaradoImg.loadPixels();
  for(int x = 0; x < aclaradoImg.width; x++){
    for(int y = 0; y < aclaradoImg.height; y++){
      color c = convolucion(x,y, sharpen, matrixsize, aclaradoImg, 1);
      int loc = x + y*aclaradoImg.width;
      aclaradoImg.pixels[loc] = c;
    }
  }
  aclaradoImg.updatePixels();
  
  image(blurImg,290,410);
  matrixsize = blurred.length;
  blurImg.loadPixels();
  divisor = 1;
  for(int x = 0; x < blurImg.width; x++){
    for(int y = 0; y < blurImg.height; y++){
      color c = convolucion(x,y, blurred, matrixsize, blurImg, divisor);
      int loc = x + y*blurImg.width;
      blurImg.pixels[loc] = c;
    }
  }
  blurImg.updatePixels();
  
  image(edgesImg,580,410);
  matrixsize = edges.length;
  edgesImg.loadPixels();
  divisor = 1;
  for(int x = 0; x < edgesImg.width; x++){
    for(int y = 0; y < edgesImg.height; y++){
      color c = convolucion(x,y, edges, matrixsize, edgesImg, divisor);
      int loc = x + y*edgesImg.width;
      edgesImg.pixels[loc] = c;
    }
  }
  edgesImg.updatePixels();
  
  image(embossImg,860,410);
  matrixsize = edges.length;
  embossImg.loadPixels();
  divisor = 1;
  for(int x = 0; x < embossImg.width; x++){
    for(int y = 0; y < embossImg.height; y++){
      color c = convolucion(x,y, emboss, matrixsize, embossImg, divisor);
      int loc = x + y*embossImg.width;
      embossImg.pixels[loc] = c;
    }
  }
  embossImg.updatePixels();
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

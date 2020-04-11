// Hello PContour!
// Realtime Random Shapes Demo

// PContour is a library for finding contours in binary images and approximating polylines.
// It implements the same algorithms as OpenCV's findContours and approxPolyDP.


import pcontour.*;


int[] im;           // the image stored as bitmap

ArrayList<PContour.Contour> contours; // To store contours calculated by PContour
int COLOR_BG = 200;
int COLOR_FG = 250;

PGraphics buff;

void setup(){
  size(600,600);
  im = new int[width*height];
  contours = new ArrayList<PContour.Contour>();
  
  background(COLOR_BG);
  buff = createGraphics(width,height);
  buff.beginDraw();
  buff.background(COLOR_BG);
  buff.endDraw();
  //noLoop();
}

// recompute the contours
void recompute(){ 
  
  // magic!
  contours = new PContour().findContours(im,width,height);
  
  for (int i = 0; i < contours.size(); i++){
    // simplify the contours
    contours.get(i).points = new PContour().approxPolyDP(contours.get(i).points,1);
  }
}

void draw(){
  
  buff.beginDraw();
  buff.noStroke();
  for (int i = 0; i < 1; i++ ){
    buff.fill(random(1)>0.5?COLOR_FG:COLOR_BG);
    if (random(1)>0.5){
      buff.triangle(random(width),random(height),random(width),random(height),random(width),random(height));
    }else{
      buff.ellipse(random(width),random(height),random(width),random(height));
    }
  }
  buff.loadPixels();
  for (int i = 1; i < height-1; i++){
    for (int j = 1; j < width-1; j++){
      im[i*width+j] = red(buff.pixels[i*width+j]) > ((COLOR_FG+COLOR_BG)/2) ? 1:0;
    }
  }
  buff.endDraw();

  recompute();

  background(0);
  image(buff,0,0);
  
  
  // draw the contours!
  for (int i = 0; i < contours.size(); i++){
    noFill();
    strokeWeight(2);
    // different color for holes and non-holes
    if (contours.get(i).isHole){
      stroke(100,0,0);
    }else{
      stroke(0);
    }
    
    beginShape();
    for (int j = 0; j < contours.get(i).points.size(); j++){
      rect(contours.get(i).points.get(j).x-2,
             contours.get(i).points.get(j).y-2,4,4);
      vertex(contours.get(i).points.get(j).x,
             contours.get(i).points.get(j).y);
    }
    endShape(CLOSE);
  }
  
  fill(0);
  text("FPS:"+frameRate,0,10);
}

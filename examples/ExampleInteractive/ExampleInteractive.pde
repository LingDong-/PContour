// Hello PContour!
// Interactive Demo

// PContour is a library for finding contours in binary images and approximating polylines.
// It implements the same algorithms as OpenCV's findContours and approxPolyDP.

// Drag mouse to paint bitmap, Right click to erase.
// Contours and other semantic info will be displayed.

import pcontour.*;

int W_GRID;         // width of each cell
int N_GRID = 30;    // number of cells in each dimension
float NOISE = 0.5f; // add some dynamism to distinguish overlapping contours
int[] im;           // the image stored as bitmap

ArrayList<PContour.Contour> contours; // To store contours calculated by PContour

void setup(){
  size(600,600);
  W_GRID = width/N_GRID;
  im = new int[N_GRID*N_GRID];
  contours = new ArrayList<PContour.Contour>();
}

// recompute the contours
void recompute(){
  
  // clear the semantic information, restore to 0s and 1s
  for (int i = 0; i < N_GRID; i++){
    for (int j = 0; j < N_GRID; j++){
      if (im[i*N_GRID+j] != 0){
        im[i*N_GRID+j] = 1;
      }
    }
  }
  
  // magic!
  contours = new PContour().findContours(im,N_GRID,N_GRID);
  
  for (int i = 0; i < contours.size(); i++){
    
    // simplify the contours; try approxPolyDP for more aggresive approximation!
    contours.get(i).points = new PContour().approxPolySimple(contours.get(i).points);
  }
}

void draw(){
  
  // draw the bitmap and check for mouse down
  for (int i = 0; i < N_GRID; i++){
    for (int j = 0; j < N_GRID; j++){
      stroke(0);
      strokeWeight(1);
      fill(im[i*N_GRID+j]==0?255:0);
      if (j*W_GRID<mouseX&&mouseX<j*W_GRID+W_GRID &&
          i*W_GRID<mouseY&&mouseY<i*W_GRID+W_GRID){
        fill(128);
        if (mousePressed){
          if (mouseButton == LEFT){
            im[i*N_GRID+j] = 1;
          }else{
            im[i*N_GRID+j] = 0;
          }
          recompute();
        }
      
      }
      rect(j*W_GRID,i*W_GRID,W_GRID,W_GRID);
      fill(255,0,0);
      text(im[i*N_GRID+j],j*W_GRID,i*W_GRID+W_GRID);
    }
  }
  
  // draw the contours!
  for (int i = 0; i < contours.size(); i++){
    noFill();
    strokeWeight(2);
    // different color for holes and non-holes
    if (contours.get(i).isHole){
      stroke(255,255,0);
    }else{
      stroke(0,255,255);
    }
    
    beginShape();
    for (int j = 0; j < contours.get(i).points.size(); j++){
      vertex(contours.get(i).points.get(j).x*W_GRID+W_GRID*(1-NOISE)/2+W_GRID*NOISE*noise(i,j,frameCount*0.1),
             contours.get(i).points.get(j).y*W_GRID+W_GRID*(1-NOISE)/2+W_GRID*NOISE*noise(i,j+1,frameCount*0.1));  
    }
    endShape(CLOSE);
    
    // display PARENT ID > SELF ID
    fill(0,255,0);
    text(contours.get(i).parent+">"+contours.get(i).id,contours.get(i).points.get(0).x*W_GRID+W_GRID/2,contours.get(i).points.get(0).y*W_GRID+W_GRID/2);
  }
  fill(0);
  text("Drag to paint bitmap, Right click to erase. Press any key to toggle noise.",0,10);
  
}

void keyPressed(){
  NOISE = NOISE > 0 ? 0 : 0.5f;
}

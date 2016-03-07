// 2d totalitarian cellular automata

// starts as game of life

int num = 500;


int[][] grid, futuregrid;
float density=0.1;

void setup() {
 size(540,100);
 frameRate(8);
 grid = new int[width][height]; 
 futuregrid = new int[width][height];
 
 for(int i=0; i < (int)(density*width*height); i++) {
    grid[(int)random(width)][(int)random(height)] = 1;
 }
 background(0);
}

void draw(){
  for(int x=1; x<width-1; x++)
      for(int y=1; y<height-1; y++){
        
         // count cells
         int cc = neighbors(x,y);
         
         // cases..
         if((grid[x][y] == 1) && cc < 2) { //isolation death
           futuregrid[x][y] = 0;
           set(x,y,color(0));
         }   else if((grid[x][y] == 1) && cc > 3) { //overpop death
           futuregrid[x][y] = 0;
           set(x,y,color(0));
         }     else if((grid[x][y] == 0) && cc == 3) { //birth
           futuregrid[x][y] = 1;
           set(x,y,color(255));
         }
         
           else {
             
              futuregrid[x][y] = grid[x][y]; //survive
             
           }

 
        
        
      }



    //swap grids
    int[][] temp = grid;
    grid = futuregrid;
    futuregrid = temp;
  
}

// count

int neighbors(int x, int y){
  
  return (
          grid[x][y-1] + //north
          grid[x+1][y-1] + //northeast
          grid[x+1][y] + //east
          grid[x+1][y+1] + //southeast
          grid[x][y+1] + //south
          grid[x-1][y+1] + //southwest
          grid[x-1][y] + //west
          grid[x-1][y-1]  //northwest
          );
  
}


void mousePressed(){
  int x = constrain(mouseX,0,width);
  int y = constrain(mouseY,0,height);
  grid[x][y] = 1;
}

void mouseDragged(){
  int x = constrain(mouseX,0,width);
  int y = constrain(mouseY,0,height);
  grid[x][y] = 1;
}

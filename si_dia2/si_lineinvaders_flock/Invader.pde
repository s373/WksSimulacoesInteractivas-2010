class Invader {

  byte bits[];
  int dimx, dimy;
  float scalex, scaley;
  float prob;
  
  Invader() {
    dimx = 4;
    dimy = 8;
    prob = 0.52f;
    build();
  }
  
  void build() {
    float invaderSize = 16.0f;
    scalex = (float)invaderSize / (float)dimx / 2.0f;
    scaley = (float)invaderSize / (float)dimy ;
    bits = new byte[dimx*dimy];
    for(int i=0,idx=0; i<dimx; i++) {
      for(int j=0; j<dimy; j++) {
        bits[idx] = random(1)<prob? (byte)127:(byte)0;
        idx++;
      }
    }
  }
  
  void mouse() {
    build();
  }
  
  void draw(float x, float y) {
    
    pushMatrix();
    translate(x,y,0);
    
    for(int i=0, idx=0; i<dimx; i++) {
      for(int j=0; j<dimy; j++) {
        if(bits[idx]>0)
          fill(255);
        else
          fill(0);

        rect (  (i+0.5) * scalex, (j+0.5) * scaley, scalex, scaley );
        rect (  (2*dimx-i-0.5) * scalex, (j+0.5) * scaley, scalex, scaley );
        idx++;
      }
    }
    
    popMatrix();
  }
}


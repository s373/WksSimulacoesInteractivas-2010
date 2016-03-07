class airborn{
  city cini,cfim;
  PVector ini,mid,fim,now;
  PVector dist0,dist1;
  float pct,speed;
  boolean go, active;
  PVector pts[] = null;
  float exponent = 0.82;//random(2,8);
  int deadtime = 60;
  
  float al,ald=1,als=random(0.0025,0.025);//0.0025;

  airborn(city a, city b){
    cini = a; cfim = b;
    ini = new PVector(a.pos.x,a.pos.y,a.pos.z);
    fim = new PVector(b.pos.x,b.pos.y,b.pos.z);
    init();
  }
  airborn(PVector v[]){
    ini = new PVector(v[0].x,v[0].y,v[0].z);
    fim = new PVector(v[1].x,v[1].y,v[1].z);
    init();
  }
  void init(){
    active = true;
    go = false;
//    ini = new PVector(random(wmin20.x,wmax20.x), random(wmin20.y,wmax20.y), -500);
//    fim = new PVector(random(wmin20.x,wmax20.x), random(wmin20.y,wmax20.y), -500);
    now = new PVector(ini.x,ini.y,ini.z);
    mid = interp(ini,fim,0.5);
    mid.z = 0.0f;//250.0f;//top height

    dist0 = new PVector();
    dist1 = new PVector();
    dist0.set(mid);
    dist0.sub(ini);
    dist1.set(mid);
    dist1.sub(fim);

    pct = 0.0f;
    speed = 0.005;//0.00051; 
    pts = new PVector[100];
    for(int i=0;i<pts.length;i++)
      pts[i] = new PVector(ini.x,ini.y,ini.z);
  }

  void fly(){

    if(!active){
    //  init();      
      return;
    }

    if(!go){
      if(frameCount%10==0)
        if(random(1)<0.1)
          go = true;
    }


    if(go){

      // fifo
      if(frameCount%4==0){
      for(int i=pts.length-2;i>=0;i--){
        pts[i+1].set(pts[i]);
      }
      pts[0].set(now);
      }


      pct += speed;

      if(pct > 1.0){
        float pctdesce = 1.0f - (pct - 1.0f);//pct - 1.0;//1.0f - (pct - 1.0f);
        if(pctdesce < 0.0f){
          if(deadtime--<0)
            active = false;
          pctdesce = 0.0f;
        }          

        now.x = fim.x + (pctdesce * dist1.x);
        now.y = fim.y + (pctdesce * dist1.y);
//        now.z = fim.z + (pow(pctdesce,exponent) * dist1.z);
        now.z = fim.z + (sin(pctdesce*HALF_PI) * dist1.z);//(pow(pctdesce,exponent) * dist1.z);

      } 
      else {                
        now.x = ini.x + (pct * dist0.x);
        now.y = ini.y + (pct * dist0.y);
//        now.z = ini.z + (pow(pct,exponent) * dist0.z);                
        now.z = ini.z + (sin(pct*HALF_PI) * dist0.z);//(pow(pct,exponent) * dist0.z);                
      }   


      //draw// line

      gl.glBegin(GL.GL_LINE_STRIP);  
      for(int i=0;i<pts.length;i++){
        gl.glColor4f(1,1,1,constrain(((pts.length-i)*0.01),0.,0.5));
        gl.glVertex3f(pts[i].x, pts[i].y, pts[i].z );  
      }
      gl.glEnd();

//      pushMatrix();
//      translate(now.x,now.y,now.z);
//      ellipse(0,0,50,50);
//      popMatrix();
      al+=als*ald;
      if(al<0.||al>0.79)
        ald=-ald;

      gl.glColor4f(1,1,1,al);
      circle(now.x,now.y,now.z,10);
      gl.glColor4f(1,1,1,0.05);
      circle(now.x,now.y,-500.0f,5);


    } 




  }


}




float circlepts0[] = new float[66];
FloatBuffer circlepts1 ;
boolean initcircle=false;
void init_circle(){
  int k=0;
  for(int i=0;i<22;i++){
    circlepts0[i*3+0] = cos(i/21.0f*TWO_PI);
    circlepts0[i*3+1] = sin(i/21.0f*TWO_PI);
    circlepts0[i*3+2] = 0.0f;
  }


    int numberElements = 22*3;
    circlepts1 = ByteBuffer.allocateDirect(4 * numberElements).order(ByteOrder.nativeOrder()).asFloatBuffer();
    circlepts1.limit(numberElements);
    circlepts1.rewind();
  
  
//  for(int i=0;i<66;i++)
//    circlepts1.put(i, circlepts0[i]);
    
  initcircle = true;
}


void circle(float x, float y, float z, float radius) {

    if(!initcircle)  init_circle();
  
	int k = 0;
	for(int i = 0; i < 22; i++){
		circlepts1.put(k,  x + circlepts0[k] * radius);
		circlepts1.put(k+1,  y + circlepts0[k+1] * radius);
		circlepts1.put(k+2, z + circlepts0[k+2] * radius);
		k+=3;
	}

	gl.glEnableClientState(GL.GL_VERTEX_ARRAY);
	gl.glVertexPointer(3, GL.GL_FLOAT, 0, circlepts1);
//        gl.glDrawArrays( GL.GL_LINE_LOOP, 0, 22);
        gl.glDrawArrays( GL.GL_TRIANGLE_FAN, 0, 22);
	//glDrawArrays( (drawMode == OF_FILLED) ? GL_TRIANGLE_FAN : GL_LINE_LOOP, 0, numCirclePts);

}









class atmosphere{

  ArrayList nuvens = new ArrayList();
  PVector vento = new PVector(random(-0.1,0.1),random(-0.1,0.1),0);

  atmosphere(){
    int num = (int) random(20,150);
    for(int i=0;i<num;i++){
     nuvem n = new nuvem(); 
     nuvens.add(n);
    }
  }

  void helios(){
    PVector rnd = new PVector(random(-0.01,0.01),random(-0.01,0.01),0);
    vento.add(rnd);

    for(int i=0; i<nuvens.size(); i++){
      nuvem n = (nuvem)nuvens.get(i); 
      n.d();
 

    }

  }

}


class nuvem{
  PVector pos = new PVector(); 
  float s = random(50,500);
  float speed = random(0.9,1.1);
  float op = random(1)<0.01? random(0,0.1):random(0.001,0.055);
  int num = (int)random(2,10);
  PVector spos[];
  float c[] = new float[3];
  
  nuvem(){
   pos.set(random(wmin20.x,wmax20.x),random(wmin20.y,wmax20.y),random(-100,300)); //random(100,500)); 
   spos = new PVector[num];
   for(int i=0;i<spos.length;i++){
    spos[i] = new PVector();
    spos[i].set(pos);
    spos[i].add(random(-100,100),random(-100,100),pos.z); 
   }
   if(random(1)<0.5){
   c[0] = 0.0f;
   c[1] = 0.0f;
   c[2] = random(0.5f);
   } else {
     c[0] = c[1] = c[2] = 1.0f;
   }
  }
  void d(){
    PVector vv = new PVector();
    vv.set(atmos.vento);
    vv.mult(speed);
    pos.add(vv);
    if(pos.x > wmax20.x) pos.x = wmin20.x;
    if(pos.y > wmax20.y) pos.y = wmin20.y;
    if(pos.x < wmin20.x) pos.x = wmax20.x;
    if(pos.y < wmin20.y) pos.y = wmin20.y;

    gl.glColor4f(c[0],c[1],c[2],op);
    //gl.glColor4f(1,1,1,op);
    circle(pos.x,pos.y,pos.z,s);
    for(int i=0;i<num;i++)
      circle(spos[i].x,spos[i].y,spos[i].z,s*0.33);
    
  }
}



class incendiario{
  ArrayList f = new ArrayList();
  incendiario(){};
  void arde(){
    for(int i=0;i<f.size();i++){
      fogo f0 = (fogo) f.get(i);
      f0.arde(); 
      if(f0.life<0){
        f.remove(i);
        i--; 
      }
    }     
  }
  void gas(city c){
    int v = (int)random(5,10);
    for(int i=0; i<v; i++){
    fogo f0 = new fogo(c);
    f.add(f0);
    }
  }

}


class fogo{
  PVector pos;
  float life = random(0.8,1.1), ld = random(0.0001,0.00051);
  float maxal = random(10,100);  
  float si = random(0.001,0.09);
  float s = random(2,10);
  float col[] = new float[4];

  fogo(city c){
    pos = new PVector(c.pos.x+random(-25,25),c.pos.y+random(-25,25),-495.0f);

    col[0] = random(0.7,1.);
    col[1] = col[0]*random(0.1,0.7) + random(-0.1,0.1);
    col[2] = 0.0f;
    col[3] = 0.0f;
  }

  void arde(){
    life-=ld;        
    col[3] = map(life,0,1,0,maxal) % 1.0f;

    float size = s + sin(frameCount*si);

    gl.glColor4f(col[0],col[1],col[2],col[3]);
    circle(pos.x,pos.y,pos.z,size); 


  }

}




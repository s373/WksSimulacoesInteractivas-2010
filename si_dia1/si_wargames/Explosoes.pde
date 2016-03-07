class Explosoes{
  ArrayList e = new ArrayList();

  Explosoes(){
  };
  void explode(){
    for(int i=0; i<e.size();i++){
      ExploPart ep = (ExploPart) e.get(i);
      ep.go();
      if(ep.life<0){
        e.remove(i);
        i--;
      }
    } 
  }

  void bang(PVector p, int num){
    for(int i=0;i<num;i++){
      ExploPart ep = new ExploPart (p);
      e.add(ep);
    }
      
      ExploPart ep = new ExploPart (p);
      ep.grow=true;
      ep.maxal=random(0.5,1.5);
      e.add(ep);
   
  }


}


class ExploPart{

  PVector pos,vel;
  float s = random(2,11);
  float life = random(0.8,1.1), ld = random(0.001,0.01);
  float maxal = random(1,10);
  boolean grow = false;

  ExploPart(PVector p){
    pos = new PVector(p.x,p.y,p.z); 
    float m = 5.05f;
    vel = new PVector(random(-m,m),random(-m,m),0);
  }

  void go(){
    pos.add(vel);
    vel.mult(0.921);
    life-=ld;        
    float al = map(life,0,1,0,maxal) % 0.7f;//1.0f;
    if(grow){
      s+=al;
      if(s>50)
        s=50;
    }

    gl.glColor4f(1,1,1,al);
    circle(pos.x,pos.y,pos.z,s); 
  }

}



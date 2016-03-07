class Galaxy{
  PVector pos,vel,acc;
  float rad,mass;
  boolean move=false;//true;
  float moveamt = 0.1;
  

  Galaxy(){
  };
  Galaxy(PVector pos, float _mass,float _rad){
    this.pos = pos;
    vel = new PVector();
    acc = new PVector();
    rad = _rad;
    mass = _mass;

  }


  void GalaxyInteraction(Galaxy g){

    if(move) {
//    float x = g.pos.x - pos.x;
//    float y = g.pos.y - pos.y;
//    float z = g.pos.z - pos.z;
   float x = pos.x - g.pos.x;
    float y = pos.x - g.pos.x;
    float z = pos.x - g.pos.x;
   float den = abs(x)+abs(y)+abs(z);//pow((x*x+y*y+z*z),0.5);  //sqrt(x*x+y*y+z*z);
 //   float den = sqrt(x*x+y*y+z*z);
    den = den*den;//*-1;
    float timesgmassden =  moveamt* ep * g.mass / den;
    
    acc.x += x * timesgmassden;//ep * g.mass / den;
    acc.y += y * timesgmassden;//ep * g.mass / den;
    acc.z += z * timesgmassden;//ep * g.mass / den;
    }

  }



  void update(){
   
  if(move){  
    vel.x += ts * acc.x;
    vel.y += ts * acc.y;
    vel.z += ts * acc.z;
    
//    vel.limit(moveamt);

    pos.x += ts * vel.x;
    pos.y += ts * vel.y;
    pos.z += ts * vel.z;
    
    acc.set(0,0,0);
  }
  }



  void draw(){
    fill(0,0,100,200);//blue galaxies
    pushMatrix();
    translate(pos.x,pos.y,pos.z);
    ellipse(0,0,rad*2,rad*2);
    popMatrix();
  }


}




class Star{
  PVector pos,vel,acc;

  Star(Galaxy g){
    float d = g.rad * 5;
       
    float px = g.pos.x + random(-d,d);
    float py = g.pos.y + random(-d,d);
    float pz = g.pos.z + random(-d,d);
    pos = new PVector(px,py,pz);
    vel = new PVector();
    acc = new PVector();
  }


  void StarInteraction(Galaxy g){

    //attract
    float x = g.pos.x - pos.x;
    float y = g.pos.y - pos.y;
    float z = g.pos.z - pos.z;
    //repel
//float x = pos.x - g.pos.x;
//    float y = pos.y - g.pos.y;
//    float z = pos.z - g.pos.z;
    float den = abs(x)+abs(y)+abs(z);//pow((x*x+y*y+z*z),0.5);  //sqrt(x*x+y*y+z*z);
  //  float den = sqrt(x*x+y*y+z*z);
     den = den*den;
    float timesgmassden =  ep * g.mass / den;

    acc.x += x * timesgmassden;//ep * g.mass / den;
    acc.y += y * timesgmassden;//ep * g.mass / den;
    acc.z += z * timesgmassden;//ep * g.mass / den;

     
  }


  void update(){
     vel.x += ts * acc.x;
    vel.y += ts * acc.y;
    vel.z += ts * acc.z;
    
//    vel.limit(2);

    pos.x += ts * vel.x;
    pos.y += ts * vel.y;
    pos.z += ts * vel.z;
    
    acc.set(0,0,0);
  
    
  }


  void draw(){
    fill(255);
    pushMatrix();
    translate(pos.x,pos.y,pos.z); 
    ellipse(0,0,25,25);
    //point
    popMatrix();
    
  }

}




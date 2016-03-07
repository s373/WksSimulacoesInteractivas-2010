class Physis {

  PVector       boundsMin, boundsMax;
  PVector       gravidade;
  ArrayList     <AgregadoBase> agregados;
  ArrayList     obstaculos;


  Physis() {
    init(10);
  }

  void addAgregado(float lx, float ly) {
    AgregadoBase a = new AgregadoBase();
    a.setPos(lx,ly);
    agregados.add(a);
  }

  void init(int numAgre) {
    boundsMin = new PVector();
    boundsMax = new PVector(width,height);
    gravidade = new PVector(0,1,0);
    agregados = new ArrayList<AgregadoBase>();
    for(int i=0; i<numAgre;i++) {
      AgregadoBase a = new AgregadoBase();
      agregados.add(a);
    }
  }


  void addForce() {
  }

  void update() {
    gravidade.x += random(-0.1,0.1);
    gravidade.y += random(-0.1,0.1);
    gravidade.limit(0.2);

    for(int i=0; i<agregados.size();i++) {
      AgregadoBase a =  agregados.get(i);      
      for(int j=i+1; j<agregados.size();j++) {
        a.colide(agregados.get(j));
      }
    }
    
    for(int i=0; i<agregados.size();i++) {
      agregados.get(i).update();
    }
  }

  void draw() {
    for(int i=0; i<agregados.size();i++) {
      agregados.get(i).draw();
    }
  }
}







/////////////////////// core

class AgregadoBase {

  ArrayList<Spring> springs;
  ArrayList<PartBase> parts;
  int forcePart;
  AABB aabb;
  float collisionSpring = 0.08;

  AgregadoBase() {
    init((int)random(2,20), (int)random(2,20));
  }

  void init(int ns, int np) {
    forcePart = (int) random(np);
    springs = new ArrayList();
    parts = new ArrayList(); 
    for(int i=0; i<np; i++) {
      PartBase part = new PartBase();
      parts.add(part);
    }
//    if(np>=2)
      for(int i=1; i<np; i++) {


        int a = (int) 0;
        int b = (int) i;//random(np);
        while(b==a) {
          b = (int) random(np);
        }
//        Spring spring = new Spring( a, b, 0.05, 0.9, random(20,80)         );
        Spring spring = new Spring( a, b, 0.05, 0.9, random(20,80)         );
        springs.add(spring);



        //        int a = (int) random(np);
        //        int b = (int) random(np);
        //        while(b==a) {
        //          b = (int) random(np);
        //        }
        //        Spring spring = new Spring( a, b, 0.05, 0.9, random(10,20)         );
        //        springs.add(spring);
      }

    aabb = new AABB();
    aabb.calc(parts);
  }


  void addForce(PVector f){
    
     parts.get(forcePart).addForce(f);
     
  }

  void colide( AgregadoBase other) {

    if( aabb.intersect(other.aabb) ){
       
          PVector delta = new PVector( other.aabb.center.x - aabb.center.x ,
                                      other.aabb.center.y - aabb.center.y, 0 );
                                      
          delta.mult(-collisionSpring);
          addForce(delta);
          delta.mult(-1.0f);          
          other.addForce(delta);
           
    }
    
    
  }
  
  void setPos(float x, float y){
      for(int i=0; i<parts.size();i++) {       
            parts.get(i).init(new PVector(x+random(-10,10),y+random(-10,10)));        
      } 
  }

  void update() {
    // add spring forces
    calcSpringForces(.125);
    addStandingForce(-2);
    // calc rest
    for(int i=0; i<parts.size();i++) {
      parts.get(i).update();
    }
    aabb.calc(parts);
  }

  void calcSpringForces(float amt) {
    for(int i=0; i<springs.size(); i++) {       
      Spring spring = springs.get(i);
      PartBase p1 = parts.get(spring.from); 
      PartBase p2 = parts.get(spring.to); 
      PVector delta = new PVector(p2.pos.x - p1.pos.x, p2.pos.y - p1.pos.y);

      float len = abs(delta.x) + abs(delta.y);
      ////sqrt(delta.x*delta.x+delta.y*delta.y);

      float centerOffset = 10;
      if( len > spring.restlen + centerOffset || len < spring.restlen - centerOffset) {
        delta.mult(amt*spring.spring);
        p1.addForce(delta);
        delta.mult(-1.0f);
        p2.addForce(delta);
      }

      //         float len = sqrt(delta.x*delta.x+delta.y*delta.y);
      //         if(len > spring.restlen){
      //           
      //         }
    }
  }

  void addStandingForce(float a){
   
     if( parts.get(forcePart).pos.y > physis.boundsMax.y*0.8 ){
      
        addForce(new PVector(0,a,0)); 
       
     }
    
  }


  void draw() {
    for(int i=0; i<parts.size();i++) {
      parts.get(i).draw();
    }
    for(int i=0; i<springs.size(); i++) {       
      Spring spring = springs.get(i);
      PartBase p1 = parts.get(spring.from); 
      PartBase p2 = parts.get(spring.to); 
      line(p1.pos.x, p1.pos.y, p2.pos.x, p2.pos.y);
    }
    ///aabb draw
    aabb.draw();
  }
}


class PartBase {
  PVector pos,vel,acc;
  float mass, drag=0.97f, rad=10, rad2=2*rad;

  PartBase() {
    init(new PVector(random(width),random(height)));
  }

  PartBase(PVector loc) {
    init(loc);
  }

  void init(PVector loc){
    float v = 5;
    init(loc, new PVector(random(-v,v),random(-v,v)));      
  }
  void init(PVector loc, PVector velocity) {
    pos = new PVector(loc.x, loc.y, loc.z);
    vel = new PVector(velocity.x, velocity.y);
    acc = new PVector();
  }

  void addForce(PVector force) {
    acc.add(force);
  }

  void update() {
    acc.add(physis.gravidade);
    vel.add(acc);
    vel.limit(5);
    //    vel.mult(drag);
    pos.add(vel);
    bounds();
    acc.set(0,0,0);
  }

  void bounds() {

    if(pos.x < physis.boundsMin.x) {
      pos.x = physis.boundsMin.x;
      vel.x = -vel.x;
    }
    if(pos.y < physis.boundsMin.y) {
      pos.y = physis.boundsMin.y;
      vel.y = -vel.y;
    }
    if(pos.z < physis.boundsMin.z) {
      pos.z = physis.boundsMin.z;
      vel.z = -vel.z;
    }

    if(pos.x > physis.boundsMax.x) {
      pos.x = physis.boundsMax.x;
      vel.x = -vel.x;
    }
    if(pos.y > physis.boundsMax.y) {
      pos.y = physis.boundsMax.y;
      vel.y = -vel.y;
    }
    if(pos.z > physis.boundsMax.z) {
      pos.z = physis.boundsMax.z;
      vel.z = -vel.z;
    }
  }

  void draw() {
    ellipse(pos.x, pos.y, rad, rad);
  }
}



class Spring {
  int from, to;
  float spring, damp, restlen;
  Spring() {
  }
  Spring( int _f, int _t, float _s, float _d, float _r) {
    from = _f;
    to = _t;
    spring = _s;
    damp = _d;
    restlen = _r;
  }
}


class AABB {

  PVector min,max,center; 

  AABB() { 
    min = new PVector(); 
    max = new PVector();
    center = new PVector();
  }
  AABB(PVector mn, PVector mx) {
    this(mn.x,mn.y,mx.x,mx.y);
  } 
  AABB(float mnx, float mny, float mxx, float mxy) {
    min = new PVector(mnx,mny);
    max = new PVector(mxx,mxy);
    center = new PVector();
  }
  void calc(ArrayList<PartBase> list) {
    min.set(1e7,1e7,1e7);
    max.set(-1e7,-1e7,-1e7);
    for(int i=0; i<list.size();i++) {
      PartBase p = list.get(i);
      if(p.pos.x < min.x) {
        min.x = p.pos.x;
      }
      if(p.pos.y < min.y) {
        min.y = p.pos.y;
      }
      if(p.pos.x > max.x) {
        max.x = p.pos.x;
      }
      if(p.pos.y > max.y) {
        max.y = p.pos.y;
      }
    }
    center.set( (min.x + max.x)*0.5f, (min.y + max.y)*0.5f, 0);
  }
  boolean intersect (AABB other) {
  		boolean intersects = false;
		
		if (	
			abs( (max.x+min.x) - (other.max.x+other.min.x)	) <  abs( (max.x-min.x) + (other.max.x-other.min.x)	) &&
			abs( (max.y+min.y) - (other.max.y+other.min.y)	) <  abs( (max.y-min.y) + (other.max.y-other.min.y)	) &&
			abs( (max.z+min.z) - (other.max.z+other.min.z)	) <  abs( (max.z-min.z) + (other.max.z-other.min.z)	) ) {
		
				intersects = true;
		}

		return intersects;
  
  
  }
  void draw() {
    rect(center.x, center.y, 2, 2);
    line(min.x, min.y, max.x, min.y); 
    line(max.x, min.y, max.x, max.y); 
    line(max.x, max.y, min.x, max.y); 
    line(min.x, max.y, min.x, min.y);
  }
}


import processing.opengl.*;
import s373.boids.*;


Flock2d flock2d;



void setup() {
  size(1024,600,OPENGL);

  reset();

  textFont(createFont("Arial",16));

  rectMode(CENTER);
  stroke(0,50);
}


void draw() {
  background(255);
  stroke(0);

  if(frameCount%60==0) {
    flock2d.changeAttractionPoint( 
    (int) random(10), random (width), random (height), -100, random(20,250)
      );
    flock2d.changeAttractionPoint( 
    (int) random(10), random (width), random (height), 20, random(20,250)
      );
  }

  if(frameCount>60) {
    flock2d.update(1);
  }

  for(int i=0; i<flock2d.size(); i++) {     
    Boid2d b = (Boid2d) flock2d.get(i);
    Invader invader = getInvader(i);
    noStroke();
    invader.draw(b.x, b.y);
    float lm = 10.f;
    stroke(0,10);
    line(b.x, b.y, b.x + b.vx*lm, b.y + b.vy*lm);
  }



  //view attrpoints
  color attrColor = color(0,10);
  color repelColor = color(0,3); 

  noStroke();
  for(int i=0; i<flock2d.attractionPoints.size(); i++) {   
    AttractionPoint2d ap = flock2d.attractionPoints.get(i);            
    /// rectdist, color force      
    fill( ap.force > 0 ? attrColor : repelColor);
    //      rect(ap.x, ap.y, ap.sensorDist/2, ap.sensorDist/2);
    ellipse(ap.x, ap.y, ap.sensorDist, ap.sensorDist);
    fill( ap.force > 0 ? attrColor : repelColor);
    ellipse(ap.x, ap.y, 5, 5);
  }


  fill(0,100);
  text(
  ""+frameRate+"\nsize: "+flock2d.size()+
    "\nalign: "+flock2d.getAlign()+
    "\ncohesion: "+flock2d.getCohesion()+
    "\nseparate: "+flock2d.getSeparate(), 
  10, height-100  );
}

void addBoids() {
  flock2d.add(mouseX,mouseY);
  addInvader();
}

void reset() {
  invaders.clear();
  int num = 55;
  flock2d = new Flock2d(num, width/2,height/2, 25);
  for(int i=0; i<num; i++) {
    addInvader();
  }
  flock2d.setBoundmode(0).setMaxSpeed(5);
  float b = 25;
  flock2d.setBounds(0,b,width-b,height-b);

  // make attrPts
  for(int i=0; i<10; i++) {   
    float x = random(width);
    float y = random(height);
    float force = -100;//random (-25,25);
    float dist = random(100,200); 
    flock2d.addAttractionPoint(x,y,force,dist);
  }
}
void keyPressed() {
  reset();
}

void mousePressed() {
  addBoids();
}
void mouseDragged() {
  addBoids();
}


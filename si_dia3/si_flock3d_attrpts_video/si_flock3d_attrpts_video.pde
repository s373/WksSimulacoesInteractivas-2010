// hello s373.boids.*;

import processing.opengl.*;
import s373.boids.*;
import processing.video.*;
import s373.flob.*;



Capture video;
Flob flob;

Flock3d flock3d;
PFont font;

boolean varyForces=false;
float ali=random(1e-10,1e-3) , coh=random(1e-10,1e-3), sep =random(1e-10,1e-3);



float camX, camY;

void setup() {  

  try { 
    quicktime.QTSession.open();
  } 
  catch (quicktime.QTException qte) { 
    qte.printStackTrace();
  }
  
  
  size(1024,600,OPENGL);
  
  
    // init video data and stream
  video = new Capture(this, 128, 128, 30);  
  flob = new Flob(128, 128, width, height);

  flob.setThresh(10).setSrcImage(0)
  .setBackground(video).setBlur(0).setOm(1).
  setFade(125).setMirror(true,false);
  

  // num, x, y, z,  dev
  flock3d = new Flock3d(210, width/2,height/2, -300, 25);

  flock3d.setBoundmode(1).setMaxSpeed(5);//.setForceAlign(-0.01);
  //  flock2d.setBoundmode(1).setForceAlign(0.01).
  //  setForceCohesion(10).setForceSeparate(1000).
  //  setMaxForce(1000).setMaxSpeed(20);


  flock3d.setAlign(-10).setCohesion(10).setSeparate(100);

  float b = 25;
  flock3d.setBounds(b,b, -700, width-b,height-b, 0);


  fill(200);
  stroke(255);

  font = createFont("Arial",10);
  textFont(font);
  rectMode(CORNER);
  
  
  camX = width/2;
  camY = height/2;
}


void draw() {

  
  
  if(video.available()) {
     video.read();
     flob.calc(flob.binarize(video));

     flock3d.attractionPoints.clear();
   //  float force = map(cos(frameCount*0.005),-1,1, -200,200);
     for(int i=0; i<flob.getNumBlobs(); i++) {
        ABlob ab = (ABlob) flob.getABlob(i); 
        float force = i%2==0 ? 700 : -700;///map(cos(frameCount*0.005),-1,1, -200,200);
        flock3d.addAttractionPoint(ab.cx,ab.cy, -200 ,force,ab.dimx*2);
     }
  }
  
  
  
  flock3d.setAlign(  cos(frameCount*0.0012f)*20.0f   );
  
  
  
  background(0);
//  hint(DISABLE_DEPTH_TEST);
//  tint(255,25);
//  image(flob.getSrcImage(), 0, 0, width, height);

  
  camX += ( mouseX - camX ) * 0.05;
  camY += ( mouseY - camY ) * 0.05;

  camera(camX,camY,700, width/2,height/2,0, 0, 1, 0);


  //view attrpoints
  color attrColor = color(100,255,0);
  color repelColor = color(255,128,0); 
  
  for(int i=0; i<flock3d.attractionPoints.size(); i++){   
      AttractionPoint3d ap = flock3d.attractionPoints.get(i);            
      /// rectdist, color force      
      fill( ap.force > 0 ? attrColor : repelColor, 100);

      pushMatrix();
      translate( ap.x, ap.y, ap.z);
      rect ( -ap.sensorDist/2, -ap.sensorDist/2, ap.sensorDist , ap.sensorDist );
      rotateX (radians(90));
      rect ( -ap.sensorDist/2, -ap.sensorDist/2, ap.sensorDist , ap.sensorDist );
      popMatrix();
      
//      rect(ap.x, ap.y, ap.sensorDist, ap.sensorDist);
//      fill( ap.force > 0 ? attrColor : repelColor, 200);
//      rect(ap.x, ap.y, 5, 5);    
  }

    flock3d.update(1);


  for(int i=0; i<flock3d.size(); i++) {     
    Boid3d b = flock3d.get(i);

    pushMatrix();
    translate(b.x, b.y, b.z);
    rect(-5,-5,10,10);
    rotateX(radians(90));
    rect(-5,-5,10,10);
    popMatrix();
    
//    rect(b.x, b.y, 5,5);
    float lm = 10.f;
    line(b.x, b.y, b.z, b.x + b.vx*lm, b.y + b.vy*lm, b.z + b.vz*lm);
  }

camera();
  text(
  ""+frameRate+"\nsize: "+flock3d.size()+
    "\nalign: "+flock3d.getAlign()+
    "\ncohesion: "+flock3d.getCohesion()+
    "\nseparate: "+flock3d.getSeparate(), 
  10, height-70  );
}

void addBoids() {
  flock3d.add(mouseX,mouseY, -300);
}

void mousePressed() {
  addBoids();
}
void mouseDragged() {
  addBoids();
}

void keyPressed(){
   if(key=='f')
    varyForces^=true; 
}


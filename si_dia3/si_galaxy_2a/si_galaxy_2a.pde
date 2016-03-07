/*
    
*/

///http://mirtchovski.com/code/galaxy_collision.html


import processing.opengl.*;
Star stars[];
Galaxy galaxy[];
float time = 0.0f;

int numgalaxies=10;
int numstars=200;///1000;
///world coords
//float wc[] ={ -1000.0f, -500.0f, -2000.0f,
//              1000.0f, 500.0f , 0.0f} ;
float wcoords[] ={ -1000.0f, -500.0f, -1000.0f,
              1000.0f, 500.0f , 1000.0f} ;

float wcenter[] = {(wcoords[0] + wcoords[3])*0.5 , (wcoords[1] + wcoords[4])*0.5 ,(wcoords[2] + wcoords[5])*0.5  };
//
float ts = 0.0; // this is the time step we are currently on
float dt = 0.0201;//0.000201;
float ep = 0.0001;//0.5;//10.0f;//0.0002;///Gravitational constant

PFont font;

void setup(){
  size(1000,600,OPENGL);

  galaxy = new Galaxy[numgalaxies];
  for(int i = 0; i < galaxy.length;i++){
    float x =random(wcoords[0],wcoords[3]);//random(width);// random(-1000,1000);///random(width);
    float y =random(wcoords[1],wcoords[4]);// random(-1000,1000);//random(height);
    float z = random(wcoords[2],wcoords[5]);
    float mass = random(10,100);//1.;//random(1,20);
    float rad = map(mass,1,100,20,100);    
 //   int num = (int)random(5,20);//(int)random(25,200);//(int)random(250,200) 
    galaxy[i] = new Galaxy( new PVector(x,y,z),mass,rad);
  }


   stars = new Star[numstars];
    for(int i=0;i<numstars;i++)
      stars[i] = new Star(galaxy[(int)random(galaxy.length)]); //pass this galaaxy pointer


  font = createFont("arial",16);
  textFont(font);
}


void draw(){

  background(0);
  
 // camera(0,0,-200, 0,0,200, 0, 1, 0);
 
// camera(width/2,height/2, 2400  , width/2,height/2, 0, 0, 1, 0);
 camera(wcenter[0],wcenter[1],wcoords[5], wcenter[0],wcenter[1],wcoords[2], 0,1,0 );
 
 rotateY(map(mouseX,0,width,0,2*TWO_PI));

  // galaxy interaction
  // Galactic center interaction
  for(int i = 0; i < galaxy.length; i++) {
    for(int j = i+1; j < galaxy.length; j++) {

      if(i!=j){
        galaxy[i].GalaxyInteraction( galaxy[j]  );            
      }

    }  
  }


 for(int i = 0; i < galaxy.length; i++) {    
   galaxy[i].update();
   galaxy[i].draw();
 }



 // new Star interaction with galactic centers
    for(int i = 0; i < stars.length; i++) {
      for(int j = 0; j < galaxy.length; j++) {
         stars[i].StarInteraction(  galaxy[j] );
      }
      stars[i].update();
      stars[i].draw();
    }


  ts += dt; //advance time
  
  camera();
  text("time: "+ts,5,height-20);


}



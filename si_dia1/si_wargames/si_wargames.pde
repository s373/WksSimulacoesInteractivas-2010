/// andré sier /// simulações interactivas 2010
/// wargames

import javax.media.opengl.*;
import javax.media.opengl.glu.*;
import processing.opengl.*;
import com.sun.opengl.util.*;
import com.sun.opengl.util.texture.*;
import java.nio.*;

PGraphicsOpenGL pgl;
GL gl;
GLU glu;
GLUT glut;

GLUquadric gquadric;
Texture tex[];

Explosoes explosoes;
incendiario incendios;

int camom = 1;//0;//1; // 0 - rato
float cx,cy,cz=2000f;//220;//=500;
float dstx,dsty;
int wair = 0;

//cam bounds at dif zooms
PVector wmin20 = new PVector( 750.0f , 670.0f ,-20.0f   );
PVector wmax20 = new PVector( 7000.0f, 3000.0f ,-20.0f   );
PVector wmin1000 = new PVector( 1500.0f, 1000.0f ,1280.0f   );
PVector wmax1000 = new PVector( 5820.0f, 2600.0f ,1280.0f   );

worldcities wx;
city c;
PVector citypos= new PVector(2500,1000,-500);

ArrayList air = new ArrayList();

atmosphere atmos = new atmosphere();

void setup(){
  size(1024,600,OPENGL);
//  size(screen.width,screen.height,OPENGL);
  perspective( radians(50.0f), float(width)/float(height), 0.01, 10000.0f   );
  pgl = (PGraphicsOpenGL)g;
  glu = pgl.glu;
  glut = new GLUT();
  

  tex = new Texture[1];

  try { 
    tex[0]=TextureIO.newTexture(new File(dataPath("eee2048a.png")),true);
  }  
  catch(Exception e) { 
    println(e); 
  }  


  String dta[] = new String[3];
  dta[0] = "lisboa";
  dta[1] = "pt";
  dta[2] = "eu";
  citypos = new PVector(2500,1000,-495);
  c = new city(citypos,dta);
  
  wx = new worldcities();
  
  explosoes = new Explosoes();
  
  incendios = new incendiario();

}



void draw(){

  gl = pgl.beginGL();
  gl.setSwapInterval(1);
  gl.glClearColor(0.1f,0.1f,0.1f,0.1f);
  gl.glClear( GL.GL_COLOR_BUFFER_BIT | GL.GL_DEPTH_BUFFER_BIT);
  
  gl.glDepthMask(false);
  
  
 
  

  float dx=0,dy=0;
  if(camom==0) {
    //cam mouse
    dx = mouseX-width/2;
    dy = mouseY-height/2;
    float d = abs(dx)+abs(dy);
    if(d>250){
      float f = 0.01;
      cx = (1.0f-f)*cx + f*(cx+dx);
      cy = (1.0f-f)*cy + f*(cy+dy);
    }

    float Zf = 1.5f;
    if(mousePressed){
      if(mouseButton==LEFT)
        cz+=Zf;//0.1;
      else
        cz-=Zf;//0.1; 
    }
  }

  if(camom==1){
    
    if(wair < air.size()){
     
      airborn ab = (airborn) air.get(wair);
      dstx = ab.now.x;
      dsty = ab.now.y;
        
      
    }

      float f = 0.01;
      cx = (1.0f-f)*cx + f*(dstx);
      cy = (1.0f-f)*cy + f*(dsty);
   
   float Zf = 1.5f;
    if(mousePressed){
      if(mouseButton==LEFT)
        cz+=Zf;//0.1;
      else
        cz-=Zf;//0.1; 
    }

  }

  // cam bounds
  float zpct = map(cz,wmin20.z,wmax1000.z,0.,1.);
  boolean side = zpct > 0.5 ? true : false;
  PVector bmin = interp(wmin20,wmin1000,zpct);
  PVector bmax = interp(wmax20,wmax1000,zpct);

  if(cx <= bmin.x)   cx = bmin.x; 
  if(cy <= bmin.y)   cy = bmin.y; 
  if(cz <= bmin.z)   cz = bmin.z; 
  if(cx >= bmax.x)   cx = bmax.x; 
  if(cy >= bmax.y)   cy = bmax.y; 
  if(cz >= bmax.z)   cz = bmax.z; 


  camera(cx,cy,cz,cx-dx*0.25,cy+dy*0.25,-500,0,1,0);


  c.pos.set(cx,cy,-495);

  gl.glDisable( GL.GL_DEPTH_TEST ) ;
  gl.glEnable( GL.GL_BLEND ) ;
  gl.glBlendFunc(GL.GL_SRC_ALPHA,GL.GL_ONE); 


  tex[0].bind();   
  tex[0].enable();   



  ////

  int divx = 4;
  int divy = 1;
  float dimx = 7500;
  float dimy = 3750;//2812;
  float zpos = -500;

  gl.glColor4f( 1.0f, 1.0f, 1.0f,0.71f);  
  gl.glBegin(GL.GL_QUAD_STRIP);  
  gl.glNormal3f( 0.0f, 0.0f, 1.0f); 

  for(int j=0; j<divy; j++){
    for(int i=0; i<divx; i++){
      float xx = ((float) i / (float) (divx-1) );//* 2.0) ;//% 1.0f;
      float y0 = (float) j / (float) (divy);
      float y1 = (float) (j+1) / (float) (divy);


      float tu = xx > 1.0f ? xx-1.0 : xx;

      gl.glNormal3f( 0.0f, 0.0f, 1.0f); 

      gl.glTexCoord2f(tu, y0);    
      gl.glVertex3f(xx*dimx, y0*dimy, zpos );  
      gl.glNormal3f( 0.0f, 0.0f, 1.0f); 
      gl.glTexCoord2f(tu, y1);    
      gl.glVertex3f(xx*dimx, y1*dimy, zpos);  

    }
  }  

  gl.glEnd();   


  tex[0].disable(); 


  for(int i=0; i<air.size();i++){
   airborn a = (airborn) air.get(i);
   a.fly(); 
   if(!a.active){
 
     int num = (int) random(10,100);
     explosoes.bang(a.fim, num);
     dstx = 0.3*dstx + a.fim.x*0.7;
     dsty = 0.3*dsty + a.fim.y*0.7;

     incendios.gas(a.cfim);     
     a.cfim.hitcount++;
     air.remove(i);
     i--;
     wx.citynum = wx.citytarget; 
      
      if(wair==i) ///dri: z<<
        wair = (int) random(air.size());
        

   }
     
    
  }
  

  wx.draw();
  
  explosoes.explode();
  incendios.arde();
  
  float tal = 0.01f + (cos(frameCount*0.027)*0.25 + 0.25);
  float tal1 = tal + random(-0.02, 0.02);

  int txtx =-50;//-90;//-400;
  int txty = 221;//210;// +250;//-100; 
  gl.glColor4f(1f,1f,1f,tal);//0.01f);
  gl.glRasterPos3i(int(5+cx+txtx),int(10+cy+txty), int(cz-500));

  glut.glutBitmapString(glut.BITMAP_HELVETICA_12, "W A R G A M E S");
  gl.glRasterPos3i(int(6+cx+txtx),int(11+cy+txty), int(cz-500));
  gl.glColor4f(0f,0f,1.0f,tal1);//0.1f);
  glut.glutBitmapString(glut.BITMAP_HELVETICA_12, "W A R G A M E S ");

  atmos.helios();

  pgl.endGL();
  gl.glFlush();
}



void keyPressed(){
    
  if(key=='a'){
    wx.add(c);
  }
 if(key=='A'){
    wx.write();
  }
      
    
}



PVector interp(PVector a, PVector b, float f){
  float f1 = 1.0f - f;
  PVector r = new PVector();
  r.x = a.x*f1 + b.x*f;
  r.y = a.y*f1 + b.y*f; 
  r.z = a.z*f1 + b.z*f;   
  return r;
}










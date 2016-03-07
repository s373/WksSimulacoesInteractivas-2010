class worldcities{

  ArrayList cities = new ArrayList();
  int citynum=-1;
  int citytarget=-1;

  worldcities(){
    read();
  }

  void add(city c){
    city ct = new city(c);
    cities.add(ct); 
  }

  void read(){
    String data[] = loadStrings("cities.txt");
    for(int i=1;i<data.length;i++){
      String info[] = split(data[i]," ");
      PVector pos = new PVector(float(info[4]),float(info[5]),-495); 
      String dta[] = new String[3];
      dta[0] = info[1];
      dta[1] = info[2];
      dta[2] = info[3];
      city c = new city(pos,dta);
      add(c);
    }
  }

  void write(){

    String data[] = new String[0];
    data = append(data,"worldcities>pieceattack");
    for(int i=0;i<cities.size();i++){
      city c = (city)cities.get(i);
      data = append(data, ""+i+" "+c.name+" "+c.country+" "+c.federation+" "+c.pos.x+" "+c.pos.y); 
    }

    saveStrings("cities-"+minute()+"-"+second()+".txt",data);
  }


  void draw(){
    
    if(random(1)<0.01){
      spawn();
    }

    for(int i=0;i<cities.size();i++){
      city c = (city) cities.get(i);
      c.update();
      c.draw();

//      gl.glColor4f(0f,0f,1f,0.91f);
//      circle(c.pos.x,c.pos.y,c.pos.z, 5);      
//      gl.glColor4f(1f,1f,1f,0.1f);
//      gl.glRasterPos3i(int(c.pos.x),int(c.pos.y+10), int(c.pos.z));
//      glut.glutBitmapString(glut.BITMAP_9_BY_15, c.name+","+c.country);

    } 

//    if(cities.size()>0){
//      int citynum = (frameCount/480)%cities.size();
      drawblink(citynum);
//    }

  }


  void drawblink(int i){
    if(i==-1)
      return;
    i = (int)constrain(i,0,cities.size()-1);
    city c = (city) cities.get(i);
    if(frameCount%10==0)
      gl.glColor4f(0f,0f,1f,0.91f);
    else
      gl.glColor4f(1f,0.5f,0f,0.91f);

    circle(c.pos.x,c.pos.y,c.pos.z, 10+sin(frameCount*0.07)*10.0);      //50+sin(frameCount*0.11)*25.0);      
    gl.glColor4f(1f,1f,1f,0.1f);
    gl.glRasterPos3i(int(c.pos.x),int(c.pos.y+10), int(c.pos.z));
    glut.glutBitmapString(glut.BITMAP_9_BY_15, c.name+" "+i);

  }


  void spawn(){
   
     int c0 = (int) random(cities.size()); 
     int c1 = (int) random(cities.size()); 
     while(c1==c0){
         c1 = (int) random(cities.size()); 
     }
     
     citynum = c0;
     citytarget = c1;
     PVector v[] = new PVector[2];
     city ca,cb;
     ca = (city)cities.get(c0);
     cb = (city)cities.get(c1);
//     v[0] = new PVector(  ca.pos.x,ca.pos.y,ca.pos.z    );
//     v[1] = new PVector(  cb.pos.x,cb.pos.y,cb.pos.z    );
     airborn ab = new airborn(ca,cb);//new airborn(v);
     air.add(ab);
    
  }
  
  void explode(){
     int num = (int) random(10,100);
     city ca;
     ca = (city)cities.get(citynum);
     explosoes.bang(ca.pos, num);
      
  }

}



class city{

  PVector pos;
  String name = "lisboa";
  String country = "pt";
  String federation = "eu";
  
  // 
  float life = 1.0f;
  float explo = 0.0f;
  int hitcount = 0;
  int missilecount = 5;
   

  city(city c){
    pos = new PVector(c.pos.x,c.pos.y,c.pos.z);
    name = c.name;
    country = c.country;
    federation = c.federation;
  }
  city(PVector _p, String data[]){
    pos = new PVector(_p.x,_p.y,_p.z);
    name = data[0];
    country = data[1];
    federation = data[2];    
  }


  void update(){
      
    
  }

  void draw(){

    gl.glColor4f(0f,0f,1f,0.21f);
    circle(pos.x,pos.y,pos.z, 5);//25);      
    gl.glColor4f(1f,1f,1f,0.1f);
    gl.glRasterPos3i(int(pos.x),int(pos.y+10), int(pos.z));
    glut.glutBitmapString(glut.BITMAP_HELVETICA_10, name+" "+hitcount);
        
    

  }

}








/// simulaç~es interactivas, 2010
/// andre sier



//Mola mola;
Physis physis;

void setup(){
 
 size(500,500); 
 
 physis = new Physis();
 stroke(255);
}


void draw(){
  background(0);
  physis.update();
  physis.draw();
}

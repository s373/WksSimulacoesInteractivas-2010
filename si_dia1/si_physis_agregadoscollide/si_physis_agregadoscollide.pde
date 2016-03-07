/// simulaç~es interactivas, 2010
/// andre sier



Physis physis;

void setup(){
 
 size(1024,600); 
 
 physis = new Physis();
 stroke(255);
}


void draw(){
  background(0);
  physis.update();
  physis.draw();
}


void mousePressed(){
   physis.addAgregado(mouseX, mouseY); 
}



BinaryMachine state;
FloatMachine  floatstate;

void setup(){
  size(200,200);
  state = new BinaryMachine();  
//  state.setBit(2,1);
//  state.setBit(1,1);
//  state.setBit(0,1);
  floatstate = new FloatMachine(3);
  
}


void draw(){
  
  background(0);

  
  
  
  if(state.getBit(0)){
    fill(0,0,200);
    rect(random(width/2),random(height), random(2,12), random(2,12));
  }
  
  if(state.getBit(1)){
    fill(0,200,0);
    rect(random(width/2,width),random(height), random(2,12), random(2,12));
  }
  
  if(state.getBit(2)){
    fill(200,200,0);
    rect(random(width/2),random(height), random(2,12), random(2,12));
  }




  
 
  if(floatstate.getValOn(0)){
    fill(0,0,200, floatstate.getVal(0)*255.0f);
    rect(random(width/2),random(height), random(2,12), random(2,12));
  }
  
  if(floatstate.getValOn(1)){
    fill(0,200,0, floatstate.getVal(1)*255.0f);
    rect(random(width/2,width),random(height), random(2,12), random(2,12));
  }
  
  if(floatstate.getValOn(2)){
    fill(200,200,0, floatstate.getVal(2)*255.0f);
    rect(random(width/2),random(height), random(2,12), random(2,12));
  }

  //always update
  floatstate.update();
    floatstate.ease = map(mouseX, 0, width, 0., 0.1);

  
  String fd = ""+floatstate.getVal(0)+" "+floatstate.getVal(1)+" "+floatstate.getVal(2)+
  "\n"+floatstate.targetStates[0]+" "+floatstate.targetStates[1]+" "+floatstate.targetStates[2];
  text(fd,2,height-20);
}


void keyPressed(){
   
 if(key=='a'){
    state.toggleBit(0);
 } 
 if(key=='s'){
    state.toggleBit(1);
 } 
 if(key=='d'){
    state.toggleBit(2);
 } 
  

 if(key=='z'){
    floatstate.toggleVal(0);
 } 
 if(key=='x'){
    floatstate.toggleVal(1);
 } 
 if(key=='c'){
    floatstate.toggleVal(2);
 } 


}

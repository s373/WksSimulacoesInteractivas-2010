class FloatMachine{
  
//   int state = 0; //32 states
   int numstates = 32;
   float states[] = new float[numstates];
   float targetStates[] = new float[numstates];
   float ease=0.05f;
   
   boolean changed = true;
   boolean reached = false;
  
   FloatMachine(){     
   }
   FloatMachine(int ns){     
     init(ns);
   }
   
   void init(int ns){
     numstates = ns;
     states = new float[numstates];
     targetStates = new float[numstates];
   }
   
   void update(){
     if(!reached || changed){

       if(!changed && getDiff() < 0.001){
          reached = true; 
       }       

       if(changed){
          reached = false;
          changed = false; 
       }       
       
       easeStates();       

     }
       
   }
   
   void easeStates(){
     for(int i=0;i<numstates;i++){
        states[i]+=(targetStates[i]-states[i])*ease;
      }      
   }
   
   float getDiff(){
      float d = 0;
      for(int i=0;i<numstates;i++){
        d += abs((targetStates[i]-states[i]));
      } 
      return d;
   }
   
   void setVal(int numbit, float on){      
       targetStates[numbit] = on;  
       changed = true;
   }   
   
   void toggleVal(int numbit){     
       targetStates[numbit] = (1.0f-targetStates[numbit]);
              changed = true;
   }
   
   float getVal(int numbit){
     return states[numbit];
   }
   boolean getValOn(int numbit){
     return states[numbit]>0.001;
   }
  
  
}

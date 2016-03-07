class BinaryMachine{
  
   int state = 0; //32 states
//   int maxStates = 0;
//   int currState;   
  
   BinaryMachine(){     
   }
   
   void setBit(int numbit, int on){
     if(on>0){
        //turn on numbit
        state |= (1<<numbit); 
     } else {
        //turn off numbit
        state &= ~(1<<numbit);        
     }
   }
   
   
   void toggleBit(int numbit){     
     if(getBit(numbit)){
        setBit(numbit,0); 
     } else{
        setBit(numbit,1);        
     }
   }
   
   boolean getBit(int numbit){
     return (state & (1<<numbit)) > 0;
   }
  
}

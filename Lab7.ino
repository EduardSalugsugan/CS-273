// CS 273
// Lab7.ino
// Eduard Salugsugan
// 3/11/2019

extern "C" { 
  void initAD();
  byte readAD(byte);
}

void setup() {    

  Serial.begin(9600);    
  initAD(); // call assembly init A/D routine 
}  

void loop() {    
//
//  byte v;
//  v = readAD(2); // call assembly read sensor routine, A/D pin #2         
//  Serial.print("light = ");    
//  Serial.println(v,HEX);    
//  delay(1000); // delay one second 

  byte left;
  left = readAD(0); // call assembly read sensor routine, A/D pin #2        
  Serial.print("left light = ");    
  Serial.println(left,HEX);    
  delay(1000);

  byte right;
  right = readAD(1); 
  Serial.print("right light = ");
  Serial.println(right,HEX);
  delay(1000);

} 

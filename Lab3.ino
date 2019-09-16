//
// Declare the things that exist in our assembly code
//

extern byte gender;
extern byte age;
extern byte fat;

extern "C" {   
  void lightup();
}

//
// function to read a 2-digit HEX value from user
//
byte read2DigitHexValue()
{
  byte inch; int val=0;
  Serial.println("Enter a 2-digit hex value:");
  while (!Serial.available()) delay(100);
  inch = Serial.read();
  if (inch <= '9')
     val = (inch - '0') * 16;
  else if (inch > '9' && inch >= 'a') 
     val = (inch - 'a' + 10) * 16;
  else if (inch > '9' && inch >= 'A') 
     val = (inch - 'A' + 10) * 16;
  while (!Serial.available()) delay(100);
  inch = Serial.read();
  if (inch <= '9')
     val += (inch - '0');
  else if (inch > '9' && inch >= 'a') 
     val += (inch - 'a' + 10);
  else if (inch > '9' && inch >= 'A') 
     val += (inch - 'A' + 10);
  Serial.print("The value entered is decimal ");
  Serial.println(val,DEC);
  return (byte) val;
}
//
// Arduino-required setup function (called once)
//
void setup()
{
  //
  // Initialize serial communications
  //
  Serial.begin(9600);
  //
  // Read 2 values from user, store in global vars
  //
  gender = read2DigitHexValue();
  age = read2DigitHexValue();
  fat = read2DigitHexValue();
  //
  // Call our assembly code
  //
  lightup();
}

//
// Arduino-required loop function (called infinitely)
//
void loop()
{
  delay(20000); // 20,000 millisecs == 20 seconds
  Serial.println("*");
}


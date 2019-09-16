// CS 273 m02
// Program Name: Lab2
// Author: Eduard Salugsugan
// Date: 1/24/2019
// Purpose: reads the value from the user and sends it to addition() Function

// 
// Declare the things that exist in our assembly code
//

extern byte x1, x2, x3;
extern "C" void addition(void);

//
// function to read a 2-digit decimal value from user
//
byte read2DigitValue()
{
  byte inch; int val;
  Serial.println("Enter a 2-digit decimal value:");
  while (!Serial.available()) delay(100);
  inch = Serial.read();
  val = (inch - '0') * 10;
  while (!Serial.available()) delay(100);
  inch = Serial.read();
  val += (inch - '0');
  Serial.print("The value entered is ");
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
  // Read three values from user, store in global vars
  //
  x1 = read2DigitValue();
  x2 = read2DigitValue();
  x3 = read2DigitValue();
  //
  // Turns off the arduino when 3 numbers are inputted by the user
  //
  pinMode(13, OUTPUT);
  digitalWrite(13, LOW);
  //
  // Call our assembly code
  //
  addition();
  //
  // Print out value of x3 variable
  //
  Serial.println("After addition()");
  Serial.print("The value is ");
  Serial.println((int) x3,DEC);
}

//
// Arduino-required loop function (called infinitely)
// - this just prints a '*' on the serial comm output
//   once every 20 seconds, forever
//
void loop()
{
  delay(20000); // 20,000 millisecs == 20 seconds
  Serial.println("*");
}


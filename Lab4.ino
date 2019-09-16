// Eduard Salugsugan
// 02/21/19
// CS 273
// Lab 4
// Purpose: to ask user for values for goaggies and morsecodes

extern byte val;
extern byte width;
extern char ascii;

extern "C" {
  void goaggies();
  void decode_morse();
}

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
  Serial.println(val, DEC);
  return (byte) val;
}

// uses the read2DigitValue to get the value and calls the function goaggies to make the avr blink
void flashGoAggies()
{ 
  
  val = read2DigitValue();
  goaggies();
  
}

// decodes the message to morsecode delivers the ascii and stores it in message
void decodeMorse1(const String & string, char message[])
{ 
 
  val = 0;
  width = 0;
  int c = 0;
    for (int i = 0; i < string.length(); i++){
      if (string[i] == '1') {
        width++; 
        val = val * 2 + 1;
      }// end of if
      if (string[i] == '0') {
        width++; 
        val = val * 2 + 0;
      }// end of if
      if (string[i] == ' ') {
        decode_morse();
        message[c] = ascii;
        c++;
        val = 0;
        width = 0;
      }// end of if
    }// end of for

    if (val > 0 || width > 0) {
      decode_morse();
      message[c] = ascii;
      c++;
    }//end of if

   message[c] = 0;
}


// asks the users for the undecoded code to store in string
void decodeMorse()
{ 
  
  Serial.println("Input a Morse code string (separate the code for characters by a space):");

  while (!Serial.available()) delay(100);
  
  String string = Serial.readString();

  Serial.print("The Morse code string is: ");
  Serial.println(string);

  char message[100];

  decodeMorse1(string, message);

  if (strlen(message) > 0) {
    Serial.print("The decoded message is: ");
    Serial.println(message);
  } else {
    Serial.print("Failure in decoding the input Morse code\n");
  }
}

// gets everything and calls it in the void setup function
void setup() {
  //
  // Initialize serial communications
  //
  Serial.begin(9600);

  flashGoAggies();

  decodeMorse();


}

void loop() {
  // put your main code here, to run repeatedly:
  delay(20000); // 20,000 millisecs == 20 seconds
  Serial.println("*");
}

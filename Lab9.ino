// 1)  Take 5 different distance measurements noting the exact distance.  Report these values.
//  microseconds  |   inches
//      420       |      3
//      690       |      5
//      880       |      6
//     1300       |     8.5  
//     1660       |    11.5 
// 2)  Calculate how many microseconds one foot is.  Show your work
//     One foot equals 1750 microseconds
// 3)  What is the minimum and maximum effective measuring distance of the device?  Provide a link along with your answer
//     Range detection is from 1" to 13 feet Reference: https://www.tutorialspoint.com/arduino/arduino_ultrasonic_sensor.htm
// 4)  Is it possible for our ISR to be interrupted with another PINB, pin 1 state change? 
//     No because of the interrupt vectors
#include <avr/interrupt.h>
long start_time;
long totduration;
extern byte pinbstate;

extern "C" {
  void ultrasensor();
  void readPINBState();
}

void setup()
{
  Serial.begin(9600);
  
  /*
   * Set the bits of the appropriate PCMSKx register high
   * to enable pin change detection on PB1 (port b pin 1). 
   * PCINT1 in our case.
   */
  PCMSK0 = (1<<PCINT1);

  // Enable the corresponding vector, PCIE0 in our case.
  PCICR = (1<<PCIE0);

  // Enable the interrupt flag
  sei();
  
}

void loop()
{
  ultrasensor();
  delay(1000); // delay a second
}

/*
 * The interrupt service routine that would activate on 
 * a value change of PB1
 */
ISR(PCINT0_vect)
{
  /* The echo pin is changed twice
   * 1. First echo pin is set, this is when the echo is sent,
   * record start time in microseconds
   * 2. Then echo pin is cleared, this is when the echo came
   * back, record the end time now.
   */

   // Read the pin b state to know if its 0 or 1
   readPINBState();
  
   if(pinbstate == 1)
    start_time = micros();

   if(pinbstate == 0)
   {
    totduration = micros() - start_time;
      if (totduration > 4000){
        Serial.println("safe Distance");
      } else {
        Serial.println("Too close");
      }
     // figure out total time,
     // determine a safe distance (like 5 inches)
     // print out "Safe Distance"  or "Too close" based on your science
   }
}


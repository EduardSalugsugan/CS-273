// CS 273
// Lab7.s
// Eduard Salugsugan
// 3/21/2019
// 1)  What was the lowest value you saw from the photoresistor?
// 2A
// 2)  What was the highest value you saw from the photoresistor?
// E7
// 3)  Our A/D conversion mechanism has the ability to create 1024 distinct values, why did your output not have 1024 values?
// Because its 1 byte

  .text
  .global initAD
  .global readAD
  

  initAD:
      LDI r16, 0b00111111
      STS 0x007E,r16

      LDI r17, 0b10000111
      STS 0x007A,r17

  readAD:
      LDI r18, 0b01100000
      OR r18, r24
      STS 0x007C,r18
      

      LDI r19, 0b11000111
      STS 0x007A,r19

  loop:
      LDS r20, 0x007A
      SBRC r20, 6
      jmp loop
      CLR r25
      LDS r24, 0x0079
      ret
  

    
 
  
  

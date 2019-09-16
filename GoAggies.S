// Eduard Salugsugan
// 02/21/19
// CS 273
// Lab 4
// Purpose: Makes the avr blink in morse for how big the val is

#
# Global data 
# 
   
.macro pushall
  push r16
  push r17
  push r18
  push r19
  push r20
  push r21
  push r22
  push r23
  push r24
  push r25
  push r26
  push r27
  push r28
  push r29
  push r30
  push r31
.endm ; of pushall

.macro popall 
  pop r31
  pop r30
  pop r29
  pop r28
  pop r27
  pop r26
  pop r25
  pop r24
  pop r23
  pop r22
  pop r21
  pop r20
  pop r19
  pop r18
  pop r17
  pop r16
.endm ; of popall

  .extern delay 
  .data
  .comm val, 1
  .global val
  .text
  .global goaggies

// gets the value of val and stores it in register r18
goaggies: lds r18, val

// blinks goaggies in morse code
goaggies1:
          ldi r16, 0x20 ;; turn on light
          out 0x04, r16
                 
          call G
          call O
          call A
          call G
          call G
          call I
          call E
          call S
          dec r18
          cpi r18,0
          BRNE goaggies1

          ret
          
G:  call LONG ;; Generates the G
    call LONG
    call SHORT
    ret       
    
O:  call LONG ;; Generates the O
    call LONG
    call LONG
    ret       

A:  call SHORT ;; Generates the A
    call LONG
    ret

I:  call SHORT ;; Generates the I
    call SHORT
    ret

E:  call SHORT ;; Generates the E
    ret

S:  call SHORT ;; Generates the S
    call SHORT
    call SHORT
    ret
    
LONG:               ;; equivalent to dash in morse
      ldi r17, 0x20
      out 0x05, r17
      call WAIT
      call WAIT
      ldi r17, 0b00000000
      out 0x05, r17          ;; turn off light
      call WAIT
      ret ;; of routine LONG

WAIT:              // wait time for spaces 
      pushall 
      ldi  r22, 0xa0
      ldi  r23, 0x00
      ldi  r24, 0x00
      ldi  r25, 0x00
      call delay
      popall
      ret ;;

SHORT:            ;; equivalent to dot in more
        ldi r17, 0x20
        out 0x05, r17
        call WAIT
        ldi r17, 0b00000000
        out 0x05, r17        ;; turn off light
        call WAIT
        ret ;; of routine SHORT

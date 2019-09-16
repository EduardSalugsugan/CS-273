# Constants for motor

       ; on port B 
      .set PORTB,0x05
      .set DDIRB,0x04
      .set PINB, 0x03
      .set MOTDATA,0
      .set MOTLATCH,4
      .set M1ENABLE,3
      .set BOARDLED, 5
      .set SWITCH2, 2
      
      ; on port D
      .set PORTD,0x0B
      .set DDIRD,0x0A
      .set MOTCLOCK,4
      .set M2ENABLE,3
      .set M4ENABLE,6
      .set M3ENABLE,5
      
# Constants for LED

      ; on port C
      .set PORTC, 0x08
      .set DDIRC, 0x07

# Macros to push and pop registers without writing them multiple times
# Fun fact : One would prefer a function over macro but you cannot use a function that pushes onto stack, why? 

.macro pushall 
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
.endm

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
.endm

# Data

    .data
    .comm remotecommand, 2
    .global remotecommand ; For getting the 2 byte remote command sent from the .ino side

    .comm command, 1
    .global command ; To return the respective command for a button press
    
     commandlowbyte: ; All low bytes in order of 'commandcode'
     .byte 0x07, 0x2F, 0xBB, 0xDB, 0x3B  // FIX UPDATE THIS TO MATCH YOUR REMOTE LOWERBYTE

     commandhighbyte:  ;All high bytes in order of 'commandcode'
     .byte 0x2B, 0x97, 0x4D, 0xED, 0xC1 // FIX UPDATE THIS TO MATCH YOUR REMOTE UPPER BYTE

     # Command codes -- where '>' means forward (clockwise), '<' means backward (counter clockwise), '!' means stop motor
     # '^' means turn a LED on and 'v' mean turn a LED off.
     commandcode: 
     .byte '>', '<', '!', '^', 'v' // you should set command to one of these values based on the values in remotecommand, '.' for not found

     commandlen: ; maximum number of commands
     .byte 5

# Program

    .text
    .global control
    .global controlMotor
    .extern delay

control: 
      pushall
      call setupMotor
      ; 
      ; TODO: change this "mainLoop" to be the code for lab 8
      ;

      ; argument to sendMotorByte (r24) holds the 8-bits 
      ; to control 4 bidirectional motors: 
      ; (bits 2+3  for motor1, bits 0+6  for motor4, 
      ;  bits 1+4  for motor2, bits 5+7  for motor3)
      ;;   FIX This program runs forever, you are to make the following modifications
      ;;  Run the loop 3 times.  You should use turnoffmotor, turnonclockwise, and turnoncounterclockwise
      ;; 
mainLoop:        

      
      //ldi   r24, 0b11011000   ; all motors 1 direction
      //call  sendMotorByte
        ; delays three seconds
      
      //ldi r24, 0
      //call sendMotorByte
      
      //ldi   r24, 0b00100111   ; then all motors opposite dir
      //call  sendMotorByte
      
      //ldi R24, 0
      //call sendMotorByte
      
      //sbi PORTC, 5       ; turn on arduino board LED
      //cbi PORTC, 5
      
      call turnonclockwise
      call delayThree 
      
      call turnoffmotor
      call delayTwo
      
      call turnoncounterclockwise
      call delayThree
      
      call turnoffmotor
      call turnonlight
      
      call  delayThree
      call turnofflight
      
      popall
      ret  ;; of control()

setupMotor: 
      ; set ports B and D to be output
      ldi r20 ,0b11111001
      out DDIRB, r20
      out DDIRD, r20
      out DDIRC, r20
      ret ;; of setupMotor

remoteCommand: #  This routine uses the 2 bytes of remote command to determine which of the 
               #  5 inputs are selected
               #  on completion, the shared global variable "command" will be one of 6 values
               #   '<', '>', '!','^','v','.'
               
      pushall ; push all registers so that 'we' do not overwrite a register used by compiler/linker/loader

      LDI R31, hi8(commandhighbyte) // Z register
      LDI R30, lo8(commandhighbyte) // Z register

      LDI r29, hi8(commandlowbyte)  // Y register
      LDI r28, lo8(commandlowbyte)  // Y register
      
      LDI r27, hi8(remotecommand) // Read the 2 bytes of remote signal in X
      LDI r26, lo8(remotecommand) // Read the 2 bytes of remote signal in X
      
      # Read last 2 bytes

      LD r19, X+ // R19 = remotecommand[0]
      LD r18, X+ // R18 = remotecommand[1]

      LDI r27, hi8(commandcode) // X register is now filled with commandcode characters
      LDI r26, lo8(commandcode) // 
     
      LDI r20, 6  // counter
l1:    
      LD R23, Z+  // loading commandhighbyte
      LD R22, Y+  // loading commandlowbyte
      LD R21, X+  // loading commandcode
      DEC R20     // decrementing the commandcode length
      BREQ notthere // if not found
    
      CP R19, R23   // if found compare remote highbyte to commandhighbyte
      BRNE l1    // if not equal, move on to next element
      
      CP R18, R22   // if remote highbyte is equal, we compare the remote and command lowbytes
      BREQ there    // if remote lowbyte is equal, move on to found
      BRNE l1    // if remote lowbyte is not equal, move on to next element
      
notthere:
        LDI R20, '.'
        STS command, R20  // stores "Unknown Command" 
        RJMP done
there:  
        STS command, R21   // Sends back a character related to the remote command
done:      
        popall
        RET  ; of remoteCommand()

controlMotor:
      pushall
      call setupMotor ; Setup motor
      call remoteCommand ; Pattern match the remote command to get a code.  Sets "command"

      lds r22, command ; Load the code

      # Call corresponding utility based on the command code received.
      cpi r22, '>'
      breq turnonclockwise

      cpi r22, '<'
      breq turnoncounterclockwise

      cpi r22, '!'
      breq turnoffmotor

      cpi r22, '^'
      breq turnonlight

      cpi r22, 'v'
      breq turnofflight

finish:
      popall
      ret  ;  of controlMotor
      
turnoffmotor:
      LDI R24, 0
      CALL sendMotorByte
      jmp finish

turnonclockwise:      
      ldi   r24, 0b11011000   // turns motor clockwise
      call  sendMotorByte
      jmp finish

turnoncounterclockwise:

      ldi   r24, 0b00100111   // turns motor counterclockwise
      call  sendMotorByte
      jmp finish

turnonlight:

      SBI PORTC, BOARDLED
      jmp finish

turnofflight:

      CBI PORTC, BOARDLED
      jmp finish
      
#
# Delays for 1 and 255 milliseconds
#

delay1:     // delays 1 ms
      pushall
      ldi   r22, 0x01
      ldi   r23, 0x00
      ldi   r24, 0
      ldi   r25, 0
      call  delay
      popall
      ret ;; of delay1

delayLong:  // delays 255 ms
      pushall     
      ldi   r22, 0xE8
      ldi   r23, 0x13
      ldi   r24, 0
      ldi   r25, 0
      call  delay 
      popall    
      ret ;; of delayLong
      
delayTwo: // delays two seconds; 2000 ms
      pushall
      ldi   r22, 0xD0
      ldi   r23, 0x07
      ldi   r24, 0x00
      ldi   r25, 0x00
      call  delay
      popall     
      ret ;; of delayTwo

delayThree:   // delays three seconds; 3000 ms
      pushall
      ldi   r22, 0xB8
      ldi   r23, 0x0B
      ldi   r24, 0x00
      ldi   r25, 0x00
      call delay 
      popall
      ret

#  1 bit transmission
sendOneBit:
      
      CALL latchReset      // resets MOTLATCH
      SBI PORTB, MOTDATA   // sets PORTB for MOTDATA
      SBI PORTD, MOTCLOCK  // sets PORTD for MOTCLOCK
      CALL delay1          // delay 1 ms
      CBI PORTD, MOTCLOCK  // clears MOTCLOCK from PORTD
      CBI PORTB, MOTDATA   // clears MOTDATA from PORTB
      CALL delay1          // delay 1 ms
      ret

# 0 bit transmission
sendZeroBit:
      
      CALL latchReset     // resets MOTLATCH
      CBI PORTB, MOTDATA  // clears MOTDATA from PORTB
      SBI PORTD, MOTCLOCK // sets MOTCLOCK for PORTD
      CALL delay1         // delays 1 ms
      CBI PORTD, MOTCLOCK // clears MOTCLOCK from PORTD
      CBI PORTB, MOTDATA  // clears MOTDATA from PORTB
      CALL delay1         // delays 1 ms
      ret

#
# latch now should be enabled (one) in order to release 
# the control pattern to the motor driver chips 
#
latchData:
      sbi   PORTB,MOTLATCH
      call  delay1
      ; make sure PWM outputs are on
      sbi   PORTB, M1ENABLE
      sbi   PORTD, M2ENABLE
      sbi   PORTD, M3ENABLE
      sbi   PORTD, M4ENABLE
      ret

# latch should be zero in order to send the control 
# pattern to shift register    
latchReset: 
      cbi   PORTB,MOTLATCH
      call  delay1
      ret

sendMotorByte: ;; assumes r24 has the byte we want to send
      push  r15
      push  r16
      mov   r15, r24
      call  latchReset
      ldi   r16, 8
smbloop:
      lsl   r15
      brcs  smbone
      call  sendZeroBit   
      rjmp  smbdone
smbone:
      call  sendOneBit
smbdone:
      dec   r16
      brne  smbloop
      call  latchData
      call  latchReset
      pop   r16
      pop   r15
      ret

;;

;;  AVR code to do the function of the 4  x 7 segment display of Lab 5
;;
;;
;;   Shaun Cooper
;;    CS 273
;;    Semester XXXX , 20XX
;;
;;  The basic algorithm is to have the main loop
;; set some shared variable values
;;  we then use simulataneous arrays (vectors)
;;  to figure out which segment is desired 
;;; and which sequence is needed
;;
;;  Since our setup utilizes PORTB and PORTB, then we need to main
;;   simulataneous vectors for all of the segment sequences that are neededed
;;
;; main routine does
;;   setup_ports once
;; 
;;   C code to do the following

;;   segment=0
;;   digit=9
;;   display_segment();; will display 9 on segment 0, for example
;; 

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

  .data
  .size segment_table, 4
  .size portb_table, 10
  .size portd_table, 10
  
segment_table:  #binary for seting input on PORTB for segment select
    .byte 0b00000010, 0b00000100, 0b00001000, 0b00010000
    ;; 0, 1, 2,3 4, 5, 6 , 7, 8 , 9
portb_table:  # list of binary sequences for setting port B to be ORed with segment table ite
    .byte  0b00000001,1,0,0,0,0,0,1,0,0
portd_table: # list of binary sequences for setting port D.
    .byte  0b00000000,0b11100100,0b10010000,0b11000000,0b01100100,0b01001000,0b00001100,0b11100000,0, 0b01100000
segmentv: .byte 1


  
  .comm segment, 1 ;; the common name for segment
  .comm digit, 1 ;; the digit into our sequences
  .global segment, digit

  

# --------
  .text
  .global setup_ports
  .global display_segment



setup_ports:  ;; routine to set the ports into output mode
    pushall
    LDI R16, 0b11111111
    OUT 0x04, R16
    OUT 0x0A, R16
    popall
    
    ret ;; of setup_ports

display_segment:
    pushall 
    
    LDI R31, hi8(segment_table) ; initialize high byte of Z
    LDI R30, lo8(segment_table) ; initialize low byte of Z
    LDI R29, hi8(portb_table) ; initialize high byte of Y
    LDI R28, lo8(portb_table) ; initialize low byte of Y
    LDI R27, hi8(portd_table) ; initialize high byte of X
    LDI R26, lo8(portd_table) ; initialize low byte of X
            
    LDS r16, segment
    LDS r17, digit
   
loop: 
    LD r20, Z+  ;; loads z+ to register 20
    CPI r16, 0  ;; compares segment
    BREQ L1     ;; if r16 = 0 goes to L1
    DEC R16     ;; decremens r16 if not equal to 0 
    JMP loop    ;; then jumps to loop again till r16 equals to 0

L1: 
    LD R21, Y+  ;; loads Y+ to r21
    LD R22, X+  ;; loads X+ to r22
    CPI R17, 0  ;; compares segment
    BREQ L2     ;; if r17 = 0 goes to L2
    DEC R17     ;; decremens r17 if not equal to 0 
    JMP L1      ;; then jumps to L1 again till r17 equals to 0

L2: 
    or r20,r21
    OUT 0x05, r20   ;; pushes out r20
    OUT 0x0B, r22   ;; pushes out r22 
    
    popall
    ret  ;; end of program
  

 


;#include "C8051F020.h"
ORG 00H

SW1 BIT P1.0
SW2 BIT P1.1
BEGIN BIT P0.0
	
R_LED BIT P1.6
G_LED BIT P1.7
	
SETB SW1
SETB SW2
SETB BEGIN

SETB R_LED
CLR G_LED

MOV R1, #00H                         ;Digit1 num
MOV R2, #00H                         ;Digit2 num
MOV DPTR, #200H 

INIT: 
	MOV A, R1
	MOVC A, @A+DPTR
	MOV P2, A
	MOV A, R2 
	MOVC A, @A+DPTR
	MOV P3, A

JNB BEGIN,START

JNB SW1,INCREMENT1
JNB SW2,INCREMENT2

SJMP INIT 

INCREMENT1:
	CJNE R1, #09H, IN1
	MOV R1,#00H
	ACALL DELAY
	SJMP INIT
	IN1:INC R1
	ACALL DELAY
	SJMP INIT
	
INCREMENT2:
	CJNE R2,#09H,IN2
	MOV R2,#00H
	ACALL DELAY
	SJMP INIT
	IN2:INC R2
	ACALL DELAY
	SJMP INIT

START:
	MOV 60H,R1
	MOV 50H,R2
	
	
	JNB P1.2,A0
	JNB P1.3,A1
	JNB P1.4,A2
	L:
	MOV DPTR,#20FH
	MOVC A,@A+DPTR
	MOV 61H,A
	MOV DPTR,#200H
	SJMP MAIN
	
A0:MOV A ,#00H
SJMP L
A1:MOV A ,#01H
SJMP L
A2:MOV A ,#02H
SJMP L

MAIN: 
	ACALL DELAY1
	MOV A, R1
	MOVC A, @A+DPTR
	MOV P2, A
	MOV A, R2 
	MOVC A, @A+DPTR
	MOV P3, A
	
DEC1:
	CJNE R1,#00H,DC1
	MOV R1,#09H
	SJMP DEC2
	DC1:DEC R1
	SJMP MAIN

DEC2:
	CJNE R2,#00H,DC2
	SJMP FINISH
	DC2:DEC R2
	SJMP MAIN
	
FINISH:
	CPL R_LED
	CPL G_LED
	MOV R1,60H
	MOV R2,50H
	SJMP START
		 
	

ORG 200H 
DB 3FH, 06H, 5BH, 4FH, 66H, 6DH, 7DH, 07H, 7FH, 6FH 
	
ORG 20FH
DB 05H, 0AH, 014H 

	
DELAY:
	MOV R3,#02H
	UP2:MOV R4,#0FFH 
	UP1: MOV R5, #0FFH 
	HERE: DJNZ R5, HERE 
		DJNZ R4, UP1 
		DJNZ R3, UP2 
	RET
	
DELAY1:
	
	MOV R3, 61H
	UP22:MOV R4,#00H 
	UP11: MOV R5, #0C8H
	HERE1: DJNZ R5, HERE1 
		DJNZ R4, UP11 
		DJNZ R3, UP22 
	RET
	

END
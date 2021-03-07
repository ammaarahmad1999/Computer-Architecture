;Count the number of set bits
.MODEL SMALL
.STACK 100H
.DATA
	DATA1 DB 99H		;ORIGINAL NUMBER
	SET   DB ?		;NUMBER OF SET BITS
.CODE
START:	MOV AX, @DATA		
	MOV DS, AX
	MOV AL, DATA1		;COOYING FIRST DATA
	MOV BL, 00		;INITIALIZING TO 0
	MOV CX, 0008H		;COUNT=8 FOR LOOP
REPEAT:	RCR AL, 01		;ROTATING RIGHT THROUGH CARRY
	JNC SKIP		;IF CARRY=0 SKIP NEXT STEP
	INC BL			;INCREMENT COUNT
SKIP:	LOOP REPEAT		;WHILE CX>0 LOOP CONTINUES
	MOV SET, BL		;STORING NO. OF SET BIT
	MOV AH, 4CH
	INT 21H
	END START
.END
	
	
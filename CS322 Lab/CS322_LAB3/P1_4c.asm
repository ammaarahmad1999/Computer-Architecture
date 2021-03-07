; Adding 2 4 digits BCD numbers
.MODEL SMALL
.STACK 100H
.DATA
	DATA1 DB 45H		;FIRST NUMBER
	DATA2 DB 56H		;SECOND NUMBER
	DATA3 DB ?		;NEW NUMBER AFTER ADDITION
	CARRY DB ?		;CARRY AFTER ADDITION
.CODE
START:	MOV AX, @DATA				
	MOV DS, AX
	MOV AL, DATA1		;STORING FIRST NUMBER
	MOV BL, DATA2		;STORING SECOND NUMBER
	ADD AL, BL		;ADDITION
	DAA			;DECIMAL ADJUSTMENT
	MOV DATA3, AL		;STORING ANSWER
	MOV AL, 00H		;AL=0
	ADC AL, AL		;ADDING CARRY TO AL
	MOV CARRY, AL		;STORING CARRY
	MOV AH, 4CH		
	INT 21H
	END START
.END
	
; Sum of 2 digit Hexadecimal No.
.MODEL SMALL
.STACK 100H
.DATA
	DATA1 DB 99H		;STORING THE HEX NUMBER
	SUM   DB ?		;SUM OF DIGITS
.CODE
START:	MOV AX, @DATA		
	MOV DS, AX
	MOV AL, DATA1		;COPYING THE NUMBER
	MOV AH, DATA1		;COPYING THE NUMBER
	AND AL, 0FH		;MASKING FIRST 4 BITS
	AND AH, 0F0H		;MASKING LAST 4 BITS
	MOV CL, 04H		;COUNT FOR ROTATION
	ROR AH, CL		;ROTATING RIGHT BY 4 BITS
	ADD AL, AH		;ADDING BOTH THE DIGITS
	MOV SUM,AL		;STORING SUM
	MOV AH, 4CH		
	INT 21H
	END START
.END
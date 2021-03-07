; Converting BCD to Hexadecimal
.MODEL SMALL
.STACK 100H
.DATA
	DATA1 DB 99H		;BCD NUMBER IN HEX FORM
	HEX   DB ?
.CODE
START:	MOV AX, @DATA		
	MOV DS, AX
	MOV AL, DATA1		;COPYING NUMBER TO AL
	MOV BL, DATA1		;COPYING NUMBER TO BL
	AND AL, 0F0H		;MASKING LAST 4 BITS
	AND BL, 0FH		;MASKING FIRST 4 BITS
	MOV CL, 04H		;COUNT ROTATION
	ROR AL, CL		;ROTATING RIGHT BY 4
	MOV DL, 0AH		;STORING DL=10 IN DECIMAL
	MUL DL			;MULTIPLICATION OF AL AND DL
	ADD AL, BL		;ADDING AL AND BL
	MOV HEX, AL		;STORING HEXADECIMAL VALUE
	MOV AH, 4CH		
	INT 21H
	END START
.END
	

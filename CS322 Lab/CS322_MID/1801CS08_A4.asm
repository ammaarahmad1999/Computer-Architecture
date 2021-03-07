;DIFFERENT ADDRESSING MODES
.MODEL SMALL
.STACK 100H
.DATA
	ARR DB 07H, 05H, 34H, 54H, 78H
	LEN DB 05H
.CODE
START:	MOV AX, @DATA		;AX = DATA SEGMENT ADDRESS
	MOV DS, AX		;LOADING DS TO AX
	LEA BX, ARR		;LOADING BASE ADDRESS OF ARR
	MOV AL, [BX]		;REGISTER INDIRECT ADDRESSING MODE
	ADD AL, CL		;REGISTER ADDRESSING MODE
	MOV [BX], AL		;REGISTER INDIRECT ADDRESSING MODE
	MOV AL, [BX+01H]	;BASED ADDRESSING MODE
	MOV [BX+01H], AL	;BASED ADDRESSING MODE
	
	MOV SI, 02H		;IMMEDIATE ADDRESSING MODE
	MOV AL, [BX+SI]		;BASED INDEXED ADDRESSING MODE
	ADD AL, AL		;REGISTER ADDRESSING MODE
	MOV [BX+SI], AL		;BASED INDEXED ADDRESSING MODE
	
	MOV AL, [BX+SI+01H]	;BASED INDEXED RELATIVE ADDRESSING MODE
	ADD AL, AL		;REGISTER ADDRESSING MODE
	MOV [BX+SI+01H], AL	;BASED INDEXED RELATIVE ADDRESSING MODE
	
	LEA SI, ARR		;LOADING ADDRESS OF ARR
	MOV AL, [SI+04H]	;INDEXED ADDRESSING MODE
	STC 			;IMPLIED ADDRESSING MODE
	ADC AL, 00H		;IMMEDIATE ADDRESSING MODE
	MOV [SI+04H], AX	;INDEXED ADDRESSING MODE

	MOV AL, [0006H]		;DIRECT ADDRESSING MODE
	ADD AL, AL		;REGISTER ADDRESSING MODE
	
	MOV AH, 4CH
	INT 21H
	END START
.END
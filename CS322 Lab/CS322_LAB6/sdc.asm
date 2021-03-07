; Simple Program using Nasm
; CS/Algo used: Simple Application of Number Theory

extern printf
extern scanf
extern exit

SEGMENT .DATA
Start_msg	db	"Enter the 16 bit number to play the game: ",0 
Player_Won	db	"You Won",10 ,0
Computer_Won	db 	"Computer Won",10 ,0
Restart_msg	db	"Do you want to play again: Y for Yes, N for No: ",0
Char		db 	"%c",0
Integer		db	"%d",0

SECTION .bss
C	resb 1
NUM	resb 16

SECTION .CODE
GLOBAL main
main:
NEW:	;Start Message
	MOV	RAX, 0
	MOV 	RDI, Start_msg	
	CALL	printf	
	
	;Number from user
	MOV	RAX, 0
	MOV	RDI, Integer
	MOV	RSI, NUM
	CALL 	scanf

	MOV 	AX, [NUM]
AHEAD:	MOV	CX, 08
	MOV	BX, 00
NEXT:	MOV	DX, AX
	AND	DX, 03
	ADD	BX, DX
	DEC 	CX
	RCR	AX, 02
	LOOP	NEXT
	MOV	AX, BX
	CMP	AX, 04
	JC	SKIP
	JMP	AHEAD
SKIP:	CMP	AX, 00
	JE	PLAYER
        CMP     AX,03
        JE      PLAYER

	MOV	RAX, 0
	MOV 	RDI, Computer_Won
	CALL	printf
	JMP	RESTART

PLAYER: MOV	RAX, 0
	MOV 	RDI, Player_Won
	CALL	printf

	;Restart Game	
RESTART:MOV	RAX, 0
	MOV 	RDI, Restart_msg
	CALL	printf
	
	;User choice input
	MOV	RAX, 0
	MOV	RDI, Char
	MOV	RSI, C
	CALL 	scanf

	MOV	RAX, 0
	MOV	RDI, Char
	MOV	RSI, C
	CALL 	scanf

	MOV	AL, [C]
	CMP 	AL, 89		;Checking if AL ='Y'
	JE	NEW		;If equal restart->NEW

	;Exit Game
EXIT:	MOV	RAX, 0
	MOV	RDI, 0
	CALL 	exit	

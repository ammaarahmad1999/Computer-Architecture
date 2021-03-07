//Sorting the elements in ascending order
#ORG 2000H
#BEGIN 2000H
LXI H,2050H		//Set pointer for array
MOV C,M
DCR C
REPEAT: MOV D,C
LXI H,2051H
LOOP: MOV A,M
INX H
CMP M
JC SKIP
MOV B,M
MOV M,A
DCX H
MOV M,B
INX H
SKIP: DCR D
JNZ LOOP
DCR C
JNZ REPEAT
HLT		//Terminate the program
//Answer is stored in 2051H TO 2055H
//05H - SIZE OF ARRAY
//05H,01H,F1H,26H,FEH - ARRAY DATA
//The data in array is sorted
#ORG 2050H
#DB 05H,0AH,F1H,1FH,FEH,26H
//Answer is 0A 1F 26 F1 FE

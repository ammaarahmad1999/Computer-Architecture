4. Sum of first n natural numbers as 16 bit answer
#ORG 2000H
# BEGIN 2000H
LDA 2050H		//LOADING THE VALUE OF N
MOV C,A		//STORING N
MVI H,00H		//INITALING ANSWER=00
MVI L,00H
LOOP: DAD B		//ADDING B-C TO H-L
DCR C		//DECREAMENTING C
JNZ LOOP		//WHILE C!=0 LOOP
SHLD 2051H		//STORING ANSWER TO 2051 MEMORY
HLT		//END
# ORG 2050H
# DB 1CH

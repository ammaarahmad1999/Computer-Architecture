3. Multiplying 2 8 bits numbers as 16 bit answer
#ORG 2000H
# BEGIN 2000H
LDA 2050H		//LOADING DATA 
MOV C,A		//COPYING THE MULTIPLICAND
LDA 2051H		//LODING MULTIPLIER
MVI H, 00H		//INITALING ANS=0
MVI L, 00H		
LOOP : DAD B	//LOOP TO ADD MULTIPLICAND FOR
DCR A		//MULTIPLIER NO OF TIMES
JNZ LOOP		//IF MULTIPLIER IS 0 BREAK LOOP
SHLD 2052H		//STORING THE RESULT IN REVERSE ORDER
HLT
# ORG 2050H
# DB 11H, 1AH

// Subtraction of 2 16 bits numbers
#ORG 2000H
# BEGIN 2000H
LHLD 2050H	//LOADING NUMBER TO BE SUBTRACTED	
XCHG	//STORING 16 BIT IN REGISTER DE	
LHLD 2052H	//LOAD FIRST NUMBER
MOV A,L	//LAST 8 BIT TO A
SUB E	//SUBTRACTION OF LAST 8 BITS
MOV L,A	//FINAL LAST 8 BITS COPIED TO L
MOV A,H	//FIRST 8 BITS TO A
SBB D	//SUBTRACTION OF FIRST 8 BITS
MOV H,A	//FINAL FIRST 8 BITS COPIED TO H
SHLD 2054H	//STORING THE ANSWER IN REVERSE ORDER
HLT
// ENTER THE 2ND NUMBER AND THEN 1ST NUMBER EACH IN REVERSE ORDER
# ORG 2050H
# DB 53H, 01H, 2BH, CAH

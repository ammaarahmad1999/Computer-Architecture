10. Dividing 2 16 bit numbers
#ORG 2000H
# BEGIN 2000H
LHLD 2050H
XCHG
LHLD 2052H
LXI B, 0000H
LOOP: MOV A,L
SUB E
MOV L,A
MOV A,H
SBB D
MOV H,A
JC AHEAD
INX B
JMP LOOP
AHEAD: DAD D
SHLD 2056H
MOV L,C
MOV H,B
SHLD 2054H
HLT

// ENTER THE DIVISOR AND DIVIDEND EACH IN REVERSE ORDER
# ORG 2050H
# DB 53H, 00H, 2BH, CAH
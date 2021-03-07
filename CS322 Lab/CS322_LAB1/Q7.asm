// COPY PASTE OPERATION
#ORG 2000H
#BEGIN 2000H
LXI H, 2050H		//POINTER TO INITIAL DATA
LXI D, 2060H		//POINTER WHERE DATA IS TO BE COPIED
MVI C, 08H		//MAXIMUM NUMBER OF ELEMENTS
LOOP: MOV A,M	//LOADING ACCUMULATOR WITH CURRENT DATA
STAX D		//COPYING DATA FROM A TO NEW LOCATION
INX H		//INCREMENT OF ORIGINAL POINTER	
INX D		//INCREMENT OF NEW POINTER
DCR C		//DECREMENT OF NUMBER OF ELEMENTS LEFT TO COPY
JNZ LOOP		//WHEN ZERO LOOP BREAKS
HLT		//END
#ORG 2050H
#DB 54H, 35H, 76H, 8AH, FFH, 7BH, 10H, 6DH
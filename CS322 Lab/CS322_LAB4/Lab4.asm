.model small
.stack  256
.data
	STRING1 DB 'Left Pad Up: w, Down: s $'
	STRING2 DB 10,13,'Right Pad Up: o, Down:l $'
	STRING3 DB 10,13,'Keys are case insentivie $'
	STRING4 DB 10,13,'Press Any Key to continue $'
	STRING5 DB 10,13,'Game over',10,13,'Left Won$'
	STRING6 DB 10,13,'Game over',10,13,'Right Won$'
	
	WINDOW_WIDTH DW 140h   		;the width of the window (320 pixels)
	WINDOW_HEIGHT DW 0C8h  		;the height of the window (200 pixels)
	WINDOW_BOUNDS DW 04h   		;variable used to check collisions early

	TIME_AUX DB 0 			;variable used when checking if the time has changed

	BALL_ORIGINAL_X DW 0A0h		;X position of the ball on the beginning of a game
	BALL_ORIGINAL_Y DW 64h		;Y position of the ball on the beginning of a game
	BALL_X DW 0A0h 			;X position (column) of the ball
	BALL_Y DW 64h 			;Y position (line) of the ball
	BALL_SIZE DW 04h 		;size of the ball (how many pixels does the ball have in width and height)
	BALL_VELOCITY_X DW 04h 		;X (horizontal) velocity of the ball
	BALL_VELOCITY_Y DW 02h 		;Y (vertical) velocity of the ball

	PADDLE_LEFT_X DW 0Ah		;current X position of the left paddle
	PADDLE_LEFT_Y DW 55h		;current Y position of the left paddle
	
	PADDLE_RIGHT_X DW 130h		;current X position of the right paddle
	PADDLE_RIGHT_Y DW 55h		;current Y position of the right paddle
	
	PADDLE_WIDTH DW 05h		;width of both the paddle
	PADDLE_HEIGHT DW 1Eh		;height of both the paddle
	PADDLE_VELOCITY DW 05h		;velocity of both the paddle when moving a step

.code
START:	MOV AX, @DATA			;save on the AX register the contents of the DATA segment	
	MOV DS, AX			;save on the DS segment the contents of AX
	
	;Printiing initial intructions
	LEA DX, STRING1
	MOV AH, 09H
	INT 21H
	LEA DX, STRING2
	MOV AH,	09H
	INT 21H
	LEA DX, STRING3
	MOV AH, 09H
	INT 21H
	LEA DX, STRING4
	MOV AH, 09H
	INT 21H

	;Waiting for any response to start
	MOV AH, 00H
	INT 16H
	
	CALL CLEAR_SCREEN		;Clearing the screen initially
	
	CHECK_TIME:
		MOV AH,2Ch 		;get the system time
		INT 21h    		;CH = hour CL = minute DH = second DL = 1/100 seconds
			
		CMP DL,TIME_AUX  	;is the current time equal to the previous one(TIME_AUX)?
		JE CHECK_TIME    	;if it is the same, check again
		
		;if it's different, then draw, move, etc.
		MOV TIME_AUX,DL 	;update time
		
		CALL CLEAR_SCREEN	;clear screen by restarting the video mode
		CALL MOVE_BALL		;move the ball to new location
		CALL DRAW_BALL 		;draw the ball at new location
		
		CALL MOVE_PADDLES	;move the paddle to new location
		CALL DRAW_PADDLES	;draw the paddle to new location
		
		;JMP CHECK_TIME
		
		MOV AX, PADDLE_RIGHT_X	
		CMP BALL_X, AX		;checking if ball crossed the right paddle
		JNG CHECK		;if no then jump to check
		
		;if ball crossed the right paddle then game is over and left won
		LEA DX, STRING5
		MOV AH, 09H
		INT 21H
		MOV AH, 4CH
		INT 21H
		
	CHECK:	MOV AX, PADDLE_LEFT_X	
		CMP BALL_X, AX		;checking if ball crossed the left paddle
		JNL CHECK_TIME		;if ball is within boundary check time again
	
		;if ball crossed the left paddle then game is over and right won
		LEA DX, STRING6
		MOV AH, 09H
		INT 21H
		MOV AH, 4CH
		INT 21H


MOVE_BALL PROC				;procedure of movement of ball
		
		;move the ball horizontally
		MOV AX,BALL_VELOCITY_X    
		ADD BALL_X,AX          	
		
		;Check if the ball has passed the left boundarie (BALL_X < 0 + WINDOW_BOUNDS)
		;If is colliding, restart its position
		MOV AX,WINDOW_BOUNDS
		CMP BALL_X,AX           ;BALL_X is compared with the left boundarie of the screen (0 + WINDOW_BOUNDS)              
		JL RESET_POSITION       ;if is less, reset position 
		
		;Check if the ball has passed the right boundarie (BALL_X > WINDOW_WIDTH - BALL_SIZE  - WINDOW_BOUNDS)
		;If is colliding, restart its position		
		MOV AX,WINDOW_WIDTH
		SUB AX,BALL_SIZE
		SUB AX,WINDOW_BOUNDS
		CMP BALL_X,AX	        ;BALL_X > WINDOW_WIDTH - BALL_SIZE  - WINDOW_BOUNDS (Y -> collided)  
		JG RESET_POSITION	;if is greater, reset position 
		
		;move the ball vertically
		MOV AX,BALL_VELOCITY_Y
		ADD BALL_Y,AX             
		
		;Check if the ball has passed the top boundarie (BALL_Y < 0 + WINDOW_BOUNDS)
	       	;If is colliding, reverse the velocity in Y
		MOV AX,WINDOW_BOUNDS
		CMP BALL_Y,AX   	;BALL_Y < 0 + WINDOW_BOUNDS (Y -> collided)
		JL NEG_VELOCITY_Y       ;if is less, reset position      	            
		
		MOV AX,WINDOW_HEIGHT	
		SUB AX,BALL_SIZE
		SUB AX,WINDOW_BOUNDS
		CMP BALL_Y,AX		;BALL_Y > WINDOW_HEIGHT - BALL_SIZE - WINDOW_BOUNDS (Y -> collided)
		JG NEG_VELOCITY_Y	;if is greater, reset position 	 

		CALL CHECK_COLLISION
		RET
	
		RESET_POSITION:
		CALL RESET_BALL_POSITION;reset ball position to the center of the screen
		RET
			
		NEG_VELOCITY_Y:
		NEG BALL_VELOCITY_Y   	;reverse the velocity in Y of the ball (BALL_VELOCITY_Y = - BALL_VELOCITY_Y)
			RET
		
MOVE_BALL ENDP

CHECK_COLLISION PROC
		
		;Check if the ball is colliding with the right paddle
		; maxx1 > minx2 && minx1 < maxx2 && maxy1 > miny2 && miny1 < maxy2
		; BALL_X + BALL_SIZE > PADDLE_RIGHT_X && BALL_X < PADDLE_RIGHT_X + PADDLE_WIDTH 
		; && BALL_Y + BALL_SIZE > PADDLE_RIGHT_Y && BALL_Y < PADDLE_RIGHT_Y + PADDLE_HEIGHT
	
	CHECK_COLLISION_WITH_RIGHT_PADDLE:	
		MOV AX,BALL_X
		ADD AX,BALL_SIZE
		CMP AX,PADDLE_RIGHT_X
		JNG CHECK_COLLISION_WITH_LEFT_PADDLE  ;if there's no collision check for the left paddle collisions
		
		MOV AX,PADDLE_RIGHT_X
		ADD AX,PADDLE_WIDTH
		CMP BALL_X,AX
		JNL CHECK_COLLISION_WITH_LEFT_PADDLE  ;if there's no collision check for the left paddle collisions
		
		MOV AX,BALL_Y
		ADD AX,BALL_SIZE
		CMP AX,PADDLE_RIGHT_Y
		JNG CHECK_COLLISION_WITH_LEFT_PADDLE  ;if there's no collision check for the left paddle collisions
		
		MOV AX,PADDLE_RIGHT_Y
		ADD AX,PADDLE_HEIGHT
		CMP BALL_Y,AX
		JNL CHECK_COLLISION_WITH_LEFT_PADDLE  ;if there's no collision check for the left paddle collisions
		
		;If it reaches this point, the ball is colliding with the right paddle

		NEG BALL_VELOCITY_X              ;reverses the horizontal velocity of the ball
		RET                               
		
		;Check if the ball is colliding with the left paddle
		; maxx1 > minx2 && minx1 < maxx2 && maxy1 > miny2 && miny1 < maxy2
		; BALL_X + BALL_SIZE > PADDLE_LEFT_X && BALL_X < PADDLE_LEFT_X + PADDLE_WIDTH 
		; && BALL_Y + BALL_SIZE > PADDLE_LEFT_Y && BALL_Y < PADDLE_LEFT_Y + PADDLE_HEIGHT
		
	CHECK_COLLISION_WITH_LEFT_PADDLE:
		MOV AX,BALL_X
		ADD AX,BALL_SIZE
		CMP AX,PADDLE_LEFT_X
		JNG EXIT  	;if there's no collision jump to exit
		
		MOV AX,PADDLE_LEFT_X
		ADD AX,PADDLE_WIDTH
		CMP BALL_X,AX
		JNL EXIT 	;if there's no collision jump to exit
		
		MOV AX,BALL_Y
		ADD AX,BALL_SIZE
		CMP AX,PADDLE_LEFT_Y
		JNG EXIT	;if there's no collision jump to exit
	
		MOV AX,PADDLE_LEFT_Y
		ADD AX,PADDLE_HEIGHT
		CMP BALL_Y,AX
		JNL EXIT 	;if there's no collision jump to exit
	
		NEG BALL_VELOCITY_X              ;reverses the horizontal velocity of the ball
		RET   
		
		EXIT:
		RET          

CHECK_COLLISION ENDP

MOVE_PADDLES PROC
		
	;left paddle movement
		
	;check if any key is being pressed (if not check the other paddle)
	MOV AH,01h
	INT 16h
	JNZ CHECK_LEFT_PADDLE_MOVEMENT 		;ZF = 0, JZ -> Jump If not Zero
		RET

	;left paddle movement
	CHECK_LEFT_PADDLE_MOVEMENT:

	;check which key is being pressed (AL = ASCII character)
	MOV AH,00h
	INT 16h
		
	;if it is 'w' or 'W' move up
	CMP AL,77h ;'w'
	JE MOVE_LEFT_PADDLE_UP
	CMP AL,57h ;'W'
	JE MOVE_LEFT_PADDLE_UP
		
	;if it is 's' or 'S' move down
	CMP AL,73h ;'s'
	JE MOVE_LEFT_PADDLE_DOWN
	CMP AL,53h ;'S'
	JE MOVE_LEFT_PADDLE_DOWN
	JMP CHECK_RIGHT_PADDLE_MOVEMENT		;if pressed key is not s or w then jump to right paddle movement
		
	MOVE_LEFT_PADDLE_UP:			;move left paddle up if key is 's' or 'S'
		MOV AX,PADDLE_VELOCITY				
		SUB PADDLE_LEFT_Y,AX		;checking the position of left paddle				
		CMP PADDLE_LEFT_Y,00H		;if left paddle is already touching top boundary
		JL FIX_PADDLE_LEFT_TOP_POSITION	;fix it back to that position
		JMP EXIT_PADDLE_MOVEMENT	;or else exit paddle movement
			
		FIX_PADDLE_LEFT_TOP_POSITION:	;fixing left paddle to top boundary
		MOV PADDLE_LEFT_Y,00H
		JMP EXIT_PADDLE_MOVEMENT	;exit paddle movement
			
	MOVE_LEFT_PADDLE_DOWN:			;move left paddle up if key is 'w' or 'W'
		MOV AX,PADDLE_VELOCITY		
		ADD PADDLE_LEFT_Y,AX		
		MOV AX,WINDOW_HEIGHT
		SUB AX,PADDLE_HEIGHT		;checking the position of left paddle
		CMP PADDLE_LEFT_Y,AX		;if left paddle is already touching bottom boundary
		JG FIX_PADDLE_LEFT_BOTTOM_POSITION;fix it back to that position
		JMP EXIT_PADDLE_MOVEMENT	;or else exit paddle movement
			
		FIX_PADDLE_LEFT_BOTTOM_POSITION:;fixing right paddle to bottom boundary
		MOV PADDLE_LEFT_Y,AX
		JMP EXIT_PADDLE_MOVEMENT	;exit paddle movement
		
		
	;right paddle movement
	CHECK_RIGHT_PADDLE_MOVEMENT:
		
	;if it is 'o' or 'O' move up
	CMP AL,6Fh ;'o'
	JE MOVE_RIGHT_PADDLE_UP
	CMP AL,4Fh ;'O'
	JE MOVE_RIGHT_PADDLE_UP
			
	;if it is 'l' or 'L' move down
	CMP AL,6Ch ;'l'
	JE MOVE_RIGHT_PADDLE_DOWN
	CMP AL,4Ch ;'L'
	JE MOVE_RIGHT_PADDLE_DOWN
	JMP EXIT_PADDLE_MOVEMENT		;exit paddle movement
			

	MOVE_RIGHT_PADDLE_UP:			;move right paddle up if key is 'o' or 'O'
		MOV AX,PADDLE_VELOCITY		
		SUB PADDLE_RIGHT_Y,AX		;check ther position of right paddle
		CMP PADDLE_RIGHT_Y,00		;if right paddle is already touching bottom boundary
		JL FIX_PADDLE_RIGHT_TOP_POSITION;fix the same position 
		JMP EXIT_PADDLE_MOVEMENT	;exit paddle movement
				
		FIX_PADDLE_RIGHT_TOP_POSITION:	;fixing right paddle to top boundary
		MOV PADDLE_RIGHT_Y,00		
		JMP EXIT_PADDLE_MOVEMENT	;exit paddle movement
			
	MOVE_RIGHT_PADDLE_DOWN:			;move right paddle down if key is 'l' or 'L'
		MOV AX,PADDLE_VELOCITY	
		ADD PADDLE_RIGHT_Y,AX		
		MOV AX,WINDOW_HEIGHT		
		SUB AX,PADDLE_HEIGHT		;check the position of right paddle
		CMP PADDLE_RIGHT_Y,AX		;if right paddle is already touching bottom boundary
		JG FIX_PADDLE_RIGHT_BOTTOM_POSITION;fix it to same position	
		JMP EXIT_PADDLE_MOVEMENT	;exit paddle movement
				
		FIX_PADDLE_RIGHT_BOTTOM_POSITION:	;fixing right paddle to bottom boundary
		MOV PADDLE_RIGHT_Y,AX
		
	EXIT_PADDLE_MOVEMENT:			;exit paddle movement
		RET
		
MOVE_PADDLES ENDP

RESET_BALL_POSITION PROC	;restart ball position to the original position
		
	MOV AX,BALL_ORIGINAL_X
	MOV BALL_X,AX
		
	MOV AX,BALL_ORIGINAL_Y
	MOV BALL_Y,AX
		
	RET

RESET_BALL_POSITION ENDP

DRAW_BALL PROC 
	MOV CX,BALL_X 		;set the initial column (X)
	MOV DX,BALL_Y 		;set the initial line (Y)
		
	DRAW_BALL_HORIZONTAL:
		MOV AH,0Ch 	;set the configuration to writing a pixel
		MOV AL,0Fh 	;choose white as color
		MOV BH,00h 	;set the page number 
		INT 10h    	;execute the configuration
			
		INC CX     	;CX = CX + 1
		MOV AX,CX  	;CX - BALL_X > BALL_SIZE (Y -> We go to the next line,N -> We continue to the next column
		SUB AX,BALL_X
		CMP AX,BALL_SIZE
		JNG DRAW_BALL_HORIZONTAL
			
		MOV CX,BALL_X 	;the CX register goes back to the initial column
		INC DX        	;we advance one line
			
		MOV AX,DX       ;DX - BALL_Y > BALL_SIZE (Y -> we exit this procedure,N -> we continue to the next line
		SUB AX,BALL_Y
		CMP AX,BALL_SIZE
		JNG DRAW_BALL_HORIZONTAL
	RET
DRAW_BALL ENDP

DRAW_PADDLES PROC
		
	MOV CX,PADDLE_LEFT_X 	;set the initial column (X)
	MOV DX,PADDLE_LEFT_Y 	;set the initial line (Y)
		
	DRAW_PADDLE_LEFT_HORIZONTAL:
		MOV AH,0Ch 	;set the configuration to writing a pixel
		MOV AL,0Fh 	;choose white as color
		MOV BH,00h 	;set the page number 
		INT 10h    	;execute the configuration
			
		INC CX     	;CX = CX + 1
		MOV AX,CX       ;CX - PADDLE_LEFT_X > PADDLE_WIDTH (Y -> We go to the next line,N -> We continue to the next column
		SUB AX,PADDLE_LEFT_X
		CMP AX,PADDLE_WIDTH
		JNG DRAW_PADDLE_LEFT_HORIZONTAL
			
		MOV CX,PADDLE_LEFT_X ;the CX register goes back to the initial column
		INC DX        	;we advance one line
			
		MOV AX,DX       ;DX - PADDLE_LEFT_Y > PADDLE_HEIGHT (Y -> we exit this procedure,N -> we continue to the next line
		SUB AX,PADDLE_LEFT_Y
		CMP AX,PADDLE_HEIGHT
		JNG DRAW_PADDLE_LEFT_HORIZONTAL
			
			
	MOV CX,PADDLE_RIGHT_X ;set the initial column (X)
	MOV DX,PADDLE_RIGHT_Y ;set the initial line (Y)
		
	DRAW_PADDLE_RIGHT_HORIZONTAL:
		MOV AH,0Ch 	;set the configuration to writing a pixel
		MOV AL,0Fh 	;choose white as color
		MOV BH,00h 	;set the page number 
		INT 10h    	;execute the configuration
			
		INC CX     	;CX = CX + 1
		MOV AX,CX       ;CX - PADDLE_RIGHT_X > PADDLE_WIDTH (Y -> We go to the next line,N -> We continue to the next column
		SUB AX,PADDLE_RIGHT_X
		CMP AX,PADDLE_WIDTH
		JNG DRAW_PADDLE_RIGHT_HORIZONTAL
			
		MOV CX,PADDLE_RIGHT_X ;the CX register goes back to the initial column
		INC DX        	;we advance one line
			
		MOV AX,DX       ;DX - PADDLE_RIGHT_Y > PADDLE_HEIGHT (Y -> we exit this procedure,N -> we continue to the next line
		SUB AX,PADDLE_RIGHT_Y
		CMP AX,PADDLE_HEIGHT
		JNG DRAW_PADDLE_RIGHT_HORIZONTAL
			
	RET
DRAW_PADDLES ENDP

CLEAR_SCREEN PROC
	MOV AH,00h 		;set the configuration to video mode
	MOV AL,13h 		;choose the video mode
	INT 10h    		;execute the configuration 
		
	MOV AH,0Bh 		;set the configuration
	MOV BH,00h 		;to the background color
	MOV BL,00h 		;choose black as background color
	INT 10h    		;execute the configuration
			
	RET
CLEAR_SCREEN ENDP
	
END START
	
.END	
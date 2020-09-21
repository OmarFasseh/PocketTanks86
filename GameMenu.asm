EXTRN Game:FAR
EXTRN chmd:FAR
EXTRN INITIALIZE:FAR
EXTRN serialmode:byte
EXTRN level:byte
PUBLIC user1
PUBLIC user2
PUBLIC inputBfr
.model large
.data     

;---------------------Game modules--------------------


;----------------------------------Color palette Used in drawing----------------------------------;
color db lred ;The primary color
color2 db black ;The secondary color
DrawLength dw 1;

;----------------------------------Colors EQU----------------------------------;
;(easier to read) lred = Light Red,etc 
black EQU 0
blue EQU 1
green equ 2
cyan equ 3
red equ 4
violet equ 5
brown equ 6
lgray equ 7
dgray equ 8
lgreen equ 10
lcyan equ 11
lred equ 12
lviolet equ 13
yellow equ 14
white equ 15
;---------------------------------------------------------------------------;

;-----------------------------Drawing SHAPES data---------------------------;

;The data for drawing the LOGO shape.
;Logo1 : The word "Pocket", Logo2 : The word "Tanks", Logo1B : The backcolor of the logo (shadow like)
;logo1Xs : x offset, starting x, ending x, starting x, ending x.
;logo1Y : y offset, starting y 
;logo1LenCol : The length of the vertical line drawn between the 2 xS given above, and  color of that line
logo1Xs dw 15, 1,6, 6,15, 6,15,	15,18, 24,29, 29,38,  38,42, 29,38, 47,51, 51,61, 61,65, 61,65,	51,61, 70,74, 74,84, 84,88, 84,88, 93,97, 97,107, 97,107, 97,107, 107,111
dw 107,111,116,139, 125,130, 	0
logo1Y dw 70, 0, 0, 14, 0, 0,0,0,26, 0,0,0, 23, 27,0,14,0,18, 0, 0, 14,27,0,23, 0,0,    				0
logo1LenCol dw 31,violet, 5,violet, 4,violet, 18,violet, 31,violet, 5,violet, 31,violet, 5,violet, 31,violet, 5,violet, 9, violet, 8,violet, 4,violet, 31,violet, 4,violet
dw 13, violet,13, violet, 31,violet,5,violet, 4,violet, 4,violet,9, violet, 8,violet, 5,violet, 31,violet,		0

logo1bXs dw 13, 1,6, 6,15, 6,15,	15,18, 24,29, 29,38,  38,42, 29,38, 47,51, 51,61, 61,65, 61,65,	51,61, 70,74, 74,84, 84,88, 84,88, 93,97, 97,107, 97,107, 97,107, 107,111
dw 107,111,116,139, 125,130, 	0
logo1bY dw 70, 0, 0, 14, 0, 0,0,0,26, 0,0,0, 23, 27,0,14,0,18, 0, 0, 14,27,0,23, 0,0,    				0
logo1bLenCol dw 31,yellow, 5,yellow, 4,yellow, 18,yellow, 31,yellow, 5,yellow, 31,yellow, 5,yellow, 31,yellow, 5,yellow, 9, yellow, 8,yellow, 4,yellow, 31,yellow, 4,yellow
dw 13, yellow,13, yellow, 31,yellow,5,yellow, 4,yellow, 4,yellow,9, yellow, 8,yellow, 5,yellow, 31,yellow,		0


logo2Xs dw 15, 166,189, 175,180, 194,198, 198,208, 198,208, 208,212, 217,221, 221,231, 231,235, 240,244, 244,253, 253,258,253,258, 263,267,263,267, 267,276,267,276,267,276,276,279,276,279,	0
logo2Y dw 70, 0, 0, 0,0,14,0,0,0,0, 0,14,0,18, 0,23,0,14,27,0,14,	0
logo2LenCol dw 5,violet, 31, violet, 31,violet, 5,violet,4,violet,31,violet, 31,violet, 5,violet, 31,violet,31,violet,4,violet,13,violet,13,violet,18,violet,9,violet,5,violet,4,violet,5 ,violet,8,violet,18,violet,	0

logo2bXs dw 13, 166,189, 175,180, 194,198, 198,208, 198,208, 208,212, 217,221, 221,231, 231,235, 240,244, 244,253, 253,258,253,258, 263,267,263,267, 267,276,267,276,267,276,276,279,276,279,	0
logo2bY dw 70, 0, 0, 0,0,14,0,0,0,0, 0,14,0,18, 0,23,0,14,27,0,14,	0
logo2bLenCol dw 5,yellow, 31, yellow, 31,yellow, 5,yellow,4,yellow,31,yellow, 31,yellow, 5,yellow, 31,yellow,31,yellow,4,yellow,13,yellow,13,yellow,18,yellow,9,yellow,5,yellow,4,yellow,5 ,yellow,8,yellow,18,yellow,	0


;The offset that will be used to draw the shape in X, Y
offsetX dw 4
offsetY dw 4




;----------------------------------Messages data part----------------------------------
valid db 1      ;Boolean to check if input was valid or not
welcomeMsg db  'Please press any key ! $'
inputMsg db 10,13,10,13,'Please enter your name : ',10,13,'$' 
inputErrMsg db 10,13,10,13,'Error! ',10,13, 'Please enter a name WITHOUT special',10,13,'characters in it!  ',10,13,'Please enter again: ', 10,13,'$'        
inputBfr db  16, ?, 16 dup('$') 
notifBar db 1 dup('-'),'$'
op1 db 'Play','$'
op2 db 'Chat','$'
op3 db 'EXIT','$'


lv1 db 'Level 1','$'
lv2 db 'Level 2','$'
lv3 db 'Level 3','$'

opchosen dw 1
exchgNames db 'You are playing/chatting with $'
;Notifications messages
sentGInv db 'You sent a game invite to $'
sentCHInv db 'You sent a chat invite to $'
recGInv db ' sent you a game invite, press enter to accept, esc to reject$'
recCHInv db ' sent you a chat invite, press enter to accept, esc to reject$'
waitOtherPlayerMsg db 'Waiting for the other player...$'
;-------------------THE SERIAL COMM -----------------------;
;Player names
user1 db 16 dup('$')
user2 db 16 dup('$')
;Boolean to indicate if player in game or not
P2Entered db 0
player2rde db 0
name1done db 0
name2done db 0
;Inviting stuff
invite db 0 ;0->no invite, 255->exit, 254->chat invite, 253->game invite
inviteResp db 255 ;13->acc, 27->rej
.stack 64

.code

;-----------------------------------------;
;A procedure that draws a shape using it's array.
;IN :  DI -> address of starting + ending x point, SI->address of starting y point, bp->address of length of vertical line and its color 
; cx x1 , ax x2 , pushed l1,c1 , bx l2,c2
;-------------------------------------------;
Draw 	proc
push ax
push bx
push cx
push dx
mov ax, [DI]
mov offsetX, ax
mov ax, [si]
mov offsetY, ax
add di,2
add si,2
mov cx,0
mov dx,0
mov bx,0
mov ax,0

DrawLoop:
mov cx,[di]
cmp cx,0
JE doneDraw
add cx, offsetx
add di,2
mov ax,[di]
add ax, offsetX
mov dx, [si]
add dx, offsetY
mov bx, DS:[bp]
add bp,2
mov DrawLength,Bx
mov bx, DS:[bp]
mov color, bl



xLoop:
call DrawVLine
add cx,1
cmp cx,ax
JNE xLoop


add si,2
add di,2
add bp,2
jmp DrawLoop
doneDraw:
;mov ax,stcktmp
;mov ss,ax
pop dx
pop cx
pop bx
pop ax

ret
Draw endp
     
;------------------------------------;
;A procedure that draws a vertical line.
; CX : Starting x position, DX : Starting Y position, BX : Length, color is the global variable
;------------------------------------;
DrawVLine	proc
	push cx
	push bx
	push dx
	push ax
	mov al,color
	mov bx,DrawLength
	add bx, dx ; DX = end y position
	l2:
	mov ah,0ch
	int 10h
	inc dx
	cmp dx,bx
	JBE l2
	pop ax
	pop dx
	pop bx
	pop cx
	ret
DrawVLine endp

;------------------------------------------;
;A procedure to print a string in color in color palette
;in : SI, string offset
;-------------------------------------------;
PrintColored	proc
push ax
push bx
push cx
push dx
mov bh,0
mov bl, color
mov cx,1
mov ah,09
PrintLoop:
mov al, [si]
cmp al,'$'
JE outt
int 10h
call MovCurs
inc si

JMP PrintLoop

Outt:
pop dx
pop cx
pop bx
pop ax
ret
PrintColored	endp



;---------------------------------------;
;A procedure to move cursor one time right;
;----------------------------------------;
MovCurs 	proc
push ax
push bx
push cx
push dx
mov ah,03h
mov bh,0
int 10h
inc dl
	cmp dl,40
	jb endinc1
	mov dl,0
	add dh,2
	endinc1:
	mov ah,2
	mov bh,0
	int 10h
pop dx
pop cx
pop bx
pop ax
ret
MovCurs		endp                  
  

;---------------------------------------;
;A procedure to draw the logo
;----------------------------------------;
DrawLogo Proc
lea di, logo1bxs
lea si, logo1by
lea bp, logo1blencol
call Draw    
lea di, logo2bxs
lea si, logo2by
lea bp, logo2blencol
call Draw    
lea di, logo1xs
lea si, logo1y
lea bp, logo1lencol
call Draw    
lea di, logo2xs
lea si, logo2y
lea bp, logo2lencol
call Draw    
ret
DrawLogo endp

;---------------------------------; 
;A procedure to check if input is valid (no letters for an example are entered)
;---------------------------------;
CheckInput proc    
    push si
    lea si, inputBfr ;The offset of the input     
    inc si  
    mov cl, [si]    ;Put in cx the length of the input  
    and ch,0     
    inc si ;Move to the first number in the input string   
        mov al, [si] 
	;validation for the first letter
            cmp al,'A'            
            jge ck1
            jmp notValid
            ck1:
            cmp al,'Z'
            jle vld
            jmp vld1
            vld1:
            cmp al,'a'
            jge ck2
            jmp notValid
            ck2:
            cmp al,'z'
            jle vld
            jmp notValid
            vld:
    mov valid,1  
    JMP exitCheck
    notValid: 
    mov valid,0
    exitCheck:
    pop si
    ret    
CheckInput endp
  
;----------------------------------THIS PROCEDURE DISPLAYS THE MENU------------------------;
DisplayMenu	proc

;Move cursor
mov ah,2
mov dl, 18
mov dh, 5
int 10h

mov cx, opchosen
cmp cx,1
JNE cm2
cm1:
lea si, op1
mov color, red
call PrintColored
mov color, white
lea si,op2
;Move cursor
mov ah,2
mov dl, 18
mov dh, 10
int 10h
call PrintColored
lea si, op3
;Move cursor
mov ah,2
mov dl, 18
mov dh, 15
int 10h
call PrintColored
jmp exit
cm2:
cmp cx,2
JNE cm3
lea si, op1
mov color, white
;Move cursor
mov ah,2
mov dl, 18
mov dh, 5
int 10h
call PrintColored
mov color, red
lea si,op2
;Move cursor
mov ah,2
mov dl, 18
mov dh, 10
int 10h
call PrintColored
mov color,white
lea si, op3
;Move cursor
mov ah,2
mov dl, 18
mov dh, 15
int 10h
call PrintColored
jmp exit
cm3:
lea si, op1
mov color, white
;Move cursor
mov ah,2
mov dl, 18
mov dh, 5
int 10h
call PrintColored
lea si,op2
;Move cursor
mov ah,2
mov dl, 18
mov dh, 10
int 10h
call PrintColored
lea si, op3
mov color, red
;Move cursor
mov ah,2
mov dl, 18
mov dh, 15
int 10h	
call PrintColored

exit:
call DrawNotifBar
ret

DisplayMenu endp

;----------------------------------THIS PROCEDURE DISPLAYS THE LEVELS MENU------------------------;
DisplayLvs	proc

;Move cursor
mov ah,2
mov dl, 18
mov dh, 5
int 10h

mov cx, opchosen
cmp cx,1
JNE cmm2
cmm1:
lea si, lv1
mov color, red
call PrintColored
mov color, white
lea si,lv2
;Move cursor
mov ah,2
mov dl, 18
mov dh, 10
int 10h
call PrintColored
lea si, lv3
;Move cursor
mov ah,2
mov dl, 18
mov dh, 15
int 10h
call PrintColored
jmp exit
cmm2:
cmp cx,2
JNE cmm3
lea si, lv1
mov color, white
;Move cursor
mov ah,2
mov dl, 18
mov dh, 5
int 10h
call PrintColored
mov color, red
lea si,lv2
;Move cursor
mov ah,2
mov dl, 18
mov dh, 10
int 10h
call PrintColored
mov color,white
lea si, lv3
;Move cursor
mov ah,2
mov dl, 18
mov dh, 15
int 10h
call PrintColored
jmp exit2
cmm3:
lea si,lv1
mov color, white
;Move cursor
mov ah,2
mov dl, 18
mov dh, 5
int 10h
call PrintColored
lea si,lv2
;Move cursor
mov ah,2
mov dl, 18
mov dh, 10
int 10h
call PrintColored
lea si, lv3
mov color, red
;Move cursor
mov ah,2
mov dl, 18
mov dh, 15
int 10h	
call PrintColored


exit2:
call DrawNotifBar
ret

DisplayLvs endp
 
 

;=======================================================================;
;----------------------SERIAL COMM PROCEDURES---------------------------;
;=======================================================================;

;------------A procedure to draw the notification bar-----------------;
DrawNotifBar proc
	;Move cursor
	mov cx,0 ;Column
	mov dx,160 ;Row
	mov al,blue ;Pixel color
	mov ah,0ch ;Draw Pixel Command
	back: int 10h
	inc cx
 	cmp cx,320
	jnz back 
	ret
DrawNotifBar endp

;----------------------The procedure that moves the name of player 1 to the chatting module-----------------------;
MoveName1	proc

	push bx
	push si
	push ax
	lea bx, inputBfr
	lea si, user1
	add bx,2

	cpyName1:
	mov al,[bx]
	mov [si],al
	inc bx
	inc si
	cmp byte ptr [bx],13 ;If new line aka end of string.
	jne notNewL
	mov byte ptr [bx], '$' ;terminate string instead
	notNewL:
	cmp byte ptr [bx],'$'
	jne cpyName1
	mov al,'$'
	mov [si],al

  	pop ax
	pop si
	pop bx
	ret

MoveName1	endp


;-------------------THE PROCEDURE THAT SENDS A SIGNAL THAT PLAYER ENTERED HIS NAME AND IS READY-------;
SendNameSignal	proc
		mov dx , 3FDH		; Line Status Register
AGAINsignal:  	In al , dx 			;Read Line Status
  		test al , 00100000b
  		JZ AGAINsignal                               ;Not empty

;If empty put the VALUE in Transmit data register
  		mov dx , 3F8H		; Transmit data register
  		mov  al,255
  		out dx , al
ret
SendNameSignal	endp


;-------------------THE PROCEDURE THAT Receives the signal of the second player -------------------------------;
RecNameSignal proc
;Check that Data is Ready
		mov dx , 3FDH		; Line Status Register
	    	in al , dx 
  		test al , 1
		jz endchkr
;If Ready read the VALUE in Receive data register
  		mov dx , 03F8H
  		in al , dx 
		cmp al,255 ; If user sent a signal that he's ready
		jne endchkr
		mov player2rde,1
		
endchkr:
ret
RecNameSignal endp


;-------------------THE PROCEDURE THAT Receives the name of the second player and sends yours -------------------------------;
SnRNames proc

;Check if there's a letter to receive
;Check that Data is Ready
		cmp name2done,1 ;If name already received
		je norec
		mov dx , 3FDH		; Line Status Register
	    	in al , dx 
  		test al , 1
		jz norec
;If Ready read the VALUE in Receive data register
  		mov dx , 03F8H
  		in al , dx 
		cmp al,'$' ; if end of name
		jne notEndOfName2
		mov name2done,1 ;Name of other player received successfully
		notEndOfName2:
		mov [di], al
		inc di		
norec:
		
		cmp name1done,1 ;If name already sent
		je sndout
;check if there's a letter to send
		mov dx , 3FDH		; Line Status Register
AGAIN2:  	In al , dx 			;Read Line Status
  		test al , 00100000b
  		JZ AGAIN2                               ;Not empty

;If empty put the VALUE in Transmit data register
  		mov dx , 3F8H		; Transmit data register
  		mov  al,[si]
  		out dx , al
		cmp al,'$'
		jne notEndOfName1
		mov name1done,1 ;Name of first player sent successfully
		notEndOfName1:
		inc si
		sndOut:

ret
SnRNames endp

;---------------------------THE PROCEDURE THAT SHOWS THE NAME OF THE OTHER PLAYER------------------;
ExchangeNames proc
;Move cursor
mov al,13h
mov ah,0
int 10h

mov ah,2
mov dl,0
mov dh,170
int 10h
mov color,red
lea si, exchgNames
call PrintColored
mov ah,2
mov dl,0
mov dh,172
int 10h
lea si, user2
mov color, yellow
call PrintColored
mov ah,2
mov dl,0
mov dh, 174
int 10h
lea si, welcomeMsg
mov color, blue
call PrintColored
ret
ExchangeNames endp

;------------------INVITING MANAGEMENT-------------------;
;========================================================;

;Sends the invite flag to the other player. 
;IN: invite flag in ax
SendInvite  proc
		mov dx , 3FDH		; Line Status Register
AGAINsignal2:  	In al , dx 			;Read Line Status
  		test al , 00100000b
  		JZ AGAINsignal2                               ;Not empty
;If empty put the VALUE in Transmit data register
  		mov dx , 3F8H		; Transmit data register
		mov al, invite
  		out dx , al
		call sndInvMsg
ret
SendInvite  endp


;Receives the invite flag to the other player. 
;IN: invite flag in ax
RecInvite  proc
		mov dx , 3FDH		; Line Status Register
	  	In al , dx 			;Read Line Status
  		test al , 1
  		JZ noinv                               ;No invite
  		
		mov dx , 3F8H	
		in al,dx
		mov invite,al
		noinv:
ret
RecInvite  endp


;---------------------THE FUNCTION THAT SHOWS THE RECEIVED INVITE MESSAGE------------;
recInvMsg   proc
;Move cursor
mov ah,2
mov dl,0
mov dh,21
int 10h
lea si, user2
mov color, yellow
call PrintColored
cmp invite,254 ;CHatting invite
jne chkGameInv ;Check if game invite


lea si, recCHInv   
mov color,yellow
call PrintColored

chkGameInv:
cmp invite, 253
jne unknown

lea si, recGInv  
mov color,yellow
call PrintColored

unknown:
ret
recInvMsg   endp

;---------------------THE FUNCTION THAT SHOWS THE SENT INVITE MESSAGE------------;
sndInvMsg   proc
;Move cursor
mov ah,2
mov dl,0
mov dh,21
int 10h
mov color,yellow
cmp invite,254 ;CHatting invite
jne chkGameInv2 ;Check if game invite
lea si, sentCHInv   
mov color,yellow
call PrintColored
lea si, user2
mov color, yellow
call PrintColored
chkGameInv2:
cmp invite, 253
jne unknown2

lea si, sentGInv  
mov color,yellow
call PrintColored
lea si, user2
mov color, yellow
call PrintColored

unknown2:
ret
sndInvMsg   endp


;-----------------THE PROCEDURE THAT WAITS TO RECEIVE AN ACCEPTION/REJECTION for the invie-------------
waitForAcRej	proc
waitloop:
			;check if invite is cancelled (escape is pressed)
			mov ah,1
			int 16h
			jz invnotcanc
			mov ah,0
			int 16h
			cmp al,27
			jne invnotcanc
			mov invite,255
			call SendInvite
			mov inviteResp,27
			mov invite,0
			ret
			invnotcanc:
	mov dx , 3FDH		; Line Status Register
	  	In al , dx 			;Read Line Status
  		test al , 1
  		JZ waitloop                               ;No invite
  		
		mov dx , 3F8H	
		in al,dx
		mov inviteResp,al

ret
waitForAcRej	endp


;----------------THE PROCEDURE THAT SENDS THE RESPOND TO THE INVITATION----------------;
sendResp    proc
		mov dx , 3FDH		; Line Status Register
AGAINsignal3:  	In al , dx 			;Read Line Status
  		test al , 00100000b
  		JZ AGAINsignal3                               ;Not empty
;If empty put the VALUE in Transmit data register
  		mov dx , 3F8H		; Transmit data register
		mov al, inviteResp
  		out dx , al
ret
sendResp    endp


;-----------proc to clear keyboard buffer----------;
clearKBuffer	proc
	push ax
	clearbfr:
	mov ah,1
	int 16h
	jz bfrclrd
	mov ah,0
	int 16h
	jmp clearbfr
	bfrclrd:
	pop ax
ret
clearKBuffer	endp

clearScreen proc
;Clear screen
push ax
	MOV AH, 0
	MOV AL, 13h
	INT 10H
pop ax
ret
clearScreen endp
;---------------The start of our game--------------      
main proc   far
 mov ax,@data
 mov ds,ax
 ;Initialize the serial port
 call INITIALIZE
 ;Change to video mode
 mov ah,0
 mov al, 13h
 int 10h
 call DrawLogo
	
	;print msg1 	
	mov ah,2
	mov dl,0
	mov dh,170
	int 10h
	mov color, red
	lea si,welcomeMsg
	call PrintColored
	;wait to press any key           
	mov ah,0
	int 16h 
	
	;Clear screen
	MOV AH, 0
	MOV AL, 13h
	INT 10H
	
	;Read input from user
	mov ah,9
	mov dx, offset inputMsg
	int 21h ;Show message to take input   
    
	;A loop to use if the user keeps entering invalid data
	inputLoop:    
	mov ah,0ah
	mov dx, offset inputBfr    ;Reading input into inputBfr
	int 21h
	call CheckInput            ;Checking if input is valid
	cmp valid,1                ;If valid, we should jump from this loop
	JE ok 
	

	mov ah,9
	mov dx, offset inputErrMsg   ;Show error message if input isn't accepted
	int 21h    
	JMP inputLoop ;If not valid, keep asking for input                                  
    	
	ok: ;Our exit if input was valid
	;print msg1 	
	mov ah,2
	mov dl,0
	mov dh,11
	int 10h
	mov color, yellow
	lea si,waitOtherPlayerMsg
	call PrintColored
	call SendNameSignal

	waitForP2rde:
	call RecNameSignal
	cmp player2rde,1
	jne waitForP2rde



	;Move your entered name to user variable
	call MoveName1
	;Wait to receive the name of the second player and send yours
	lea di, user2
	lea si, user1
	sendNameschars:
	call SnRNames
	cmp name1done,1
	jne sendNameschars
	cmp name2done,1
	jne sendNameschars

	
	
	
	
	call clearKBuffer

	;See the other player name
	call ExchangeNames
	;wait to press any key           
	mov ah,0
	int 16h 

	;Clear screen
	MOV AH, 0
	MOV AL, 13h
	INT 10H

	menuLoop:
	call DisplayMenu	
	;Check if we received an invite/signal
	call RecInvite
	cmp invite,0
	je noInvRec
	cmp invite,255;if exit
	jne notExit
	mov ah,4ch
	int 21h
	notExit:
	call recInvMsg

	respondToInv:
	call RecInvite
	cmp invite, 255 ;If other player cancelled the invite
	jne notCancelled

	mov invite,0
	;Clear screen
	MOV AH, 0
	MOV AL, 13h
	INT 10H
	call DisplayMenu
	jmp menuLoop

	notCancelled:
	mov ah,1
	int 16h
	jz respondToInv ;if user pressed nothing
	mov ah,0
	int 16h
	mov inviteResp,al
	cmp inviteResp,27;if user rejected
	jne checkacc
	call sendResp
	mov invite,0
	mov inviteResp,0
	call clearScreen	
	jmp menuLoop
	checkacc:
	cmp inviteResp,13;If user pressed inter
	jne respondToInv	
	call sendResp
	mov inviteResp,0

    
	invAcc:
	cmp invite,254
	jne checkGameInvAcc
	call chmd
	mov invite,0
	call clearScreen	
	jmp menuLoop
	checkGameInvAcc:
	mov serialmode,0
	mov invite,0
	waitForStart:
	call RecInvite
	cmp invite,0
	je waitForStart
	call game
	mov invite,0
	call clearScreen
	jmp menuLoop
	;If no invite received
	noInvRec:
	;Checking if the user pressed a key 
  	  mov ah,1
   	 int 16h
   	 ;If no key is pressed
   	 jz menuLoop

   	 ;Read key from buffer
  	  mov ah,0
  	  int 16h
    
  	  ;If user pressed down, then increment chosen opt
  	  cmp ah,80
	  JNE c2
	  mov cx, opchosen
	  cmp cx,3 ;If we pressed one more time and we already on our last option, do nothing.
	  JE update
	  inc cx
	  mov opchosen,cx
	  c2:
	  cmp ah,72
	  JNE c3
	  mov cx,opchosen
	  cmp cx,1 ;If we pressed one more time and we are already on our first option, do nothing.
	  JE update
	  dec cx
	  mov opchosen, cx
	  c3: ;If user pressed enter, exit the menu loop
	  cmp al,13
	  JE exitmenu
	  update:
	  call DisplayMenu
	  JMP menuLoop
	 
	 

	 exitmenu:
	 ;We exit the menu, based on Option chosen (opchosen) we either go to the game, char(when done), or exit.
	 mov ax, opchosen
	 cmp ax, 1
	 JNE MenuOption2Check
	 mov invite,253
	 call SendInvite
	 call waitForAcRej
	 cmp inviteResp,27
	 jne notrej
	 mov invite,0
	 mov inviteResp,0
	 call clearScreen
 	 jmp menuLoop
	 notrej:
	 mov serialmode,1
	 mov opchosen,1
	 lvlloop:
	 call DisplayLvs
	 
	;Checking if the user pressed a key 
  	  mov ah,1
   	 int 16h
   	 ;If no key is pressed
   	 jz lvlloop

   	 ;Read key from buffer
  	  mov ah,0
  	  int 16h
    
  	  ;If user pressed down, then increment chosen opt
  	  cmp ah,80
	  JNE cc2
	  mov cx, opchosen
	  cmp cx,3 ;If we pressed one more time and we already on our last option, do nothing.
	  JE update2
	  inc cx
	  mov opchosen,cx
	  cc2:
	  cmp ah,72
	  JNE cc3
	  mov cx,opchosen
	  cmp cx,1 ;If we pressed one more time and we are already on our first option, do nothing.
	  JE update2
	  dec cx
	  mov opchosen, cx
	  cc3: ;If user pressed enter, exit the menu loop
	  cmp al,13
	  JE exitmenu2
	  update2:
	  call DisplayMenu
	  JMP lvlloop
	  exitmenu2:
	  push ax
	  mov ax,0
	  mov al,byte ptr opchosen
	 mov level, al
	 pop ax
	 mov invite,1
	 call SendInvite
	 call Game
	 mov invite,0
 	 mov inviteResp,0
	 call clearScreen
	 JMP menuLoop
	 MenuOption2Check:
	 cmp ax,2
	 JNE MenuOption3
	 mov invite,254
	 call SendInvite
	 call waitForAcRej
	 cmp inviteResp,27
	 jne notrej2
	 mov invite,0
	 mov inviteResp,0
         call clearScreen
	 jmp menuLoop
	 notrej2:
	 call chmd
	 mov invite,0
	 mov inviteResp,0
    	 call clearScreen
	 JMP menuLoop
	 MenuOption3:
	 mov invite,255
	call SendInvite
	mov ah,4ch
	int 21h
main endp
end main



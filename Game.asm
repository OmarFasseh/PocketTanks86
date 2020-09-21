EXTERN inputBfr:BYTE
EXTERN DrawString:FAR 
EXTERN DrawChar:FAR 
EXTERN user1:byte
EXTERN user2:byte
;EXTERN level:byte
PUBLIC GAME
PUBLIC DrawPixel
public level
public serialmode

.model large

.stack 64
;----------------------------------DATA SEGMENT----------------------------------;
.data
level db 3

WaitTime dw 1 ;Wait time in seconds when calling function "WaitFor"

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

;----------------------------------VARIABLES FOR HEALTH BAR----------------------------------;

hlth1 dw 100 ;player 1 health
hlth2 dw 100 ;player 2 health      
gameEnded db 0 ;flag if the game ended 1, if game ended with a winner, 0 if not ended, 2 if ended in the middle
gamePaused db 0; flag if game paused
;-----------------------------Drawing SHAPES data---------------------------;

;The data for drawing the tank shape.
;tankXs : x offset, starting x, ending x, starting x, ending x.
;tankY : y offset, starting y 
;tankLenCol : The length of the vertical line drawn between the 2 xS given above, and  color of that line
tank1Xs dw 263, 23,30, 26,27, 27,28, 28,29, 29,46, 46,48, 48,49, 49,50, 31,47, 35,41 ,30,33, 33,36, 36,39, 39,42, 42,45 ,36,40, 37,39,  0
tank1Y dw 140,4,9,8,7,7,7,7,9,4,2,13,13,13,13,13, 1,0 ,0
tank1LenCol dw 1,lgray ,2,lgreen,3,green,5,green,6,green,5,green,4,lgreen,1,lgreen,3,green,2,lgreen,1,lgreen,1,green,1,lgreen,1,green,1,lgreen, 1, green, 1, lgreen ,0
tank1speed dw 2
projectxOffset1 equ 19
projectyOffset1 equ 13
;The colliders for tank 1
tank1ColX dw 291,313 
tank1ColY dw 144,154


;Tank2
tank2Xs dw 1, 29,36,33,34,32,33,31,32,14,31,12,14,11,12,10,11,13,29,19,25,27,30,24,27,21,24,18,21,15,18, 20,24, 21,23,0
tank2Y dw 140, 4,9,8,7,7,7,7,9,4,2,13,13,13,13,13, 1, 0 ,0
tank2LenCol dw 1,lgray ,2,lviolet,3,violet,5,violet,6,violet,5,violet,4,lviolet,1,lviolet,3,violet,2,lviolet,1,lviolet,1,violet,1,Lviolet,1,violet,1,lviolet, 1, violet, 1, lviolet ,0
tank2speed dw 2
projectxOffset2 equ 36
projectyOffset2 equ 13
;The colliders for tank 2
tank2ColX dw 12,33 
tank2ColY dw 144,154

;canondata
cannonlength dw ?
cannonDx dw ?
cannonDy dw ?
tmpw dw 0
tmpy dw 0
tmpx dw 0 

activeplayer db 2

;The data for drawing the bullet.
bulletXs dw 20, 1,7, 2,6, 3,5, 3,5, 3,5 ,0 
bulletY dw 0, 2, 1, 0, 1, 2, 0
bulletLenCol dw 3,lgray, 5, brown, 7, red, 5,brown, 3,cyan, 0   
bulletSpeed dw 4 ;not used
BullColBorder dw 1,7 ,0 ,7 
tstx dw 0
BullColX dw 1,7 
tsty dw 0
BullColY dw 60,67
tstcl dw 1 ,red
bulletDamage dw 10


;The data for a cloud
cloud1Xs dw 50,  2,3, 3,17, 5,15, 7,15, 8,12, 9,12, 0
cloud1Y dw 25,  4, 4, 3, 2, 1, 0, 0
cloud1LenCol dw  4,dgray, 5,dgray, 6,dgray, 6,dgray, 7,dgray, 8,dgray, 0    
cloud2Xs dw 150,  2,3, 3,17, 5,15, 7,15, 8,12, 9,12, 0
cloud2Y dw 67,  4, 4, 3, 2, 1, 0, 0
cloud2LenCol dw  4,dgray, 5,dgray, 6,dgray, 6,dgray, 7,dgray, 8,dgray, 0    
cloud3Xs dw 270,  2,3, 3,17, 5,15, 7,15, 8,12, 9,12, 0
cloud3Y dw 50, 4, 4, 3, 2, 1, 0, 0
cloud3LenCol dw  4,dgray, 5,dgray, 6,dgray, 6,dgray, 7,dgray, 8,dgray, 0    
cloudSpeed dw 1

;The data for the stars
star1Xs dw 40, 1,4, 2,3 ,0
star1Y dw 30, 2,1,0
star1LenCol dw 1,white, 3, yellow, 0

star2Xs dw 130, 1,4, 2,3 ,0
star2Y dw 32, 2,1,0
star2LenCol dw 1,white, 3, yellow, 0

star3Xs dw 180, 1,4, 2,3 ,0
star3Y dw 25, 2,1,0
star3LenCol dw 1,white, 3, yellow, 0


star4Xs dw 250, 1,4, 2,3 ,0
star4Y dw 25, 2,1,0
star4LenCol dw 1,white, 3, yellow, 0

;The data for the trees
tree1Xs dw 60, 20,25 ,12, 33, 190,195, 182, 203,15,30,185,200, 0
tree1Y dw 94, 0, 0, 0, 0, 0, 0,0,0
tree1LenCol dw 50,0B9h, 10, green, 50, 0B9H, 10, green,10,192,10,192, 0

;The data for the fence
fence1Xs dw 115, 1,90, 0 ; 40,50, 37,53, 38,52, 37,53, 38,52, 0
fence1Y dw 90,  50, 0 ;,0,0,60, 60, 0
fence1LenCol dw 20,  red, 0 ; 60, yellow, 10,42, 10,yellow, 10,42, 10,yellow,  0
fenceColX dw 151,169 
fenceColY dw 90,150	   

;the data for the stand barrier 
barX dw 115,1,91,0 
barY dw 90,0,0
barLen dw 50,red,0
 
;for collision stand barrier

barx1 dw 116
barx2 dw 207


bary1 dw 90
bary2 dw 140


;the data for the moving barrier
MbarX dw 135,1,50,0 
MbarY dw 130,0,0
MbarLen dw 20,lred,0 
up dw 0 ;enable for moving up if 0 and down if 1


;for collision moving barrier

Mbarx1 dw 135
Mbarx2 dw 185 


Mbary1 dw 130
Mbary2 dw 150



;The value used to shift a shape in positive xDir
shiftvalx dw 1
shiftvaly dw 1
;The offset that will be used to draw the shape in X, Y
offsetX dw 4
offsetY dw 4
;-------------------------------------------------------------------------;

;-----------------------------------serial stuff-------------------------------------;
serialmode db slave
serialslaveinput db ?
serialmagic1 EQU 0AFH
serialmagic2 EQU 0FAH
serialnoinput EQU 0
serialkeyup EQU 1
serialkeydown EQU 2
serialkeyleft EQU 3
serialkeyright EQU 4
serialkeyspace EQU 5
serialkeypause EQU 6
serialkeyescape EQU 7
slave equ 0
master equ 1
;-------------------------------------------------------------------------;
;-----------------------------------chat stuff-------------------------------------;
CursX dw 160,1,6,1,3,1,6,0
CursY dw 10,1,1,6,1
CursLen dw 1,red,6,red,1,red
mycharcount db 0
mymaxcharcount db CharsPerLine
mymsg db 40 dup(0)
othermsg db 40 dup(0)
p1length db ?
p2length db ?
inchat db 0
messageSent db 0
CharsPerLine EQU 40
FONTWIDTH EQU 8
FONTHEIGHT EQU 8
;----------------------------------------------------------------------------------;
;----------------------------------projectiles----------------------------------;
Sin_TBL Dw 0,174,342,500,643,766,866,940,985       ;1000sine10x         :0->80
Cos_TBL Dw 1000,985,940,866,766,643,500,342,174        ;1000cos10x          :0->80
Tan_TBL Dw 0,176,364,577,839,1192,1732,2747,5671    ;1000tan10x          :0->80
startX dw ? ; start X position of projectile needs initial value
startY dw ? ; start Y
projectxval dw 1
projectxDir dw 1 ;1 for postive(left to right) || 0 for negative (right to left)
projectyval dw 1
Angle1 dw 6 ;angle 1
Angle2 dw 6 ;angle 2
Angle dw 0 ; tmp angle
vo dw 50
currentsteps dw 0;
steps equ  32 ;number of steps
;----------------------------------end of projectiles ----------------------------------;

;----------------------------------Powerups----------------------------------;
PowerupType db PowerupDamage
PowerupOn db 0
PowerupTick dw 0
PowerupX1 dw PowerUpDX1
PowerupX2 dw PowerUpDX2
PowerupY1 dw PowerUpDY1
PowerupY2 dw PowerUpDY2
PowerupHealth EQU 0
PowerupDamage EQU 1
PowerupTypeMax EQU 2
PowerUpDX1 EQU 156
PowerUpDY1 EQU 20
PowerUpDX2 EQU 164
PowerUpDY2 EQU 28
PowerUpTickMax EQU 500
PUHeal EQU 10	 ;powerup heal ammout
PUDmg EQU 20	;powerup dmg ammount
;----------------------------------------------------------------------------;

;----------------------------------INPUT DATA ----------------------------------;
larrow equ 75
uarrow equ 72
darrow equ 80
rarrow equ 77
escape equ 01


;----------------------------------Messages data part----------------------------------
winningPlayerName db 15 dup(' ')
db ' Won!' , 00H
ContinueMSG db 'Press any key to continue...', 00H
HealthMSG db 'Player '
HealthMSGPname db 15 dup(' ')
db ' Health: '
healthvalue db ?, ?, ?, 00H
GameEndMsg db 'Game Over!', 00H        



;----------------------------------TEMP DATA----------------------------------;  

pl1 db 15 dup('m'),00h
pl2 db 15 dup('s'),00h
pl2len equ 25 ;length of player 2 name (MUST) and then multiply by 5


;----------------------------------SCREEN BUFFER----------------------------------;
bufferSegment SEGMENT
screenBuffer db 64000 dup(0h) ;The screen buffer, contains colors of all pixels to be drawn.
bufferSegment ENDS



;----------------------------------CODE SEGMENT----------------------------------;
.code
ResetGame	proc far
mov hlth1, 100
mov hlth2, 100
mov tank2xs,1
mov tank1xs,263
mov tank1Colx, 291
mov tank1colx+2, 313
mov tank2Colx, 12
mov tank2colx+2, 33
mov bulletXs,20
mov bulletY,0 
mov activeplayer, 2
mov currentsteps, 0
mov angle1, 3
mov angle2, 3
mov gameEnded,0
call FixName
;PUSH CX
;PUSH BX
;mov mycharcount, 0
;MOV CX, 40
;LEA BX, mymsg
mov mymaxcharcount, CharsPerLine
clrloop:
CALL RemoveLastChatChar
cmp mycharcount, 0
JNE clrloop
PUSH BX
PUSH CX
LEA BX, othermsg
MOV CX, 40
clroloop:
mov byte ptr[bx], 0
inc bx
loop clroloop
POP CX
POP BX
ret
ResetGame endp

Game proc far
    ;Moving data segment
    mov ax,@data
    mov ds,ax
    call ResetGame
    call clearscreenbuffer
    ;Changing to video mode
    mov ah,0
    mov al,13h
    int 10h 
    
    call INITIALIZESERIAL
    

    call InitChat
    ;A loop to keep drawing on the screen
    movlp:

    cmp serialmode, slave
	JNE SerialMaster
	;sync with master here
	call SerialSlaveSyncWithMasterRecvData
	jmp DrawStuff
	
SerialMaster:
	call SerialMasterRecvData
	call SerialMasterSendData
DrawStuff:	
	cmp gamePaused, 0
	JNE PausedInputCheck
    ;Drawing the background
    call DrawBG      
    
    
    cmp level,1
    je cont 
     
    cmp level,2
    jne lv3 
    call DrawStandBarrier 
    jmp cont
     
    lv3: 
    call drawmovingbarrier

    cont: 
    
    
    ;Draw Health Bar
    call PrintHBP1 
    call printHBp2
    
     
	
	call printplayer1name
    call PrintPlayer2Name
    
    call PrintChat
     
   ;call DrawmovingBarrier
	

	;POWERUPNEW
    call DoPowerups
    ;POWERUPNEW

PausedInputCheck:
    ;Check input to take action if any key is pressed.
    call CheckInput
	
	cmp gamePaused, 0
	JNE movlp
	
   ;projectile

    cmp serialmode, slave
	JE DrawBullet
	
	cmp currentsteps,0
	je notflying
	cmp currentsteps,50 ;bullet will reach ground after 32 steps any extra steps >32 will do the trick also in the collider
	jb flying
	mov currentsteps,0
	cmp activePlayer,1
	je Switch2P2
	mov activeplayer,1 ;active player was 2 now switch to 1	
	jmp notflying
	switch2p2:
	mov activeplayer,2
	jmp notflying
	flying:

	mov bx,projectxval
	mov shiftvalx,bx
	lea di, bulletxs
	call ProjectX
	lea si, bullety
	call projectY
	
	inc currentsteps
	notflying:
	call bulletcollider
DrawBullet:	
    ;Draw bullet
	lea di, bulletxs
    lea si, bullety
    lea bp, bulletlencol
    call draw


    ;Drawing 2nd tank
    lea di, tank2xs
    lea si, tank2y
    lea bp, tank2lencol
    mov al,activeplayer
    mov activeplayer,2
    call DrawPlayer
    

    ;Drawing 1st tank, and moving with its speed
    lea di, tank1xs
    lea si, tank1y
    lea bp, tank1lencol
    mov activeplayer,1
    call Drawplayer
    mov activeplayer,al

    ;Wait for the new VR to avoid stuttering/flickering/tearing
    call waitForNewVR 
   
	cmp inchat, 0
	JE NoCurs
	lea di, cursx
	lea si, cursy
	lea bp, curslen
	call draw
	NoCurs:
    ;Drawing the whole screen.
    call drawScreen


	;If the user health reaches 0, then have gameEnded (word) equal to 1
    ;Loop once again.

    ;If game ended, exit the game and show the winner
    push ax
    mov al, gameEnded
    cmp al,0
    pop ax
    JNE playerWon

    jmp movlp



    PlayerWon:
    
	
	;jmp exitGame
	;MODIFED HERE BEGIN
	;A procedure that shows the winner player and telling them to press any button to return to main menu
	PUSH AX
	PUSH BX
	PUSH CX
	PUSH DX
	PUSH DS
	
	;Clear screen
	CALL ClearScreenBuffer
	
	;check if draw or win
    mov al, gameEnded
    cmp al,2
    
	JNE ShowGameWin
ShowGameEnded:
	
	;show winning message
	;BX: string address
	LEA BX, GameEndMsg
	;cx: column, dx: row, ah= color(fg,bg)
	
	MOV CX, 70
	MOV DX, 100
	MOV AH, 00FH
	CALL DrawString
	
	JMP ShowContinueAndHealth
ShowGameWin:
	;compare healths
	MOV AX, hlth1
	
	CMP AX, hlth2
	
	JA p1won
	lea si, pl2
	JMP showWinMsg
p1won:
	
	LEA si, pl1
showWinMsg:	
	call CopyWinner
	;show winning message
	;BX: string address
	LEA BX, winningPlayerName
	;cx: column, dx: row, ah= color(fg,bg)
	
	MOV CX, 70
	MOV DX, 100
	MOV AH, 00FH
	CALL DrawString

ShowContinueAndHealth:
	LEA BX, ContinueMSG
	
	MOV CX, 50
	MOV DX, 160
	MOV AH, 0F7H
	
	CALL DrawString
	
	
	;draw p1 health
	lea si, pl1
	call CopyHealthName
	
	MOV AX, hlth1
	CALL Number2ASCII3
	
	;output: left:dl middle:bl right:dh
	MOV healthvalue, dl
	MOV healthvalue+1, bl
	MOV healthvalue+2, dh
	
	LEA BX, HealthMSGPname
	
	MOV CX, 60
	MOV DX, 130
	MOV AH, 097H
	
	CALL DrawString
	CALL DrawString
	
	
	;draw p2 health
	lea si,pl2
	call CopyHealthName
	
	MOV AX, hlth2
	CALL Number2ASCII3
	
	;output: left:dl middle:bl right:dh
	MOV healthvalue, dl
	MOV healthvalue+1, bl
	MOV healthvalue+2, dh
	
	LEA BX, HealthMSGPname
	
	MOV CX, 60
	MOV DX, 140
	MOV AH, 0C7H
	
	CALL DrawString
	CALL DrawString
	
	CALL drawScreen
	cmp serialmode, slave
	JE DontSendWhenSlaveGameEnd
	call SerialMasterSendData
	call SerialMasterSendData
	call SerialMasterSendData
DontSendWhenSlaveGameEnd:	
	;wait to press any key           
	mov ah,0
	int 16h
	POP DS
	POP DX
	POP CX
	POP BX
	POP AX
	
	jmp exitGame
	
	;MODIFED HERE END
    exitGame:
    
	;CALL ClearSerialBuffer
    ret
Game endp
ClearSerialBuffer PROC
	PUSH AX
	PUSH CX
receiveclearloop:
	CALL ReceiveSerial
	test ch, ch
	JNZ receiveclearloop
	POP CX
	POP AX
	ret
ClearSerialBuffer ENDP

;---------------------------------------------------------------------------------------------------------;
;power up timer + generator
;in: nothing
;out: nothing
;modifes: ???
;---------------------------------------------------------------------------------------------------------;
DoPowerups	PROC
	push ax
	push bx
	push cx
	push dx
	push si
	push di
	push bp
	CMP PowerupOn, 1
	JE PUDraw
	
	CMP serialmode, slave
	JE PUSkip
	
	INC PowerupTick
	
	CMP PowerupTick, PowerUpTickMax
	JBE PUSkip
	
	MOV PowerupTick, 0
	
	;enable powerup
	MOV PowerupOn, 1
	
	;random power up :
	
	MOV DX, PowerupTypeMax
	CALL GenRandNumber
	MOV PowerupType, DL
	
	PUDraw:
	CALL DrawPowerUp
	
	PUSkip:
	pop bp
	pop di
	pop si
	pop dx
	pop cx
	pop bx
	pop ax
	RET
DoPowerups	ENDP
;---------------------------------------------------------------------------------------------------------;
;power up drawer + generator
;in: nothing
;out: nothing
;modifes: ???
;---------------------------------------------------------------------------------------------------------;
DrawPowerUp	PROC
	MOV CX, PowerupX1
	MOV DX, PowerupY1
	MOV BX, PowerupX2
	MOV AX, PowerupY2
	
	MOV AL, PowerUpType
	CMP AL, PowerupHealth
	JE DoHealthPU
	CMP AL, PowerupDamage
	JE DoDamagePU
	JMP PUcont
	
	DoHealthPU:
	MOV AX, PowerupY2
	CALL DrawHealthPowerup
	jmp PostPUDraw
	
	DoDamagePU:
	MOV AX, PowerupY2
	CALL DrawDamagePowerup
	
	PostPUDraw:
	CMP level, 2
	JNE normalpucheck
	CMP AX, 90 ; for level 2
	JAE PUReset
	JMP pucontnocoll
normalpucheck:	
	CMP AX, 140
	JAE PUReset
pucontnocoll:	
	MOV PowerupX1, CX
	MOV PowerupY1, DX
	MOV PowerupX2, BX
	MOV PowerupY2, AX
	JMP PUcont
	
	PUReset:
	MOV PowerupX1 , PowerUpDX1
	MOV PowerupY1 , PowerUpDY1
	MOV PowerupX2 , PowerUpDX2
	MOV PowerupY2 , PowerUpDY2
	MOV PowerupOn , 0
	PUcont:
	RET
DrawPowerUp	ENDP
;---------------------------------------------------------------------------------------------------------;
;draws health powerup, advances it's position
;in: CX: X1, DX:Y1, BX: X2, AX: Y2
;out: CX: X1 new, DX:Y1 new, BX: X2 new, AX: Y2new
;---------------------------------------------------------------------------------------------------------;
DrawHealthPowerup PROC
	;draw anything here
	
	;draw outer rectangle:
	MOV color, lred
	MOV color2, white
	call DrawRecWBord
	
	;draw plus sign inside:
	;draw horizontal line:
	MOV color, white
	PUSH BX
	;CX : Starting x position, DX : Starting Y position, BX : Length, color is the global variable
	ADD CX, 2
	ADD DX, 4
	MOV BX, 4
	CALL DrawHLine
	POP BX
	
	SUB CX, 2
	SUB DX, 4
	
	PUSH BX
	;draw vertical line:
	; CX : Starting x position, DX : Starting Y position, BX : Length, color is the global variable
	ADD CX, 4
	ADD DX, 2
	MOV DrawLength, 4
	
	CALL DrawVLine
	POP BX
	SUB CX, 4
	SUB DX, 2
	
	ADD DX, 2
	ADD AX, 2
	
	RET
DrawHealthPowerup ENDP
;---------------------------------------------------------------------------------------------------------;
;draws health powerup, advances it's position
;in: CX: X1, DX:Y1, BX: X2, AX: Y2
;out: CX: X1 new, DX:Y1 new, BX: X2 new, AX: Y2new
;---------------------------------------------------------------------------------------------------------;
DrawDamagePowerup PROC
	;draw anything here
	
	;draw outer rectangle:
	MOV color, blue
	MOV color2, cyan
	call DrawRecWBord
	
	;draw plus sign inside:
	;draw horizontal line:
	MOV color, white
	
	PUSH AX
	MOV AL, white
	
	
	ADD CX, 4
	ADD DX, 2
	CALL DrawPixel
	
	SUB CX, 1
	ADD DX, 1
	CALL DrawPixel
	
	ADD CX, 2
	CALL DrawPixel
	
	ADD DX, 1
	ADD CX, 1
	CALL DrawPixel
	
	SUB CX, 4
	CALL DrawPixel
	
	ADD CX, 1
	ADD DX, 1
	CALL DrawPixel
	
	ADD CX, 2
	CALL DrawPixel
	
	ADD DX, 1
	SUB CX, 1
	CALL DrawPixel
	
	SUB CX, 4
	SUB DX, 6
	
	
	POP AX
	
	ADD DX, 2
	ADD AX, 2
	
	RET
DrawDamagePowerup ENDP
;---------------------------------------------------------------------------------------------------------;
;generates random number between 0 and cx - 1
;in: dx : range
;out: dx : number
;modifies: dx
;---------------------------------------------------------------------------------------------------------;
GenRandNumber	PROC
	PUSH AX
	PUSH BX
	PUSH CX
	MOV BX, DX
	MOV AH, 00h  ; interrupts to get system time        
	INT 1AH      ; CX:DX now hold number of clock ticks since midnight      

	MOV AX, DX
	XOR DX, DX
	MOV CX, BX	
	DIV  CX       ; here dx contains the remainder of the division - from 0 to dx-1
	
	POP CX
	POP BX
	POP AX
	RET
GenRandNumber	ENDP


;----------------------------------THE PROCEDURE THAT HANDLES COLLIDERS----------------------------------;
;In : Nothing.
;Out: Nothing
;Function : Handles bullet colliders
;---------------------------------------------------------------------------------------------------------;
	
BulletCollider proc
    push ax
    push bx
	push cx
	push dx
	push di
	push si
;================border calculations=========================

	lea di, BullColX	;values to change after adding offset
    lea si, bullColBorder ;border values
    mov ax,bulletXs ;x offset
	mov bx,bulletY	;y offset
	;x borders 
	mov cx,[si]
	add cx,ax
	mov [di],cx
	add si,2
	add di,2
	mov cx,[si]	
	add cx,ax
	mov [di],cx

	add si,2
	;yborders
	lea di, BullColY
	mov cx,[si]
	add cx,bx
	mov[di],cx
	add si,2
	add di,2
	mov cx,[si]	
	add cx,bx
	mov [di],cx
	mov cx,bullcoly+2
	sub cx,bullcoly
	mov tstcl,cx

;================collision detection=========================

	mov ax,bullcolx
	mov bx,bullcolx+2
	mov cx,bullcoly
	mov dx,bullcoly+2
	cmp cx,400
	ja goingUp
	cmp cx,150
	ja outsideScreen
	goingUp:
	cmp ax,10
	jbe outsideScreen
	cmp bx,310
	jbe insideScreen
	cmp ax,310
	jbe insideScreen
	outsideScreen:
	mov currentsteps,50
	cmp activePlayer,1
	jne	p2miss
	mov bulletXs,20;reset position
	jmp p1miss
	p2miss:
	mov bulletXs,300;reset position
	p1miss:
	mov bulletY,00
	insideScreen:

	cmp level,1
	je lvl1 ;no barrier or powerups
	cmp level,2
	je lvl2 ; steady barrier 
;moving   barrier collision
	cmp bx,Mbarx1
	jb Mnotbarr
	cmp ax,mbarx2
	ja Mnotbarr
	cmp cx,mbary2
	ja Mnotbarr
	cmp dx,mbary1
	jb Mnotbarr
	;hit the barrier
	mov currentsteps,50
	cmp activePlayer,1
	jne	Mp2missb
	mov bulletXs,20;reset position
	jmp Mp1missb
	Mp2missb:
	mov bulletXs,300;reset position
	Mp1missb:
	mov bulletY,00
	Mnotbarr:
	jmp chkpu ;check powerups 
lvl2:
;steady   barrier collision
	cmp bx,barx1
	jb notbarr
	cmp ax,barx2
	ja notbarr
	cmp cx,bary2
	ja notbarr
	cmp dx,bary1
	jb notbarr
	;hit the barrier
	mov currentsteps,50
	cmp activePlayer,1
	jne	p2missb
	mov bulletXs,20;reset position
	jmp p1missb
	p2missb:
	mov bulletXs,300;reset position
	p1missb:
	mov bulletY,00
	notbarr:
	
chkpu:
;	Powerups Collision
	cmp PowerupOn,0
	je notpow
	cmp bx,PowerupX1
	jb notpow
	cmp ax,PowerupX2
	ja notpow
	cmp cx,PowerupY2
	ja notpow
	cmp dx,PowerupY1
	jb notpow
	;hit the powerup
	MOV PowerupX1 , PowerUpDX1
	MOV PowerupY1 , PowerUpDY1
	MOV PowerupX2 , PowerUpDX2
	MOV PowerupY2 , PowerUpDY2
	MOV PowerupOn , 0
	cmp powerupType,PowerupHealth
	jne notHealth


;   hlth powerup
	cmp activePlayer,1
	jne	p2Powerup1
;	player one health powerup
	push ax
	mov ax,hlth2
	add ax,PUHeal
	cmp ax, 100
	pop ax
	jb contP1HP
	mov hlth2,100
	jmp notPow
	contP1HP:
	add hlth2,PUHeal
	jmp notPow
p2Powerup1: ;player two health powerup
	push ax
	mov ax,hlth1
	add ax,PUHeal
	cmp ax, 100
	pop ax
	jb contP2HP
	mov hlth1,100
	jmp notPow
	contP2HP:
	add hlth1,PUHeal
	jmp notPow


	notHealth:
	cmp powerupType,PowerupDamage
	jne notDamage
;   dmg powerup
	cmp activePlayer,1
	jne	p2Powerup2
; player one dmg powerup
	cmp hlth1, PUDmg
	ja ContP1Dmg
	mov gameEnded, 1
	mov hlth1,0
	jmp endColliders
contP1Dmg:
	sub hlth1,PUDmg
	jmp notPow
p2Powerup2:; player two dmg powerup
	cmp hlth2, PUDmg
	ja ContP2Dmg
	mov gameEnded, 1
	mov hlth2,0
	jmp endColliders
ContP2Dmg:
	sub hlth2,PUDmg
	jmp notPow
	notDamage:

	notpow:
	lvl1:
;	tanks collision 
	cmp activePlayer,1
	jne	p2collider
	
	;player 1 active check tank 2 collision
	cmp ax,tank2ColX+2
	ja endTankCollider
	cmp bx,tank2ColX
	jb endTankCollider
	cmp cx,tank2Coly
	jb endTankCollider
	mov currentsteps,50
	mov bulletXs,20;reset position
	mov bulletY,0
	push ax
	mov ax, bulletDamage
	cmp hlth1, ax
	pop ax
	jbe shouldEndP1

damagep1:
	push ax
	mov ax, bulletDamage
	sub hlth1,ax
	pop ax
	jmp endTankCollider
shouldEndP1:
	mov gameEnded, 1
	jmp damagep1
	jmp endTankCollider
	p2collider:
	;player 2 active check tank 1 collision
	cmp ax,tank1ColX+2
	ja endTankCollider
	cmp bx,tank1ColX
	jb endTankCollider
	cmp cx,tank1Coly
	jb endTankCollider
	mov currentsteps,50
	mov bulletXs,300;reset position
	mov bulletY,00
	push ax
	mov ax,bulletDamage
	cmp hlth2, ax
	pop ax
	jbe shouldEndP2

damagep2:
	push ax
	mov ax, bulletDamage
	sub hlth2,ax
	pop ax
	jmp endTankCollider
shouldEndP2:
	mov gameEnded, 1
	jmp damagep2
	
	endTankCollider:
	endColliders:
	pop si
	pop di
	pop dx
	pop cx
    pop bx
    pop ax

    ret
BulletCollider endp

;----------------------------------THE PROCEDURE THAT MOVES THE PLAYERS----------------------------------;
;In : Nothing.
;Out: Nothing
;Function : Takes action based on player input.
;---------------------------------------------------------------------------------------------------------;
CheckInput	proc	
 
	push dx
	push bx
	push cx
	;check serial
	cmp serialmode,slave
    je SerialRecvNo
	
    ;call receiveserial
    ;cmp ch,1
	cmp serialslaveinput, serialnoinput
	
	JNE SerialRecvYes
	JMP SerialRecvNo
SerialRecvYes:
	;mov bx, ax
	;mov ah, 0
	mov al, serialslaveinput
	cmp al, serialnoinput
	JE SerialRecvNo
	mov ah, slave
    call ParseInput
	;mov ax, bx
SerialRecvNo:
    ;Checking if the user pressed a key 
    mov ah,1
    int 16h
    ;If no key is pressed
    jz end2

    ;Read key from buffer
    mov ah,0
    int 16h
    
	cmp al, 9 ;tab button
	JNE NoTab
	;tab was pressed
	CALL ToggleChat
	JMP end2
NoTab:
    ;call ParseInput
	;jmp end2
	cmp inchat, 0
	JE NoChat
	CALL ParseChatInput
	JMP end2
NoChat:	
    ;map all input to al
	call MapInput
	
	cmp serialmode,slave
    je slav
	
	;ah will be flag (master vs slave)
	mov ah, master
    call ParseInput
	
	jmp end2
slav:
    ;if slave, just send our key
    mov bl, al
    call SendSerial
	
end2:
    pop cx
    pop bx
    pop dx
    ret
CheckInput endp

;al: mapped key
;ah: slave/master
ParseInput proc

	cmp ah, slave
	JE slaveinput
	
	;master input
	CALL ParseMasterInput
	jmp parseend
slaveinput:
	CALL ParseSlaveInput
parseend:
	RET
ParseInput endp

;in: al:ascii, ah:scan code
;out: al: mapped key
MapInput PROC

	;first check if scancode:
	TEST AL, AL
	JZ ScanCode
	
	;ascii here
	cmp al, 'p'
	JE pauseBtn
	cmp al, 'P'
	JE pauseBtn
	
	cmp al, ' '
	je spaceBar
	
	cmp al, 27;escape btn
	je escapeBtn
	
	;not pause or space
	;set it to serialnoinput
	mov al, serialnoinput
	jmp Finished
	
pauseBtn:
	mov al, serialkeypause
	jmp Finished
spaceBar:
	mov al, serialkeyspace
	jmp Finished
escapeBtn:
	mov al, serialkeyescape
	jmp Finished
	
ScanCode:
	cmp ah, uarrow
	je upArrow
	cmp ah, darrow
	je downArrow
	cmp ah, larrow
	je leftArrow
	cmp ah, rarrow
	je rightArrow
	
	
	mov al, serialnoinput
	JMP Finished
	
upArrow:
	mov al, serialkeyup
	JMP Finished
downArrow:
	mov al, serialkeydown
	JMP Finished
leftArrow:
	mov al, serialkeyleft
	JMP Finished
rightArrow:
	mov al, serialkeyright
	JMP Finished
Finished:
	RET
MapInput ENDP

;user pressed tab
ToggleChat PROC
	NOT inchat
	
	cmp messageSent, 0
	JE EndToggle
	mov messageSent, 0
clearmsgloop:
	CALL RemoveLastChatChar
	cmp mycharcount, 0
	JNE clearmsgloop
EndToggle:
	RET
ToggleChat ENDP

;parse given chat input
;in: al: ascii, ah:scancode
ParseChatInput PROC
	;check if valid chat char:
	cmp al, ' '
	JB CheckEnter
	cmp al, '~'
	JA CheckEnter
	
	;al is a valid chat ascii here
	CALL AddChatChar
	JMP ChatParsed
	
CheckEnter:
	cmp al, 13;enter - cr
	JNE CheckBackSpace
	CALL ChatInputFinished
	JMP ChatParsed
	
CheckBackSpace:
	cmp al, 8
	JNE ChatParsed
	CALL RemoveLastChatChar
	
ChatParsed:
	RET
ParseChatInput ENDP

;in: al: ascii
AddChatChar PROC
	PUSH BX
	;end of line:
	MOV BL, mycharcount
	cmp BL, mymaxcharcount
	JAE MaxChatReached
	
	LEA BX, mymsg
	
	PUSH AX
	MOV AL, mycharcount
	CBW
	
	ADD BX, AX
	POP AX
	
	MOV [BX], al
	
	INC mycharcount
	
MaxChatReached:
	POP BX
	RET
AddChatChar ENDP

;in: nothing
RemoveLastChatChar PROC
	PUSH BX
	cmp mycharcount, 0
	JBE MinChatReached
	
	LEA BX, mymsg
	
	PUSH AX
	MOV AL, mycharcount
	SUB AL, 1
	CBW
	
	ADD BX, AX
	POP AX
	
	MOV byte ptr [BX], 0; terminator
	
	DEC mycharcount
	
MinChatReached:
	POP BX
	RET
RemoveLastChatChar ENDP

;in: nothing
ChatInputFinished PROC
	PUSH BX
	PUSH SI
	;message was sent in serial
	MOV messageSent, 1
	;get out of chat
	MOV inchat, 0
	
	cmp serialmode, master
	JE DontSendNow
	
	mov bl, serialmagic1
	call sendserial
	
	LEA SI, mymsg
sendchatloop:
	MOV BL, [SI]
	CALL SendSerial
	INC SI
	TEST BL, BL
	JNZ sendchatloop
DontSendNow:
	POP SI
	POP BX
	RET
ChatInputFinished ENDP

;al: mapped key
ParseSlaveInput PROC
	cmp al, serialkeyup
	JE p1up
	cmp al, serialkeydown
	je p1down
	cmp al, serialkeyleft
	je p1left
	cmp al, serialkeyright
	je p1right
	cmp al, serialkeyspace
	je p1shoot
	cmp al, serialkeyescape
	je p1exit
	cmp al, serialkeypause
	je p1pause
	jmp endslin
	
p1up:
	mov dx, angle1
    cmp dx, 8
    JE endslin
    inc dx
    mov angle1, dx
	jmp endslin
p1down:
    mov dx, angle1
    cmp dx, 2
    JE endslin
    dec dx
    mov angle1, dx 
	jmp endslin
p1left:
	call MovP1Left
	jmp endslin
p1right:
	call MovP1Right
	jmp endslin
p1shoot:
	cmp currentsteps,1
	jae endslin ;if it's already flying don't shoot
	cmp activePlayer, 1 ; not our turn
	JNE endslin
    call shoot
    jmp endslin
p1exit:
	mov gameended,2
	jmp endslin
p1pause:
	NOT gamePaused
	jmp endslin
endslin:
	RET
ParseSlaveInput ENDP

ParseMasterInput PROC
	cmp al, serialkeyup
	JE p2up
	cmp al, serialkeydown
	je p2down
	cmp al, serialkeyleft
	je p2left
	cmp al, serialkeyright
	je p2right
	cmp al, serialkeyspace
	je p2shoot
	cmp al, serialkeyescape
	je p2exit
	
	cmp al, serialkeypause
	je p2pause
	jmp endmsin
	
p2up:
	mov dx, angle2
    cmp dx, 8
    JE endmsin
    inc dx
    mov angle2, dx
	jmp endmsin
p2down:
    mov dx, angle2
    cmp dx, 2
    JE endmsin
    dec dx
    mov angle2, dx 
	jmp endmsin
p2left:
	call MovP2Left
	jmp endmsin
p2right:
	call MovP2Right
	jmp endmsin
p2shoot:
	cmp currentsteps,1
	jae endmsin ;if it's already flying don't shoot
	cmp activePlayer, 2 ; not our turn
	JNE endmsin
    call shoot
    jmp endmsin
    
p2exit:
	mov gameended,2
	jmp endmsin
p2pause:
	NOT gamePaused
	jmp endslin
endmsin:
	RET
ParseMasterInput ENDP
;------------------------------------------THE PROCEDURE THAT SHOOTS--------------------------------------;
;In : Activeplayer.
;Out: Nothing
;Function : shoot
;---------------------------------------------------------------------------------------------------------;
Shoot	proc
	push ax
	push bx
	push dx
	;push cx
    lea di, bulletXs
    lea si, bulletY
    lea bp, bulletLenCol
	cmp activePlayer,2
	je P2Shoot0
;	player 1 active (shoots right to left)
	mov projectxDir,0
	mov ax,tank1Xs
 	add ax,projectxOffset1
	mov bx,tank1Y
	sub bx,projectyOffset1
	mov [di],ax
	mov [si],bx
	mov ax,angle1
	mov angle,ax
	jmp Shootlbl0
	p2Shoot0:
;	player 2 active (shoots left to right)
	mov projectxDir,1
	mov ax,tank2Xs
 	add ax,projectxOffset2
	mov bx,tank2Y
	sub bx,projectyOffset2
	mov [di],ax
	mov [si],bx
	mov ax,angle2
	mov angle,ax
	shootlbl0:

	
	call deltaX
	call deltaY
	mov ax,[di]
	mov startx,ax
	mov ax,[si]
	mov starty,ax
	inc currentsteps
	;mov cx,steps
;	lip:
;	lea di, bulletxs
 ;   lea si, bullety
  ;  lea bp, bulletlencol
   ; call draw

;	mov bx,projectxval
;	mov shiftvalx,bx
;	lea di, bulletxs
;	call ProjectX
;	lea si, bullety
;	call projectY
;	call drawScreen
;	loop lip
	;mov currentsteps,1
;pop cx
	pop dx
	pop bx
	pop ax
    ret
shoot endp

;----------------------------------THE PROCEDURE THAT Adjusts the collider of player 2----------------------------------;
;In : BX : value to add for the collider x axis
;Out: Nothing
;Function : Moves the collider of player 2
;---------------------------------------------------------------------------------------------------------;
AdjustColliderP2R	proc
mov ax, tank2ColX
add ax, bx
mov tank2colx, ax

mov ax,tank2colx+2
add ax,bx
mov tank2colx+2, ax
ret
AdjustColliderP2R endp

AdjustColliderP2L	proc
mov ax, tank2ColX
sub ax, bx
mov tank2colx, ax

mov ax,tank2colx+2
sub ax,bx
mov tank2colx+2, ax
ret
AdjustColliderP2L endp

;----------------------------------THE PROCEDURE THAT Adjusts the collider of player 1----------------------------------;
;In : BX : value to add for the collider x axis
;Out: Nothing
;Function : Moves the collider of player 1
;---------------------------------------------------------------------------------------------------------;
AdjustColliderP1R	proc
mov ax, tank1ColX
add ax, bx
mov tank1colx, ax

mov ax,tank1colx+2
add ax,bx
mov tank1colx+2, ax
ret
AdjustColliderP1R endp

AdjustColliderP1L	proc
mov ax, tank1ColX
sub ax, bx
mov tank1colx, ax

mov ax,tank1colx+2
sub ax,bx
mov tank1colx+2, ax
ret
AdjustColliderP1L endp

;----------------------------------THE PROCEDURE THAT MOVES THE PLAYER 2----------------------------------;
;In : Nothing.
;Out: Nothing
;Function : Moves the player2
;---------------------------------------------------------------------------------------------------------;
MovP2Right    proc
    push ax
    push bx
    mov ax, tank2xs; Get old offset and push it
    push ax
    mov bx,projectxdir
    mov projectxDir,1
    lea di, tank2xs
    lea si, tank2y
    lea bp, tank2lencol
    mov ax, tank2speed
    mov shiftvalx, ax
    call projectx
    pop ax
    cmp tank2xs,80
    JC validPos1T2
    mov tank2xs,ax
    validPos1T2:
    mov projectxdir,bx
    mov bx, tank2xs
    sub bx, ax
    call AdjustColliderP2R
    pop bx
    pop ax
    ret
MovP2Right endp


MovP2Left    proc
    push ax
    push bx
    mov ax, tank2xs ;Get old offset and push it
    push ax
    mov bx,projectxdir
    mov projectxDir,0
    lea di, tank2xs
    lea si, tank2y
    lea bp, tank2lencol
    mov ax, tank2speed
    mov shiftvalx, ax
    call projectx
    pop ax
    cmp tank2xs,ax
    JNC notvalid2
    cmp tank2xs,0
    JNC validPos2T2
    notvalid2:
    mov tank2xs, ax
    validPos2T2:
    mov projectxdir,bx
    mov bx, tank2xs
    sub ax,bx
    mov bx,ax
    call AdjustColliderP2L
    pop bx
    pop ax
    ret
MovP2Left endp


;----------------------------------THE PROCEDURE THAT MOVES THE PLAYER 1----------------------------------;
;In : Nothing.
;Out: Nothing
;Function : Moves the player1
;---------------------------------------------------------------------------------------------------------;
MovP1Right    proc
    push ax
    push bx
    mov ax, tank1xs ;Get old offset and push it
    push ax
    mov bx,projectxDir
    mov projectxDir,1
    lea di, tank1xs
    lea si, tank1y
    lea bp, tank1lencol
    mov ax, tank1speed

    mov shiftvalx, ax
    call projectx
    pop ax
    cmp tank1xs, 264	
    JC validPos1T1
    mov tank1xs, ax
    validPos1T1:
    mov projectxDir,bx
    mov bx, tank1xs
    sub bx, ax
    call AdjustColliderP1R
    pop bx
    pop ax
    ret
MovP1Right endp

MovP1Left    proc
    push ax
    push bx
    mov ax, tank1xs ;Get old offset and push it
    push ax
    mov bx,projectxDir
    mov projectxDir,0
    lea di, tank1xs
    lea si, tank1y
    lea bp, tank1lencol
    mov ax, tank1speed
    mov shiftvalx, ax
    call projectx
    pop ax
    cmp tank1xs, 180
    JNC validPos2T1
    mov tank1xs,ax
    validPos2T1:
    mov projectxDir,bx
    mov bx, tank1xs
    sub ax,bx
    mov bx,ax
    call AdjustColliderP1L
    pop bx
    pop ax
    ret
MovP1Left endp


ClearScreenBuffer PROC
push di
push es
push cx
push bx
push ax
push si
push ds
	mov cx,7D00H ;The whole screen 320*200=64000=0FA00h/2= 7D00H
	mov bx, bufferSegment ;The vram
	mov es, bx
	mov di,0
	MOV AX, 0
	rep stosw
pop ds
pop si
pop ax
pop bx
pop cx
pop es
pop di
	RET
ClearScreenBuffer ENDP

;----------------------------------THE PROCEDURE THAT DRAWS THE SCREEN----------------------------------;
;In : Nothing.
;Out: Nothing
;Function : Draws the screen.
;---------------------------------------------------------------------------------------------------------;
drawScreen proc
push di
push es
push cx
push bx
push ax
push si
push ds
mov cx, bufferSegment
mov ds, cx
mov cx,7D00H ;The whole screen 320*200=64000=0FA00h/2 = 7D00H
mov di,0
mov bx, 0a000h ;The vram
mov es, bx
lea si, screenBuffer
rep movsw
pop ds
pop si
pop ax
pop bx
pop cx
pop es
pop di
ret
drawScreen endp

;---------------------WAIT FOR VSYNC-----------------------------------;
waitForNewVR PROC
 mov dx, 3dah

 ;Wait for bit 3 to be zero (not in VR).
 ;We want to detect a 0->1 transition.
_waitForEnd:
 in al, dx
 test al, 08h
jnz _waitForEnd

 ;Wait for bit 3 to be one (in VR)
_waitForNew:
 in al, dx
 test al, 08h
jz _waitForNew

ret
waitForNewVR ENDP



;--------------------THE PROCEDURE THAT DRAWS A PIXEL------------------------;
;In : same as the drawing interrupt, al = colour, cx = x, dx = y;
;-----------------------------------------------------------------------------;
DrawPixel proc
push ax
push bx
push cx
push dx
push si

lea si, ScreenBuffer
push ax

mov ax,dx
mov dx,320
mul dx

add ax,cx
add si, ax
pop ax
push es
mov cx, bufferSegment
mov es, cx
mov es:[si], al
pop es
pop si
pop dx
pop cx
pop bx
pop ax
ret
DrawPixel endp

;-------------------------------------------------;
;Procedures that calculate the change in position 
;IN : angle
;-------------------------------------------------;
deltaX proc
	push ax
	push bx
	push dx
	;xmax=vo^2*sin2alpha / g
	mov ax,angle
	mov dx,2
	mul dl
	cmp al,8
	jbe smallAng
	mov bl,al
	mov al,18
	sub al,bl
	smallAng:
    mov BX,offset Sin_TBL 
    mov dl,2
    mul dl ;2 
    add Bx,ax
    mov ax,[Bx]
    mov bx,vo
    MUL bx
    mov bx,10 ;need to divide by 10 value of gravity-acc
    div bx
    mov bx,vo
    mul bx
    mov bx,1000 ;need to divide by 1000 for the sine 
    div bx
    ;now al contains the approx point of landing
    mov bx,steps
    xor dx,dx
    div bx
	mov bx,offset projectXval 
	mov ah,0
	mov [bx],ax

	pop dx
	pop bx
	pop ax
	ret
deltaX endp
;------------
deltaY proc
	push ax
	push bx
	push dx
	;y=xtanx-gx^2/(2vo^2cos^2)
	mov ax,angle 
    mov bl,2
    mul bl ;2
    mov BX,offset Cos_TBL  
    add Bx,ax
    mov ax,[Bx]
    mov bx,ax
    MUL bx
    mov bx,1000 ;divide by 1000 for the cos
    div bx
    mov bx,vo
    MuL bx
    mov bx,100 ;divided by 100 need to divide by another 10 , g=10 , multiply 2 ->>> need to divide by 50
    xor dx,dx
    div bx
    mov bx,vo
    MuL bx
    mov bx,50
    div bx
    
    
    
    ;bx contains: 2vo^2 cos^2 /g
	mov bx,offset projectYval
	mov [bx],ax 
	pop dx
	pop bx
	pop ax
	ret
deltaY endp
;-------------------------------------------------;
;Procedures that throws the shape 
;IN : shiftvalx , projectYval, projectxDir 1(+  l2r),0(-  r2l)
;-------------------------------------------------;
projectX proc
	push di
	push bx 
	push ax

	mov ax,projectxDir
	mov bx, shiftvalx 
	
;	projectXLoop:
	cmp ax,0
	jne toright 
	sub [di],bx
	jmp toleft
	toright:
	add  [di], bx 
	toleft:
;	add di,2
;	cmp word ptr [di], 0;
;	JNE projectXLoop 
	pop ax
	pop bx
	pop di
	ret
projectX endp
;--------------
projectY proc
    push si
    push ax
    push bx
    push cx
    push dx
	mov ax,angle
    mov BX,offset Tan_TBL
    mov dl,2 
    mul dl ;2 
    add Bx,ax
    mov ax,[Bx]  ;ax has tan alpha*1000 
    mov bx, [DI]
    sub bx,startX; bx has X` where Y = X`tan alpha - x`^2 /(ProjectYval) 
    mov cx, [DI]
    cmp cx,startX
    
    jg toleft1
    neg bx    
    toleft1:
    mul bx
    mov cx,1000  
    div cx     ;ax has xtan
    mov cx,ax  ;cx has xtan 
    mov ax,bx  ;ax=x`
    mul bx     
    mov bx,ProjectYval
    div bx
    sub cx,ax 
    mov ax,starty
    sub ax,cx
    
    
    
    
    
;    projectYLoop:
    mov  [SI], ax
;    add si,2
;    cmp word ptr [si], 0;
;    JNE projectYLoop
    pop dx 
    pop cx
    pop bx
    pop ax
    pop si
    ret
projectY endp

;-----------------------------------------;
;A procedure that draws a player using it's array.
;IN :  DI -> address of starting + ending x point, SI->address of starting y point, bp->address of length of vertical line and its color 
; cx x1 , ax x2 , pushed l1,c1 , bx l2,c2
;-------------------------------------------;
DrawPlayer 	proc
push ax
push bx
push cx
push dx
mov ax,angle
push ax
mov ax, [DI]
mov offsetX, ax
mov ax, [si]
mov offsetY, ax
add di,2
add si,2
mov cx,[di]

cmp activePlayer,2 ;get the angle of the player being drawn
je pl2lable1
mov ax,angle1
mov angle,ax
jmp pl
pl2lable1:
mov ax,angle2
mov angle,ax
pl:
;DrawLoop: 
;cmp cx,0
;JE doneDraw
;add cx, offsetx
add di,2
mov ax,[di]
sub ax,cx  ;ax always bigger
mov cannonlength,ax
;//////////////////
;angle calculations
;--------cos----------- length * cos and saved in cannonDx
mov BX,offset Cos_TBL  
add Bx,angle
add Bx,angle
mov ax,[Bx]
mov bx,cannonlength ;cannon length must be smaller than 65
mul bx
mov bx,1000
mov dx,0
div bx
cmp dx,500
jb dEndCos
inc ax ;rounding the remaining decimal
dEndCos:
mov cannonDx,ax
;--------sine-----------length * sin and saved in cannonDy
mov BX,offset Sin_TBL  
add Bx,angle 
add Bx,angle
mov ax,[Bx]
mov bx,cannonlength ;cannon length must be smaller than 65
mul bx
mov bx,1000
mov dx,0
div bx
cmp dx,500
jb dEndSin
inc ax ;rounding the remaining decimal
dEndSin:
mov cannonDy,ax

;/////////////
;end of angles
mov ax,[di]
add ax, offsetX 
mov dx, [si]

cmp activeplayer,2
je pl2lable2
mov cx,[di]
pl2lable2:

;cmp cx,DrawPlayer
add dx, offsetY
mov bx, DS:[bp]
add bp,2
mov DrawLength,Bx
mov bx, DS:[bp]
mov color, bl


mov tmpx,0
mov tmpy,0
mov ax,1 ;itrator=ax 
add cx,offsetx

CANLoop:
call DrawVLine
sub cx,tmpx
cmp activeplayer,2
je pl2lable3
add cx,tmpx
add cx,tmpx
pl2lable3:
add dx,tmpy
;deltax=cannonDx *i /length
push ax
mov bx,cannonDx ; max val 65
mul bl
mov tmpw,ax
mov bx,cannonlength
mov ax,bx
shr ax,1 ;dividing by 2
add ax,tmpw
div bl ;(n+d/2)/d
mov ah,0
add cx,ax ;inc x 
cmp activeplayer,2
je pl2lable4
sub cx,ax ;inc x for player1
sub cx,ax ;remove the added value
pl2lable4:
mov tmpx,ax 
pop ax

push ax
mov bx,cannonDy ; max val 65
mul bl
mov tmpw,ax
mov bx,cannonlength
mov ax,bx
shr ax,1 ;dividing by 2
add ax,tmpw
div bl ;(n+d/2)/d
mov ah,0
sub dx,ax ;inc y 
mov tmpy,ax
pop ax
inc ax
cmp ax,cannonlength
Jbe CANLoop

add si,2
add di,2
add bp,2
;jmp DrawLoop

;doneDraw: ;;;;;;;;;;;;;;;;;;;;;;;;;draw 
;mov ax,stcktmp
;mov ss,ax

DrawLoop1:
mov cx,[di]
cmp cx,0
JE doneDraw1
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



xLoop1:
call DrawVLine
add cx,1
cmp cx,ax
JNE xLoop1


add si,2
add di,2
add bp,2
jmp DrawLoop1
doneDraw1:

pop ax
mov angle,ax
pop dx
pop cx
pop bx
pop ax

ret
DrawPlayer endp

;-----------------------------------------;
;A procedure that draws a shape using it's array.
;IN :  DI -> address of starting + ending x point, SI->address of starting y point, bp->address of length of vertical line and its color 
; cx x1 , ax x2 , pushed l1,c1 , bx l2,c2
;-------------------------------------------;
Draw proc
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
cmp dx,160
ja outside
call DrawVLine
outside:
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


;-----------------------------------;
;Draws background;
;-----------------------------------;
DrawBG	proc

push ax
push bx
push cx
push dx
mov cl, color
push cx

;Draw the sky (3 gradients) and the road
mov cl, 0
mov color, cl
mov cx,0
mov dx,0
mov bx,319
mov ax,10
call DrawRecFilled


mov cl, 16
mov color, cl
mov cx,0
mov dx,10
mov bx,319
mov ax,20
call DrawRecFilled


mov cl, 1
mov color, cl
mov cx,0
mov dx,20
mov bx,319
mov ax,40
call DrawRecFilled


mov cl, 176
mov color, cl
mov cx,0
mov dx,40
mov bx,319
mov ax,160
call DrawRecFilled

mov cl,brown
mov color, cl
mov cx,0
mov dx,140
mov bx,319
mov ax,160
call DrawRecFilled

    ;Draw the stars
    lea di, star1xs
    lea si, star1y
    lea bp, star1lencol
    call Draw
    lea di, star2xs
    lea si, star2y
    lea bp, star2lencol
    call Draw
    lea di, star2xs
    lea si, star2y
    lea bp, star2lencol
    call Draw
    lea di, star3xs
    lea si, star3y
    lea bp, star3lencol
    call Draw
    lea di, star4xs
    lea si, star4y
    lea bp, star4lencol
    call Draw


;Draw the clouds
mov ax, projectxDir
push ax
mov ax,1
mov projectxDir,ax
    lea di, cloud1xs
    lea si, cloud1y
    lea bp, cloud1lencol
    mov ax, cloudspeed
    mov shiftvalx, ax
    call projectx
    lea di, cloud1xs
    cmp [di],300
    JC cloud1done
    mov [di],0
    cloud1done:
    call Draw
;Draw the clouds

    lea di, cloud2xs
    lea si, cloud2y
    lea bp, cloud2lencol
    mov ax, cloudspeed
    mov shiftvalx, ax
    call projectx
    lea di, cloud2xs
    cmp [di],300
    JC cloud2done
    mov [di],0
    cloud2done:
     call Draw
    ;Draw the clouds
    lea di, cloud3xs
    lea si, cloud3y
    lea bp, cloud3lencol
    mov ax, cloudspeed
    mov shiftvalx, ax
    call projectx
    lea di, cloud3xs
    cmp [di],300
    JC cloud3done
    mov [di],0
    cloud3done:
    call Draw
    pop ax
    mov projectxDir,ax 


   ;Draw the  fence
   lea di, fence1xs
   lea si, fence1y
   lea bp, fence1lencol
   call Draw

   ;Draw the tree
   lea di, tree1xs
   lea si, tree1y
   lea bp, tree1lencol
   call draw


pop cx
mov color, cl
pop dx
pop cx
pop bx
pop ax
ret
DrawBG endp


;-------------------------------------------------;
;A procedure that shifts the shape in x-axis
;IN : DI offset of X points, variable shiftX
;-------------------------------------------------;
ShiftX proc
	push di
	push bx
	mov bx, shiftvalx
	add  [di], bx
	pop bx
	pop di
	ret
ShiftX endp

;------------------------------------;
;A procedure that draws a horizontal line.
; CX : Starting x position, DX : Starting Y position, BX : Length, color is the global variable
;------------------------------------;
DrawHLine	proc
	push bx
	push cx
	push ax
	mov al, color
	add bx, cx ; BX = end x position
	l1:
	mov ah,0ch
	call DrawPixel
	inc cx
	cmp cx,bx
	JBE l1
	pop ax
	pop cx
	pop bx
	ret
DrawHLine endp

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
	call DrawPixel
	inc dx
	cmp dx,bx
	JBE l2
	pop ax
	pop dx
	pop bx
	pop cx
	ret
DrawVLine endp

;------------------------------------;
;A procedure that draws a line with slope = 1.
; CX : Starting x position, DX : Starting Y position, BX : Length, color is the global variable
;------------------------------------;
DrawLine	proc
	push cx
	push bx
	push dx
	push ax
	mov al,color
	add bx, dx ; DX = end y position
	l3:
	mov ah,0ch
	int 10h
	inc dx
	inc cx
	cmp dx,bx
	JBE l3
	pop ax
	pop dx
	pop bx
	pop cx
	ret
DrawLine endp

;-------------------------------------;
;A procedure that draws a rectangle.
;CX: Top left x, DX: Top left y, BX : Bottom right x, AX: Bottom right y
;Color variable = color
;-------------------------------------;
DrawRec		proc
	push dx
	push bx 
	push ax
	push cx 
	

	sub bx,cx
	call DrawHLine 
	
	pop cx
	pop ax
	pop bx
	pop dx
	push ax
	push bx
	push cx
	push dx 
	
	mov dx,ax
 
	sub bx,cx
	call DrawHLine
	pop dx
	pop cx
	pop bx
	pop ax
	push ax
	push bx   
	push cx
	push dx
	
	mov bx,ax
	sub bx,dx
		mov DrawLength,Bx
	call DrawVLine 
	pop dx
	pop cx
	pop bx
	pop ax
	push dx
	push cx
	push bx
	push ax
	
	mov cx, bx
	mov bx,ax
	sub bx,dx  
		mov DrawLength,Bx
	call DrawVline
	pop ax
	pop bx
	pop cx
	pop dx
	ret
DrawRec	endp

;-------------------------------------;
;A procedure that draws a filled rectangle.
;CX: Top left x, DX: Top left y, BX : Bottom right x, AX: Bottom right y
;Color variable = color
;-------------------------------------;
DrawRecFilled	proc
	push ax
	push bx
	push cx
	push dx
	sub bx,cx
	yLoop: ;Loop to print in different Y positions
	push ax

	call DrawHLine
	pop ax
	inc dx
	cmp dx,ax
	JBE yLoop ;Repeat if not less than final y position

	pop dx
	pop cx
	pop bx
	pop ax
	ret
DrawRecFilled	endp

;-------------------------------------------;
;A procedure to draw a rectangle with color and border of colorBorder
;CX: Top left x, DX: Top left y, BX : Bottom right x, AX: Bottom right y
;--------------------------------------------;
DrawRecWBord	proc
	push ax
	push bx
	push cx
	push dx
	;Draw rectangle first
	call DrawRecFilled
	call ReverseColors
	call DrawRec
	call ReverseColors
	pop dx
	pop cx
	pop bx
	pop ax
	ret
DrawRecWBord	endp


;-----------------------------------------;
;A procedure to reverse the 2 colors in the color palette;
;------------------------------------------;
ReverseColors	proc
push ax; tmp value for ax
	push bx; tmp value for bx
	mov al, color2
	mov bl, color
	;Swap colors
	mov color2,bl
	mov color,al
	pop bx
	pop ax
	ret
ReverseColors	endp

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
mov ah,02h
int 10h

pop dx
pop cx
pop bx
pop ax

ret
MovCurs		endp

;------------------------------------------;
;A procedure that sleeps.
;In: WaitTime
;-------------------------------------------;
WaitFor		proc
push ax
push bx
push cx
push dx

mov dx,0000 
mov cx,WaitTime ;Delay with CX:DX
mov ax,1
mul cx
mov cx,ax
mov al,0
mov ah,86h
int 15h ;Wait interrupt
pop dx
pop cx
pop bx
pop ax
ret
waitfor endp

;------------------------------------------;
;A procedure that sleeps for frame.
;In: nothing
;-------------------------------------------;
WaitFrame		proc
push ax
push bx
push cx
push dx

mov dx,25 
mov cx,0 ;Delay with CX:DX
mov ax,1
mul cx
mov cx,ax
mov al,0
mov ah,86h
int 15h ;Wait interrupt
pop dx
pop cx
pop bx
pop ax
ret
waitFrame endp

;-------------------------------------Procedure to draw health bars----------------------------;
PrintHBP1 proc   
           ;store registers
           push cx
           push dx
           push ax
           push bx
           ;draw rectangular frame
           mov cx,10
           mov dx,10
           mov al,white  ;white color
           mov ah,0ch
           b1:call DrawPixel  
           add dx,10
           call DrawPixel
           inc cx           
           sub dx,10
           cmp cx,110
           jnz b1
           mov cx,10
           mov dx,10
           mov al,0fh
           mov ah,0ch
           b2:call DrawPixel  
           add cx,100
          call DrawPixel
           inc dx
           sub cx,100
           cmp dx,20
           jnz b2 
           ;fill the bar with color red
           mov dx,11
				    big1: 
				    mov cx,11
				    mov al, red
				    mov ah,0ch 
				    b3: call DrawPixel
				    inc cx
				    cmp cx,110
				    jnz b3 
				    inc dx 
				    cmp dx,20
				    jnz big1 
				   ;add health to the bar 
				   mov bx,hlth1 
				   cmp bx,1              ;check if health is zero 
				   jbe ending1
                   add bx,10 
                       
				    ;fill the bar with health
				    mov dx,11
				    big2: 
				    mov cx,11
				    mov al,green
				    mov ah,0ch 
				    a1: call DrawPixel
				    inc cx
				    cmp cx,bx  
				    jnz a1 
				    inc dx 
				    cmp dx,20
				    jnz big2 
				    ending1:
    pop bx
    pop ax
    pop dx
    pop cx
    ret           
PrintHBP1 endp  

;-------------------------------------------------
;proc to print health bar of player 2
;-------------------------------------------------

PrintHBP2 proc   

           ;store the registers
           push cx
           push dx
           push ax 
           push bx
           ;draw frame
           mov cx,310
           mov dx,10
           mov al,white
           mov ah,0ch
           b4:call DrawPixel
           add dx,10
           call DrawPixel
           dec cx
           sub dx,10
           cmp cx,210
           jnz b4
           mov cx,310
           mov dx,10
           mov al,0fh
           mov ah,0ch
           b5: call DrawPixel  
           sub cx,100
           call DrawPixel
           inc dx
           add cx,100
           cmp dx,20
           jnz b5    
           ;fill with red
           mov dx,11
				    big3: 
				    mov cx,309
				    mov al,red
				    mov ah,0ch 
				    b6:call DrawPixel
				    dec cx
				    cmp cx,210
				    jnz b6 
				    inc dx 
				    cmp dx,20
				    jnz big3 
				    ;add health 
				    mov bx,hlth2 
				    cmp bx,1              ;check if health is zero 
				   jbe ending2
				    mov bx,100            ;maping the health
				    sub bx,hlth2 
                 		   add bx,210  
				    mov dx,11
				    big4: 
				    mov cx,309
				    mov al,2
				    mov ah,0ch 
				    a2: call DrawPixel
				    dec cx
				    cmp cx,bx
				    jnz a2 
				    inc dx 
				    cmp dx,20
				    jnz big4  
				    ending2:   
    
           pop bx
           pop ax
           pop dx
           pop cx
           ret
           
PrintHBP2 endp  


;input: number in AX
;output: left:dl middle:bl right:dh
Number2ASCII3	PROC
	
	MOV CL, 100
	DIV CL
	
	MOV BH, AH
	
	;AL: left digit
	ADD AL, '0'
	
	MOV DL, AL
	
	MOV AL, BH
	MOV AH, 0
	
	MOV CL, 10
	DIV CL
	
	MOV BH, AH
	
	;AL: middle digit
	ADD AL, '0'
	MOV BL, AL
	
	;right digit
	MOV DH, BH
	ADD DH, '0'
	
	
	RET
Number2ASCII3	ENDP 

;-------------------------------------------------
;proc to draw level 2
;-------------------------------------------------

DrawStandBarrier proc
push si
push di

    lea di,barx
    lea si,bary
    lea bp,barlen
    
    call draw         

pop di
pop si
ret   
DrawStandBarrier endp

;-------------------------------------------------
;proc to draw level 3
;-------------------------------------------------

DrawMovingBarrier proc
push si
push di
    
    lea di,mbarx
    lea si,mbary
    lea bp,mbarlen 
    
    cmp up,0
    je mup 
    
     
    add mbary,5
    add mbary1,5
    add mbary2,5
    call draw
    
    cmp mbary,110
    je chg1 
    
pop di
pop si 
ret  

     chg1:
     mov up,0
    
    
pop di
pop si
ret
     
    
    mup:
    sub mbary,5
    sub mbary1,5
    sub mbary2,5
    call draw
    
    cmp mbary,10
    je chg2 
    
pop di
pop si
ret
    
  
    chg2:
    mov up,1
    
    
pop di
pop si
ret
 
DrawMovingBarrier endp   

;-------------------------------------------------
;proc to print player 1 name
;-------------------------------------------------

PrintPlayer1Name proc
push ax
push bx
push cx
push dx
push si
push di

    LEA BX, pl1

	
	MOV CX, 30
	MOV DX, 0
	MOV AH, 00FH
	CALL DrawString           


pop di
pop si
pop dx
pop cx
pop bx
pop ax 
ret   
PrintPlayer1Name endp 

;-------------------------------------------------
;proc to print player 2 name
;-------------------------------------------------

PrintPlayer2Name proc
push ax
push bx
push cx
push dx
push si
push di


    LEA BX, pl2

	mov si,200
	sub si,pl2len
	
	MOV CX, si
	MOV DX, 0
	MOV AH, 00FH
	CALL DrawString           


pop di
pop si
pop dx
pop cx
pop bx
pop ax 
ret   
PrintPlayer2Name endp

;prints chat name
;in: none
;out: none
InitChat PROC
	PUSH AX
	PUSH BX
	PUSH CX
	PUSH DX
	PUSH SI
	PUSH DI
	
	;draw name
	;input: BX: string address, cx: column, dx: row, ah= color(fg,bg)
	LEA BX, pl1
	
	CMP serialmode, slave
	JE PrintP1Down
	MOV CX, 0
	MOV DX, 161
	MOV AH, 00FH
	JMP PrintP1
PrintP1Down:
	MOV CX, 0
	MOV DX, 181
	MOV AH, 00FH
PrintP1:
	CALL DrawString
	CALL GetChatNameLength
	;MOV SI, BX
	
	mov p1length, bl
	ADD p1length, 1
	
	MOV AX, BX
	;INC AX
	MOV AH, 0
	
	MOV SI, AX
	
	MOV CL, FONTWIDTH
	
	MUL CL
	
	MOV CX, AX
	;input: bl: ascii, cx: column, dx: row, bh: color attribute
	MOV bl, ':'
	;MOV DX, 161
	MOV bh, 0FH
	CALL DrawChar
	
	;input: BX: string address, cx: column, dx: row, ah= color(fg,bg)
	LEA BX, pl2

	
	CMP serialmode, slave
	JE PrintP2Up
	MOV CX, 0
	MOV DX, 181
	MOV AH, 00FH
	JMP PrintP2
PrintP2Up:
	MOV CX, 0
	MOV DX, 161
	MOV AH, 00FH
PrintP2:
	CALL DrawString
	CALL GetChatNameLength
	
	mov p2length, bl
	ADD p2length, 1
	
	MOV AX, BX
	;INC AX
	MOV AH, 0
	
	MOV DI, AX
	MOV CL, FONTWIDTH
	
	MUL CL
	
	MOV CX, AX
	;input: bl: ascii, cx: column, dx: row, bh: color attribute
	MOV bl, ':'
	;MOV DX, 161
	MOV bh, 0FH
	CALL DrawChar
	
	
	MOV AL, mymaxcharcount
	CBW
	MOV BX, AX
	cmp serialmode, master
	JE p1size
	SUB BX, DI
	jmp chatdone
p1size:
	SUB BX, SI
chatdone:	
	SUB BX, 2
	MOV mymaxcharcount, BL
	POP DI
	POP SI
	POP DX
	POP CX
	POP BX
	POP AX
	RET
InitChat ENDP

;get null termiated name length (length not including terminator)
;in: BX : string loc
;out: BX: length
;modifies: none
GetChatNameLength PROC
	PUSH AX
	PUSH CX
	PUSH DI
	PUSH ES
	MOV DI, BX
	MOV AX, @DATA
	MOV ES, AX
	;es:di is the string
	mov al, 00H; terminator
	MOV CX, 0FFFFH
	REPNE SCASB
	
	SUB DI, BX
	DEC DI
	MOV BX, DI
	POP ES
	POP DI
	POP CX
	POP AX
	
	RET
GetChatNameLength ENDP
;print chat
PrintChat PROC
	PUSH AX
	PUSH BX
	PUSH CX
	PUSH DX
	
	;clear bg first
	;jmp PrintNormalChat
	;-------------------------------------;
	;A procedure that draws a filled rectangle.
	;CX: Top left x, DX: Top left y, BX : Bottom right x, AX: Bottom right y
	;Color variable = color
	;-------------------------------------;
	
	cmp serialmode, slave
	JE useP2Length2
	MOV AL, p1length
	jmp clearupmsg
useP2Length2:
	MOV AL, p2length
clearupmsg:
	MOV CL, FONTWIDTH
	MUL CL
	MOV CX, AX
	MOV DX, 161
	MOV BX, 319
	MOV AX, 161+FONTHEIGHT
	MOV color, black
	CALL DrawRecFilled
	
	cmp serialmode, slave
	JE useP1Length2
	MOV AL, p2length
	jmp cleardownmsg
useP1Length2:
	MOV AL, p1length
cleardownmsg:
	MOV CL, FONTWIDTH
	MUL CL
	MOV CX, AX
	MOV DX, 181
	MOV BX, 319
	MOV AX, 181+FONTHEIGHT
	MOV color, black
	CALL DrawRecFilled
	
PrintNormalChat:
	;MOV AL, p2length
	;MOV CL, FONTWIDTH
	;MUL CL
	;MOV CX, AX
	;CALL DrawRecFilled
	
	;p1 msg
	
	cmp serialmode, slave
	JE useP2Length
	MOV AL, p1length
	jmp contprintfirstmsg
useP2Length:
	MOV AL, p2length
contprintfirstmsg:
	MOV CL, FONTWIDTH
	MUL CL
	LEA BX, mymsg
	MOV CX, AX
	mov dx, 161
	MOV AH, 00FH
	CALL DrawString
	
	
	;p2 msg
	
	cmp serialmode, slave
	JE useP1Length
	MOV AL, p2length
	jmp contprintsecondmsg
useP1Length:
	MOV AL, p1length
contprintsecondmsg:
	MOV CL, FONTWIDTH
	MUL CL
	
	LEA BX, othermsg
	MOV CX, AX
	MOV DX, 181
	MOV AH, 00FH
	CALL DrawString
	
	POP DX
	POP CX
	POP BX
	POP AX
	RET
PrintChat ENDP
;-------------------------------------------------
;initialization for serial
;-------------------------------------------------

INITIALIZESERIAL proc far
mov dx,3fbh 			; Line Control Register
mov al,10000000b		;Set Divisor Latch Access Bit
out dx,al				;Out it
						;Set LSB byte of the Baud Rate Divisor Latch register.
mov dx,3f8h			
mov al,01h			
out dx,al
						;Set MSB byte of the Baud Rate Divisor Latch register.
mov dx,3f9h
mov al,00h
out dx,al
						;Set port configuration
mov dx,3fbh
mov al,00011011b
out dx,al

ret
INITIALIZESERIAL endp


;-------------------THE PROCEDURE THAT SENDS THE DATA IN THE BUFFER-------------------------------;
;in: what to send in bl
;out: none
SendSerial proc
      push ax
      push bx
      push cx
      push dx

		mov dx , 3FDH		; Line Status Register
AGAIN:  	In al , dx 			;Read Line Status
  		 test al , 00100000b
  		JZ AGAIN                               ;Not empty

;If empty put the VALUE in Transmit data register
  		mov dx , 3F8H		; Transmit data register
  		mov  al,bl
  		out dx , al
      
      pop dx
      pop cx
      pop bx
      pop ax

	ret
SendSerial endp

;-------------------THE PROCEDURE THAT CHECKS IF WE RECEIVED DATA TO PRINT-------------------------------;
;in:  nothing
;out: al: word, ch: 0 no receive 1 received
ReceiveSerial proc
		push dx
    mov ch, 0
;Check that Data is Ready
		mov dx , 3FDH		; Line Status Register
	    in al , dx 
  		test al , 1
		jz endchkr
;If Ready read the VALUE in Receive data register
  		mov dx , 03F8H
  		in al , dx
    	mov ch, 1 
  		;mov VALUEHERE!!!!!!!!!!!!!!!!!!!!!!!!!!!!! , al	
endchkr:
		pop dx
    ret
ReceiveSerial endp

;wait for master to send magic packet
SerialSlaveSyncWithMasterRecvData PROC

recvloop:
	call ReceiveSerial
	test ch, ch
	jz recvloop
	
	cmp al, serialmagic1
	jne recvloop

recvloop3:
	call ReceiveSerial
	test ch, ch
	jz recvloop3
	
	cmp al, serialmagic2
	jne recvloop3
	
	;slave data receive starts here
	;receive game ended or not
	call SerialSlaveReceive
	mov gameended, al


	;receive level
	call SerialSlaveReceive
	mov level, al 
	
	
	;receive moving barrier
	call SerialSlaveReceive 
	mov  byte ptr up,al
	call SerialSlaveReceive 
	mov  byte ptr mbarx[0],al
	call SerialSlaveReceive 
	mov  byte ptr mbarx[1],al 
	call SerialSlaveReceive 
	mov  byte ptr mbarx[2],al 
	call SerialSlaveReceive 
	mov  byte ptr mbarx[3],al 
	call SerialSlaveReceive 
	mov  byte ptr mbary[0],al
	call SerialSlaveReceive 
	mov  byte ptr mbary[1],al
	call SerialSlaveReceive 
	mov  byte ptr mbary[2],al
	call SerialSlaveReceive 
	mov  byte ptr mbarlen[0],al 
	call SerialSlaveReceive 
	mov  byte ptr mbarlen[1],al 
	call SerialSlaveReceive 
	mov  byte ptr mbarlen[2],al 
	call SerialSlaveReceive 
	mov  byte ptr mbarx1,al   
	call SerialSlaveReceive 
	mov  byte ptr mbarx2,al   
	call SerialSlaveReceive 
	mov  byte ptr mbary1,al   
	call SerialSlaveReceive 
	mov  byte ptr mbary2,al    
	
	
	
	;receive health
	call SerialSlaveReceive 
	mov  byte ptr hlth1,al
	call SerialSlaveReceive 
	mov  byte ptr hlth2,al
	
	;Receive tanks coordinate offsets
	call SerialSlaveReceive
	mov byte ptr tank1xs, al
	call SerialSlaveReceive
	mov byte ptr tank1xs[1], al
	call SerialSlaveReceive
	mov byte ptr tank2xs, al
	call SerialSlaveReceive
	mov byte ptr tank2xs[1], al

	;Receive angles
	call SerialSlaveReceive
	mov byte ptr angle , al	
	call SerialSlaveReceive
	mov byte ptr angle1 , al
	call SerialSlaveReceive
	mov byte ptr angle2 , al

	;Receive Bullet data
	call SerialSlaveReceive
	mov byte ptr bulletXs , al
	call SerialSlaveReceive
	mov byte ptr bulletXs[1] , al
	call SerialSlaveReceive
	mov byte ptr bullety , al
	call SerialSlaveReceive
	mov byte ptr bullety[1] , al
	
	;Receive cloud data
    	call SerialSlaveReceive
	mov byte ptr cloud1Xs , al
	call SerialSlaveReceive
	mov byte ptr cloud1Xs[1] , al
	call SerialSlaveReceive
	mov byte ptr cloud2Xs , al
	call SerialSlaveReceive
	mov byte ptr cloud2Xs[1] , al
	call SerialSlaveReceive
	mov byte ptr cloud3Xs , al
	call SerialSlaveReceive
	mov byte ptr cloud3Xs[1] , al

	;Receive powerup data
	call SerialSlaveReceive
	mov byte ptr PowerUpType , al
	call SerialSlaveReceive
	mov byte ptr PowerUpOn , al
	call SerialSlaveReceive
	mov byte ptr PowerUpTick , al
	call SerialSlaveReceive
	mov byte ptr PowerUpTick[1] , al
	call SerialSlaveReceive
	mov byte ptr PowerUpX1 , al
	call SerialSlaveReceive
	mov byte ptr PowerUpX1[1] , al
	call SerialSlaveReceive
	mov byte ptr PowerUpy1 , al
	call SerialSlaveReceive
	mov byte ptr PowerUpy1[1] , al
	call SerialSlaveReceive
	mov byte ptr PowerUpX2 , al
	call SerialSlaveReceive
	mov byte ptr PowerUpX2[1] , al
	call SerialSlaveReceive
	mov byte ptr PowerUpy2 , al
	call SerialSlaveReceive
	mov byte ptr PowerUpy2[1] , al
	
	call SerialSlaveReceive
	mov gamePaused, al
	
	call SerialSlaveReceive
	
	;al: true if I have message from master
	
	test al, al
	JZ EndReceive
	
	PUSH BX
	LEA BX, othermsg
chatcharrecvloopslave:
	call SerialSlaveReceive
	MOV [BX], al
	INC BX
	TEST AL, AL
	JNZ chatcharrecvloopslave
	POP BX
EndReceive:
	RET
SerialSlaveSyncWithMasterRecvData ENDP

SerialSlaveReceive PROC
	
recvloop2:
	CALL ReceiveSerial
	test ch, ch
	jz recvloop2
	RET
SerialSlaveReceive ENDP


SerialMasterSendData PROC

	;send magic packet first then all the other data.
	MOV BL, serialmagic1
	CALL SendSerial 
	MOV BL, serialmagic2
	CALL SendSerial
	
	

	


;for collision moving barrier

	
	;master data send starts here
	;send game ended or not
	mov bl, gameended
	call SendSerial

	
	;send level

	mov bl, level
	CALL SendSerial 
	
	
	;send mooving barrier
	mov bl,byte ptr up
	call sendserial 
	mov bl,byte ptr mbarx[0]
	call sendserial  
	mov bl,byte ptr mbarx[1]
	call sendserial
	mov bl,byte ptr mbarx[2]
	call sendserial
	mov bl,byte ptr mbarx[3]
	call sendserial
	mov bl,byte ptr mbary[0]
	call sendserial
	mov bl,byte ptr mbary[1]
	call sendserial
	mov bl,byte ptr mbary[2]
	call sendserial
	mov bl,byte ptr mbarlen[0]
	call sendserial
	mov bl,byte ptr mbarlen[1]
	call sendserial
	mov bl,byte ptr mbarlen[2]
	call sendserial 
	mov bl,byte ptr mbarx1
	call sendserial
	mov bl,byte ptr mbarx2
	call sendserial
	mov bl,byte ptr mbary1
	call sendserial
	mov bl,byte ptr mbary2
	call sendserial      
	
	;send health
	mov bl,byte ptr hlth1
	call sendserial 
	mov bl,byte ptr hlth2
	call sendserial
	
	;Send tanks coordinate offsets
	mov bl, byte ptr tank1xs
	call SendSerial
	mov bl, byte ptr tank1xs[1]
	call SendSerial
	mov bl, byte ptr tank2xs
	call SendSerial
    	mov bl, byte ptr  tank2xs[1]
	call SendSerial
	;Send angles
	mov bl, byte ptr  angle
	call SendSerial
	mov bl, byte ptr  angle1
	call SendSerial
	mov bl, byte ptr  angle2
	call SendSerial	
	
	;Send bullet data
	mov bl, byte ptr  bulletXs
	call SendSerial
    	mov bl, byte ptr  bulletXs[1]
	call SendSerial
	mov bl, byte ptr  bullety
	call SendSerial
	mov bl, byte ptr  bullety[1]
	call SendSerial
	
	;Send cloud data
	mov bl, byte ptr  cloud1Xs
	call SendSerial
    	mov bl, byte ptr  cloud1Xs[1]
	call SendSerial
	mov bl, byte ptr  cloud2Xs
	call SendSerial
	mov bl, byte ptr  cloud2Xs[1]
	call SendSerial
	mov bl, byte ptr  cloud3Xs
	call SendSerial
	mov bl, byte ptr  cloud3Xs[1]
	call SendSerial

	;Send powerup data
	mov bl, byte ptr  PowerUpType
    	call SendSerial
	mov bl, byte ptr  PowerUpOn
	call SendSerial
	mov bl, byte ptr  PowerUpTick
	call SendSerial
    	mov bl, byte ptr  PowerUpTick[1]
	call SendSerial
	mov bl, byte ptr  PowerUpx1
	call SendSerial
	mov bl, byte ptr  PowerUpx1[1]
	call SendSerial
	mov bl, byte ptr  PowerUpy1
	call SendSerial		
	mov bl, byte ptr  PowerUpy1[1]
	call SendSerial	
	mov bl, byte ptr  PowerUpx2
	call SendSerial
	mov bl, byte ptr  PowerUpx2[1]
	call SendSerial
	mov bl, byte ptr  PowerUpy2
	call SendSerial
	mov bl, byte ptr  PowerUpy2[1]
	call SendSerial
	
	mov bl, gamePaused
	call SendSerial
	
	mov bl, 0
	
	
	mov bl, messageSent
	call SendSerial
	
	test bl, bl
	JZ EndSend
	
	PUSH SI
	LEA SI, mymsg
sendchatloopmaster:
	MOV BL, [SI]
	CALL SendSerial
	INC SI
	TEST BL, BL
	JNZ sendchatloopmaster
	POP SI
	
EndSend:
	
	RET
SerialMasterSendData ENDP

SerialMasterRecvData PROC
	
	call ReceiveSerial
	test ch, ch
	jz nodata
	
	
	mov serialslaveinput, al
	jmp yesdata
nodata:
	mov serialslaveinput, serialnoinput
yesdata:
	cmp al, serialmagic1
	JNE gotKey
	;got chat message
	PUSH BX
	;al: char, terminator: 0
	LEA BX, othermsg
chatcharrecvloop:
	call ReceiveSerial
	test ch, ch
	jz chatcharrecvloop
	MOV [BX], al
	INC BX
	TEST AL, AL
	JNZ chatcharrecvloop
	;MOV [BX], 0; terminator
	POP BX
gotKey:
	RET
SerialMasterRecvData ENDP


FixName	proc
    
    push si
    push di
    push ax
    

    LEA si, user1
    lea di,pl1 
    cmp serialmode,master
    je mastername
    lea di, pl2
    mastername:
    lpp:
    mov al,[si]
    cmp al,'$'
    je contt
    mov byte ptr [di],al
    inc di
    inc si
    jmp lpp
    contt: 
    mov byte ptr [di], 00
    
    LEA si, user2
    lea di,pl2 
    cmp serialmode, master
    je mastername2
    lea di, pl1
    mastername2:
    
    lpp2:
    mov al,[si]
    cmp al,'$'
    je contt2
    mov byte ptr [di],al
    inc di
    inc si
    jmp lpp2
    contt2: 
    mov byte ptr [di], 00

pop ax
pop di
pop si
ret
FixName	endp

;---------procedure to copy winner name-------------;
;in : si offset of player name
CopyWinner  proc
push si
push ax
push di
lea di, winningPlayerName

cpynamelp1:
mov al, [si]
test al, al
JZ doneCopyW
mov [di], al
inc si
inc di
jmp cpynamelp1
doneCopyW:

pop di
pop ax
pop si
ret
CopyWinner  endp

;---------procedure to copy health name-------------;
;in : si offset of player name
CopyHealthName  proc
push si
push ax
push di
lea di, HealthMSGPname
;reset health name:
mov al, 16

resetnamelp:
mov byte ptr[di], ' '
inc di
dec al
jnz resetnamelp

lea di, HealthMSGPname

cpynamelp2:
mov al, [si]
test al, al
JZ doneCopyH
mov [di], al
inc si
inc di
jmp cpynamelp2

doneCopyH:
pop di
pop ax
pop si
ret
CopyHealthName  endp



end

;---------PROC TO D

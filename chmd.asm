EXTERN user1:Byte
EXTERN user2:Byte
public chmd
public INITIALIZE

.model small
.data

;The cursor for user1 and user2
curs1 dw 0
curs2 dw 0d00h
;The value of the char to print
value db ?
;The buffer of the message
msgBfr db 325 dup('$')
;Boolean to know if the chat ended
chatEnded db 0

.stack 64
.code

;The chatting procedure
chmd proc far
	mov ax,@data
	mov ds, ax
	mov ah,0
	mov al,03
	int 10h
	call INITIALIZE
	call SPLT
	call WriteNames
	lp:
	call CHCKK
	call CHCKR
	cmp chatEnded,1
	jne lp
	ret
chmd endp


;-------------------THE PROCEDURE THAT INITIALIZES THE SERIAL PORT-------------------------------;
INITIALIZE proc far
mov dx,3fbh 			; Line Control Register
mov al,10000000b		;Set Divisor Latch Access Bit
out dx,al				;Out it
						;Set LSB byte of the Baud Rate Divisor Latch register.
mov dx,3f8h			
mov al,0ch			
out dx,al
						;Set MSB byte of the Baud Rate Divisor Latch register.
mov dx,3f9h
mov al,00h
out dx,al
						;Set port configuration
mov dx,3fbh
mov al,00011011b
out dx,al
lea di, msgBfr
mov chatended,0
;The cursor for user1 and user2
mov curs1 , 0
mov curs2 , 0d00h
;The buffer of the message
ret
INITIALIZE endp


;-------------------THE PROCEDURE THAT SPLITS THE SCREEN-------------------------------;
SPLT proc
					;The first half
mov ah,6
mov al,0
mov bh,7
mov ch,0       ; upper left Y
mov cl,0        ; upper left X
mov dh,12     ; lower right Y
mov dl,79      ; lower right X 
int 10h           
					;The first half
mov ah,6
mov al,0
mov bh,122
mov ch,13       ; upper left Y
mov cl,0        ; upper left X
mov dh,24     ; lower right Y
mov dl,79      ; lower right X 
int 10h           
ret
SPLT endp



;-------------------THE PROCEDURE THAT WRITES THE NAMES OF THE USERS-------------------------------;
WriteNames	proc

;Write the name of the first user
lea si, user1

name1lp:
mov dx, word ptr curs1
mov bx,0
mov ah,2
int 10h
mov ah, 2
mov dl, byte ptr [si]
int 21h
call INCCURS1
inc si
cmp byte ptr [si], '$'
jne name1lp
mov dx, word ptr curs1
mov bx,0
mov ah,2
int 10h
mov ah,2
mov dl,':'
int 21h

;Write the name of the second user
lea si, user2
name2lp:
mov dx, word ptr curs2
mov bx,0
mov ah,2
int 10h
mov ah, 2
mov dl, byte ptr [si]
int 21h
call INCCURS2
inc si
cmp byte ptr [si], '$'
jne name2lp
mov ah,2
mov dl,':'
int 21h

mov ax,79
mov curs1,ax
call INCCURS1
mov ax,0d00h
add ax,79
mov curs2,ax
call inccurs2

ret
WriteNames	endp

;-------------------THE PROCEDURE THAT CHECKS IF THE USER PRESSED ON A KEY-------------------------------;
CHCKK	proc
mov ah,1
int 16h
jz endchk
 
mov ah,0
int 16h
cmp al,27
je endProg
cmp al,8 ;If backspace
je backSpace
cmp al,13 ;If enter
jne notEnter

mov [di],8
inc di
mov [di],'$'
call SND
mov dx, word ptr curs1
mov dl,79
mov curs1,dx
call INCCURS1
mov dx,word ptr curs1
mov bx,0
mov ah,2
int 10h
lea di, msgbfr
jmp endchk

notEnter:
mov dx, word ptr curs1
mov bx,0
mov ah,2
int 10h
mov ah, 2
mov dl, al
mov [di],dl
inc di
mov value,dl
int 21h
call INCCURS1
jmp endchk

endProg:
mov chatEnded,1
;send to the other player
		mov dx , 3FDH		; Line Status Register
AGAIN2:  	In al , dx 			;Read Line Status
  		test al , 00100000b
  		JZ AGAIN2                               ;Not empty

;If empty put the VALUE in Transmit data register
  		mov dx , 3F8H		; Transmit data register
  		mov  al,0
  		out dx , al
jmp endchk
backSpace:
;make sure we have letters to delete
lea bx, msgbfr
cmp di,bx
je endchk
call DECCURS1
mov dx,word ptr curs1
mov bx,0
mov ah,2
int 10h
mov ah,2
mov dl,' '
int 21h
mov dx,word ptr curs1
mov bx,0
mov ah,2
int 10h
mov [di],'$'
dec di
endchk:
ret
CHCKK endp

;-------------------THE PROCEDURE THAT SENDS THE DATA IN THE BUFFER-------------------------------;
SND proc
lea si, msgBfr
mov cx,0
sendMsgLp:
		mov dx , 3FDH		; Line Status Register
AGAIN:  	In al , dx 			;Read Line Status
  		test al , 00100000b
  		JZ AGAIN                               ;Not empty

;If empty put the VALUE in Transmit data register
  		mov dx , 3F8H		; Transmit data register
  		mov  al,[si]
  		out dx , al
inc si
inc cx
cmp cx,324
je sndOut
cmp [si],'$'
jne sendMsgLp
sndOut:
ret
SND endp


;-------------------THE PROCEDURE THAT CHECKS IF WE RECEIVED DATA TO PRINT-------------------------------;
CHCKR proc
;Check that Data is Ready
		mov dx , 3FDH		; Line Status Register
	        in al , dx 
  		test al , 1
		jz endchkr
;If Ready read the VALUE in Receive data register
  		mov dx , 03F8H
  		in al , dx 
  		mov VALUE , al	
		cmp value,0 ;If exit
		jne notExit
		mov chatEnded,1
		jmp endchkr
		notExit:
		cmp value,8 ;If enter, end of message and print new line
		jne notNewLine
		
		mov dx, word ptr curs2
		mov dl,79
		mov curs2,dx
		call INCCURS2
		mov dx, word ptr curs2
		mov bx,0
		mov ah,2
		int 10h
		jmp endchkr

		notNewLine:
		mov dx, word ptr curs2
		mov bx,0
		mov ah,2
		int 10h
		mov ah, 2
		mov al,value
		mov dl, al
		int 21h
		call INCCURS2
endchkr:
ret
CHCKR endp


;-------------------THE PROCEDURE THAT INCREMENTS CURSOR1-------------------------------;
INCCURS1 proc
	mov dx,curs1
	inc dl
	cmp dl,80
	jb endinc1
	mov dl,0
	inc dh
	cmp dh,13
	jb endinc1
	dec dh
	mov curs1,dx	
	mov ah,6
	mov al,1
	mov bh,7
	mov ch,1       ; upper left Y
	mov cl,0        ; upper left X
	mov dh,12     ; lower right Y
	mov dl,79      ; lower right X 
	int 10h 
	ret
	endinc1:
	mov curs1,dx
	
ret
INCCURS1 endp


;-------------------THE PROCEDURE THAT INCREMENTS CURSOR2-------------------------------;

INCCURS2 proc
	mov dx,curs2
	inc dl
	cmp dl,80
	jb endinc2
	mov dl,0
	inc dh
	cmp dh,24
	jb endinc2
	dec dh
	mov curs2,dx	
	mov ah,6
	mov al,1
	mov bh,122
	mov ch,14       ; upper left Y
	mov cl,0        ; upper left X
	mov dh,24     ; lower right Y
	mov dl,79      ; lower right X 
	int 10h         
	ret
	endinc2:
	mov curs2,dx
ret
INCCURS2 endp

;-------------------THE PROCEDURE THAT DECREMENTS CURSOR1-------------------------------;

DECCURS1 proc
	mov dx,curs1
	cmp dl,0
	jne notzero1
	cmp dh,1
	je enddec1
	mov dl,79
	dec dh
	jmp enddec1
	notzero1:
	dec dl
	enddec1:
	mov curs1,dx
	
ret
DECCURS1 endp

end

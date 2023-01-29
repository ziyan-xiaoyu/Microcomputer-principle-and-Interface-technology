	CODE SEGMENT        ;S9.ASM
	ASSUME CS:CODE	;this is a program of 9 way jmp
        	ORG 2F40H	;[4000H]=0,1,2,3....9; disp:0,1,2,3....0
START:	JMP START0
ADDR	DW DP0,DP1,DP2,DP3,DP4,DP5,DP6,DP7,DP8,DP9
START0:	MOV SI,4000H
	MOV AL, [SI]
	SUB AH,AH
	SHL AL,1
	MOV BX,OFFSET ADDR
	ADD BX,Ax
	JMP [BX]
DP0:	mov bl,0c0h	;DISP "0"
	jmp disp
DP1:	mov bl,0f9h	;DISP "1"
	jmp disp
DP2:	mov bl,0a4h	;DISP "2"
	jmp disp
DP3:	mov bl,0b0h	;DISP "3"
	jmp disp
DP4:	mov bl,99h	;DISP "4"
	jmp disp
DP5:	mov bl,92h	;DISP "5"
	jmp disp
DP6:	mov bl,82h	;DISP "6"
	jmp disp
DP7:	mov bl,0f8h	;DISP "7"
	jmp disp
DP8:	mov bl,80h	;DISP "8"
	jmp disp
DP9:	mov bl,90h	;DISP "9"
	jmp disp
;----------------------------------------
disp:  	mov ah,0DFh
disp0:	mov dx,0ff21h
         	mov al,bl
          	OUT DX,AL
          	mov dx,0ff20h
          	mov al,ah
          	OUT DX,AL
	CALL DLY
               	ror ah,01h
          	jmp disp0
DLY:	mov cx,0001h
dly1:	push cx
	 mov cx,0ffffh
disp1:    	loop disp1
	pop cx
	loop dly1
	ret
CODE ENDS
END  START


CODE SEGMENT            ;H8253.ASM
ASSUME CS:CODE
	ORG 1290H
START:	JMP TCONT
TCONTRO EQU 0043H
TCON0	EQU 0040H
TCONT:	MOV DX,TCONTRO
	MOV AL,36H
	OUT DX,AL
	MOV DX,TCON0
	MOV AL,00H
	OUT DX,AL
	MOV AL,04H
	OUT DX,AL
MOV DX,TCONTRO
	MOV AL,36H
	OUT DX,AL
	MOV DX,TCON0
	MOV AL,00H
	OUT DX,AL
	MOV AL,02H
	OUT DX,AL

	JMP $
CODE ENDS
END  START

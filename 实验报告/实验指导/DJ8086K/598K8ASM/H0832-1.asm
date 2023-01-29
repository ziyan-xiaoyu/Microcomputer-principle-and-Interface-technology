 CODE SEGMENT            ;H0832-1.ASM
ASSUME CS:CODE
DAPORT  EQU 0FF80h
        ORG 10D0h
START:  MOV AL,0FFH
        MOV CX,0800H
DACON1: MOV DX,DAPORT
        OUT DX,AL
        PUSH CX
        MOV CX,0400H
        LOOP $
        POP CX
        NOT AL
        LOOP DACON1
;---------------------
        MOV DX,DAPORT
        MOV AL,00H
        MOV CX,0008H
        MOV BX,0FFFFH
DACON2: OUT DX,AL
        INC AL
        DEC BX
        CMP BX,0000H
        JNZ DACON2
        LOOP DACON2
        JMP START
CODE ENDS
END  START

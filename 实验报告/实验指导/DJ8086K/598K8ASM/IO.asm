CODE SEGMENT    ;IO.ASM            
ASSUME CS:CODE
        ORG 19D0H
START:  MOV DX,0FF80H
        IN AL,DX
        MOV DX,0FF90H
        OUT DX,AL
        JMP START
CODE ENDS
END START


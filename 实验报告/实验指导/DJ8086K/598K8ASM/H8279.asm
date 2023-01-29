CODE SEGMENT            ;H8279.ASM
ASSUME CS:CODE
D8279   EQU    0FF80H
C8279   EQU    0FF81H
       ORG 2A90H
       JMP START
KH     DB ?             ;KEY HAO
ZW     DB ?
ZX     DB ?
START: MOV DX,C8279     ;8001H     ;WR-->MODE
       MOV AL,00H       ;8BIT L-IN 2KEY
       OUT DX,AL
       MOV AL,32H       ;FENG PIN
       OUT DX,AL
       MOV AL,0DFH      ;CLR BUF
       OUT DX,AL
WAIT:  IN AL,DX         ;clr buf end ?
       TEST AL,80H
       JNZ WAIT
       MOV AL,85H       ;WR DISRAM ADR Y5(PA5);100 0 0101-->com no-inc y5
       OUT DX,AL
       MOV DX,D8279     ;8000H     ;WR DATA 'P'
       MOV AL,0C8H
       OUT DX,AL
START0:MOV ZW,85H       ;BEST H BIT
NEXT:  MOV KH,00H       ;KEY HAO 0..FH,10..13H
       MOV DX,C8279     ;8001H     ;RD STATUS KEY ?
NOKEY: IN AL,DX
       AND AL,07H
       CMP AL,00H
       JZ NOKEY
       MOV DX,D8279     ;8000H     ;rd key zhi
       IN AL,DX
       MOV AH,AL        ;SAVE KEY ZHI
       MOV BX,OFFSET TABK
CMPK:  MOV AL,KH
       XLAT
       CMP AH,AL
       JZ KEY
       INC KH
       CMP KH,14H
       JNC KEY0
       JMP CMPK
KEY:   CMP KH,10H
       JNC FUN
       CALL DIS
       DEC ZW
KEY0:  CMP ZW,7FH
       JNZ NEXT
       JMP START0
FUN:   CMP KH,13H
       JNZ KEY0
        MOV ZW,85H
       MOV KH,08H
       CALL DIS
       MOV ZW,84H
       MOV KH,02H
       CALL DIS
       MOV ZW,83H
       MOV KH,07H
       CALL DIS
       MOV ZW,82H
       MOV KH,09H
       CALL DIS
       MOV ZW,81H
       MOV KH,11H
       CALL DIS
       MOV ZW,80H
       MOV KH,11H
       CALL DIS
;--------------------
       CALL DELY
       MOV ZW,85H
       MOV KH,09H
       CALL DIS
       MOV ZW,84H
       MOV KH,00H
       CALL DIS
       MOV ZW,83H
       MOV KH,00H
       CALL DIS
       MOV ZW,82H
       MOV KH,0DH
       CALL DIS
       MOV ZW,81H
       MOV KH,10H
       CALL DIS
       MOV ZW,80H
       MOV KH,10H
       CALL DIS
       JMP $
DIS:   MOV DX,C8279  ;8001H     ;WR BIT,BIT 85H,84H,..80H
       MOV AL,ZW
       OUT DX,AL
       MOV AL,KH        ;WR CODE
       MOV BX,OFFSET TABC
       XLAT
       MOV DX,D8279  ;8000H
       OUT DX,AL
       RET
DELY:  MOV BX,00FFH
DELY1: DEC BX
       CMP BX,0000
       JZ  DELY2
       MOV CX,04FFH
       LOOP $
       JMP DELY1
DELY2: RET
TABK:	DB 0C9H,0C1H,0D1H,0E1H,0C8H,0D8H,0E8H,0C0H,0D0H
	DB 0E0H,0F0H,0F8H,0F1H,0F9H,0E9H,0D9H
        DB 0F2H,0FAH,0F3H,0FBH
TABC:	DB 0CH,9FH,4AH,0BH,99H,29H,28H,8FH,08H,09H,88H
	DB 38H,6CH,1AH,68H,0E8H,0FFH,0FBH

CODE ENDS
END  START
DH

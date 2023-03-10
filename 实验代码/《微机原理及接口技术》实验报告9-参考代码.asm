CODE SEGMENT            ;Experiment2.ASM
ASSUME CS:CODE
INTPORT1 EQU 0FF80H
INTPORT2 EQU 0FF81H
INTQ3	 EQU INTREEUP3
TCONTRO EQU 0043H
TCON1     EQU 0041H
TCON0	EQU 0040H
IOCONPT EQU 0FF2BH
IOCPT      EQU 0FF2AH
IOBPT	EQU 0FF29H

	ORG 12D0H

START:	JMP s0
	first db 0feh
s0:
	CLD
	MOV AX,0H
	 MOV ES,AX
	 MOV DI,002CH
	 LEA AX,SUB1
	 STOSW
	 MOV AX,seg sub1
	 STOSW

	MOV AL,13H                                  ;8259初始化
	MOV DX,INTPORT1
	OUT DX,AL
	MOV AL,08H
	MOV DX,INTPORT2
	OUT DX,AL
	MOV AL,09H
	OUT DX,AL
	MOV AL,0F7H
	OUT DX,AL

	MOV AL,80H                                ;8255初始化
	MOV DX,IOCONPT
	OUT DX,AL
	
	  MOV DX,IOBPT
	MOV AL,first
                 OUT DX,AL
                
	
	MOV DX,TCONTRO                      ;8253初始化
	MOV AL,15H
	OUT DX,AL
	MOV DX,TCON0
	MOV AL,00H
	OUT DX,AL

	MOV DX,TCONTRO
	MOV AL,76H
	OUT DX,AL
	MOV DX,TCON1
	MOV AX,800
	OUT DX,AL
	MOV AL,AH
	OUT DX,AL
	
              
               
	
	STI
WAITING: 		     
	JMP WAITING
	RET

SUB1:	CLI
   
	ROL first,1         
	MOV DX,IOBPT
	MOV AL,first
	OUT DX,AL
                
   
  	MOV AL,20H
	MOV DX,INTPORT1
	OUT DX,AL
	STI
	IRET


CODE ENDS
END  START
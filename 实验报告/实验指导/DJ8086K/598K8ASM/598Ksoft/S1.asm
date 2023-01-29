	CODE SEGMENT    ;S1.ASM-->BIN ADD
	ASSUME CS:CODE
	ORG 2CA0H	;this is a program of add
START: 	CLC
	MOV SI,4000H	;result in [4100]
	MOV [SI],0ffffH
	MOV [SI+2],0ffffH
	MOV [SI+4],0ffffH
	MOV AX,0000H
	MOV [SI+102H],AX
                    MOV AX,[SI]
	ADD AX,[SI+2]
	ADC [SI+102H],0000
	ADD AX,[SI+4]
	MOV [SI+100H],AX
	ADC [SI+102H],0000
	JMP $
CODE ENDS
END  START

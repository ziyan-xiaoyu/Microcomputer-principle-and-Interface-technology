EXTRN READINT: FAR, READDEC: FAR, READHEX: FAR
EXTRN WRITEINT: FAR, WRITEDEC: FAR, WRITEHEX: FAR
EXTRN CRLF: FAR
;�궨��SCROLL,���������Ļ��ʾ����
SCROLL	MACRO	TOP, LEFT, BOTTOM, RIGHT, ATTRIB
	push	ax
	push	bx
	push	cx
	push	dx
	MOV	AX, 0600H		; ��Ļ�Ͼ�����
	MOV	CH, TOP			; ���Ͻ��к�
	MOV	CL, LEFT		; ���Ͻ��к�
	MOV	DH, BOTTOM		; ���½��к�
	MOV	DL, RIGHT		; ���½��к�
	MOV	BH, ATTRIB		; ����������
	INT	10H			; ��ָ����Χ��Ļ����
	pop	dx
	pop	cx
	pop	bx
	pop	ax
	ENDM
;�궨��CLS���������������Ļ��������
CLS	MACRO
	SCROLL	0, 0, 24, 79, 7
	ENDM
;�궨��SETCURSOR,�������ù��λ��
SETCUSOR MACRO	PAGE1, ROW, COLUMN
	push	ax
	push	bx
	push	dx
	MOV	AH, 2			; ���ù��λ��
	MOV	DH, ROW			; ���������
	MOV	DL, COLUMN		; ���������
	MOV	BH, PAGE1		; BH=ҳ��
	INT 	10H			; BIOS���ܵ���
	pop	dx
	pop	bx
	pop	ax
	ENDM
;��ָ��SETMODE,����������ʾģʽ
SETMODE	MACRO	MODE1
	push	ax
	MOV	AH, 0
	MOV	AL, MODE1
	INT	10H
	pop	ax
	ENDM
; д���غ궨��
WRITE_PIXEL	MACRO	PAGE1, ROW, COLUMN, COLOR
	push	ax
	push	bx
	push	cx
	push	dx
	MOV	AH, 0CH			; д���ع���
	MOV	AL, COLOR		; ��ɫ
	MOV	BH, PAGE1		; ҳ��
	MOV	DX, ROW			; ������
	MOV	CX, COLUMN		; ������
	INT	10H			; д����
	pop	dx
	pop	cx
	pop	bx
	pop	ax
	ENDM
; �����غ궨��
READ_PIXEL	MACRO	PAGE1, ROW, COLUMN, COLOR
	push	ax
	push	bx
	push	cx
	push	dx
	MOV	AH, 0DH			; �����ع���
	MOV	BH, PAGE1		; ҳ��
	MOV	DX, ROW			; ������
	MOV	CX, COLUMN		; ������
	INT	10H		;	 д����
	pop	dx
	pop	cx
	pop	bx
	pop	ax
	ENDM


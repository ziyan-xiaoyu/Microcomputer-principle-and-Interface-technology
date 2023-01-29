EXTRN READINT: FAR, READDEC: FAR, READHEX: FAR
EXTRN WRITEINT: FAR, WRITEDEC: FAR, WRITEHEX: FAR
EXTRN CRLF: FAR
;宏定义SCROLL,用于清除屏幕显示内容
SCROLL	MACRO	TOP, LEFT, BOTTOM, RIGHT, ATTRIB
	push	ax
	push	bx
	push	cx
	push	dx
	MOV	AX, 0600H		; 屏幕上卷功能
	MOV	CH, TOP			; 左上角行号
	MOV	CL, LEFT		; 左上角列号
	MOV	DH, BOTTOM		; 右下角行号
	MOV	DL, RIGHT		; 右下角列号
	MOV	BH, ATTRIB		; 卷入行属性
	INT	10H			; 对指定范围屏幕清屏
	pop	dx
	pop	cx
	pop	bx
	pop	ax
	ENDM
;宏定义CLS，用于清除整个屏幕（清屏）
CLS	MACRO
	SCROLL	0, 0, 24, 79, 7
	ENDM
;宏定义SETCURSOR,用于设置光标位置
SETCUSOR MACRO	PAGE1, ROW, COLUMN
	push	ax
	push	bx
	push	dx
	MOV	AH, 2			; 设置光标位置
	MOV	DH, ROW			; 光标行坐标
	MOV	DL, COLUMN		; 光标列坐标
	MOV	BH, PAGE1		; BH=页号
	INT 	10H			; BIOS功能调用
	pop	dx
	pop	bx
	pop	ax
	ENDM
;宏指令SETMODE,用于设置显示模式
SETMODE	MACRO	MODE1
	push	ax
	MOV	AH, 0
	MOV	AL, MODE1
	INT	10H
	pop	ax
	ENDM
; 写像素宏定义
WRITE_PIXEL	MACRO	PAGE1, ROW, COLUMN, COLOR
	push	ax
	push	bx
	push	cx
	push	dx
	MOV	AH, 0CH			; 写像素功能
	MOV	AL, COLOR		; 颜色
	MOV	BH, PAGE1		; 页号
	MOV	DX, ROW			; 行坐标
	MOV	CX, COLUMN		; 列坐标
	INT	10H			; 写像素
	pop	dx
	pop	cx
	pop	bx
	pop	ax
	ENDM
; 读像素宏定义
READ_PIXEL	MACRO	PAGE1, ROW, COLUMN, COLOR
	push	ax
	push	bx
	push	cx
	push	dx
	MOV	AH, 0DH			; 读像素功能
	MOV	BH, PAGE1		; 页号
	MOV	DX, ROW			; 行坐标
	MOV	CX, COLUMN		; 列坐标
	INT	10H		;	 写像素
	pop	dx
	pop	cx
	pop	bx
	pop	ax
	ENDM



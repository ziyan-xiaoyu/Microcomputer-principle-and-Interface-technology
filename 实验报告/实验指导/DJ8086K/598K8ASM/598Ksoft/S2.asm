;将 AX 拆为5个 BCD 码, 并存入 Result 开始的5个单元
data   segment AT 0    ;S2.ASM,BIN-->BCD
       	ORG 4100H
Result 	db 5 dup(?)
data   ends

code   segment
assume cs:code, ds:data
       	ORG 2CE0H
start  proc  near

       	mov   ax, data
      	mov   ds, ax
	mov dx,0000h
       	mov   ax, 65535
       	mov   cx, 10000
       	div   cx
       	mov   Result, al     ; 除以 10000, 得wan位数
	mov ax,dx
	mov dx,0000h
       	mov   cx, 1000
       	div   cx
       	mov   Result+1, al     ; 除以 1000, 得qian位数
	mov ax,dx
	mov dx,0000h
       	mov   cx, 100
       	div   cx
       	mov   Result+2, al     ; 除以 100, 得bai位数
	mov ax,dx
	mov dx,0000h
       	mov   cx, 10
       	div   cx
       	mov   Result+3, al     ; 除以 10, 得shi位数
       	mov   Result+4, dl     ; 得ge位数
       	jmp  $

code   ends
end  start


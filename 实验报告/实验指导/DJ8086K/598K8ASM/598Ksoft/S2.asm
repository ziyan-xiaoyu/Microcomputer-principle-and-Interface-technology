;�� AX ��Ϊ5�� BCD ��, ������ Result ��ʼ��5����Ԫ
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
       	mov   Result, al     ; ���� 10000, ��wanλ��
	mov ax,dx
	mov dx,0000h
       	mov   cx, 1000
       	div   cx
       	mov   Result+1, al     ; ���� 1000, ��qianλ��
	mov ax,dx
	mov dx,0000h
       	mov   cx, 100
       	div   cx
       	mov   Result+2, al     ; ���� 100, ��baiλ��
	mov ax,dx
	mov dx,0000h
       	mov   cx, 10
       	div   cx
       	mov   Result+3, al     ; ���� 10, ��shiλ��
       	mov   Result+4, dl     ; ��geλ��
       	jmp  $

code   ends
end  start


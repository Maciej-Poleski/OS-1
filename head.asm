[org 0x0000]
[bits 16]
mov ax,800h
mov ds,ax
jmp short _start

section .text
_start:
mov si,f_start
call put_s
mov si,info_hg
call put_s

system_prompt:
mov si,prompt
call put_s
mov di,buf
call get_s_start

is_hang:
mov si,buf
mov di,p_hang
mov cx,5

repe cmpsb
jne system_prompt_next

call system_hang

system_prompt_next:
mov si,buf
mov di,p_help
mov cx,5
repe cmpsb
jne spn2
call print_help
jmp short system_prompt

spn2:
mov si,buf
mov di,p_relo
mov cx,7
repe cmpsb
jne spn3
call reload
jmp short system_prompt

spn3:

spnxxx:
mov si,unknow
call put_s

jmp system_prompt

put_s:
mov ah,0eh
put_s_beg
mov al,[si]
inc si

test al,al
jz put_s_end

int 10h

jmp short put_s_beg

put_s_end:
ret

get_s_start:
mov byte [buf_s],0

get_s:
xor ah,ah
int 16h

cmp al,13
je get_s_enter

cmp al,8
je get_s_backspace

cmp byte [buf_s],63
je get_s

mov ah,0eh
int 10h
mov [di],al
inc di
inc byte [buf_s]
jmp short get_s

get_s_enter:
mov byte [di],0
ret

get_s_backspace:
xor bl,bl
mov bh,[buf_s]
cmp bl,bh
je get_s

dec di
dec byte [buf_s]

mov ah,0eh
int 10h

mov ah, 09h
xor bh,bh
mov al, ' '
xor cx,cx
mov bl, 07h
inc cx
int 10h
jmp short get_s

system_hang:
mov si,hang_in
call put_s
jmp $

;ret

print_help:
mov si,help_ms
call put_s

ret

reload:
mov si,relo_ms
call put_s
jmp _start

; ret

section .data
f_start	db	"This is an alpha version of My operating system.",13,10,"Do not use it on server machines!",13,10,10,0
prompt	db	13,10," ->",0
info_hg	db	"If you want to get help, type <help>.",13,10,0
help_ms	db	13,10,"hang - shut down system",13,10,"help - print this message",13,10,"reload - shut down system and re-start",0
relo_ms	db	13,10,"MP is restarting...",13,10,0
unknow	db	13,10,"Bad command!",0
p_hang	db	"hang",0
p_help	db	"help",0
p_relo	db	"reload",0
hang_in	db	13,10,10,"System halted",13,10,"Now, you can power off computer.",0
buf_s	db	0

section .bss
buf	resb	64


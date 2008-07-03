bits 16
org 7c00h
xor ax,ax
mov ds,ax
cli
mov ss,ax
mov sp,200h 
sti
mov es,ax
jmp _start

msg	db	"Starting up...",13,10,10,0

_start:
mov si,msg
mov ah,0eh
next_char:
mov al,[si]
inc si
test al,al
jz end_char
int 10h
jmp short next_char

end_char:
nop

load_core:
mov ah, 02h             ; odczytaj sektor z dyskietki
mov al, 4               ; ile sektorow
mov ch, 0               ; numer sciezki
mov cl, 2               ; numer sektora
mov dh, 0               ; glowica
mov dl, 0               ; numer dysku
mov bx, 0800h  
mov es, bx  
mov bx, 0               ; odczytany sektor zapisujemy pod adresem 0800:0000h
int    13h 

jmp 0800h:0000h

times 510-($-$$)	db	0
	dw	0aa55h
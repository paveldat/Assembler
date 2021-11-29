.model small
.stack 100h
.data 
mess1 db 0dh,0ah,"Enter first string: ","$" 
mess2 db 0dh,0ah,"Enter second string: ","$" 
mess3 db 0dh,0ah,"Found ","$"  
string db 80 dup(?)
undstring db ?
count dw 0

.code
start: 

mov ax, @data 
mov ds, ax ; Загрузить сегментный адрес данных 

lea dx,mess1  ;Приглашение к вводу первой строки
mov ah,09h
int 21h

xor bx,bx
entering:     ;Ввод первой строки
mov ah,01h
int 21h
cmp al,13
je continue
mov string[bx],al
inc bx
jmp entering

continue:
inc bx
mov string[bx],'$'    ;Добавление конца первой строки
xor bx,bx

lea dx,mess2      ;Приглашение к вводу второй строки
mov ah,09h
int 21h

entering2:        ;Ввод второй строки
mov ah,01h
int 21h
cmp al,13
je continue2
mov undstring[bx],al
inc bx
jmp entering2

continue2:
mov undstring[bx],'$'    ;Добавление конца второй строки
xor bx,bx
lea di,string[0]
dec di

finding:               ;Главный цикл поиска
inc di
mov ah,[di]
cmp ah,'$'
je break
cmp ah,undstring[0]
je strcmp
jmp finding

strcmp:                 ;Цикл, позволяющий сравнить
inc bx                    ; первую строку со второй
inc di
mov ah,[di]
cmp ah,undstring[bx]
je addcount
cmp ah,'$'
je break
xor bx,bx
jmp finding

addcount:                             ;Цикл, в котором проверяется полная
cmp undstring[bx+1],'$'    ;входимость второй строки в первую
jne strcmp
inc count
xor bx,bx
jmp finding

break:
lea dx,mess3           ;Вывод результирующей строки
mov ah,09h
int 21h
mov ax,cx

Perevod:        ;Перевод количества вхождений из 16
push ax          ;в 10 систему счисления и вывод его
push bx
oush cx
push dx
push di

mov cx,10
xor di,di

Conv:
xor dx,dx
div cx
add dl,'0'
inc di
push dx
or ax,ax
jnz Conv

Show:
pop dx
mov ah,2
int 21h
dec di
jnz Show

pop di
pop dx
pop cx
pop bx
pop ax
 
mov ax, 4C00h ; Код завершения 0 
int 21h ; Выход в DOS  

end START

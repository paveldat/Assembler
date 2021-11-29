DOSSEG
.MODEL small
.386
.STACK 100h
.DATA

 fifo  DB  10 dup ('-') ;очередь
 
 fifo_size  DW  8 ;размер очереди
 fifo_end  DW  0 ;указывает на конец очереди

 wr_num  DW  0 ;количество записываемых элементов
 rd_num  DW  0 ;количество читаемых элементов
 
 f_msg DB 'FIFO: ',10,13,'$'
 input_msg DB 'Enter number of input elements:',10,13,'$'
 elem_msg DB 'Enter elements of array:',10,13,'$'
 output_msg DB 'Enter number of output elements:',10,13,'$'
 empty_msg DB 'FIFO is empty!',10,13,'$'
 full_msg DB 'FIFO is full!',10,13,'$'
 excess_msg DB 'Your number become max of avilable',10,13,'$'
 retry_msg DB 'It is very big number, try again!',10,13,'$'
 
.CODE


;---------------------------------------
;процедура выводящая содержимое очереди
;---------------------------------------

print_fifo proc
;вывод надписи "FIFO: "
    mov ah,9
    mov dx,offset f_msg
    int 21h
;вывод содержимого очереди
    xor si,si
    lea bx,fifo
    mov cx,fifo_size
print:
    mov dl,[bx+si]
    mov ah,2
    int 21h
    inc si
loop print
    mov al,10 ;перенос строки
    int 29h
    int 29h
ret
print_fifo endp


;----------------------------------------------
;процедура включения новых элементов в очередь
;----------------------------------------------

write_fifo proc
;проверка на заполненность очереди
    mov ax,fifo_size
    cmp fifo_end,ax
      je full_label
;вывод сообщения о количестве заполняемых элементов
    mov ah,9
    mov dx,offset input_msg
    int 21h
;ввод количества заполняемых элементов
    mov ah,0 ;ввод информации в консоль
    int 16h
    mov byte ptr wr_num,al ;запись числа в переменную
    sub word ptr wr_num,30h ;преобразование ASCII кода в число
    mov dl,al ;вывод введенного числа
    mov ah,2
    int 21h     
    mov al,10 ;перенос строки
    int 29h
;проверка на превышение зачения wr_num
    mov bx,fifo_end
    mov ax,fifo_size
    sub ax,bx
    mov bx,wr_num
    cmp bx,ax
    jb excess_label
    ;записываем в wr_num разность fifo_size и fifo_end
        mov ah,9
        mov dx,offset excess_msg
        int 21h
        mov bl,byte ptr fifo_end
        mov al,byte ptr fifo_size
        sub al,bl
        mov byte ptr wr_num,al
        add al,30h
        int 29h
        mov al,10
        int 29h
    excess_label:
;вывод сообщения о заполнении очереди
    mov ah,9
    mov dx,offset elem_msg
    int 21h
;заполнение очереди
    xor si,si
    add si,fifo_end
    lea bx,fifo
    mov cx,wr_num
input:
    mov ah,0
    int 16h
    mov [bx+si],al
    inc si
    mov dl,al
    mov ah,2
    int 21h
loop input
;обновляем значение fifo_end
    mov bx,wr_num
    add fifo_end,bx
    jmp over_full
;вывод сообщения о заполненности очереди
full_label: 
    mov ah,9
    mov dx,offset full_msg
    int 21h
over_full:
    mov al,10 ;перенос строки
    int 29h
ret
write_fifo endp


;--------------------------------------
;процедура чтения элементов из очереди
;-------------------------------------- 

read_fifo proc
;проверка на пустоту очереди
    cmp fifo_end,0
      je empty_label
try_again:
;вывод сообщения о количестве читаемых элементов
    mov ah,9
    mov dx,offset output_msg
    int 21h
;ввод количества выводимых элементов
    mov ah,0 ;ввод информации в консоль
    int 16h
    mov byte ptr rd_num,al ;запись числа в переменную
    sub word ptr rd_num,30h ;преобразование ASCII кода в число
;проверка на превышение зачения rd_num
    mov bx,rd_num
    cmp bx,fifo_end
      jae retry_label
    mov dl,al ;вывод введенного числа
    mov ah,2
    int 21h
    mov al,10 ;перенос строки
    int 29h
;чтение из очереди
    xor si,si
    lea bx,fifo
    mov cx,rd_num
output:
    mov dl,[bx+si]
    mov ah,2
    int 21h
    inc si
loop output
;сдвиг элементов
    xor di,di
    xor si,si
    add si,rd_num
    lea bx,fifo
    mov cx,fifo_end
    sub cx,rd_num
moving:
    mov al,[bx+si]
    mov [bx+di],al
    inc di
    inc si
loop moving
    mov fifo_end,di
;зачистка
    mov si,fifo_end
    mov cx,fifo_size
    sub cx,fifo_end 
erasing:
    mov byte ptr [bx+si],'-'
    inc si
loop erasing
    jmp over_empty
;вывод сообщения о том, что очередь пуста
empty_label:
    mov ah,9
    mov dx,offset empty_msg
    int 21h
    jmp over_empty
;вывод сообщения о том, что введено большое число
retry_label:
    mov ah,9
    mov dx,offset retry_msg
    int 21h
    jmp try_again
over_empty:
    mov al,10 ;перенос строки
    int 29h
ret
read_fifo endp


;--------------------------
;начало основной программы
;--------------------------

start:

    mov ax,@data
    mov ds,ax
    xor ax,ax

    call write_fifo 
    call print_fifo
    call read_fifo 
    call print_fifo
    call write_fifo 
    call print_fifo
    call read_fifo 
    call print_fifo

    mov ax,4c00h
    int 21h

END start

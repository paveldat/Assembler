exit_app macro                                         ;макрос для выхода из программы
      mov ax, 4c00h                                     ;функция выхода из программы
      int 21h 
endm

enter_app macro                                     ;макрос для ввода строки
    mov ax, data                            
      mov ds, ax                                
      mov ah, 0ah                            
      lea dx, string                            
      int 21h      
endm

data segment
     string db 100,102 dup ('$')               ;выделяем память под строку и заполняем ее ‘$’
     space db ' $'
data ends

code segment 
assume cs:code, ds:data
start:    
      enter_app                                           ;макрос для ввода строки
                                
      lea di, string + 1                                ;ES:DI ->string+1
      mov ax, [di]
      mov cx, ax
      mov byte ptr[di], ' '
      inc di
      cycle:                                          
       mov ah, [di]
       cmp ah, '$'
       je exit                                                 ;если ‘$’, то exit               
       
       cmp ah, 'A'                                        ;сравнение
       jb pass
       cmp ah, 'Z'                                        ;сравнение
       ja pass2
       jmp word                                          ;безусловный переход на word
       pass2:
       cmp ah, 'a'                                        ;сравнение
       jb pass
       cmp ah, 'z'                                         ;сравнение
       ja pass
       jmp word                                           ;безусловный переход на word
       pass:
       inc di
      loop cycle                                            ;конец цикла
      
      exit:
      exit_app                                               ;вызов макроса для выхода из программы         
      wordd:
       mov al, 0
       mov bl, 0                                             ;флаг
       mov si, di
       dec si
       cmp byte ptr[si], ' '
       je qwer
       mov bl, 2                                              ;флаг
       qwer:
       cmp ah, 'M'                                         ;проверка на принадлежность первой буквы от ‘A’ до ‘M’ 
       ja wordPass2
       inc bl
       jmp word1
       ;проверка на принадлежность первой буквы от ‘а’ до ‘m’
       wordPass2:
       cmp ah, 'a'
       jb word1                          
       cmp ah, 'm'
       ja word1

       inc bl
       push cx                      ;cx на вершину стека
       word1:                       
        inc al
        inc si
        mov ah, [si]
        cmp ah, '0'                 ;цифры печатаем как слово, если они не являются первым символом
        jb wordPass3 
        cmp ah, '9'
        ja wordPass5
        jmp passCyc              ;безусловный переход на passCyc
        wordPass5:
        cmp ah, 'A'                 
        jb wordPass3 
        cmp ah, 'Z'                 
        ja wordPass4
        jmp passCyc              ;безусловный переход на passCyc
        wordPass4:
        cmp ah, 'a'
        jb wordPass3
        cmp ah, 'z'
        ja wordPass3
        passCyc:
       loop word1                     
       wordPass3:
       cmp bl,1
       jne passPrint
        mov bl, [si]
        mov byte ptr[si], '$'
        mov ah, 09h
        mov dx, di
        int 21h
        lea dx, space
        int 21h
        mov byte ptr[si], bl
       passPrint:
       mov di, si
       pop cx                                ;извлекаем сх с верхушки стека
       jmp pass
    
    
    code ends  
    end start

dosseg
.model tiny
.stack 100h

prnstr macro sto  ; макросс для печати 
 mov ah, 09h
        lea dx, sto
        int 21h
        endm
        
.data
      fv db 'The end of the world is VORON$'
      de db 'The end of the world is VORONA$'
      cr db 'The end of the world is VORONI$'
      
     
string db 5 
       db ? 
       db 5 dup (?) 
                    
 .code

start:

mov ax, @data
mov ds, ax

;ввод строки
  mov  ah, 0Ah
  mov  dx, offset string
  int  21h
  call string2number

;Перевод строки в число и его запись в bx
  proc string2number         
  mov  si, offset string + 1 
  mov  cl, [ si ]                                         
  mov  ch, 0 
  add  si, cx 

  mov  bx, 0
  mov  bp, 1 
repeat: ;цикл переобразования символов                            
  mov  al, [ si ] 
  sub  al, 48 
  mov  ah, 0 
  mul  bp 
  add  bx,ax                         

  mov  ax, bp
  mov  bp, 10
  mul  bp 
  mov  bp, ax  

  dec  si 
  loop repeat ; cx - 1, если не 0, переход на метку "repeat"
  
  mov ax, bx  ;помещаем введенное число в ах
  
mov bl, 10
div bl        
mov cl, al

         mov ch, ah ;остаток, записанный в ah, помещаем в ch
mov cl, ch
mov al, 5
mov bl, 0
mov dl, 1


       cmp cl, dl   ;сравниваем остаток от целочисленного деления числа и 1
       je rav1
       jne nerav1
       
   ;Если равно 1
  rav1:
  prnstr de    ;Печать "vorona"
  jmp exit

;Если не равно 1
nerav1:

CMP al, cl  ;Cравниваем 1-ую часть числа и 5
ja menshe
jb bolshe
;je ravno


     ;Если число меньше 5
     menshe:
     cmp cl, bl   ;проверка на "Не является ли число нулем"
     je exit
     prnstr cr     ;Печать "voroni"
     dec cl        ;уменьшаем число на 1
     cmp cl, bl    ;проверка на "Больше ли наше число, чем 0"
     jmp exit

  ;Если число больше 5
  bolshe:
  prnstr fv   ;печать "voron"
  jmp exit
  ;sub cl,  1   ;Уменьшаем число на 1
  ;dec cl        ;уменьшаем число на 1
  
       ;Если число равно 5
       ravno:
       prnstr fv     ;печать "voron"
       jmp exit

exit:   

start1:
mov cl, ch  ;присваиваем cl, остаток числа
mov al, 1
mov bl, 0
mov dl, 0

        cmp cl, dl  ;сравниваем 2-ую часть числа и 0
        je rav0
        jne nerav0
                                                            
  ;Если равно 0
  rav0:
  prnstr fv   ;печать "voron"
  jmp exit1

;Если не равно 0
nerav0:
   jmp exit1


exit1:  ;конец программы

 mov ah, 4ch
 int 21h
end

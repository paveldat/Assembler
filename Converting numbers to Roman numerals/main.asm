dosseg
.model tiny
.stack 100h

prnstr macro sto  ; макрос для печати 
 mov ah, 09h
        lea dx, sto
        int 21h
        endm
        
.data
      ed db 'X$'
      fv db 'L$'
      de db 'XC$'
      cr db 'XL$'
      
      sk db 'I$'
      five db 'V$'
      nine db 'IX$'
      foure db 'IV$'
      sto db 'C$'  
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
repeat:  ;цикл преобразования символов                            
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
div bl        ;al (первая часть числа) = ax (введенное число) / 10
mov cl, al

         mov ch, ah ;остаток, записанный в ah, помещаем в ch, 
                    ;ch сы воспользуемся во второй части программы
mov al, 4
mov bl, 0
mov dl, 10


       cmp cl, dl   ;сравниваем 1-ую часть числа и 10
       je rav10
       jne nerav10
       
   ;Если равно 10
  rav10:
   prnstr sto    ;Печать "C"
   jmp exit

;Если не равно 10
nerav10:
 mov dl, 9
 
 cmp cl, dl ;cравниваем 1-ую часть числа и 9
 je rav9
 jne nerav
 
       ;Если равно 9
       rav9:
        prnstr de     ;Печать "XC"
        jmp exit

;Если не равно 9
nerav:

CMP al, cl  ;Cравниваем 1-ую часть числа и 4
ja menshe
jb bolshe
je ravno


     ;Если меньше
     menshe:
     cmp cl, bl   ;проверка на "Не является ли число нулем"
     je exit
     prnstr ed     ;Печать "X"
     dec cl        ;уменьшаем число на 1
     cmp cl, bl    ;проверка на "Больше ли наше число, чем 0"
     ja menshe     ;Если ноль меньше, чем наше число, возвращаемся к метке "menshe" 
     jmp exit

  ;Если число больше 4
  bolshe:
  prnstr fv    ;печать "L"
  sub cl,  5   ;Уменьшаем число на 5
  jmp menshe   ;переход на метку "menshe"
  
       ;Если число равно 4
       ravno:
       prnstr cr     ;печать "XL"
       jmp exit


exit:   ;конец 1-ой части программы

;-------------------------------------------------------------------------------------------------------------------------------
;-------------------------------------------------------------------------------------------------------------------------------

start1:

mov cl, ch  ;присваиваем cl, вторую часть введенного нами числа
mov al, 4
mov bl, 0
mov dl, 9

        cmp cl, dl  ;сравниваем 2-ую часть числа и 9
        je rav9_1
        jne nerav1
        
  ;Если равно 9
  rav9_1:
  prnstr nine   ;печать "IX"
  jmp exit1

;Если не равно 9
nerav1:

CMP al, cl   ;Cравниваем 2-ую часть числа и 4
ja menshe1
jb bolshe1
je ravno1

    ;Если меньше
    menshe1:
    cmp cl, bl   ;проверка на "Не является ли число нулем"
    je exit1
    prnstr sk    ;Печать "I"
    dec cl       ;уменьшаем число на 1
    cmp cl, bl   ;проверка на "Больше ли наше число, чем 0"
    ja menshe1   ;Если ноль меньше, чем наше число, возвращаемся к метке "menshe1" 
    jmp exit1

;Если число больше 4
bolshe1:
prnstr five  ;печать "V"
sub cl,  5   ;уменьшаем число на 5
jmp menshe1  ;переход на метку "menshe1"

   ;Если число равно 4
   ravno1:
   prnstr foure     ;печать"IV"
   jmp exit1
exit1:  ;конец 2-ой части программы
 mov ah, 4ch
 int 21h
end

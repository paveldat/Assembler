DATA SEGMENT
    MSG1 DB 10,13,'ENTER ANY STRING :- $'
    MSG2 DB 10,13,'ENTER ANY CHARACTER :- $'
    MSG3 DB 10,13,' $'
    MSG4 DB 10,13,'NO, CHARACTER FOUND IN THE GIVEN STRING $' 
    MSG5 DB ' CHARACTER(S) FOUND IN THE GIVEN STRING $'
    CHAR DB ?
    COUNT DB 0
    P1 LABEL BYTE
    M1 DB 0FFH
    L1 DB ?
    P11 DB 0FFH DUP ('$')   
DATA ENDS 
DISPLAY MACRO MSG
    MOV AH,9
    LEA DX,MSG
    INT 21H
ENDM   
CODE SEGMENT
    ASSUME CS:CODE,DS:DATA
START:
        MOV AX,DATA
        MOV DS,AX                
               
        DISPLAY MSG1
       
        LEA DX,P1
        MOV AH,0AH    
        INT 21H
       
        DISPLAY MSG2
       
        MOV AH,1
        INT 21H
        MOV CHAR,AL                           
       
        DISPLAY MSG3
       
        LEA SI,P11
                      
        MOV CL,L1
        MOV CH,0
       
CHECK:
        MOV AL,[SI]
        CMP CHAR,AL
        JNE SKIP
        INC COUNT       
SKIP:       
        INC SI
        LOOP CHECK
             
        CMP COUNT,0
        JE NOTFOUND
             
        DISPLAY MSG3
       
        MOV DL,COUNT
        ADD DL,30H
        MOV AH,2
        INT 21H 
               
        DISPLAY MSG5
        JMP EXIT 
NOTFOUND:      
        DISPLAY MSG4
               
EXIT:   MOV AH,4CH
        INT 21H
CODE ENDS
END START  

DATA SEGMENT  
    STR1 DB "ENTER A STRING: ",'$'  
    MAXLEN DB 100  
    ACTUALLEN DB ?  
    STRING DB 100 DUP('$')  
    NEWLINE DB 10,13,'$'  
    WORD_COUNT DB 0  
DATA ENDS  

CODE SEGMENT  
MAIN PROC FAR  
    MOV AX, @DATA  
    MOV DS, AX  

    ; Display prompt message
    MOV AH, 09H  
    LEA DX, STR1  
    INT 21H  

    ; Read input string
    MOV AH, 0AH  
    LEA DX, MAXLEN  
    INT 21H  

    MOV AL, ACTUALLEN  ; Get actual length entered
    MOV AH, 0  
    ADD STRING+1, AL   ; Add the length for correct termination  

    LEA SI, STRING+1   ; SI points to the first character of input  
    MOV CL, ACTUALLEN  ; CL stores the number of characters  

    MOV WORD_COUNT, 0   ; Initialize word count  

CONVERT:  
    CMP [SI], '$'  
    JE DISPLAY_WORD_COUNT  
    CMP [SI], 20H  ; Space  
    JE NEW_WORD  
    CMP [SI], 'a'  
    JB NEXT_CHAR  
    CMP [SI], 'z'  
    JA NEXT_CHAR  
    SUB [SI], 20H  ; Convert to uppercase  

NEXT_CHAR:  
    INC SI  
    LOOP CONVERT  
    JMP DISPLAY_WORD_COUNT  

NEW_WORD:  
    MOV AH, 09H  
    LEA DX, NEWLINE  
    INT 21H  

    INC WORD_COUNT  
    INC SI  
    LOOP CONVERT  

DISPLAY_WORD_COUNT:  
    MOV AH, 09H  
    LEA DX, NEWLINE  
    INT 21H  

    MOV AH, 09H  
    LEA DX, STRING+1  
    INT 21H  

    ; Print newline
    MOV AH, 09H  
    LEA DX, NEWLINE  
    INT 21H  

    ; Display word count
    MOV AL, WORD_COUNT  
    AAM  
    ADD AX, '00'  

    MOV DL, AH  
    MOV AH, 02H  
    INT 21H  

    MOV DL, AL  
    MOV AH, 02H  
    INT 21H  

    MOV AX, 4C00H  
    INT 21H  

MAIN ENDP  
CODE ENDS  
END MAIN  

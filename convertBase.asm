DATA SEGMENT   
                  
WELCOME_STR DB "WELCOME TO THE ONLINE BASE CONVERTER!$"
ENTER_BASE_STR DB "PLEAS ENTER YOUR BASE TO CONVERT FROM$" 
OPTIONS_STR DB "('H' - HEXA, 'D'- DEC, 'O'- OCT, 'B',BIN)$"
ENTER_NUM_STR DB "PLEASE ENTER YOUR NUMBER:$" 
YOUR_INPUT_STR DB "YOUR INPUT WAS: $" 
CONVERTED_VAL_STR DB "THE CONVERTED VALUES ARE:$" 
ERR_MSG DB "WRONG INPUT PLEASE TRY AGAIN.$"  
ANOTHER_NUM DB "CONVERT ANOTHER NUMBER? (Y/N)$"
OCT_STR DB "(OCT)$"
DEC_STR DB "(DEC)$"
HEX_STR DB "(HEX)$"
BIN_STR DB "(BIN)$"  
BASE DB ?  
HEX DB 0 ,N DUP(?) 
DECI DW ?  
DECI_STR DB 0 ,N DUP(?) 
OCT DB 0 ,N DUP(?)
BIN DB 0 ,N DUP(?) 
VALUE DW ?
MULT_HEX DD 16  
MULT_DEC DW 10
MULT_OCT DW 8
MULT_BIN DW 2

                         
N=254
INPUT DB N+1, N+2 DUP(?)    
                           


DATA ENDS

SSEG SEGMENT STACK  
  DW 100 DUP (?)
SSEG ENDS

CODE SEGMENT
ASSUME CS:CODE,DS:DATA,SS:SSEG

START:   MOV AX,DATA
         MOV DS,AX     
         
         MOV DX, OFFSET WELCOME_STR
         MOV AH,09H
         INT 21H       
         MOV DL,0AH
         MOV AH , 2
         INT 21H   
         MOV DL, 13
         MOV AH, 02H
         INT 21H   
                    
         
RE_CONVERT:
         MOV DX, OFFSET ENTER_BASE_STR
         MOV AH,09H
         INT 21H             
         MOV DL,0AH
         MOV AH , 2
         INT 21H   
         MOV DL, 13
         MOV AH, 02H
         INT 21H        
         
         MOV DX, OFFSET OPTIONS_STR
         MOV AH,09H
         INT 21H             
         MOV DL,0AH
         MOV AH , 2
         INT 21H   
         MOV DL, 13
         MOV AH, 02H
         INT 21H 
         
         MOV AH , 1
         INT 21H 
         MOV BASE, AL  
         MOV DL,0AH
         MOV AH , 2
         INT 21H   
         MOV DL, 13
         MOV AH, 02H
         INT 21H  
  
         
         MOV DX, OFFSET ENTER_NUM_STR
         MOV AH,09H
         INT 21H 
         MOV DL,0AH
         MOV AH , 2
         INT 21H   
         MOV DL, 13
         MOV AH, 02H
         INT 21H  
                                
         MOV DX, OFFSET INPUT  
         MOV AH,0AH
         INT 21H
         MOV DL,0AH
         MOV AH , 2
         INT 21H   
         MOV DL, 13
         MOV AH, 02H
         INT 21H  
         
         CMP BASE,'B' ;CHECK BASE TYPE 
         JE  BINARY 
         
         CMP BASE, 'O'
         JE OCTAL   
         
         CMP  BASE,'D'
         JE DECIMAL  
         
         CMP BASE,'H'
         JE HEXA        
         
         
         
PRING_ERR_MSG: 
         MOV DX, OFFSET ERR_MSG  ;PRINT ERROR MSG AND JUMP TO START
         MOV AH,09H
         INT 21H       
         MOV DL,0AH
         MOV AH , 2
         INT 21H   
         MOV DL, 13
         MOV AH, 02H
         INT 21H   
         JMP RE_CONVERT    
         

         
         
         
BINARY:    
         CALL  IS_LEGAL_B ;CHECK IF NUMBER IS LEGAL
         CMP AL,-1
         JE PRING_ERR_MSG 
         JMP PRINT_INPUT 
        
         
OCTAL:
        CALL IS_LEGAL_O 
        CMP AL,-1
        JE PRING_ERR_MSG 
        JMP PRINT_INPUT
        
DECIMAL:
        CALL IS_LEGAL_D 
        CMP AL,-1
        JE PRING_ERR_MSG  
        CALL CONVERT_DECI_INPUT
        JMP PRINT_INPUT
                                   
HEXA:     
        CALL IS_LEGAL_H 
        CMP AL,-1
        JE PRING_ERR_MSG 
        
        
        
        
PRINT_INPUT:                          ;PRINTING THE INPUT BEFORE THE RESULTE
         MOV DX, OFFSET YOUR_INPUT_STR
         MOV AH,09H
         INT 21H  
          
         XOR CH,CH  
         MOV CL,INPUT[1]
         MOV DI,2
PRINT_INPUT_LOOP:
         MOV DL,INPUT[DI]
         MOV AH , 2
         INT 21H  
         INC DI
         LOOP PRINT_INPUT_LOOP
         MOV DL,'('
         MOV AH , 2
         INT 21H 
         MOV DL,BASE
         MOV AH , 2
         INT 21H 
         MOV DL,')'
         MOV AH , 2
         INT 21H 
         MOV DL,0AH
         MOV AH , 2
         INT 21H   
         MOV DL, 13
         MOV AH, 02H
         INT 21H 
           
         MOV DX, OFFSET CONVERTED_VAL_STR
         MOV AH,09H
         INT 21H 
         MOV DL,0AH
         MOV AH , 2
         INT 21H   
         MOV DL, 13
         MOV AH, 02H
         INT 21H  
         
         
         ; PRINTING RESULT
                          
         CMP BASE,'B'          
         JNE  OCTAL_CHK
         CALL CONVERT_BIN_TO_DEC  
         CALL CONVERT_DEC_TO_HEX  
         CALL CONVERT_DEC_TO_OCT
         CALL PRINT_OCT_NUMBER 
         CALL CONVERT_DECI_DECI_STR
         CALL PRINT_DEC_NUMBER
         CALL PRINT_HEX_NUMBER 
         JMP IF_REDU  
         
OCTAL_CHK:
         CMP BASE, 'O'
         JNE DECIMAL_CHK
         CALL CONVERT_OCT_TO_DEC  
         CALL CONVERT_DEC_TO_HEX 
         CALL CONVERT_DEC_TO_BIN
         CALL PRINT_BIN_NUMBER 
         CALL PRINT_HEX_NUMBER 
         CALL CONVERT_DECI_DECI_STR
         CALL PRINT_DEC_NUMBER   
          
         JMP IF_REDU  
         
DECIMAL_CHK:
         CMP  BASE,'D'
         JNE HEXA_CHK 
         CALL CONVERT_DEC_TO_HEX 
         CALL CONVERT_DEC_TO_BIN
         CALL CONVERT_DEC_TO_OCT 
         CALL PRINT_BIN_NUMBER 
         CALL PRINT_HEX_NUMBER
         CALL PRINT_OCT_NUMBER   
         JMP IF_REDU
           
         
HEXA_CHK:
        CALL CONVERT_HEX_TO_DEC 
        CALL CONVERT_DEC_TO_OCT 
        CALL CONVERT_DEC_TO_BIN
        CALL PRINT_BIN_NUMBER 
        CALL PRINT_OCT_NUMBER 
        CALL CONVERT_DECI_DECI_STR
        CALL PRINT_DEC_NUMBER   
                           
        
        
      
         
IF_REDU:        
         MOV DX, OFFSET ANOTHER_NUM ; IF THE USER WANTS TO CONVERT ANOTHER NUMBER
         MOV AH,09H
         INT 21H             
         MOV DL,0AH
         MOV AH , 2
         INT 21H   
         MOV DL, 13
         MOV AH, 02H
         INT 21H   
         
         MOV AH , 1
         INT 21H 
         MOV BASE, AL  
         MOV DL,0AH
         MOV AH , 2
         INT 21H   
         MOV DL, 13
         MOV AH, 02H
         INT 21H   
         
         CMP BASE,'Y'
         JE RE_CONVERT      
                              
                                   

EXIT:    MOV AH,4CH
         INT 21H 
         
         
         
         
           
         
IS_LEGAL_B:   
             MOV DI,2
             XOR CH,CH
             MOV CL, INPUT[1]
    CHECK_B: 
            CMP INPUT[DI],'0'
            JL BAD
            CMP INPUT[DI],'1'    
            JG BAD      
            INC DI
            LOOP CHECK_B   
            MOV AL,0
            JMP END_B
    BAD:    MOV AL,-1        
    END_B:        
            RET   
            
IS_LEGAL_O:
             MOV DI,2
             XOR CH,CH
             MOV CL, INPUT[1]
    CHECK_O: 
            CMP INPUT[DI],'0'
            JL BAD_O
            CMP INPUT[DI],'7'    
            JG BAD_O      
            INC DI
            LOOP CHECK_O   
            MOV AL,0
            JMP END_O
    BAD_O:  MOV AL,-1        
    END_O:        
            RET       
                        
IS_LEGAL_D:    
             MOV DI,2
             XOR CH,CH
             MOV CL, INPUT[1]
    CHECK_D: 
            CMP INPUT[DI],'0'
            JL BAD_D
            CMP INPUT[DI],'9'    
            JG BAD_D      
            INC DI
            LOOP CHECK_D  
            MOV AL,0
            JMP END_D
    BAD_D:  MOV AL,-1        
    END_D:        
            RET 
              
            
IS_LEGAL_H:   
             MOV DI,2
             XOR CH,CH
             MOV CL, INPUT[1]
    CHECK_H: 
            CMP INPUT[DI],'0'
            JL BAD_H
            CMP INPUT[DI],'F'    
            JG BAD_H 
            CMP INPUT[DI],'9'    
            JNG LEGAL_H_DIGIT          
            CMP INPUT[DI],'A'                                                                           
            JL BAD_H
LEGAL_H_DIGIT:
            INC DI
            LOOP CHECK_H  
            MOV AL,0
            JMP END_H
    BAD_H:  MOV AL,-1        
    END_H:        
            RET   
                 
                 
                 
                 
            
CONVERT_HEX_TO_DEC:                             ;CONVERTNG HEXA TO DECIMAL
             XOR AX,AX  
             MOV AL,INPUT[1] 
             MOV DI,AX 
             INC DI
             MOV SI,0 
             MOV BX,16
             XOR CH,CH
             MOV CL, INPUT[1] 
             
              
NEXT_H_DIGIT: 
            XOR AX,AX 
            MOV AL,INPUT[DI]   
            MOV VALUE,AX
            CMP INPUT[DI],'9'
            JLE  NUM 
            JG LETTER 
          
NUM:        
            SUB VALUE,'0'
            MOV DX,VALUE
            CMP SI,0
            JE FIRS_DIG_H
            JMP BEFORE_H_LOOP
           
LETTER:     
            
            SUB VALUE,'7' ;11 LESS THAN A
            MOV DX,VALUE  
            CMP SI,0
            JE FIRS_DIG_H
                
BEFORE_H_LOOP:
            MOV AL,DL 
            XOR DX,DX
            MUL BX
            ADD DECI,AX 
            MOV AX,BX
            MUL MULT_HEX
            MOV BX,AX 
            JMP SKIP_H
FIRS_DIG_H:
             MOV DECI,DX
SKIP_H:  
             DEC DI
             INC SI          
             LOOP NEXT_H_DIGIT 
      
             RET    
             
            
CONVERT_OCT_TO_DEC:          ;CONVERTING OCTAL TO DECIMAL
             XOR AX,AX  
             MOV AL,INPUT[1] 
             MOV DI,AX 
             INC DI
             MOV SI,0 
             MOV BX,8
             XOR CH,CH
             MOV CL, INPUT[1] 
             
              
NEXT_O_DIGIT: 
            XOR AX,AX 
            MOV AL,INPUT[DI]   
            MOV VALUE,AX
            
            SUB VALUE,'0'
            MOV DX,VALUE
            CMP SI,0
            JE FIRS_DIG_O
            JMP BEFORE_O_LOOP
                
BEFORE_O_LOOP:
            MOV AL,DL
            MUL BX       
            ADD DECI,AX
            MOV AX,BX
            MUL MULT_OCT
            MOV BX,AX 
            JMP SKIP_O
FIRS_DIG_O:
             MOV DECI,DX 
SKIP_O:  
             DEC DI
             INC SI          
             LOOP NEXT_O_DIGIT 
      
             RET    
             
CONVERT_BIN_TO_DEC:              ;CONVERT BINARY TO DEC
             XOR AX,AX  
             MOV AL,INPUT[1] 
             MOV DI,AX 
             INC DI
             MOV SI,0 
             MOV BX,2
             XOR CH,CH
             MOV CL, INPUT[1] 
             
              
NEXT_B_DIGIT:   
            XOR AX,AX
            MOV AL,INPUT[DI]   
            MOV VALUE,AX 
            
            SUB VALUE,'0'
            MOV DX,VALUE
            CMP SI,0
            JE FIRS_DIG_B
            JMP BEFORE_B_LOOP
                
BEFORE_B_LOOP:
            MOV AL,DL
            MUL BX       
            ADD DECI,AX
            MOV AX,BX
            MUL MULT_BIN
            MOV BX,AX 
            JMP SKIP_B
FIRS_DIG_B:
             MOV DECI,DX 
SKIP_B:  
             DEC DI
             INC SI          
             LOOP NEXT_B_DIGIT 
      
             RET  
             
             
CONVERT_DEC_TO_HEX:      ;CONVERT DECIMAL TO HEXA  
             MOV HEX[0],0
             MOV DI,1
             MOV AX,DECI
DEC_HEX_LOOP:
             XOR DX,DX                   
             IDIV MULT_HEX 
             CMP DL,9
             JLE NUMBER_HEX  
             ADD DL,55 
             JMP HEX_BEFORE_LOOP
NUMBER_HEX: 
             ADD DL,'0'     
HEX_BEFORE_LOOP:  
             MOV HEX[DI],DL
             INC DI
             INC HEX[0]
             CMP AX,0
             JNE DEC_HEX_LOOP  
             
             RET  
             
CONVERT_DEC_TO_OCT:      ;CONVERT DECIMAL  TO OCTA   
             MOV OCT[0],0
             MOV DI,1
             MOV AX,DECI
DEC_OCT_LOOP:
             XOR DX,DX                   
             IDIV MULT_OCT 
             ADD DL,'0'       
             MOV OCT[DI],DL
             INC DI
             INC OCT[0]
             CMP AX,0
             JNE DEC_OCT_LOOP  
             
             RET  
             
             
              
             
CONVERT_DEC_TO_BIN:     ;CONVERT DECIMAL TO BINARY
             MOV BIN[0],0
             MOV DI,1
             MOV AX,DECI
DEC_BIN_LOOP:
             XOR DX,DX                   
             IDIV MULT_BIN 
             ADD DL,'0'       
             MOV BIN[DI],DL
             INC DI
             INC BIN[0]
             CMP AX,0
             JNE DEC_BIN_LOOP  
             
             RET             
             
PRINT_OCT_NUMBER:
            XOR CH,CH 
            MOV CL,OCT[0]  
            MOV DI,CX
PRNT_OCT:                     ;PRINT OCTAL RESAULT
            
            MOV DL,OCT[DI]
            MOV AH , 2
            INT 21H  
            DEC DI
            LOOP PRNT_OCT  
            MOV CL,21   
            SUB CL,OCT[0]
            
SPACES_OCT:
            MOV DL,' '
            MOV AH , 2
            INT 21H       
            LOOP SPACES_OCT   
            
            MOV DX, OFFSET OCT_STR
            MOV AH,09H
            INT 21H  
              
            MOV DL,0AH
            MOV AH , 2
            INT 21H   
            MOV DL, 13
            MOV AH, 02H
            INT 21H   
            RET  
            
             
PRINT_HEX_NUMBER:
            XOR CH,CH 
            MOV CL,HEX[0]  
            MOV DI,CX
            
PRNT_HEX:                     ;PRINT HEXA RESAULT
            
            MOV DL,HEX[DI]
            MOV AH , 2
            INT 21H  
            DEC DI
            LOOP PRNT_HEX
            MOV CL,21   
            SUB CL,HEX[0]
            
SPACES_HEX:
            MOV DL,' '
            MOV AH , 2
            INT 21H       
            LOOP SPACES_HEX
            
            MOV DX, OFFSET HEX_STR
            MOV AH,09H
            INT 21H    
            MOV DL,0AH
            MOV AH , 2
            INT 21H   
            MOV DL, 13
            MOV AH, 02H
            INT 21H 
            RET    
                  
                  
                  
PRINT_BIN_NUMBER:
            XOR CH,CH 
            MOV CL,BIN[0]  
            MOV DI,CX
            
PRNT_BIN:                     ;PRINT BINARY RESAULT
            
            MOV DL,BIN[DI]
            MOV AH , 2
            INT 21H  
            DEC DI
            LOOP PRNT_BIN    
            MOV CL,21   
            SUB CL,BIN[0]
            
SPACES_BIN:
            MOV DL,' '
            MOV AH , 2
            INT 21H       
            LOOP SPACES_BIN
            
            MOV DX, OFFSET BIN_STR
            MOV AH,09H
            INT 21H                       
            MOV DL,0AH
            MOV AH , 2
            INT 21H   
            MOV DL, 13
            MOV AH, 02H
            INT 21H   
            RET  
            
CONVERT_DECI_DECI_STR:   
             MOV DECI_STR[0],0
             MOV DI,1
             MOV AX,DECI
DEC_DECI_STR_LOOP:
             XOR DX,DX                   
             IDIV MULT_DEC 
             ADD DL,'0'       
             MOV DECI_STR[DI],DL
             INC DI
             INC DECI_STR[0]
             CMP AX,0
             JNE DEC_DECI_STR_LOOP      
             RET      


                              
PRINT_DEC_NUMBER:      ; PRINT DECIMAL NUMBER
            XOR CH,CH 
            MOV CL,DECI_STR[0]  
            MOV DI,CX
            
PRNT_DEC:                     
            
            MOV DL,DECI_STR[DI]
            MOV AH , 2
            INT 21H  
            DEC DI
            LOOP PRNT_DEC
            
            MOV CL,21   
            SUB CL,DECI_STR[0]
            
SPACES_DEC:
            MOV DL,' '
            MOV AH , 2
            INT 21H       
            LOOP SPACES_DEC 
            
            MOV DX, OFFSET DEC_STR
            MOV AH,09H
            INT 21H                       
            MOV DL,0AH
            MOV AH , 2
            INT 21H   
            MOV DL, 13
            MOV AH, 02H
            INT 21H   
            RET  
            
            
CONVERT_DECI_INPUT:  ;CONVERT INPUT STRING TO DECI VALUE  
        MOV DECI,0       
        XOR CH,CH          
        XOR AX,AX
        MOV CL, INPUT[1] 
        DEC CL         
        MOV DI,2      
        MOVE_TO_DECI: 
        XOR AX,AX
        MOV Al,INPUT[DI]        
        SUB AX,'0' 
        ADD DECI,AX
        MOV AX,DECI
        IMUL MULT_DEC
        MOV DECI,AX    
        INC DI
        LOOP MOVE_TO_DECI 
        XOR AX,AX
        MOV AL,INPUT[DI]        
        SUB AL,'0' 
        ADD DECI,AX                        
            
        RET    
                                         
                    
                            
        

CODE ENDS
END START
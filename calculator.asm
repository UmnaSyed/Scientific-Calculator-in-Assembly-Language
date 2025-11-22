INCLUDE Irvine32.inc

.data
menu BYTE 0Dh,0Ah,'1.Addition 2.Subtraction 3.Multiplication 4.Division 5.Power 6.Factorial 7.Square 8.Cube 9.%',0Dh,0Ah,\
                      '10.Matrix Addition 11.Matrix Multiplication 12.Permutation 13.Combination 14. Trignometric Functions 0.Exit',0Dh,0Ah,\

msgOpt BYTE "Enter your choice: ", 0
msgIn1  BYTE "Enter First number: ", 0
msgIn2 BYTE "Enter Second number: ", 0
msgBase BYTE "Enter Base number: ",
msgArows BYTE "Enter Matrix A Row Size (UPTO 3): ", 0
msgBrows BYTE "Enter Matrix B Row Size (UPTO 3): ", 0
msgAcols BYTE "Enter Matrix A Column Size (UPTO 3): ", 0
msgBcols BYTE "Enter Matrix B Column Size (UPTO 3): ", 0
msgCresult BYTE "Resultant Matrix: ", 0
msgA BYTE "Enter Matrix A Elements (Row-Wise)", 0
msgB BYTE "Enter Matrix B Elements (Row-Wise)", 0
matERR BYTE "Invalid Matrix Size!", 0
msgResult BYTE "Answer: ", 0
menuMsg BYTE "Choose an option:",0Dh,0Ah,
         "1. sin(x)",0Dh,0Ah,
         "2. cos(x)",0Dh,0Ah,
         "3. tan(x)",0Dh,0Ah,
         "4. Return to Main Menu",0Dh,0Ah,
         "Enter choice: ",0

angleMsg  BYTE "Enter angle in degrees: ",0
resultMsg BYTE "Result = ",0

degToRad  REAL8 0.017453292519943295    ; PI / 180
mul_10000 REAL8 10000.0

choice DWORD ?
num1 SDWORD ?
num2 SDWORD ?
rowsA DWORD ?
rowsB DWORD ?
colsA DWORD ?
colsB DWORD ?
matrixA SDWORD 9 DUP(0)
matrixB SDWORD 9 DUP(0)
matrixC SDWORD 9 DUP(0)
result SDWORD ?
tempInt DWORD ?

.code

Fact PROC
    push ebp
    mov  ebp, esp

    mov eax, [ebp+8]     
    cmp eax, 1
    jbe BaseCase         

    dec eax
    push eax
    call Fact           
    
    mov ebx, [ebp+8]     
    mul ebx
    jmp Done

BaseCase:
    mov eax, 1

Done:
    mov esp, ebp
    pop ebp
    ret 4
Fact ENDP

Cube PROC
    mov ebx, eax
    imul eax, ebx
    imul eax, ebx
    ret
Cube ENDP

calculatepercent PROC
    push ebp
    mov ebp, esp

    mov eax, [ebp+12]   
    mov ebx, [ebp+8]    
    imul ebx           
    mov ecx, 100
    cdq
    idiv ecx            

    pop ebp
    ret 8
calculatepercent ENDP

nCrfunc PROC
    push ebp
    mov ebp, esp

    mov eax, [ebp+12]
    push eax
    call Fact
    mov esi, eax     

    mov eax, [ebp+8]
    push eax
    call Fact
    mov edi, eax    

    mov eax, [ebp+12]
    sub eax, [ebp+8]  
    push eax
    call Fact
    mov ebx, eax      

    mov eax, edi
    imul ebx          
    mov ebx, eax

    mov eax, esi     
    cdq
    idiv ebx          

    pop ebp
    ret 8
nCrfunc ENDP

TrigonometricCalculation PROC

main_loop:
    mov edx, OFFSET menuMsg
    call WriteString

    call ReadInt
    mov ebx, eax          

    cmp ebx, 4
    je done               

    cmp ebx, 1
    je do_sin
    cmp ebx, 2
    je do_cos
    cmp ebx, 3
    je do_tan

    jmp main_loop         

do_sin:
    call ReadAngleToST0
    fsin
    call PrintFixedFloat
    jmp main_loop

do_cos:
    call ReadAngleToST0
    fcos
    call PrintFixedFloat
    jmp main_loop

do_tan:
    call ReadAngleToST0
    fptan
    fstp st(0)           
    call PrintFixedFloat
    jmp main_loop


done:
    ret
TrigonometricCalculation ENDP


ReadAngleToST0 PROC
    mov edx, OFFSET angleMsg
    call WriteString
    call ReadFloat            

    fld degToRad              
    fmulp st(1), st(0)        
    ret
ReadAngleToST0 ENDP

PrintFixedFloat PROC
    mov edx, OFFSET resultMsg
    call WriteString

    fld mul_10000            
    fmulp st(1), st(0)        

    fistp tempInt             

    mov eax, tempInt
    mov ebx, 10000
    xor edx, edx
    div ebx                 

    call WriteDec             
    mov al, '.'
    call WriteChar

    mov eax, edx
    mov ecx, 4                

printFracLoop:
    mov ebx, 10
    xor edx, edx
    div ebx
    push dx
    loop printFracLoop

    mov ecx, 4
printDigits:
    pop dx
    add dl, '0'
    mov al, dl
    call WriteChar
    loop printDigits

    call CrLf
    call CrLf
    ret
PrintFixedFloat ENDP



main PROC

mainMenu:
    mov edx, OFFSET menu
    call WriteString
    mov edx, OFFSET msgOpt
    call WriteString
    call ReadInt
    mov choice, eax

    cmp choice, 0
    JE exit_prog

    cmp choice, 1
    JE add_proc

    cmp choice, 2
    JE sub_proc

    cmp choice, 3
    JE mul_proc

    cmp choice, 4
    JE div_proc

    cmp choice, 5
    JE pow_proc

    cmp choice, 6
    JE fact_proc

    cmp choice, 7
    JE sq_proc

    cmp choice, 8
    JE cube_proc

    cmp choice, 9
    JE percentage_proc

    cmp choice, 10
    JE matrix_add

    cmp choice, 11
    JE matrix_mul

    cmp choice, 12
    JE perm_proc

    cmp choice, 13
    JE comb_proc

    cmp choice, 14
    JE trig_func

    jmp mainMenu

add_proc PROC
    mov edx, OFFSET msgIn1
    call WriteString
    call ReadInt
    mov num1, eax

    mov edx, OFFSET msgIn2
    call WriteString
    call ReadInt
    mov num2, eax

    mov eax, num1
    add eax, num2
    mov result, eax

    mov edx, OFFSET msgResult
    call WriteString
    mov eax, result
    call writeInt
    call Crlf

    jmp mainMenu
add_proc ENDP

sub_proc PROC
    mov edx, OFFSET msgIn1
    call WriteString
    call ReadInt
    mov num1, eax

    mov edx, OFFSET msgIn2
    call WriteString
    call ReadInt
    mov num2, eax

    mov eax, num1
    sub eax, num2
    mov result, eax

    mov edx, OFFSET msgResult
    call WriteString
    mov eax, result
    call writeInt
    call Crlf

    jmp mainMenu
sub_proc ENDP


sq_proc PROC
    mov edx, OFFSET msgBase
    call WriteString
    call ReadInt
    mov num1, eax

    mov eax, num1
    imul eax, eax
    mov result, eax

    mov edx, OFFSET 
    mov edx, OFFSET msgResult
    call WriteString
    mov eax, result
    call writeInt
    call Crlf

    jmp mainMenu
sq_proc ENDP

cube_proc PROC
    mov edx, OFFSET msgIn1
    call WriteString
    call ReadInt

    call Cube       

    mov edx, OFFSET msgResult
    call WriteString
    call WriteInt
    call Crlf

    jmp mainMenu
cube_proc ENDP

fact_proc PROC
    mov edx, OFFSET msgIn1
    call WriteString
    call ReadInt

    push eax
    call Fact       

    mov edx, OFFSET msgResult
    call WriteString
    call WriteInt
    call Crlf

    jmp mainMenu
fact_proc ENDP


trig_func PROC
    call TrigonometricCalculation
    jmp mainMenu
trig_func ENDP

perm_proc PROC
    mov edx, OFFSET msgIn1
    call WriteString
    call ReadInt
    push eax    

    mov edx, OFFSET msgIn2
    call WriteString
    call ReadInt
    push eax     

    call nCrfunc

    mov edx, OFFSET msgResult
    call WriteString
    call WriteInt
    call Crlf

    jmp mainMenu
perm_proc ENDP

percentage_proc PROC
    mov edx, OFFSET msgIn1
    call WriteString
    call ReadInt
    push eax

    mov edx, OFFSET msgIn2
    call WriteString
    call ReadInt
    push eax

    call calculatepercent

    mov edx, OFFSET msgResult
    call WriteString
    call WriteInt
    call Crlf

    jmp mainMenu
percentage_proc ENDP

matrix_mul PROC
    mov edx, OFFSET msgArows
    call WriteString
    call ReadInt
    mov rowsA, eax

    cmp rowsA, 1
    jl MatErr
    cmp rowsA, 3
    jg MatErr

    mov edx, OFFSET msgAcols
    call WriteString
    call ReadInt
    mov colsA, eax

    cmp colsA, 1
    jl MatErr
    cmp colsA, 3
    jg MatErr

    mov edx, OFFSET msgBrows
    call WriteString
    call ReadInt
    mov rowsB, eax

    cmp rowsB, 1
    jl MatErr
    cmp rowsB, 3
    jg MatErr

    mov edx, OFFSET msgBcols
    call WriteString
    call ReadInt
    mov colsB, eax

    cmp colsB, 1
    jl MatErr
    cmp colsB, 3
    jg MatErr

    mov eax, colsA
    cmp eax, rowsB
    jne MatErr

    mov edx, OFFSET msgA
    call WriteString

    mov ecx, rowsA
    mov ebx, colsA
    mov edi, OFFSET matrixA

    readRowsA:
    push ecx
    mov ecx, ebx

    readColsA:
    call ReadInt
    mov [edi], eax
    add edi, 4
    loop readColsA

    pop ecx
    loop readRowsA

    mov edx, OFFSET msgB
    call WriteString

    mov ecx, rowsB
    mov ebx, colsB
    mov edi, OFFSET matrixB

    readRowsB:
    push ecx
    mov ecx, ebx

    readColsB:
    call ReadInt
    mov [edi], eax
    add edi, 4
    loop readColsB

    pop ecx
    loop readRowsB

    mov ecx, 9
    mov edi, OFFSET matrixC

    clearC:
    mov DWORD PTR [edi], 0
    add edi, 4
    loop clearC


    mov esi, 0
    iLoop:
    cmp esi, rowsA
    JGE mulDone

    mov edi, 0
    jLoop:
    cmp ebx, colsA
    JGE next_i

    xor eax, eax
    mov ebx, 0

    kLoop:
    cmp ebx, colsA
    jge storeC

    mov ecx, esi
    imul ecx, colsA
    add ecx, ebx
    mov edx, [matrixA + ecx*4]

    mov ecx, ebx
    imul ecx, colsB
    add ecx, edi
    mov ecx, [matrixB + ecx*4]

    imul edx, ecx
    add eax, edx

    inc ebx
    jmp kLoop

    storeC:
    mov ecx, esi
    imul ecx, colsB
    add ecx, edi
    mov [matrixC + ecx*4], eax
    
    inc edi
    jmp jLoop

    next_i:
    inc esi
    jmp iLoop

    mulDone:
    mov edX, OFFSET msgCresult
    call WriteString
    call Crlf

    mov ecx, rowsA
    mov edi, OFFSET matrixC

    printRows:
    push ecx
    mov ecx, colsB

    printCols:
    mov eax, [edi]
    call WriteInt
    mov al, ' '
    call WriteChar
    add edi, 4
    loop printCols

    call Crlf
    pop ecx
    loop printRows

    jmp mainMenu

    MattErr:
    mov edx, OFFSET matERR
    call WriteString
    call Crlf
    jmp mainMenu

matrix_mul ENDP

exit_prog PROC
    exit

main endp
END main

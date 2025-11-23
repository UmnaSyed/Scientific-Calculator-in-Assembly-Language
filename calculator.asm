INCLUDE Irvine32.inc

.data

menu BYTE 0Dh,0Ah,
           '1. Addition         2. Subtraction                  3. Multiplication',0Dh,0Ah,
           '4. Division         5. Power                        6. Factorial',0Dh,0Ah,
           '7. Square           8. Cube                         9. Percentage',0Dh,0Ah,
           '10. Matrix Addition 11. Matrix Multiplication       12. Permutation',0Dh,0Ah,
           '13. Combination     14. Trigonometric Functions     0. Exit',0Dh,0Ah,0

msgOpt BYTE "Enter your choice: ",0
msgIn1 BYTE "Enter First number: ",0
msgIn2 BYTE "Enter Second number: ",0
msgArows BYTE "Enter Matrix A Row Size (UPTO 3): ",0
msgBrows BYTE "Enter Matrix B Row Size (UPTO 3): ",0
msgAcols BYTE "Enter Matrix A Column Size (UPTO 3): ",0
msgBcols BYTE "Enter Matrix B Column Size (UPTO 3): ",0
msgCresult BYTE "Resultant Matrix: ",0
msgA BYTE "Enter Matrix A Elements (Row-Wise): ",0
msgB BYTE "Enter Matrix B Elements (Row-Wise): ",0
msgResult BYTE "Answer: ",0
space BYTE " ",0
msgDividend BYTE "Enter dividend: ",0
msgDivisor BYTE "Enter divisor: ",0
msgQuotient BYTE "Quotient: ",0
msgRemainder BYTE "Remainder: ",0
msgError BYTE "Error: Division by zero!",0
invalidMsg BYTE "Matrix multiplication not possible!",0
msgBase        BYTE "Enter base: ",0
msgExponent    BYTE "Enter exponent: ",0
msgResultPow   BYTE "Result: ",0
msgFraction    BYTE "Fractional form: ",0
msgDecimal     BYTE "Decimal form: ",0
msgOneOver BYTE "1/", 0
msgOne         BYTE "1",0
msgNegativeOne BYTE "-1",0
msgOverflow BYTE "Error! Overflow.",0
msgN BYTE "Enter n (total items): ",0
msgR BYTE "Enter r (selected items): ",0
msgResultNPR BYTE "nPr result: ",0
msgResultNCR BYTE "nCr result: ",0
nCrMsg BYTE "nCr result: ",0
msgErrorNPR BYTE "Error: r cannot be greater than n!",0
triMenu    BYTE "----- Trigonometric Menu -----",0dh,0ah,
                  "1. sin(x)",0dh,0ah,
                  "2. cos(x)",0dh,0ah,
                  "3. tan(x)",0dh,0ah,
                  "4. Back to Main Menu",0dh,0ah,
                  "Enter choice: ",0

angleMsg   BYTE "Enter angle in degrees: ",0
perSymb BYTE "%",0


choice DWORD ?
num1 SDWORD ?
num2 SDWORD ?
rowsA DWORD ?
rowsB DWORD ?
colsA DWORD ?
colsB DWORD ?
n_value DWORD ?
r_value DWORD ?
nMINUSr DWORD ?
nfact DWORD ?
rfact DWORD ?
nMINUSrFact DWORD ?
resultNPR DWORD 1
base SDWORD ?
exponent SDWORD ?
temp SDWORD ?
decimalResult  REAL8 ?
matrixA SDWORD 9 DUP(0)
matrixB SDWORD 9 DUP(0)
matrixC SDWORD 9 DUP(0)
totalElements DWORD ?
result SDWORD ?
product SDWORD ?
quotient SDWORD ?
remainder SDWORD ?
tempInt DWORD ?
degToRad REAL8 0.017453292519943295
mul_10000 REAL8 10000.0

.code

addProc PROC
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
    call WriteInt
    call Crlf
    ret
addProc ENDP

subProc PROC
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
    call WriteInt
    call Crlf
    ret
subProc ENDP

Multiplication PROC
    mov edx, OFFSET msgIn1
    call WriteString
    call ReadInt
    mov ebx, eax

    mov edx, OFFSET msgIn2
    call WriteString
    call ReadInt
    mov ecx, eax

    mov eax, ebx
    imul ecx
    mov product, eax    

    mov edx, OFFSET msgResult
    call WriteString
    call WriteInt
    call Crlf
    ret
Multiplication ENDP

DivisionOperation PROC

    mov edx, OFFSET msgDividend
    call WriteString
    call ReadInt
    mov ebx, eax

    mov edx, OFFSET msgDivisor
    call WriteString
    call ReadInt
    mov ecx, eax

    cmp ecx, 0
    jne PerformDivision
    
    mov edx, OFFSET msgError
    call WriteString
    call Crlf
    ret

PerformDivision:
    mov eax, ebx
    cdq
    idiv ecx

    mov quotient, eax
    mov remainder, edx

    mov edx, OFFSET msgQuotient
    call WriteString
    mov eax, quotient
    call WriteInt
    call Crlf

    mov edx, OFFSET msgRemainder
    call WriteString
    mov eax, remainder
    call WriteInt
    call Crlf

    ret
DivisionOperation ENDP

Fact PROC
    mov eax, num1        ; load the number for factorial
    cmp eax, 0
    je FactDone
    mov ecx, eax         ; counter
    mov eax, 1           ; accumulator for result

    FactLoop:
    imul eax, ecx        ; multiply accumulator by counter
    loop FactLoop

    FactDone:
    mov result, eax      ; store result
    ret
Fact ENDP


sqProc PROC
    mov edx, OFFSET msgBase
    call WriteString
    call ReadInt
    mov num1, eax

    mov eax, num1
    imul eax, eax
    mov result, eax

    mov edx, OFFSET msgResult
    call WriteString
    mov eax, result
    call WriteDec
    call Crlf
    ret
sqProc ENDP

CubeProc PROC
    push ebp
    mov ebp, esp

    mov eax, [ebp+8]
    mov ebx, eax
    mul ebx
    mul ebx

    mov edx, OFFSET msgResult
    call WriteString
    call WriteInt
    call CrLf
    call CrLf

    pop ebp
    ret 4
CubeProc ENDP

PercentProc PROC
    push ebp
    mov ebp, esp

    mov eax, [ebp+12]   
    mov ebx, [ebp+8]    
    mov ecx, 100
    xor edx, edx

    mul ebx
    div ecx

    mov edx, OFFSET msgResult
    call WriteString
    call WriteInt
    mov edx, OFFSET perSymb
    call WriteString
    call CrLf
    call CrLf

    pop ebp
    ret 8
PercentProc ENDP


PowerCalculation PROC
    mov  edx, OFFSET msgBase
    call WriteString
    call ReadInt
    mov  base, eax

    mov  edx, OFFSET msgExponent
    call WriteString
    call ReadInt
    mov  exponent, eax
 
    cmp  exponent, 0
    jne  NotZero
    mov  eax, 1
    jmp  DisplayIntegerResult

NotZero:
    cmp  exponent, 0
    jg   PositiveExponent

    jmp  NegativeExponent

PositiveExponent:
    mov  eax, 1         
    mov  ecx, exponent   
    mov  ebx, base

PosPowLoop:
    imul ebx
    loop PosPowLoop
    jmp  DisplayIntegerResult

NegativeExponent:
    mov  eax, exponent
    neg  eax
    mov  ecx, eax        
    mov  ebx, base

    ; special cases
    cmp  ebx, 1
    je   BaseIsOne
    cmp  ebx, -1
    je   BaseIsNegOne

    mov  eax, 1         

NegPowLoop:
    imul ebx
    loop NegPowLoop

    mov  result, eax    

    mov  edx, OFFSET msgResultPow
    call WriteString
    call Crlf

    mov  edx, OFFSET msgFraction
    call WriteString

    mov  edx, OFFSET msgOneOver
    call WriteString      

    mov  eax, result
    call WriteDec         
    call Crlf
    jmp  Done

BaseIsOne:
    mov  eax, 1
    jmp  DisplayIntegerResult

BaseIsNegOne:
    mov  eax, exponent
    test eax, 1          
    jz   EvenExp
    mov  eax, -1
    jmp  DisplayIntegerResult

EvenExp:
    mov  eax, 1
    jmp  DisplayIntegerResult

DisplayIntegerResult:
    mov  result, eax
    mov  edx, OFFSET msgResultPow
    call WriteString
    call WriteInt
    call Crlf
    jmp  Done

Done:
    ret
PowerCalculation ENDP


PermutationCalculation PROC
    mov edx, OFFSET msgN
    call WriteString
    call ReadInt
    mov n_value, eax

    mov edx, OFFSET msgR
    call WriteString
    call ReadInt
    mov r_value, eax

    cmp eax, n_value
    ja PermError

    mov eax, n_value
    mov num1, eax
    call Fact
    mov ebx, result       

    mov eax, n_value
    sub eax, r_value
    mov num1, eax
    call Fact
    mov ecx, result     

    mov eax, ebx
    xor edx, edx          
    div ecx
    mov resultNPR, eax

    mov edx, OFFSET msgResultNPR
    call WriteString
    mov eax, resultNPR
    call WriteDec
    call Crlf

    ret

PermError:
    mov edx, OFFSET msgErrorNPR
    call WriteString
    call Crlf
    ret

PermutationCalculation ENDP

CombinationCalculation PROC
    mov edx, OFFSET msgN
    call WriteString
    call ReadInt
    mov n_value, eax

    mov edx, OFFSET msgR
    call WriteString
    call ReadInt
    mov r_value, eax

    ; Validate r <= n
    mov eax, r_value
    cmp eax, n_value
    jle ContinueCalc

    mov edx, OFFSET msgErrorNPR
    call WriteString
    call Crlf
    ret

ContinueCalc:
    ; ---------- Calculate n! ----------
    mov eax, n_value
    mov num1, eax
    call Fact
    mov eax, result
    mov nfact, eax        ; store n!

    mov eax, r_value
    mov num1, eax
    call Fact
    mov eax, result
    mov rfact, eax        

    mov eax, n_value
    sub eax, r_value
    mov nMINUSr, eax
    mov num1, eax
    call Fact
    mov eax, result
    mov nMINUSrFact, eax 

    mov eax, rfact
    imul nMINUSrFact
    mov ecx, eax            

    mov eax, nfact
    xor edx, edx
    div ecx
    mov resultNPR, eax      

    mov edx, OFFSET msgResultNCR
    call WriteString
    mov eax, resultNPR
    call WriteDec
    call Crlf

    ret
CombinationCalculation ENDP



MatrixAddition PROC
    mov edx, OFFSET msgArows
    call WriteString
    call ReadInt
    mov rowsA, eax

    mov edx, OFFSET msgAcols
    call WriteString
    call ReadInt
    mov colsA, eax

    mov eax, rowsA
    mul colsA
    mov totalElements, eax

    mov edx, OFFSET msgA
    call WriteString
    call Crlf
    mov esi, OFFSET matrixA
    mov ecx, totalElements

ReadA:
    call ReadInt
    mov [esi], eax
    add esi, 4
    loop ReadA

    mov edx, OFFSET msgB
    call WriteString
    call Crlf
    mov esi, OFFSET matrixB
    mov ecx, totalElements

ReadB:
    call ReadInt
    mov [esi], eax
    add esi, 4
    loop ReadB

    mov esi, OFFSET matrixA
    mov edi, OFFSET matrixB
    mov ebx, OFFSET matrixC
    mov ecx, totalElements

AddLoop:
    mov eax, [esi]
    add eax, [edi]
    mov [ebx], eax
    add esi, 4
    add edi, 4
    add ebx, 4
    loop AddLoop

    mov edx, OFFSET msgCresult
    call WriteString
    call Crlf

    mov ecx, rowsA      
    mov ebx, 0           
    mov esi, OFFSET matrixC

PrintRows:
    cmp ebx, rowsA
    jge EndPrintRows
    mov ecx, colsA      
    mov edi, 0         

PrintCols:
    cmp edi, colsA
    jge NextRow
    mov eax, [esi]
    call WriteInt
    mov edx, OFFSET space
    call WriteString
    add esi, 4
    inc edi
    jmp PrintCols

NextRow:
    call Crlf
    inc ebx
    jmp PrintRows

EndPrintRows:
    ret

MatrixAddition ENDP

matrixMulProc PROC
    mov edx, OFFSET msgArows
    call WriteString
    call ReadInt
    mov rowsA, eax

    mov edx, OFFSET msgAcols
    call WriteString
    call ReadInt
    mov colsA, eax

    mov edx, OFFSET msgBrows
    call WriteString
    call ReadInt
    mov rowsB, eax

    mov edx, OFFSET msgBcols
    call WriteString
    call ReadInt
    mov colsB, eax

    mov eax, colsA
    cmp eax, rowsB
    jne invalidMul

    mov ecx, 9
    mov edi, OFFSET matrixC
    xor eax, eax

zeroLoop:
    mov [edi], eax
    add edi, 4
    loop zeroLoop

    mov edx, OFFSET msgA
    call WriteString
    mov esi, OFFSET matrixA
    mov ecx, rowsA

readARows:
    push ecx
    mov ecx, colsA

readACols:
    call ReadInt
    mov [esi], eax
    add esi, 4
    loop readACols
    pop ecx
    loop readARows

    mov edx, OFFSET msgB
    call WriteString
    mov esi, OFFSET matrixB
    mov ecx, rowsB

readBRows:
    push ecx
    mov ecx, colsB

readBCols:
    call ReadInt
    mov [esi], eax
    add esi, 4
    loop readBCols
    pop ecx
    loop readBRows

    ; multiply
    mov eax,0
    xor edi, edi      
    mov ebx,0         
iLoop:
    cmp ebx, rowsA
    jge doneMul
    mov ecx,0        
jLoop:
    cmp ecx, colsB
    jge nextI
    xor edx, edx      
    mov esi,0        
kLoop:
    cmp esi, colsA
    jge storeC

    mov eax, ebx
    imul eax, colsA
    add eax, esi
    mov eax, [matrixA + eax*4]

    mov edi, esi
    imul edi, colsB
    add edi, ecx
    mov edi, [matrixB + edi*4]
    imul eax, edi
    add edx, eax
    inc esi
    jmp kLoop
storeC:
    mov eax, ebx
    imul eax, colsB
    add eax, ecx
    mov [matrixC + eax*4], edx
    inc ecx
    jmp jLoop
nextI:
    inc ebx
    jmp iLoop
doneMul:
    ; print result
    mov edx, OFFSET msgCresult
    call WriteString
    call Crlf
    mov ebx,0
printRows:
    cmp ebx, rowsA
    jge endPrint
    mov ecx,0
printCols:
    cmp ecx, colsB
    jge nextPrintRow
    mov eax, ebx
    imul eax, colsB
    add eax, ecx
    mov eax, [matrixC + eax*4]
    call WriteInt
    mov edx, OFFSET space
    call WriteString
    inc ecx
    jmp printCols
nextPrintRow:
    call Crlf
    inc ebx
    jmp printRows
endPrint:
    ret
invalidMul:
    mov edx, OFFSET invalidMsg
    call WriteString
    call Crlf
    ret
matrixMulProc ENDP


TrigonometricCalculation PROC

tri_loop:
    mov edx, OFFSET triMenu
    call WriteString
    call ReadInt
    mov ebx, eax

    cmp ebx, 1
    je do_sin
    cmp ebx, 2
    je do_cos
    cmp ebx, 3
    je do_tan
    cmp ebx, 4
    je tri_done
    jmp tri_loop

do_sin:
    call ReadAngleToST0
    fsin
    call PrintFixedFloat
    jmp tri_loop

do_cos:
    call ReadAngleToST0
    fcos
    call PrintFixedFloat
    jmp tri_loop

do_tan:
    call ReadAngleToST0
    fptan
    fstp st(0)
    call PrintFixedFloat
    jmp tri_loop

tri_done:
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
    mov edx, OFFSET msgResult
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

print_frac:
    mov ebx, 10
    xor edx, edx
    div ebx
    push dx
    loop print_frac

    mov ecx, 4
print_digits:
    pop dx
    add dl, '0'
    mov al, dl
    call WriteChar
    loop print_digits

    call CrLf
    call CrLf
    ret
PrintFixedFloat ENDP

exitProg PROC
    exit
exitProg ENDP


main PROC
mainMenu:
    mov edx, OFFSET menu
    call WriteString

    mov edx, OFFSET msgOpt
    call WriteString
    call ReadInt
    mov choice, eax

    cmp choice, 0
    JE exitProg

    cmp choice, 1
    JE doAdd

    cmp choice, 2
    JE doSub

    cmp choice, 3
    JE doMul

    cmp eax, 4
    JE doDivision

    cmp eax, 5
    JE doPower

    cmp eax, 6
    JE doFactorial

    cmp choice, 7
    JE doSquare

    cmp eax, 8
    je doCube

    cmp eax, 9
    je doPercentage

    cmp choice, 10
    JE doMatrixAdd

    cmp choice, 11
    JE doMatrixMul

    cmp choice, 12
    JE doPermutation

    cmp choice, 13
    JE doCombination

    cmp choice, 14
    JE doTrig

    jmp mainMenu

doAdd:
    call addProc
    jmp mainMenu

doSub:
    call subProc
    jmp mainMenu

doMul:
    call Multiplication
    jmp mainMenu

doDivision:
    call DivisionOperation
    jmp mainMenu

doFactorial:
    mov edx, OFFSET msgBase   
    call WriteString
    call ReadInt
    mov num1, eax            
    call Fact                 
    mov eax, result           
    mov edx, OFFSET msgResult
    call WriteString
    call WriteDec
    call Crlf
    jmp mainMenu


doSquare:
    call sqProc
    jmp mainMenu

doCube:
    mov edx, OFFSET msgBase
    call WriteString
    call ReadInt
    push eax
    call CubeProc
    jmp mainMenu

doPercentage:
    mov edx, OFFSET msgIn1
    call WriteString
    call ReadInt
    mov ebx, eax

    mov edx, OFFSET msgIn2
    call WriteString
    call ReadInt

    push ebx   
    push eax   
    call PercentProc
    jmp mainMenu

doPower:
    call PowerCalculation
    jmp mainMenu

doMatrixMul:
    call matrixMulProc
    jmp mainMenu

doMatrixAdd:
    call MatrixAddition
    jmp mainMenu

doPermutation:
    call PermutationCalculation
    jmp mainMenu

doCombination:
    call CombinationCalculation
    jmp mainMenu

doTrig:
    call TrigonometricCalculation
    jmp mainMenu

main ENDP
END main

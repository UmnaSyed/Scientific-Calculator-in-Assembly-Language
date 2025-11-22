INCLUDE Irvine32.inc

.data
menu BYTE 0Dh,0Ah,'1.Addition 2.Subtraction 3.Multiplication 4.Division 5.Power 6.Factorial 7.Square 8.Cube 9.%',0Dh,0Ah,\
      '10.Matrix Addition 11.Matrix Multiplication 12.Permutation 13.Combination 14.Trigonometric Functions 0.Exit',0Dh,0Ah,0

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
msgResultPow   BYTE "Power result: ",0
msgFraction    BYTE "Fraction form: 1/",0
msgDecimal     BYTE "Decimal form: ",0
msgOne         BYTE "1",0
msgNegativeOne BYTE "-1",0
msgOverflow BYTE "Error! Overflow.",0
msgN BYTE "Enter n (total items): ",0
msgR BYTE "Enter r (selected items): ",0
msgResultNPR BYTE "nPr result: ",0
msgErrorNPR BYTE "Error: r cannot be greater than n!",0

choice DWORD ?
num1 SDWORD ?
num2 SDWORD ?
rowsA DWORD ?
rowsB DWORD ?
colsA DWORD ?
colsB DWORD ?
n_value DWORD ?
r_value DWORD ?
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


.code

;-------------------------
; Addition
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

;-------------------------
; Subtraction
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

;-------------------------
; Square
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

MatrixAddition PROC

    ; Input rows for Matrix A
    mov edx, OFFSET msgArows
    call WriteString
    call ReadInt
    mov rowsA, eax

    ; Input columns for Matrix A
    mov edx, OFFSET msgAcols
    call WriteString
    call ReadInt
    mov colsA, eax

    ; Compute total elements
    mov eax, rowsA
    mul colsA
    mov totalElements, eax

    ; Input Matrix A elements
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

    ; Input Matrix B elements
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

    ; Perform matrix addition: C = A + B
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

    ; Display result
    mov edx, OFFSET msgCresult
    call WriteString
    call Crlf

    mov ecx, rowsA       ; number of rows
    mov ebx, 0           ; row counter
    mov esi, OFFSET matrixC

PrintRows:
    cmp ebx, rowsA
    jge EndPrintRows
    mov ecx, colsA       ; number of columns
    mov edi, 0           ; column counter

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


;-------------------------
; Matrix Multiplication
matrixMulProc PROC
    ; read dimensions
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

    ; zero matrixC
    mov ecx, 9
    mov edi, OFFSET matrixC
    xor eax, eax
zeroLoop:
    mov [edi], eax
    add edi, 4
    loop zeroLoop

    ; input matrixA
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

    ; input matrixB
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
    xor edi, edi      ; matrixC index
    mov ebx,0         ; row i
iLoop:
    cmp ebx, rowsA
    jge doneMul
    mov ecx,0         ; column j
jLoop:
    cmp ecx, colsB
    jge nextI
    xor edx, edx      ; accumulator for C[i][j]
    mov esi,0         ; k
kLoop:
    cmp esi, colsA
    jge storeC
    ; A[i][k] index
    mov eax, ebx
    imul eax, colsA
    add eax, esi
    mov eax, [matrixA + eax*4]
    ; B[k][j] index
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

;-------------------------
exitProg PROC
    exit
exitProg ENDP

;-------------------------
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
    cmp choice, 7
    JE doSquare

    cmp choice, 10
    JE doMatrixAdd

    cmp choice, 11
    JE doMatrixMul

    jmp mainMenu

doAdd:
    call addProc
    jmp mainMenu

doSub:
    call subProc
    jmp mainMenu

doSquare:
    call sqProc
    jmp mainMenu

doMatrixMul:
    call matrixMulProc
    jmp mainMenu

doMatrixAdd:
    call MatrixAddition
    jmp mainMenu

main ENDP
END main

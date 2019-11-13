comment !
        Task:Create a procedure that returns the sum of all array elements falling within the range j..k (inclusive).
        Write a test program that calls the procedure twice, passing a pointer to a signed doubleword array, the size of the array, and the values of j and k.
        Return the sum in the EAX register, and preserve all other register values between calls to the procedure.
!

.386
.model flat,stdcall
.stack 4096

ExitProcess proto,dwExitCode:dword
INCLUDE Irvine32.inc
.data
InstructionalPrompt BYTE "Selects integers ranging from j to k (inclusive) in a random array and sums those integers", 0
EnterPrompt BYTE "Enter a value for ", 0
JPrompt BYTE "J(must be greater than 0): ", 0
KPrompt BYTE "K(must be greater than J): ", 0
SumPrompt BYTE "Sum is: ", 0
RandomArrayInt DWORD 10 DUP(?)
.code
main proc

        mov EDX, OFFSET InstructionalPrompt
        call WriteString
        call crlf
        ;Get value of J
        mov EDX, OFFSET JPrompt
        call WriteReadPrompt
        mov EBX, EAX

        ;Get value of k
        mov EDX, OFFSET KPrompt
        call WriteReadPrompt
        mov EDX, EAX


        mov ESI, OFFSET RandomArrayInt

        ;Populate array with random values
        mov ECX, 2                                                              ;Test Twice, since Randomize works with current time and CPU clock is faster than a second. Anwser produce same values
        L1:
                push ECX                                                        ;Save ECX
                push EDX                                                        ;Save unedited edx
                add EDX, 10
                mov ECX, LENGTHOF RandomArrayInt
                call FillArray
                call ReadIntArray
                pop EDX                                                         ;Retrieve unedited edx
                call SumRange
                push EDX                                                        ;Save EDX
                mov EDX, OFFSET SumPrompt
                call WriteString
                call WriteInt
                call crlf
                pop EDX                                                         ;Retrieve EDX
                pop ECX                                                         ;Retrieve ECX
        Loop L1
        call WaitMsg
        invoke ExitProcess,0
main endp
;-------------------------------------------
;Summary: Selects integers between j to k in an Array and sums up their values.
;Receives: ESI (Offset of Array), ECX (N), EBX (J), EDX (K)
;Returns: Selected Sums into EAX
;-------------------------------------------
SumRange Proc Uses ECX EBX EDX EDI
        mov EAX, 0
        mov EDI, 0
        L1:
                cmp DWORD PTR [ESI + EDI*4], EDX                ;compare with k
                jg L2                                           ;If greater than k go to L2
                        cmp DWORD PTR [ESI + EDI*4], EBX        ;compare with j
                jl L2                                           ;if less than j go to L2
                        add EAX, DWORD PTR [ESI + EDI*4]
                L2:
                INC EDI
        Loop L1
        ret
SumRange Endp
;-------------------------------------------
;Summary: Fills the array with random values ranging between j to k
;Receives: ESI (Offset of Array), ECX (N), EBX (J), EDX (K)
;Returns: Nothing
;-------------------------------------------
FillArray Proc
        pushad                                          ;Push register values
        call Randomize                                  ;Re-seed the random generator to get a better psuedo-random number.
        INC EDX                                         ;Increment EDX because RandomRange gives a range between 0 to n-1
        L1:
                mov EAX, EDX                            ;Mov edx to eax
                call RandomRange
                cmp EAX, EBX                            ;compare EAX with J
                JL L1                                   ;If EAX is less than J go back to L1
                mov [ESI], EAX				;Move EAX into the memory offset of ESI + EDI*4
                Add ESI, 4
        Loop L1
        popad                                           ;Pop all register values into registers.
        ret
FillArray endp
;-------------------------------------------
;Summary: Reads an Array
;Receives: ESI (Offset of Array), ECX (# of items in the Array)
;Returns: Nothing
;-------------------------------------------
ReadIntArray PROC
                pushad
        mov EDI, 0
        L1:
                mov EAX, DWORD PTR [ESI + EDI*4]
                call WriteInt
                call crlf
                inc EDI
        Loop L1
                popad
        ret
ReadIntArray endp
;-------------------------------------------
;Summary: Prompts "user to enter a value for [a value ]"
;Recieves: Offset to EDX
;Returns: Returns user value in EAX
;-------------------------------------------
WriteReadPrompt Proc
                push EDX                                ;Save offset to stack
                mov EDX, OFFSET EnterPrompt
                call WriteString
                pop EDX                                 ;Retrieve offset from stack
                call WriteString
                call ReadInt
        ret
WriteReadPrompt endp
end main

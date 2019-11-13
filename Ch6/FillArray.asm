comment !
        Task: Create a procedure that fills an array of doublewords with N random integers, making sure the values fall within the range j...k, inclusive.
        When calling the procedure, pass a pointer to the array that will hold the data, pass N, and pass the values of j and k.
        Preserve all register values between calls to the procedure. Write a test program that calls the procedure twice, using different values for j and k. Verify your results using a debugger.
!
include Irvine32.inc
.data
EnterPrompt BYTE "Enter a value for ", 0
NPrompt BYTE "N(must be less than 100): ", 0
JPrompt BYTE "J(must be 0 or greater): ", 0
KPrompt BYTE "K(must be greater than J): ", 0
RandomArrayInt DWORD 100 DUP(?)
.code
main proc

                ;Get value of N
                mov EDX, OFFSET NPrompt
                call WriteReadPrompt
                mov ECX, EAX

                ;Get value of J
                mov EDX, OFFSET JPrompt
                call WriteReadPrompt
                mov EBX, EAX

                ;Get value of k
                mov EDX, OFFSET KPrompt
                call WriteReadPrompt
                mov EDX, EAX

                mov ESI, OFFSET RandomArrayInt
                call FillArray
                call ReadIntArray
                call WaitMsg
        invoke ExitProcess,0
main endp
;-------------------------------------------
;Summary: Reads an Array
;Receives: ESI (Offset of Array), ECX (# of items in the Array)
;Returns: Nothing
;-------------------------------------------
ReadIntArray PROC uses EDI EAX
        mov EDI, 0
        L1:
                mov EAX, DWORD PTR [ESI + EDI*4]
                call WriteInt
                call crlf
                inc EDI
        Loop L1
        ret
ReadIntArray endp
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
                ADD ESI, 4
        Loop L1
        popad                                           ;Pop all register values into registers.
        ret
FillArray endp
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

comment !
  Task: A program using a loop and indexed addressing to rotate the members of a 32-bit integer array forward one position. 
  The values at the end wrap around to the first position, For example, the array [10, 20, 30, 40] would be transferred into 
  [40, 10, 20, 30]. Call a procedure to perform the move.
!

.386
.model flat,stdcall
.stack 4096
ExitProcess proto,dwExitCode:dword
.data
        Array DWORD 10, 20, 30, 40
.code
main proc

        CALL ProcRotateArray
        invoke ExitProcess,0

main endp
;---------------------------------------------------------
; ProcRotateArray
;
; Rotates the Array. Example [10, 20, 30, 40] would be transferred into [40, 10, 20, 30]
;---------------------------------------------------------
ProcRotateArray proc uses ESI ECX
        MOV ECX, Lengthof Array - 1             ;Count Down
        MOV ESI, 0                                              ;Starting value
        Rotate:
                Push Array[ESI*TYPE Array]                       ;Push the ith value on the stack
                Push Array[ECX*TYPE Array]                       ;Push the (LengthArray - ith) value on the stack
                Pop Array[ESI*TYPE Array]                        ;Pop the (LengthArray - ith) value on to the (ith) memory location
                Pop Array[ECX*TYPE Array]                        ;Pop the ith value on to the (LengthArray - ith) memory location
                inc ESI                                 ;Increment ESI (ith value)
        Loop Rotate
ProcRotateArray endp
end main

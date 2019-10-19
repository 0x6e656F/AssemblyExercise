comment !
	Task: Write a program that uses a loop to calculate the first seven values of the Fibonacci Sequence and calculate the sum of these numbers. 
	Your code should call two procedures, the first is used to calculate the sequence and the second is used to calculate the sum.		
!
.386
.model flat,stdcall
.stack 4096
ExitProcess proto,dwExitCode:dword

.code
main proc
	
	MOV ECX, 7
	call ProcSumFibonacci
	invoke ExitProcess,0

main endp

;---------------------------------------------------------
; ProcSumFibonacci
;
; Calculates and returns the sum of the fibonacci sequnce of a 32-bit integer.
; Receives: ECX. Must be greater than 0.
; Returns:  EAX: the sum of the fibonacci value at ECX. 
;---------------------------------------------------------
ProcSumFibonacci proc
	
	mov EAX, 0
	SumFibonacci:
		Push EAX							;Save EAX as it is returned by fibonacci functions
		Push ECX							;Save ECX value as it would be used up by Fibonacci Func
			call ProcFibonacci				;Calculate the fibonacci for the given number ECX
		mov EBX, EAX						;Move the fionacci value to EBX
		Pop ECX								;Restore ECX
		Pop EAX								;Restore EAX
		Add EAX, EBX						;Add EAX with the Fibonacci Value (EBX)
	Loop SumFibonacci
	ret
ProcSumFibonacci endp

;---------------------------------------------------------
; ProcFibonacci
;
; Calculates and returns the value of a fibonacci sequnce of a 32-bit integer.
; Receives: ECX. Must be greater than 0.
; Returns:  EAX: the fibonacci value at ECX. 
;---------------------------------------------------------
ProcFibonacci proc
	Push EBX			;Save value of EBX
	Push EDX			;Save value of EDX

	MOV EBX, 0
	MOV EAX, 1
	MOV EDX, 0
	Fibonacci:
		ADD EAX, EDX	;(n - 1) + (n - 2) where (n-1) is EAX and (n-2) is EDX
		MOV EDX, EBX	;Added so that when n = 2 EAX be 1;
		MOV EBX, EAX	;Set next (n-2) to the current (n-1)
	LOOP Fibonacci
	
	POP EDX				;Restore EDX
	POP EBX				;Restore EBX
	
	ret
ProcFibonacci endp

end main

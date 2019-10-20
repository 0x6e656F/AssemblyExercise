comment !
	Task: Write a program with a loop and indirect addressing that copies a string from source to target, reversing the character order in the process. Use the following variables:
		source BYTE "This is the source string",0
		target BYTE SIZEOF source DUP('#')
!
.386
.model flat,stdcall
.stack 4096
ExitProcess proto,dwExitCode:dword

.data
source BYTE "This is the source string",0
target BYTE SIZEOF source - 1 DUP('#')  ;added -1 since we don't want null terminator
.code
main proc
	mov ECX, SIZEOF source - 1      ;initialize ECX, skip null terminator
	mov EDI, 0		        ;index
	L1:
		mov AL, source[ECX - 1] ;correct index since when ECX is 0, the loop ends and move data in AL
		mov target[EDI], AL     ;mov AL into memory of target at EDI
		Inc EDI	                ;Increment EDI
	Loop L1
	invoke ExitProcess,0
main endp
end main

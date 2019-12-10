comment !
	Task: 
	The greatest common divisor (GCD) of two integers is the largest integer that will evenly divide both integers. 
	The GCD algorithm involves integer division in a loop, described by the following pseudocode:

	int GCD(int x, int y)
	{
	   x = abs(x)                   // absolute value
	   y = abs(y)
	   do {
			 int n = x % y
			 x = y
			 y = n
	   } while (y > 0)
	   return x
	}

!
.386
.model flat,stdcall
.stack 4096

ExitProcess proto,dwExitCode:dword
INCLUDE Irvine32.inc

.code
main PROC
	mov Eax, 15
	mov ebx, 10
	call GCD
	call WriteInt
	call crlf
	call WaitMsg
    quit: invoke ExitProcess, 0
main ENDP
GCD PROC
	call abs
	push eax
	mov eax, ebx
	call abs 
	mov ebx, eax
	pop eax
	L1:
		mov edx, 0
		div ebx
		mov eax, ebx
		mov ebx, edx
	cmp ebx, 0
	ja L1
	ret
GCD endp
Abs PROC
	test EAX, 8000000h
	jz finish
	neg eax
	finish: ret
Abs endp
END main

comment !
	Task: Write a program that generates all prime numbers between 2 and 1000, using the Sieve of Eratosthenes method. 
	You can find many articles that describe the method for finding primes in this manner on the Internet. Display all the prime values.
!
.386
.model flat,stdcall
.stack 4096

ExitProcess proto,dwExitCode:dword
INCLUDE Irvine32.inc

.code
main PROC
	mov ECX, 1000
	call displayprime
    quit: invoke ExitProcess, 0
main ENDP
DisplayPrime Proc
	pushad
	mov EDX, 0
	L1:
		mov bx, dx
		call IsPrime 
		jnz cont
			mov EAX, Edx
			call WriteInt
			mov al, ','
			call WriteChar
		cont:
		inc Edx
	Loop L1
	popad
	ret
DisplayPrime endp
IsPrime PROC
	pushad
	mov cx, 2
	cmp bx, 0
	je NotPrime
	cmp bx, 1
	je done
	Check:
		cmp cx, bx
		je done
		mov dx, 0
		mov ax, bx
		div cx
		cmp dx, 0
		jz NotPrime
		inc cx
		jmp check
	NotPrime:
		cmp cx, 1		;clear zero flag
	Done:
	popad
	ret
IsPrime endp
END main

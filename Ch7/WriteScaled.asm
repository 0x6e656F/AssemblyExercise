comment !
	Task: Display ASCII Decimal

	Write a procedure named WriteScaled that outputs a decimal ASCII number with an implied decimal point. 
	Suppose the following number were defined as follows, where DECIMAL_OFFSET indicates that the decimal 
	point must be inserted five positions from the right side of the number:
	DECIMAL_OFFSET = 5
	.data
	decimal_one BYTE "100123456789765"

	WriteScaled would display the number like this:
	1001234567.89765

	When calling WriteScaled, pass the number’s offset in EDX, the number length in ECX, and the decimal offset in EBX. 
	Write a test program that passes three numbers of different sizes to the WriteScaled procedure.
!
.386
.model flat,stdcall
.stack 4096

ExitProcess proto,dwExitCode:dword
INCLUDE Irvine32.inc

DECIMAL_OFFSET = 5
.data

decimal_one BYTE "100123456789765"

.code
main PROC
	mov ECX, lengthof Decimal_one
	mov EBX, decimal_offset
	mov EDX, OFFSET decimal_one
	call WriteScaled
    invoke ExitProcess, 0
main ENDP
WriteScaled PROC
	pushad
	mov ESI, 0
	sub EBX, ECX
	neg EBX
	L1:
		mov EAX, [EDX]
		cmp ESI, EBX
		jne noDec
			push EAX
			mov al, '.'
			call WriteChar
			pop EAX
		noDec:
		call WriteChar
		inc EDX
		inc ESI
	Loop L1
	call crlf
	popad
	ret
WriteScaled endp
END main

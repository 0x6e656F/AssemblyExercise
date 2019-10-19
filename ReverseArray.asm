comment !
	Task: Use a loop with indirect or indexed addressing to reverse the elements of an integer array in place. Do not copy the elements to any other array. 
	Use the SIZEOF, TYPE, and LENGTHOF operators to make the program as flexible as possible if the array size and type should be changed in the future.	
!
.386
.model flat,stdcall
.stack 4096
ExitProcess proto,dwExitCode:dword

.data
Array WORD 8,5,4,3,6,1,9,2,7
.code
main proc
	
	mov ECX, (SIZEOF Array)/2												;Get half the number of bytes in array
	mov ESI, ECX															;initialize ESI
	sub ESI, TYPE Array/2													;subtract the type divided by 2. if Array is byte subtracts 0
	add ESI, ((LENGTHOF Array - 1) MOD 2)									;if the # of elements are even add 1. 
	mov EDI, (SIZEOF Array)/2 - ((LENGTHOF Array - 1) MOD 2) - TYPE Array/2	;initialize EDI as well 
	sub ECX, ((LENGTHOF Array - 1) MOD 2)									;subtract from ECX if # of elements are even. 
	sub ECX, (((TYPE Array) + 1) MOD 3)/2									;subtract 1 from ECX if a BYTE or a DWORD
	add ECX, ((TYPE Array) MOD 2)*2											;Add two if the type is BYTE
	L1:
		mov AL, BYTE PTR Array[ESI]											;Get the byte pointer of Array at ESI
		XCHG BYTE PTR Array[EDI], AL											;exchange element at Byte pointer of Array at EDI with AL
		XCHG AL, BYTE PTR Array[ESI]											;exchange al with element at Byte pointer of Array at ESI
		inc ESI																;Increment ESI
		dec EDI																;Decrement EDI
	Loop L1
	invoke ExitProcess,0
main endp
end main


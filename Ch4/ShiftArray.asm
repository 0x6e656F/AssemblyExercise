comment !
        Task:Write a program with a loop and indexed addressing that exchanges every element in the array
        Therefore, item i will exchange with item i+1, and item i+1 will exchange with item i+2, and so on.

	Note:Not from the book.
!
.386
.model flat,stdcall
.stack 4096
ExitProcess proto,dwExitCode:dword

.data
Array WORD 1234h,3456h,5678h,7890h
.code
main proc

 	mov ECX, (SIZEOF Array) - Type Array			;retrieve the total number of iterations in list to use as a counter 
	mov ESI, 0						;Initialize ESI (Index)
	xchgLoop:
		mov AL, BYTE PTR Array[ESI]			;retrieve the i-th index
		xchg  BYTE PTR Array[ESI + TYPE Array], AL	;exchange the next item in list with AL (current item)
		xchg  BYTE PTR Array[ESI], AL			;exchange the current item with with AL (next item)
		Add ESI, 1					;Increment ESI (index)
	loop xchgLoop
        invoke ExitProcess,0
main endp
end main

comment !
	Task: Create a procedure named Extended_Sub that subtracts two binary integers of arbitrary size. 
	The storage size of the two integers must be the same, and their size must be a multiple of 32 bits. 
	Write a test program that passes several pairs of integers, each at least 10 bytes long.
!
.386
.model flat,stdcall
.stack 4096

ExitProcess proto,dwExitCode:dword
INCLUDE Irvine32.inc

.data

;done the book's way of little-endian so read right to left

int1 BYTE 12h,34h,56h,78h,90h,09h,08h,07h,06h,05h,04h,03h,02h,01h,12h,23h,34h;
int2 BYTE 13h,20h,40h,60h,80h,08h,07h,06h,05h,04h,03h,02h,01h,00h,02h,10h,20h;
result BYTE sizeof int1 Dup(0)

.code
main PROC
	mov ESI, OFFSET int1
	mov EDI, Offset int2
	mov EBX, OFFSET result
	mov ecx, lengthof int1

	call Extended_Sub
	mov ESI, OFFSET result
	mov ECX, lengthof result
	call DisplayResult
    invoke ExitProcess, 0
main ENDP
Extended_Sub Proc
	pushad
	clc
	L1:
		mov al, [ESI]
		sbb al, [EDI]
		pushfd
		mov [ebx], al
		inc esi
		inc edi
		inc ebx
		popfd
	Loop L1
	popad
	ret
Extended_Sub endp
DisplayResult PROC ;code from book
    pushad
    ; point to the last array element
    add  esi,ecx
    sub  esi,TYPE BYTE
    mov  ebx,TYPE BYTE
	L1: 
	mov  al,[esi]           ; get an array byte
    call WriteHexB          ; display it
    sub  esi,TYPE BYTE      ; point to previous byte
    loop L1
    popad
    ret
DisplayResult ENDP
END main

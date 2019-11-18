comment !
	Task:Create a program that functions as a simple boolean calculator for 32-bit integers. It should display a menu that asks the user to make a selection from the following list:

    x AND y
    x OR y
    NOT x
    x XOR y
    Exit program

	When the user makes a choice, call a procedure that displays the name of the operation about to be performed. You must implement this procedure using the Table-Driven Selection technique, shown in Section 6.4.4. 
(You will implement the operations in Exercise 6.) (The Irvine32 library is required for this solution program.)
	
	Task:Continue the solution program from Exercise 5 by implementing the following procedures:

    AND_op: Prompt the user for two hexadecimal integers. AND them together and display the result in hexadecimal.

    OR_op: Prompt the user for two hexadecimal integers. OR them together and display the result in hexadecimal.

    NOT_op: Prompt the user for a hexadecimal integer. NOT the integer and display the result in hexadecimal.

    XOR_op: Prompt the user for two hexadecimal integers. Exclusive-OR them together and display the result in hexadecimal.

!

.386
.model flat,stdcall
.stack 4096

ExitProcess proto,dwExitCode:dword
INCLUDE Irvine32.inc
.data
CaseTable	BYTE '1'
			DWORD ProcAND
EntrySize = ($ - CaseTable)
			BYTE '2'
			DWORD ProcOR
			BYTE '3'
			DWORD ProcNOT
			BYTE '4'
			DWORD ProcXOR
NumberOfEntries = ($ - CaseTable) / EntrySize
msgPAND BYTE "x AND y", 0
msgPOR BYTE "x OR y", 0
msgPNOT BYTE "NOT x", 0
msgPXOR BYTE "x XOR y", 0
msgPExit BYTE "Exit Program", 0
msgInputPrompt BYTE "Choose a value between 1 - 5: ", 0
msgErrorPrompt BYTE "Error value must be between 1-5!", 0
.code
main proc
		
		L0:
		Call ClrScr
		Call GetUserOption
		mov ebx, OFFSET CaseTable
		mov ecx, NumberOfEntries
		or al, 00110000b		;change integer into character hex representation of the ASCII value
		L1: 
			cmp al, '5'
			je quit			;quit program
			cmp al, [ebx]		;compare characters 
			jne Increment		;increment if they are not equal
			call NEAR PTR [ebx + 1]	;call procedure if equal
			call WaitMsg
			jmp L0;
		Increment:
			add ebx, EntrySize	;incrment by size of each entry
			Loop L1;

        quit: invoke ExitProcess,0
main endp
ProcAND Proc USES EAX EBX
	mov EDX, OFFSET msgPAND
	call DisplayUserSelection
	call GetHexFromUser
	AND EAX, EBX
	call WriteHex
	call crlf
	ret
ProcAND endp
ProcOR proc Uses EAX EBX
	mov EDX, OFFSET msgPOR
	call DisplayUserSelection
	call GetHexFromUser
	OR EAX, EBX
	call WriteHex
	call crlf
	ret
ProcOR endp
ProcNOT proc Uses EAX EDX
	.data
		msgPrompt BYTE "Enter a hexadecimal integers: ", 0	
		msgResult BYTE "The result of the operation is ", 0
	.code
	mov EDX, OFFSET msgPNOT
	call DisplayUserSelection
	mov EDX, OFFSET msgPrompt
	call WriteString
	call crlf
	call ReadHex
	NOT EAX
	mov EDX, OFFSET msgResult
	call WriteString
	call WriteHex
	call crlf
	ret
ProcNOT endp
ProcXOR proc Uses EAX EBX EDX
	mov EDX, OFFSET msgPXOR
	call DisplayUserSelection
	call GetHexFromUser
	XOR EAX, EBX
	call WriteHex
	call crlf
	ret
ProcXOR endp
;-------------------------------------
;Summary: Retrieves two hex value from user ;Receives: Nothing ; Returns: EAX, EBX
;-------------------------------------
GetHexFromUser Proc Uses EDX
	.data 
	msgPrompt1 BYTE "Enter two hexadecimal integers: ", 0	
	msgResult1 BYTE "The result is of the operation is ", 0
	.code
	mov EDX, OFFSET msgPrompt
	call WriteString
	call crlf
	call ReadHex
	mov EBX, EAX
	call ReadHex
	mov EDX, OFFSET msgResult
	call WriteString
	ret
GetHexFromUser endp
;-------------------------------------
;Summary: Display User selection ;Receives: Nothing ; Returns: EAX
;-------------------------------------
DisplayUserSelection Proc 
	.data
	 DisplayPrompt BYTE "The procedure you picked: ", 0				
	.code
	push EDX														
	mov EDX, OFFSET DisplayPrompt									
	call WriteString												
	pop EDX													
	call WriteString	
	call crlf
	call crlf
	ret
DisplayUserSelection endp
;-------------------------------------
;Summary: Get user option ;Receives: Nothing ; Returns: EAX
;-------------------------------------
GetUserOption Proc Uses EBX EDX ECX ESI EDI
	
	call DisplayOptions

	;set the bounds and messages and check for inputvalidation
	mov EBX, 1														
	mov ECX, 5
	mov ESI, OFFSET msgInputPrompt
	mov EDI, OFFSET msgErrorPrompt
	call InputValidation
	ret
GetUserOption endp
;-------------------------------------
;Summary: Displays Options ;Receives: Nothing ;Returns: Nothing
;-------------------------------------
DisplayOptions Proc Uses EAX EDX
	
	mov al, '1'
	call FormatBulletPoints
	mov edx, OFFSET msgPAND
	call WriteString
	call crlf
	
	mov al, '2'
	call FormatBulletPoints
	mov edx, OFFSET msgPOR
	call WriteString
	call crlf

	mov al, '3'
	call FOrmatBulletPoints
	mov edx, OFFSET msgPNOT
	call WriteString
	call crlf

	mov al, '4'
	call FOrmatBulletPoints
	mov edx, OFFSET msgPXOR
	call WriteString
	call crlf
	
	mov al, '5'
	call FormatBulletPoints
	mov edx, OFFSET msgPExit
	call WriteString
	call crlf
	ret
DisplayOptions endp
;-------------------------------------
;Summary: Adds a space and period after character ;Receives: AL (char) ;Returns: Nothing
;-------------------------------------
FormatBulletPoints Proc
	call WriteChar
	mov al, '.'
	call WriteChar
	mov al, ' '
	call WriteChar
	ret
FormatBulletPoints endp
;-------------------------------------
;Summary: Validates if input is between range
;Receives: EBX (min), ECX (max), ESI (offset of inputPrompt), EDI (offset of errorPrompt)
;Returns: EAX
;-------------------------------------
InputValidation PROC uses EDX
		
		Validation:
		mov EDX, ESI
		Call GetUserInt

		cmp EAX, EBX
		jl ErrorMsg
		cmp EAX, ECX
		jg ErrorMsg
		jmp L1
		ErrorMsg:
		mov EDX, EDI
		call WriteString
		call crlf
		jmp Validation

	L1:ret
InputValidation endp
;-------------------------------------
;Summary: Get's integer input from user ;Receives: EDX, OFFSET of string ;Returns: EAX
;-------------------------------------
GetUserInt PROC
	call WriteString
	call ReadInt
	ret
GetUserInt endp
end main


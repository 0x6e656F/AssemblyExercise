comment !
Info:Banks use a Personal Identification Number (PIN) to uniquely identify each customer. Let us assume that our bank has a specified range of acceptable values for each digit in its customers’ 5-digit PINs. 
The table shown below contains the acceptable ranges, where digits are numbered from left to right in the PIN. Then we can see that the PIN 52413 is valid. But the PIN 43534 is invalid because the first digit is out of range.
Similarly, 64535 is invalid because of its last digit.

Digit Number	Range

1				5 to 9

2				2 to 5

3				4 to 8

4				1 to 4

5				3 to 6

Task:Your task is to create a procedure named Validate_PIN that receives a pointer to an array of byte containing a 5-digit PIN. Declare two arrays to hold the minimum and maximum range values, and use these arrays to validate each 
digit of the PIN that was passed to the procedure. If any digit is found to be outside its valid range, immediately return the digit’s position (between 1 and 5) in the EAX register. If the entire PIN is valid, return 0 in EAX. 
Preserve all other register values between calls to the procedure. Write a test program that calls Validate_PIN at least four times, using both valid and invalid byte arrays. By running the program in a debugger, verify that the 
return value in EAX after each procedure call is valid. Or, if you prefer to use the book’s library, you can display “Valid” or “Invalid” on the console after each procedure call.


!

.386
.model flat,stdcall
.stack 4096

ExitProcess proto,dwExitCode:dword
INCLUDE Irvine32.inc
.data

MinRange BYTE 5,2,4,1,3
MaxRange BYTE 9,5,8,4,6
PinArray BYTE Lengthof MinRange Dup(?)
InvalidIndex BYTE LengthOf MinRange Dup(-1)
InvalidNumbers BYTE LengthOF MinRange Dup(-1)

.code
main proc
		
		call TestValidation

        invoke ExitProcess,0
main endp
;-------------------------------------
;Summary:Tests validation code 4 times ;Receives: Nothing ;Returns: Nothing
;-------------------------------------
TestValidation Proc
	pushad
	mov ECX, 4
	L1:
		push ECX
		mov ESI, Offset PinArray
		mov ECX, LengthOf PinArray
		mov EBX, 0
		mov EDX, 10
		call FillArray
		
		;Only need to re-initialize InvalidIndex because it is used as a check in DisplayInvalidNumbers. Also Jump destination become too large if initialize InvalidNumbers 
		mov ESI, OFFSET InvalidIndex
		mov ECX, LengthOf InvalidIndex
		mov AL, -1
		call Initialize					
		
		push OFFSET InvalidNumbers
		push OFFSET InvalidIndex
		push OFFSET MaxRange
		push OFFSET MinRange
		push OFFSET PinArray
	
		call Validate_PIN

		mov ESI, OFFSET PinArray
		mov ECX, Lengthof PinArray
		call ReadByteArray

		call crlf
		mov ESI, OFFSET InvalidIndex 
		mov EDI, OFFSET InvalidNumbers
		mov ECX, Lengthof InvalidNumbers
		call DisplayInvalidNumbers
		pop ECX
	Loop L1;
	popad
	ret
TestValidation endp
;-------------------------------------
;Summary: Displays invalid numbers ;Receives: ESI(offset of array), ECX(length of array), AL(value to initialize with);Returns: Nothing
;-------------------------------------
 Initialize Proc Uses ESI EAX ECX
	L1:
		mov BYTE PTR [ESI], AL
		inc ESI
	Loop L1;
	ret
 Initialize  endp
;-------------------------------------
;Summary: Displays invalid numbers ;Receives: ESI(offset of invalidIndex), EDI(offset of invalidnumbers) ;Returns: Nothing
;-------------------------------------
DisplayInvalidNumbers Proc 
	.data
	msgValid BYTE "All values were valid Pin combination", 0
	msgInvalid BYTE "These values were invalid pin combination {index, value}: ", 0
	
	.code
	test BYTE PTR [ESI], 80h
	jnz Valid
	mov EDX, Offset msgInvalid
	call WriteString
	mov EAX, 0
	Invalid: 
			mov AL, '{'
			call WriteChar
			mov AL, BYTE PTR [ESI]
			call WriteInt
			mov AL, ','
			call WriteChar
			mov AL, BYTE PTR [EDI]
			call WriteInt
			mov AL, '}'
			call WriteChar
			mov AL, ' '
			call WriteChar
			inc EDI
			inc ESI
			test BYTE PTR [ESI], 80h	;Test if it has negative value if it doesn't repeat loop
	Loopz Invalid
	jmp quit
	Valid:
		mov EDX, OFFSET msgValid
		call WriteString
	quit:
	call crlf
	call crlf
	ret
DisplayInvalidNumbers endp
;-------------------------------------
;Summary: Checks to see if an array has valid pins
;Receives: 
;		Pops last four values stored on the stack: 
;		Order of push:
;			OFFSET of array that will accept invalid numbers
;			OFFSET of array that will accept invalid Index
;			OFFSET of MaxRange array
;			OFFSET of MinRange array
;			OFFSET of Array to test
;			
;	   Also receives ECX, All arrays must be of same size. 
;Returns: Nothing
;-------------------------------------
Validate_PIN Proc
	.data
		TestPtr DWORD ?
		minPtr DWORD ?
		maxPtr DWORD ?
		InvIndPtr DWORD ?
		InvNumPtr DWORD ?
		nxtPTR DWORD ?
		count BYTE ?
	.code
	Pop	nxtPTR
	Pop TestPtr
	Pop minPtr
	Pop maxPtr
	Pop InvIndPtr
	Pop InvNumPtr
	pushad
	mov count, 0
	L1:
		mov EAX, 0
		mov EBX, 0
		mov EDX, 0
		mov ESI, TestPtr
		mov AL, BYTE PTR [ESI]
		mov ESI, minPtr
		mov EDI, maxPtr
		mov BL, BYTE PTR [ESI]
		mov DL, BYTE PTR [EDI]
		call IsInRange
		jz L2						;Test to see if it's in range if it is goto L2
		mov ESI, InvNumPtr
		mov BYTE PTR [ESI], AL
		mov ESI, InvIndPtr
		mov al, Count
		mov BYTE PTR [ESI], al
		inc InvIndPtr
		inc InvNumPtr
		L2:
		;Increment all ptrs
		inc [TestPtr]
		inc [minPtr]
		inc [maxPtr]
		inc Count
	Loop L1
	popad
	push nxtPTR
	ret
Validate_PIN endp
;-------------------------------------
;Summary: Checks if value is between range and set's zero flag
;Receives: EAX(Test value), EBX (min), EDX (max)
;Returns: Nothing. Set's the zero flag if it is in range
;-------------------------------------
IsInRange PROC 
	cmp EAX, EBX
	jb quit
	cmp EAX, EDX
	ja quit
	test EAX, 0			;set zero flag
	quit:ret
IsInRange endp
;-------------------------------------------
;Summary: Reads an Array
;Receives: ESI (Offset of Array), ECX (# of items in the Array)
;Returns: Nothing
;-------------------------------------------
ReadByteArray PROC uses EAX ECX ESI
        L1:
				mov EAX, 0
                mov AL, BYTE PTR [ESI]
                call WriteInt
                mov AL, ','
				call WriteChar
				mov AL, ' '
				call WriteChar
                inc ESI
        Loop L1
		call crlf
        ret
ReadByteArray endp

;-------------------------------------------
;Summary: Fills the array with random values ranging between j to k
;Receives: ESI (Offset of Array), ECX (N), EBX (J), EDX (K)
;Returns: Nothing
;-------------------------------------------
FillArray Proc
        pushad                                          ;Push register values
        call Randomize                                  ;Re-seed the random generator to get a better psuedo-random number.
        INC EDX                                         ;Increment EDX because RandomRange gives a range between 0 to n-1
        L1:
                mov EAX, EDX                            ;Mov edx to eax
                call RandomRange
                cmp EAX, EBX                            ;compare EAX with J
                JL L1                                   ;If EAX is less than J go back to L1
                mov BYTE PTR [ESI], AL			;Move EAX into the memory offset of ESI + EDI*4
                inc ESI
        Loop L1
        popad                                           ;Pop all register values into registers.
        ret
FillArray endp

end main

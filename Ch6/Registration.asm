comment !
	Task: Using the College Registration example from Section 6.6.3 as a starting point, do the following:
  	Recode the logic using CMP and conditional jump instructions (instead of the .IF and .ELSEIF directives).
	Perform range checking on the credits value; it cannot be less than 1 or greater than 30. If an invalid entry is discovered, display an appropriate error message.
	Prompt the user for the grade average and credits values.
	Display a message that shows the outcome of the evaluation, such as “The student can register” or “The student cannot register.”	

!
.386
.model flat,stdcall
.stack 4096

ExitProcess proto,dwExitCode:dword
INCLUDE Irvine32.inc
.data
TRUE = 1
FALSE = 0
gradeAverage  WORD 275              ; test value
credits       WORD 12               ; test value
CanRegister  BYTE ?
GradePrompt BYTE "Enter your grade average value: ", 0
CreditPrompt BYTE "Enter number of credits: ", 0
ErrorPrompt BYTE "Error: value must be between 1 - 30!", 0
PosResultPrompt BYTE "The Student can register", 0
NegResultPrompt BYTE "The Student can't register", 0
.code
main proc
		
		mov CanRegister, False

		mov EDX, OFFSET GradePrompt
		Call GetUserInt
		mov gradeAverage, AX

		mov EBX, 1
		mov ECX, 30
		mov ESI, OFFSET CreditPrompt
		mov EDI, OFFSET ErrorPrompt
		call InputValidation
		mov credits, AX
		cmp gradeAverage, 350
		jbe L2
		mov CanRegister, True
		jmp result
		L2:
		cmp gradeAverage, 250
		jbe L3
		cmp credits, 16
		ja L3
		mov CanRegister, True
		jmp result
		L3:
		cmp credits, 12
		ja result
		mov CanRegister, True
		result:
		test CanRegister, 1
		jnz can
		mov edx, OFFSET NegResultPrompt
		jmp quit
		Can:
		mov edx, OFFSET PosResultPrompt
		quit:
		call WriteString
        invoke ExitProcess,0
main endp
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
;Summary: Get's integer input from user
;Receives: EDX, OFFSET of string
;Returns: EAX
;-------------------------------------
GetUserInt PROC
	call WriteString
	call ReadInt
	ret
GetUserInt endp
end main

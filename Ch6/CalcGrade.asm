comment !
        Task:Create a procedure named CalcGrade that receives an integer value 
		between 0 and 100, and returns a single capital letter in the AL 
		register. Preserve all other register values between calls to the 
		procedure. The letter returned by the procedure should be according 
		to the following ranges:
		Score Range Letter Grade
		-------------------------
		90 to 100 A
		80 to 89 B
		70 to 79 C
		60 to 69 D
		0 to 59 F
		Write a test program that generates 10 random integers between 50 and 100, 
		inclusive. Each time an integer is generated, pass it to the CalcGrade 
		procedure. You can test your program using a debugger, or if you prefer 
		to use the book's library, you can display each integer and its corresponding 
		letter grade.

!

.386
.model flat,stdcall
.stack 4096

ExitProcess proto,dwExitCode:dword
INCLUDE Irvine32.inc
.data

RandomArrayByte BYTE 10 DUP(?)
.code
main proc
		
		mov ECX, Lengthof RandomArrayByte 
		mov ESI, OFFSET RandomArrayByte
		mov EBX, 50
		mov EDX, 100
		call FillArray
		call TestCalcGrade
		call crlf
		call WaitMsg
        invoke ExitProcess,0
main endp
;-------------------------------------------
;Summary: Tests CalcGrade
;Receives: ESI (Offset of Array), ECX (N)
;Returns: A letter grade into the AL
;-------------------------------------------
TestCalcGrade Proc
	L1:
		mov BL, BYTE PTR [ESI]
		movzx EAX, BL
		
		;calculate grade and display value to console.
		call CalcGrade
		push EAX
		push " "			
		movzx EAX, BL
		call WriteInt
		pop EAX
		call WriteChar
		pop EAX 
		call WriteChar
		call crlf
		inc ESI
	Loop L1
	ret
TestCalcGrade endp
;-------------------------------------------
;Summary: Fills the array with random values ranging between j to k
;Receives: BL value between 0 - 100
;Returns: A letter grade into the AL
;-------------------------------------------
CalcGrade Proc
		cmp BL, 59
		mov AL, "F"
		jle L2			;Jump if less than or equal to 59
		cmp BL, 69
		mov AL, "D"
		jle L2
		cmp BL, 79
		mov AL, "C"
		jle L2
		cmp BL, 89
		mov AL, "B"
		jle L2			;If greater than 89 then an A
		mov AL, "A"
		L2:
	ret
CalcGrade endp

;-------------------------------------------
;Summary: Fills the array with random values ranging between j to k
;Receives: ESI (Offset of Array), ECX (N), EBX (J), EDX (K)
;Returns: Nothing
;-------------------------------------------
FillArray Proc
        pushad                        ;Push register values
        call Randomize                ;Re-seed the random generator to get a better psuedo-random number.
        INC EDX                       ;Increment EDX because RandomRange gives a range between 0 to n-1
        L1:
                mov EAX, EDX          ;Mov edx to eax
                call RandomRange
                cmp EAX, EBX          ;compare EAX with J
                JL L1                 ;If EAX is less than J go back to L1
                mov [ESI], EAX        ;Move EAX into the memory offset of ESI + EDI*4
                inc ESI
        Loop L1
        popad  			      ;Pop all register values into registers.
        ret
FillArray endp
end main


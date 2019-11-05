comment !
	Task: Use the solution program of 2.A from the preceding exercise as a starting point.  Let this new program repeat the same steps three times, using a loop.  Clear the screen after each loop iteration.
!
include Irvine32.inc
.data
prompt BYTE "Enter an integer: ", 0
SumPrompt BYTE "The sum of the two integers is ", 0
int1 DWORD ?
.code
main proc
     
	mov ECX, 3
	L1:
		call GetUserSum
	Loop L1
     	call crlf			;go to next line
	call crlf
	call WaitMsg			;Wait until user press a key.
	invoke ExitProcess,0
main endp

;--------------------------------------
;Summary: Asks the user to input two integers and displays the usm
;Returns EAX
;--------------------------------------
GetUserSum Proc
	call GetUserInt								
	mov int1, EAX			;Save information to int1
	call GetUserInt
	add EAX, int1			;add int1 with eax and save to eax
	call CursorToMiddle		;move cursor to middle
	mov EDX, OFFSET SumPrompt	;Move SumPrompt memory offset into EDX
	call WriteString		;Write the Sumprompt to console
	call WriteInt			;Write the int to console.
	call crlf			;go to next line
	call WaitMsg			;Wait until user press a key.
	ret
GetUserSum endp
;--------------------------------------
;Summary: Prompts user to enter integer
;Returns EAX
;--------------------------------------
GetUserInt Proc
	call CursorToMiddle		;Move cursor to middle
     mov EDX, OFFSET prompt		;Move prompt memory offset into EDX
     call WriteString			;Write the prompt to console
     call ReadInt			;Read the input of user into EAX
	ret
GetUserInt endp
;--------------------------------------
;Summary: Clears screen and moves the cursor to the middle of the screen
;input: nothing
;returns: nothing
;--------------------------------------
CursorToMiddle proc
     call clrscr
     mov DH, 12
     mov DL, 20
     call Gotoxy
     ret
CursorToMiddle endp
end main


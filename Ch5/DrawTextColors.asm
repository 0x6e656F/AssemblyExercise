comment !
Task: Draw Text Colors
Write a program that displays the same string in four different colors using a loop.  Call the SetTextColor procedure from the book's link library. Any colors may be chosen, but you may find it easier to change the foreground color.
!
include Irvine32.inc
.data
prompt BYTE "Message", 0
foreground WORD ?
.code
main proc
     
     mov ECX, 4
     L1:
          mov foreground, CX		;Change foreground color information
          mov AX, foreground		;Move foreground color into AX
          call SetTextColor		;Call the SetTextColor
          mov EDX, OFFSET prompt	;Put offset of prompt into EDX 
          call WriteString		;Display the message
          call crlf			;Go to next line
     Loop L1
     mov AX, 0fh;			;Change color to white
     call SetTextColor			;Call the SetTextColor
     call WaitMsg			;Wait until user press a key
	invoke ExitProcess,0
main endp
end main


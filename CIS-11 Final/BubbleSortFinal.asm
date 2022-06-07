; Andrew Lemus
; Bubble Sort: Implement bubble sort that obtains 8 numbers ranging from 0-100 and sorts in ascending order
; CIS 11
; 06/06/2022

		.ORIG x3000

; Load prompts to display

		LEA R0, FIRSTPROMPT	; load first prompt, asking user to input 8 numbers
		PUTS			; display to console
		AND R0, R0, x0		; clear R0 for the next prompt
		LEA R0, SPACE		; allows "\n" to be used
		PUTS			; display to console
		AND R0, R0, x0		; clear R0 for next prompt
		LEA R0, SAMPLE		; load example to show the user what is needed
		PUTS			; display to console
		
		LD R3, POINTER		; initialize and load pointer in R3
		LD R6, IOCOUNTER	; load R6 with IO Counter

; Receives input

INPUT		
		IN			; input first number
		AND R2, R2, x0		; clear r2
		AND R5, R5, x0		; clear r5
		LD R5, PLACEHUNDRED	; load value 100 to R5 to eventually counter
		LD R2, HEXN48		; R2 is loaded with negative offset
		ADD R0, R0, R2		; add ASCII offset to inputted value (R0)
		ADD R2, R0, x0		; move R0 to R2
		ADD R0, R0, x0		; clear R0 for next input

	FIRST_NUM			; loop to obtain first digit from user
		ADD R0, R0, R2		; first digit input value + 0
		ADD R5, R5, x-1		; decrement counter
		BRp FIRST_NUM		; if positive, loop 100 times
		ADD R1, R0, x0		; R1 now contains first digit
		ADD R0, R0, x0		; Clear R0

		IN			; second digit in input
		ADD R2, R2, x0		; clear R2
		ADD R5, R5, x0		; clear R5
		LD R5, PLACETEN		; Load value 10 to R5 for countering
		LD R2, HEXN48		; R2 is loaded with negative offset
		ADD R0, R0, R2		; add ASCII offset to input value
		ADD R2, R0, x0		; move inputted value to R2
		AND R0, R0, x0		; clear R0
	
	SECOND_NUM			; loop to obtain second digit from user
		ADD R0, R0, R2		; second value + 0
		ADD R5, R5, x-1		; decrement counter
		BRp SECOND_NUM		; if positive loop 10 times
		ADD R4, R0, x0		; R4 now contains seonc digit
		AND R0, R0, x0		; clear R0

		IN			; input third digit
		AND R2, R2, x0		; clear R2
		LD R2, HEXN48		; load negative ASCII
		ADD R0, R0, R2		; add ASCII offset to input value
		AND R2, R2, x0		; clear R2

		ADD R2, R1, R4		; R2 = First value (R1) + second value (R4)
		ADD R2, R0, R2		; R2 = (R1 + R2) + third value (R0)
		STR R2, R3, x0		; store the 3 dfigit value in R2, in an array with pointer (R3)
		ADD R3, R3, x1		; Increase pointer value
		ADD R6, R6, x-1		; Decrease input loop by counter
		BRp INPUT		; check condition by branching: if counter is positive, loop

		JSR BUBBLESORT
		JSR PRODUCTLOOP
		HALT

		; Bubble Sort Subroutine
BUBBLESORT

		AND R3, R3, x0		; clear R3
		LD R3, POINTER		; reload register in pointer
		AND R4, R4, x0		; clear R4 
		LD R4, IOCOUNTER	; clear counter value (OUTERLOOP)
		AND R5, R5, x0		; clear R5
		LD R5, IOCOUNTER	; reset counter value (INNERLOOP)

OUTERLOOP	ADD R4, R4, x-1		; loop n-1 times
		BRz SORTED		; exit loop if complete
		ADD R5, R4, x0		; move outerloop counter (R4) into innerloop counter (R5)
		LD R3, POINTER		; reload register in pointer to start from beginning of array

INNERLOOP 	LDR R0, R3, x0		; get item at file pointer
		LDR R1, R3, x1		; get next item
		AND R2, R2, x0		; clear R2
		NOT R2, R1		; make negative
		ADD R2, R2, x1		; next item
		ADD R2, R0, R2		; swap = item - next item
		BRn SWAPPED		; dont swap if its in order
		STR R1, R3, x0		; perform
		STR R0, R3, x1		; swap

SWAPPED		ADD R3, R3, x1		; increment file pointer
		ADD R5, R5, x-1		; decrement inner loop
		BRp INNERLOOP		; end inner loop
		BRzp OUTERLOOP		; end outer loop
		SORTED RET		; return when sorted
		RET

PRODUCTLOOP
		LEA R0, PROMPTEXECUTE
		PUTS
		LD R3, POINTER
		LD R6, IOCOUNTER

	RESULTLOOP
		AND R1, R1, x0
		AND R2, R2, x0
		AND R4, R4, x0
		AND R5, R5, x0
		AND R0, R0, x0
		LD R0, SPACE
		OUT
		AND R0, R0, x0
		LDR R0, R3, x0

		LD R2, PLACEHUNDRED
		NOT R2, R2
		ADD R2, R2, x1

	MINUS01
		ADD R1, R1, x1
		ADD R0, R0, R2
		BRzp MINUS01
	REMAINDER01
		AND R2, R2, x0
		LD R2, PLACEHUNDRED
		ADD R0, R0, R2
		ADD R1, R1, x-1
		STI R1, FIRSTNUM

		AND R2, R2, x0
		LD R2, PLACETEN
		NOT R2, R2
		ADD R2, R2, x1

	MINUS02
		ADD R4, R4, x1
		ADD R0, R0, R2
		BRzp MINUS02

	REMAINDER02
		AND R2, R2, x0
		LD R2, PLACETEN
		ADD R5, R0, R2
		STI R5, THIRDNUM
		ADD R4, R4, x-1
		STI R4, SECONDNUM

		AND R0, R0, x0
		LDI R0, FIRSTNUM
		AND R2, R2, x0
		LD R2, HEX48
		ADD R0, R0, R2
		OUT
		
		AND R0, R0, x0
		LDI R0, THIRDNUM
		AND R2, R2, x0
		LD R2, HEX48
		ADD R0, R0, R2
		OUT

		ADD R3, R3, x1
		ADD R6, R6, x-1
		BRp RESULTLOOP
		HALT

FIRSTPROMPT	.STRINGZ	"Input 8 numbers between 000 - 100 with 3 digits."
SAMPLE		.STRINGZ	"Ex: 010, 001, 100, 012 "
PROMPTEXECUTE	.STRINGZ	"Numbers in Ascending Order: "
SPACE		.STRINGZ	"\n"
HEXN48		.FILL		xFFD0
HEX48		.FILL		x0030	
PLACEHUNDRED	.FILL		x0064
PLACETEN	.FILL		x000A
POINTER		.FILL		x4000
IOCOUNTER	.FILL		#8
FIRSTNUM	.FILL		x400A
SECONDNUM	.FILL		x400B
THIRDNUM	.FILL		x400C
		.END
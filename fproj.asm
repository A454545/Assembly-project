%include "simple.io.inc"

global asm_main
extern rprem

SECTION .data 
	prompt1: db "enter a,b to swap",10,0
	prompt2: db "0 to terminate: ",0
	a1: db "first coordiante is not 1..8",10,0
	a2: db "comma not there",10,0
	a3: db "second coordiante is not 1..8",10,0
	

SECTION .bss
array: resq 8  ;initializes an array of size 8 (simply allocates the space) 
len:   equ $-array ;initializes len to the array 

SECTION .text 

display: 
	enter 0,0 
	saveregs 
	
	;now lets display the array number by number separated by commas
	;we will use the register to hold each element of the array temporary then call the function to print it.
	mov rax, [array]   ;first element 
	call print_int 
	mov al, ','
	call print_char 
	mov rax, [array+8]	;second element 
	call print_int
	mov al, ','
	call print_char
	mov rax, [array+16]		;third element
	call print_int
	mov al, ','
	call print_char
	mov rax, [array+24]		;fourth element
	call print_int
	mov al, ','
	call print_char
	mov rax, [array+32]		;fifth element
	call print_int
	mov al, ','
	call print_char
	mov rax, [array+40]		;sixth element
	call print_int
	mov al, ','
	call print_char
	mov rax, [array+48]		;seventh element
	call print_int
	mov al, ','
	call print_char
	mov rax, [array+56]		;eighth element
	call print_int
	call print_nl
	
	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	;nested loop to go level by level (height 8, width 8)
		;push array and length of array
		;if smaller than row print spaces, equal to row print ---, larger than row print +  +
		;pop
		
	;;set up the stack alignment 
	;sub rsp, 32+8
	
	;;in the display subroutine the stack is paased with 2 parameters 
	;;numbers on the stack have to be odd to avoid problems whena the call function is used 
	;;even push 
	;;therefor you nedd to push the fake then push the array then push the size 
	;;the first parameter is the address of the array ;;should be display any array
	;push rdi
	;;the second parameter is the size of the array  ;;it is a parameter and information on the stack 
	;push rsi
	
	
	
	;;clean up the stack
	;add rsp, 32+8
	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	
	restoregs
	leave
	ret
	
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;these blocks will be used to display the pattern afterwards
;;a block that display multiple string for each piece of the row
;;display the dashes 
;;display the plues for each occasion of the number 

CREATE_LINE:			;puts everything together 
ADD_LINE:				;use a loop with the level as th econtrol for each if statement and th ecounter bneing the size of the array 
DISPLAY_THE_ROW:		;the nested loops will makes sure you are displaying row by row just make sure th eouter loop have a counter by the size which represents the levels of displating

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

asm_main:
	enter 0,0
	saveregs 
	
	call display
	
	mov rdi, array		;sets up the first parameter of the function that will be called soon in the register rdi
	mov rsi, qword 8	;2nd parameter stored in the register  rsi
	call rperm
	
	;mov rdi, array
	;mov rsi, len
	call display
	
prompt: 
	mov rax, prompt1
	call print_string
	mov rax, prompt2
	call print_string
	
read:
	call read_char
	cmp al, '0'
	je asm_main_end
	
	cmp al, '1'
	jb error1
	cmp al, '8'
	ja error1 
	
	;;changes to number 
	mov r12, 0
	mov r12b, al
	sub r12b, '0'
	
	call read_char
	cmp al, ','
	jne error2
	;;jmp asm_main_end;;
	
	;;now we have to check the second number after the comma\
	;;we are checking between 1 and 8
	
	call read_char
	cmp al, '1'
	jb error3
	cmp al. '8'
	ja error3
	
	mov r13, 0
	mov r13b, al
	sub r13b, '0'
	;;jmp asm_main_end;;;
	
	;;we have to find where in the array is the first and second values 
	
	;;takes in the array --> points to the beginning to the array 
	mov r14, array
	
LOOP1:
	cmp [r14], r12		;;compares every element in the array
	je LOOP2
	add r14, 8   ;add to the next index of the array
	jmp LOOP1
	
LOOP2:
	mov r15, array		
	
LOOP3:
	cmp [r15], r13
	je LOOP4
	add r15, 8
	jmp LOOP3
LOOP4:
	mov [r14], r13		;at the address of r14 we hav the value r13
	mov [r15], r12		;move the value at r12 to pointer r15 
	call display 
	
	;jmp prompt		;;or 
	jmp asm_main_end
	
	
error1:
	call print_nl
	mov rax, al
	call print_string
	;;empty input buffer to acoid overwriting with the registers 
	L1:
		cmp al, 10
		je L2
		call read_char
		jmp L1
	L2:
		jmp prompt 
	
error2:
	call print_nl
	mov rax, a2
	call print_string
	;;empty input buffer before jumping
	K1:
		cmp al, 10
		je k2
		call read_char
		jmp k1
	k2:
		jmp prompt 
		jmp prompt
	
error3:
	call print_nl
	mov rax, err3
	call print_string
	;;empty input buffer before jumping
	T1:
		cmp al, 10
		je T2
		call read_char
		jmp T1
	T2:
		jmp prompt 
		jmp prompt
		
		
PATTERN_OF_BOX_ONE:
	mov al, '+'
	call print_char

PATTERN_OF_BOX_TWO:
	Lstart1:
		mov rcx, qword 2
		mov al, '++'
		read_char
		loopnz Lstart1
		
PATTERN_OF_BOX_THREE:
	mov al, '+-+'
	call print_char
	mov al, '+ +'
	call print_char 
	mov al, '+-+'
	call print_char

PATTERN_OF_BOX_FOUR:
	mov al, '+--+'
	call print_char
	Lstart2:
		mov rcx, qword 2
		mov al, '+  +'
		read_char
		loopnz Lstart2
	mov al, '+--+'
	call print_char
	
PATTERN_OF_BOX_FIVE:
	mov al, '+---+'
	call print_char
	Lstart3:
		mov rcx, qword 3
		mov al, '+   +'
		read_char
		loopnz Lstart3
	mov al, '+---+'
	call print_char
	
PATTERN_OF_BOX_SIX:
	mov al, '+----+'
	call print_char
	Lstart4:
		mov rcx, qword 4
		mov al, '+    +'
		read_char
		loopnz Lstart4
	mov al, '+----+'
	call print_char

PATTERN_OF_BOX_SEVEN:
	mov al, '+-----+'
	call print_char
	Lstart5:
		mov rcx, qword 5
		mov al, '+     +'
		read_char
		loopnz Lstart5
	mov al, '+-----+'
	call print_char

PATTERN_OF_BOX_EIGHT: 
	mov al, '+------+'
	call print_char
	Lstart6:
		mov rcx, qword 6
		mov al, '+      +'
		read_char
		loopnz Lstart6
	mov al, '+------+'
	call print_char
	
asm_main_end:	
	restoregs 
	leave 
	ret

	@ BSS section
	.bss
	
	@ DATA SECTION
	.data
	getInputSize: .asciz "Size Of Array:\n"
	getElements: .asciz "Enter Array elements in Sorted Order:\n"
	getSearchElement: .asciz "Search Element:\n"
	arraySize: .word 0 
	arrayAddress: .skip 80
	searchElementAddress: .word 0
	searchResult: .word -1
	output: .asciz "Element Position(output) is: "
	@ TEXT section
	  .text	

	.globl MAIN
	.text	

	MAIN:
	
//ENTER SIZE
	mov r0,#1 
	ldr r1,=getInputSize
swi 0x69 
	//SOFTWARE INTERRUPTION
	ldr r0,=IntRead               
	ldr r0,[r0]                                      
	swi 0x6c
	mov r2,r0                                        
	ldr r0,=arraySize
	str r2,[r0]

//INPUT ARRAY ELEMNTS
	mov r0, #1   
	ldr r1, =getElements
	swi 0x69
	mov r4, r2 
	mov r7, #0  
	ldr r1, =arrayAddress 
	loop_for_array_input:
	ldr r0, =IntRead
	ldr r0, [r0]
	swi 0x6c
	str r0, [r1], #4
	mov r7, r0
	subs r4, r4, #1
	bgt loop_for_array_input

//INPUT SEARCH ELEMENT
	mov r0, #1 
	ldr r1, =getSearchElement
	swi 0x69
	ldr r0, =IntRead
	ldr r0, [r0]   
	swi 0x6c
	mov r3, r0 
	ldr r0, =searchElementAddress
	str r3, [r0]

//DO BINARY SEARCH
	mov r5, #4 
	bl CALL_BINARY_SEARCH_SUBROUTINE
	ldr r5, =searchResult 
	mov r9, r0 
	str r9, [r5] 
	mov r0, #1
	ldr r1, =output 
	swi 0x69
	mov r0,#1
	mov r1, r9  
	swi 0x6b
	swi 0x11

//BINARY SEARCH SUBROUTINE

	CALL_BINARY_SEARCH_SUBROUTINE:
	stmfd sp!,{r1,r2,r3,r4,lr}
	mov r7, #1
	mov r8, r2 
	loop:
	mov r4, r7  
	add r4, r8
	asr r4, #1  
	ldr r1, =arrayAddress  
	mul r5, r4 
	add r1, r5 
	sub r1, #4         
	ldr r6, [r1] 
	cmp r6, r3 
	
	beq INDEX_POSITION 
	bgt MAX_ELEMENT 
	b MIN_ELEMENT 
    b ELEMENT_NOT_FOUND                                          

    INDEX_POSITION:
    mov r0, r2   
    sub r0, r4  
    sub r0, r2, r0  
    ldmfd sp!,{r1,r2,r3,r4,pc}   

    MIN_ELEMENT:  
	add r4, #1
	mov r7, r4
	mov r5, #4
	cmp r7, r8           
	bgt ELEMENT_NOT_FOUND
    b loop          
    MAX_ELEMENT:
	mov r8, r4
	mov r5, #4
	cmp r7, r8    
	bgt ELEMENT_NOT_FOUND
	b loop                    

	ELEMENT_NOT_FOUND: 
	mov r0, #-1
	ldmfd sp!,{r1,r2,r3,r4,pc}
	
	IntRead: .word 0
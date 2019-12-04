@ BSS section
	.bss
	
	@ DATA SECTION
	.data
	getInputSize: .asciz "Size Of Array:\n"
	getElements: .asciz "Enter Array elements:\n"
	getSearchElement: .asciz "Search Element:\n"
	arraySize: .word 0              
	arrayAddress: .skip 80                  
	searchElementAddress: .word 0     
	searchResult: .word -1  
	output: .asciz "Element Position:"

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
	mov r0,#1
	ldr r1,=getElements
	swi 0x69
	mov r8,r2                           
	ldr r1,=arrayAddress  
	ITERATE1:
	ldr r0,=IntRead
	ldr r0,[r0]
	swi 0x6c
	str r0,[r1],#4
	subs r8,r8,#1
	bgt ITERATE1
//INPUT SEARCH ELEMENT
	mov r0,#1         
	ldr r1,=getSearchElement
	swi 0x69

	ldr r0,=IntRead   
	ldr r0,[r0] 
	swi 0x6c
	mov r3,r0 
	ldr r0,=searchElementAddress
	str r3,[r0]

//DO SEARCH
	ldr r1,=arrayAddress
	mov r8,r2        
	bl SEARCH          
	ldr r5,=searchResult
	mov r9,r0  
	str r9,[r5]  
	mov r0,#1
	ldr r1,=output 
	swi 0x69
	mov r0,#1
	mov r1,r9 
	swi 0x6b

//DO SEARCH SUBROUTINE
SEARCH:
	stmfd sp!,{r1,r2,r3,r8,lr}                

	ITERATE2: 
	ldr r6, [r1], #4  
	cmp r6, r3 
	beq INDEX_POSITION  
	subs r8, r8, #1  
	bgt ITERATE2 
    b ELEMENT_NOT_FOUND
	
    INDEX_POSITION:  
	mov r0, r2 
	sub r0, r8 
	add r0, #1
	ldmfd sp!,{r1,r2,r3,r8,pc}
	ELEMENT_NOT_FOUND:
	mov r0, #-1
	ldmfd sp!,{r1,r2,r3,r8,pc}

IntRead: .word 0
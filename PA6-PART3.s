	@ BSS section
	.bss
	
	@ DATA SECTION
	.data
	INPUT: .asciz ">>>>>>>>>>>>>>>>>>>>>>>>      Enter N:\n"

	Input:
		N: .word 0
	OUTPUT: .word 0
	
	out: .asciz "Fibonnaci Value: "
	
	@ TEXT section
	  .text	

	.globl MAIN
	.text	

	MAIN:


	mov r0, #1 
	ldr r1, =INPUT
	swi 0x69

	ldr r0, =IntRead    
	ldr r0, [r0] 
	swi 0x6c
	mov r1, r0   
	ldr r0, =N
	str r1, [r0]

	mov r2, #1   
	mov r3, #1
	bl PERFORM 
	ldr r5, =OUTPUT 
	mov r9, r0        
	str r9, [r5]
	mov r0, #1
	ldr r1, =out   
	swi 0x69
	mov r0,#1
	mov r1, r9    
	swi 0x6b
	swi 0x11
PERFORM:                                        
	stmfd sp!,{r1,lr} 
	mov r4, #1	
ITERATE:
    cmp r4, r1       
	beq PERFORM_FIB   
	cmp r4, #1          
	beq INIT   
	cmp r4, #2  
	beq LAST 
	pop {r5} 
	pop {r6}
	add r7, r5, r6 				 
	push {r5}    
	push {r7}        
	add r4, #1 
	b ITERATE   

	INIT:        
	PUSH {r2}
	add r4, #1
	b ITERATE
	LAST: 
	PUSH {r3}
	add r4, #1
	b ITERATE	
	
	PERFORM_FIB:  
	mov r0, #1
	cmp r1, #1
	beq END                    
	cmp r1, #2
	beq POP
	pop {r5}                       
	pop {r6}       
	add r7, r5, r6 
	push {r5}   
	push {r7}
	mov r0, r7  
	pop {r7}
	pop {r5}
	
	END:
	ldmfd sp!,{r1,pc}

	POP:
	pop {r5}
	ldmfd sp!,{r1,pc}
		
IntRead: .word 0
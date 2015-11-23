SEARCH_CALLBAK_CONTINUE:

	ldmfd sp!, {r1-r4}

	b loop

SEARCH_CALLBACK:

	stmfd sp!, {lr}

	ldr r1, =CALLBACK_VECTOR
	
	ldr r2, =CALLBACK_VECTOR_SIZE
	ldr r3, [r2]

	mov r4, #0 @ Counter

loop:

	cmp r4, r3
	beq loop_end

	mov r5, #12

	mul r6, r4, r5 @ Sets the vector offset

	ldr r0, [r1, r6] @ Loads the next sonar id

	bl READ_SONAR @ Receives back the distance in r0 (sonar.s)

	add r6, r6, #4 @ Sets the vector offset to get the distance saved

	cmp r6, r0
	beq call_function

	add r4, r4, #1
	
	b loop

call_function:
	
	stmfd sp!, {r1-r4} @ Saves the loop current state

	add r6, r6, #4 @ Sets the vector offset to get the callback address	
	
	msr CPSR_c, #0x10
	blx r6

	mov r7, #31
	svc 0x0

loop_end:

	@ TODO -> SORT VECTOR!!!

	ldmfd sp!, {lr}

	mov pc, lr


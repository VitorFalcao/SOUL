SEARCH_CALLBACK:

	stmfd sp!, {lr}
	
	ldr r1, =READ_SONAR_FLAG
	ldr r2, [r1]
	
	@ Checks if a read sonar is alredy running	
	cmp r2, #1
	beq read_sonar_exit
	
	mov r2, #1
	str r2, [r1]	

	ldr r1, =CALLBACK_VECTOR

	ldr r2, =CALLBACK_VECTOR_SIZE
	ldr r3, [r2] 

	mov r4, #0 @ Counter

loop:

	cmp r4, r3
	beq callback_loop_end

	mov r5, #12

	mul r6, r4, r5 @ Sets the vector offset

	ldr r0, [r1, r6] @ Loads the next sonar id

	bl READ_SONAR @ Receives back the distance in r0 (sonar.s)

	add r6, r6, #4 @ Sets the vector offset to get the distance saved
	ldr r5, [r1, r6] @ Gets the distance

	add r6, r6, #4
	ldr r6, [r1, r6] @ Gets the function address

	@stmfd sp!, {r3}

	cmp r0, r5
	blls call_function_callback

	@ldmfd sp!, {r3}

	add r4, r4, #1

	b loop

call_function_callback:

	stmfd sp!, {r1-r4, lr} @ Saves the loop current state

	blx r6

	ldmfd sp!, {r1-r4, lr}
	mov pc, lr

callback_loop_end:
	
	ldmfd sp!, {lr}

	@ Set the read sonar flag to 0
	ldr r1, =READ_SONAR_FLAG
	mov r2, #0
	str r2, [r1]

	mov pc, lr

read_sonar_exit:

	ldmfd sp!, {lr}	
	mov pc, lr

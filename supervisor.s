.set FLAG_MASK, 0x00000001
.set TRIGGER_MASK, 0x00000002
.set SONAR_DATA_MASK, 0x0003FFC0

SUPERVISOR_HANDLER:

	cmp r7, #16
	beq READ_SONAR
	
	cmp r7, #17
	beq REGISTER_PROXIMITY_CALLBACK
	
	cmp r7, #18
	beq SET_MOTOR_SPEED

	cmp r7, #19
	beq SET_MOTORS_SPEED

	cmp r7, #20
	beq GET_TIME
	
	cmp r7, #21
	beq SET_TIME

	cmp r7, #22
	beq SET_ALARM

	cmp r7, #30 @ Special syscall to return to user mode restoring SPSR
	beq RETURN

REGISTER_PROXIMITY_CALLBACK:
	
	stmfd sp!, {r3-r12, lr}

	ldr r3, =MAX_CALLBACKS
	ldr r4, [r3]

	cmp r4, #0
	beq callback_full

	mov r4, #15
	cmp r4, r0
	bgt invalid_sonar_id

	mov r4, #0
	cmp r4, r0
	blt invalid_sonar_id
	
	@ Updates the number of MAX_CALLBACKS
	add r4, r4, #1
	str r4, [r3]

	@@
	@ Saves the callback
	@@
	
	ldr r3, =CALLBACK_VECTOR

	ldr r4, =CALLBACK_VECTOR_SIZE
	ldr r5, [r4]
	
	@ Set the CALLBACK_VECTOR offset
	mov r6, #8
	mul r6, r5, r6

	add r3, r3, r6 @ Set the address to the last element in CALLBACK_VECTOR

	str r0, [r3, #4] @ Saves the sonar id
	str r1, [r3, #8] @ Saves the distance
	str r2, [r3, #12] @ Saves the function address (callback)
	
	@ Updates the CALLBACK_VECTOR_SIZE
	add r5, r5 #1
	str r5, [r4]

	mov r0, #0 @ Sets the return value	

	ldmfd sp!, {r3-r12, lr}
	movs pc, lr

callback_full:

	@ Returns -1 on r0
	ldmfd sp!, {r3-r12, lr}
	mov r0, #-1
	movs pc, lr

invalid_sonar_id:

	@ Returns -2 on r0
	ldmfd sp!, {r3-r12, lr}
	mov r0, #-2
	movs pc, lr

SET_MOTOR_SPEED:

	stmfd sp!, {r2-r12, lr}

    @ If speed is less than zero, it's an invalid speed
    cmp r1, #0
    blt INVALID_SPEED

    @ Move to r3 the address of DR
    ldr r3, =GPIO_BASE
    ldr r4, [r3]

    @ Go to the right motor function, if it's not 0 or 1 then it's invalid
    cmp r0, #0
    beq MOTOR0

    cmp r0, #1
    beq MOTOR1
    
    b INVALID_MOTOR

MOTOR0:

    @ Move to r3 the address of DR
    sub r3, r3, #8

    @ Change to 1 the bit that allow writing the speed
    mov r2, #1
    lsl r2, r2, #18
    orr r4, r2
    str r4, [r3]

    @ Set the motor zero speed in to DR
    lsl r1, r1, #19
    orr r4, r4, r1
    mvn r1, r1
    lsl r1, r1, #19
    mvn r1, r1
    and r4, r4, r1
    str r4, [r3]

    @ Return to 0 the bit tha allow writing the speed
    mov r2, #1
    lsl r2, r2, #18
    mvn r2, r2
    and r4, r4, r2
    str r4, [r3]
    
    mov r0, #0

	ldmfd sp!, {r2-r12, lr}
    movs pc, lr

MOTOR1:

    @ Change to 1 the bit that allow writing the speed
    mov r2, #1
    lsl r2, r2, #25
    orr r4, r2

    @ Set the motor zero speed in to DR
    lsl r1, r1, #26
    orr r4, r4, r1
    mvn r1, r1
    lsl r1, r1, #26
    mvn r1, r1
    and r4, r4, r1
    str r4, [r3]

    @ Return to 0 the bit tha allow writing the speed
    mov r2, #1
    lsl r2, r2, #25
    mvn r2, r2
    and r4, r4, r2
    str r4, [r3]
    
    mov r0, #0
	
	ldmfd sp!, {r2-r12, lr}
    movs pc, lr

INVALID_MOTOR:
    
    ldmfd sp!, {r2-r12, lr}
    mov r0, #-1
    movs pc, lr

INVALID_SPEED:
	
	ldmfd sp!, {r2-r12, lr}
    mov r0, #-2
    movs pc, lr

SET_MOTORS_SPEED:

    stmfd sp!, {r2-r12, lr}

    @ Save the speeds
    mov r5, r0
    mov r6, r1
    
    @ Write motor 0 speed
    mov r0, #0
    mov r1, r5
    bl SET_SPEED_MOTOR

    @ If MOTOR0 speed is invalid go to MOTOR0_INVALID_SPEED
    cmp r0, #-2
    beq MOTOR0_INVALID_SPEED

    @ Write motor 1 speed
    mov r0, #1
    mov r1, r6
    bl SET_SPEED_MOTOR

    ldmfd sp!, {r2-r12, lr}
    movs pc, lr

MOTOR0_INVALID_SPEED
	
	ldmfd sp!, {r2-r12, lr}
    mov r0, #-2
    movs pc, lr

GET_TIME:
	
	ldr r1, =TIME
	ldr r0, [r1]
	
	movs pc, lr

SET_TIME:

	ldr r1, =TIME
	str r0, [r1]

	movs pc, lr

SET_ALARM:

	stmfd sp!, {r2-r12, lr}
	
	@ Loads the number of MAX_ALARMS, which decreases every time a new alarm is added.
	ldr r2, =MAX_ALARMS
	ldr r3, [r2]

	cmp r3, #0
	beq alarm_full

    ldr r6, =TIME
    ldr r8, [r6]
	cmp r1, r8

	bl invalid_time
	
	@ Updates the number of MAX_ALARMS
	sub r3, r3, #1
	str r3, [r2]
	
	@@
	@ SAVES TIME AND FUNCTION POINTER ON STACK
	@@
	
	@ Loads the ALARM_VECTOR (address)
	ldr r2, =ALARM_VECTOR
	
	@ Loads the size of the ALARM_VECTOR
	ldr r3, =ALARM_VECTOR_SIZE 
	ldr r4, [r3]

	mov r6, #8
	mul r5, r4, r6 @ Set the offset to the last ALARM_VECTOR element

	add r2, r2, r5 @ Set r2 address to the last element of ALARM_VECTOR
	
	str r1, [r2, #4] @ Saves the time in the ALARM_VECTOR
	str r0, [r2, #8] @ Saves the function in the ALARM_VECTOR
	
	@ Updates the ALARM_VECTOR_SIZE
	add r4, r4, #1
	str r4, [r3] 

	ldmfd sp!, {r2-r12, lr}
	movs pc, lr

alarm_full:

	@ Returns -1 in r0
	mov r0, #-1
	movs pc, lr

invalid_time:

	@ Returns -2 in r0	
	mov r0, #-2
	movs pc, lr

RETURN:

	ldmfd sp!, {r0} @ SPSR
	msr SPSR, r0

	ldmfd sp!, {r0-r12, lr}

	sub lr, lr, #4
	movs pc, lr

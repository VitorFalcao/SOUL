.set FLAG_MASK, 0x00000001
.set TRIGGER_MASK, 0x00000002
.set SONAR_DATA_MASK, 0x0003FFC0

SUPERVISOR_HANDLER:
	
    @ Save the values of previous mode
    stmfd sp!, {r1-r12}

	cmp r7, #16
	bleq READ_SONAR
	
	cmp r7, #17
	bleq REGISTER_PROXIMITY_CALLBACK
	
	cmp r7, #18
	bleq SET_MOTOR_SPEED

	cmp r7, #19
	bleq SET_MOTORS_SPEED

	cmp r7, #20
	bleq GET_TIME
	
	cmp r7, #21
	bleq SET_TIME

	cmp r7, #22
	bleq SET_ALARM

    @Load the values of previous mode
    ldmfd sp!, {r1-r12}
    movs pc, lr

READ_SONAR:

    stmfd sp!, {lr}

    @ Move to r2 address of PSR, load the value, and then move to r2 address of DR
    ldr r2, =GPIO_BASE
    add r2, r2, #8
    ldr r1, [r2]
    sub r2, r2, #8

    cmp r0, #15
    bgt INVALID_SONAR

    cmp r0, #0
    blt INVALID_SONAR

    @ Change the bits of sonar_mux to read the right sonar
    mul r0, r0, #4
    orr r1, r1, r0
    mvn r0, r0
    mul r0, r0, #4
    and r1, r1, r0 
    str r1, [r2]

    @ Set the trigger to zero
    mvn r0, #TRIGGER_MASK
    and r1, r1, r0
    str r1, [r2]

    mov r3, #1000
    bl DELAY

    @ Set the trigger to one
    mov r0, #TRIGGER_MASK
    orr r1, r1, r0
    str r1, [r2]

    mov r3, #1000
    bl DELAY

    @ Set the trigger to zero
    mvn r0, #TRIGGER_MASK
    and r1, r1, r0
    str r1, [r2]

@ Wait the flag become 1
WAIT_FLAG:
    
    @ Set r2 address to PSR
    add r2, r2, #8

    @ Pick flag value
    ldr r1, [r2]
    mov r0, #1
    and r0, r0, r1

    cmp r0, #0
    bne FLAG_1
    mov r3, #1000
    bl DELAY
    b WAIT_FLAG

@ When the flag become 1
FLAG_1:

    @ Get the value of SONAR_DATA and return it
    mov r0, #SONAR_DATA_MASK
    and r0, r0, r1
    lsr r0, r0, #6

    ldmfd sp!, {pc}

@ Delay executing the loop r3 value times
DELAY:
    
    sub r3, r3, #1
    cmp r3, #0
    beq END_DELAY

END_DELAY:
	mov pc, lr

INVALID_SONAR:

    mov r0, #-1
    ldmfd sp!, {pc}

REGISTER_PROXIMITY_CALLBACK:

	movs pc, lr

SET_MOTOR_SPEED:

    @ If speed is less than zero, it's an invalid speed
    cmp r1, #0
    blt INVALID_SPEED

    @ Move to r3 the address of PSR
    ldr r3, =GPIO_BASE
    add r3, r3, #8
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

    mov pc, lr

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

    mov pc, lr

INVALID_MOTOR:
    
    mov r0, #-1
    mov pc, lr

INVALID_SPEED:
    
    mov r0, #-2
    mov pc, lr

SET_MOTORS_SPEED:

    stmfd sp!, {lr}

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

    ldmfd sp!, {pc}

MOTOR0_INVALID_SPEED
    
    mov r0, #-2
    ldmfd sp!, {pc}

GET_TIME:
	
	ldr r1, =TIME
	ldr r0, [r1]
	
	mov pc, lr

SET_TIME:

	ldr r1, =TIME
	str r0, [r1]

	mov pc, lr

SET_ALARM:
	
	@ Loads the number of MAX_ALARMS, which decreases every time a new alarm is added.
	ldr r2, =MAX_ALARMS
	ldr r3, [r2]

	cmp r3, #0
	beq alarm_full

    ldr r6, =TIME
    ldr r8, [r6]
	cmp r1, r8
	blt invalid_time
	
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

	mul r5, r4, #8 @ Set the offset to the last ALARM_VECTOR element

	add r2, r2, r5 @ Set r2 address to the last element of ALARM_VECTOR
	
	str r1, [r2, #4] @ Saves the time in the ALARM_VECTOR
	str r0, [r2, #8] @ Saves the function in the ALARM_VECTOR
	
	@ Updates the ALARM_VECTOR_SIZE
	add r4, r4, #1
	str r4, [r3] 

	mov pc, lr

alarm_full:

	@ Returns -1 in r0

	mov r0, #-1
	mov pc, lr

invalid_time:

	@ Returns -2 in r0
	
	mov r0, #-2
	mov pc, lr

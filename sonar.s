READ_SONAR:

    stmfd sp!, {r1-r12,lr}

    @ Move to r2 address of DR
    ldr r2, =GPIO_BASE
    ldr r1, [r2]

    cmp r0, #15
    bgt INVALID_SONAR

    cmp r0, #0
    blt INVALID_SONAR

    @ Change the bits of sonar_mux to read the right sonar
	lsl r0, #2
	ldr r3, =SONAR_MUX_MASK
    and r1, r1, r3
    orr r1, r1, r0
    str r1, [r2]

    @ Set the trigger to zero
    ldr r0, =TRIGGER_MASK
    and r1, r1, r0
    str r1, [r2]

<<<<<<< HEAD
    mov r3, #500
=======
    ldr r3, =500
>>>>>>> 22b022042d0878e362ef281badf46047e9ae4103
    bl DELAY

    @ Set the trigger to one
	mov r0, #1
    lsl r0, #1
    orr r1, r1, r0
    str r1, [r2]

<<<<<<< HEAD
    mov r3, #500
=======
    ldr r3, =500
>>>>>>> 22b022042d0878e362ef281badf46047e9ae4103
    bl DELAY

    @ Set the trigger to zero
    ldr r0, =TRIGGER_MASK
    and r1, r1, r0
    str r1, [r2]

@ Wait the flag become 1
WAIT_FLAG:
    
    @ Pick flag value
    ldr r1, [r2]
    mov r0, #1
    and r0, r0, r1

    cmp r0, #0
    bne FLAG_1
    mov r3, #360
    bl DELAY
    b WAIT_FLAG

@ When the flag become 1
FLAG_1:

    @ Get the value of SONAR_DATA and return it
	ldr r0, =SONAR_DATA_MASK
    and r0, r0, r1
    lsr r0, r0, #6

    ldmfd sp!, {r1-r12, lr}
	mov pc, lr

@ Delay executing the loop r3 value times
DELAY:
	stmfd sp!, {lr}

DELAY_LOOP:
    sub r3, r3, #1
    cmp r3, #0
	beq END_DELAY
	b DELAY_LOOP

END_DELAY:
	ldmfd sp!, {lr}
	mov pc, lr

INVALID_SONAR:

    mov r0, #-1
    ldmfd sp!, {r1-r12, lr}
	mov pc, lr


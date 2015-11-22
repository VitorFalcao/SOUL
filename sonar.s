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


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

READ_SONAR:

	movs pc, lr

REGISTER_PROXIMITY_CALLBACK:

	movs pc, lr

SET_MOTOR_SPEED:

	movs pc, lr

SET_MOTORS_SPEED:
	
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

	cmp MAX_ALARMS, #0
	beq alarm_full

	cmp TIME, r1
	beq invalid_time

	@ SAVE TIME AND FUNCTION POINTER ON STACK	

	movs pc, lr

alarm_full:

	@ RETORNA EM r0 -1

	movs pc, lr

invalid_time:

	@ Retorna em r0 -1

	movs pc, lr

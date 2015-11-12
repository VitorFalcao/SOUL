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

	movs pc, lr

SET_TIME:

	movs pc, lr

SET_ALARM:

	movs pc, lr

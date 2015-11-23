.set MAX_ALARMS, 8
.set MAX_CALLBACKS, 8

@ GPIO memory positions
.set GPIO_BASE, 0x53F84000 

.data

	TIME:
		.word 0

	ALARM_VECTOR_SIZE:
		.word 0

	ALARM_VECTOR:
		.skip 8*MAX_ALARMS
	
	CALLBACKS_VECTOR_SIZE:
		.word 0

	CALLBACKS_VECTOR:
		.skip 8*MAX_CALLBACKS
                                                 

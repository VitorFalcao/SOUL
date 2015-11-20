.include global.s
@@
@	Configura a GPIO, especificamente o registrador GDIR.	
@@
SET_GPIO:

	stmfd sp!, {r0-r1, lr}	

	.set GPIO_GDIR, 0x4
	.set CONFIG, 0xFFFC003E

	ldr r1, =GPIO_BASE
	
	ldr r0, =CONFIG
	str r0, [r1, #GPIO_GDIR]

	ldmfd sp!, {r0-r1, lr}
	mov pc, lr



@@
@	Configura a GPIO, especificamente o registrador GDIR.	
@@
SET_GPIO:

	.set GPIO_BASE, 0x53F84000
	.set GPIO_GDIR, 0x4

	ldr r1, =GPIO_BASE
	
	mov r0, #0xFFFC003E
	str r0, [r1, #GPIO_GdIR]

	mov pc, lr

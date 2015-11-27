SET_GPT:

	@ Seta quantos ciclos devem passar para ocorrer uma interrupcao
	.set TIME_SZ, 0x2710

	@ Constantes para os enderecos do GPT
	.set GPT_BASE, 	0x53FA0000
	.set GPT_CR, 	0x0
	.set GPT_PR, 	0x4
	.set GPT_OCR1, 	0x10
	.set GPT_IR, 	0xC

	ldr r1, =GPT_BASE

	mov r0, #0x41
	str r0, [r1, #GPT_CR]

	mov r0, #0x0
	str r0, [r1, #GPT_PR]

	mov r0, #0x64
	str r0, [r1, #GPT_OCR1]

	mov r0, #0x1
	str r0, [r1, #GPT_IR]

	mov pc, lr

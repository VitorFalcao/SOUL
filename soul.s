.include global.s

.org 0x0
.section .iv, "a"

_start:		

interrupt_vector:

    b RESET_HANDLER

.org 0x04
	b UNDF_INST_HANDLER

.org 0x08
	b SUPERVISOR_HANDLER

.org 0x0C
	b ABORT_HANDLER

.org 0x18
    b IRQ_HANDLER

.org 0x1C
	b FIQ_HANDLE


.text

RESET_HANDLER:

	@ Set interrupt table base address on coprocessor 15.
    ldr r0, =interrupt_vector
    mcr p15, 0, r0, c12, c0, 0
	
	@ GPT config.
	.set GPT_BASE, 0x53FA0000	
	.set GPT_CR, 0x0
	.set GPT_PR, 0x4
	.set GPT_OCR1, 0x10
	.set GPT_IR, 0xC

	ldr r1, =GPT_BASE

	mov r0, #0x41
	str r0, [r1, #GPT_CR]

	mov r0, #0x0
	str r0, [r1, #GPT_PR]
	
	mov r0, TIME_SZ
	str r0, [r1, #GPT_OCR1]
	
	mov r0, #0x1
	str r0, [r1, #GPT_IR]

IRQ_HANDLER:

	@ Coloca 0x1 no GPT_SR
    mov r1, #0x1
    ldr r2, =0x53FA0008
    str r1, [r2]
  
    @ Adiciona 1 ao contador
	ldr r1, =CONTADOR
    ldr r2, [r1]
    add r2, r2, #1
    str r2, [r1]
  
    @ Retorna da interrupcao
    sub lr, lr, #4
    movs pc, lr


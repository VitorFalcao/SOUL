.include "global.s"

.section .iv, "a"

_start:		

interrupt_vector:

    b RESET_HANDLER

.org 0x08
	b SUPERVISOR_HANDLER

.org 0x18
    b IRQ_HANDLER

.text
.align 4
RESET_HANDLER:

	@ Set interrupt table base address on coprocessor 15.
    ldr r0, =interrupt_vector
    mcr p15, 0, r0, c12, c0, 0

	@ Zera o contador
    ldr r2, =TIME  @ Lembre-se de declarar esse contador em uma secao de dados! 
    mov r0, #0
    str r0, [r2]	

	@ Each stack will have 4096 bytes
	.set STACK_BASE, ADDRESS

	ldr r0, =STACK_BASE

	msr CPSR_c, #0x12
	mov sp, r0 @ Set irq mode SP

	msr CPSR_c, #0x11
	add r0, r0, #0x2000
	mov sp, r0 @ Set user mode SP

	msr CPSR_C, #0x13
	add r0, r0, #0x2000
	mov sp, r0 @ Set supervisor mode SP

	bl SET_GPIO	
	bl SET_GPT
	bl SET_TZIC
	
	b 0x77802000 @ User program _start address

@ Inclui os arquivos de configuracao dos registradores GPIO, GPT, TZIC
.align 4 
.include "gpio.s"

.align 4
.include "gpt.s"

.align 4
.include "tzic.s"

@ Include interruptions handlers
.align 4
.include "supervisor.s"

.align 4
.include "irq.s"


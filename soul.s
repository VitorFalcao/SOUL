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
	
	@ldr r0, =STACK_BASE

	msr CPSR_c, #0x12
	@mov sp, r0 @ Set irq mode SP
	ldr sp, =STACK_BASE 	

	msr CPSR_c, #0x1F
	@add r0, r0, #0x2000
	ldr sp, =STACK_USER @ Set user mode SP

	msr CPSR_c, #0x13
	@add r0, r0, #0x2000
	ldr sp, =STACK_SUPERVISOR @ Set supervisor mode SP

	bl SET_GPIO	
	bl SET_GPT
	bl SET_TZIC
	
	.set USER_PROGRAM, 0x77803000

	msr CPSR_c, #0x10	
	ldr pc, =USER_PROGRAM @ User program _start address

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

@ Include ...
.align 4
.include "sonar.s"

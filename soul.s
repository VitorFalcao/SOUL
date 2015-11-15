.include global.s

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

	@ TODO -> ZERAR O CONTADOR!
	

	@ Set the MAX_ALARMS to 8
	ldr r0, =MAX_ALARMS
	mov r1, #8
	str r1, [r0]
	    
	@@
	@	TODO -> SET SP FOR EACH MODE!!
	@   MSR CPSR_c, CODE
	@	MOV sp, ADDRESS
	@@
	
	bl SET_GPIO	
	bl SET_GPT
	bl SET_TZIC

@ Inclui os arquivos de configuracao dos registradores GPIO, GPT, TZIC
.include gpio.s
.include gpt.s
.include tzic.s

@ Inclui os arquivos que lidam com as interrupcoes
.include undefined_instruction.s
.include supervisor.s
.include abort.s
.include irq.s
.include fiq.s


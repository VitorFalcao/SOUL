.text
.align 4
.global _start

_start:

	b teste
	@mov r1, #20
	@mov r7, #22
	@svc 0x0
	@ldr r0, =FUNCAO_2
	@mov r1, #800
	@svc 0x0
	@b loop_DOIDAO

FUNCAO:
	stmfd sp!, {r0-r12, lr}
	mov r0, #0
	mov r1, #10
	mov r7, #18
	svc 0x0
	ldmfd sp!, {r0-r12, lr}
	b loop

FUNCAO_2:
	stmfd sp!, {r0-r12, lr}
	mov r0, #20
	mov r1, #0
	mov r7, #19
	svc 0x0	
	ldmfd sp!, {r0-r12, lr}
	b funcao

loop_DOIDAO:
	b loop_DOIDAO

teste:
	mov r0, #10
	mov r1, #10
	mov r7, #19
	svc 0x0
funcao:
	mov r0, #3
	mov r7, #16
	svc 0x0
	cmp r0, #1200
	bhi funcao
retorno:
	mov r0, #1
	mov r1, #0
	mov r7, #18
	svc 0x0
loop:
	b loop
	

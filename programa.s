.text
.align 4
.global _start

_start:

	b loop
	mov r0, #20
	mov r1, #20
	mov r7, #19
	svc 0x0
	b loop

loop:
	mov r0, #3
	mov r7, #16
	svc 0x0	
retorno:
	
	cmp r0, #1200
	blt vira	
	b loop

vira:
	mov r0, #20
	mov r1, #0
	mov r7, #19
	svc 0x0
	b loop2
loop2:
	b loop2

.text
.align 4
.global _start

_start:

	b loop

loop:

	mov r7, #20
	svc 0x0
	mov r5, #13
	b loop

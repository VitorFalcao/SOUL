	.arch armv5te
	.fpu softvfp
	.eabi_attribute 20, 1
	.eabi_attribute 21, 1
	.eabi_attribute 23, 3
	.eabi_attribute 24, 1
	.eabi_attribute 25, 1
	.eabi_attribute 26, 1
	.eabi_attribute 30, 6
	.eabi_attribute 18, 4
	.file	"t.c"
	.text
	.align	2
	.global	_start
	.type	_start, %function
_start:
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 1, uses_anonymous_args = 0
	stmfd	sp!, {fp, lr}
	add	fp, sp, #4
	ldr	r0, .L4
	mov	r1, #5
	bl	add_alarm
	mov	r0, #3
	mov	r1, #1200
	ldr	r2, .L4+4
	bl	register_proximity_callback
.L2:
	b	.L2
.L5:
	.align	2
.L4:
	.word	set_2
	.word	set
	.size	_start, .-_start
	.align	2
	.global	set
	.type	set, %function
set:
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 1, uses_anonymous_args = 0
	stmfd	sp!, {fp, lr}
	add	fp, sp, #4
	mov	r0, #30
	mov	r1, #0
	bl	set_motors_speed
	ldmfd	sp!, {fp, pc}
	.size	set, .-set
	.align	2
	.global	set_2
	.type	set_2, %function
set_2:
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 1, uses_anonymous_args = 0
	stmfd	sp!, {fp, lr}
	add	fp, sp, #4
	mov	r0, #10
	mov	r1, #10
	bl	set_motors_speed
	ldmfd	sp!, {fp, pc}
	.size	set_2, .-set_2
	.ident	"GCC: (GNU) 4.4.3"
	.section	.note.GNU-stack,"",%progbits

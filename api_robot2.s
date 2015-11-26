@@@
@	Vitor Falcao da Rocha
@	157537
@	MC 404 - Trabalho 02
@	api_robot2.s
@@@

.global set_motor_speed
.global set_motors_speed
.global read_sonar
.global read_sonars
.global register_proximity_callback
.global add_alarm
.global get_time
.global set_time

.align 4

set_motor_speed:

	stmfd sp!, {r4-r11, lr}                         
    mov r7, #18               
    svc 0x0             
    ldmfd sp!, {r4-r11, lr}            
    mov pc, lr

set_motors_speed:

	stmfd sp!, {r4-r11, lr}
	mov r7, #19
	svc 0x0
	ldmfd sp!, {r4-r11, lr}
	mov pc, lr

read_sonar:

	stmfd sp!, {r4-r11, lr}
	mov r7, #16
	svc 0x0
	ldmfd sp!, {r4-r11, lr}
	mov pc, lr

read_sonars:
	
	stmfd sp!, {r4-r11, lr}
	mov r1, r0 @ Armazena o endereco do vetor
	mov r2, #0 @ Zera o contador
	b read_sonars_loop

read_sonars_loop:

	cmp r2, #16
	beq read_sonars_loop_exit
	mov r0, r2
	bl read_sonar
	str r0, [r1] @ Salva o valor lido no vetor
	add r1, r1, #4 @ Pula para a proxima posicao do vetor
	add r2, r2, #1 @ Incrementa o contador
	b read_sonars_loop

read_sonars_loop_exit:

	ldmfd sp!, {r4-r11, lr}
	mov pc, lr

register_proximity_callback:

	stmfd sp!, {r4-r11, lr}
	mov r7, #17
	svc 0x0
	ldmfd sp!, {r4-r11, lr}
	mov pc, lr

add_alarm:

	stmfd sp!, {r4-r11, lr}
	mov r7, #22
	svc 0x0
	ldmfd sp!, {r4-r11, lr}
	mov pc, lr
	
get_time:

	stmfd sp!, {r4-r11, lr}
	mov r7, #20
	svc 0x0
	ldmfd sp!, {r4-r11, lr}
	mov pc, lr

set_time:

	stmfd sp!, {r4-r11, lr}
	mov r7, #21
	svc 0x0	
	ldmfd sp!, {r4-r11, lr}
	mov pc, lr
	

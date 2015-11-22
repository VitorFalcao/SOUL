SEARCH_ALARM_CONTINUE:

    @ Back to the loop position
    ldmfd sp!, {pc}

ORGANIZE_VECTOR:

    @ Move to r0 the current alarm time postion
    add r0, r3, r4
    sub r1, r1, #1

@ At the point where the alarm was found, move every data in the vector one position back
loop_vector2:

    cmp r2, r1
    bge loop_end2

    @ Save the next time in the current time position
    ldr r3, [r0, #8]
    str r3, [r0]

    @ Save te next funcion address in the current function address postion
    add r0, r0, #4
    ldr r3, [r0, #8]
    str r3, [r0]
    
    add r2, r2, #1
    b loop_vector2
        
loop_end2:

    mov pc, lr

SEARCH_ALARM:

	stmfd sp!, {r4-r7, lr}

	ldr r0, =ALARM_CALLBACK_LOOP_FLAG
	ldr r0, [r0]
	
	@ Carrega em r1 o tamanho do vetor
    ldr r0, =ALARM_VECTOR_SZ
    ldr r1, [r0]
    mov r2, #0
	ldr r3, =ALARM_VECTOR

loop_vector:

    @ Enquanto nao chegar o fim do vetor
    cmp r2, r1
    bge loop_end	

    @ Carrega o valor da posicao BASE + r2*8 do vetor
   	mul r4, r2, #8
	ldr r5, [r3, r4]

    @ Carrega em r7 o tempo atual
    ldr r6, =TIME
    ldr r7, [r4]
    
    @ Se o tempo do alarme for igual ao tempo atual vai para a funcao referente 
    @ Salvar r0-r3 na pilha
    stmfd sp!, {r0-r3}
	add r0, r3, r4
	add r0, r0, #4 @ Adiciona 4 ao endereco do tempo, para acessar a funcao

    cmp r5, r7
    bleq call_function	

    @ Recupera o valor de r0-r3
    ldmfd sp!, {r0-r3}
    add r2, r2, #1

    b loop_vector

loop_end:

	@ TODO -> SORT VECTOR!
    
    @ Desempilha lr
	ldmfd sp!, {r4-r7, lr}
    mov pc, lr

call_function:
	
	stmfd sp!, {r0-r3, lr} @ Saves the current loop position and state

    bl ORGANIZE_VECTOR

    ldmfd sp!, {r0-r3}

	ldr r1, =MAX_ALARMS @ Defined in global.s
	ldr r0, [r1]

	add r0, r0, #1
	str r0, [r1] @ Updates the number of available alarms

    ldr r1 =ALARM_VECTOR_SZ
    ldr r0, [r1]
    sub r0, r0, #1
    str r0, [r1] @ Updates the size of alarm vector

    msr CPSR_c, #0x10 @ Changes mode to User mode

    blx r0 @ Calls the user function

	mov r7, #30 @ Special syscall
    svc 0x0 


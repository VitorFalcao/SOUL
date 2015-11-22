SEARCH_ALARM_CONTINUE:

	ldmfd sp!, {r0-r3} @ Loads the loop state 	

	b loop_vector

SEARCH_ALARM:

	stmfd sp!, {lr}

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
	add r0, r3, r4
	add r0, r0, #4 @ Adiciona 4 ao endereco do tempo, para acessar a funcao

    cmp r5, r7
    bleq call_function	

    @ Recupera o valor de r0-r3
    add r2, r2, #1

    b loop_vector

loop_end:
    
    @ Desempilha lr
	ldmfd sp!, {lr}
    mov pc, lr

call_function:
	
	stmfd sp!, {r0-r3} @ Saves the current loop state

	ldr r1, =MAX_ALARMS @ Defined in global.s
	ldr r0, [r1]

	add r0, r0, #1
	str r0, [r1] @ Updates the number of available alarms

    ldr r1 =ALARM_VECTOR_SZ
    ldr r0, [r1]
    sub r0, r0, #1
    str r0, [r1] @ Updates the size of alarm vector

    msr CPSR_c, #0x10 @ Changes mode to User mode

    mov pc, r0 @ Calls the user function

	mov r7, #30 @ Special syscall
    svc 0x0 


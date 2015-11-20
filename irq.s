IRQ_HANDLER:

    @Salva r0-r12 na pilha
	stmfd sp!, {r1-r12, lr}
 
    @ Coloca 0x1 no GPT_SR
    mov r1, #0x1
    ldr r2, =0x53FA0008
    str r1, [r2]
  
    @ Adiciona 1 ao contador
    ldr r1, =TIME
    ldr r2, [r1]
    add r2, r2, #1
    str r2, [r1]

    bl SEARCH_ALARM
  
    @Desempilha r0-r12
	ldmfd sp!, {r1-r12, lr}

    @ Retorna da interrupcao
    sub lr, lr, #4
    movs pc, lr

SEARCH_ALARM:

	@ TODO -> REVISAR OS REGISTRADORES QUE DEVEM SER SALVOS!

    @Salvar r4-r12, lr na pilha!
	stmfd sp!, {r4-r12, lr}

    @Carrega em r1 o tamanho do vetor
    ldr r0, =ALARM_VECTOR_SZ
    ldr r1, [r0]
    mov r2, #0
	ldr r3, =ALARM_VECTOR

loop_vector:

    @ Enquanto nao chegar o fim do vetor
    cmp r2, r1
    bge loop_end	

    @Carrega o valor da posicao BASE + r2*8 do vetor
   	mul r4, r2, #8
	ldr r5, [r3, r4]

    @Carrega em r7 o tempo atual
    ldr r6, =TIME
    ldr r7, [r4]
    
    @Se o tempo do alarme for igual ao tempo atual vai para a funcao referente 
    @Salvar r0-r3 na pilha
	add r0, r3, r4
	add r0, r0, #4 @ Adiciona 4 ao endereco do tempo, para acessar a funcao

    cmp r5, r7
    bleq call_function	

    @Recupera o valor de r0-r3
    add r2, r2, #1

    b loop_vector

loop_end:
    
    @Desempilha r4-r12
	ldmfd sp!, {r4-r12, lr}
    mov pc, lr

call_function:
	
	stmfd sp!, {r0-r1, lr}

	movs pc, r0
	
	@ Volta o modo para SUPERVISOR
	msr CPSR_c, #0x13

	ldr r1, =MAX_ALARMS @ Definido em global.s
	ldr r0, [r1]

	add r0, r0, #1
	str r0, [r1] @ Updates the number of available alarms

    ldr r1 =ALARM_VECTOR_SZ
    ldr r0, [r1]
    sub r0, r0, #1
    str r0, [r1] @Updates the size of alarm vector

	ldmfd sp!, {r0-r1, lr}
	mov pc, lr

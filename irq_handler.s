.include global.s
.set TIME, 0x77801800

IRQ_HANDLER:

    @Salva r0-r12 na pilha
    
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

    @ Retorna da interrupcao
    sub lr, lr, #4
    movs pc, lr

SEARCH_ALARM:

    @Salvar r4-r12, lr na pilha!

    @Carrega em r1 o tamanho do vetor
    ldr r0, =ALARM_VECTOR_SZ
    ldr r1, [r0]
    mov r2, #0

loop_vector:

    @ Enquanto nao chegar o fim do vetor
    cmp r2, r1
    bge loop_end

    @Carrega o valor da posicao r2 do vetor
    ldr r3, [r2, #ALARM_VECTOR, #8]!

    @Carrega em r5 o tempo atual
    ldr r4, =TIME
    ldr r5, [r4]
    
    @Se o tempo do alarme for igual ao tempo atual vai para a funcao referente 
    @Salvar r0-r3 na pilha
    cmp r3, r5
    bleq [r2, #4]

    @Recupera o valor de r0-r3

    b loop_vector

loop_end:
    
    @Desempilha r4-r12

    mov pc, lr

IRQ_HANDLER:

    @Salva r0-r12 na pilha
	stmfd sp!, {r0-r12, lr}
 
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
    bl SEARCH_CALLBACK
  
    @ Desempilha r0-r12
	ldmfd sp!, {r0-r12, lr}

    @ Retorna da interrupcao
    sub lr, lr, #4
    movs pc, lr

.include "alarm.s"
.include "callback.s"


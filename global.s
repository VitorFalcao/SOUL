@ Size of alarm vector  (endereco faltando)
.set ALARM_VECTOR_SIZE, ADDRES

@ First position of alarm vector
.set ALARM_VECTOR, ADDRESS

@ System time
.set TIME, ADDRESS

@ Max numbers of alarm. Set in  RESET_HANDLER

@ GPIO memory positions
.set GPIO_BASE, 0x53F84000                                                  
.set MAX_ALARMS, ENDERECO

@ First position of the callback vector
.set CALLBACK_VECTOR, ADDRESS

@ Max number of callbacks. Set in RESET_HANDLER
.set MAX_CALLBACKS, ADDRESS

@ Size of callback vector
.set CALLBACK_VECTOR_SIZE, ADDRESS

@ Sets the address of the flag used to control de loop of the alarm callbacks
.set ALARM_CALLBACK_LOOP_FLAG, ADDRESS

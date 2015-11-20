@ Size of alarm vector  (endereco faltando)
.set ALARM_VECTOR_SIZE, XXXXXXX

@ First position of alarm vector
.set ALARM_VECTOR, XXXXXXX

@ System time
.set TIME, 0x77801800

@ Max numbers of alarm. Set in  RESET_HANDLER
.set MAX_ALARMS, XXXXXXXX

@ GPIO memory positions
.set GPIO_BASE, 0x53F84000                                                  
.set GPIO_GDIR, 0x4
.set GPIO_PSR, 0x08         

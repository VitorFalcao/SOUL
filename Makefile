# Disciplina: MC404 - 1o semestre de 2015
# Professor: Edson Borin
#
#
# ----------------------------------------

# ----------------------------------
# SOUL object files -- Add your SOUL object files here 
SOUL_OBJS=soul.o 

# ----------------------------------
# Compiling/Assembling/Linking Tools and flags
AS=arm-eabi-as
AS_FLAGS=-g

CC=arm-eabi-gcc
CC_FLAGS=-g

LD=arm-eabi-ld
LD_FLAGS=-g

# ----------------------------------
# Default rule
all: disk.img

# ----------------------------------
# Generic Rules
%.o: %.s
	$(AS) $(AS_FLAGS) $< -o $@

%.o: %.c
	$(CC) $(CC_FLAGS) -c $< -o $@

# ----------------------------------
# Specific Rules
soul.x: $(SOUL_OBJS)
	$(LD) $^ -o $@ $(LD_FLAGS) --section-start=.iv=0x778005e0 -Ttext=0x77800700 -Tdata=0x77801800 -e 0x778005e0

ronda.x: ronda.o api_robot2.o
	$(LD) $^ -o $@ $(LD_FLAGS) -Ttext=0x77802000

programa.x: programa.o
	$(LD) $^ -o $@ $(LD_FLAGS) -Ttext=0x77802000

programa.o: programa.s
	arm-eabi-as programa.s -o programa.o

disk.img: soul.x programa.x
	mksd.sh --so soul.x --user programa.x

clean:
	rm -f soul.x programa.x disk.img *.o
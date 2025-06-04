PREFIX=riscv64-linux-gnu-
CPP = $(PREFIX)cpp
CC = $(PREFIX)gcc
AS = $(PREFIX)as
LD = $(PREFIX)ld
OBJCOPY = $(PREFIX)objcopy
OBJDUMP = $(PREFIX)objdump

# Compiler and linker flags
CPP_FLAGS = 
AS_FLAGS = -march=rv64g_zbb -g
CFLAGS = -Wall -nostdlib -nostartfiles -g
LDFLAGS = -T linker.ld

all:
	$(CPP) $(CPP_FLAGS) start.S -o kernel.i
	$(AS) $(AS_FLAGS) kernel.i -o kernel.o
	$(LD) $(LDFLAGS) kernel.o -o kernel.elf

objdump:
	$(OBJDUMP) -D kernel.elf


clean:
	rm *.o
	rm *.i
	rm *.elf



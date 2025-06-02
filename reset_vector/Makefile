FILE_NAME=kernel
PREFIX=riscv64-linux-gnu-
CPP = $(PREFIX)cpp
CC = $(PREFIX)gcc
AS = $(PREFIX)as
LD = $(PREFIX)ld
OBJCOPY = $(PREFIX)objcopy
OBJDUMP = $(PREFIX)objdump

# Source files
ASM_SRC = $(FILE_NAME).S

# Output files
ASM_I = $(FILE_NAME).i
ASM_OBJ = $(FILE_NAME).o
ELF = $(FILE_NAME).elf
BIN = $(FILE_NAME).bin

# Compiler and linker flags
CPP_FLAGS = -march=rv64g_zbb -g
CFLAGS = -Wall -nostdlib -nostartfiles -g
LDFLAGS = -T linker.ld

all: $(BIN)

$(ASM_I): $(ASM_SRC)
	$(CPP) -o $@ $<

$(ASM_OBJ): $(ASM_I)
	$(AS) $(CPP_FLAGS) -o $@ $<

$(ELF): $(ASM_OBJ)
	$(LD) $(LDFLAGS) -o $@ $^

$(BIN): $(ELF)
	$(OBJCOPY) -O binary $< $@

objdump: $(ELF)
	$(OBJDUMP) -D $<

run: $(ELF)
	echo "Running $<"
	qemu-system-riscv64 \
	-machine virt \
	-cpu rv64 \
	-smp 4 \
	-m 8192M \
	-nographic \
	-serial mon:stdio \
	-bios none \
	-kernel $<

debug: $(ELF)
	echo "Running $<"
	qemu-system-riscv64 \
	-machine virt \
	-cpu rv64 \
	-smp 4 \
	-m 8192M \
	-nographic \
	-serial mon:stdio \
	-bios none \
	-kernel $< \
	-s \
	-S

clean:
	rm -f $(ASM_I) $(ASM_OBJ) $(ELF) $(BIN) 

.PHONY: all clean


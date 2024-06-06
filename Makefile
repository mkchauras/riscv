# Define the RISC-V tools
RISCV_PREFIX = riscv64-linux-gnu-
CC = $(RISCV_PREFIX)gcc
AS = $(RISCV_PREFIX)as
LD = $(RISCV_PREFIX)ld
OBJCOPY = $(RISCV_PREFIX)objcopy

# Source files
SRC = bios.S

# Output files
OBJ = bios.o
ELF = bios.elf
BIN = bios.bin

# Compiler and linker flags
CFLAGS = -Wall -nostdlib -nostartfiles -march=rv64imac -mabi=lp64
LDFLAGS = -T linker.ld

all: $(BIN)

$(OBJ): $(SRC)
	$(AS) -g -o $@ $<

$(ELF): $(OBJ)
	$(LD) $(LDFLAGS) -o $@ $^

$(BIN): $(ELF)
	$(OBJCOPY) -O binary $< $@

clean:
	rm -f $(OBJ) $(ELF) $(BIN)

.PHONY: all clean


PREFIX = riscv64-linux-gnu-

CPP     = $(PREFIX)cpp
CC      = $(PREFIX)gcc
AS      = $(PREFIX)as
LD      = $(PREFIX)ld
OBJCOPY = $(PREFIX)objcopy
OBJDUMP = $(PREFIX)objdump

COMMONFLAGS = -march=rv64g_zbb -fno-pic -mcmodel=medany -Wall -nostdlib -nostartfiles -g

CPPFLAGS =
ASFLAGS  = $(COMMONFLAGS)
CFLAGS   = $(COMMONFLAGS)
LDFLAGS  = -T linker.ld

C_SRCS := $(wildcard *.c)
S_SRCS := $(wildcard *.S)

# Intermediate preprocessed files for .S
I_SRCS := $(S_SRCS:.S=.i)

# Object files
C_OBJS := $(C_SRCS:.c=.o)
S_OBJS := $(S_SRCS:.S=.o)
OBJS   := $(C_OBJS) $(S_OBJS)

# Default: Just compile object files
all: ELF

# Compile .c -> .o
%.o: %.c
	$(CC) $(CFLAGS) -c $< -o $@

# Preprocess .S -> .i
%.i: %.S
	$(CPP) $(CPPFLAGS) $< -o $@
	echo $<

# Assemble .i -> .o
%.o: %.i
	$(AS) $(ASFLAGS) $< -o $@

# Optional: Link everything to ELF
ELF: $(OBJS)
	$(LD) $(LDFLAGS) -o kernel.elf $(OBJS)

# Optional: Disassemble
objdump: ELF
	$(OBJDUMP) -D kernel.elf > kernel.dump
	cat kernel.dump | less

# Clean
clean:
	rm -f *.o *.i *.elf *.dump


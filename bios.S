# Define UART base address and configuration values
.equ UART_BASE_ADDR, 0x10000000
.equ UART_CONFIG, 0x00000003  # Example configuration value
	
.section .text
.globl _start

_start:
    # Set up stack pointer
    la sp, stack_top

    # Initialize memory (example: clear BSS section)
    la t0, _bss_start
    la t1, _bss_end
clear_bss:
    bge t0, t1, bss_cleared
    sw zero, 0(t0)
    addi t0, t0, 4
    j clear_bss
bss_cleared:

    # Initialize UART for console output (example, hardware-specific)
    # Setup UART base address
    la t0, UART_BASE_ADDR
    # Configure UART (baud rate, etc.)
    li t1, UART_CONFIG
    sw t1, 0(t0)

    # Print "BIOS Initialized" to UART
    la t0, message
print_loop:
    lbu t1, 0(t0)
    beq t1, zero, print_done
    la t2, UART_BASE_ADDR
    sw t1, 4(t2)  # Assume TX register is at offset 4
    addi t0, t0, 1
    j print_loop
print_done:

    # Jump to bootloader or kernel
    la t0, bootloader_start
    jr t0

.section .data
message:
    .asciz "BIOS Initialized\n"

.section .bss
.balign 4
_bss_start:
    .space 1024  # Example BSS size
_bss_end:

.section .stack
.balign 16
stack_top:
    .space 4096  # 4KB stack size

.section .bootloader
.globl bootloader_start
bootloader_start:
    # Bootloader or kernel start code here
    # For example, load kernel into memory and jump to it
    j .



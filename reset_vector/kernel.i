# 0 "kernel.S"
# 0 "<built-in>"
# 0 "<command-line>"
# 1 "kernel.S"

  .section .text._start
  .global _start

_start:
  # Enable all specific interrupts in the mie register
  li t0, 0x00000000 # Load a value with all bits set to 1
  csrw mie, t0 # Write this value to the mie register
  # Enable global interrupts by setting the MIE bit in the mstatus register
  csrr t0, mstatus # Read mstatus into t0
  ori t0, t0, 0x8 # Set the MIE bit (bit 3)
  csrw mstatus, t0 # Write back to mstatus

  # If not 0th core, wait for interrupt
  csrr t0, mhartid
  bnez t0, _wait_loop
  j _set_reg_value
_loop:
  rol t1, t1, t0
  beqz t1, _set_reg_value
  j _loop

_set_reg_value:
  la t1, 0xAA
  la t0, 0x01
  j _loop

_wait_loop:
  wfi

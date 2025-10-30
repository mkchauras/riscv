# Interrupt Handler

.section .text._mtrap_vec
.global mtrap_vector_table
mtrap_vector_table:
	csrr a0, mcause
	csrr a1, mtval 
	csrr a2, mepc
	jal trap_handler
	csrr t0, mepc
	addi t0, t0, 0x04
	csrw mepc, t0
	mret

.section .text._strap_vec
.global strap_vector_table
strap_vector_table:
	csrr a0, scause
	csrr a1, stval 
	jal trap_handler
	sret

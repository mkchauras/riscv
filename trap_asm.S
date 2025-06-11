# Interrupt Handler

.section .text._mtrap_vec
.global mtrap_vector_table
mtrap_vector_table:
	csrr a0, mcause
	csrr a1, mtval 
	jal trap_handler
	mret

.section .text._strap_vec
.global strap_vector_table
strap_vector_table:
	csrr a0, scause
	csrr a1, stval 
	jal trap_handler
	sret

#include "uart.h"

void trap_handler(unsigned long mcause, unsigned long mtval, unsigned long mepc)
{
	printk("Inside %s with mcause: %ld mepc: %x and mtval: %ld\n", __func__, mcause, mepc, mtval);
}

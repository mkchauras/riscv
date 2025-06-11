#include "uart.h"

void trap_handler(unsigned long mcause, unsigned long mtval)
{
	printk("Inside %s with mcause: %ld and mtval: %ld");
}

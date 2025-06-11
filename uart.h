#ifndef _UART_H_
#define _UART_H_

#define UART0_BASE 0x10000000
#define UART0_THR  (*(volatile unsigned char *)(UART0_BASE + 0x00))
#define UART0_LSR  (*(volatile unsigned char *)(UART0_BASE + 0x05))

void printk(const char *fmt, ...);

#endif

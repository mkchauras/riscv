#include "uart.h"

static void put_char(char ch)
{
	// Wait until Transmit Holding Register is empty
	while ((UART0_LSR & 0x20) == 0);
	UART0_THR = ch;
}

// Declare your low-level output function
void put_char(char c);

// Our own minimal va_list
typedef __builtin_va_list va_list;
#define va_start(v, l)   __builtin_va_start(v, l)
#define va_end(v)        __builtin_va_end(v)
#define va_arg(v, t)     __builtin_va_arg(v, t)

// Print string
static void print_str(const char *s) {
    while (*s) put_char(*s++);
}

// Print unsigned integer
static void print_uint(unsigned long val, int base) {
    char buf[20];
    int i = 0;
    const char *digits = "0123456789abcdef";

    if (val == 0) {
        put_char('0');
        return;
    }

    while (val > 0) {
        buf[i++] = digits[val % base];
        val /= base;
    }

    while (i--) {
        put_char(buf[i]);
    }
}

// Print signed integer
static void print_int(long val) {
    if (val < 0) {
        put_char('-');
        print_uint((unsigned long)(-val), 10);
    } else {
        print_uint((unsigned long)val, 10);
    }
}

// The main printf implementation
void printk(const char *fmt, ...) {
    va_list ap;
    va_start(ap, fmt);

    while (*fmt) {
        if (*fmt == '%') {
            fmt++;
            switch (*fmt) {
                case 'c': {
                    char c = (char)va_arg(ap, int);
                    put_char(c);
                    break;
                }
                case 's': {
                    char *s = va_arg(ap, char *);
                    if (s)
                        print_str(s);
                    else
                        print_str("(null)");
                    break;
                }
                case 'd':
                case 'i': {
                    int d = va_arg(ap, int);
                    print_int(d);
                    break;
                }
                case 'u': {
                    unsigned int u = va_arg(ap, unsigned int);
                    print_uint(u, 10);
                    break;
                }
                case 'x': {
                    unsigned int x = va_arg(ap, unsigned int);
                    print_uint(x, 16);
                    break;
                }
                case 'p': {
                    unsigned long p = (unsigned long)va_arg(ap, void *);
                    print_str("0x");
                    print_uint(p, 16);
                    break;
                }
                case '%': {
                    put_char('%');
                    break;
                }
                default:
                    put_char('%');
                    put_char(*fmt);
                    break;
            }
        } else {
            put_char(*fmt);
        }
        fmt++;
    }

    va_end(ap);
}


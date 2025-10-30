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

void printk(const char *fmt, ...) {
    va_list ap;
    va_start(ap, fmt);

    while (*fmt) {
        if (*fmt == '%') {
            fmt++;
            int long_flag = 0;
            int long_long_flag = 0;

            // Handle length modifiers: l / ll
            if (*fmt == 'l') {
                fmt++;
                if (*fmt == 'l') {
                    long_long_flag = 1;
                    fmt++;
                } else {
                    long_flag = 1;
                }
            }

            switch (*fmt) {
                case 'd':
                case 'i': {
                    if (long_long_flag) {
                        long long val = va_arg(ap, long long);
                        print_int(val);
                    } else if (long_flag) {
                        long val = va_arg(ap, long);
                        print_int(val);
                    } else {
                        int val = va_arg(ap, int);
                        print_int(val);
                    }
                    break;
                }
                case 'u': {
                    if (long_long_flag) {
                        unsigned long long val = va_arg(ap, unsigned long long);
                        print_uint(val, 10);
                    } else if (long_flag) {
                        unsigned long val = va_arg(ap, unsigned long);
                        print_uint(val, 10);
                    } else {
                        unsigned int val = va_arg(ap, unsigned int);
                        print_uint(val, 10);
                    }
                    break;
                }
                case 'x': {
                    if (long_long_flag) {
                        unsigned long long val = va_arg(ap, unsigned long long);
                        print_uint(val, 16);
                    } else if (long_flag) {
                        unsigned long val = va_arg(ap, unsigned long);
                        print_uint(val, 16);
                    } else {
                        unsigned int val = va_arg(ap, unsigned int);
                        print_uint(val, 16);
                    }
                    break;
                }
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


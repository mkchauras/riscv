ENTRY(_start)

STACK_SIZE = DEFINED(__stack_size__) ? __stack_size__ : 0x8192;

SECTIONS
{
    /* Define start address */
    . = 0x80000000;

    /* Entry point / startup code */
    .text.start : {
        *(.text._start)
    }

    /* General text/code section */
    .text : ALIGN(4) {
        *(.text)
        *(.text.*)
    }

    /* Read-only data (like string literals) */
    .rodata : ALIGN(4) {
        *(.rodata)
        *(.rodata.*)
    }

    /* Initialized data */
    .data : ALIGN(4) {
        *(.data)
        *(.data.*)
    }

    /* Uninitialized data */
    .bss : ALIGN(4) {
        *(.bss)
        *(COMMON)
    }

    /* Stack at the end */
    . = ALIGN(8);
    __stack_start = .;
    . = . + STACK_SIZE;
    . = ALIGN(8);
    __stack_end = .;
}


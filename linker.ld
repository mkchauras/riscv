ENTRY(_start)

SECTIONS
{
    /* Define the start of the program at address 0x80000000 */
    . = 0x80000000;

    .text : {
        *(.text .text.*)
    }

    .rodata : {
        *(.rodata .rodata.*)
    }

    .data : {
        *(.data .data.*)
    }

    .bss : {
        _bss_start = .;
        *(.bss .bss.*)
        _bss_end = .;
    }

    .stack (NOLOAD) : {
        stack_top = . + 0x1000;  /* 4KB stack */
        . += 0x1000;
    }
}


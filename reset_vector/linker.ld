ENTRY(_start)

SECTIONS
{
    /* Define the start of the text segment */
    . = 0x80000000;
    .text.start : {
        *(.text._start)
    }

    .data : {
        *(.data)
    }

    .bss : {
        *(.bss)
        *(COMMON)
    }
}


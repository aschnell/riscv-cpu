/* GCC Linker Script */

ENTRY(__reset)

SECTIONS
{
    . = 0x10000;

    .text : {
	__text_start = .;
	*(.vectors)
	*(.text)
	__text_end = .;
    }

    . = 0x20000;

    .data : {
	*(.data)
    }

    .rodata : {
	*(.rodata)
    }

    __global_pointer = .;

    .bss : {
	__bss_start = .;
	*(.bss)
	__bss_end = .;
    }

    . = 0x20080;

    .stack : {
        __stack_start = .;
	  . = 0x00080; /* relative (within braces?) */
        __stack_pointer = .;
    }
}

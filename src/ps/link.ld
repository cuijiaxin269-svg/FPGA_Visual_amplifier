ENTRY(_start)
MEMORY { app (rwx) : ORIGIN = 0x00100000, LENGTH = 0x00e00000
         mailbox (rw) : ORIGIN = 0x00ff0000, LENGTH = 0x00010000 }
SECTIONS {
 __mailbox_start = ORIGIN(mailbox);
 __mailbox_end = ORIGIN(mailbox) + LENGTH(mailbox);
 .text : { KEEP(*(.vectors)) *(.text*) *(.rodata*) } > app
 .data : { *(.data*) } > app
 .bss (NOLOAD) : { . = ALIGN(8); __bss_start = .; *(.bss*) *(COMMON) . = ALIGN(8); __bss_end = .; } > app
 .stack (NOLOAD) : { . = ALIGN(16); . += 0x8000; __stack_top = .; } > app
 .irq_stack (NOLOAD) : { . = ALIGN(16); . += 0x1000; __irq_stack_top = .; } > app
 .mailbox (NOLOAD) : { KEEP(*(.mailbox)) } > mailbox
 .hmi_diag 0x00ff2000 (NOLOAD) : { KEEP(*(.hmi_diag)) } > mailbox
 .hmi_trace 0x00ff2100 (NOLOAD) : { KEEP(*(.hmi_trace)) } > mailbox
 .hmi_probe 0x00ff6300 (NOLOAD) : { KEEP(*(.hmi_probe)) } > mailbox
 /DISCARD/ : { *(.comment*) *(.note*) *(.ARM.exidx*) *(.ARM.extab*) }
}
ASSERT(__stack_top < 0x00f00000, "App overlaps mailbox reservation")
ASSERT(__irq_stack_top < 0x00f00000, "IRQ stack overlaps mailbox reservation")
ASSERT(SIZEOF(.hmi_diag) <= 0x100, "HMI diagnostics overflow")
ASSERT(ADDR(.hmi_trace) + SIZEOF(.hmi_trace) <= 0x00ff6300, "HMI trace overflow")
ASSERT(ADDR(.hmi_probe) + SIZEOF(.hmi_probe) <= 0x00ff6400, "HMI probe overflow")

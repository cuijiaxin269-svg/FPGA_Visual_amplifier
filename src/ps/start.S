.syntax unified
.cpu cortex-a9
#ifdef MOTION60_VFP
.fpu vfpv3
#endif
.arm
.section .vectors,"ax"
.global _start
_start:
 b reset
 b .
 b .
 b .
 b .
 b .
#ifdef MOTION60_HMI
 b hmi_irq_entry
#else
 b .
#endif
 b .
reset:
 cpsid if
 // Supported entry: matching AMD FSBL handoff or cold JTAG loader.
 // FSBL flushes/disables data caches before loading partitions and hands off
 // with MMU/I-cache disabled. DMA buffers remain uncached throughout.
 mrc p15,0,r0,c1,c0,0
 bic r0,r0,#1
 bic r0,r0,#4
 bic r0,r0,#0x1000
#ifdef MOTION60_HMI
 bic r0,r0,#0x2000
#endif
 mcr p15,0,r0,c1,c0,0
 dsb sy
 isb
 mov r0,#0
 mcr p15,0,r0,c7,c5,0
 mcr p15,0,r0,c7,c5,6
 mcr p15,0,r0,c8,c7,0
 dsb sy
 isb
#ifdef MOTION60_VFP
 // Cortex-A9 CP10/CP11 access and FPEXC.EN, as in AMD standalone boot.S.
 mrc p15,0,r1,c1,c0,2
 orr r1,r1,#0x00f00000
 mcr p15,0,r1,c1,c0,2
 isb
 vmrs r1,fpexc
 orr r1,r1,#0x40000000
 vmsr fpexc,r1
 // IEEE round-to-nearest, no flush-to-zero/default-NaN shortcuts.
 mov r1,#0
 vmsr fpscr,r1
 isb
#endif
#ifdef MOTION60_HMI
 cps #0x12
 ldr sp,=__irq_stack_top
 cps #0x13
 ldr r0,=_start
 mcr p15,0,r0,c12,c0,0
 isb
#endif
 ldr sp,=__stack_top
 ldr r0,=__bss_start
 ldr r1,=__bss_end
 mov r2,#0
1: cmp r0,r1
 strlo r2,[r0],#4
 blo 1b
 // ELF NOLOAD regions and fixed-address telemetry are not file payload.
 // Clear the whole reserved mailbox page independently of the downloader.
 ldr r0,=__mailbox_start
 ldr r1,=__mailbox_end
3: cmp r0,r1
 strlo r2,[r0],#4
 blo 3b
 dsb sy
 bl main
2: b 2b
#ifdef MOTION60_HMI
.align 4
hmi_irq_entry:
 sub lr,lr,#4
 stmdb sp!,{r0-r12,lr}
 mrs r0,spsr
 sub sp,sp,#8
 str r0,[sp]
 bl hmi_irq_dispatch
 ldr r0,[sp]
 add sp,sp,#8
 msr spsr_cxsf,r0
 ldmia sp!,{r0-r12,pc}^
#endif

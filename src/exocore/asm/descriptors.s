%include "exocore/asm/segments.s"

section .text

global gdt_flush

align 8
gdt_flush:

%if EXOCORE_IS_32_BIT
    mov eax, [esp + 4] ; GDT pointer is the first argument.

    ; Load the GDT.
    lgdt [eax]

    ; Load segment selectors.
    mov ax, KERNEL_DATA_SEGMENT
    mov ds, ax
    mov es, ax
    mov fs, ax
    mov gs, ax
    mov ss, ax

    ; Far jump to new code segment.
    jmp KERNEL_CODE_SEGMENT:.flush

align 8
.flush:
%else

    ; Load the GDT.
    lgdt [rdi]
%endif

    ret

global idt_flush

align 8
idt_flush:

%if EXOCORE_IS_32_BIT
    mov eax, [esp + 4] ; IDT pointer is the first argument.

    ; Load the IDT.
    lidt [eax]
%else
    ; Load the GDT.
    lidt [rdi]
%endif

    ret

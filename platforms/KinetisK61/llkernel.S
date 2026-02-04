
//
// llkernel.S - Low-level kernel routines and exception handling.
//
// Copyright (C) 2020-2026 Gabriele Galeotti
//
// This work is licensed under the terms of the MIT License.
// Please consult the LICENSE.txt file located in the top-level directory.
//

#define __ASSEMBLER__ 1

////////////////////////////////////////////////////////////////////////////////

                .syntax unified

                .macro EXCEPTION handler,number
                .thumb_func
                .type   \handler,%function
                .global \handler
\handler:       push    {lr}
                movs    r0,#\number
                mov     r1,lr
                bl      exception_process
                pop     {pc}
                .endm

////////////////////////////////////////////////////////////////////////////////

                .sect   .vectors,"ax"

                .align  7

                .global vectors
vectors:

SP_Main:        .long   0
                .extern _start
Reset:          .long   _start                  //   1
NMI:            .long   NMI_handler             //   2
HardFault:      .long   HardFault_handler       //   3
MemManage:      .long   MemManage_handler       //   4
BusFault:       .long   BusFault_handler        //   5
UsageFault:     .long   UsageFault_handler      //   6
ReservedExc7:   .long   ReservedExc7_handler    //   7
ReservedExc8:   .long   ReservedExc8_handler    //   8
ReservedExc9:   .long   ReservedExc9_handler    //   9
ReservedExcA:   .long   ReservedExcA_handler    //  10
SVCall:         .long   SVCall_handler          //  11
DebugMonitor:   .long   DebugMonitor_handler    //  12
ReservedExcD:   .long   ReservedExcD_handler    //  13
PendSV:         .long   PendSV_handler          //  14
SysTick:        .long   SysTick_handler         //  15

// non-core vectors

Interrupt0:     .long   0                       //  16
Interrupt1:     .long   0                       //  17
Interrupt2:     .long   0                       //  18
Interrupt3:     .long   0                       //  19
Interrupt4:     .long   0                       //  20
Interrupt5:     .long   0                       //  21
Interrupt6:     .long   0                       //  22
Interrupt7:     .long   0                       //  23
Interrupt8:     .long   0                       //  24
Interrupt9:     .long   0                       //  25
Interrupt10:    .long   0                       //  26
Interrupt11:    .long   0                       //  27
Interrupt12:    .long   0                       //  28
Interrupt13:    .long   0                       //  29
Interrupt14:    .long   0                       //  30
Interrupt15:    .long   0                       //  31
Interrupt16:    .long   0                       //  32
Interrupt17:    .long   0                       //  33
Interrupt18:    .long   0                       //  34
Interrupt19:    .long   0                       //  35
Interrupt20:    .long   0                       //  36
Interrupt21:    .long   0                       //  37
Interrupt22:    .long   0                       //  38
Interrupt23:    .long   0                       //  39
Interrupt24:    .long   0                       //  40
Interrupt25:    .long   0                       //  41
Interrupt26:    .long   0                       //  42
Interrupt27:    .long   0                       //  43
Interrupt28:    .long   0                       //  44
Interrupt29:    .long   0                       //  45
Interrupt30:    .long   0                       //  46
Interrupt31:    .long   0                       //  47
Interrupt32:    .long   0                       //  48
Interrupt33:    .long   0                       //  49
Interrupt34:    .long   0                       //  50
Interrupt35:    .long   0                       //  51
Interrupt36:    .long   0                       //  52
Interrupt37:    .long   0                       //  53
Interrupt38:    .long   0                       //  54
Interrupt39:    .long   0                       //  55
Interrupt40:    .long   0                       //  56
Interrupt41:    .long   0                       //  57
Interrupt42:    .long   0                       //  58
Interrupt43:    .long   0                       //  59
Interrupt44:    .long   0                       //  60
Interrupt45:    .long   0                       //  61
Interrupt46:    .long   0                       //  62
Interrupt47:    .long   0                       //  63
Interrupt48:    .long   0                       //  64
Interrupt49:    .long   0                       //  65
Interrupt50:    .long   0                       //  66
Interrupt51:    .long   0                       //  67
Interrupt52:    .long   0                       //  68
Interrupt53:    .long   0                       //  69
Interrupt54:    .long   0                       //  70
Interrupt55:    .long   0                       //  71
Interrupt56:    .long   0                       //  72
Interrupt57:    .long   0                       //  73
Interrupt58:    .long   0                       //  74
Interrupt59:    .long   0                       //  75
Interrupt60:    .long   0                       //  76
Interrupt61:    .long   0                       //  77
Interrupt62:    .long   0                       //  78
Interrupt63:    .long   0                       //  79
Interrupt64:    .long   0                       //  80
Interrupt65:    .long   0                       //  81
Interrupt66:    .long   0                       //  82
Interrupt67:    .long   0                       //  83
Interrupt68:    .long   0                       //  84
Interrupt69:    .long   0                       //  85
Interrupt70:    .long   0                       //  86
Interrupt71:    .long   0                       //  87
Interrupt72:    .long   0                       //  88
Interrupt73:    .long   0                       //  89
Interrupt74:    .long   0                       //  90
Interrupt75:    .long   0                       //  91
Interrupt76:    .long   0                       //  92
Interrupt77:    .long   0                       //  93
Interrupt78:    .long   0                       //  94
Interrupt79:    .long   0                       //  95
Interrupt80:    .long   0                       //  96
Interrupt81:    .long   0                       //  97
Interrupt82:    .long   0                       //  98
Interrupt83:    .long   0                       //  99
Interrupt84:    .long   0                       // 100
Interrupt85:    .long   0                       // 101
Interrupt86:    .long   0                       // 102
Interrupt87:    .long   0                       // 103
Interrupt88:    .long   0                       // 104
Interrupt89:    .long   0                       // 105
Interrupt90:    .long   0                       // 106
Interrupt91:    .long   0                       // 107
Interrupt92:    .long   0                       // 108
Interrupt93:    .long   0                       // 109
Interrupt94:    .long   0                       // 110
Interrupt95:    .long   0                       // 111
Interrupt96:    .long   0                       // 112
Interrupt97:    .long   0                       // 113
Interrupt98:    .long   0                       // 114
Interrupt99:    .long   0                       // 115
Interrupt100:   .long   0                       // 116
Interrupt101:   .long   0                       // 117
Interrupt102:   .long   0                       // 118
Interrupt103:   .long   0                       // 119
Interrupt104:   .long   0                       // 120
Interrupt105:   .long   0                       // 121

////////////////////////////////////////////////////////////////////////////////

                .sect   .text,"ax"

                .extern exception_process
                .extern systick_process
                .extern irq_process

                EXCEPTION NMI_handler,2
                EXCEPTION HardFault_handler,3
                EXCEPTION MemManage_handler,4
                EXCEPTION BusFault_handler,5
                EXCEPTION UsageFault_handler,6
                EXCEPTION ReservedExc7_handler,7
                EXCEPTION ReservedExc8_handler,8
                EXCEPTION ReservedExc9_handler,9
                EXCEPTION ReservedExcA_handler,10
                EXCEPTION SVCall_handler,11
                EXCEPTION DebugMonitor_handler,12
                EXCEPTION ReservedExcD_handler,13
                EXCEPTION PendSV_handler,14

                .thumb_func
                .type   SysTick_handler,%function
                .global SysTick_handler
SysTick_handler:
                push    {lr}
                .extern systick_process
                bl      systick_process
                pop     {lr}
                bx      lr


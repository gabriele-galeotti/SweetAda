
//
// llkernel.S - Low-level kernel routines and exception handling.
//
// Copyright (C) 2020-2025 Gabriele Galeotti
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

Interrupt0:     .long   0                       //  16 Event selected in the ICU.IELSR0 register
Interrupt1:     .long   0                       //  17 Event selected in the ICU.IELSR1 register
Interrupt2:     .long   0                       //  18 Event selected in the ICU.IELSR2 register
Interrupt3:     .long   0                       //  19 Event selected in the ICU.IELSR3 register
Interrupt4:     .long   0                       //  20 Event selected in the ICU.IELSR4 register
Interrupt5:     .long   0                       //  21 Event selected in the ICU.IELSR5 register
Interrupt6:     .long   0                       //  22 Event selected in the ICU.IELSR6 register
Interrupt7:     .long   0                       //  23 Event selected in the ICU.IELSR7 register
Interrupt8:     .long   0                       //  24 Event selected in the ICU.IELSR8 register
Interrupt9:     .long   0                       //  25 Event selected in the ICU.IELSR9 register
Interrupt10:    .long   0                       //  26 Event selected in the ICU.IELSR10 register
Interrupt11:    .long   0                       //  27 Event selected in the ICU.IELSR11 register
Interrupt12:    .long   0                       //  28 Event selected in the ICU.IELSR12 register
Interrupt13:    .long   0                       //  29 Event selected in the ICU.IELSR13 register
Interrupt14:    .long   0                       //  30 Event selected in the ICU.IELSR14 register
Interrupt15:    .long   0                       //  31 Event selected in the ICU.IELSR15 register
Interrupt16:    .long   0                       //  32 Event selected in the ICU.IELSR16 register
Interrupt17:    .long   0                       //  33 Event selected in the ICU.IELSR17 register
Interrupt18:    .long   0                       //  34 Event selected in the ICU.IELSR18 register
Interrupt19:    .long   0                       //  35 Event selected in the ICU.IELSR19 register
Interrupt20:    .long   0                       //  36 Event selected in the ICU.IELSR20 register
Interrupt21:    .long   0                       //  37 Event selected in the ICU.IELSR21 register
Interrupt22:    .long   0                       //  38 Event selected in the ICU.IELSR22 register
Interrupt23:    .long   0                       //  39 Event selected in the ICU.IELSR23 register
Interrupt24:    .long   0                       //  40 Event selected in the ICU.IELSR24 register
Interrupt25:    .long   0                       //  41 Event selected in the ICU.IELSR25 register
Interrupt26:    .long   0                       //  42 Event selected in the ICU.IELSR26 register
Interrupt27:    .long   0                       //  43 Event selected in the ICU.IELSR27 register
Interrupt28:    .long   0                       //  44 Event selected in the ICU.IELSR28 register
Interrupt29:    .long   0                       //  45 Event selected in the ICU.IELSR29 register
Interrupt30:    .long   0                       //  46 Event selected in the ICU.IELSR30 register
Interrupt31:    .long   0                       //  47 Event selected in the ICU.IELSR31 register
Interrupt32:    .long   0                       //  48 Event selected in the ICU.IELSR32 register
Interrupt33:    .long   0                       //  49 Event selected in the ICU.IELSR33 register
Interrupt34:    .long   0                       //  50 Event selected in the ICU.IELSR34 register
Interrupt35:    .long   0                       //  51 Event selected in the ICU.IELSR35 register
Interrupt36:    .long   0                       //  52 Event selected in the ICU.IELSR36 register
Interrupt37:    .long   0                       //  53 Event selected in the ICU.IELSR37 register
Interrupt38:    .long   0                       //  54 Event selected in the ICU.IELSR38 register
Interrupt39:    .long   0                       //  55 Event selected in the ICU.IELSR39 register
Interrupt40:    .long   0                       //  56 Event selected in the ICU.IELSR40 register
Interrupt41:    .long   0                       //  57 Event selected in the ICU.IELSR41 register
Interrupt42:    .long   0                       //  58 Event selected in the ICU.IELSR42 register
Interrupt43:    .long   0                       //  59 Event selected in the ICU.IELSR43 register
Interrupt44:    .long   0                       //  60 Event selected in the ICU.IELSR44 register
Interrupt45:    .long   0                       //  61 Event selected in the ICU.IELSR45 register
Interrupt46:    .long   0                       //  62 Event selected in the ICU.IELSR46 register
Interrupt47:    .long   0                       //  63 Event selected in the ICU.IELSR47 register
Interrupt48:    .long   0                       //  64 Event selected in the ICU.IELSR48 register
Interrupt49:    .long   0                       //  65 Event selected in the ICU.IELSR49 register
Interrupt50:    .long   0                       //  66 Event selected in the ICU.IELSR50 register
Interrupt51:    .long   0                       //  67 Event selected in the ICU.IELSR51 register
Interrupt52:    .long   0                       //  68 Event selected in the ICU.IELSR52 register
Interrupt53:    .long   0                       //  69 Event selected in the ICU.IELSR53 register
Interrupt54:    .long   0                       //  70 Event selected in the ICU.IELSR54 register
Interrupt55:    .long   0                       //  71 Event selected in the ICU.IELSR55 register
Interrupt56:    .long   0                       //  72 Event selected in the ICU.IELSR56 register
Interrupt57:    .long   0                       //  73 Event selected in the ICU.IELSR57 register
Interrupt58:    .long   0                       //  74 Event selected in the ICU.IELSR58 register
Interrupt59:    .long   0                       //  75 Event selected in the ICU.IELSR59 register
Interrupt60:    .long   0                       //  76 Event selected in the ICU.IELSR60 register
Interrupt61:    .long   0                       //  77 Event selected in the ICU.IELSR61 register
Interrupt62:    .long   0                       //  78 Event selected in the ICU.IELSR62 register
Interrupt63:    .long   0                       //  79 Event selected in the ICU.IELSR63 register
Interrupt64:    .long   0                       //  80 Event selected in the ICU.IELSR64 register
Interrupt65:    .long   0                       //  81 Event selected in the ICU.IELSR65 register
Interrupt66:    .long   0                       //  82 Event selected in the ICU.IELSR66 register
Interrupt67:    .long   0                       //  83 Event selected in the ICU.IELSR67 register
Interrupt68:    .long   0                       //  84 Event selected in the ICU.IELSR68 register
Interrupt69:    .long   0                       //  85 Event selected in the ICU.IELSR69 register
Interrupt70:    .long   0                       //  86 Event selected in the ICU.IELSR70 register
Interrupt71:    .long   0                       //  87 Event selected in the ICU.IELSR71 register
Interrupt72:    .long   0                       //  88 Event selected in the ICU.IELSR72 register
Interrupt73:    .long   0                       //  89 Event selected in the ICU.IELSR73 register
Interrupt74:    .long   0                       //  90 Event selected in the ICU.IELSR74 register
Interrupt75:    .long   0                       //  91 Event selected in the ICU.IELSR75 register
Interrupt76:    .long   0                       //  92 Event selected in the ICU.IELSR76 register
Interrupt77:    .long   0                       //  93 Event selected in the ICU.IELSR77 register
Interrupt78:    .long   0                       //  94 Event selected in the ICU.IELSR78 register
Interrupt79:    .long   0                       //  95 Event selected in the ICU.IELSR79 register
Interrupt80:    .long   0                       //  96 Event selected in the ICU.IELSR80 register
Interrupt81:    .long   0                       //  97 Event selected in the ICU.IELSR81 register
Interrupt82:    .long   0                       //  98 Event selected in the ICU.IELSR82 register
Interrupt83:    .long   0                       //  99 Event selected in the ICU.IELSR83 register
Interrupt84:    .long   0                       // 100 Event selected in the ICU.IELSR84 register
Interrupt85:    .long   0                       // 101 Event selected in the ICU.IELSR85 register
Interrupt86:    .long   0                       // 102 Event selected in the ICU.IELSR86 register
Interrupt87:    .long   0                       // 103 Event selected in the ICU.IELSR87 register
Interrupt88:    .long   0                       // 104 Event selected in the ICU.IELSR88 register
Interrupt89:    .long   0                       // 105 Event selected in the ICU.IELSR89 register
Interrupt90:    .long   0                       // 106 Event selected in the ICU.IELSR90 register
Interrupt91:    .long   0                       // 107 Event selected in the ICU.IELSR91 register
Interrupt92:    .long   0                       // 108 Event selected in the ICU.IELSR92 register
Interrupt93:    .long   0                       // 109 Event selected in the ICU.IELSR93 register
Interrupt94:    .long   0                       // 110 Event selected in the ICU.IELSR94 register
Interrupt95:    .long   0                       // 111 Event selected in the ICU.IELSR95 register

// unused interrupts

Interrupt96:    .long   0
Interrupt97:    .long   0
Interrupt98:    .long   0
Interrupt99:    .long   0
Interrupt100:   .long   0
Interrupt101:   .long   0
Interrupt102:   .long   0
Interrupt103:   .long   0
Interrupt104:   .long   0
Interrupt105:   .long   0
Interrupt106:   .long   0
Interrupt107:   .long   0
Interrupt108:   .long   0
Interrupt109:   .long   0
Interrupt110:   .long   0
Interrupt111:   .long   0
Interrupt112:   .long   0
Interrupt113:   .long   0
Interrupt114:   .long   0
Interrupt115:   .long   0
Interrupt116:   .long   0
Interrupt117:   .long   0
Interrupt118:   .long   0
Interrupt119:   .long   0
Interrupt120:   .long   0
Interrupt121:   .long   0
Interrupt122:   .long   0
Interrupt123:   .long   0
Interrupt124:   .long   0
Interrupt125:   .long   0
Interrupt126:   .long   0
Interrupt127:   .long   0
Interrupt128:   .long   0
Interrupt129:   .long   0
Interrupt130:   .long   0
Interrupt131:   .long   0
Interrupt132:   .long   0
Interrupt133:   .long   0
Interrupt134:   .long   0
Interrupt135:   .long   0
Interrupt136:   .long   0
Interrupt137:   .long   0
Interrupt138:   .long   0
Interrupt139:   .long   0
Interrupt140:   .long   0
Interrupt141:   .long   0
Interrupt142:   .long   0
Interrupt143:   .long   0
Interrupt144:   .long   0
Interrupt145:   .long   0
Interrupt146:   .long   0
Interrupt147:   .long   0
Interrupt148:   .long   0
Interrupt149:   .long   0
Interrupt150:   .long   0
Interrupt151:   .long   0
Interrupt152:   .long   0
Interrupt153:   .long   0
Interrupt154:   .long   0
Interrupt155:   .long   0
Interrupt156:   .long   0
Interrupt157:   .long   0
Interrupt158:   .long   0
Interrupt159:   .long   0
Interrupt160:   .long   0
Interrupt161:   .long   0
Interrupt162:   .long   0
Interrupt163:   .long   0
Interrupt164:   .long   0
Interrupt165:   .long   0
Interrupt166:   .long   0
Interrupt167:   .long   0
Interrupt168:   .long   0
Interrupt169:   .long   0
Interrupt170:   .long   0
Interrupt171:   .long   0
Interrupt172:   .long   0
Interrupt173:   .long   0
Interrupt174:   .long   0
Interrupt175:   .long   0
Interrupt176:   .long   0
Interrupt177:   .long   0
Interrupt178:   .long   0
Interrupt179:   .long   0
Interrupt180:   .long   0
Interrupt181:   .long   0
Interrupt182:   .long   0
Interrupt183:   .long   0
Interrupt184:   .long   0
Interrupt185:   .long   0
Interrupt186:   .long   0
Interrupt187:   .long   0
Interrupt188:   .long   0
Interrupt189:   .long   0
Interrupt190:   .long   0
Interrupt191:   .long   0
Interrupt192:   .long   0
Interrupt193:   .long   0
Interrupt194:   .long   0
Interrupt195:   .long   0
Interrupt196:   .long   0
Interrupt197:   .long   0
Interrupt198:   .long   0
Interrupt199:   .long   0
Interrupt200:   .long   0
Interrupt201:   .long   0
Interrupt202:   .long   0
Interrupt203:   .long   0
Interrupt204:   .long   0
Interrupt205:   .long   0
Interrupt206:   .long   0
Interrupt207:   .long   0
Interrupt208:   .long   0
Interrupt209:   .long   0
Interrupt210:   .long   0
Interrupt211:   .long   0
Interrupt212:   .long   0
Interrupt213:   .long   0
Interrupt214:   .long   0
Interrupt215:   .long   0
Interrupt216:   .long   0
Interrupt217:   .long   0
Interrupt218:   .long   0
Interrupt219:   .long   0
Interrupt220:   .long   0
Interrupt221:   .long   0
Interrupt222:   .long   0
Interrupt223:   .long   0
Interrupt224:   .long   0
Interrupt225:   .long   0
Interrupt226:   .long   0
Interrupt227:   .long   0
Interrupt228:   .long   0
Interrupt229:   .long   0
Interrupt230:   .long   0
Interrupt231:   .long   0
Interrupt232:   .long   0
Interrupt233:   .long   0
Interrupt234:   .long   0
Interrupt235:   .long   0
Interrupt236:   .long   0
Interrupt237:   .long   0
Interrupt238:   .long   0
Interrupt239:   .long   0

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


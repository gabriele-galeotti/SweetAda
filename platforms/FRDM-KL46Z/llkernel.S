
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
\handler:
                push    {lr}
                movs    r0,#\number
                mov     r1,lr
                bl      exception_process
                pop     {pc}
                .endm

////////////////////////////////////////////////////////////////////////////////

                .sect   .vectors,"ax"

                .p2align 8

                .global vectors
vectors:

SP_Main:        .long   0
                .extern _start
Reset:          .long   _start                  //  1
NMI:            .long   NMI_handler             //  2
HardFault:      .long   HardFault_handler       //  3
ReservedExc4:   .long   ReservedExc4_handler    //  4
ReservedExc5:   .long   ReservedExc5_handler    //  5
ReservedExc6:   .long   ReservedExc6_handler    //  6
ReservedExc7:   .long   ReservedExc7_handler    //  7
ReservedExc8:   .long   ReservedExc8_handler    //  8
ReservedExc9:   .long   ReservedExc9_handler    //  9
ReservedExcA:   .long   ReservedExcA_handler    // 10
SVCall:         .long   SVCall_handler          // 11
ReservedExcC:   .long   ReservedExcC_handler    // 12
ReservedExcD:   .long   ReservedExcD_handler    // 13
PendSV:         .long   PendSV_handler          // 14
SysTick:        .long   SysTick_handler         // 15

// Non-Core vectors

Interrupt0:     .long   0                       // 16 DMA DMA channel 0 transfer complete and error
Interrupt1:     .long   0                       // 17 DMA DMA channel 1 transfer complete and error
Interrupt2:     .long   0                       // 18 DMA DMA channel 2 transfer complete and error
Interrupt3:     .long   0                       // 19 DMA DMA channel 3 transfer complete and error
Interrupt4:     .long   0                       // 20 -
Interrupt5:     .long   0                       // 21 FTFA Command complete and read collision
Interrupt6:     .long   0                       // 22 PMC Low-voltage detect, low-voltage warning
Interrupt7:     .long   0                       // 23 LLWU Low Leakage Wakeup
Interrupt8:     .long   0                       // 24 I2C0
Interrupt9:     .long   0                       // 25 I2C1
Interrupt10:    .long   0                       // 26 SPI0 Single interrupt vector for all sources
Interrupt11:    .long   0                       // 27 SPI1 Single interrupt vector for all sources
Interrupt12:    .long   0                       // 28 UART0 Status and error
Interrupt13:    .long   0                       // 29 UART1 Status and error
Interrupt14:    .long   0                       // 30 UART2 Status and error
Interrupt15:    .long   0                       // 31 ADC0
Interrupt16:    .long   0                       // 32 CMP0
Interrupt17:    .long   0                       // 33 TPM0
Interrupt18:    .long   0                       // 34 TPM1
Interrupt19:    .long   0                       // 35 TPM2
Interrupt20:    .long   0                       // 36 RTC Alarm interrupt
Interrupt21:    .long   0                       // 37 RTC Seconds interrupt
Interrupt22:    .long   0                       // 38 PIT Single interrupt vector for all channels
Interrupt23:    .long   0                       // 39 I2S0 Single interrupt vector for all sources
Interrupt24:    .long   0                       // 40 USB OTG
Interrupt25:    .long   0                       // 41 DAC0
Interrupt26:    .long   0                       // 42 TSI0
Interrupt27:    .long   0                       // 43 MCG
Interrupt28:    .long   0                       // 44 LPTMR0
Interrupt29:    .long   0                       // 45 SLCD
Interrupt30:    .long   0                       // 46 Port control module Pin detect (Port A)
Interrupt31:    .long   0                       // 47 Port control module Pin detect (Single interrupt vector for Port C and Port D)

                .sect   .text,"ax"

                .extern exception_process
                .extern systick_process
                .extern irq_process

                EXCEPTION NMI_handler,2
                EXCEPTION HardFault_handler,3
                EXCEPTION ReservedExc4_handler,4
                EXCEPTION ReservedExc5_handler,5
                EXCEPTION ReservedExc6_handler,6
                EXCEPTION ReservedExc7_handler,7
                EXCEPTION ReservedExc8_handler,8
                EXCEPTION ReservedExc9_handler,9
                EXCEPTION ReservedExcA_handler,10
                EXCEPTION SVCall_handler,11
                EXCEPTION ReservedExcC_handler,12
                EXCEPTION ReservedExcD_handler,13
                EXCEPTION PendSV_handler,14

                .thumb_func
                .type   SysTick_handler,%function
                .global SysTick_handler
SysTick_handler:
                push    {lr}
                bl      systick_process
                pop     {pc}


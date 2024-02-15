
//
// llkernel.S - Low-level kernel routines and exception handling.
//
// Copyright (C) 2020-2024 Gabriele Galeotti
//
// This work is licensed under the terms of the MIT License.
// Please consult the LICENSE.txt file located in the top-level directory.
//

#define __ASSEMBLER__ 1

////////////////////////////////////////////////////////////////////////////////

                .syntax unified

                .sect   .vectors,"ax"

                .p2align 8

                .global vectors
vectors:

SP_Main:        .long   0
                .extern _start
Reset:          .long   _start                  //  1
NMI:            .long   0                       //  2
HardFault:      .long   0                       //  3
ReservedExc4:   .long   0                       //  4
ReservedExc5:   .long   0                       //  5
ReservedExc6:   .long   0                       //  6
ReservedExc7:   .long   0                       //  7
ReservedExc8:   .long   0                       //  8
ReservedExc9:   .long   0                       //  9
ReservedExcA:   .long   0                       // 10
SVCall:         .long   0                       // 11
ReservedExcC:   .long   0                       // 12
ReservedExcD:   .long   0                       // 13
PendSV:         .long   0                       // 14
SysTick:        .long   systick_handler         // 15

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

                .thumb_func
                .type   systick_handler,%function
                .global systick_handler
systick_handler:
                push    {lr}
                .extern irq_process
                bl      irq_process
                pop     {pc}


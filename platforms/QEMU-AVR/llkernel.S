
//
// llkernel.S - Low-level kernel routines and exception handling.
//
// Copyright (C) 2020-2023 Gabriele Galeotti
//
// This work is licensed under the terms of the MIT License.
// Please consult the LICENSE.txt file located in the top-level directory.
//

#define __ASSEMBLER__ 1

#include <avr.h>

////////////////////////////////////////////////////////////////////////////////

                .sect   .vectors,"ax"

                .global vectors
vectors:

                // vector #1 @0x0000 is RESET
RESET:
                .extern _start
                jmp     _start

// 02   EXT_INT0        External Interrupt Request 0
V_EXT_INT0:     rjmp    ISR_EXT_INT0
                nop

// 03   EXT_INT1        External Interrupt Request 1
V_EXT_INT1:     rjmp    ISR_EXT_INT1
                nop

// 04   PCINT0          Pin Change Interrupt Request 0
V_PCINT0:       rjmp    ISR_PCINT0
                nop

// 05   PCINT1          Pin Change Interrupt Request 1
V_PCINT1:       rjmp    ISR_PCINT1
                nop

// 06   PCINT2          Pin Change Interrupt Request 2
V_PCINT2:       rjmp    ISR_PCINT2
                nop

// 07   WDT             Watchdog Time-out Interrupt
V_WDT:          rjmp    ISR_WDT
                nop

// 08   TIM2_COMPA      Timer/Counter2 Compare Match A
V_TIM2_COMPA:   rjmp    ISR_TIM2_COMPA
                nop

// 09   TIM2_COMPB      Timer/Counter2 Compare Match B
V_TIM2_COMPB:   rjmp    ISR_TIM2_COMPB
                nop

// 10   TIM2_OVF        Timer/Counter2 Overflow
V_TIM2_OVF:     rjmp    ISR_TIM2_OVF
                nop

// 11   TIM1_CAPT       Timer/Counter1 Capture Event
V_TIM1_CAPT:    rjmp    ISR_TIM1_CAPT
                nop

// 12   TIM1_COMPA      Timer/Counter1 Compare Match A
V_TIM1_COMPA:   rjmp    ISR_TIM1_COMPA
                nop

// 13   TIM1_COMPB      Timer/Counter1 Compare Match B
V_TIM1_COMPB:   rjmp    ISR_TIM1_COMPB
                nop

// 14   TIM1_OVF        Timer/Counter1 Overflow
V_TIM1_OVF:     rjmp    ISR_TIM1_OVF
                nop

// 15   TIM0_COMPA      Timer/Counter0 Compare Match A
V_TIM0_COMPA:   rjmp    ISR_TIM0_COMPA
                nop

// 16   TIM0_COMPB      Timer/Counter0 Compare Match B
V_TIM0_COMPB:   rjmp    ISR_TIM0_COMPB
                nop

// 17   TIM0_OVF        Timer/Counter0 Overflow
V_TIM0_OVF:     rjmp    ISR_TIM0_OVF

// 18   SPI_STC         SPI Serial Transfer Complete
V_SPI_STC:      rjmp    ISR_SPI_STC
                nop

// 19   USART_RXC       USART Rx Complete
V_USART_RXC:    rjmp    ISR_USART_RXC
                nop

// 20   USART_UDRE      USART, Data Register Empty
V_USART_UDRE:   rjmp    ISR_USART_UDRE
                nop

// 21   USART_TXC       USART, Tx Complete
V_USART_TXC:    rjmp    ISR_USART_TXC
                nop

// 22   ADC             ADC Conversion Complete
V_ADC:          rjmp    ISR_ADC
                nop

// 23   EE_RDY          EEPROM Ready
V_EE_RDY:       rjmp    ISR_EE_RDY
                nop

// 24   ANA_COMP        Analog Comparator
V_ANA_COMP:     rjmp    ISR_ANA_COMP
                nop

// 25   TWI             2-wire Serial Interface
V_TWI:          rjmp    ISR_TWI
                nop

// 26   SPM_RDY         Store Program Memory Ready
V_SPM_RDY:      rjmp    ISR_SPM_RDY
                nop

ISR_EXT_INT0:
                reti
ISR_EXT_INT1:
                reti
ISR_PCINT0:
                reti
ISR_PCINT1:
                reti
ISR_PCINT2:
                reti
ISR_WDT:
                reti
ISR_TIM2_COMPA:
                reti
ISR_TIM2_COMPB:
                reti
ISR_TIM2_OVF:
                reti
ISR_TIM1_CAPT:
                reti
ISR_TIM1_COMPA:
                reti
ISR_TIM1_COMPB:
                reti
ISR_TIM1_OVF:
                reti
ISR_TIM0_COMPA:
                reti
ISR_TIM0_COMPB:
                reti
ISR_TIM0_OVF:
                reti
ISR_SPI_STC:
                reti
ISR_USART_RXC:
                reti
ISR_USART_UDRE:
                reti
ISR_USART_TXC:
                reti
ISR_ADC:
                reti
ISR_EE_RDY:
                reti
ISR_ANA_COMP:
                reti
ISR_TWI:
                reti
ISR_SPM_RDY:
                reti


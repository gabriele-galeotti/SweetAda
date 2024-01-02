
//
// llkernel.S - Low-level kernel routines and exception handling.
//
// Copyright (C) 2020-2024 Gabriele Galeotti
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

/////////////////////////////////////////////////////////////////////////////////////////////////////////////
// #    SOURCE          INTERRUPT DEFINITION                            ARDUINO/C++ ISR()       ASSEMBLY NAME
/////////////////////////////////////////////////////////////////////////////////////////////////////////////

// 02   EXT_INT0        External Interrupt Request 0 (pin D2)           (INT0_vect)             INT0addr
V_EXT_INT0:     rjmp    ISR_EXT_INT0
                nop

// 03   EXT_INT1        External Interrupt Request 1 (pin D3)           (INT1_vect)             INT1addr
V_EXT_INT1:     rjmp    ISR_EXT_INT1
                nop

// 04   PCINT0          Pin Change Interrupt Request 0 (pins D8 to D13) (PCINT0_vect)           PCI0addr
V_PCINT0:       rjmp    ISR_PCINT0
                nop

// 05   PCINT1          Pin Change Interrupt Request 1 (pins A0 to A5)  (PCINT1_vect)           PCI1addr
V_PCINT1:       rjmp    ISR_PCINT1
                nop

// 06   PCINT2          Pin Change Interrupt Request 2 (pins D0 to D7)  (PCINT2_vect)           PCI2addr
V_PCINT2:       rjmp    ISR_PCINT2
                nop

// 07   WDT             Watchdog Time-out Interrupt                     (WDT_vect)              WDTaddr
V_WDT:          rjmp    ISR_WDT
                nop

// 08   TIM2_COMPA      Timer/Counter2 Compare Match A                  (TIMER2_COMPA_vect)     OC2Aaddr
V_TIM2_COMPA:   rjmp    ISR_TIM2_COMPA
                nop

// 09   TIM2_COMPB      Timer/Counter2 Compare Match B                  (TIMER2_COMPB_vect)     OC2Baddr
V_TIM2_COMPB:   rjmp    ISR_TIM2_COMPB
                nop

// 10   TIM2_OVF        Timer/Counter2 Overflow                         (TIMER2_OVF_vect)       OVF2addr
V_TIM2_OVF:     rjmp    ISR_TIM2_OVF
                nop

// 11   TIM1_CAPT       Timer/Counter1 Capture Event                    (TIMER1_CAPT_vect)      ICP1addr
V_TIM1_CAPT:    rjmp    ISR_TIM1_CAPT
                nop

// 12   TIM1_COMPA      Timer/Counter1 Compare Match A                  (TIMER1_COMPA_vect)     OC1Aaddr
V_TIM1_COMPA:   rjmp    ISR_TIM1_COMPA
                nop

// 13   TIM1_COMPB      Timer/Counter1 Compare Match B                  (TIMER1_COMPB_vect)     OC1Baddr
V_TIM1_COMPB:   rjmp    ISR_TIM1_COMPB
                nop

// 14   TIM1_OVF        Timer/Counter1 Overflow                         (TIMER1_OVF_vect)       OVF1addr
V_TIM1_OVF:     rjmp    ISR_TIM1_OVF
                nop

// 15   TIM0_COMPA      Timer/Counter0 Compare Match A                  (TIMER0_COMPA_vect)     OC0Aaddr
V_TIM0_COMPA:   rjmp    ISR_TIM0_COMPA
                nop

// 16   TIM0_COMPB      Timer/Counter0 Compare Match B                  (TIMER0_COMPB_vect)     OC0Baddr
V_TIM0_COMPB:   rjmp    ISR_TIM0_COMPB
                nop

// 17   TIM0_OVF        Timer/Counter0 Overflow                         (TIMER0_OVF_vect)       OVF0addr
V_TIM0_OVF:     rjmp    ISR_TIM0_OVF

// 18   SPI_STC         SPI Serial Transfer Complete                    (SPI_STC_vect)          SPIaddr
V_SPI_STC:      rjmp    ISR_SPI_STC
                nop

// 19   USART_RXC       USART Rx Complete                               (USART_RX_vect)         URXCaddr
V_USART_RXC:    rjmp    ISR_USART_RXC
                nop

// 20   USART_UDRE      USART, Data Register Empty                      (USART_UDRE_vect)       UDREaddr
V_USART_UDRE:   rjmp    ISR_USART_UDRE
                nop

// 21   USART_TXC       USART, Tx Complete                              (USART_TX_vect)         UTXCaddr
V_USART_TXC:    rjmp    ISR_USART_TXC
                nop

// 22   ADC             ADC Conversion Complete                         (ADC_vect)              ADCCaddr
V_ADC:          rjmp    ISR_ADC
                nop

// 23   EE_RDY          EEPROM Ready                                    (EE_READY_vect)         ERDYaddr
V_EE_RDY:       rjmp    ISR_EE_RDY
                nop

// 24   ANA_COMP        Analog Comparator                               (ANALOG_COMP_vect)      ACIaddr
V_ANA_COMP:     rjmp    ISR_ANA_COMP
                nop

// 25   TWI             2-wire Serial Interface                         (I2C) (TWI_vect)        TWIaddr
V_TWI:          rjmp    ISR_TWI
                nop

// 26   SPM_RDY         Store Program Memory Ready                      (SPM_READY_vect)        SPMRaddr
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


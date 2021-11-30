
//
// llkernel.S - Low-level kernel routines and exception handling.
//
// Copyright (C) 2020, 2021 Gabriele Galeotti
//
// This work is licensed under the terms of the MIT License.
// Please consult the LICENSE.txt file located in the top-level directory.
//

#define __ASSEMBLER__ 1

////////////////////////////////////////////////////////////////////////////////

#define SREG 0x3F

                .sect   .vectors,"ax"

                // vector #1 is RESET @ 0x0000
reset:          rjmp    _start

/////////////////////////////////////////////////////////////////////////////////////////////////////////////
// #    SOURCE          INTERRUPT DEFINITION                            ARDUINO/C++ ISR()       ASSEMBLY NAME
/////////////////////////////////////////////////////////////////////////////////////////////////////////////

// 02   INT0            External Interrupt Request 0 (pin D2)           (INT0_vect)             INT0addr
V0x0002:        jmp     ISR_INT0

// 03   INT1            External Interrupt Request 1 (pin D3)           (INT1_vect)             INT1addr
V0x0004:        jmp     ISR_INT1

// 04   PCINT0          Pin Change Interrupt Request 0 (pins D8 to D13) (PCINT0_vect)           PCI0addr
V0x0006:        jmp     ISR_PCINT0

// 05   PCINT1          Pin Change Interrupt Request 1 (pins A0 to A5)  (PCINT1_vect)           PCI1addr
V0x0008:        jmp     ISR_PCINT1

// 06   PCINT2          Pin Change Interrupt Request 2 (pins D0 to D7)  (PCINT2_vect)           PCI2addr
V0x000A:        jmp     ISR_PCINT2

// 07   WDT             Watchdog Time-out Interrupt                     (WDT_vect)              WDTaddr
V0x000C:        jmp     ISR_WDT

// 08   TIMER2 COMPA    Timer/Counter2 Compare Match A                  (TIMER2_COMPA_vect)     OC2Aaddr
V0x000E:        jmp     ISR_TIMER2_COMPA

// 09   TIMER2 COMPB    Timer/Counter2 Compare Match B                  (TIMER2_COMPB_vect)     OC2Baddr
V0x0010:        jmp     ISR_TIMER2_COMPB

// 10   TIMER2 OVF      Timer/Counter2 Overflow                         (TIMER2_OVF_vect)       OVF2addr
V0x0012:        jmp     ISR_TIMER2_OVF

// 11   TIMER1 CAPT     Timer/Counter1 Capture Event                    (TIMER1_CAPT_vect)      ICP1addr
V0x0014:        jmp     ISR_TIMER1_CAPT

// 12   TIMER1 COMPA    Timer/Counter1 Compare Match A                  (TIMER1_COMPA_vect)     OC1Aaddr
V0x0016:        jmp     ISR_TIMER1_COMPA

// 13   TIMER1 COMPB    Timer/Counter1 Compare Match B                  (TIMER1_COMPB_vect)     OC1Baddr
V0x0018:        jmp     ISR_TIMER1_COMPB

// 14   TIMER1 OVF      Timer/Counter1 Overflow                         (TIMER1_OVF_vect)       OVF1addr
V0x001A:        jmp     ISR_TIMER1_OVF

// 15   TIMER0 COMPA    Timer/Counter0 Compare Match A                  (TIMER0_COMPA_vect)     OC0Aaddr
V0x001C:        jmp     ISR_TIMER0_COMPA

// 16   TIMER0 COMPB    Timer/Counter0 Compare Match B                  (TIMER0_COMPB_vect)     OC0Baddr
V0x001E:        jmp     ISR_TIMER0_COMPB

// 17   TIMER0 OVF      Timer/Counter0 Overflow                         (TIMER0_OVF_vect)       OVF0addr
V0x0020:        jmp     ISR_TIMER0_OVF

// 18   SPI, STC        SPI Serial Transfer Complete                    (SPI_STC_vect)  SPIaddr
V0x0022:        jmp     ISR_SPI_STC

// 19   USART, RX       USART, Rx Complete                              (USART_RX_vect) URXCaddr
V0x0024:        jmp     ISR_USART_RX

// 20   USART, UDRE     USART, Data Register Empty                      (USART_UDRE_vect)       UDREaddr
V0x0026:        jmp     ISR_USART_UDRE

// 21   USART, TX       USART, Tx Complete                              (USART_TX_vect) UTXCaddr
V0x0028:        jmp     ISR_USART_TX

// 22   ADC             ADC Conversion Complete                         (ADC_vect)      ADCCaddr
V0x002A:        jmp     ISR_ADC

// 23   EE READY        EEPROM Ready                                    (EE_READY_vect) ERDYaddr
V0x002C:        jmp     ISR_EE_READY

// 24   ANALOG COMP     Analog Comparator                               (ANALOG_COMP_vect)      ACIaddr
V0x002E:        jmp     ISR_ANALOG_COMP

// 25   TWI             2-wire Serial Interface                         (I2C) (TWI_vect)        TWIaddr
V0x0030:        jmp     ISR_TWI

// 26   SPM READY       Store Program Memory Ready                      (SPM_READY_vect)        SPMRaddr
V0x0032:        jmp     ISR_SPM_READY

ISR_INT0:
                reti
ISR_INT1:
                reti
ISR_PCINT0:
                reti
ISR_PCINT1:
                reti
ISR_PCINT2:
                reti
ISR_WDT:
                reti
ISR_TIMER2_COMPA:
                reti
ISR_TIMER2_COMPB:
                reti
ISR_TIMER2_OVF:
                reti
ISR_TIMER1_CAPT:
                reti
ISR_TIMER1_COMPA:
                reti
ISR_TIMER1_COMPB:
                reti
ISR_TIMER1_OVF:
                reti
ISR_TIMER0_COMPA:
                reti
ISR_TIMER0_COMPB:
                reti
ISR_TIMER0_OVF:
                reti
ISR_SPI_STC:
                reti
ISR_USART_RX:
                reti
ISR_USART_UDRE:
                reti
ISR_USART_TX:
                reti
ISR_ADC:
                reti
ISR_EE_READY:
                reti
ISR_ANALOG_COMP:
                reti
ISR_TWI:
                reti
ISR_SPM_READY:
                reti


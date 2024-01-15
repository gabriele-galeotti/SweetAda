
#include <simavr/avr/avr_mcu_section.h>

#define PORTB 0x25

AVR_MCU(16000000, "atmega328p");
AVR_MCU_VCD_FILE("simavr.vcd", 1000);

const struct avr_mmcu_vcd_trace_t _vcdtrace[] _MMCU_ = {
        {
                AVR_MCU_VCD_SYMBOL("PORTB5"),
                .mask = (1 << 5),
                .what = (void *)PORTB
        }
        };


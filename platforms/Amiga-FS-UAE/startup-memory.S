
#define CIAA_PRA  0x00BFE001 // Port A
#define CIAA_DDRA 0x00BFE201 // Data Direction Port A

                move.b  #0x3,CIAA_DDRA                  // CIAA: LED, OVL signals are outputs
                move.b  #0x2,CIAA_PRA                   // CIAA: PWR LED on, disable aliased ROM and make RAM appears @ 0x00000000


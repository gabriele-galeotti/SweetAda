
//
// Keep QEMU running even with no kernel loaded. It is important to set now
// bit 0 of SDRAM0_CFG, else hw/ppc/ppc4xx_devs.c:dcr_write_sdram() will set
// SDRAM_B0/1CR without enabling.
//

//
// Configure SDRAM controller.
// __REF__
// PPC405EP Embedded Processor User?s Manual
// 15.2 Accessing SDRAM Registers
// 15.3.1 Memory Controller Configuration Register (SDRAM0_CFG)
// 15.3.3 Memory Bank 0?1 Configuration (SDRAM0_B0CR?SDRAM0_B1CR)
//

#define SDRAM0_CFGADDR 0x10 // R/W Memory Controller Address Register
#define SDRAM0_CFGDATA 0x11 // R/W Memory Controller Data Register
#define SDRAM0_CFG     0x20 // R/W SDRAM Configuration
#define SDRAM0_STATUS  0x24 // R   SDRAM Controller Status
#define SDRAM0_RTR     0x30 // R/W Refresh Timer Register
#define SDRAM0_PMIT    0x34 // R/W Power Management Idle Timer
#define SDRAM0_B0CR    0x40 // R/W Memory Bank 0 Configuration Register
#define SDRAM0_B1CR    0x44 // R/W Memory Bank 1 Configuration Register
#define SDRAM0_TR      0x80 // R/W SDRAM Timing Register

                // disable SDRAM
                li      r0,SDRAM0_CFG
                mtdcr   SDRAM0_CFGADDR,r0
                li      r0,0
                mtdcr   SDRAM0_CFGDATA,r0

                // 1st SDRAM memory bank, 64 MB @ 0x00000000
                li      r0,SDRAM0_B0CR
                mtdcr   SDRAM0_CFGADDR,r0
                lis     r0,0x00080001@ha
                ori     r0,r0,0x00080001@l
                mtdcr   SDRAM0_CFGDATA,r0

                // 2nd SDRAM memory bank, 64 MB @ 0x04000000
                li      r0,SDRAM0_B1CR
                mtdcr   SDRAM0_CFGADDR,r0
                lis     r0,0x04080001@ha
                ori     r0,r0,0x04080001@l
                mtdcr   SDRAM0_CFGDATA,r0

                // enable SDRAM, DCE = 1, SRE = 1, BRPF = 16 bytes
                li      r0,SDRAM0_CFG
                mtdcr   SDRAM0_CFGADDR,r0
                lis     r0,0x80800000@ha
                ori     r0,r0,0x80800000@l
                mtdcr   SDRAM0_CFGDATA,r0


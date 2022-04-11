
#define SDRAM_ADDRESS 0x40000000
#define SDCS0_SIZE16M 0x17
#define SDCS0_SIZE32M 0x18

                //
                // SDRAM programming.
                // port size = 16
                //
                move.l  #(SDRAM_ADDRESS+SDCS0_SIZE32M),%d0
                move.l  %d0,MCF_SDRAMC_SDCS0
                move.l  #0x53722730,%d0
                move.l  %d0,MCF_SDRAMC_SDCFG1
                move.l  #0x56670000,%d0
                move.l  %d0,MCF_SDRAMC_SDCFG2
                // issue PALL command
                move.l  #0xC0090002,%d0
                move.l  %d0,MCF_SDRAMC_SDCR
                // generate an LMR command with SD_A[11:0] = 0
                move.l  #0x00010000,%d0
                move.l  %d0,MCF_SDRAMC_SDMR
                // generate an LMR command with SD_A[11:0] = 0x22
                move.l  #0x00890000,%d0
                move.l  %d0,MCF_SDRAMC_SDMR
                // issue PALL command
                move.l  #0xC0090002,%d0
                move.l  %d0,MCF_SDRAMC_SDCR
                // issue two refresh cycles
                move.l  #0xC0090004,%d0
                move.l  %d0,MCF_SDRAMC_SDCR
                move.l  #0xC0090004,%d0
                move.l  %d0,MCF_SDRAMC_SDCR
                // generate an LMR command with SD_A[11:0] = 0x22
                move.l  #0x00890000,%d0
                move.l  %d0,MCF_SDRAMC_SDMR
                move.l  #0x50090C00,%d0
                move.l  %d0,MCF_SDRAMC_SDCR


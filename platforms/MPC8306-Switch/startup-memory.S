
//
// Setup BATs.
//

// BAT0 memory block SDRAM
#define CFG_IBAT0L      (SDRAM_BASE_ADDRESS|BATL_PP_10|BATL_MEMCOHERENCE)
#define CFG_IBAT0U      (SDRAM_BASE_ADDRESS|BATU_BL_128M|BATU_VS|BATU_VP)
#define CFG_DBAT0L      (SDRAM_BASE_ADDRESS|BATL_PP_10|BATL_MEMCOHERENCE)
#define CFG_DBAT0U      (SDRAM_BASE_ADDRESS|BATU_BL_128M|BATU_VS|BATU_VP)

// BAT1 memory block NAND Flash
#define CFG_IBAT1L      (NANDF_BASE_ADDRESS|BATL_PP_10|BATL_CACHEINHIBIT|BATL_GUARDEDSTORAGE)
#define CFG_IBAT1U      (NANDF_BASE_ADDRESS|BATU_BL_256M|BATU_VS|BATU_VP)
#define CFG_DBAT1L      (NANDF_BASE_ADDRESS|BATL_PP_10|BATL_CACHEINHIBIT|BATL_GUARDEDSTORAGE)
#define CFG_DBAT1U      (NANDF_BASE_ADDRESS|BATU_BL_256M|BATU_VS|BATU_VP)

// BAT5 configuration registers
#define CFG_IBAT5L      (CFG_IMMRBAR|BATL_PP_10|BATL_CACHEINHIBIT|BATL_GUARDEDSTORAGE)
#define CFG_IBAT5U      (CFG_IMMRBAR|BATU_BL_2M|BATU_VS|BATU_VP)
#define CFG_DBAT5L      (CFG_IMMRBAR|BATL_PP_10|BATL_CACHEINHIBIT|BATL_GUARDEDSTORAGE)
#define CFG_DBAT5U      (CFG_IMMRBAR|BATU_BL_2M|BATU_VS|BATU_VP)

                // IBAT 0
                lis     r4,CFG_IBAT0L@h
                ori     r4,r4,CFG_IBAT0L@l
                lis     r3,CFG_IBAT0U@h
                ori     r3,r3,CFG_IBAT0U@l
                mtspr   IBAT0L,r4
                mtspr   IBAT0U,r3
                isync
                // DBAT 0
                lis     r4,CFG_DBAT0L@h
                ori     r4,r4,CFG_DBAT0L@l
                lis     r3,CFG_DBAT0U@h
                ori     r3,r3,CFG_DBAT0U@l
                mtspr   DBAT0L,r4
                mtspr   DBAT0U,r3
                isync
                // IBAT 1
                lis     r4,CFG_IBAT1L@h
                ori     r4,r4,CFG_IBAT1L@l
                lis     r3,CFG_IBAT1U@h
                ori     r3,r3,CFG_IBAT1U@l
                mtspr   IBAT1L,r4
                mtspr   IBAT1U,r3
                isync
                // DBAT 1
                lis     r4,CFG_DBAT1L@h
                ori     r4,r4,CFG_DBAT1L@l
                lis     r3,CFG_DBAT1U@h
                ori     r3,r3,CFG_DBAT1U@l
                mtspr   DBAT1L,r4
                mtspr   DBAT1U,r3
                isync
                // IBAT 5
                lis     r4,CFG_IBAT5L@h
                ori     r4,r4,CFG_IBAT5L@l
                lis     r3,CFG_IBAT5U@h
                ori     r3,r3,CFG_IBAT5U@l
                mtspr   IBAT5L,r4
                mtspr   IBAT5U,r3
                isync
                // DBAT 5
                lis     r4,CFG_DBAT5L@h
                ori     r4,r4,CFG_DBAT5L@l
                lis     r3,CFG_DBAT5U@h
                ori     r3,r3,CFG_DBAT5U@l
                mtspr   DBAT5L,r4
                mtspr   DBAT5U,r3
                isync
                //
                sync


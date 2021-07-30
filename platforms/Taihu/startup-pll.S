
                //
                // Configure PLL.
                //
                mfdcr   r5,CPC0_PLLMR1
                rlwinm  r4,r5,31,0x1                    // get system clock source (SSCS)
                cmpi    cr0,0,r4,0x1
                beq     pll_done                        // if SSCS =b'1' then PLL has already been set and CPU has been reset, so skip PLL code
                // write PLL configuration values; assuming a 33MHz SysClk input
                // CPU clk = 200MHz
                // PLB clk = CPU/2 = 100MHz
                // EBC clk = PLB/2 = 50MHz
                // OPB clk = PLB/2 = 50MHz
                // MAL clk = PLB/1 = 100MHz
                addis   r3,0,0x0011                     // PLL configuration values:
                ori     r3,r3,0x1002                    // 200/100/50/50 MHz
                addis   r4,0,0x80C6                     // M = 24, VCO = 800MHz
                ori     r4,r3,0x623E
                mtdcr   CPC0_PLLMR0,r3                  // set clock dividers
                mtdcr   CPC0_PLLMR1,r3                  // set PLL
                // wait minimum of 100?s for PLL to lock; at 200MHz, that means
                // waiting 20,000 instructions; see IBM ASIC SA27E databook for more info
                addi    r3,0,20000                      // 20000 = 0x4E20
                mtctr   r3
pll_wait:       bdnz    pll_wait
                // reset CPU core to guarantee external timings are OK
                // CPU core reset will not alter cpc0_pllmr values
                addis   r3,0,0x1000                     // bit28 = core reset
                mtspr   DBCR0,r3                        // this causes a CPU core reset; execution continues from the poweron vector of 0xfffffffc
pll_done:       // CPU PLL setting completed


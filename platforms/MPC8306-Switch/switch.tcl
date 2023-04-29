
#
# MPC8306 COMESA "Switch" CCS configuration.
#

################################################################################
# Generic setup                                                                #
################################################################################

# MBAR
ccs::write_reg 0 mbar 0xFF400000

# FP available
# machine check disable
# exception vectors at 0x00000000
ccs::write_reg 0 msr 0x00002000

################################################################################
# System Configuration - Local Access Windows                                  #
################################################################################

# Local Bus Local Access Windows
# WINDOW 1 - NAND Flash EPROM
ccs::write_mem 0 0xFF400020 4 0 0xC0000000 ;# LBLAWBAR1 - beginning at 0xC0000000
ccs::write_mem 0 0xFF400024 4 0 0x8000001B ;# LBLAWAR1 - enable, size = 256MB

# DDR Local Access Windows
# WINDOW 0 - 1st DDR SODIMM
ccs::write_mem 0 0xFF4000A0 4 0 0x00000000 ;# DDRLAWBAR0 - beginning at 0x00000000
ccs::write_mem 0 0xFF4000A4 4 0 0x8000001A ;# DDRLAWAR0 - enable, size = 128MB

################################################################################
# DDR2 Controller Registers                                                    #
# System Configuration - Block Base Address 0x0_0000                           #
# DDR Memory Controller - Block Base Address 0x0_2000                          #
################################################################################

# MT47H64M16 has 16384 rows (13 bits) and 8192 columns (10 bits)

# DDRCDR
# DDR driver software override enable
# DDR driver software p-impedance override = Higher Z than nominal
# DDR driver software n-impedance override = Higher Z than nominal
# Disable memory transaction reordering
ccs::write_mem 0 0xFF400128 4 0 0x73000002

# DDR_SDRAM_CLK_CNTL
# Clock is launched 1/2 applied cycle after address/command
ccs::write_mem 0 0xFF402130 4 0 0x02000000

# CS0_BNDS
# Starting address for chip select (bank) 0 = 0x00000000
# Ending address for chip select (bank) 0 = 0x07xxxxxx = 128MB size
ccs::write_mem 0 0xFF402000 4 0 0x00000007

# CS0_CONFIG
# Chip select 0 is active and assumes the state set in CSn_BNDS
# Chip select 0 always issues an auto-precharge for read and write transactions
# Never assert ODT for reads
# Assert ODT for all writes
# 2 logical bank bits
# 13 row bits
# 10 column bits
ccs::write_mem 0 0xFF402080 4 0 0x80840102

# TIMING_CONFIG_0
ccs::write_mem 0 0xFF402104 4 0 0x00220802

# TIMING_CONFIG_1
ccs::write_mem 0 0xFF402108 4 0 0x26256222

# TIMING_CONFIG_2
ccs::write_mem 0 0xFF40210C 4 0 0x0F9028C7

# TIMING_CONFIG_3
# Extended refresh recovery time (tRFC) = 0 clocks
ccs::write_mem 0 0xFF402100 4 0 0x00000000

# DDR_SDRAM_CFG
# SDRAM self refresh is enabled during sleep
# Indicates unbuffered DRAM modules
# Type of SDRAM device to be used
# 16-bit bus is used
ccs::write_mem 0 0xFF402110 4 0 0x43100000

# DDR_SDRAM_CFG_2
ccs::write_mem 0 0xFF402114 4 0 0x00401000

# DDR_SDRAM_MODE
ccs::write_mem 0 0xFF402118 4 0 0x44400232

# DDR_SDRAM_MODE_2
ccs::write_mem 0 0xFF40211C 4 0 0x8000C000

# DDR_SDRAM_INTERVAL
ccs::write_mem 0 0xFF402124 4 0 0x03200064

# DDR_SDRAM_CFG
# previous configuration + SDRAM interface logic enabled
ccs::write_mem 0 0xFF402110 4 0 0xC3100000

################################################################################
# Local Bus Interface (LBIU) Configuration                                     #
################################################################################

# CS0 - 256MB NAND Flash EPROM - Large Page
ccs::write_mem 0 0xFF405000 4 0 0xC0000C21 ;# BR0 base address at 0xC0000000, port size 8 bit, FCM, valid
ccs::write_mem 0 0xFF405004 4 0 0xFFFC0796 ;# OR0 256kB Bank size, Large page Relax Timing

# LBCR (Local Bus enable)
ccs::write_mem 0 0xFF4050D0 4 0 0x00000000

# LCRR
# bit 14 - 15 = 0b11 - EADC - 3 external address delay cycles
# bit 28 - 31 = 0b0010 - CLKDIV - system clock:memory bus clock = 2
ccs::write_mem 0 0xFF4050D4 4 0 0x00030002

################################################################################
# NAND Flash EPROM settings                                                    #
################################################################################

# FMR
ccs::write_mem 0 0xFF4050E0 4 0 0x0000E000

################################################################################
# Memory refresh                                                               #
################################################################################

# MRTPR - memory refresh timer prescaler
ccs::write_mem 0 0xFF405084 4 0 0x20000000

# delay
after 1000


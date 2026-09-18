-----------------------------------------------------------------------------------------------------------------------
--                                                     SweetAda                                                      --
-----------------------------------------------------------------------------------------------------------------------
-- __HDS__                                                                                                           --
-- __FLN__ mpc106.ads                                                                                                --
-- __DSC__                                                                                                           --
-- __HSH__ e69de29bb2d1d6434b8b29ae775ad8c2e48c5391                                                                  --
-- __HDE__                                                                                                           --
-----------------------------------------------------------------------------------------------------------------------
-- Copyright (C) 2020-2026 Gabriele Galeotti                                                                         --
--                                                                                                                   --
-- SweetAda web page: http://sweetada.org                                                                            --
-- contact address: gabriele.galeotti@sweetada.org                                                                   --
-- This work is licensed under the terms of the MIT License.                                                         --
-- Please consult the LICENSE.txt file located in the top-level directory.                                           --
-----------------------------------------------------------------------------------------------------------------------

with System;
with Bits;

package MPC106
   is

   --========================================================================--
   --                                                                        --
   --                                                                        --
   --                               Public part                              --
   --                                                                        --
   --                                                                        --
   --========================================================================--

   use System;
   use Bits;

pragma Style_Checks (Off);

   ----------------------------------------------------------------------------
   -- MPC106 PCI Bridge/Memory Controller User’s Manual
   -- MPC106UM/AD 7/2003 Rev. 2
   ----------------------------------------------------------------------------

   -- 3.1 Address Maps

   MAP_A_CONFIG_ADDR : constant := 16#8000_0CF8#;
   MAP_A_CONFIG_DATA : constant := 16#8000_0CFC#;

   MAP_B_CONFIG_ADDR : constant := 16#FEC0_0000#;
   MAP_B_CONFIG_DATA : constant := 16#FEE0_0000#;

   -- 3.2.2 Configuration Register Summary

   PICR1_Offset : constant := 16#A8#;
   PICR2_Offset : constant := 16#AC#;

   -- 3.2.3 PCI Registers
   -- 3.2.3.1 PCI Command Register
   -- 3.2.3.2 PCI Status Register
   -- 3.2.4 Performance Monitor Registers
   -- 3.2.4.1 Performance Monitor Command Register (CMDR)—0x48
   -- 3.2.4.2 Performance Monitor Mode Control Register (MMCR)—0x4C
   -- 3.2.4.3 Performance Monitor Counters (PMC0, PMC1, PMC2, PMC3)—0x50, 0x54, 0x58, 0x5C
   -- 3.2.5 Power Management Configuration Registers (PMCRs)
   -- 3.2.6 Output Driver Control Register (ODCR)—0x73
   -- 3.2.7 Error Handling Registers
   -- 3.2.7.1 ECC Single-Bit Error Registers
   -- 3.2.7.2 Error Enabling Registers
   -- 3.2.7.3 Error Detection Registers
   -- 3.2.7.4 Error Status Registers
   -- 3.2.8 Memory Interface Configuration Registers
   -- 3.2.8.1 Memory Boundary Registers
   -- 3.2.8.2 Memory Bank Enable Register
   -- 3.2.8.3 Memory Page Mode Register
   -- 3.2.8.4 Memory Control Configuration Registers

   -- 3.2.9 Processor Interface Configuration Registers

   type CF_PROCESSOR_L2_Cfg_Type is record
      CF_L2_MP       : Bits_2;
      CF_EXTERNAL_L2 : Bits_1;
   end record;

   CF_UPWOL2  : constant CF_PROCESSOR_L2_Cfg_Type := (2#00#, 0); -- Uniprocessor without L2 cache
   CF_UPWTL2  : constant CF_PROCESSOR_L2_Cfg_Type := (2#01#, 0); -- Uniprocessor with internally-controlled, write-through L2 cache
   CF_UPWBL2  : constant CF_PROCESSOR_L2_Cfg_Type := (2#10#, 0); -- Uniprocessor with internally-controlled, write-back L2 cache
   CF_MPWOL2  : constant CF_PROCESSOR_L2_Cfg_Type := (2#11#, 0); -- Multiprocessor (2–4 60x processors on the 60x bus) without L2 cache
   CF_UPEXTL2 : constant CF_PROCESSOR_L2_Cfg_Type := (2#00#, 1); -- Uniprocessor with externally-controlled L2 cache
   CF_RSVD1   : constant CF_PROCESSOR_L2_Cfg_Type := (2#01#, 1);
   CF_RSVD2   : constant CF_PROCESSOR_L2_Cfg_Type := (2#10#, 1);
   CF_MPEXTL2 : constant CF_PROCESSOR_L2_Cfg_Type := (2#11#, 1); -- Multiprocessor with externally-controlled L2 cache

   LE_MODE_BE : constant := 0; -- Big-endian mode
   LE_MODE_LE : constant := 1; -- Little-endian mode

   CF_MP_ID_PROC0 : constant := 2#00#; -- Processor 0 is reading PICR1[CF_MP_ID].
   CF_MP_ID_PROC1 : constant := 2#01#; -- Processor 1 is reading PICR1[CF_MP_ID].
   CF_MP_ID_PROC2 : constant := 2#10#; -- Processor 2 is reading PICR1[CF_MP_ID].
   CF_MP_ID_PROC3 : constant := 2#11#; -- Processor 3 is reading PICR1[CF_MP_ID].

   ADDRESS_MAP_B : constant := 0; -- The MPC106 is configured for address map B.
   ADDRESS_MAP_A : constant := 1; -- The MPC106 is configured for address map A.

   PROC_TYPE_601         : constant := 2#00#; -- 601
   PROC_TYPE_RSVD        : constant := 2#01#; -- Reserved
   PROC_TYPE_603_740_750 : constant := 2#10#; -- 603/740/750
   PROC_TYPE_604         : constant := 2#11#; -- 604

   XIO_MODE_CONTIGUOUS    : constant := 0; -- Contiguous mode
   XIO_MODE_DISCONTIGUOUS : constant := 1; -- Discontiguous mode

   RCS0_PCI    : constant := 0; -- ROM is located on PCI bus
   RCS0_MEMORY : constant := 1; -- ROM is located on 60x/memory data bus

   CF_BREAD_WS_0 : constant := 2#00#; -- 0 wait states (601, 603 with 2:1 or greater clock ratio, and 604)
   CF_BREAD_WS_1 : constant := 2#01#; -- 1 wait state (603 with 1:1 clock ratio in DRTRY mode)
   CF_BREAD_WS_2 : constant := 2#10#; -- 2 wait states (603 with 1:1 clock ratio in no-DRTRY mode)
   CF_BREAD_WS_3 : constant := 2#11#; -- 3 wait states (not recommended)

   type PICR1_Type is record
      CF_L2_MP              : Bits_2  := CF_UPWOL2.CF_L2_MP;       -- L2/multiprocessor configuration.
      Speculative_PCI_Reads : Boolean := False;                    -- This bit controls speculative PCI reads from memory.
      CF_APARK              : Boolean := False;                    -- This bit indicates whether the 60x address bus is parked.
      CF_LOOP_SNOOP         : Boolean := True;                     -- This bit causes the MPC106 to repeat a snoop operation (due to a PCI-to-memory transaction) until it is not retried (ARTRY input asserted) by the processor(s) or the L2 cache.
      LE_MODE               : Bits_1  := LE_MODE_BE;               -- This bit controls the endian mode of the MPC106.
      ST_GATH_EN            : Boolean := False;                    -- This bit enables/disables store gathering of writes from the processor to PCI memory space.
      NO_PORT_REGS          : Boolean := False;                    -- When configured for address map A, this bit indicates the presence or absence of the external configuration registers.
      CF_EXTERNAL_L2        : Bits_1  := CF_UPWOL2.CF_EXTERNAL_L2; -- External L2 cache enable.
      CF_DPARK              : Boolean := False;                    -- Data bus park.
      TEA_EN                : Boolean := False;                    -- Transfer error enable.
      MCP_EN                : Boolean := False;                    -- Machine check enable.
      FLASH_WR_EN           : Boolean := False;                    -- Flash write enable.
      CF_LBA_EN             : Boolean := False;                    -- Local bus slave access enable.
      CF_MP_ID              : Bits_2  := CF_MP_ID_PROC0;           -- Multiprocessor identifier.
      ADDRESS_MAP           : Bits_1;                              -- Address map.
      PROC_TYPE             : Bits_2  := PROC_TYPE_601;            -- Processor type.
      XIO_MODE              : Bits_1  := XIO_MODE_CONTIGUOUS;      -- Address map A contiguous/discontiguous mode.
      RCS0                  : Bits_1;                              -- ROM Location.
      CF_CACHE_1G           : Boolean := False;                    -- L2 cache 0–1 Gbyte only.
      CF_BREAD_WS           : Bits_2  := CF_BREAD_WS_0;            -- Burst read wait states.
      CF_CBA_MASK           : Bits_8  := 2#1111_1111#;             -- L2 copyback address mask.
   end record
      with Bit_Order => Low_Order_First,
           Size      => 32;
   for PICR1_Type use record
      CF_L2_MP              at 0 range  0 ..  1;
      Speculative_PCI_Reads at 0 range  2 ..  2;
      CF_APARK              at 0 range  3 ..  3;
      CF_LOOP_SNOOP         at 0 range  4 ..  4;
      LE_MODE               at 0 range  5 ..  5;
      ST_GATH_EN            at 0 range  6 ..  6;
      NO_PORT_REGS          at 0 range  7 ..  7;
      CF_EXTERNAL_L2        at 0 range  8 ..  8;
      CF_DPARK              at 0 range  9 ..  9;
      TEA_EN                at 0 range 10 .. 10;
      MCP_EN                at 0 range 11 .. 11;
      FLASH_WR_EN           at 0 range 12 .. 12;
      CF_LBA_EN             at 0 range 13 .. 13;
      CF_MP_ID              at 0 range 14 .. 15;
      ADDRESS_MAP           at 0 range 16 .. 16;
      PROC_TYPE             at 0 range 17 .. 18;
      XIO_MODE              at 0 range 19 .. 19;
      RCS0                  at 0 range 20 .. 20;
      CF_CACHE_1G           at 0 range 21 .. 21;
      CF_BREAD_WS           at 0 range 22 .. 23;
      CF_CBA_MASK           at 0 range 24 .. 31;
   end record;

   -- For pipelined burst SRAMs, this bit indicates ADSC-only or ADSP mode.
   CF_WDATA_ADSCONLY     : constant := 0; -- ADSC-only mode
   CF_WDATA_ADSP         : constant := 1; -- ADSP mode (TS is connected to ADSP on the L2 data RAM)
   -- For asynchronous SRAMs, this bit indicates the DWEn timing:
   CF_WDATA_DWEnFALLEDGE : constant := 0; -- DWEn is negated on the falling clock edge of the cycle when is asserted.
   CF_WDATA_DWEnRISEDGE  : constant := 1; -- DWEn is negated on the rising clock edge when TA is negated.

   -- For synchronous burst SRAM configurations
   CF_DOE_CLK1      : constant := 0; -- 1 clock cycle
   CF_DOE_CLK2      : constant := 1; -- 2 clock cycles
   -- For asynchronous SRAM configurations
   CF_DOE_3222_2222 : constant := 0; -- 3-2-2-2/2-2-2-2 timing (2 clocks)
   CF_DOE_3222_3222 : constant := 1; -- 3-2-2-2/3-2-2-2 timing (3 clocks)

   CF_APHASE_WS_0 : constant := 2#00#; -- 0 wait states
   CF_APHASE_WS_1 : constant := 2#01#; -- 1 wait state
   CF_APHASE_WS_2 : constant := 2#10#; -- 2 wait states
   CF_APHASE_WS_3 : constant := 2#11#; -- 3 wait states

   CF_L2_SIZE_256k : constant := 2#00#; -- 256 Kbytes
   CF_L2_SIZE_512k : constant := 2#01#; -- 512 Kbytes
   CF_L2_SIZE_1M   : constant := 2#10#; -- 1 Mbyte
   CF_L2_SIZE_RSVD : constant := 2#11#; -- Reserved

   CF_TOE_WIDTH_CLK2 : constant := 0; -- 2 clock cycles
   CF_TOE_WIDTH_CLK3 : constant := 1; -- 3 clock cycles

   CF_TWO_BANKS_BANK1 : constant := 0; -- 1 SRAM bank
   CF_TWO_BANKS_BANK2 : constant := 1; -- 2 SRAM banks

   CF_L2_HIT_DELAY_RSVD : constant := 2#00#; -- Reserved
   CF_L2_HIT_DELAY_CLK1 : constant := 2#01#; -- 1 clock cycle
   CF_L2_HIT_DELAY_CLK2 : constant := 2#10#; -- 2 clock cycles
   CF_L2_HIT_DELAY_CLK3 : constant := 2#11#; -- 3 clock cycles

   CF_RWITM_FILL_RWITM   : constant := 0; -- The internally-controlled L2 cache performs a line-fill when a RWITM miss occurs.
   CF_RWITM_FILL_NORWITM : constant := 1; -- The internally-controlled L2 cache does not perform a line-fill when a RWITM miss occurs.

   CF_HOLD_SYNCRAM  : constant := 0; -- Synchronous tag RAM configurations.
   CF_HOLD_ASYNCRAM : constant := 1; -- Asynchronous tag RAM configurations.

   CF_HIT_HIGH_LOW  : constant := 0; -- /HIT is active low.
   CF_HIT_HIGH_HIGH : constant := 1; -- HIT is active high.

   CF_MOD_HIGH_LOW  : constant := 0; -- The input signals /TV and /DIRTY_IN are active low and the output signals /TV and /DIRTY_OUT are active low.
   CF_MOD_HIGH_HIGH : constant := 1; -- The input signals TV and DIRTY_IN are active high and the output signals TV and DIRTY_OUT are active high.

   CF_SNOOP_WS_0 : constant := 2#00#; -- 0 wait states (2-clock address phase)
   CF_SNOOP_WS_1 : constant := 2#01#; -- 1 wait state (3-clock address phase)
   CF_SNOOP_WS_2 : constant := 2#10#; -- 2 wait states (4-clock address phase)
   CF_SNOOP_WS_3 : constant := 2#11#; -- 3 wait states (5-clock address phase)

   CF_WMODE_NORMWOUPD      : constant := 2#00#; -- Normal write timing without partial update.
   CF_WMODE_NORMPARTUPD    : constant := 2#01#; -- Normal write timing with partial update using external byte write decoding.
   CF_WMODE_DELAYEDPARTUPD : constant := 2#10#; -- Delayed write timing with partial update using external byte write decoding.
   CF_WMODE_EARLYPARTUPD   : constant := 2#11#; -- Early write timing with partial update using external byte write decoding.

   CF_DATA_RAM_TYPE_SYNC  : constant := 2#00#; -- Synchronous burst SRAM
   CF_DATA_RAM_TYPE_PIPE  : constant := 2#01#; -- Pipelined burst SRAM
   CF_DATA_RAM_TYPE_ASYNC : constant := 2#10#; -- Asynchronous SRAM
   CF_DATA_RAM_TYPE_RSVD  : constant := 2#11#; -- Reserved

   type PICR2_Type is record
      CF_WDATA             : Bits_1  := 0;                     -- This bit has different functions depending on the L2 data RAM configuration.
      CF_DOE               : Bits_1  := 0;                     -- L2 first data read access timing.
      CF_APHASE_WS         : Bits_2  := CF_APHASE_WS_3;        -- Address phase wait states.
      CF_L2_SIZE           : Bits_2  := CF_L2_SIZE_256k;       -- L2 cache size.
      CF_TOE_WIDTH         : Bits_1  := CF_TOE_WIDTH_CLK2;     -- /TOE active pulse width.
      CF_FAST_CASTOUT      : Boolean := False;                 -- Fast L2 castout timing
      CF_TWO_BANKS         : Bits_1  := CF_TWO_BANKS_BANK1;    -- L2 cache banks.
      CF_L2_HIT_DELAY      : Bits_2  := CF_L2_HIT_DELAY_CLK3;  -- L2 cache hit delay.
      CF_RWITM_FILL        : Bits_1  := CF_RWITM_FILL_RWITM;   -- L2 read-with-intent-to-modify line-fill disable.
      CF_INV_MODE          : Boolean := False;                 -- L2 invalidate mode enable.
      CF_HOLD              : Bits_1  := CF_HOLD_SYNCRAM;       -- L2 tag address hold.
      CF_ADDR_ONLY_DISABLE : Boolean := False;                 -- This bit specifies whether the internally-controlled L2 cache responds to address-only transactions (clean, flush, and kill).
      Reserved             : Bits_1  := 0;
      CF_HIT_HIGH          : Bits_1  := CF_HIT_HIGH_LOW;       -- L2 cache /HIT signal polarity.
      CF_MOD_HIGH          : Bits_1  := CF_MOD_HIGH_LOW;       -- Cache-modified signal polarity.
      CF_SNOOP_WS          : Bits_2  := CF_SNOOP_WS_3;         -- Snoop wait states.
      CF_WMODE             : Bits_2  := CF_WMODE_NORMWOUPD;    -- SRAM write timing and partial update disable. 
      CF_DATA_RAM_TYPE     : Bits_2  := CF_DATA_RAM_TYPE_SYNC; -- L2 data RAM type.
      CF_FAST_L2_MODE      : Boolean := False;                 -- Fast L2 mode enable.
      FLASH_WR_LOCKOUT     : Boolean := False;                 -- Flash write lock-out.
      CF_FF0_LOCAL         : Boolean := False;                 -- ROM remapping enable.
      NO_SNOOP_EN          : Boolean := False;                 -- This bit controls whether the MPC106 generates snoop transactions on the 60x bus for PCI-to-system-memory transactions.
      CF_FLUSH_L2          : Boolean := False;                 -- L2 cache flush.
      NO_SERIAL_CFG        : Boolean := False;                 -- This bit controls whether the MPC106 serializes configuration writes to PCI devices from the 60x bus.
      L2_EN                : Boolean := False;                 -- This bit enables/disables the internally-controlled L2 cache.
      L2_UPDATE_EN         : Boolean := False;                 -- L2 update enable.
   end record
      with Bit_Order => Low_Order_First,
           Size      => 32;
   for PICR2_Type use record
      CF_WDATA             at 0 range  0 ..  0;
      CF_DOE               at 0 range  1 ..  1;
      CF_APHASE_WS         at 0 range  2 ..  3;
      CF_L2_SIZE           at 0 range  4 ..  5;
      CF_TOE_WIDTH         at 0 range  6 ..  6;
      CF_FAST_CASTOUT      at 0 range  7 ..  7;
      CF_TWO_BANKS         at 0 range  8 ..  8;
      CF_L2_HIT_DELAY      at 0 range  9 .. 10;
      CF_RWITM_FILL        at 0 range 11 .. 11;
      CF_INV_MODE          at 0 range 12 .. 12;
      CF_HOLD              at 0 range 13 .. 13;
      CF_ADDR_ONLY_DISABLE at 0 range 14 .. 14;
      Reserved             at 0 range 15 .. 15;
      CF_HIT_HIGH          at 0 range 16 .. 16;
      CF_MOD_HIGH          at 0 range 17 .. 17;
      CF_SNOOP_WS          at 0 range 18 .. 19;
      CF_WMODE             at 0 range 20 .. 21;
      CF_DATA_RAM_TYPE     at 0 range 22 .. 23;
      CF_FAST_L2_MODE      at 0 range 24 .. 24;
      FLASH_WR_LOCKOUT     at 0 range 25 .. 25;
      CF_FF0_LOCAL         at 0 range 26 .. 26;
      NO_SNOOP_EN          at 0 range 27 .. 27;
      CF_FLUSH_L2          at 0 range 28 .. 28;
      NO_SERIAL_CFG        at 0 range 29 .. 29;
      L2_EN                at 0 range 30 .. 30;
      L2_UPDATE_EN         at 0 range 31 .. 31;
   end record;

   -- 3.2.10 Alternate OS-Visible Parameters Registers

   nXIO_MODE_DISCONTIGUOUS : constant := 0; -- Discontiguous mode
   nXIO_MODE_CONTIGUOUS    : constant := 1; -- Contiguous mode

   type AOSVPR1_Type is record
      MCP_EN     : Boolean := False;                -- Machine check enable.
      TEA_EN     : Boolean := False;                -- Transfer error acknowledge enable.
      nXIO_MODE  : Bits_1  := nXIO_MODE_CONTIGUOUS; -- Address map A discontiguous/contiguous mode.
      Reserved1  : Bits_2  := 0;
      RX_SERR_EN : Boolean := False;                -- This bit controls whether the MPC106 recognizes the assertion of SERR by another PCI device.
      Reserved2  : Bits_2  := 0;
   end record
      with Bit_Order => Low_Order_First,
           Size      => 8;
   for AOSVPR1_Type use record
      MCP_EN     at 0 range 0 .. 0;
      TEA_EN     at 0 range 1 .. 1;
      nXIO_MODE  at 0 range 2 .. 2;
      Reserved1  at 0 range 3 .. 4;
      RX_SERR_EN at 0 range 5 .. 5;
      Reserved2  at 0 range 6 .. 7;
   end record;

   type AOSVPR2_Type is record
      FLASH_WR_EN : Boolean := False; -- Flash write enable.
      Reserved    : Bits_7  := 0;
   end record
      with Bit_Order => Low_Order_First,
           Size      => 8;
   for AOSVPR2_Type use record
      FLASH_WR_EN at 0 range 0 .. 0;
      Reserved    at 0 range 1 .. 7;
   end record;

   -- 3.2.11 Emulation Support Configuration Registers

   PROC_COMPATIBILITY_HOLE_MEM : constant := 0; -- The MPC106 forwards 60x processor-initiated transactions in the address range 0x000A_0000–0x000B_FFFF to system memory.
   PROC_COMPATIBILITY_HOLE_PCI : constant := 1; -- The MPC106 forwards 60x processor-initiated transactions in the address range 0x000A_0000–0x000B_FFFF to the PCI memory space.

   PCI_COMPATIBILITY_HOLE_MEM  : constant := 0; -- The MPC106, as a PCI target, responds to PCI addresses in the range 0x000A_0000–0x000F_FFFF, and forwards the transaction to system memory.
   PCI_COMPATIBILITY_HOLE_NONE : constant := 1; -- The MPC106, as a PCI target, does not respond to PCI addresses in the range 0x000A_0000–0x000F_FFFF.

   type ESCR1_Type is record
      EMULATION_MODE_EN       : Boolean := False;                       -- Emulation mode address map enable.
      EMULATION_MODE_HW       : Bits_1  := 1;                           -- This bit is read-only and indicates that the MPC106 supports the emulation mode address map.
      PROC_COMPATIBILITY_HOLE : Bits_1  := PROC_COMPATIBILITY_HOLE_MEM; -- This bit is used for address map B and the emulation mode map only; it is not used for address map A.
      PCI_COMPATIBILITY_HOLE  : Bits_1  := PCI_COMPATIBILITY_HOLE_MEM;  -- This bit is used for address map B and the emulation mode map only; it is not used for address map A.
      PIRQ_ACTIVE_HIGH        : Boolean := False;                       -- /PIRQ signal polarity.
      PIRQ_EN                 : Boolean := False;                       -- When emulation mode is enabled, PIRQ will be asserted if a PCI-write-to-system-memory occurs when the modified memory status is 0b00.
      FD_ALIAS_EN             : Boolean := True;                        -- This bit is used in address map B only; it is not used for map A or the emulation mode map.
      Reserved1               : Bits_1  := 0;
      TOP_OF_MEM              : Bits_8  := 0;                           -- These bits represent the block address of a 1-Mbyte block that is the upper address boundary to which the MPC106, as a PCI target, will respond.
      INT_VECTOR_RELOCATE     : Bits_12 := 16#FFF#;                     -- These bits represent the 1-Mbyte block of system memory that is accessed when emulation mode is enabled (EMULATION_MODE_EN = 1) and a 60x transaction to the address range 0xFFF0_0000–0xFFFF_FFFF occurs.
      Reserved2               : Bits_4  := 0;
   end record
      with Bit_Order => Low_Order_First,
           Size      => 32;
   for ESCR1_Type use record
      EMULATION_MODE_EN       at 0 range  0 ..  0;
      EMULATION_MODE_HW       at 0 range  1 ..  1;
      PROC_COMPATIBILITY_HOLE at 0 range  2 ..  2;
      PCI_COMPATIBILITY_HOLE  at 0 range  3 ..  3;
      PIRQ_ACTIVE_HIGH        at 0 range  4 ..  4;
      PIRQ_EN                 at 0 range  5 ..  5;
      FD_ALIAS_EN             at 0 range  6 ..  6;
      Reserved1               at 0 range  7 ..  7;
      TOP_OF_MEM              at 0 range  8 .. 15;
      INT_VECTOR_RELOCATE     at 0 range 16 .. 27;
      Reserved2               at 0 range 28 .. 31;
   end record;

   MOD_MEM_SIZE_NONE_1 : constant := 2#1000_0000#; -- 16 Kbytes (not supported)
   MOD_MEM_SIZE_8k     : constant := 2#0100_0000#; -- 8 Kbytes
   MOD_MEM_SIZE_4k     : constant := 2#0010_0000#; -- 4 Kbytes
   MOD_MEM_SIZE_NONE_2 : constant := 2#0001_0000#; -- 2 Kbytes (not supported)
   MOD_MEM_SIZE_NONE_3 : constant := 2#0000_1000#; -- 1 Kbyte (not supported)
   MOD_MEM_SIZE_NONE_4 : constant := 2#0000_0100#; -- 512 bytes (not supported)
   MOD_MEM_SIZE_NONE_5 : constant := 2#0000_0010#; -- 256 bytes (not supported)
   MOD_MEM_SIZE_NONE_6 : constant := 2#0000_0001#; -- 128 bytes (not supported)

   type ESCR2_Type is record
      MOD_MEM_SIZE : Bits_8  := MOD_MEM_SIZE_4k; -- These bits configure the size of the modified memory regions in system memory for the emulation mode address map.
      Reserved     : Bits_24 := 0;
   end record
      with Bit_Order => Low_Order_First,
           Size      => 32;
   for ESCR2_Type use record
      MOD_MEM_SIZE at 0 range 0 ..  7;
      Reserved     at 0 range 8 .. 31;
   end record;

   -- 3.2.12 External Configuration Registers

   -- LE_MODE_* constants already defined at 3.2.9

   type ExternalConfigurationRegister1_Type is record
      Reserved1 : Bits_1 := 0;
      LE_MODE   : Bits_1 := LE_MODE_BE; -- This bit controls the endian mode of the MPC106.
      Reserved2 : Bits_6 := 0;
   end record
      with Bit_Order => Low_Order_First,
           Size      => 8;
   for ExternalConfigurationRegister1_Type use record
      Reserved1 at 0 range 0 .. 0;
      LE_MODE   at 0 range 1 .. 1;
      Reserved2 at 0 range 2 .. 7;
   end record;

   type ExternalConfigurationRegister2_Type is record
      Reserved     : Bits_4  := 0;
      CF_FLUSH_L2  : Boolean := False; -- L2 cache flush.
      TEA_EN       : Boolean := False; -- Transfer error acknowledge enable.
      L2_EN        : Boolean := True;  -- This bit enables/disables the L2 cache.
      L2_UPDATE_EN : Boolean := True;  -- This bit controls how the L2 cache handles cache misses.
   end record
      with Bit_Order => Low_Order_First,
           Size      => 8;
   for ExternalConfigurationRegister2_Type use record
      Reserved     at 0 range 0 .. 3;
      CF_FLUSH_L2  at 0 range 4 .. 4;
      TEA_EN       at 0 range 5 .. 5;
      L2_EN        at 0 range 6 .. 6;
      L2_UPDATE_EN at 0 range 7 .. 7;
   end record;

   -- nXIO_MODE_* already defined at 3.2.10

   type ExternalConfigurationRegister3_Type is record
      nXIO_MODE : Bits_1 := nXIO_MODE_CONTIGUOUS; -- Address map A discontiguous/contiguous mode.
      Reserved  : Bits_7 := 0;
   end record
      with Bit_Order => Low_Order_First,
           Size      => 8;
   for ExternalConfigurationRegister3_Type use record
      nXIO_MODE at 0 range 0 .. 0;
      Reserved  at 0 range 1 .. 7;
   end record;

pragma Style_Checks (On);

end MPC106;

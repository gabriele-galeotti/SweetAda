-----------------------------------------------------------------------------------------------------------------------
--                                                     SweetAda                                                      --
-----------------------------------------------------------------------------------------------------------------------
-- __HDS__                                                                                                           --
-- __FLN__ sun4m.ads                                                                                                 --
-- __DSC__                                                                                                           --
-- __HSH__ e69de29bb2d1d6434b8b29ae775ad8c2e48c5391                                                                  --
-- __HDE__                                                                                                           --
-----------------------------------------------------------------------------------------------------------------------
-- Copyright (C) 2020-2025 Gabriele Galeotti                                                                         --
--                                                                                                                   --
-- SweetAda web page: http://sweetada.org                                                                            --
-- contact address: gabriele.galeotti@sweetada.org                                                                   --
-- This work is licensed under the terms of the MIT License.                                                         --
-- Please consult the LICENSE.txt file located in the top-level directory.                                           --
-----------------------------------------------------------------------------------------------------------------------

with System;
with Interfaces;
with Bits;

package Sun4m
   with Preelaborate => True
   is

   --========================================================================--
   --                                                                        --
   --                                                                        --
   --                               Public part                              --
   --                                                                        --
   --                                                                        --
   --========================================================================--

   use System;
   use Interfaces;
   use Bits;

pragma Style_Checks (Off);

   SCC_BASEADDRESS                           : constant := 16#7110_0000#;
   SLAVIO_TIMER_PROC_BASEADDRESS             : constant := 16#71D0_0000#;
   SLAVIO_TIMER_SYS_BASEADDRESS              : constant := 16#71D1_0000#;
   SLAVIO_INTC_BASEADDRESS                   : constant := 16#71E0_0000#;
   SLAVIO_SS_SCR_BASEADDRESS                 : constant := 16#71F0_0000#;

   DMA2_INTERNAL_IDREGISTER_ADDRESS          : constant := 16#7800_0000#;
   DMA2_ESP_REGISTERS_BASEADDRESS            : constant := 16#7840_0000#;
   DMA2_ETHERNET_REGISTERS_BASEADDRESS       : constant := 16#7840_0010#;
   DMA2_PARALLEL_PORT_REGISTERS_BASEADDRESS  : constant := 16#7C80_0000#;

   SCSI_CONTROLLER_REGISTERS_BASEADDRESS     : constant := 16#7880_0000#;
   ETHERNET_CONTROLLER_REGISTERS_BASEADDRESS : constant := 16#78C0_0000#;

   ----------------------------------------------------------------------------
   -- pp. 2-25 DMA2 Internal ID Register
   ----------------------------------------------------------------------------

   DMA2_INTERNAL_IDREGISTER : aliased Unsigned_32
      with Address              => System'To_Address (DMA2_INTERNAL_IDREGISTER_ADDRESS),
           Volatile_Full_Access => True,
           Import               => True,
           Convention           => Ada;

   ----------------------------------------------------------------------------
   -- 89C105 SLAVIO System Status and System Control Register
   ----------------------------------------------------------------------------

   type Slavio_SS_SC_Type is record
      SR        : Boolean;
      RS        : Boolean;
      Reserved1 : Bits_2;
      WD        : Boolean;
      Reserved2 : Bits_27;
   end record
      with Bit_Order => Low_Order_First,
           Size      => 32;
   for Slavio_SS_SC_Type use record
      SR        at 0 range 0 ..  0;
      RS        at 0 range 1 ..  1;
      Reserved1 at 0 range 2 ..  3;
      WD        at 0 range 4 ..  4;
      Reserved2 at 0 range 5 .. 31;
   end record;

   System_Status_Control : aliased Slavio_SS_SC_Type
      with Address              => System'To_Address (SLAVIO_SS_SCR_BASEADDRESS),
           Volatile_Full_Access => True,
           Import               => True,
           Convention           => Ada;

   ----------------------------------------------------------------------------
   -- 89C105 SLAVIO Interrupt Controller
   ----------------------------------------------------------------------------

   -- pp. 6-39 System Interrupt Pending Register

   type SI_Type is record
      Reserved1 : Bits_7  := 0;
      SBusIrq   : Bits_7;       -- Gives a direct indication of which SBus level interrupts are active.
      K         : Boolean;      -- Keyboard/Mouse interrupt
      S         : Boolean;      -- Serial Port interrupt
      E         : Boolean;      -- Ethernet interrupt
      Reserved2 : Bits_1  := 0;
      SC        : Boolean;      -- SCSI interrupt
      T         : Boolean;      -- Level 10 Counter/Timer
      V         : Boolean;      -- Video interrupt
      Reserved3 : Bits_1  := 0;
      F         : Boolean;      -- Floppy interrupt
      Reserved4 : Bits_5  := 0;
      M         : Boolean;      -- EMC (ECC Memory Controller) interrupt
      I         : Boolean;      -- MSI (MBus-SBus Interface) interrupt
      ME        : Boolean;      -- Module Error (asynchronous fault)
      MA        : Boolean;      -- Mask All interrupts.
   end record
      with Bit_Order => Low_Order_First,
           Size      => 32;
   for SI_Type use record
      Reserved1 at 0 range  0 ..  6;
      SBusIrq   at 0 range  7 .. 13;
      K         at 0 range 14 .. 14;
      S         at 0 range 15 .. 15;
      E         at 0 range 16 .. 16;
      Reserved2 at 0 range 17 .. 17;
      SC        at 0 range 18 .. 18;
      T         at 0 range 19 .. 19;
      V         at 0 range 20 .. 20;
      Reserved3 at 0 range 21 .. 21;
      F         at 0 range 22 .. 22;
      Reserved4 at 0 range 23 .. 27;
      M         at 0 range 28 .. 28;
      I         at 0 range 29 .. 29;
      ME        at 0 range 30 .. 30;
      MA        at 0 range 31 .. 31;
   end record;

   -- pp. 6-39 System Interrupt Pending Register
   -- pp. 6-39 System Interrupt Target Mask Register (Read Only), and Mask Set and Mask Clear Registers (Write Only)

   -- Pending
   SIPR : aliased SI_Type
      with Address              => System'To_Address (SLAVIO_INTC_BASEADDRESS + 16#0001_0000#),
           Volatile_Full_Access => True,
           Import               => True,
           Convention           => Ada;

   -- Target Mask Read
   SITM  : aliased SI_Type
      with Address              => System'To_Address (SLAVIO_INTC_BASEADDRESS + 16#0001_0004#),
           Volatile_Full_Access => True,
           Import               => True,
           Convention           => Ada;

   -- Target Mask Set
   SITMS : aliased SI_Type
      with Address              => System'To_Address (SLAVIO_INTC_BASEADDRESS + 16#0001_0008#),
           Volatile_Full_Access => True,
           Import               => True,
           Convention           => Ada;

   -- Target Mask Clear
   SITMC : aliased SI_Type
      with Address              => System'To_Address (SLAVIO_INTC_BASEADDRESS + 16#0001_000C#),
           Volatile_Full_Access => True,
           Import               => True,
           Convention           => Ada;

   ----------------------------------------------------------------------------
   -- 89C105 SLAVIO Timers
   ----------------------------------------------------------------------------

   -- pp. 6-43 Counter/Timer Limit Register

   type Slavio_Timer_Limit_Type is record
      Reserved1 : Bits_9;
      Limit     : Bits_22;
      Reserved2 : Bits_1;
   end record
      with Bit_Order => Low_Order_First,
           Size      => 32;
   for Slavio_Timer_Limit_Type use record
      Reserved1 at 0 range  0 ..  8;
      Limit     at 0 range  9 .. 30;
      Reserved2 at 0 range 31 .. 31;
   end record;

   -- pp. 6-44 User Timer Count Register Field Definitions

   type Slavio_Timer_Counter_Type is record
      Reserved : Bits_9;
      Count    : Bits_22;
      L        : Bits_1;
   end record
      with Bit_Order => Low_Order_First,
           Size      => 32;
   for Slavio_Timer_Counter_Type use record
      Reserved at 0 range  0 ..  8;
      Count    at 0 range  9 .. 30;
      L        at 0 range 31 .. 31;
   end record;

   type Slavio_Timer_Type is record
      Limit      : Slavio_Timer_Limit_Type   with Volatile_Full_Access => True;
      Counter    : Slavio_Timer_Counter_Type with Volatile_Full_Access => True;
      Counter_NR : Slavio_Timer_Limit_Type   with Volatile_Full_Access => True;
   end record
      with Size => 3 * 32;
   for Slavio_Timer_Type use record
      Limit      at 0 range 0 .. 31;
      Counter    at 4 range 0 .. 31;
      Counter_NR at 8 range 0 .. 31;
   end record;

   System_Timer : aliased Slavio_Timer_Type
      with Address    => System'To_Address (SLAVIO_TIMER_SYS_BASEADDRESS),
           Volatile   => True,
           Import     => True,
           Convention => Ada;

   procedure System_Timer_ClearLR
      with Inline => True;

   procedure Tclk_Init;

   ----------------------------------------------------------------------------
   -- SCC
   ----------------------------------------------------------------------------
   -- CHANNEL A @ 0x7110_0004
   -- CHANNEL B @ 0x7110_0000
   ----------------------------------------------------------------------------

   ----------------------------------------------------------------------------
   -- DMA (Ethernet)
   ----------------------------------------------------------------------------

   -- Control/Status Register

   type E_CSR_Type is record
      E_INT_PEND      : Boolean;      -- R   Set when e_irq_ active, cleared when e_irq_ inactive
      E_ERR_PEND      : Boolean;      -- R   Set when memory time-out, protection or late error detected on a ENET transfer.
      E_DRAINING      : Bits_2;       -- R   Both bits set when E-cache draining dirty data to memory, otherwise both bits are 0.
      E_INT_EN        : Boolean;      -- R/W When set, enables sb_e_irq_ to assert when E_INT_PEND or E_ERR_PEND is set.
      E_INVALIDATE    : Boolean;      -- W   When set, marks all bytes in E-cache as invalid.  Resets itself. Reads as zero.
      E_SLAVE_ERR     : Boolean;      -- R/W Set on slave access size error to a ENET-related register.  Reset on write of 1.
      E_RESET         : Boolean;      -- R/W When set, invalidates the E-cache, resets the ENET interface, and asserts e_reset.
      Unused1         : Bits_2  := 0;
      E_DRAIN         : Boolean;      -- R/W When set, forces draining of E-cache Resets itself when draining complete
      E_DSBL_WR_DRN   : Boolean;      -- R/W When set, disables draining of E-cache on descriptor writes from ENET.
      E_DSBL_RD_DRN   : Boolean;      -- R/W When set, disables draining of E-cache on slave reads to ENET.
      Unused2         : Bits_2  := 0;
      E_ILACC         : Boolean;      -- R/W When set, modifies ENET DMA cycle.
      E_DSBL_BUF_WR   : Boolean;      -- R/W When set, disables buffering of slave writes to ENET.
      E_DSBL_WR_INVAL : Boolean;      -- R/W Defines whether E-cache is invalidated on slave writes to ENET 1 = no invalidate
      E_BURST_SIZE    : Bits_2;       -- R/W Defines size of SBus read and write bursts for ENET transfers (see table below).
      Unused3         : Bits_1  := 0;
      E_LOOP_TEST     : Boolean;      -- R/W When set, enables Ethernet loop-back mode by tristating TP_AUI_ output.
      E_TP_AUI_x      : Boolean;      -- R/W When E_LOOP_TEST = 0, selects TP or AUI Ethernet by driving TP_AUI to 1 or 0.
      Unused4         : Bits_5  := 0;
      E_DEV_ID        : Bits_4;       -- R   Device ID (For DMA2, E_DEV_ID=1010)
   end record
      with Bit_Order => High_Order_First,
           Size      => 32;
   for E_CSR_Type use record
      E_INT_PEND      at 0 range  0 ..  0;
      E_ERR_PEND      at 0 range  1 ..  1;
      E_DRAINING      at 0 range  2 ..  3;
      E_INT_EN        at 0 range  4 ..  4;
      E_INVALIDATE    at 0 range  5 ..  5;
      E_SLAVE_ERR     at 0 range  6 ..  6;
      E_RESET         at 0 range  7 ..  7;
      Unused1         at 0 range  8 ..  9;
      E_DRAIN         at 0 range 10 .. 10;
      E_DSBL_WR_DRN   at 0 range 11 .. 11;
      E_DSBL_RD_DRN   at 0 range 12 .. 12;
      Unused2         at 0 range 13 .. 14;
      E_ILACC         at 0 range 15 .. 15;
      E_DSBL_BUF_WR   at 0 range 16 .. 16;
      E_DSBL_WR_INVAL at 0 range 17 .. 17;
      E_BURST_SIZE    at 0 range 18 .. 19;
      Unused3         at 0 range 20 .. 20;
      E_LOOP_TEST     at 0 range 21 .. 21;
      E_TP_AUI_x      at 0 range 22 .. 22;
      Unused4         at 0 range 23 .. 27;
      E_DEV_ID        at 0 range 28 .. 31;
   end record;

   E_CSR_ADDRESS : constant := DMA2_ETHERNET_REGISTERS_BASEADDRESS + 16#0#;

   E_CSR : aliased E_CSR_Type
      with Address              => System'To_Address (E_CSR_ADDRESS),
           Volatile_Full_Access => True,
           Import               => True,
           Convention           => Ada;

   function To_U32
      (Value : E_CSR_Type)
      return Unsigned_32
      with Inline => True;
   function To_E_CSR
      (Value : Unsigned_32)
      return E_CSR_Type
      with Inline => True;

   -- Test Control/Status Reg

   E_TST_CSR_ADDRESS : constant := DMA2_ETHERNET_REGISTERS_BASEADDRESS + 16#4#;

   E_TST_CSR : aliased Unsigned_32
      with Address              => System'To_Address (E_TST_CSR_ADDRESS),
           Volatile_Full_Access => True,
           Import               => True,
           Convention           => Ada;

   -- Cache Valid Bits

   E_VLD_ADDRESS : constant := DMA2_ETHERNET_REGISTERS_BASEADDRESS + 16#8#;

   E_VLD : aliased Unsigned_32
      with Address              => System'To_Address (E_VLD_ADDRESS),
           Volatile_Full_Access => True,
           Import               => True,
           Convention           => Ada;

   -- Base Address Reg
   -- High Order 8 bits of address for Ethernet DMA transfers (defaults to 0xFF).

   E_BASE_ADDR_ADDRESS : constant := DMA2_ETHERNET_REGISTERS_BASEADDRESS + 16#C#;

   E_BASE_ADDR : aliased Unsigned_8
      with Address              => System'To_Address (E_BASE_ADDR_ADDRESS),
           Volatile_Full_Access => True,
           Import               => True,
           Convention           => Ada;

pragma Style_Checks (On);

end Sun4m;

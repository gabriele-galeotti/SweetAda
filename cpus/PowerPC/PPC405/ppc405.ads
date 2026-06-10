-----------------------------------------------------------------------------------------------------------------------
--                                                     SweetAda                                                      --
-----------------------------------------------------------------------------------------------------------------------
-- __HDS__                                                                                                           --
-- __FLN__ ppc405.ads                                                                                                --
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
with Interfaces;
with Bits;
with PowerPC;

package PPC405
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

   ----------------------------------------------------------------------------
   -- AMCC 405 PowerPC
   -- – User’s Manual –
   -- PPC405EP Embedded Processor
   -- Document Issue 1.01 September 2004
   ----------------------------------------------------------------------------

   subtype SPR_Type is PowerPC.SPR_Type;

   ----------------------------------------------------------------------------
   -- SPRs
   ----------------------------------------------------------------------------

   PID    : constant SPR_Type := 945;  -- 0x3B1
   CCR0   : constant SPR_Type := 947;  -- 0x3B3
   IAC3   : constant SPR_Type := 948;  -- 0x3B4
   IAC4   : constant SPR_Type := 949;  -- 0x3B5
   DVC1   : constant SPR_Type := 950;  -- 0x3B6
   DVC2   : constant SPR_Type := 951;  -- 0x3B7
   DCWR   : constant SPR_Type := 954;  -- 0x3BA
   DBCR1  : constant SPR_Type := 957;  -- 0x3BD
   ICDBDR : constant SPR_Type := 979;  -- 0x3D3
   ESR    : constant SPR_Type := 980;  -- 0x3D4
   DEAR   : constant SPR_Type := 981;  -- 0x3D5
   EVPR   : constant SPR_Type := 982;  -- 0x3D6
   TSR    : constant SPR_Type := 984;  -- 0x3D8
   TCR    : constant SPR_Type := 986;  -- 0x3DA
   PIT    : constant SPR_Type := 987;  -- 0x3DB
   DBSR   : constant SPR_Type := 1008; -- 0x3F0
   DBCR0  : constant SPR_Type := 1010; -- 0x3F2
   IAC1   : constant SPR_Type := 1012; -- 0x3F4
   IAC2   : constant SPR_Type := 1013; -- 0x3F5
   DAC1   : constant SPR_Type := 1014; -- 0x3F6
   DAC2   : constant SPR_Type := 1015; -- 0x3F7
   DCCR   : constant SPR_Type := 1018; -- 0x3FA
   ICCR   : constant SPR_Type := 1019; -- 0x3FB

   ----------------------------------------------------------------------------
   -- DCRs generics
   ----------------------------------------------------------------------------

   type DCR_Type is mod 2**10; -- 0 .. 1023

   -- DCR numbers
   -- DCRF:                        -- 5 .. 9 ---   -------- 0 .. 4 --------
   UIC0_SR  : constant DCR_Type := 16#C0# / 2**5 + (16#C0# mod 2**5) * 2**5; -- UIC Status Register
   UIC0_ER  : constant DCR_Type := 16#C2# / 2**5 + (16#C2# mod 2**5) * 2**5; -- UIC Enable Register
   UIC0_CR  : constant DCR_Type := 16#C3# / 2**5 + (16#C3# mod 2**5) * 2**5; -- UIC Critical Register
   UIC0_PR  : constant DCR_Type := 16#C4# / 2**5 + (16#C4# mod 2**5) * 2**5; -- UIC Polarity Register
   UIC0_TR  : constant DCR_Type := 16#C5# / 2**5 + (16#C5# mod 2**5) * 2**5; -- UIC Trigger Register
   UIC0_MSR : constant DCR_Type := 16#C6# / 2**5 + (16#C6# mod 2**5) * 2**5; -- UIC Masked Status Register
   UIC0_VR  : constant DCR_Type := 16#C7# / 2**5 + (16#C7# mod 2**5) * 2**5; -- UIC Vector Register
   UIC0_VCR : constant DCR_Type := 16#C8# / 2**5 + (16#C8# mod 2**5) * 2**5; -- UIC Vector Configuration Register

   generic
      DCR : in DCR_Type;
      type DCR_Value_Type is private;
   function MFDCR
      return DCR_Value_Type
      with Inline => True;

   generic
      DCR : in DCR_Type;
      type DCR_Value_Type is private;
   procedure MTDCR
      (DCR_Value : in DCR_Value_Type)
      with Inline => True;

   ----------------------------------------------------------------------------
   -- Chapter 10. Interrupt Controller Operations
   ----------------------------------------------------------------------------

   -- indexes into UIC0_SR/UIC0_ER arrays

   U0I  : constant := 0;  -- UART0 Interrupt
   U1I  : constant := 1;  -- UART1 Interrupt
   IICI : constant := 2;  -- IIC Interrupt
   PCII : constant := 3;  -- PCI Interrupt
   -- Reserved1
   D0I  : constant := 5;  -- DMA Channel 0 Interrupt
   D1I  : constant := 6;  -- DMA Channel 1 Interrupt
   D2I  : constant := 7;  -- DMA Channel 2 Interrupt
   D3I  : constant := 8;  -- DMA Channel 3 Interrupt
   EWI  : constant := 9;  -- Ethernet Wake-up Interrupt
   MSI  : constant := 10; -- MAL SERR Interrupt
   MTEI : constant := 11; -- MAL TX EOB Interrupt
   MREI : constant := 12; -- MAL RX EOB Interrupt
   MTDI : constant := 13; -- MAL TX DE Interrupt
   MRDI : constant := 14; -- MAL RX DE Interrupt
   EI0  : constant := 15; -- EMAC0 Interrupt
   EPSI : constant := 16; -- External PCI SERR Interrupt
   EI1  : constant := 17; -- EMAC1 Interrupt
   PPMI : constant := 18; -- PCI Power Management Interrupt
   GTI0 : constant := 19; -- General Purpose Timer Interrupt 0
   GTI1 : constant := 20; -- General Purpose Timer Interrupt 1
   GTI2 : constant := 21; -- General Purpose Timer Interrupt 2
   GTI3 : constant := 22; -- General Purpose Timer Interrupt 3
   GTI4 : constant := 23; -- General Purpose Timer Interrupt 4
   -- Reserved2
   EIR0 : constant := 25; -- External IRQ 0
   EIR1 : constant := 26; -- External IRQ 1
   EIR2 : constant := 27; -- External IRQ 2
   EIR3 : constant := 28; -- External IRQ 3
   EIR4 : constant := 29; -- External IRQ 4
   EIR5 : constant := 30; -- External IRQ 5
   EIR6 : constant := 31; -- External IRQ 6

   -- 10.5.1 UIC Status Register (UIC0_SR)

   subtype UIC0_SR_Type is Bitmap_32;

   function UIC0_SR_Read
      return UIC0_SR_Type
      with Inline => True;
   procedure UIC0_SR_Write
      (Value : in UIC0_SR_Type)
      with Inline => True;

   -- 10.5.2 UIC Enable Register (UIC0_ER)

   subtype UIC0_ER_Type is Bitmap_32;

   function UIC0_ER_Read
      return UIC0_ER_Type
      with Inline => True;
   procedure UIC0_ER_Write
      (Value : in UIC0_ER_Type)
      with Inline => True;

   ----------------------------------------------------------------------------
   -- Chapter 11. Timer Facilities
   ----------------------------------------------------------------------------

   -- 11.2 Programmable Interval Timer (PIT)

   function PIT_Read
      return Unsigned_32
      with Inline => True;
   procedure PIT_Write
      (Value : in Unsigned_32)
      with Inline => True;

   -- 11.4 Timer Status Register (TSR)

   WRS_NONE   : constant := 2#00#; -- No Watchdog Timer reset has occurred.
   WRS_CORE   : constant := 2#01#; -- Core reset was forced by the watchdog
   WRS_CHIP   : constant := 2#10#; -- Chip reset was forced by the watchdog
   WRS_SYSTEM : constant := 2#11#; -- System reset was forced by the watchdog

   type TSR_Type is record
      ENW      : Boolean := False;    -- Enable Next Watchdog
      WIS      : Boolean := False;    -- Watchdog Interrupt Status
      WRS      : Bits_2  := WRS_NONE; -- Watchdog Reset Status
      PIS      : Boolean := False;    -- PIT Interrupt Status
      FIS      : Boolean := False;    -- FIT Interrupt Status
      Reserved : Bits_26 := 0;
   end record
      with Bit_Order => High_Order_First,
           Size      => 32;
   for TSR_Type use record
      ENW      at 0 range 0 ..  0;
      WIS      at 0 range 1 ..  1;
      WRS      at 0 range 2 ..  3;
      PIS      at 0 range 4 ..  4;
      FIS      at 0 range 5 ..  5;
      Reserved at 0 range 6 .. 31;
   end record;

   function TSR_Read
      return TSR_Type
      with Inline => True;
   procedure TSR_Write
      (Value : in TSR_Type)
      with Inline => True;

   function TSR_PIS return TSR_Type with Inline => True;
   function TSR_FIS return TSR_Type with Inline => True;

   -- 11.5 Timer Control Register (TCR)

   WP_CLKS2E17 : constant := 2#00#; -- 2^17 clocks
   WP_CLKS2E21 : constant := 2#01#; -- 2^21 clocks
   WP_CLKS2E25 : constant := 2#10#; -- 2^25 clocks
   WP_CLKS2E29 : constant := 2#11#; -- 2^29 clocks

   WRC_NONE   renames WRS_NONE;   -- No Watchdog reset will occur.
   WRC_CORE   renames WRS_CORE;   -- Core reset will be forced by the Watchdog.
   WRC_CHIP   renames WRS_CHIP;   -- Chip reset will be forced by the Watchdog.
   WRC_SYSTEM renames WRS_SYSTEM; -- System reset will be forced by the Watchdog.

   FP_CLKS2E9  : constant := 2#00#; -- 2^9 clocks
   FP_CLKS2E13 : constant := 2#01#; -- 2^13 clocks
   FP_CLKS2E17 : constant := 2#10#; -- 2^17 clocks
   FP_CLKS2E21 : constant := 2#11#; -- 2^21 clocks

   type TCR_Type is record
      WP       : Bits_2  := WP_CLKS2E17; -- Watchdog Period
      WRC      : Bits_2  := WRC_NONE;    -- Watchdog Reset Control
      WIE      : Boolean := False;       -- Watchdog Interrupt Enable
      PIE      : Boolean := False;       -- PIT Interrupt Enable
      FP       : Bits_2  := FP_CLKS2E9;  -- FIT Period
      FIE      : Boolean := False;       -- FIT Interrupt Enable
      ARE      : Boolean := False;       -- Auto Reload Enable
      Reserved : Bits_22 := 0;
   end record
      with Bit_Order => High_Order_First,
           Size      => 32;
   for TCR_Type use record
      WP       at 0 range  0 ..  1;
      WRC      at 0 range  2 ..  3;
      WIE      at 0 range  4 ..  4;
      PIE      at 0 range  5 ..  5;
      FP       at 0 range  6 ..  7;
      FIE      at 0 range  8 ..  8;
      ARE      at 0 range  9 ..  9;
      Reserved at 0 range 10 .. 31;
   end record;

   function TCR_Read
      return TCR_Type
      with Inline => True;
   procedure TCR_Write
      (Value : in TCR_Type)
      with Inline => True;

   ----------------------------------------------------------------------------
   -- Exceptions and interrupts
   ----------------------------------------------------------------------------

   procedure Irq_Enable
      with Inline => True;
   procedure Irq_Disable
      with Inline => True;

pragma Style_Checks (On);

end PPC405;

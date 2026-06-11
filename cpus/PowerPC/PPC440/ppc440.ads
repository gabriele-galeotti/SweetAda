-----------------------------------------------------------------------------------------------------------------------
--                                                     SweetAda                                                      --
-----------------------------------------------------------------------------------------------------------------------
-- __HDS__                                                                                                           --
-- __FLN__ ppc440.ads                                                                                                --
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

package PPC440
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
   -- AMCC 440 PPC440 Processor
   -- PPC440 Processor User’s Manual
   -- Revision 1.09 – March 13, 2008
   ----------------------------------------------------------------------------

   subtype SPR_Type is PowerPC.SPR_Type;

   -- Table 9-1. Special Purpose Registers Sorted by SPR Number

   PID    : constant SPR_Type := 48;   -- 0x030
   DECAR  : constant SPR_Type := 54;   -- 0x036
   CSRR0  : constant SPR_Type := 58;   -- 0x03A
   CSRR1  : constant SPR_Type := 59;   -- 0x03B
   DEAR   : constant SPR_Type := 61;   -- 0x03D
   ESR    : constant SPR_Type := 62;   -- 0x03E
   IVPR   : constant SPR_Type := 63;   -- 0x03F
   USPRG0 : constant SPR_Type := 256;  -- 0x100
   SPRG4  : constant SPR_Type := 260;  -- 0x104
   SPRG5  : constant SPR_Type := 261;  -- 0x105
   SPRG6  : constant SPR_Type := 262;  -- 0x106
   SPRG7  : constant SPR_Type := 263;  -- 0x107
   TBL    : constant SPR_Type := 268;  -- 0x10C
   TBU    : constant SPR_Type := 269;  -- 0x10D
   TSR    : constant SPR_Type := 336;  -- 0x150
   TCR    : constant SPR_Type := 340;  -- 0x154
   IVOR0  : constant SPR_Type := 400;  -- 0x190
   IVOR1  : constant SPR_Type := 401;  -- 0x191
   IVOR2  : constant SPR_Type := 402;  -- 0x192
   IVOR3  : constant SPR_Type := 403;  -- 0x193
   IVOR4  : constant SPR_Type := 404;  -- 0x194
   IVOR5  : constant SPR_Type := 405;  -- 0x195
   IVOR6  : constant SPR_Type := 406;  -- 0x196
   IVOR7  : constant SPR_Type := 407;  -- 0x197
   IVOR8  : constant SPR_Type := 408;  -- 0x198
   IVOR9  : constant SPR_Type := 409;  -- 0x199
   IVOR10 : constant SPR_Type := 410;  -- 0x19A
   IVOR11 : constant SPR_Type := 411;  -- 0x19B
   IVOR12 : constant SPR_Type := 412;  -- 0x19C
   IVOR13 : constant SPR_Type := 413;  -- 0x19D
   IVOR14 : constant SPR_Type := 414;  -- 0x19E
   IVOR15 : constant SPR_Type := 415;  -- 0x19F

   ----------------------------------------------------------------------------
   -- 5. Interrupts and Exceptions
   ----------------------------------------------------------------------------

   -- 5.4.9 Interrupt Vector Offset Registers (IVOR0:IVOR15)

   procedure IVOR10_Write
      (Value : in Unsigned_32)
      with Inline => True;

   ----------------------------------------------------------------------------
   -- 6. Timer Facilities
   ----------------------------------------------------------------------------

   -- 6.2 Decrementer (DEC)

   function DEC_Read
      return Unsigned_32
      with Inline => True;
   procedure DEC_Write
      (Value : in Unsigned_32)
      with Inline => True;
   procedure DECAR_Write
      (Value : in Unsigned_32)
      with Inline => True;

   -- 6.5 Timer Control Register (TCR)

   WP_CLKS2E17 : constant := 2#00#; -- 2^17 time base clocks
   WP_CLKS2E21 : constant := 2#01#; -- 2^21 time base clocks
   WP_CLKS2E25 : constant := 2#10#; -- 2^25 time base clocks
   WP_CLKS2E29 : constant := 2#11#; -- 2^29 time base clocks

   WRC_NONE   : constant := 2#00#; -- No Watchdog Timer reset will occur.
   WRC_CORE   : constant := 2#01#; -- Core reset
   WRC_CHIP   : constant := 2#10#; -- Chip reset
   WRC_SYSTEM : constant := 2#11#; -- System reset

   FP_CLKS2E9  : constant := 2#00#; -- 2^9 time base clocks
   FP_CLKS2E13 : constant := 2#01#; -- 2^13 time base clocks
   FP_CLKS2E17 : constant := 2#10#; -- 2^17 time base clocks
   FP_CLKS2E21 : constant := 2#11#; -- 2^21 time base clocks

   type TCR_Type is record
      WP       : Bits_2  := WP_CLKS2E17; -- Watchdog Timer Period
      WRC      : Bits_2  := WRC_NONE;    -- Watchdog Timer Reset Control
      WIE      : Boolean := False;       -- Watchdog Timer Interrupt Enable
      DIE      : Boolean := False;       -- Decrementer Interrupt Enable
      FP       : Bits_2  := FP_CLKS2E9;  -- Fixed Interval Timer (FIT) Period
      FIE      : Boolean := False;       -- FIT Interrupt Enable
      ARE      : Boolean := False;       -- Auto-Reload Enable
      Reserved : Bits_22 := 0;
   end record
      with Bit_Order => High_Order_First,
           Size      => 32;
   for TCR_Type use record
      WP       at 0 range  0 ..  1;
      WRC      at 0 range  2 ..  3;
      WIE      at 0 range  4 ..  4;
      DIE      at 0 range  5 ..  5;
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

   -- 6.6 Timer Status Register (TSR)

   WRS_NONE   renames WRC_NONE;   -- No Watchdog Timer reset has occurred.
   WRS_CORE   renames WRC_CORE;   -- Core reset was forced by Watchdog Timer.
   WRS_CHIP   renames WRC_CHIP;   -- Chip reset was forced by Watchdog Timer.
   WRS_SYSTEM renames WRC_SYSTEM; -- System reset was forced by Watchdog Timer.

   type TSR_Type is record
      ENW      : Boolean := False;    -- Enable Next Watchdog Timer Exception
      WIS      : Boolean := False;    -- Watchdog Timer Interrupt Status
      WRS      : Bits_2  := WRS_NONE; -- Watchdog Timer Reset Status
      DIS      : Boolean := False;    -- Decrementer Interrupt Status
      FIS      : Boolean := False;    -- Fixed Interval Timer (FIT) Interrupt Status
      Reserved : Bits_26 := 0;
   end record
      with Bit_Order => High_Order_First,
           Size      => 32;
   for TSR_Type use record
      ENW      at 0 range 0 ..  0;
      WIS      at 0 range 1 ..  1;
      WRS      at 0 range 2 ..  3;
      DIS      at 0 range 4 ..  4;
      FIS      at 0 range 5 ..  5;
      Reserved at 0 range 6 .. 31;
   end record;

   function TSR_Read
      return TSR_Type
      with Inline => True;
   procedure TSR_Write
      (Value : in TSR_Type)
      with Inline => True;

   function TSR_DIS return TSR_Type with Inline => True;
   function TSR_FIS return TSR_Type with Inline => True;

   ----------------------------------------------------------------------------
   -- Exceptions and interrupts
   ----------------------------------------------------------------------------

   procedure Irq_Enable
      with Inline => True;
   procedure Irq_Disable
      with Inline => True;

pragma Style_Checks (On);

end PPC440;

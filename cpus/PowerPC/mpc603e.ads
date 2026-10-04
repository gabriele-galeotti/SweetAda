-----------------------------------------------------------------------------------------------------------------------
--                                                     SweetAda                                                      --
-----------------------------------------------------------------------------------------------------------------------
-- __HDS__                                                                                                           --
-- __FLN__ mpc603e.ads                                                                                               --
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

pragma Restrictions (No_Elaboration_Code);
pragma Style_Checks (Off);

with System;
with Bits;
with PowerPC;

package MPC603e
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
   use PowerPC;

   ----------------------------------------------------------------------------
   -- MPC603e RISC Microprocessor User’s Manual
   -- MPC603EUM/AD
   -- Q2/02
   -- REV 3
   ----------------------------------------------------------------------------

   -- 2.1.2.1 Hardware Implementation Registers (HID0 and HID1)

   HID0 : constant SPR_Type := 1008;

   type HID0_Type is record
      EMCP      : Boolean;      -- Enable /MCP.
      Reserved1 : Bits_1;
      EBA       : Boolean;      -- Enable 60x bus address parity checking.
      EBD       : Boolean;      -- Enable 60x bus data parity checking.
      BCLK      : Boolean;      -- CLK_OUT output enable and clock type selection.
      EICE      : Boolean;      -- Enables in-circuit emulator outputs for pipeline tracking.
      ECLK      : Boolean;      -- CLK_OUT output enable and clock type selection.
      PAR       : Boolean;      -- Disable precharge of /ARTRY.
      DOZE      : Boolean;      -- Doze mode enable.
      NAP       : Boolean;      -- Nap mode enable.
      SLEEP     : Boolean;      -- Sleep mode enable.
      DPM       : Boolean;      -- Dynamic power management enable.
      Reserved2 : Bits_4  := 0;
      ICE       : Boolean;      -- Instruction cache enable.
      DCE       : Boolean;      -- Data cache enable.
      ILOCK     : Boolean;      -- Instruction cache lock.
      DLOCK     : Boolean;      -- Data cache lock.
      ICFI      : Boolean;      -- Instruction cache flash invalidate.
      DCFI      : Boolean;      -- Data cache flash invalidate.
      Reserved3 : Bits_2  := 0;
      IFEM      : Boolean;      -- Enable M bit on 60x bus for instruction fetches (PID7t-603e only).
      Reserved4 : Bits_2  := 0;
      FBIOB     : Boolean;      -- Force branch indirect on bus.
      ABE       : Boolean;      -- Address broadcast enable.
      Reserved5 : Bits_2;
      NOOPTI    : Boolean;      -- No-op the data cache touch instructions.
   end record
      with Bit_Order => High_Order_First,
           Size      => 32;
   for HID0_Type use record
      EMCP      at 0 range  0 ..  0;
      Reserved1 at 0 range  1 ..  1;
      EBA       at 0 range  2 ..  2;
      EBD       at 0 range  3 ..  3;
      BCLK      at 0 range  4 ..  4;
      EICE      at 0 range  5 ..  5;
      ECLK      at 0 range  6 ..  6;
      PAR       at 0 range  7 ..  7;
      DOZE      at 0 range  8 ..  8;
      NAP       at 0 range  9 ..  9;
      SLEEP     at 0 range 10 .. 10;
      DPM       at 0 range 11 .. 11;
      Reserved2 at 0 range 12 .. 15;
      ICE       at 0 range 16 .. 16;
      DCE       at 0 range 17 .. 17;
      ILOCK     at 0 range 18 .. 18;
      DLOCK     at 0 range 19 .. 19;
      ICFI      at 0 range 20 .. 20;
      DCFI      at 0 range 21 .. 21;
      Reserved3 at 0 range 22 .. 23;
      IFEM      at 0 range 24 .. 24;
      Reserved4 at 0 range 25 .. 26;
      FBIOB     at 0 range 27 .. 27;
      ABE       at 0 range 28 .. 28;
      Reserved5 at 0 range 29 .. 30;
      NOOPTI    at 0 range 31 .. 31;
   end record;

   function HID0_Read
      return HID0_Type
      with Inline => True;

   procedure HID0_Write
      (Value : in HID0_Type)
      with Inline => True;

   HID1 : constant SPR_Type := 1009;

   type HID1_Type is record
      PC0      : Bits_1;       -- PLL configuration bit 0 (read-only)
      PC1      : Bits_1;       -- PLL configuration bit 1 (read-only)
      PC2      : Bits_1;       -- PLL configuration bit 2 (read-only)
      PC3      : Bits_1;       -- PLL configuration bit 3 (read-only)
      Reserved : Bits_28 := 0;
   end record
      with Bit_Order => High_Order_First,
           Size      => 32;
   for HID1_Type use record
      PC0      at 0 range 0 ..  0;
      PC1      at 0 range 1 ..  1;
      PC2      at 0 range 2 ..  2;
      PC3      at 0 range 3 ..  3;
      Reserved at 0 range 4 .. 31;
   end record;

   function HID1_Read
      return HID1_Type
      with Inline => True;

   -- procedure HID1_Write
   --    (Value : in HID1_Type)
   --    with Inline => True;

end MPC603e;

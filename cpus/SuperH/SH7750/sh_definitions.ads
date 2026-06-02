-----------------------------------------------------------------------------------------------------------------------
--                                                     SweetAda                                                      --
-----------------------------------------------------------------------------------------------------------------------
-- __HDS__                                                                                                           --
-- __FLN__ sh_definitions.ads                                                                                        --
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

package SH_Definitions
   with Pure => True
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

   ----------------------------------------------------------------------------
   -- SH7750, SH7750S, SH7750R Group
   -- User’s Manual: Hardware
   -- Renesas 32-Bit RISC Microcomputer
   -- SuperHTM RISC engine Family / SH7750 Series
   -- Rev.7.02 Sep 2013
   ----------------------------------------------------------------------------

   -- 2.2.4 Control Registers

   MD_USERMODE   : constant := 0; -- User mode
   MD_PRIVILEGED : constant := 1; -- Privileged mode

   RB_BANK0 : constant := 0; -- R0_BANK0–R7_BANK0 are accessed as general registers R0–R7.
   RB_BANK1 : constant := 1; -- R0_BANK1–R7_BANK1 are accessed as general registers R0–R7.

   type SR_Type is record
      T         : Boolean;      -- True/false condition or carry/borrow bit
      S         : Boolean;      -- Specifies a saturation operation for a MAC instruction.
      Reserved1 : Bits_2  := 0;
      IMASK     : Bits_4;       -- Interrupt mask level
      Q         : Boolean;      -- Used by the DIV0S, DIV0U, and DIV1 instructions.
      M         : Boolean;      -- ''
      Reserved2 : Bits_5  := 0;
      FD        : Boolean;      -- FPU disable bit
      Reserved3 : Bits_12 := 0;
      BL        : Boolean;      -- Exception/interrupt block bit
      RB        : Bits_1;       -- General register bank specifier in privileged mode
      MD        : Bits_1;       -- Processor mode
      Reserved4 : Bits_1  := 0;
   end record
      with Bit_Order   => Low_Order_First,
           Object_Size => 32;
   for SR_Type use record
      T         at 0 range  0 ..  0;
      S         at 0 range  1 ..  1;
      Reserved1 at 0 range  2 ..  3;
      IMASK     at 0 range  4 ..  7;
      Q         at 0 range  8 ..  8;
      M         at 0 range  9 ..  9;
      Reserved2 at 0 range 10 .. 14;
      FD        at 0 range 15 .. 15;
      Reserved3 at 0 range 16 .. 27;
      BL        at 0 range 28 .. 28;
      RB        at 0 range 29 .. 29;
      MD        at 0 range 30 .. 30;
      Reserved4 at 0 range 31 .. 31;
   end record;

end SH_Definitions;

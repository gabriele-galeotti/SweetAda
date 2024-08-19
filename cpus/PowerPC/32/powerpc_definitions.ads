-----------------------------------------------------------------------------------------------------------------------
--                                                     SweetAda                                                      --
-----------------------------------------------------------------------------------------------------------------------
-- __HDS__                                                                                                           --
-- __FLN__ powerpc_definitions.ads                                                                                   --
-- __DSC__                                                                                                           --
-- __HSH__ e69de29bb2d1d6434b8b29ae775ad8c2e48c5391                                                                  --
-- __HDE__                                                                                                           --
-----------------------------------------------------------------------------------------------------------------------
-- Copyright (C) 2020-2024 Gabriele Galeotti                                                                         --
--                                                                                                                   --
-- SweetAda web page: http://sweetada.org                                                                            --
-- contact address: gabriele.galeotti@sweetada.org                                                                   --
-- This work is licensed under the terms of the MIT License.                                                         --
-- Please consult the LICENSE.txt file located in the top-level directory.                                           --
-----------------------------------------------------------------------------------------------------------------------

with System;
with Bits;

package PowerPC_Definitions
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
   -- MSR
   ----------------------------------------------------------------------------

   -- 2.3.1 Machine State Register (MSR)

   PR_US : constant := 0; -- The processor can execute both user- and supervisor-level instructions.
   PR_U  : constant := 1; -- The processor can only execute user-level instructions.

   type FE_Type is record
      FE0 : Bits_1;
      FE1 : Bits_1;
   end record;

   FE_DISABLED    : constant FE_Type := (0, 0); -- Floating-point exceptions disabled
   FE_IMPRECISENR : constant FE_Type := (0, 1); -- Floating-point imprecise nonrecoverable
   FE_IMPRECISE   : constant FE_Type := (1, 0); -- Floating-point imprecise recoverable
   FE_PRECISE     : constant FE_Type := (1, 1); -- Floating-point precise mode

   IP_LOW  : constant := 0; -- Interrupts are vectored to the physical address 0x000n_nnnn.
   IP_HIGH : constant := 1; -- Interrupts are vectored to the physical address 0xFFFn_nnnn.

   type MSR_Type is record
      Reserved1 : Bits_13 := 0;
      POW       : Boolean;      -- Power management enable
      Reserved2 : Bits_1  := 0;
      ILE       : Boolean;      -- Interrupt little-endian mode.
      EE        : Boolean;      -- External interrupt enable
      PR        : Bits_1;       -- Privilege level
      FP        : Boolean;      -- Floating-point available
      ME        : Boolean;      -- Machine check enable
      FE0       : Bits_1;       -- Floating-point exception mode 0
      SE        : Boolean;      -- Single-step trace enable (Optional)
      BE        : Boolean;      -- Branch trace enable (Optional)
      FE1       : Bits_1;       -- Floating-point exception mode 1
      Reserved3 : Bits_1  := 0;
      IP        : Bits_1;       -- Interrupt prefix
      IR        : Boolean;      -- Instruction address translation
      DR        : Boolean;      -- Data address translation
      Reserved4 : Bits_2  := 0;
      RI        : Boolean;      -- Recoverable interrupt
      LE        : Boolean;      -- Little-endian mode enable
   end record
      with Bit_Order => High_Order_First,
           Size      => 32;
   for MSR_Type use record
      Reserved1 at 0 range  0 .. 12;
      POW       at 0 range 13 .. 13;
      Reserved2 at 0 range 14 .. 14;
      ILE       at 0 range 15 .. 15;
      EE        at 0 range 16 .. 16;
      PR        at 0 range 17 .. 17;
      FP        at 0 range 18 .. 18;
      ME        at 0 range 19 .. 19;
      FE0       at 0 range 20 .. 20;
      SE        at 0 range 21 .. 21;
      BE        at 0 range 22 .. 22;
      FE1       at 0 range 23 .. 23;
      Reserved3 at 0 range 24 .. 24;
      IP        at 0 range 25 .. 25;
      IR        at 0 range 26 .. 26;
      DR        at 0 range 27 .. 27;
      Reserved4 at 0 range 28 .. 29;
      RI        at 0 range 30 .. 30;
      LE        at 0 range 31 .. 31;
   end record;

end PowerPC_Definitions;

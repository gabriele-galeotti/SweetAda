-----------------------------------------------------------------------------------------------------------------------
--                                                     SweetAda                                                      --
-----------------------------------------------------------------------------------------------------------------------
-- __HDS__                                                                                                           --
-- __FLN__ powerpc_definitions.ads                                                                                   --
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

   SF_32 : constant := 0; -- The 64-bit processor runs in 32-bit mode.
   SF_64 : constant := 1; -- The 64-bit processor runs in 64-bit mode.

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
      SF        : Bits_1  := SF_64;
      Reserved1 : Bits_44 := 0;
      POW       : Boolean;          -- Power management enable
      Reserved2 : Bits_1  := 0;
      ILE       : Boolean;          -- Interrupt little-endian mode.
      EE        : Boolean;          -- External interrupt enable
      PR        : Bits_1;           -- Privilege level
      FP        : Boolean;          -- Floating-point available
      ME        : Boolean;          -- Machine check enable
      FE0       : Bits_1;           -- Floating-point exception mode 0
      SE        : Boolean;          -- Single-step trace enable (Optional)
      BE        : Boolean;          -- Branch trace enable (Optional)
      FE1       : Bits_1;           -- Floating-point exception mode 1
      Reserved3 : Bits_1  := 0;
      IP        : Bits_1;           -- Interrupt prefix
      IR        : Boolean;          -- Instruction address translation
      DR        : Boolean;          -- Data address translation
      Reserved4 : Bits_2  := 0;
      RI        : Boolean;          -- Recoverable interrupt
      LE        : Boolean;          -- Little-endian mode enable
   end record
      with Bit_Order => High_Order_First,
           Size      => 64;
   for MSR_Type use record
      SF        at 0 range  0 ..  0;
      Reserved1 at 0 range  1 .. 44;
      POW       at 0 range 45 .. 45;
      Reserved2 at 0 range 46 .. 46;
      ILE       at 0 range 47 .. 47;
      EE        at 0 range 48 .. 48;
      PR        at 0 range 49 .. 49;
      FP        at 0 range 50 .. 50;
      ME        at 0 range 51 .. 51;
      FE0       at 0 range 52 .. 52;
      SE        at 0 range 53 .. 53;
      BE        at 0 range 54 .. 54;
      FE1       at 0 range 55 .. 55;
      Reserved3 at 0 range 56 .. 56;
      IP        at 0 range 57 .. 57;
      IR        at 0 range 58 .. 58;
      DR        at 0 range 59 .. 59;
      Reserved4 at 0 range 60 .. 61;
      RI        at 0 range 62 .. 62;
      LE        at 0 range 63 .. 63;
   end record;

end PowerPC_Definitions;

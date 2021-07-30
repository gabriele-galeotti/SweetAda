-----------------------------------------------------------------------------------------------------------------------
--                                                     SweetAda                                                      --
-----------------------------------------------------------------------------------------------------------------------
-- __HDS__                                                                                                           --
-- __FLN__ sparc.ads                                                                                                 --
-- __DSC__                                                                                                           --
-- __HSH__ e69de29bb2d1d6434b8b29ae775ad8c2e48c5391                                                                  --
-- __HDE__                                                                                                           --
-----------------------------------------------------------------------------------------------------------------------
-- Copyright (C) 2020, 2021 Gabriele Galeotti                                                                        --
--                                                                                                                   --
-- SweetAda web page: http://sweetada.org                                                                            --
-- contact address: gabriele.galeotti@sweetada.org                                                                   --
-- This work is licensed under the terms of the MIT License.                                                         --
-- Please consult the LICENSE.txt file located in the top-level directory.                                           --
-----------------------------------------------------------------------------------------------------------------------

with System;
with Bits;

package SPARC is

   --========================================================================--
   --                                                                        --
   --                                                                        --
   --                               Public part                              --
   --                                                                        --
   --                                                                        --
   --========================================================================--

   pragma Preelaborate;

   ----------------------------------------------------------------------------
   -- Generic definitions
   ----------------------------------------------------------------------------

   -- BREAKPOINT_Instruction : constant := 16#7FE0_0008#;
   -- 0x30800000 is Branch Always with annul, 22-displacement address (4x, sign-extended)
   BRANCH_ALWAYS_Instruction : constant := 16#3080_0000#;

   procedure NOP;
   -- procedure BREAKPOINT;

   ----------------------------------------------------------------------------
   -- SPARC registers
   ----------------------------------------------------------------------------

   subtype Register_Number_Type is Natural range 0 .. 31;

   Register_Size : constant array (0 .. 31) of Positive :=
      (
       0  => 4,
       1  => 4,
       2  => 4,
       3  => 4,
       4  => 4,
       5  => 4,
       6  => 4,
       7  => 4,
       8  => 4,
       9  => 4,
       10 => 4,
       11 => 4,
       12 => 4,
       13 => 4,
       14 => 4,
       15 => 4,
       16 => 4,
       17 => 4,
       18 => 4,
       19 => 4,
       20 => 4,
       21 => 4,
       22 => 4,
       23 => 4,
       24 => 4,
       25 => 4,
       26 => 4,
       27 => 4,
       28 => 4,
       29 => 4,
       30 => 4,
       31 => 4
      );

   Maximum_Register_Size : constant := 4;

   ----------------------------------------------------------------------------
   -- Traps
   ----------------------------------------------------------------------------

   type TrapTable_Item_Type is
   record
      Code : Bits.U32_Array (0 .. 3);
   end record with
      Alignment => 16,
      Size      => 4 * 32;
   for TrapTable_Item_Type use
   record
      Code at 0 range 0 .. 127;
   end record;

   ----------------------------------------------------------------------------
   --
   ----------------------------------------------------------------------------

   procedure TBR_Set (TBR_Address : in System.Address);

   ----------------------------------------------------------------------------
   -- Irq handling
   ----------------------------------------------------------------------------

   subtype Irq_State_Type is Natural;

   procedure Irq_Enable;
   procedure Irq_Disable;
   function Irq_State_Get return Irq_State_Type;
   procedure Irq_State_Set (Irq_State : in Irq_State_Type);

private

   --========================================================================--
   --                                                                        --
   --                                                                        --
   --                              Private part                              --
   --                                                                        --
   --                                                                        --
   --========================================================================--

   pragma Inline (NOP);

   pragma Inline (TBR_Set);

end SPARC;

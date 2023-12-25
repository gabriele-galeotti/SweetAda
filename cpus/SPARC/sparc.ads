-----------------------------------------------------------------------------------------------------------------------
--                                                     SweetAda                                                      --
-----------------------------------------------------------------------------------------------------------------------
-- __HDS__                                                                                                           --
-- __FLN__ sparc.ads                                                                                                 --
-- __DSC__                                                                                                           --
-- __HSH__ e69de29bb2d1d6434b8b29ae775ad8c2e48c5391                                                                  --
-- __HDE__                                                                                                           --
-----------------------------------------------------------------------------------------------------------------------
-- Copyright (C) 2020-2023 Gabriele Galeotti                                                                         --
--                                                                                                                   --
-- SweetAda web page: http://sweetada.org                                                                            --
-- contact address: gabriele.galeotti@sweetada.org                                                                   --
-- This work is licensed under the terms of the MIT License.                                                         --
-- Please consult the LICENSE.txt file located in the top-level directory.                                           --
-----------------------------------------------------------------------------------------------------------------------

with System;
with Bits;

package SPARC
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
   use Bits;

   ----------------------------------------------------------------------------
   -- Generic definitions
   ----------------------------------------------------------------------------

   Opcode_NOP           : constant := 16#0100_0000#;
   -- Opcode_BREAKPOINT    : constant := 16#7FE0_0008#;
   -- 0x30800000 is Branch Always with annul, 22-displacement address (4x, sign-extended)
   Opcode_BRANCH_ALWAYS : constant := 16#3080_0000#;

   PSR_PIL : constant := 16#0000_0F00#;

   procedure NOP
      with Inline => True;
   procedure Asm_Call
      (Target_Address : in Address)
      with Inline => True;

   ----------------------------------------------------------------------------
   -- PSR
   ----------------------------------------------------------------------------

   type icc_Type is record
      N : Boolean; -- negative
      Z : Boolean; -- zero
      V : Boolean; -- overflow
      C : Boolean; -- carry
   end record
      with Size => 4,
           Pack => True;

   type PSR_Type is record
      CWP      : Natural range 0 .. 31; -- current_window_pointer
      ET       : Boolean;               -- enable_traps
      PS       : Boolean;               -- previous_supervisor
      S        : Boolean;               -- supervisor
      PIL      : Natural range 0 .. 15; -- proc_interrupt_level
      EF       : Boolean;               -- enable_floating-point
      EC       : Boolean;               -- enable_coprocessor
      Reserved : Bits_6 := 0;
      icc      : icc_Type;              -- integer_cond_codes
      ver      : Bits_4;                -- version
      impl     : Bits_4;                -- implementation
   end record
      with Bit_Order => Low_Order_First,
           Size      => 32;
   for PSR_Type use record
      CWP      at 0 range  0 ..  4;
      ET       at 0 range  5 ..  5;
      PS       at 0 range  6 ..  6;
      S        at 0 range  7 ..  7;
      PIL      at 0 range  8 .. 11;
      EF       at 0 range 12 .. 12;
      EC       at 0 range 13 .. 13;
      Reserved at 0 range 14 .. 19;
      icc      at 0 range 20 .. 23;
      ver      at 0 range 24 .. 27;
      impl     at 0 range 28 .. 31;
   end record;

   function PSR_Read
      return PSR_Type
      with Inline => True;
   procedure PSR_Write
      (PSR : in PSR_Type)
      with Inline => True;

   ----------------------------------------------------------------------------
   -- SPARC registers
   ----------------------------------------------------------------------------

   subtype Register_Number_Type is Natural range 0 .. 31;

   Register_Size : constant array (0 .. 31) of Positive :=
      [ 0 => 4,  1 => 4,  2 => 4,  3 => 4,  4 => 4,  5 => 4,  6 => 4,  7 => 4,
        8 => 4,  9 => 4, 10 => 4, 11 => 4, 12 => 4, 13 => 4, 14 => 4, 15 => 4,
       16 => 4, 17 => 4, 18 => 4, 19 => 4, 20 => 4, 21 => 4, 22 => 4, 23 => 4,
       24 => 4, 25 => 4, 26 => 4, 27 => 4, 28 => 4, 29 => 4, 30 => 4, 31 => 4];

   Maximum_Register_Size : constant := 4;

   ----------------------------------------------------------------------------
   -- Traps
   ----------------------------------------------------------------------------

   type TrapTable_Item_Type is record
      Code : U32_Array (0 .. 3);
   end record
      with Alignment => 16,
           Size      => 4 * 32;
   for TrapTable_Item_Type use record
      Code at 0 range 0 .. 127;
   end record;

   procedure TBR_Set
      (TBR_Address : in Address)
      with Inline => True;
   procedure Traps_Enable
      (Enable : in Boolean)
      with Inline => True;

   ----------------------------------------------------------------------------
   -- Exceptions and interrupts
   ----------------------------------------------------------------------------

   subtype Irq_State_Type is Natural;

   procedure Irq_Enable;
   procedure Irq_Disable;
   function Irq_State_Get
      return Irq_State_Type;
   procedure Irq_State_Set
      (Irq_State : in Irq_State_Type);

end SPARC;

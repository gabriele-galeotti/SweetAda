-----------------------------------------------------------------------------------------------------------------------
--                                                     SweetAda                                                      --
-----------------------------------------------------------------------------------------------------------------------
-- __HDS__                                                                                                           --
-- __FLN__ mips-r3000.ads                                                                                            --
-- __DSC__                                                                                                           --
-- __HSH__ e69de29bb2d1d6434b8b29ae775ad8c2e48c5391                                                                  --
-- __HDE__                                                                                                           --
-----------------------------------------------------------------------------------------------------------------------
-- Copyright (C) 2020, 2021, 2022 Gabriele Galeotti                                                                  --
--                                                                                                                   --
-- SweetAda web page: http://sweetada.org                                                                            --
-- contact address: gabriele.galeotti@sweetada.org                                                                   --
-- This work is licensed under the terms of the MIT License.                                                         --
-- Please consult the LICENSE.txt file located in the top-level directory.                                           --
-----------------------------------------------------------------------------------------------------------------------

with System;
with Interfaces;
with Bits;

package R3000 is

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

   ----------------------------------------------------------------------------
   -- Status Register (CP0 register 12)
   ----------------------------------------------------------------------------

   type Status_Register_Type is
   record
      IEc     : Boolean;
      KUc     : Boolean;
      IEp     : Boolean;
      KUp     : Boolean;
      IEo     : Boolean;
      KUo     : Boolean;
      Unused1 : Bits_2_Zeroes := Bits_2_0;
      IM      : Unsigned_8;
      IsC     : Boolean;
      SwC     : Boolean;
      PZ      : Boolean;
      CM      : Boolean;
      PE      : Boolean;
      TS      : Boolean;
      BEV     : Boolean;
      Unused2 : Bits_2_Zeroes := Bits_2_0;
      RE      : Boolean;
      Unused3 : Bits_2_Zeroes := Bits_2_0;
      CU0     : Boolean;
      CU1     : Boolean;
      Unused4 : Bits_2_Zeroes := Bits_2_0;
   end record with
      Bit_Order => Low_Order_First,
      Size      => 32;
   for Status_Register_Type use
   record
      IEc     at 0 range 0 .. 0;
      KUc     at 0 range 1 .. 1;
      IEp     at 0 range 2 .. 2;
      KUp     at 0 range 3 .. 3;
      IEo     at 0 range 4 .. 4;
      KUo     at 0 range 5 .. 5;
      Unused1 at 0 range 6 .. 7;
      IM      at 0 range 8 .. 15;
      IsC     at 0 range 16 .. 16;
      SwC     at 0 range 17 .. 17;
      PZ      at 0 range 18 .. 18;
      CM      at 0 range 19 .. 19;
      PE      at 0 range 20 .. 20;
      TS      at 0 range 21 .. 21;
      BEV     at 0 range 22 .. 22;
      Unused2 at 0 range 23 .. 24;
      RE      at 0 range 25 .. 25;
      Unused3 at 0 range 26 .. 27;
      CU0     at 0 range 28 .. 28;
      CU1     at 0 range 29 .. 29;
      Unused4 at 0 range 30 .. 31;
   end record;

   function CP0_SR_Read return Status_Register_Type with
      Inline => True;
   procedure CP0_SR_Write (Value : in Status_Register_Type) with
      Inline => True;

   ----------------------------------------------------------------------------
   -- PRId register (CP0 register 15)
   ----------------------------------------------------------------------------

   type PRId_Register_Type is
   record
      Rev    : Unsigned_8;
      Imp    : Unsigned_8;
      Unused : Bits_16_Zeroes := Bits_16_0;
   end record with
      Bit_Order => Low_Order_First,
      Size      => 32;
   for PRId_Register_Type use
   record
      Rev    at 0 range 0 .. 7;
      Imp    at 0 range 8 .. 15;
      Unused at 0 range 16 .. 31;
   end record;

   function CP0_PRId_Read return PRId_Register_Type with
      Inline => True;

   ----------------------------------------------------------------------------
   -- Interrupts
   ----------------------------------------------------------------------------

   type Irq_State_Type is new Natural;
   type Irq_Id_Type is new Natural;

   procedure Irq_Enable with
      Inline => True;
   procedure Irq_Disable with
      Inline => True;
   function Irq_State_Get return Irq_State_Type with
      Inline => True;
   procedure Irq_State_Set (Irq_State : in Irq_State_Type) with
      Inline => True;

end R3000;

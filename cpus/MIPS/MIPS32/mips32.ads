-----------------------------------------------------------------------------------------------------------------------
--                                                     SweetAda                                                      --
-----------------------------------------------------------------------------------------------------------------------
-- __HDS__                                                                                                           --
-- __FLN__ mips32.ads                                                                                                --
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
with MIPS;

package MIPS32 is

   --========================================================================--
   --                                                                        --
   --                                                                        --
   --                               Public part                              --
   --                                                                        --
   --                                                                        --
   --========================================================================--

   pragma Preelaborate;

   use System;
   use Interfaces;
   use Bits;
   use MIPS;

   ----------------------------------------------------------------------------
   -- Count register (CP0 register 9, Select 0) (157)
   ----------------------------------------------------------------------------

   function CP0_Count_Read return Unsigned_32 with
      Inline => True;
   procedure CP0_Count_Write (Value : in Unsigned_32) with
      Inline => True;

   ----------------------------------------------------------------------------
   -- Compare register (CP0 register 11, Select 0) (158)
   ----------------------------------------------------------------------------

   function CP0_Compare_Read return Unsigned_32 with
      Inline => True;
   procedure CP0_Compare_Write (Value : in Unsigned_32) with
      Inline => True;

   ----------------------------------------------------------------------------
   -- Status Register (CP0 register 12, Select 0) (158)
   ----------------------------------------------------------------------------

   type Status_Register_Type is
   record
      IE      : Boolean;
      EXL     : Boolean;
      ERL     : Boolean;
      KSU     : Bits_2;
      UX      : Boolean;
      SX      : Boolean;
      KX      : Boolean;
      Unused1 : Bits_8 := 0;
      Unused2 : Bits_8 := 0;
      Unused3 : Bits_4 := 0;
      CU0     : Boolean;
      CU1     : Boolean;
      CU2     : Boolean;
      CU3     : Boolean;
   end record with
      Bit_Order => Low_Order_First,
      Size      => 32;
   for Status_Register_Type use
   record
      IE      at 0 range 0 .. 0;
      EXL     at 0 range 1 .. 1;
      ERL     at 0 range 2 .. 2;
      KSU     at 0 range 3 .. 4;
      UX      at 0 range 5 .. 5;
      SX      at 0 range 6 .. 6;
      KX      at 0 range 7 .. 7;
      Unused1 at 0 range 8 .. 15;
      Unused2 at 0 range 16 .. 23;
      Unused3 at 0 range 24 .. 27;
      CU0     at 0 range 28 .. 28;
      CU1     at 0 range 29 .. 29;
      CU2     at 0 range 30 .. 30;
      CU3     at 0 range 31 .. 31;
   end record;

   function CP0_SR_Read return Status_Register_Type with
      Inline => True;
   procedure CP0_SR_Write (Value : in Status_Register_Type) with
      Inline => True;

   ----------------------------------------------------------------------------
   -- Cause register (CP0 register 13, Select 0) (168)
   ----------------------------------------------------------------------------

   type Cause_Type is
   record
      Reserved1 : Bits_2;
      ExcCode   : Bits_5;  -- Exception Code
      Reserved2 : Bits_1;
      IP        : Bits_8;  -- Interrupt Pending
      Reserved3 : Bits_12;
      CE        : Bits_2;  -- Coprocessor Error
      Reserved4 : Bits_1;
      BD        : Boolean; -- Branch Delay
   end record with
      Bit_Order => Low_Order_First,
      Size      => 32;
   for Cause_Type use
   record
      Reserved1 at 0 range 0 .. 1;
      ExcCode   at 0 range 2 .. 6;
      Reserved2 at 0 range 7 .. 7;
      IP        at 0 range 8 .. 15;
      Reserved3 at 0 range 16 .. 27;
      CE        at 0 range 28 .. 29;
      Reserved4 at 0 range 30 .. 30;
      BD        at 0 range 31 .. 31;
   end record;

   function CP0_Cause_Read return Unsigned_32 with
      Inline => True;
   procedure CP0_Cause_Write (Value : in Unsigned_32) with
      Inline => True;

   ----------------------------------------------------------------------------
   -- Exception Program Counter register (CP0 register 14, Select 0) (172)
   ----------------------------------------------------------------------------

   function CP0_EPC_Read return Unsigned_32 with
      Inline => True;
   procedure CP0_EPC_Write (Value : in Unsigned_32) with
      Inline => True;

   ----------------------------------------------------------------------------
   -- PRId register (CP0 register 15, Select 0)
   ----------------------------------------------------------------------------

   type PRId_Register_Type is
   record
      Revision        : Unsigned_8; -- Rev
      CPU_ID          : Unsigned_8; -- Imp
      Company_ID      : Unsigned_8;
      Company_Options : Unsigned_8;
   end record with
      Bit_Order => Low_Order_First,
      Size      => 32;
   for PRId_Register_Type use
   record
      Revision        at 0 range 0 .. 7;
      CPU_ID          at 0 range 8 .. 15;
      Company_ID      at 0 range 16 .. 23;
      Company_Options at 0 range 24 .. 31;
   end record;

   function CP0_PRId_Read return PRId_Register_Type with
      Inline => True;

   ----------------------------------------------------------------------------
   -- Config register (CP0 register 16, Select 0) (174)
   ----------------------------------------------------------------------------

   function CP0_Config_Read return Unsigned_32 with
      Inline => True;
   procedure CP0_Config_Write (Value : in Unsigned_32) with
      Inline => True;

   ----------------------------------------------------------------------------
   -- Config1 register (CP0 register 16, Select 1) (176)
   ----------------------------------------------------------------------------

   function CP0_Config1_Read return Unsigned_32 with
      Inline => True;
   procedure CP0_Config1_Write (Value : in Unsigned_32) with
      Inline => True;

   ----------------------------------------------------------------------------
   -- Debug register (CP0 register 23, Select 0) (185)
   ----------------------------------------------------------------------------

   function CP0_Debug_Read return Unsigned_32 with
      Inline => True;
   procedure CP0_Debug_Write (Value : in Unsigned_32) with
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

   ----------------------------------------------------------------------------
   -- Locking
   ----------------------------------------------------------------------------

   procedure Lock_Try (Lock_Object : in out Lock_Type; Success : out Boolean) with
      Inline => True;
   procedure Lock (Lock_Object : in out Lock_Type) with
      Inline => True;
   procedure Unlock (Lock_Object : out Lock_Type) with
      Inline => True;

end MIPS32;

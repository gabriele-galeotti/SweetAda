-----------------------------------------------------------------------------------------------------------------------
--                                                     SweetAda                                                      --
-----------------------------------------------------------------------------------------------------------------------
-- __HDS__                                                                                                           --
-- __FLN__ aarch64.ads                                                                                               --
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
with System.Storage_Elements;
with Interfaces;
with Bits;

package AArch64 is

   --========================================================================--
   --                                                                        --
   --                                                                        --
   --                               Public part                              --
   --                                                                        --
   --                                                                        --
   --========================================================================--

   pragma Preelaborate;

   use System;
   use System.Storage_Elements;
   use Interfaces;
   use Bits;

   ----------------------------------------------------------------------------
   -- CPU helper subprograms
   ----------------------------------------------------------------------------

   procedure NOP with
      Inline => True;
   procedure Asm_Call (Target_Address : in Address) with
      Inline => True;

   ----------------------------------------------------------------------------
   -- VBAR_EL1
   ----------------------------------------------------------------------------

   function VBAR_EL1_Read return Unsigned_64 with
      Inline => True;
   procedure VBAR_EL1_Write (Value : in Unsigned_64) with
      Inline => True;

   ----------------------------------------------------------------------------
   -- CNTP_CTL_EL0
   ----------------------------------------------------------------------------

   type CNTP_CTL_EL0_Type is
   record
      ENABLE    : Boolean;      -- Enables the timer.
      IMASK     : Boolean;      -- Timer interrupt mask bit.
      ISTATUS   : Boolean;      -- The status of the timer.
      Reserved1 : Bits_29 := 0;
      Reserved2 : Bits_32 := 0;
   end record with
      Bit_Order => Low_Order_First,
      Size      => 64;
   for CNTP_CTL_EL0_Type use record
      ENABLE    at 0 range 0 .. 0;
      IMASK     at 0 range 1 .. 1;
      ISTATUS   at 0 range 2 .. 2;
      Reserved1 at 0 range 3 .. 31;
      Reserved2 at 0 range 32 .. 63;
   end record;

   function CNTP_CTL_EL0_Read return CNTP_CTL_EL0_Type with
      Inline => True;
   procedure CNTP_CTL_EL0_Write (Value : in CNTP_CTL_EL0_Type) with
      Inline => True;

   ----------------------------------------------------------------------------
   -- CNTP_CVAL_EL0
   ----------------------------------------------------------------------------

   -- Holds the EL1 physical timer CompareValue.

   function CNTP_CVAL_EL0_Read return Unsigned_64 with
      Inline => True;
   procedure CNTP_CVAL_EL0_Write (Value : in Unsigned_64) with
      Inline => True;

   ----------------------------------------------------------------------------
   -- CNTP_TVAL_EL0
   ----------------------------------------------------------------------------

   type CNTP_TVAL_EL0_Type is
   record
      TimerValue : Unsigned_32;  -- The TimerValue view of the EL1 physical timer.
      Reserved   : Bits_32 := 0;
   end record with
      Bit_Order => Low_Order_First,
      Size      => 64;
   for CNTP_TVAL_EL0_Type use record
      TimerValue at 0 range 0 .. 31;
      Reserved   at 0 range 32 .. 63;
   end record;

   function CNTP_TVAL_EL0_Read return CNTP_TVAL_EL0_Type with
      Inline => True;
   procedure CNTP_TVAL_EL0_Write (Value : in CNTP_TVAL_EL0_Type) with
      Inline => True;

   ----------------------------------------------------------------------------
   -- CNTFRQ_EL0
   ----------------------------------------------------------------------------

   type CNTFRQ_EL0_Type is
   record
      Clock_frequency : Unsigned_32;  -- Clock_Frequency.
      Reserved        : Bits_32 := 0;
   end record with
      Bit_Order => Low_Order_First,
      Size      => 64;
   for CNTFRQ_EL0_Type use record
      Clock_frequency at 0 range 0 .. 31;
      Reserved        at 0 range 32 .. 63;
   end record;

   function CNTFRQ_EL0_Read return CNTFRQ_EL0_Type with
      Inline => True;

   ----------------------------------------------------------------------------
   -- GIC registers __FIX__ not properly encoded
   ----------------------------------------------------------------------------

   GIC_BASEADDRESS : constant := 16#0800_0000#;

   GICD_CTLR      : aliased Unsigned_32 with
      Address              => To_Address (GIC_BASEADDRESS),
      Volatile_Full_Access => True,
      Import               => True,
      Convention           => Ada;
   GICD_ISENABLER : aliased Unsigned_32 with
      Address              => To_Address (GIC_BASEADDRESS + 16#0000_0100#),
      Volatile_Full_Access => True,
      Import               => True,
      Convention           => Ada;
   GICD_ICPENDR   : aliased Unsigned_32 with
      Address              => To_Address (GIC_BASEADDRESS + 16#0000_0280#),
      Volatile_Full_Access => True,
      Import               => True,
      Convention           => Ada;

   GICC_CTLR      : aliased Unsigned_32 with
      Address              => To_Address (GIC_BASEADDRESS + 16#0001_0000#),
      Volatile_Full_Access => True,
      Import               => True,
      Convention           => Ada;
   GICC_PMR       : aliased Unsigned_32 with
      Address              => To_Address (GIC_BASEADDRESS + 16#0001_0004#),
      Volatile_Full_Access => True,
      Import               => True,
      Convention           => Ada;

   ----------------------------------------------------------------------------
   -- Exceptions and interrupts
   ----------------------------------------------------------------------------

   procedure Irq_Enable with
      Inline => True;
   procedure Irq_Disable with
      Inline => True;

end AArch64;

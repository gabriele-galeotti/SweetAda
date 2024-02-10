-----------------------------------------------------------------------------------------------------------------------
--                                                     SweetAda                                                      --
-----------------------------------------------------------------------------------------------------------------------
-- __HDS__                                                                                                           --
-- __FLN__ openrisc.ads                                                                                              --
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
with System.Storage_Elements;
with Ada.Unchecked_Conversion;
with Interfaces;
with Bits;

package OpenRISC
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
   use System.Storage_Elements;
   use Interfaces;
   use Bits;

   ----------------------------------------------------------------------------
   -- SPRs
   ----------------------------------------------------------------------------

   type SPR_Type is mod 2**16;

   VR_REGNO   : constant SPR_Type := 0  * 2**11 + 0;
   SR_REGNO   : constant SPR_Type := 0  * 2**11 + 17;
   TTMR_REGNO : constant SPR_Type := 10 * 2**11 + 0;
   TTCR_REGNO : constant SPR_Type := 10 * 2**11 + 1;

   ----------------------------------------------------------------------------
   -- Chapter 4 Registers
   ----------------------------------------------------------------------------

   -- 4.6 Supervision Register (SR)

   type SR_Type is record
      SM       : Boolean;         -- Supervisor Mode
      TEE      : Boolean;         -- Tick Timer Exception Enabled
      IEE      : Boolean;         -- Interrupt Exception Enabled
      DCE      : Boolean;         -- Data Cache Enable
      ICE      : Boolean;         -- Instruction Cache Enable
      DME      : Boolean;         -- Data MMU Enable
      IME      : Boolean;         -- Instruction MMU Enable
      LEE      : Boolean;         -- Little Endian Enable
      CE       : Boolean;         -- CID Enable
      F        : Boolean;         -- Flag
      CY       : Boolean;         -- Carry flag
      OV       : Boolean;         -- Overflow flag
      OVE      : Boolean;         -- Overflow flag Exception
      DSX      : Boolean;         -- Delay Slot Exception
      EPH      : Boolean;         -- Exception Prefix High
      FO       : Boolean := True; -- Fixed One
      SUMRA    : Boolean;         -- SPRs User Mode Read Access
      Reserved : Bits_11 := 0;
      CID      : Bits_4;          -- Context ID
   end record
      with Bit_Order => Low_Order_First,
           Size      => 32;
   for SR_Type use record
      SM       at 0 range  0 ..  0;
      TEE      at 0 range  1 ..  1;
      IEE      at 0 range  2 ..  2;
      DCE      at 0 range  3 ..  3;
      ICE      at 0 range  4 ..  4;
      DME      at 0 range  5 ..  5;
      IME      at 0 range  6 ..  6;
      LEE      at 0 range  7 ..  7;
      CE       at 0 range  8 ..  8;
      F        at 0 range  9 ..  9;
      CY       at 0 range 10 .. 10;
      OV       at 0 range 11 .. 11;
      OVE      at 0 range 12 .. 12;
      DSX      at 0 range 13 .. 13;
      EPH      at 0 range 14 .. 14;
      FO       at 0 range 15 .. 15;
      SUMRA    at 0 range 16 .. 16;
      Reserved at 0 range 17 .. 27;
      CID      at 0 range 28 .. 31;
   end record;

   function SR_Read
      return SR_Type
      with Inline => True;
   procedure SR_Write
      (Value : in SR_Type)
      with Inline => True;

   function To_U32 is new Ada.Unchecked_Conversion (SR_Type, Unsigned_32);
   function To_SR is new Ada.Unchecked_Conversion (Unsigned_32, SR_Type);

   -- 15.4 Tick Timer Mode Register (TTMR)

   M_DISABLED : constant := 2#00#; -- Tick timer is disabled
   M_RESTART  : constant := 2#01#; -- Timer is restarted when TTMR[TP] matches TTCR[27:0]
   M_STOP     : constant := 2#10#; -- Timer stops when TTMR[TP] matches TTCR[27:0] (change TTCR to resume counting)
   M_NONSTOP  : constant := 2#11#; -- Timer does not stop when TTMR[TP] matches TTCR[27:0]

   type TTMR_Type is record
      TP : Bits_28; -- Time Period
      IP : Boolean; -- Interrupt Pending
      IE : Boolean; -- Interrupt Enable
      M  : Bits_2;  -- Mode
   end record
      with Bit_Order => Low_Order_First,
           Size      => 32;
   for TTMR_Type use record
      TP at 0 range  0 .. 27;
      IP at 0 range 28 .. 28;
      IE at 0 range 29 .. 29;
      M  at 0 range 30 .. 31;
   end record;

   function TTMR_Read
      return TTMR_Type
      with Inline => True;
   procedure TTMR_Write
      (Value : in TTMR_Type)
      with Inline => True;

   -- 15.5 Tick Timer Count Register (TTCR)

   function TTCR_Read
      return Unsigned_32
      with Inline => True;
   procedure TTCR_Write
      (Value : in Unsigned_32)
      with Inline => True;

   -- 16.2 Version Register (VR)

   type VR_Type is record
      REV      : Bits_6;  -- Revision
      UVRP     : Boolean; -- Updated Version Registers Present
      Reserved : Bits_9;
      CFG      : Bits_8;  -- Configuration Template
      VER      : Bits_8;  -- Version
   end record
      with Bit_Order => Low_Order_First,
           Size      => 32;
   for VR_Type use record
      REV      at 0 range  0 ..  5;
      UVRP     at 0 range  6 ..  6;
      Reserved at 0 range  7 .. 15;
      CFG      at 0 range 16 .. 23;
      VER      at 0 range 24 .. 31;
   end record;

   function VR_Read
      return VR_Type
      with Inline => True;

   function To_U32 is new Ada.Unchecked_Conversion (VR_Type, Unsigned_32);

   ----------------------------------------------------------------------------
   -- CPU helper subprograms
   ----------------------------------------------------------------------------

   procedure NOP
      with Inline => True;

   procedure TEE_Enable
      (Enable : in Boolean)
      with Inline => True;

   ----------------------------------------------------------------------------
   -- Exceptions and interrupts
   ----------------------------------------------------------------------------

   subtype Intcontext_Type is Integer;

   procedure Intcontext_Get
      (Intcontext : out Intcontext_Type)
      with Inline => True;
   procedure Intcontext_Set
      (Intcontext : in Intcontext_Type)
      with Inline => True;

   procedure Irq_Enable
      with Inline => True;
   procedure Irq_Disable
      with Inline => True;

end OpenRISC;

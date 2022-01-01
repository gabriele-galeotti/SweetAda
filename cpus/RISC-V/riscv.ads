-----------------------------------------------------------------------------------------------------------------------
--                                                     SweetAda                                                      --
-----------------------------------------------------------------------------------------------------------------------
-- __HDS__                                                                                                           --
-- __FLN__ riscv.ads                                                                                                 --
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
with System.Storage_Elements;
with Interfaces;
with Bits;

package RISCV is

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

   -- Machine Status (mstatus)

   type MSTATUS_Type is
   record
      UIE       : Boolean;     -- User Interrupt Enable
      SIE       : Boolean;     -- Supervisor Interrupt Enable
      Reserved1 : Bits.Bits_1;
      MIE       : Boolean;     -- Machine Interrupt Enable
      UPIE      : Boolean;     -- User Previous Interrupt Enable
      SPIE      : Boolean;     -- Supervisor Previous Interrupt Enable
      Reserved2 : Bits.Bits_1;
      MPIE      : Boolean;     -- Machine Previous Interrupt Enabler
      SPP       : Boolean;     -- Supervisor Previous Privilege
      Reserved3 : Bits.Bits_2;
      MPP       : Bits.Bits_2; -- Machine Previous Privilege
      FS        : Bits.Bits_2; -- Floating Point State
      XS        : Bits.Bits_2; -- User Mode Extension State
      MPRIV     : Boolean;     -- Modify Privilege (access memory as MPP)
      SUM       : Boolean;     -- Permit Supervisor User Memory Access
      MXR       : Boolean;     -- Make Executable Readable
      TVM       : Boolean;     -- Trap Virtual memory
      TW        : Boolean;     -- Timeout Wait (traps S-Mode wfi)
      TSR       : Boolean;     -- Trap SRET
      Reserved4 : Bits.Bits_8;
      SD        : Boolean;     -- State Dirty (FS and XS summary bit)
   end record with
      Bit_Order => Low_Order_First,
      Size      => 32;
   for MSTATUS_Type use
   record
      UIE       at 0 range 0 .. 0;
      SIE       at 0 range 1 .. 1;
      Reserved1 at 0 range 2 .. 2;
      MIE       at 0 range 3 .. 3;
      UPIE      at 0 range 4 .. 4;
      SPIE      at 0 range 5 .. 5;
      Reserved2 at 0 range 6 .. 6;
      MPIE      at 0 range 7 .. 7;
      SPP       at 0 range 8 .. 8;
      Reserved3 at 0 range 9 .. 10;
      MPP       at 0 range 11 .. 12;
      FS        at 0 range 13 .. 14;
      XS        at 0 range 15 .. 16;
      MPRIV     at 0 range 17 .. 17;
      SUM       at 0 range 18 .. 18;
      MXR       at 0 range 19 .. 19;
      TVM       at 0 range 20 .. 20;
      TW        at 0 range 21 .. 21;
      TSR       at 0 range 22 .. 22;
      Reserved4 at 0 range 23 .. 30;
      SD        at 0 range 31 .. 31;
   end record;

   -- Machine Trap Vector CSR (mtvec)

   type MTVEC_Type is
   record
      MODE     : Bits.Bits_2;
      Reserved : Bits.Bits_4;
      BASE     : Bits.Bits_26;
   end record with
      Bit_Order => Low_Order_First,
      Size      => 32;
   for MTVEC_Type use
   record
      MODE     at 0 range 0 .. 1;
      Reserved at 0 range 2 .. 5;
      BASE     at 0 range 6 .. 31;
   end record;

   MODE_Direct   : constant := 2#00#;
   MODE_Vectored : constant := 2#01#;

   procedure MTVEC_Write (Mtvec : in MTVEC_Type) with
      Inline => True;

   -- Timer CSRs

   MTimeCmp : Unsigned_64 with
      Address    => To_Address (16#0200_4000#),
      Volatile   => True,
      Import     => True,
      Convention => Ada;

   MTime : Unsigned_64 with
      Address    => To_Address (16#0200_BFF8#),
      Volatile   => True,
      Import     => True,
      Convention => Ada;

   ----------------------------------------------------------------------------
   -- CPU helper subprograms
   ----------------------------------------------------------------------------

   procedure NOP with
      Inline => True;
   function MCAUSE_Read return Unsigned_32 with
      Inline => True;
   function MEPC_Read return Unsigned_32 with
      Inline => True;
   procedure Asm_Call (Target_Address : in Address) with
      Inline => True;

   ----------------------------------------------------------------------------
   -- Exceptions and interrupts
   ----------------------------------------------------------------------------

   subtype Irq_State_Type is Integer;

   procedure Irq_Enable with
      Inline => True;
   procedure Irq_Disable with
      Inline => True;
   function Irq_State_Get return Irq_State_Type with
      Inline => True;
   procedure Irq_State_Set (Irq_State : in Irq_State_Type) with
      Inline => True;

end RISCV;

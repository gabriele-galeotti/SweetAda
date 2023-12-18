-----------------------------------------------------------------------------------------------------------------------
--                                                     SweetAda                                                      --
-----------------------------------------------------------------------------------------------------------------------
-- __HDS__                                                                                                           --
-- __FLN__ apic.ads                                                                                                  --
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
with System.Storage_Elements;
with Interfaces;
with Bits;

package APIC
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
   -- x86 "local" APIC
   ----------------------------------------------------------------------------

   -- 10.8.3.1 Task and Processor Priorities

   type TPR_Type is record
      SubClass : Natural range 0 .. 15; -- Task-Priority Sub-Class
      Class    : Natural range 0 .. 15; -- Task-Priority Class
      Reserved : Bits_24 := 0;
   end record
      with Bit_Order => Low_Order_First,
           Size      => 32;
   for TPR_Type use record
      SubClass at 0 range 0 ..  3;
      Class    at 0 range 4 ..  7;
      Reserved at 0 range 8 .. 31;
   end record;

   -- 10.9 SPURIOUS INTERRUPT

   type SVR_Type is record
      VECTOR    : Bits_8;       -- Spurious Vector
      ENABLE    : Boolean;      -- APIC Software Enable/Disable
      FPC       : Boolean;      -- Focus Processor Checking
      Reserved1 : Bits_2 := 0;
      EOIBS     : Boolean;      -- EOI-Broadcast Suppression
      Reserved2 : Bits_19 := 0;
   end record
      with Bit_Order => Low_Order_First,
           Size      => 32;
   for SVR_Type use record
      VECTOR    at 0 range  0 ..  7;
      ENABLE    at 0 range  8 ..  8;
      FPC       at 0 range  9 ..  9;
      Reserved1 at 0 range 10 .. 11;
      EOIBS     at 0 range 12 .. 12;
      Reserved2 at 0 range 13 .. 31;
   end record;

   -- 10.5.1 Local Vector Table

   DM_FIXED  : constant := 2#000#; -- Delivers the interrupt specified in the vector field.
   DM_SMI    : constant := 2#010#; -- Delivers an SMI int to the proc core through the proc’s local SMI signal path.
   DM_NMI    : constant := 2#100#; -- Delivers an NMI interrupt to the processor.
   DM_INIT   : constant := 2#101#; -- Delivers an INIT req to the proc core, which causes the proc to perform an INIT.
   DM_ExtINT : constant := 2#111#; -- Causes the proc to respond ... (8259A-compatible) interrupt controller.

   DS_Idle        : constant := 0; -- Idle
   DS_SendPending : constant := 1; -- Send Pending

   IIPP_HIGH : constant := 0; -- active high
   IIPP_LOW  : constant := 1; -- active low

   TM_EDGE  : constant := 0; -- edge sensitive
   TM_LEVEL : constant := 1; -- level sensitive

   type LVT_Type is record
      VECTOR    : Bits_8;       -- Vector
      DM        : Bits_3;       -- Delivery Mode
      Reserved1 : Bits_1 := 0;
      DS        : Bits_1;       -- Delivery Status
      IIPP      : Bits_1;       -- Interrupt Input Pin Polarity
      RIRR      : Boolean;      -- Remote IRR Flag
      TM        : Bits_1;       -- Trigger Mode
      Mask      : Boolean;      -- Mask
      Reserved2 : Bits_15 := 0;
   end record
      with Bit_Order => Low_Order_First,
           Size      => 32;
   for LVT_Type use record
      VECTOR    at 0 range  0 ..  7;
      DM        at 0 range  8 .. 10;
      Reserved1 at 0 range 11 .. 11;
      DS        at 0 range 12 .. 12;
      IIPP      at 0 range 13 .. 13;
      RIRR      at 0 range 14 .. 14;
      TM        at 0 range 15 .. 15;
      Mask      at 0 range 16 .. 16;
      Reserved2 at 0 range 17 .. 31;
   end record;

   -- LAPIC

   type LAPIC_Type is record
      TPR   : TPR_Type with Volatile_Full_Access => True; -- Task Priority Register
      SVR   : SVR_Type with Volatile_Full_Access => True; -- Spurious Interrupt Vector Register
      LINT0 : LVT_Type with Volatile_Full_Access => True; -- LINT0
      LINT1 : LVT_Type with Volatile_Full_Access => True; -- LINT1
   end record;
   for LAPIC_Type use record
      TPR   at 16#080# range 0 .. 31;
      SVR   at 16#0F0# range 0 .. 31;
      LINT0 at 16#350# range 0 .. 31;
      LINT1 at 16#360# range 0 .. 31;
   end record;

   LAPIC_BASEADDRESS : constant := 16#0000_0000_FEE0_0000#;

   LAPIC : aliased LAPIC_Type
      with Address    => To_Address (LAPIC_BASEADDRESS),
           Volatile   => True,
           Import     => True,
           Convention => Ada;

   procedure LAPIC_Init;

   ----------------------------------------------------------------------------
   -- 82093AA I/O ADVANCED PROGRAMMABLE INTERRUPT CONTROLLER (IOAPIC)
   ----------------------------------------------------------------------------
   -- IOAPIC_QEMU_ID: 0
   ----------------------------------------------------------------------------

   IOAPIC_BASEADDRESS : constant := 16#0000_0000_FEC0_0000#;

   IOREGSEL  : constant := 0;
   IOWIN     : constant := 16#10#;
   IOAPICID  : constant := 0;
   IOAPICVER : constant := 1;
   IOAPICARB : constant := 2;
   IOREDTBL  : constant := 1;

   function IOAPIC_Read
      (Register_Number : Natural)
      return Unsigned_32;
   procedure IOAPIC_Write
      (Register_Number : in Natural;
       Value           : in Unsigned_32);

end APIC;

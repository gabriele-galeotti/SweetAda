-----------------------------------------------------------------------------------------------------------------------
--                                                     SweetAda                                                      --
-----------------------------------------------------------------------------------------------------------------------
-- __HDS__                                                                                                           --
-- __FLN__ apic.ads                                                                                                  --
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

package APIC is

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

   LAPIC_BASEADDRESS : constant := 16#FEE0_0000#;

   type LINT0_Type is
   record
      V         : Bits_8;       -- Vector
      DM        : Bits_3;       -- Delivery Mode
      Reserved1 : Bits_1 := 0;
      DS        : Bits_1;       -- Delivery Status
      IIPP      : Bits_1;       -- Interrupt Input Pin Polarity
      RIRR      : Bits_1;       -- Remote IRR Flag
      TM        : Bits_1;       -- Trigger Mode
      Mask      : Boolean;      -- Mask
      Reserved2 : Bits_15 := 0;
   end record with
      Bit_Order => Low_Order_First,
      Size      => 32;
   for LINT0_Type use
   record
      V         at 0 range 0 .. 7;
      DM        at 0 range 8 .. 10;
      Reserved1 at 0 range 11 .. 11;
      DS        at 0 range 12 .. 12;
      IIPP      at 0 range 13 .. 13;
      RIRR      at 0 range 14 .. 14;
      TM        at 0 range 15 .. 15;
      Mask      at 0 range 16 .. 16;
      Reserved2 at 0 range 17 .. 31;
   end record;

   type LAPIC_Type is
   record
      TPR   : Unsigned_32 with Volatile_Full_Access => True; -- Task Priority Register
      SVR   : Unsigned_32 with Volatile_Full_Access => True; -- Spurious Interrupt Vector Register
      LINT0 : LINT0_Type  with Volatile_Full_Access => True;
      LINT1 : Unsigned_32 with Volatile_Full_Access => True;
   end record;
   for LAPIC_Type use
   record
      TPR   at 16#080# range 0 .. 31;
      SVR   at 16#0F0# range 0 .. 31;
      LINT0 at 16#350# range 0 .. 31;
      LINT1 at 16#360# range 0 .. 31;
   end record;

   LAPIC : aliased LAPIC_Type with
      Address    => To_Address (LAPIC_BASEADDRESS),
      Volatile   => True,
      Import     => True,
      Convention => Ada;

   procedure LAPIC_Init;

   ----------------------------------------------------------------------------
   -- 82093AA I/O ADVANCED PROGRAMMABLE INTERRUPT CONTROLLER (IOAPIC)
   ----------------------------------------------------------------------------
   -- IOAPIC_QEMU_ID: 0
   ----------------------------------------------------------------------------

   IOAPIC_BASEADDRESS : constant := 16#FEC0_0000#;

   IOREGSEL  : constant := 0;
   IOWIN     : constant := 16#10#;
   IOAPICID  : constant := 0;
   IOAPICVER : constant := 1;
   IOAPICARB : constant := 2;
   IOREDTBL  : constant := 1;

   function IOAPIC_Read (Register_Number : Natural) return Unsigned_32;
   procedure IOAPIC_Write (Register_Number : in Natural; Value : in Unsigned_32);

end APIC;

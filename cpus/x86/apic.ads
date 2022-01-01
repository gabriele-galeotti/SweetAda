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

with System.Storage_Elements;
with Interfaces;

package APIC is

   --========================================================================--
   --                                                                        --
   --                                                                        --
   --                               Public part                              --
   --                                                                        --
   --                                                                        --
   --========================================================================--

   use System.Storage_Elements;
   use Interfaces;

   ----------------------------------------------------------------------------
   -- x86 "local" APIC
   ----------------------------------------------------------------------------
   -- __REF__ http://www.osdever.net/tutorials/view/advanced-programming-interrupt-controller
   -- __REF__ http://www.o3one.org/tutorials/apicarticle.txt
   -- __REF__ http://f.osdev.org/viewtopic.php?f=1&t=26658
   ----------------------------------------------------------------------------

   -- #define IRQ_OFFSET      32      // IRQ 0 corresponds to int IRQ_OFFSET
   -- // Hardware IRQ numbers. We receive these as (IRQ_OFFSET+IRQ_WHATEVER)
   -- #define IRQ_TIMER        0
   -- #define IRQ_KBD          1
   -- #define IRQ_SERIAL       4
   -- #define IRQ_SPURIOUS     7
   -- #define IRQ_IDE         14
   -- #define IRQ_ERROR       19

   LAPIC_BASEADDRESS : constant := 16#FEE0_0000#;

   -- Task Priority Register
   -- Spurious Interrupt Vector Register

   type LAPIC_Type is
   record
      TPR   : Unsigned_32;
      SVR   : Unsigned_32;
      LINT0 : Unsigned_32;
      LINT1 : Unsigned_32;
   end record;
   for LAPIC_Type use
   record
      TPR   at 16#080# range 0 .. 31;
      SVR   at 16#0F0# range 0 .. 31;
      LINT0 at 16#350# range 0 .. 31;
      LINT1 at 16#360# range 0 .. 31;
   end record;

   LAPIC : LAPIC_Type with
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

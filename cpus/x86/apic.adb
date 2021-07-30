-----------------------------------------------------------------------------------------------------------------------
--                                                     SweetAda                                                      --
-----------------------------------------------------------------------------------------------------------------------
-- __HDS__                                                                                                           --
-- __FLN__ apic.adb                                                                                                  --
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

with MMIO;
with CPU_i586;

package body APIC is

   --========================================================================--
   --                                                                        --
   --                                                                        --
   --                           Local declarations                           --
   --                                                                        --
   --                                                                        --
   --========================================================================--

   use CPU_i586;

   --========================================================================--
   --                                                                        --
   --                                                                        --
   --                           Package subprograms                          --
   --                                                                        --
   --                                                                        --
   --========================================================================--

   ----------------------------------------------------------------------------
   -- Local APIC
   ----------------------------------------------------------------------------

   procedure LAPIC_Init is
   begin
      -- enable APIC in MSR
      WRMSR (MSR_APICBASE, RDMSR (MSR_APICBASE) or 16#0000_0000_0000_0800#);
      -- set Spurious Interrupt Vector Register bit 8 to start receiving interrupts
      LAPIC.SVR   := LAPIC.SVR or 16#100# or 16#20#;
      LAPIC.TPR   := 0;
      LAPIC.LINT0 := 16#0000_0700# or 16#0000_0020#; -- DM_EXTINT, vector offset 32
   end LAPIC_Init;

   ----------------------------------------------------------------------------
   -- 82093AA I/O ADVANCED PROGRAMMABLE INTERRUPT CONTROLLER (IOAPIC)
   ----------------------------------------------------------------------------

   function IOAPIC_Read (Register_Number : Natural) return Unsigned_32 is
   begin
      MMIO.Write (To_Address (IOAPIC_BASEADDRESS) + IOREGSEL, Unsigned_32 (Register_Number));
      return MMIO.Read (To_Address (IOAPIC_BASEADDRESS) + IOWIN);
   end IOAPIC_Read;

   procedure IOAPIC_Write (Register_Number : in Natural; Value : in Unsigned_32) is
   begin
      MMIO.Write (To_Address (IOAPIC_BASEADDRESS) + IOREGSEL, Unsigned_32 (Register_Number));
      MMIO.Write (To_Address (IOAPIC_BASEADDRESS) + IOWIN, Value);
   end IOAPIC_Write;

end APIC;

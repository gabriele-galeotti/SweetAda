-----------------------------------------------------------------------------------------------------------------------
--                                                     SweetAda                                                      --
-----------------------------------------------------------------------------------------------------------------------
-- __HDS__                                                                                                           --
-- __FLN__ apic.adb                                                                                                  --
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
      declare
         Value : IA32_APIC_BASE_Type;
      begin
         Value := To_IA32_APIC_BASE (RDMSR (IA32_APIC_BASE));
         Value.APIC_Global_Enable := True;
         WRMSR (IA32_APIC_BASE, To_U64 (Value));
      end;
      -- set Spurious Interrupt Vector Register bit 8 to start receiving interrupts
      LAPIC.SVR   := LAPIC.SVR or 16#1FF#;
      LAPIC.TPR   := 0;
      LAPIC.LINT0 := (
                      V      => 16#20#, -- vector offset 32
                      DM     => 2#111#, -- ExtINT
                      DS     => 0,
                      IIPP   => 0,
                      RIRR   => 0,
                      TM     => 0,
                      Mask   => False,
                      others => <>
                     );
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

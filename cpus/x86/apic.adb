-----------------------------------------------------------------------------------------------------------------------
--                                                     SweetAda                                                      --
-----------------------------------------------------------------------------------------------------------------------
-- __HDS__                                                                                                           --
-- __FLN__ apic.adb                                                                                                  --
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

with MMIO;

package body APIC
   is

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

   ----------------------------------------------------------------------------
   -- LAPIC_Init
   ----------------------------------------------------------------------------
   procedure LAPIC_Init
      is
   begin
      LAPIC.TPR   := (
         SubClass => 0,
         Class    => 0,
         others   => <>
         );
      LAPIC.LINT0 := (
         VECTOR => 16#20#,
         DM     => 2#111#, -- ExtINT
         DS     => 0,
         IIPP   => 0,
         RIRR   => False,
         TM     => 0,
         Mask   => False,
         others => <>
         );
      LAPIC.SVR   := (
         VECTOR => 16#FF#, -- Spurious Vector
         ENABLE => True,
         FPC    => False,
         EOIBS  => False,
         others => <>
         );
   end LAPIC_Init;

   ----------------------------------------------------------------------------
   -- 82093AA I/O ADVANCED PROGRAMMABLE INTERRUPT CONTROLLER (IOAPIC)
   ----------------------------------------------------------------------------

   ----------------------------------------------------------------------------
   -- IOAPIC_Read
   ----------------------------------------------------------------------------
   function IOAPIC_Read
      (Register_Number : Natural)
      return Unsigned_32
      is
   begin
      MMIO.Write (To_Address (IOAPIC_BASEADDRESS) + IOREGSEL, Unsigned_32 (Register_Number));
      return MMIO.Read (To_Address (IOAPIC_BASEADDRESS) + IOWIN);
   end IOAPIC_Read;

   ----------------------------------------------------------------------------
   -- IOAPIC_Write
   ----------------------------------------------------------------------------
   procedure IOAPIC_Write
      (Register_Number : in Natural;
       Value           : in Unsigned_32)
      is
   begin
      MMIO.Write (To_Address (IOAPIC_BASEADDRESS) + IOREGSEL, Unsigned_32 (Register_Number));
      MMIO.Write (To_Address (IOAPIC_BASEADDRESS) + IOWIN, Value);
   end IOAPIC_Write;

end APIC;

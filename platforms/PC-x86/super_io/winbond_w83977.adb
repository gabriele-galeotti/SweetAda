-----------------------------------------------------------------------------------------------------------------------
--                                                     SweetAda                                                      --
-----------------------------------------------------------------------------------------------------------------------
-- __HDS__                                                                                                           --
-- __FLN__ winbond_w83977.adb                                                                                        --
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

with Interfaces;
with CPU.IO;

package body Winbond_W83977
   is

   --========================================================================--
   --                                                                        --
   --                                                                        --
   --                           Package subprograms                          --
   --                                                                        --
   --                                                                        --
   --========================================================================--

   procedure Setup
      is
      -- 8. PLUG AND PLAY CONFIGURATION
      -- 11. CONFIGURATION REGISTER
      type W83977_Type is record
         Logical_Device : Interfaces.Unsigned_8;
         Port           : Interfaces.Unsigned_8;
         Data           : Interfaces.Unsigned_8;
      end record;
      W83977_InitData : constant array (Natural range <>) of W83977_Type :=
         [
          -- PPI
          (16#1#, 16#30#, 16#01#), -- CR30: Activates the logical device.
          (16#1#, 16#60#, 16#03#), -- CR60: These two registers select Parallel Port I/O base address.
          (16#1#, 16#61#, 16#78#), -- CR61: ''
          (16#1#, 16#70#, 16#00#), -- CR70: These bits select IRQ resource for Parallel Port.
          (16#1#, 16#F0#, 16#04#), -- CRF0: Printer Mode (Default)
          -- COM1
          (16#2#, 16#30#, 16#01#), -- CR30: Activates the logical device.
          (16#2#, 16#60#, 16#03#), -- CR60: These two registers select Serial Port 1 I/O base address ...
          (16#2#, 16#61#, 16#F8#), -- CR61: ''
          -- COM2
          (16#3#, 16#30#, 16#01#), -- CR30: Activates the logical device.
          (16#3#, 16#60#, 16#02#), -- CR60: These two registers select Serial Port 2 I/O base address ...
          (16#3#, 16#61#, 16#F8#), -- CR61: ''
          -- ACPI
          (16#A#, 16#30#, 16#01#), -- CR30: Activates the logical device.
          (16#A#, 16#F3#, 16#3F#), -- CRF3: IRQ status.
          (16#A#, 16#30#, 16#00#)  -- CR30: Logical device is inactive.
         ];
      EFER : constant Interfaces.Unsigned_16 := 16#03F0#;
      EFIR : constant Interfaces.Unsigned_16 := 16#03F0#;
      EFDR : constant Interfaces.Unsigned_16 := 16#03F1#;
      CR02 : constant Interfaces.Unsigned_8  := 16#02#;   -- Soft Reset.
      CR07 : constant Interfaces.Unsigned_8  := 16#07#;   -- index
      CR20 : constant Interfaces.Unsigned_8  := 16#20#;   -- Device ID
      CR21 : constant Interfaces.Unsigned_8  := 16#21#;   -- Device Rev
   begin
      -- unlock configuration mode
      CPU.IO.PortOut (EFER, Interfaces.Unsigned_8'(16#87#));
      CPU.IO.PortOut (EFER, Interfaces.Unsigned_8'(16#87#));
      -- CPU.IO.PortOut (EFIR, CR20);
      -- Console.Print (Interfaces.Unsigned_8'(CPU.IO.PortIn (EFDR)), Prefix => "ID:  ", NL => True);
      -- CPU.IO.PortOut (EFIR, CR21);
      -- Console.Print (Interfaces.Unsigned_8'(CPU.IO.PortIn (EFDR)), Prefix => "Rev: ", NL => True);
      CPU.IO.PortOut (EFIR, CR02);
      CPU.IO.PortOut (EFDR, Interfaces.Unsigned_8'(1));
      CPU.IO.PortOut (EFDR, Interfaces.Unsigned_8'(0));
      for Index in W83977_InitData'Range loop
         CPU.IO.PortOut (EFIR, CR07);
         CPU.IO.PortOut (EFDR, W83977_InitData (Index).Logical_Device);
         CPU.IO.PortOut (EFIR, W83977_InitData (Index).Port);
         CPU.IO.PortOut (EFDR, W83977_InitData (Index).Data);
      end loop;
      -- lock configuration mode
      CPU.IO.PortOut (EFER, Interfaces.Unsigned_8'(16#AA#));
   end Setup;
   ----------------------------------------------------------------------------

end Winbond_W83977;

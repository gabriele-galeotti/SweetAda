-----------------------------------------------------------------------------------------------------------------------
--                                                     SweetAda                                                      --
-----------------------------------------------------------------------------------------------------------------------
-- __HDS__                                                                                                           --
-- __FLN__ winbond_w83787.adb                                                                                        --
-- __DSC__                                                                                                           --
-- __HSH__ e69de29bb2d1d6434b8b29ae775ad8c2e48c5391                                                                  --
-- __HDE__                                                                                                           --
-----------------------------------------------------------------------------------------------------------------------
-- Copyright (C) 2020-2025 Gabriele Galeotti                                                                         --
--                                                                                                                   --
-- SweetAda web page: http://sweetada.org                                                                            --
-- contact address: gabriele.galeotti@sweetada.org                                                                   --
-- This work is licensed under the terms of the MIT License.                                                         --
-- Please consult the LICENSE.txt file located in the top-level directory.                                           --
-----------------------------------------------------------------------------------------------------------------------

with Interfaces;
with CPU.IO;

package body Winbond_W83787
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
      type W83787_Type is record
         Port : Interfaces.Unsigned_8;
         Data : Interfaces.Unsigned_8;
      end record;
      W83787_InitData : constant array (Natural range <>) of W83787_Type :=
         [
          (16#00#, 16#04#), -- CR0: enable PRN mode
          (16#01#, 16#2C#), -- CR1: PRN=0x378, COM1=0x3F8, COM2=0x2F8
          (16#02#, 16#FF#), -- CR2:
          (16#03#, 16#90#), -- CR3:
          (16#04#, 16#00#), -- CR4:
          (16#06#, 16#00#), -- CR6:
          (16#09#, 16#80#)  -- CR9: enable PRN mode
         ];
      EFER : constant Interfaces.Unsigned_16 := 16#0250#;
      EFIR : constant Interfaces.Unsigned_16 := 16#0251#;
      EFDR : constant Interfaces.Unsigned_16 := 16#0252#;
   begin
      CPU.IO.PortOut (EFER, Interfaces.Unsigned_8'(16#89#)); -- unlock configuration mode
      for Index in W83787_InitData'Range loop
         CPU.IO.PortOut (EFIR, W83787_InitData (Index).Port);
         CPU.IO.PortOut (EFDR, W83787_InitData (Index).Data);
      end loop;
      CPU.IO.PortOut (EFER, Interfaces.Unsigned_8'(16#FF#)); -- lock configuration mode
   end Setup;
   ----------------------------------------------------------------------------

end Winbond_W83787;

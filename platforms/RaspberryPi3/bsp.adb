-----------------------------------------------------------------------------------------------------------------------
--                                                     SweetAda                                                      --
-----------------------------------------------------------------------------------------------------------------------
-- __HDS__                                                                                                           --
-- __FLN__ bsp.adb                                                                                                   --
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
with MMIO;
with RPI3;

package body BSP is

   --========================================================================--
   --                                                                        --
   --                                                                        --
   --                           Local declarations                           --
   --                                                                        --
   --                                                                        --
   --========================================================================--

   use System.Storage_Elements;
   use RPI3;

   procedure Core_Enable (CoreN : Integer; Start_Address : System.Storage_Elements.Integer_Address);
   procedure Core_Enable (CoreN : Integer; Start_Address : System.Storage_Elements.Integer_Address) is
      C : constant Integer_Address := 16#10# * Integer_Address (CoreN);
   begin
      MMIO.Write (To_Address (CORE0_MBOX3_SET_BASEADDRESS + C), Interfaces.Unsigned_32 (Start_Address));
   end Core_Enable;

   --========================================================================--
   --                                                                        --
   --                                                                        --
   --                           Package subprograms                          --
   --                                                                        --
   --                                                                        --
   --========================================================================--

   ----------------------------------------------------------------------------
   -- Console wrappers
   ----------------------------------------------------------------------------

   -- procedure Console_Putchar (C : in Character) is null;
   -- procedure Console_Getchar (C : out Character) is null;

   ----------------------------------------------------------------------------
   -- BSP_Setup
   ----------------------------------------------------------------------------
   procedure BSP_Setup is
   begin
      -------------------------------------------------------------------------
      loop
         GPIO1 := 16#0004_0000#; -- GPIO16 pin #36
         LEDON := 16#0001_0000#;
         for Index in 1 .. 3_000_000 loop null; end loop;
         LEDOFF := 16#0001_0000#;
         for Index in 1 .. 3_000_000 loop null; end loop;
      end loop;
      -------------------------------------------------------------------------
   end BSP_Setup;

end BSP;

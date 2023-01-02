-----------------------------------------------------------------------------------------------------------------------
--                                                     SweetAda                                                      --
-----------------------------------------------------------------------------------------------------------------------
-- __HDS__                                                                                                           --
-- __FLN__ bsp.adb                                                                                                   --
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

with System.Storage_Elements;
with Interfaces;
with Bits;
with MMIO;
with CPU;
with MCF523x;
with M5235BCC;
with Console;

package body BSP is

   --========================================================================--
   --                                                                        --
   --                                                                        --
   --                           Local declarations                           --
   --                                                                        --
   --                                                                        --
   --========================================================================--

   use System.Storage_Elements;
   use Interfaces;
   use Bits;

   Flash_ROM_Address : constant Integer_Address := 16#FFE0_0000#;

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

   procedure Console_Putchar (C : in Character) is
   begin
      -- wait for transmitter available
      loop
         exit when MCF523x.USR0.TXRDY;
      end loop;
      MCF523x.UTB0 := To_U8 (C);
   end Console_Putchar;

   procedure Console_Getchar (C : out Character) is
      Data : Unsigned_8;
   begin
      -- wait for receiver available
      loop
         exit when MCF523x.USR0.RXRDY;
      end loop;
      Data := MCF523x.URB0;
      C := To_Ch (Data);
   end Console_Getchar;

   ----------------------------------------------------------------------------
   -- BSP_Setup
   ----------------------------------------------------------------------------
pragma Warnings (Off, "volatile actual passed by copy");
   procedure BSP_Setup is
   begin
      -- Console --------------------------------------------------------------
      Console.Console_Descriptor.Write := Console_Putchar'Access;
      Console.Console_Descriptor.Read  := Console_Getchar'Access;
      Console.TTY_Setup;
      -------------------------------------------------------------------------
      Console.Print ("M5235BCC", NL => True);
      Console.Print (Unsigned_32 (MCF523x.CIR.PIN), Prefix => "PIN:    ", NL => True);
      Console.Print (Unsigned_32 (MCF523x.CIR.PRN), Prefix => "PRN:    ", NL => True);
      Console.Print (MCF523x.To_U32 (MCF523x.IPSBAR), Prefix => "IPSBAR: ", NL => True);
      -------------------------------------------------------------------------
      declare
         Address_Scale : constant := 2; -- 16-bit mode
      begin
         Console.Print ("STM29W160EB Flash ROM", NL => True);
         -- Read/Reset
         MMIO.Write_U16 (To_Address (Flash_ROM_Address), 16#F0#);
         -- Auto Select
         MMIO.Write_U16 (To_Address (Flash_ROM_Address + 16#555# * Address_Scale), 16#AA#);
         MMIO.Write_U16 (To_Address (Flash_ROM_Address + 16#2AA# * Address_Scale), 16#55#);
         MMIO.Write_U16 (To_Address (Flash_ROM_Address + 16#555# * Address_Scale), 16#90#);
         -- Read Manufacturer/Device code
         Console.Print (
            MMIO.Read_U16 (To_Address (Flash_ROM_Address + 16#00# * Address_Scale)),
            Prefix => "Manufacturer: ",
            NL => True
            );
         Console.Print (
            MMIO.Read_U16 (To_Address (Flash_ROM_Address + 16#01# * Address_Scale)),
            Prefix => "Device:       ",
            NL => True
            );
         -- Read/Reset
         MMIO.Write_U16 (To_Address (Flash_ROM_Address), 16#F0#);
      end;
      -------------------------------------------------------------------------
   end BSP_Setup;
pragma Warnings (On, "volatile actual passed by copy");

end BSP;

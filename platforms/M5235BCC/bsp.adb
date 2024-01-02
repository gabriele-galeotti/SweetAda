-----------------------------------------------------------------------------------------------------------------------
--                                                     SweetAda                                                      --
-----------------------------------------------------------------------------------------------------------------------
-- __HDS__                                                                                                           --
-- __FLN__ bsp.adb                                                                                                   --
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

with System.Parameters;
with System.Secondary_Stack;
with System.Storage_Elements;
with Definitions;
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
   use Definitions;
   use Bits;

   Flash_ROM_Address : constant Integer_Address := 16#FFE0_0000#;

   BSP_SS_Stack : System.Secondary_Stack.SS_Stack_Ptr;

   function Get_Sec_Stack return System.Secondary_Stack.SS_Stack_Ptr with
      Export        => True,
      Convention    => C,
      External_Name => "__gnat_get_secondary_stack";

   --========================================================================--
   --                                                                        --
   --                                                                        --
   --                           Package subprograms                          --
   --                                                                        --
   --                                                                        --
   --========================================================================--

   ----------------------------------------------------------------------------
   -- Get_Sec_Stack
   ----------------------------------------------------------------------------
   function Get_Sec_Stack return System.Secondary_Stack.SS_Stack_Ptr is
   begin
      return BSP_SS_Stack;
   end Get_Sec_Stack;

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
   -- Setup
   ----------------------------------------------------------------------------
pragma Warnings (Off, "volatile actual passed by copy");
   procedure Setup is
   begin
      -------------------------------------------------------------------------
      System.Secondary_Stack.SS_Init (BSP_SS_Stack, System.Parameters.Unspecified_Size);
      -- Console --------------------------------------------------------------
      Console.Console_Descriptor.Write := Console_Putchar'Access;
      Console.Console_Descriptor.Read  := Console_Getchar'Access;
      Console.Print (ANSI_CLS & ANSI_CUPHOME & VT100_LINEWRAP);
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
   end Setup;
pragma Warnings (On, "volatile actual passed by copy");

end BSP;

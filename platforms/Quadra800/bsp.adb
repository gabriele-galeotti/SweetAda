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

with System;
with System.Storage_Elements;
with Definitions;
with Bits;
with MMIO;
with Exceptions;
with Quadra800;
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
      Z8530.TX (SCC_Descriptor, Z8530.CHANNELA, To_U8 (C));
   end Console_Putchar;

   procedure Console_Getchar (C : out Character) is
      Data : Unsigned_8;
   begin
      Z8530.RX (SCC_Descriptor, Z8530.CHANNELA, Data);
      C := To_Ch (Data);
   end Console_Getchar;

   ----------------------------------------------------------------------------
   -- Setup
   ----------------------------------------------------------------------------
   procedure Setup is
   begin
      -------------------------------------------------------------------------
      -- Exceptions.Init;
      Quadra800.Init;
      -- SCC ------------------------------------------------------------------
      SCC_Descriptor.Base_Address   := To_Address (Quadra800.SCC_BASEADDRESS);
      SCC_Descriptor.AB_Address_Bit := 1;
      SCC_Descriptor.CD_Address_Bit := 2;
      SCC_Descriptor.Baud_Clock     := CLK_UART4M9;
      SCC_Descriptor.Read_8         := MMIO.Read'Access;
      SCC_Descriptor.Write_8        := MMIO.Write'Access;
      Z8530.Init (SCC_Descriptor, Z8530.CHANNELA);
      Z8530.Init (SCC_Descriptor, Z8530.CHANNELB);
      Z8530.Baud_Rate_Set (SCC_Descriptor, Z8530.CHANNELA, BR_9600);
      Z8530.Baud_Rate_Set (SCC_Descriptor, Z8530.CHANNELB, BR_9600);
      -- Console --------------------------------------------------------------
      Console.Console_Descriptor.Write := Console_Putchar'Access;
      Console.Console_Descriptor.Read := Console_Getchar'Access;
      Console.Print (ANSI_CLS & ANSI_CUPHOME & VT100_LINEWRAP);
      -------------------------------------------------------------------------
      Console.Print ("Quadra 800 (QEMU emulator)", NL => True);
      -------------------------------------------------------------------------
   end Setup;

end BSP;

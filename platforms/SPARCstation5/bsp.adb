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
with Ada.Unchecked_Conversion;
with Interfaces;
with Definitions;
with MMIO;
with SPARC;
with Sun4m;
with Exceptions;
with Console;

package body BSP is

   --========================================================================--
   --                                                                        --
   --                                                                        --
   --                           Local declarations                           --
   --                                                                        --
   --                                                                        --
   --========================================================================--

   use System;
   use System.Storage_Elements;
   use Interfaces;
   use Definitions;
   use Bits;
   use Sun4m;

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

   -- serial port "A"

   procedure Console_Putchar (C : in Character) is
   begin
      SCC.TX (SCC_Descriptor, SCC.CHANNELA, To_U8 (C));
   end Console_Putchar;

   procedure Console_Getchar (C : out Character) is
      Data : Unsigned_8;
   begin
      SCC.RX (SCC_Descriptor, SCC.CHANNELA, Data);
      C := To_Ch (Data);
   end Console_Getchar;

   ----------------------------------------------------------------------------
   -- BSP_Setup
   ----------------------------------------------------------------------------
   procedure BSP_Setup is
   begin
      -------------------------------------------------------------------------
      -- Exceptions.Init;
      -- TBR_Set (To_Address (0));
      -- SCC ------------------------------------------------------------------
      SCC_Descriptor.Base_Address   := To_Address (SCC_BASEADDRESS);
      SCC_Descriptor.AB_Address_Bit := 2;
      SCC_Descriptor.CD_Address_Bit := 1;
      SCC_Descriptor.Baud_Clock     := 4_915_200;
      SCC_Descriptor.Read_8         := MMIO.Read'Access;
      SCC_Descriptor.Write_8        := MMIO.Write'Access;
      SCC.Init (SCC_Descriptor, SCC.CHANNELA);
      SCC.Init (SCC_Descriptor, SCC.CHANNELB);
      SCC.Baud_Rate_Set (SCC_Descriptor, SCC.CHANNELA, BR_38400);
      SCC.Baud_Rate_Set (SCC_Descriptor, SCC.CHANNELB, BR_38400);
      -- Console --------------------------------------------------------------
      Console.Console_Descriptor.Write := Console_Putchar'Access;
      Console.Console_Descriptor.Read := Console_Getchar'Access;
      Console.TTY_Setup;
      -------------------------------------------------------------------------
      Console.Print ("SPARCstation 5", NL => True);
      Console.Print (Natural (Nwindows),       Prefix => "Nwindows:         ", NL => True);
      Console.Print (QEMU,                     Prefix => "QEMU:             ", NL => True);
      Console.Print (DMA2_INTERNAL_IDREGISTER, Prefix => "DMA2 ID Register: ", NL => True);
      -- Am7990 ---------------------------------------------------------------
      Am7990_Descriptor.Base_Address  := To_Address (ETHERNET_CONTROLLER_REGISTERS_BASEADDRESS);
      Am7990_Descriptor.Scale_Address := 0;
      Am7990_Descriptor.Read_16       := MMIO.ReadA'Access;
      Am7990_Descriptor.Write_16      := MMIO.WriteA'Access;
      -------------------------------------------------------------------------
      SITMS := (
                SBusIrq => 0,
                K       => False,
                S       => False,
                E       => False,
                SC      => False,
                T       => True,
                V       => False,
                F       => False,
                M       => False,
                I       => False,
                ME      => False,
                MA      => True,
                others  => <>
               );
      SPARC.Irq_Enable;
      Tclk_Init;
      -------------------------------------------------------------------------
   end BSP_Setup;

end BSP;

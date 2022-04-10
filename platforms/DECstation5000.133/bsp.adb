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

with System.Storage_Elements;
with Ada.Unchecked_Conversion;
with Interfaces;
with Definitions;
with Bits;
with MMIO;
with MIPS;
with R3000;
with KN02BA;
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
   use MIPS;
   use R3000;
   use KN02BA;

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
      -- SCC.TX (SCC_Descriptor1, SCC.CHANNELB, To_U8 (C)); -- serial port "2"
      SCC.TX (SCC_Descriptor2, SCC.CHANNELB, To_U8 (C)); -- serial port "3"
   end Console_Putchar;

   procedure Console_Getchar (C : out Character) is
   begin
      C := Character'Val (0);
   end Console_Getchar;

   ----------------------------------------------------------------------------
   -- BSP_Setup
   ----------------------------------------------------------------------------
   procedure BSP_Setup is
   begin
      -------------------------------------------------------------------------
      IOASIC_CSR.SCC_ENABLE := True;
      IOASIC_CSR.RTC_ENABLE := True;
      -- SCCs -----------------------------------------------------------------
      SCC_Descriptor1.Base_Address            := To_Address (KSEG1_ADDRESS + SCC0_BASEADDRESS);
      SCC_Descriptor1.AB_Address_Bit          := 3;
      SCC_Descriptor1.CD_Address_Bit          := 2;
      SCC_Descriptor1.Baud_Clock              := Definitions.UART7M3_CLK;
      SCC_Descriptor1.Flags.DECstation5000133 := True;
      SCC_Descriptor1.Read_8                  := MMIO.Read'Access;
      SCC_Descriptor1.Write_8                 := MMIO.Write'Access;
      SCC.Init (SCC_Descriptor1, SCC.CHANNELA);
      SCC.Init (SCC_Descriptor1, SCC.CHANNELB);
      SCC_Descriptor2.Base_Address            := To_Address (KSEG1_ADDRESS + SCC1_BASEADDRESS);
      SCC_Descriptor2.AB_Address_Bit          := 3;
      SCC_Descriptor2.CD_Address_Bit          := 2;
      SCC_Descriptor2.Baud_Clock              := Definitions.UART7M3_CLK;
      SCC_Descriptor2.Flags.DECstation5000133 := True;
      SCC_Descriptor2.Read_8                  := MMIO.Read'Access;
      SCC_Descriptor2.Write_8                 := MMIO.Write'Access;
      SCC.Init (SCC_Descriptor2, SCC.CHANNELA);
      SCC.Init (SCC_Descriptor2, SCC.CHANNELB);
      -- Console --------------------------------------------------------------
      Console.Console_Descriptor.Write := Console_Putchar'Access;
      Console.Console_Descriptor.Read := Console_Getchar'Access;
      Console.TTY_Setup;
      -------------------------------------------------------------------------
      Console.Print ("DECstation 5000/133", NL => True);
      -------------------------------------------------------------------------
   end BSP_Setup;

end BSP;

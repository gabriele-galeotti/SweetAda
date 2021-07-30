-----------------------------------------------------------------------------------------------------------------------
--                                                     SweetAda                                                      --
-----------------------------------------------------------------------------------------------------------------------
-- __HDS__                                                                                                           --
-- __FLN__ bsp.adb                                                                                                   --
-- __DSC__                                                                                                           --
-- __HSH__ e69de29bb2d1d6434b8b29ae775ad8c2e48c5391                                                                  --
-- __HDE__                                                                                                           --
-----------------------------------------------------------------------------------------------------------------------
-- Copyright (C) 2020, 2021 Gabriele Galeotti                                                                        --
--                                                                                                                   --
-- SweetAda web page: http://sweetada.org                                                                            --
-- contact address: gabriele.galeotti@sweetada.org                                                                   --
-- This work is licensed under the terms of the MIT License.                                                         --
-- Please consult the LICENSE.txt file located in the top-level directory.                                           --
-----------------------------------------------------------------------------------------------------------------------

with System.Storage_Elements;
with Configure;
with Interfaces;
with Core;
with Bits;
with PowerPC;
with PowerPC.PPC405;
with Taihu;
with Exceptions;
with MMIO;
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
   use Core;
   use Bits;
   use PowerPC;
   use PowerPC.PPC405;
   use Taihu;

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
      UART16x50.TX (UART1_Descriptor, To_U8 (C));
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
      Exceptions.Init;
      -- UARTs ----------------------------------------------------------------
      UART1_Descriptor.Base_Address  := To_Address (UART1_BASEADDRESS);
      UART1_Descriptor.Scale_Address := 0;
      UART1_Descriptor.Baud_Clock    := 1_843_200;
      UART1_Descriptor.Read_8        := MMIO.Read'Access;
      UART1_Descriptor.Write_8       := MMIO.Write'Access;
      UART16x50.Init (UART1_Descriptor);
      UART2_Descriptor.Base_Address  := To_Address (UART2_BASEADDRESS);
      UART2_Descriptor.Scale_Address := 0;
      UART2_Descriptor.Baud_Clock    := 1_843_200;
      UART2_Descriptor.Read_8        := MMIO.Read'Access;
      UART2_Descriptor.Write_8       := MMIO.Write'Access;
      UART16x50.Init (UART2_Descriptor);
      -- Console --------------------------------------------------------------
      Console.Console_Descriptor.Write := Console_Putchar'Access;
      Console.Console_Descriptor.Read := Console_Getchar'Access;
      Console.TTY_Setup;
      -------------------------------------------------------------------------
      Console.Print ("Taihu405EP (QEMU emulator)", NL => True);
      Console.Print (PVR_Read.Version, Prefix => "PVR version:  ", NL => True);
      Console.Print (PVR_Read.Revision, Prefix => "PVR revision: ", NL => True);
      Tclk_Init;
      -- enable UIC0 interrupts
      declare
         I : UIC0_ER_Register_Type;
      begin
         I := UIC0_ER_Read;
         I.U0IE := True;
         UIC0_ER_Write (I);
      end;
      MSREE_Set;
      -- Enable receiver interrupt.
      -- Uart1.IER := 1;
      -------------------------------------------------------------------------
   end BSP_Setup;

end BSP;

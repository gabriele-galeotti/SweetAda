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

with System.Parameters;
with System.Secondary_Stack;
with System.Storage_Elements;
with Interfaces;
with Definitions;
with Configure;
with Bits;
with PowerPC;
with PPC405;
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
   use Definitions;
   use Bits;
   use PowerPC;
   use PPC405;
   use Taihu;

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
      UART16x50.TX (UART1_Descriptor, To_U8 (C));
   end Console_Putchar;

   procedure Console_Getchar (C : out Character) is
      Data : Unsigned_8;
   begin
      UART16x50.RX (UART1_Descriptor, Data);
      C := To_Ch (Data);
   end Console_Getchar;

   ----------------------------------------------------------------------------
   -- Setup
   ----------------------------------------------------------------------------
   procedure Setup is
   begin
      -------------------------------------------------------------------------
      System.Secondary_Stack.SS_Init (BSP_SS_Stack, System.Parameters.Unspecified_Size);
      -------------------------------------------------------------------------
      Exceptions.Init;
      -- UARTs ----------------------------------------------------------------
      UART1_Descriptor.Base_Address  := To_Address (UART1_BASEADDRESS);
      UART1_Descriptor.Scale_Address := 0;
      UART1_Descriptor.Baud_Clock    := CLK_UART1M8;
      UART1_Descriptor.Read_8        := MMIO.Read'Access;
      UART1_Descriptor.Write_8       := MMIO.Write'Access;
      UART16x50.Init (UART1_Descriptor);
      UART2_Descriptor.Base_Address  := To_Address (UART2_BASEADDRESS);
      UART2_Descriptor.Scale_Address := 0;
      UART2_Descriptor.Baud_Clock    := CLK_UART1M8;
      UART2_Descriptor.Read_8        := MMIO.Read'Access;
      UART2_Descriptor.Write_8       := MMIO.Write'Access;
      UART16x50.Init (UART2_Descriptor);
      -- Console --------------------------------------------------------------
      Console.Console_Descriptor.Write := Console_Putchar'Access;
      Console.Console_Descriptor.Read := Console_Getchar'Access;
      Console.Print (ANSI_CLS & ANSI_CUPHOME & VT100_LINEWRAP);
      -------------------------------------------------------------------------
      Console.Print ("Taihu405EP (QEMU emulator)", NL => True);
      Console.Print (PVR_Read.Version, Prefix => "PVR version:  ", NL => True);
      Console.Print (PVR_Read.Revision, Prefix => "PVR revision: ", NL => True);
      Tclk_Init;
      MSREE_Set;
      -------------------------------------------------------------------------
   end Setup;

end BSP;

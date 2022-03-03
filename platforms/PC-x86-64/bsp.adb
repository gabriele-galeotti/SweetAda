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
with Configure;
with Core;
with Bits;
with CPU;
with CPU.IO;
with PCI;
with PC;
with VGA;
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
   use Core;
   use Bits;
   use CPU;
   use CPU.IO;

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
      UART16x50.TX (UART_Descriptors (1), To_U8 (C));
   end Console_Putchar;

   procedure Console_Getchar (C : out Character) is
      Data : Unsigned_8;
   begin
      UART16x50.RX (UART_Descriptors (1), Data);
      C := To_Ch (Data);
   end Console_Getchar;

   ----------------------------------------------------------------------------
   -- BSP_Setup
   ----------------------------------------------------------------------------
   procedure BSP_Setup is
   begin
      -- UARTs ----------------------------------------------------------------
      UART_Descriptors (1).Base_Address  := To_Address (PC.UART1_BASEADDRESS);
      UART_Descriptors (1).Scale_Address := 0;
      UART_Descriptors (1).Baud_Clock    := 1_843_200;
      UART_Descriptors (1).Read_8        := IO_Read'Access;
      UART_Descriptors (1).Write_8       := IO_Write'Access;
      UART_Descriptors (1).Data_Queue    := ((others => 0), 0, 0, 0);
      UART16x50.Init (UART_Descriptors (1));
      UART_Descriptors (2).Base_Address  := To_Address (PC.UART2_BASEADDRESS);
      UART_Descriptors (2).Scale_Address := 0;
      UART_Descriptors (2).Baud_Clock    := 1_843_200;
      UART_Descriptors (2).Read_8        := IO_Read'Access;
      UART_Descriptors (2).Write_8       := IO_Write'Access;
      UART_Descriptors (2).Data_Queue    := ((others => 0), 0, 0, 0);
      UART16x50.Init (UART_Descriptors (2));
      -- Console --------------------------------------------------------------
      Console.Console_Descriptor.Write := Console_Putchar'Access;
      Console.Console_Descriptor.Read := Console_Getchar'Access;
      Console.TTY_Setup;
      -- CPU ------------------------------------------------------------------
      Console.Print ("PC-x86-64", NL => True);
      -- PCI ------------------------------------------------------------------
      PCI.Cfg_Access_Descriptor.Read_32 := CPU.IO.PortIn'Access;
      PCI.Cfg_Access_Descriptor.Write_32 := CPU.IO.PortOut'Access;
      if True then
         declare
            Vendor_Id : PCI.Vendor_Id_Type;
            Device_Id : PCI.Device_Id_Type;
            Success   : Boolean;
         begin
            for Index in PCI.Device_Number_Type'Range loop
               PCI.Cfg_Detect_Device (0, Index, Vendor_Id, Device_Id, Success);
               if Success then
                  Console.Print (Unsigned_16 (Index), Prefix => "PCI Device #");
                  Console.Print (Character'(' '));
                  Console.Print (Unsigned_16 (Vendor_Id));
                  Console.Print (Character'(':'));
                  Console.Print (Unsigned_16 (Device_Id));
                  Console.Print_NewLine;
               end if;
            end loop;
         end;
      end if;
      -- detect if running under QEMU -----------------------------------------
      declare
         Success       : Boolean;
         Device_Number : PCI.Device_Number_Type with Unreferenced => True;
      begin
         PCI.Cfg_Find_Device_By_Id (0, PCI.VENDOR_ID_QEMU, PCI.DEVICE_ID_QEMU_VGA, Device_Number, Success);
         if Success then
            QEMU := True;
         end if;
      end;
      -- VGA ------------------------------------------------------------------
      VGA.Init (0, 0);
      VGA.Set_Mode (VGA.MODE03H);
      VGA.Clear_Screen;
      VGA.Print (0, 0, KERNEL_NAME & ": initializing");
      if QEMU then
         VGA.Print (0, 1, "Press CTRL-ALT-G to un-grab the mouse cursor.");
         VGA.Print (0, 2, "Close this window to shutdown the emulator.");
      end if;
      -------------------------------------------------------------------------
   end BSP_Setup;

end BSP;

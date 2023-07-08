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
with System.Parameters;
with System.Secondary_Stack;
with System.Storage_Elements;
with Interfaces.C;
with Configure;
with Definitions;
with Core;
with Bits;
with x86_64;
with CPU.IO;
with PCI;
with PIIX;
with PC;
with VGA;
with Exceptions;
with APIC;
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
   use x86_64;
   use CPU.IO;

   BSP_SS_Stack : System.Secondary_Stack.SS_Stack_Ptr;

   function Number_Of_CPUs return Interfaces.C.int with
      Export        => True,
      Convention    => C,
      External_Name => "__gnat_number_of_cpus";

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
   -- Number_Of_CPUs
   ----------------------------------------------------------------------------
   function Number_Of_CPUs return Interfaces.C.int is
   begin
      return 1;
   end Number_Of_CPUs;

   ----------------------------------------------------------------------------
   -- Get_Sec_Stack
   ----------------------------------------------------------------------------
   function Get_Sec_Stack return System.Secondary_Stack.SS_Stack_Ptr is
   begin
      return BSP_SS_Stack;
   end Get_Sec_Stack;

   ----------------------------------------------------------------------------
   -- Tclk_Init
   ----------------------------------------------------------------------------
   procedure Tclk_Init is
      Count : Unsigned_16;
   begin
      Count := Unsigned_16 ((PC.PIT_CLK + Configure.TICK_FREQUENCY / 2) / Configure.TICK_FREQUENCY);
      PC.PIT_Counter0_Init (Count);
   end Tclk_Init;

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
   -- Setup
   ----------------------------------------------------------------------------
   procedure Setup is
   begin
      -------------------------------------------------------------------------
      System.Secondary_Stack.SS_Init (BSP_SS_Stack, System.Parameters.Unspecified_Size);
      -------------------------------------------------------------------------
      Exceptions.Init;
      -- UARTs ----------------------------------------------------------------
      UART_Descriptors (1).Base_Address  := To_Address (PC.UART1_BASEADDRESS);
      UART_Descriptors (1).Scale_Address := 0;
      UART_Descriptors (1).Baud_Clock    := CLK_UART1M8;
      UART_Descriptors (1).Read_8        := IO_Read'Access;
      UART_Descriptors (1).Write_8       := IO_Write'Access;
      UART_Descriptors (1).Data_Queue    := [[others => 0], 0, 0, 0];
      UART16x50.Init (UART_Descriptors (1));
      UART16x50.Baud_Rate_Set (UART_Descriptors (1), Baud_Rate_Type'Enum_Rep (BR_19200));
      UART_Descriptors (2).Base_Address  := To_Address (PC.UART2_BASEADDRESS);
      UART_Descriptors (2).Scale_Address := 0;
      UART_Descriptors (2).Baud_Clock    := CLK_UART1M8;
      UART_Descriptors (2).Read_8        := IO_Read'Access;
      UART_Descriptors (2).Write_8       := IO_Write'Access;
      UART_Descriptors (2).Data_Queue    := [[others => 0], 0, 0, 0];
      UART16x50.Init (UART_Descriptors (2));
      UART16x50.Baud_Rate_Set (UART_Descriptors (2), Baud_Rate_Type'Enum_Rep (BR_19200));
      -- Console --------------------------------------------------------------
      Console.Console_Descriptor.Write := Console_Putchar'Access;
      Console.Console_Descriptor.Read := Console_Getchar'Access;
      Console.Print (ANSI_CLS & ANSI_CUPHOME & VT100_LINEWRAP);
      -- CPU ------------------------------------------------------------------
      Console.Print ("PC-x86-64", NL => True);
      -------------------------------------------------------------------------
      if Core.Debug_Flag then
         Console.Print ("Debug_Flag: ENABLED", NL => True);
      end if;
      -------------------------------------------------------------------------
      Console.Print (
                     To_IA32_EFER (RDMSR (IA32_EFER)).LMA,
                     Prefix => "64-bit mode:        ", NL => True
                    );
      Console.Print (
                     To_IA32_APIC_BASE (RDMSR (IA32_APIC_BASE)).APIC_Global_Enable,
                     Prefix => "APIC_Global_Enable: ", NL => True
                    );
      Console.Print (
                     Shift_Left (Unsigned_32 (To_IA32_APIC_BASE (RDMSR (IA32_APIC_BASE)).APIC_Base), 12),
                     Prefix => "APIC_Base:          ", NL => True
                    );
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
      -- PIIX3 ----------------------------------------------------------------
      if PIIX.Probe then
         Console.Print ("PIIX3 detected", NL => True);
         PIIX.Init;
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
      VGA.Print (0, 0, Core.KERNEL_NAME & ": initializing");
      if QEMU then
         VGA.Print (0, 1, "Press CTRL-ALT-G to un-grab the mouse cursor.");
         VGA.Print (0, 2, "Close this window to shutdown the emulator.");
      end if;
      -------------------------------------------------------------------------
      declare
         Value : IA32_APIC_BASE_Type;
      begin
         Value := To_IA32_APIC_BASE (RDMSR (IA32_APIC_BASE));
         Value.APIC_Global_Enable := True;
         WRMSR (IA32_APIC_BASE, To_U64 (Value));
      end;
      APIC.LAPIC_Init;
      PC.PIC_Init (Unsigned_8 (PC.PIC_Irq0), Unsigned_8 (PC.PIC_Irq8));
      Tclk_Init;
      PC.PIC_Irq_Enable (PC.PIT_Interrupt);
      Irq_Enable;
      -------------------------------------------------------------------------
   end Setup;

end BSP;

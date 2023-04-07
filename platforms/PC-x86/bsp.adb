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
with Interfaces;
with Ada.Unchecked_Conversion;
with Configure;
with Definitions;
with Core;
with Bits;
with CPU;
with CPU.IO;
with i586;
with GDT_Simple;
with APIC;
with MMU;
with Exceptions;
with Interrupts;
with PC;
with PCI;
with PIIX;
with PCICAN;
with VGA;
with Gdbstub.SerialComm;
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
   use CPU;
   use CPU.IO;
   use i586;
   use APIC;

   procedure Board_Init;

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
   -- Board_Init
   ----------------------------------------------------------------------------
   procedure Board_Init is separate;

   ----------------------------------------------------------------------------
   -- Setup
   ----------------------------------------------------------------------------
   -- System is in protected-mode, DPL0 flat linear address space.
   ----------------------------------------------------------------------------
   procedure Setup is
   begin
      -------------------------------------------------------------------------
      GDT_Simple.Setup;
      Exceptions.Init;
      MMU.Init;
      Board_Init;
      -- UARTs ----------------------------------------------------------------
      UART_Descriptors (1).Base_Address  := To_Address (PC.UART1_BASEADDRESS);
      UART_Descriptors (1).Scale_Address := 0;
      UART_Descriptors (1).Baud_Clock    := 1_843_200;
      UART_Descriptors (1).Read_8        := IO_Read'Access;
      UART_Descriptors (1).Write_8       := IO_Write'Access;
      UART_Descriptors (1).Data_Queue    := [[others => 0], 0, 0, 0];
      UART16x50.Init (UART_Descriptors (1));
      UART_Descriptors (2).Base_Address  := To_Address (PC.UART2_BASEADDRESS);
      UART_Descriptors (2).Scale_Address := 0;
      UART_Descriptors (2).Baud_Clock    := 1_843_200;
      UART_Descriptors (2).Read_8        := IO_Read'Access;
      UART_Descriptors (2).Write_8       := IO_Write'Access;
      UART_Descriptors (2).Data_Queue    := [[others => 0], 0, 0, 0];
      UART16x50.Init (UART_Descriptors (2));
      -- Console --------------------------------------------------------------
      Console.Console_Descriptor.Write := Console_Putchar'Access;
      Console.Console_Descriptor.Read  := Console_Getchar'Access;
      Console.Print (ANSI_CLS & ANSI_CUPHOME & VT100_LINEWRAP);
      -- CPU ------------------------------------------------------------------
      Console.Print ("PC-x86", NL => True);
      -------------------------------------------------------------------------
      if Core.Debug_Flag then
         Console.Print ("Debug_Flag: ENABLED", NL => True);
      end if;
      -- CPU feautures --------------------------------------------------------
      if CPUID_Enabled then
         declare
            CPU_Features : CPU_Features_Type;
         begin
            Console.Print ("CPU identifies as: " & String (CPU_VendorID_Read), NL => True);
            Console.Print ("Features:");
            CPU_Features := CPU_Features_Read;
            if CPU_Features.FPU then
               Console.Print (" FPU");
            end if;
            if CPU_Features.VME then
               Console.Print (" VME");
            end if;
            if CPU_Features.MSR then
               Console.Print (" MSR");
            end if;
            if CPU_Features.APIC then
               Console.Print (" APIC");
            end if;
            if CPU_Features.PAE then
               Console.Print (" PAE");
            end if;
            Console.Print_NewLine;
            if Configure.USE_APIC and then CPU_Features.APIC then
               declare
                  Value : IA32_APIC_BASE_Type;
               begin
                  Value := To_IA32_APIC_BASE (RDMSR (IA32_APIC_BASE));
                  Value.APIC_Global_Enable := True;
                  WRMSR (IA32_APIC_BASE, To_U64 (Value));
               end;
               LAPIC_Init;
            end if;
         end;
      end if;
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
      -- PIIX3 ----------------------------------------------------------------
      if PIIX.Probe then
         Console.Print ("PIIX3 detected", NL => True);
         PIIX.Init;
      end if;
      -- PPI ------------------------------------------------------------------
      PC.PPI_Init;
      -- VGA ------------------------------------------------------------------
      VGA.Init (0, 0);
      VGA.Set_Mode (VGA.MODE03H);
      VGA.Clear_Screen;
      VGA.Print (0, 0, Core.KERNEL_NAME & ": initializing");
      if QEMU then
         VGA.Print (0, 1, "Press CTRL-ALT-G to un-grab the mouse cursor.");
         VGA.Print (0, 2, "Close this window to shutdown the emulator.");
      end if;
      -- IDE ------------------------------------------------------------------
      IDE_Descriptors (1).Base_Address  := To_Address (PC.IDE1_BASEADDRESS);
      IDE_Descriptors (1).Scale_Address := 0;
      IDE_Descriptors (1).Read_8        := IO_Read'Access;
      IDE_Descriptors (1).Write_8       := IO_Write'Access;
      IDE_Descriptors (1).Read_16       := IO_Read'Access;
      IDE_Descriptors (1).Write_16      := IO_Write'Access;
      IDE.Init (IDE_Descriptors (1));
      -- NE2000 (PCI) ---------------------------------------------------------
      if True then
         declare
            Success : Boolean;
         begin
            NE2000.Probe (NE2000_Descriptors (1).Device_Number, Success);
            if Success then
               NE2000_Descriptors (1).NE2000PCI    := True;
               NE2000_Descriptors (1).Base_Address := 16#C000#;
               NE2000_Descriptors (1).MAC          := [16#02#, 16#00#, 16#00#, 16#11#, 16#22#, 16#33#];
               NE2000_Descriptors (1).Read_8       := PortIn'Access;
               NE2000_Descriptors (1).Write_8      := PortOut'Access;
               NE2000_Descriptors (1).Read_16      := PortIn'Access;
               NE2000_Descriptors (1).Write_16     := PortOut'Access;
               NE2000_Descriptors (1).Read_32      := PortIn'Access;
               NE2000_Descriptors (1).Write_32     := PortOut'Access;
               NE2000.Init_PCI (NE2000_Descriptors (1));
            end if;
         end;
      end if;
      -- Ethernet module ------------------------------------------------------
      Ethernet_Descriptor.Haddress     := NE2000_Descriptors (1).MAC;
      if QEMU then
         Ethernet_Descriptor.Paddress := [192, 168, 3, 2];
      else
         Ethernet_Descriptor.Paddress := [192, 168, 2, 2];
      end if;
      -- Ethernet_Descriptor.RX           := NE2000.Receive'Access;
      Ethernet_Descriptor.TX           := NE2000.Transmit'Access;
      Ethernet_Descriptor.Data_Address := NE2000_Descriptors (1)'Address;
      Ethernet.Init (Ethernet_Descriptor);
      -- CAN (PCI) ------------------------------------------------------------
      declare
         Device_Number : PCI.Device_Number_Type with Unreferenced => True;
         Success       : Boolean;
      begin
         PCICAN.Probe (Device_Number, Success);
         if Success then
            PCICAN.Init;
         end if;
      end;
      -------------------------------------------------------------------------
      PC.PIC_Init (Unsigned_8 (PC.PIC_Irq0), Unsigned_8 (PC.PIC_Irq8));
      Tclk_Init;
      PC.PIC_Irq_Enable (PC.PIT_Interrupt);
      -- RTC
      PC.PIC_Irq_Enable (PC.RTC_Interrupt);
      Interrupts.Install (PC.RTC_Interrupt, PC.RTC_Handle'Access, Null_Address);
      -- UART1
      PC.PIC_Irq_Enable (PC.PIC_Irq4);
      Interrupts.Install (PC.PIC_Irq4, UART16x50.Receive'Access, UART_Descriptors (1)'Address);
      -- UART2
      PC.PIC_Irq_Enable (PC.PIC_Irq3);
      Interrupts.Install (PC.PIC_Irq3, UART16x50.Receive'Access, UART_Descriptors (2)'Address);
      -- NE2000
      PC.PIC_Irq_Enable (PC.PIC_Irq5);
      Interrupts.Install (PC.PIC_Irq5, NE2000.Interrupt_Handler'Access, NE2000_Descriptors (1)'Address);
      declare
         Pirqc : constant PIIX.PIRQC_Type := (
                                              IRQROUTE   => PIIX.IRQROUTE_IRQ5,
                                              IRQROUTEEN => NTrue,
                                              others     => <>
                                             );
      begin
         -- PIC ELCR
         CPU.IO.PortOut (16#04D0#, Unsigned_8'(16#20#)); -- RTL8029 bit5, Irq5
         CPU.IO.PortOut (16#04D1#, Unsigned_8'(16#00#));
         -- QEMU RTL8029 Irq5
         PCI.Cfg_Write (PCI.BUS0, 1, 0, PIIX.PIRQRCC, Unsigned_8'(PIIX.To_U8 (Pirqc)));
      end;
      -- final IRQ enable
      Irq_Enable;
      -------------------------------------------------------------------------
   end Setup;

   ----------------------------------------------------------------------------
   -- Reset
   ----------------------------------------------------------------------------
   procedure Reset is
   begin
      null;
   end Reset;

end BSP;

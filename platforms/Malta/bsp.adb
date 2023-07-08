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
with Configure;
with Definitions;
with Bits;
with MIPS;
with MIPS32;
with Core;
with Malta;
with VGA;
with Exceptions;
with PCI;
with UART16x50;
with IDE;
with FATFS;
with MMIO;
with Console;
with SweetAda;

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
   use MIPS;
   use MIPS32;
   use Malta;
   use PCI;
   use IDE;
   use FATFS;

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
      UART16x50.TX (PIIX4_UART1_Descriptor, To_U8 (C));
   end Console_Putchar;

   procedure Console_Getchar (C : out Character) is
      Data : Unsigned_8;
   begin
      UART16x50.RX (PIIX4_UART1_Descriptor, Data);
      C := To_Ch (Data);
   end Console_Getchar;

   ----------------------------------------------------------------------------
   -- Setup
   ----------------------------------------------------------------------------
   procedure Setup is
      Status : Status_Type;
      PRId   : PRId_Type;
   begin
      -------------------------------------------------------------------------
      System.Secondary_Stack.SS_Init (BSP_SS_Stack, System.Parameters.Unspecified_Size);
      -------------------------------------------------------------------------
      HEX_DISPLAY := BOARD_REVISION;
      PCI_Init;
      PIIX4_PIC_Init;
      -- PIIX4 UARTs ----------------------------------------------------------
      PIIX4_UART1_Descriptor.Base_Address  := To_Address (PIIX4_BASEADDRESS + 16#0000_03F8#);
      PIIX4_UART1_Descriptor.Scale_Address := 0;
      PIIX4_UART1_Descriptor.Baud_Clock    := CLK_UART1M8;
      PIIX4_UART1_Descriptor.Read_8        := MMIO.Read'Access;
      PIIX4_UART1_Descriptor.Write_8       := MMIO.Write'Access;
      UART16x50.Init (PIIX4_UART1_Descriptor);
      PIIX4_UART2_Descriptor.Base_Address  := To_Address (PIIX4_BASEADDRESS + 16#0000_02F8#);
      PIIX4_UART2_Descriptor.Scale_Address := 0;
      PIIX4_UART2_Descriptor.Baud_Clock    := CLK_UART1M8;
      PIIX4_UART2_Descriptor.Read_8        := MMIO.Read'Access;
      PIIX4_UART2_Descriptor.Write_8       := MMIO.Write'Access;
      UART16x50.Init (PIIX4_UART2_Descriptor);
      -- Console --------------------------------------------------------------
      Console.Console_Descriptor.Write := Console_Putchar'Access;
      Console.Console_Descriptor.Read := Console_Getchar'Access;
      Console.Print (ANSI_CLS & ANSI_CUPHOME & VT100_LINEWRAP);
      -------------------------------------------------------------------------
      Console.Print ("MIPS Malta (QEMU emulator)", NL => True);
      -------------------------------------------------------------------------
      if Core.Debug_Flag then
         Console.Print ("Debug_Flag: ENABLED", NL => True);
      end if;
      -------------------------------------------------------------------------
      Core.Parameters_Dump;
      PRId := CP0_PRId_Read;
      Console.Print ("CPU ID         : ");
      case PRId.CPU_ID is
         when ID_5K  => Console.Print ("5K");
         when ID_24K => Console.Print ("24K");
         when others => null;
      end case;
      Console.Print_NewLine;
      Console.Print (PRId.Revision, Prefix => "Revision       : ", NL => True);
      Console.Print ("Company ID     : ");
      case PRId.Company_ID is
         when ID_COMPANY_LEGACY   => Console.Print ("LEGACY");
         when ID_COMPANY_MIPS     => Console.Print ("MIPS");
         when ID_COMPANY_BROADCOM => Console.Print ("Broadcom");
         when others              => null;
      end case;
      Console.Print_NewLine;
      Console.Print (PRId.Company_Options, Prefix => "Company Options: ", NL => True);
      -------------------------------------------------------------------------
      -- try to set coprocessor bits; if the bit can be set, the correspondent
      -- coprocessor is present
      -------------------------------------------------------------------------
      Status := CP0_SR_Read;
      Status.CU1 := True;
      Status.CU2 := True;
      CP0_SR_Write (Status);
      declare
         S : aliased Status_Type;
         X : aliased Unsigned_32 with
            Address => S'Address;
      begin
         S := CP0_SR_Read;
         Console.Print (X, Prefix => "Status: ", NL => True);
      end;
      Console.Print (CP0_Config_Read, Prefix => "Config: ", NL => True);
      -- CBUS UART ------------------------------------------------------------
      CBUS_UART_Descriptor.Base_Address  := To_Address (CBUS_UART_BASEADDRESS);
      CBUS_UART_Descriptor.Scale_Address := 3;
      CBUS_UART_Descriptor.Baud_Clock    := 3_686_400;
      CBUS_UART_Descriptor.Read_8        := MMIO.Read'Access;
      CBUS_UART_Descriptor.Write_8       := MMIO.Write'Access;
      UART16x50.Init (CBUS_UART_Descriptor);
      -- PIIX4 IDE ------------------------------------------------------------
      PIIX4_IDE_Descriptor.Base_Address  := To_Address (PIIX4_BASEADDRESS + 16#0000_01F0#);
      PIIX4_IDE_Descriptor.Scale_Address := 0;
      PIIX4_IDE_Descriptor.Read_8        := MMIO.Read'Access;
      PIIX4_IDE_Descriptor.Write_8       := MMIO.Write'Access;
      PIIX4_IDE_Descriptor.Read_16       := MMIO.ReadA'Access;
      PIIX4_IDE_Descriptor.Write_16      := MMIO.WriteA'Access;
      IDE.Init (PIIX4_IDE_Descriptor);
      -- VGA ------------------------------------------------------------------
      -- assume PCI0MEM0 memory space @ 0
      VGA.Init (MIPS.KSEG1_ADDRESS + 16#000A_0000#, MIPS.KSEG1_ADDRESS + 16#000B_8000#);
      VGA.Set_Mode (VGA.MODE12H);
      -------------------------------------------------------------------------
      MIPS32.Irq_Level_Set (16#3F#);
      MIPS32.Irq_Enable;
      Tclk_Init;
      -------------------------------------------------------------------------
   end Setup;

end BSP;

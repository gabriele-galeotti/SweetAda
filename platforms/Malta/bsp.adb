-----------------------------------------------------------------------------------------------------------------------
--                                                     SweetAda                                                      --
-----------------------------------------------------------------------------------------------------------------------
-- __HDS__                                                                                                           --
-- __FLN__ bsp.adb                                                                                                   --
-- __DSC__                                                                                                           --
-- __HSH__ e69de29bb2d1d6434b8b29ae775ad8c2e48c5391                                                                  --
-- __HDE__                                                                                                           --
-----------------------------------------------------------------------------------------------------------------------
-- Copyright (C) 2020-2026 Gabriele Galeotti                                                                         --
--                                                                                                                   --
-- SweetAda web page: http://sweetada.org                                                                            --
-- contact address: gabriele.galeotti@sweetada.org                                                                   --
-- This work is licensed under the terms of the MIT License.                                                         --
-- Please consult the LICENSE.txt file located in the top-level directory.                                           --
-----------------------------------------------------------------------------------------------------------------------

with System;
with System.Storage_Elements;
with Configure;
with Definitions;
with Bits;
with Secondary_Stack;
with MIPS;
with MIPS32;
with Core;
with Malta;
with VGA;
with Exceptions;
with PCI;
with MC146818A;
with UART16x50;
with IDE;
with FATFS;
with MMIO;
with Console;
with SweetAda;

package body BSP
   is

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

   procedure Console_Putchar
      (C : in Character)
      is
   begin
      UART16x50.TX (PIIX4_UART1_Descriptor, To_U8 (C));
   end Console_Putchar;

   procedure Console_Getchar
      (C : out Character)
      is
      Data : Unsigned_8;
   begin
      UART16x50.RX (PIIX4_UART1_Descriptor, Data);
      C := To_Ch (Data);
   end Console_Getchar;

   ----------------------------------------------------------------------------
   -- Setup
   ----------------------------------------------------------------------------
   procedure Setup
      is
      Status : Status_Type;
      PRId   : PRId_Type;
   begin
      -------------------------------------------------------------------------
      Secondary_Stack.Init;
      -------------------------------------------------------------------------
      HEX_DISPLAY := BOARD_REVISION;
      PCI_Init;
      PIIX4_PIC_Init;
      -- PIIX4 MC146818A RTC --------------------------------------------------
      PIIX4_RTC_Descriptor := (
         Base_Address  => System'To_Address (Malta.PIIX4_BASEADDRESS + 16#0000_0070#),
         Scale_Address => 0,
         Flags         => (others => <>),
         Read_8        => Malta.RTC_Register_Read'Access,
         Write_8       => Malta.RTC_Register_Write'Access
         );
      MC146818A.Init (PIIX4_RTC_Descriptor);
      -- PIIX4 UARTs ----------------------------------------------------------
      PIIX4_UART1_Descriptor := (
         Uart_Model    => UART16x50.UART16450,
         Base_Address  => System'To_Address (Malta.PIIX4_BASEADDRESS + 16#0000_03F8#),
         Scale_Address => 0,
         Baud_Clock    => CLK_UART1M8,
         Flags         => (PC_UART => True),
         Read_8        => MMIO.Read'Access,
         Write_8       => MMIO.Write'Access,
         Data_Queue    => ([others => 0], 0, 0, 0)
         );
      UART16x50.Init (PIIX4_UART1_Descriptor);
      PIIX4_UART2_Descriptor := (
         Uart_Model    => UART16x50.UART16450,
         Base_Address  => System'To_Address (Malta.PIIX4_BASEADDRESS + 16#0000_02F8#),
         Scale_Address => 0,
         Baud_Clock    => CLK_UART1M8,
         Flags         => (PC_UART => True),
         Read_8        => MMIO.Read'Access,
         Write_8       => MMIO.Write'Access,
         Data_Queue    => ([others => 0], 0, 0, 0)
         );
      UART16x50.Init (PIIX4_UART2_Descriptor);
      -- Console --------------------------------------------------------------
      Console.Console_Descriptor := (
         Write => Console_Putchar'Access,
         Read  => Console_Getchar'Access
         );
      Console.Print (ANSI_CLS & ANSI_CUPHOME & VT100_LINEWRAP);
      -------------------------------------------------------------------------
      Console.Print ("MIPS Malta (QEMU emulator)", NL => True);
      -------------------------------------------------------------------------
      if Core.Debug_Flag then
         Console.Print ("Debug_Flag: ENABLED", NL => True);
      end if;
      -------------------------------------------------------------------------
      PRId := CP0_PRId_Read;
      Console.Print ("CPU ID         : ");
      case PRId.CPU_ID is
         when ID_5K  => Console.Print ("5K");
         when ID_24K => Console.Print ("24K");
         when others => null;
      end case;
      Console.Print_NewLine;
      Console.Print (Prefix => "Revision       : ", Value => PRId.Revision, NL => True);
      Console.Print ("Company ID     : ");
      case PRId.Company_ID is
         when ID_COMPANY_LEGACY   => Console.Print ("LEGACY");
         when ID_COMPANY_MIPS     => Console.Print ("MIPS");
         when ID_COMPANY_BROADCOM => Console.Print ("Broadcom");
         when others              => null;
      end case;
      Console.Print_NewLine;
      Console.Print (Prefix => "Company Options: ", Value => PRId.Company_Options, NL => True);
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
         X : aliased Unsigned_32
            with Address => S'Address;
      begin
         S := CP0_SR_Read;
         Console.Print (Prefix => "Status: ", Value => X, NL => True);
      end;
      Console.Print (Prefix => "Config: ", Value => CP0_Config_Read, NL => True);
      -- CBUS UART ------------------------------------------------------------
      CBUS_UART_Descriptor := (
         Uart_Model    => UART16x50.UART16450,
         Base_Address  => System'To_Address (CBUS_UART_BASEADDRESS),
         Scale_Address => 3,
         Baud_Clock    => CLK_UART3M6,
         Flags         => (PC_UART => False),
         Read_8        => MMIO.Read'Access,
         Write_8       => MMIO.Write'Access,
         Data_Queue    => ([others => 0], 0, 0, 0)
         );
      UART16x50.Init (CBUS_UART_Descriptor);
      -- PIIX4 IDE ------------------------------------------------------------
      PIIX4_IDE_Descriptor := (
         Base_Address  => System'To_Address (Malta.PIIX4_BASEADDRESS + 16#0000_01F0#),
         Scale_Address => 0,
         Read_8        => MMIO.Read'Access,
         Write_8       => MMIO.Write'Access,
         Read_16       => MMIO.ReadA'Access,
         Write_16      => MMIO.WriteA'Access
         );
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

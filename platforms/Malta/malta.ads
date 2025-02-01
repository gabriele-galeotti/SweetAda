-----------------------------------------------------------------------------------------------------------------------
--                                                     SweetAda                                                      --
-----------------------------------------------------------------------------------------------------------------------
-- __HDS__                                                                                                           --
-- __FLN__ malta.ads                                                                                                 --
-- __DSC__                                                                                                           --
-- __HSH__ e69de29bb2d1d6434b8b29ae775ad8c2e48c5391                                                                  --
-- __HDE__                                                                                                           --
-----------------------------------------------------------------------------------------------------------------------
-- Copyright (C) 2020-2025 Gabriele Galeotti                                                                         --
--                                                                                                                   --
-- SweetAda web page: http://sweetada.org                                                                            --
-- contact address: gabriele.galeotti@sweetada.org                                                                   --
-- This work is licensed under the terms of the MIT License.                                                         --
-- Please consult the LICENSE.txt file located in the top-level directory.                                           --
-----------------------------------------------------------------------------------------------------------------------

with System;
with Interfaces;
with Configure;
with MIPS;
with PCI;
with GT64120;
with PIIX4;
with MC146818A;
with UART16x50;
with IDE;

package Malta
   is

   --========================================================================--
   --                                                                        --
   --                                                                        --
   --                               Public part                              --
   --                                                                        --
   --                                                                        --
   --========================================================================--

   use System;
   use Interfaces;
   use MIPS;
   use PCI;
   use GT64120;

   -- patch in BIOS ROM space, board ID = 0x420 (Malta board with CoreLV)
   BOARD_REVISION_ADDRESS : constant := KSEG1_ADDRESS + 16#1FC0_0010#;
   -- board peripherals
   LEDBAR_ADDRESS         : constant := KSEG1_ADDRESS + 16#1F00_0408#;
   HEX_DISPLAY_ADDRESS    : constant := KSEG1_ADDRESS + 16#1F00_0410#;
   CBUS_UART_BASEADDRESS  : constant := KSEG1_ADDRESS + 16#1F00_0900#;
   -- GT64120 default base address = 0x14000000
   GT64120_BASEADDRESS    : constant := KSEG1_ADDRESS + 16#1400_0000#;

   ----------------------------------------------------------------------------
   -- Malta peripherals
   ----------------------------------------------------------------------------

   BOARD_REVISION : aliased Unsigned_32
      with Address    => System'To_Address (BOARD_REVISION_ADDRESS),
           Volatile   => True,
           Import     => True,
           Convention => Ada;

   LEDBAR : aliased Unsigned_8
      with Address    => System'To_Address (LEDBAR_ADDRESS),
           Volatile   => True,
           Import     => True,
           Convention => Ada;

   HEX_DISPLAY : aliased Unsigned_32
      with Address    => System'To_Address (HEX_DISPLAY_ADDRESS),
           Volatile   => True,
           Import     => True,
           Convention => Ada;

   CBUS_UART_Descriptor : UART16x50.Descriptor_Type := UART16x50.DESCRIPTOR_INVALID;

   ----------------------------------------------------------------------------
   -- GT-64120A bridge
   ----------------------------------------------------------------------------

   GT64120_BUS_NUMBER    : constant Bus_Number_Type := 0;
   GT64120_DEVICE_NUMBER : constant Device_Number_Type := 0;

   GT_64120 : aliased GT64120_Type
      with Address    => System'To_Address (GT64120_BASEADDRESS),
           Volatile   => True,
           Import     => True,
           Convention => Ada;

   ----------------------------------------------------------------------------
   -- PIIX4 devices
   ----------------------------------------------------------------------------

   PIIX4_RTC_Descriptor   : aliased MC146818A.Descriptor_Type := MC146818A.DESCRIPTOR_INVALID;
   PIIX4_UART1_Descriptor : aliased UART16x50.Descriptor_Type := UART16x50.DESCRIPTOR_INVALID;
   PIIX4_UART2_Descriptor : aliased UART16x50.Descriptor_Type := UART16x50.DESCRIPTOR_INVALID;
   PIIX4_IDE_Descriptor   : aliased IDE.Descriptor_Type := IDE.DESCRIPTOR_INVALID;

   ----------------------------------------------------------------------------
   -- Timer
   ----------------------------------------------------------------------------

   -- CP0 Count runs at half the pipeline CPU clock
   CP0_TIMER_COUNT : constant := (Configure.CLK_FREQUENCY / Configure.TICK_FREQUENCY) / 2;

   procedure Tclk_Init;

   ----------------------------------------------------------------------------
   -- PCI
   ----------------------------------------------------------------------------

   function PCI_PortIn
      (Port : Unsigned_16)
      return Unsigned_32;

   procedure PCI_PortOut
      (Port  : in Unsigned_16;
       Value : in Unsigned_32);

   procedure PCI_Init;

   procedure PCI_Devices_Detect;

   procedure PIIX4_PIC_Init;

   ----------------------------------------------------------------------------
   -- MC146818A RTC accessors
   ----------------------------------------------------------------------------

   function RTC_Register_Read
      (Port_Address : Address)
      return Unsigned_8;

   procedure RTC_Register_Write
      (Port_Address : in Address;
       Value        : in Unsigned_8);

end Malta;

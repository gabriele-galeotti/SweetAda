-----------------------------------------------------------------------------------------------------------------------
--                                                     SweetAda                                                      --
-----------------------------------------------------------------------------------------------------------------------
-- __HDS__                                                                                                           --
-- __FLN__ malta.ads                                                                                                 --
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
with MIPS;
-- with MIPS.MIPS32;
with PCI;
with GT64120;
with UART16x50;
with IDE;

package Malta is

   --========================================================================--
   --                                                                        --
   --                                                                        --
   --                               Public part                              --
   --                                                                        --
   --                                                                        --
   --========================================================================--

   use System;
   use System.Storage_Elements;
   use Interfaces;
   use MIPS;
   -- use MIPS.MIPS32;
   use PCI;
   use GT64120;
   use UART16x50;
   use IDE;

   -- patch in BIOS ROM space, board ID = 0x420 (Malta board with CoreLV)
   BOARD_REVISION_ADDRESS : constant := KSEG1_ADDRESS + 16#1FC0_0010#;
   -- board peripherals
   LEDBAR_ADDRESS         : constant := KSEG1_ADDRESS + 16#1F00_0408#;
   HEX_DISPLAY_ADDRESS    : constant := KSEG1_ADDRESS + 16#1F00_0410#;
   CBUS_UART_BASEADDRESS  : constant := KSEG1_ADDRESS + 16#1F00_0900#;
   -- GT64120 default base address = 0x14000000
   GT64120_BASEADDRESS    : constant := KSEG1_ADDRESS + 16#1400_0000#;
   -- PCI devices I/O space
   PIIX4_BASEADDRESS      : constant := KSEG1_ADDRESS + 16#1800_0000#;

   ----------------------------------------------------------------------------
   -- Malta peripherals
   ----------------------------------------------------------------------------

   BOARD_REVISION : aliased Unsigned_32 with
      Address    => To_Address (BOARD_REVISION_ADDRESS),
      Volatile   => True,
      Import     => True,
      Convention => Ada;

   LEDBAR : aliased Unsigned_8 with
      Address    => To_Address (LEDBAR_ADDRESS),
      Volatile   => True,
      Import     => True,
      Convention => Ada;

   HEX_DISPLAY : aliased Unsigned_32 with
      Address    => To_Address (HEX_DISPLAY_ADDRESS),
      Volatile   => True,
      Import     => True,
      Convention => Ada;

   CBUS_UART_Descriptor : Uart16x50_Descriptor_Type := Uart16x50_DESCRIPTOR_INVALID;

   ----------------------------------------------------------------------------
   -- GT-64120A bridge
   ----------------------------------------------------------------------------

   GT64120_BUS_NUMBER    : constant Bus_Number_Type := 0;
   GT64120_DEVICE_NUMBER : constant Device_Number_Type := 0;

   GT_64120 : GT64120_Type with
      Address    => To_Address (GT64120_BASEADDRESS),
      Volatile   => True,
      Import     => True,
      Convention => Ada;

   ----------------------------------------------------------------------------
   -- PIIX4 devices
   ----------------------------------------------------------------------------

   PIIX4_UART1_Descriptor : Uart16x50_Descriptor_Type := Uart16x50_DESCRIPTOR_INVALID;
   PIIX4_UART2_Descriptor : Uart16x50_Descriptor_Type := Uart16x50_DESCRIPTOR_INVALID;
   PIIX4_IDE_Descriptor   : IDE_Descriptor_Type := IDE_DESCRIPTOR_INVALID;

   ----------------------------------------------------------------------------
   -- Timer
   ----------------------------------------------------------------------------

   -- CP0 Count runs at half the pipeline CPU clock
   -- CPU CLK = 320 MHz ---> 320000 = 0x4E200 ticks in 1 ms
   CP0_TIMER_COUNT : constant := 16#0004_E200# / 2;
   -- CPU CLK = 320 MHz ---> 3200000 = 0x30D400 ticks in 10 ms
   -- CP0_TIMER_COUNT : constant := 16#0030_D400# / 2;
   -- CPU CLK = 320 MHz ---> 32000000 = 0x1E84800 ticks in 100 ms
   -- CP0_TIMER_COUNT : constant := 16#01E8_4800# / 2;

   procedure Tclk_Init;

   ----------------------------------------------------------------------------
   -- PCI
   ----------------------------------------------------------------------------

   function PCI_PortIn (Port : Unsigned_16) return Unsigned_32;
   procedure PCI_PortOut (Port : in Unsigned_16; Value : in Unsigned_32);
   procedure PCI_Init;
   procedure PCI_Devices_Detect;
   procedure PIIX4_PIC_Init;

end Malta;

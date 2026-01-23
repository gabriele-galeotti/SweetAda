-----------------------------------------------------------------------------------------------------------------------
--                                                     SweetAda                                                      --
-----------------------------------------------------------------------------------------------------------------------
-- __HDS__                                                                                                           --
-- __FLN__ ksz8851snl.ads                                                                                            --
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
with Interfaces;
with Bits;

package KSZ8851SNL
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
   use Bits;

pragma Style_Checks (Off);

   ----------------------------------------------------------------------------
   -- KSZ8851SNL/SNLI
   -- DS00002381B
   ----------------------------------------------------------------------------

   -- 4.1.1 I/O REGISTERS

   CCR     : constant := 16#08#; -- Chip Configuration Register
   MARL    : constant := 16#10#; -- MAC Address Register Low
   MARM    : constant := 16#12#; -- MAC Address Register Middle
   MARH    : constant := 16#14#; -- MAC Address Register High
   OBCR    : constant := 16#20#; -- On-Chip Bus Control Register
   EEPCR   : constant := 16#22#; -- EEPROM Control Register
   MBIR    : constant := 16#24#; -- Memory BIST Info Register
   GRR     : constant := 16#26#; -- Global Reset Register
   WFCR    : constant := 16#2A#; -- Wakeup Frame Control Register
   WF0CRC0 : constant := 16#30#; -- Wakeup Frame 0 CRC0 Register
   WF0CRC1 : constant := 16#32#; -- Wakeup Frame 0 CRC1 Register
   WF0BM0  : constant := 16#34#; -- Wakeup Frame 0 Byte Mask 0 Register
   WF0BM1  : constant := 16#36#; -- Wakeup Frame 0 Byte Mask 1 Register
   WF0BM2  : constant := 16#38#; -- Wakeup Frame 0 Byte Mask 2 Register
   WF0BM3  : constant := 16#3A#; -- Wakeup Frame 0 Byte Mask 3 Register
   WF1CRC0 : constant := 16#40#; -- Wakeup Frame 1 CRC0 Register
   WF1CRC1 : constant := 16#42#; -- Wakeup Frame 1 CRC1 Register
   WF1BM0  : constant := 16#44#; -- Wakeup Frame 1 Byte Mask 0 Register
   WF1BM1  : constant := 16#46#; -- Wakeup Frame 1 Byte Mask 1 Register
   WF1BM2  : constant := 16#48#; -- Wakeup Frame 1 Byte Mask 2 Register
   WF1BM3  : constant := 16#4A#; -- Wakeup Frame 1 Byte Mask 3 Register
   WF2CRC0 : constant := 16#50#; -- Wakeup Frame 2 CRC0 Register
   WF2CRC1 : constant := 16#52#; -- Wakeup Frame 2 CRC1 Register
   WF2BM0  : constant := 16#54#; -- Wakeup Frame 2 Byte Mask 0 Register
   WF2BM1  : constant := 16#56#; -- Wakeup Frame 2 Byte Mask 1 Register
   WF2BM2  : constant := 16#58#; -- Wakeup Frame 2 Byte Mask 2 Register
   WF2BM3  : constant := 16#5A#; -- Wakeup Frame 2 Byte Mask 3 Register
   WF3CRC0 : constant := 16#60#; -- Wakeup Frame 3 CRC0 Register
   WF3CRC1 : constant := 16#62#; -- Wakeup Frame 3 CRC1 Register
   WF3BM0  : constant := 16#64#; -- Wakeup Frame 3 Byte Mask 0 Register
   WF3BM1  : constant := 16#66#; -- Wakeup Frame 3 Byte Mask 1 Register
   WF3BM2  : constant := 16#68#; -- Wakeup Frame 3 Byte Mask 2 Register
   WF3BM3  : constant := 16#6A#; -- Wakeup Frame 3 Byte Mask 3 Register
   TXCR    : constant := 16#70#; -- Transmit Control Register
   TXSR    : constant := 16#72#; -- Transmit Status Register
   RXCR1   : constant := 16#74#; -- Receive Control Register 1
   RXCR2   : constant := 16#76#; -- Receive Control Register 2
   TXMIR   : constant := 16#78#; -- TXQ Memory Information Register
   RXFHSR  : constant := 16#7C#; -- Receive Frame Header Status Register
   RXFHBCR : constant := 16#7E#; -- Receive Frame Header Byte Count Register
   TXQCR   : constant := 16#80#; -- TXQ Command Register
   RXQCR   : constant := 16#82#; -- RXQ Command Register
   TXFDPR  : constant := 16#84#; -- TX Frame Data Pointer Register
   RXFDPR  : constant := 16#86#; -- RX Frame Data Pointer Register
   RXDTTR  : constant := 16#8C#; -- RX Duration Timer Threshold Register
   RXDBCTR : constant := 16#8E#; -- RX Data Byte Count Threshold Register
   IER     : constant := 16#90#; -- Interrupt Enable Register
   ISR     : constant := 16#92#; -- Interrupt Status Register
   RXFCTR  : constant := 16#9C#; -- RX Frame Count & Threshold Register
   TXNTFSR : constant := 16#9E#; -- TX Next Total Frames Size Register
   MAHTR0  : constant := 16#A0#; -- MAC Address Hash Table Register 0
   MAHTR1  : constant := 16#A2#; -- MAC Address Hash Table Register 1
   MAHTR2  : constant := 16#A4#; -- MAC Address Hash Table Register 2
   MAHTR3  : constant := 16#A6#; -- MAC Address Hash Table Register 3
   FCLWR   : constant := 16#B0#; -- Flow Control Low Watermark Register
   FCHWR   : constant := 16#B2#; -- Flow Control High Watermark Register
   FCOWR   : constant := 16#B4#; -- Flow Control Overrun Watermark
   CIDER   : constant := 16#C0#; -- Chip ID and Enable Register
   CGCR    : constant := 16#C6#; -- Chip Global Control Register
   IACR    : constant := 16#C8#; -- Indirect Access Control Register
   IADLR   : constant := 16#D0#; -- Indirect Access Data Low Register
   IADHR   : constant := 16#D2#; -- Indirect Access Data High Register
   PMECR   : constant := 16#D4#; -- Power Management Event Control Register
   GSWUTR  : constant := 16#D6#; -- Go-Sleep & Wake-Up Time Register
   PHYRR   : constant := 16#D8#; -- PHY Reset Register
   P1MBCR  : constant := 16#E4#; -- PHY 1 MII-Register Basic Control Register
   P1MBSR  : constant := 16#E6#; -- PHY 1 MII-Register Basic Status Register
   PHY1ILR : constant := 16#E8#; -- PHY 1 PHY ID Low Register
   PHY1IHR : constant := 16#EA#; -- PHY 1 PHY ID High Register
   P1ANAR  : constant := 16#EC#; -- PHY 1 Auto-Negotiation Advertisement Register
   P1ANLPR : constant := 16#EE#; -- PHY 1 Auto-Negotiation Link Partner Ability Register
   P1SCLMD : constant := 16#F4#; -- Port 1 PHY Special Control/Status, LinkMD®
   P1CR    : constant := 16#F6#; -- Port 1 Control Register
   P1SR    : constant := 16#F8#; -- Port 1 Status Register

   -- 3.4 Serial Peripheral Interface (SPI)

   type OPCODE_REGS_Type is new Bits_2 range 2#00# .. 2#01#;

   REGREAD  : constant OPCODE_REGS_Type := 2#00#; -- Internal I/O Register Read
   REGWRITE : constant OPCODE_REGS_Type := 2#01#; -- Internal I/O Register Write

   type OPCODE_FIFO_Type is new Bits_2 range 2#10# .. 2#11#;

   RXQFIFO : constant OPCODE_FIFO_Type := 2#10#; -- RXQ FIFO Read
   TXQFIFO : constant OPCODE_FIFO_Type := 2#11#; -- TXQ FIFO Write

   type BYTE_ENABLE_Type is new Bits_4
      with Size => 4;

   BE0    : constant BYTE_ENABLE_Type := 2#0001#;
   BE01   : constant BYTE_ENABLE_Type := 2#0011#;
   BE012  : constant BYTE_ENABLE_Type := 2#0111#;
   BE0123 : constant BYTE_ENABLE_Type := 2#1111#;

   type Command_REGISTERS_Type is record
      DONTCARE         : Bits_4           := 0;
      Register_Address : Bits_6           := 0;       -- Register Address
      Byte_Enable      : BYTE_ENABLE_Type := BE0;     -- Byte Enable
      Opcode           : OPCODE_REGS_Type := REGREAD; -- Opcode
   end record
      with Bit_Order => Low_Order_First,
           Size      => 16;
   for Command_REGISTERS_Type use record
      DONTCARE         at 0 range  0 ..  3;
      Register_Address at 0 range  4 ..  9;
      Byte_Enable      at 0 range 10 .. 13;
      Opcode           at 0 range 14 .. 15;
   end record;

   type Command_TXQRXQ_Type is record
      DONTCARE : Bits_6           := 0;
      Opcode   : OPCODE_FIFO_Type := RXQFIFO; -- Opcode
   end record
      with Bit_Order => Low_Order_First,
           Size      => 8;
   for Command_TXQRXQ_Type use record
      DONTCARE at 0 range 0 .. 5;
      Opcode   at 0 range 6 .. 7;
   end record;

   ----------------------------------------------------------------------------
   -- Build the bit pattern for an internal register operation.
   ----------------------------------------------------------------------------
   function Command_REGISTERS
      (Opcode      : OPCODE_REGS_Type;
       Register    : Unsigned_8;
       Byte_Enable : BYTE_ENABLE_Type)
      return Bits_16;

   ----------------------------------------------------------------------------
   -- Build the bit pattern for FIFO data I/O.
   ----------------------------------------------------------------------------
   function Command_TXQRXQ
      (Opcode : OPCODE_FIFO_Type)
      return Bits_16;

pragma Style_Checks (On);

end KSZ8851SNL;

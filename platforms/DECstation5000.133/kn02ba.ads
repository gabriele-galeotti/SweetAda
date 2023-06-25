-----------------------------------------------------------------------------------------------------------------------
--                                                     SweetAda                                                      --
-----------------------------------------------------------------------------------------------------------------------
-- __HDS__                                                                                                           --
-- __FLN__ kn02ba.ads                                                                                                --
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
with Bits;
with MIPS;
with R3000;

package KN02BA is

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
   use Bits;

   MEMORY_CR_BASEADDRESS     : constant := 16#0C00_0000#; -- 32M space
   CPU_CR_BASEADDRESS        : constant := 16#0E00_0000#; -- 32M space

   TURBOCHANNEL0_BASEADDRESS : constant := 16#1000_0000#; -- 64M space

   TURBOCHANNEL1_BASEADDRESS : constant := 16#1400_0000#; -- 64M space

   TURBOCHANNEL2_BASEADDRESS : constant := 16#1800_0000#; -- 64M space

   TURBOCHANNEL3_BASEADDRESS : constant := 16#1C00_0000#; -- 64M space
   ROM_BASEADDRESS           : constant := TURBOCHANNEL3_BASEADDRESS + 16#0000_0000#; -- slot 0
   IOASIC_BASEADDRESS        : constant := TURBOCHANNEL3_BASEADDRESS + 16#0004_0000#; -- slot 1
   ETHER_BASEADDRESS         : constant := TURBOCHANNEL3_BASEADDRESS + 16#0008_0000#; -- slot 2
   LANCE_BASEADDRESS         : constant := TURBOCHANNEL3_BASEADDRESS + 16#000C_0000#; -- slot 3
   SCC0_BASEADDRESS          : constant := TURBOCHANNEL3_BASEADDRESS + 16#0010_0000#; -- slot 4 A = kbd/mouse, B = serial port "2"
   SCC1_BASEADDRESS          : constant := TURBOCHANNEL3_BASEADDRESS + 16#0018_0000#; -- slot 6 A = kbd/mouse, B = serial port "3"
   RTC_BASEADDRESS           : constant := TURBOCHANNEL3_BASEADDRESS + 16#0020_0000#; -- slot 8
   BOOTROM_BASEADDRESS       : constant := TURBOCHANNEL3_BASEADDRESS + 16#03C0_0000#; -- 0x1FC00000

   -- R3000 Status Register IM0..7 --------------------------------------------

   -- IM0 SW1
   -- IM1 SW2
   -- IM2 TURBOchannel SLOT 0
   -- IM3 TURBOchannel SLOT 1
   -- IM4 TURBOchannel SLOT 2
   -- IM5 I/O ASIC cascade
   -- IM6 HALT button
   -- IM7 FPU/R4k timer

   -- SSR System Support Register ---------------------------------------------

   type IOASIC_SSR_Type is
   record
      LED0        : Boolean := True;   -- .... O... rear LEDs, 0=on, 1=off
      LED1        : Boolean := True;   -- .... .O..
      LED2        : Boolean := True;   -- .... ..O.
      LED3        : Boolean := True;   -- .... ...O
      LED4        : Boolean := True;   -- O... ....
      LED5        : Boolean := True;   -- .O.. ....
      LED6        : Boolean := True;   -- ..O. ....
      LED7        : Boolean := True;   -- ...O ....
      LANCE_RESET : Boolean := False;  -- active low
      SCSI_RESET  : Boolean := False;  -- active low
      RTC_RESET   : Boolean := False;  -- active low
      SCC_RESET   : Boolean := False;  -- active low, SCC 0 & 1
      Unused1     : Bits_1 := 0;
      TXDIS0      : Boolean := False;  -- active low
      TXDIS1      : Boolean := False;  -- active low
      DIAGDN      : Boolean := False;
      Unused2     : Bits_16 := 0;
   end record with
      Bit_Order => Low_Order_First,
      Size      => 32;
   for IOASIC_SSR_Type use
   record
      LED0        at 0 range 0 .. 0;
      LED1        at 0 range 1 .. 1;
      LED2        at 0 range 2 .. 2;
      LED3        at 0 range 3 .. 3;
      LED4        at 0 range 4 .. 4;
      LED5        at 0 range 5 .. 5;
      LED6        at 0 range 6 .. 6;
      LED7        at 0 range 7 .. 7;
      LANCE_RESET at 0 range 8 .. 8;
      SCSI_RESET  at 0 range 9 .. 9;
      RTC_RESET   at 0 range 10 .. 10;
      SCC_RESET   at 0 range 11 .. 11;
      Unused1     at 0 range 12 .. 12;
      TXDIS0      at 0 range 13 .. 13;
      TXDIS1      at 0 range 14 .. 14;
      DIAGDN      at 0 range 15 .. 15;
      Unused2     at 0 range 16 .. 31;
   end record;

   IOASIC_SSR_ADDRESS : constant := IOASIC_BASEADDRESS + 16#0000_0100#;

   IOASIC_SSR : aliased IOASIC_SSR_Type with
      Address              => To_Address (MIPS.KSEG1_ADDRESS + IOASIC_SSR_ADDRESS),
      Volatile_Full_Access => True,
      Import               => True,
      Convention           => Ada;

   -- SIR/SIMR System Interrupt (Mask) Register -------------------------------

   -- .../include/asm-mips/dec/kn02ba.h
   -- I/O ASIC interrupt bits. Star marks denote non-IRQ status bits.
   type IOASIC_SI_Type is
   record
      PBNO      : Boolean;      -- button debouncer
      PBNC      : Boolean;      -- ~HALT button debouncer
      SCSI_FIFO : Boolean;      -- <ASC_DATA> SCSI data ready (for PIO)
      Unused1   : Bits_1 := 0;
      PSU       : Boolean;      -- power supply unit warning
      RTC       : Boolean;      -- DS1287 RTC
      SCC0      : Boolean;      -- SCC (Z85C30) serial #0
      SCC1      : Boolean;      -- SCC (Z85C30) serial #1
      LANCE     : Boolean;      -- LANCE (Am7990) Ethernet
      SCSI      : Boolean;      -- <ASC> (NCR53C94) SCSI
      NRMOD     : Boolean;      -- (*) NRMOD manufacturing jumper
      Unused2   : Bits_1 := 0;
      BUS       : Boolean;      -- memory, I/O bus read/write errors (timeout)
      Unused3   : Bits_1 := 0;
      NVRAM     : Boolean;      -- (*) NVRAM clear jumper
      Unused_4  : Bits_17 := 0;
   end record with
      Bit_Order => Low_Order_First,
      Size      => 32;
   for IOASIC_SI_Type use
   record
      PBNO      at 0 range 0 .. 0;
      PBNC      at 0 range 1 .. 1;
      SCSI_FIFO at 0 range 2 .. 2;
      Unused1   at 0 range 3 .. 3;
      PSU       at 0 range 4 .. 4;
      RTC       at 0 range 5 .. 5;
      SCC0      at 0 range 6 .. 6;
      SCC1      at 0 range 7 .. 7;
      LANCE     at 0 range 8 .. 8;
      SCSI      at 0 range 9 .. 9;
      NRMOD     at 0 range 10 .. 10;
      Unused2   at 0 range 11 .. 11;
      BUS       at 0 range 12 .. 12;
      Unused3   at 0 range 13 .. 13;
      NVRAM     at 0 range 14 .. 14;
      Unused_4  at 0 range 15 .. 31;
   end record;

   IOASIC_SIR_ADDRESS : constant := IOASIC_BASEADDRESS + 16#0000_0110#;

   IOASIC_SIR : aliased IOASIC_SI_Type with
      Address              => To_Address (MIPS.KSEG1_ADDRESS + IOASIC_SIR_ADDRESS),
      Volatile_Full_Access => True,
      Import               => True,
      Convention           => Ada;

   IOASIC_SIMR_ADDRESS : constant := IOASIC_BASEADDRESS + 16#0000_0120#;

   IOASIC_SIMR : aliased IOASIC_SI_Type with
      Address              => To_Address (MIPS.KSEG1_ADDRESS + IOASIC_SIMR_ADDRESS),
      Volatile_Full_Access => True,
      Import               => True,
      Convention           => Ada;

   -- SAR System Address Register ---------------------------------------------

   IOASIC_SAR_ADDRESS : constant := IOASIC_BASEADDRESS + 16#0000_0130#;

   IOASIC_SAR : aliased Unsigned_32 with
      Address              => To_Address (MIPS.KSEG1_ADDRESS + IOASIC_SAR_ADDRESS),
      Volatile_Full_Access => True,
      Import               => True,
      Convention           => Ada;

   -- Utility subprograms -----------------------------------------------------

   -- ROM code use a NOP when operating with I/O ports
   function Read32_NOP (Memory_Address : Address) return Unsigned_32 with
      Inline => True;

end KN02BA;

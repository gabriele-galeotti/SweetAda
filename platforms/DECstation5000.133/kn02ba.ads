-----------------------------------------------------------------------------------------------------------------------
--                                                     SweetAda                                                      --
-----------------------------------------------------------------------------------------------------------------------
-- __HDS__                                                                                                           --
-- __FLN__ kn02ba.ads                                                                                                --
-- __DSC__                                                                                                           --
-- __HSH__ e69de29bb2d1d6434b8b29ae775ad8c2e48c5391                                                                  --
-- __HDE__                                                                                                           --
-----------------------------------------------------------------------------------------------------------------------
-- Copyright (C) 2020, 2021 Gabriele Galeotti                                                                        --
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

   ----------------------------------------------------------------------------
   -- __REF__ gxemul-0.6.0.1/src/include/thirdparty/dec_kmin.h
   -- __REF__ gxemul-0.6.0.1/src/include/thirdparty/tc_ioasicreg.h
   ----------------------------------------------------------------------------

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

   -- IOASIC_CSR tc_ioasicreg.h

   type IOASIC_CSR_Type is
   record
      LED0         : Boolean;      -- .... O... rear LEDs, 0=on, 1=off
      LED1         : Boolean;      -- .... .O..
      LED2         : Boolean;      -- .... ..O.
      LED3         : Boolean;      -- .... ...O
      LED4         : Boolean;      -- O... ....
      LED5         : Boolean;      -- .O.. ....
      LED6         : Boolean;      -- ..O. ....
      LED7         : Boolean;      -- ...O ....
      LANCE_ENABLE : Boolean;
      SCSI_ENABLE  : Boolean;
      RTC_ENABLE   : Boolean;
      SCC_ENABLE   : Boolean;
      Unused1      : Bits.Bits_4;
      Unused2      : Bits.Bits_16;
   end record with
      Bit_Order => Low_Order_First,
      Size      => 32;
   for IOASIC_CSR_Type use
   record
      LED0         at 0 range 0 .. 0;
      LED1         at 0 range 1 .. 1;
      LED2         at 0 range 2 .. 2;
      LED3         at 0 range 3 .. 3;
      LED4         at 0 range 4 .. 4;
      LED5         at 0 range 5 .. 5;
      LED6         at 0 range 6 .. 6;
      LED7         at 0 range 7 .. 7;
      LANCE_ENABLE at 0 range 8 .. 8;
      SCSI_ENABLE  at 0 range 9 .. 9;
      RTC_ENABLE   at 0 range 10 .. 10;
      SCC_ENABLE   at 0 range 11 .. 11;
      Unused1      at 0 range 12 .. 15;
      Unused2      at 0 range 16 .. 31;
   end record;

   IOASIC_CSR_ADDRESS : constant := IOASIC_BASEADDRESS + 16#0000_0100#; -- = 0x1C040100

   IOASIC_CSR : IOASIC_CSR_Type with
      Address    => To_Address (MIPS.KSEG1_ADDRESS + IOASIC_CSR_ADDRESS),
      Volatile   => True,
      Import     => True,
      Convention => Ada;

   -- ROM code use a NOP when operating with I/O ports
   function Read32_NOP (Memory_Address : Address) return Unsigned_32;

private

   --========================================================================--
   --                                                                        --
   --                                                                        --
   --                              Private part                              --
   --                                                                        --
   --                                                                        --
   --========================================================================--

   pragma Inline (Read32_NOP);

end KN02BA;

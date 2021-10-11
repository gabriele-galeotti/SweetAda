-----------------------------------------------------------------------------------------------------------------------
--                                                     SweetAda                                                      --
-----------------------------------------------------------------------------------------------------------------------
-- __HDS__                                                                                                           --
-- __FLN__ amiga.ads                                                                                                 --
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
with Videofont8x8;

package Amiga is

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

   ----------------------------------------------------------------------------
   -- chipset clocks are 1/4 XTAL base frequency
   -- NTSC 28.63636 MHz
   -- PAL  28.37516 MHz
   ----------------------------------------------------------------------------

   CHIPSET_CLOCK_NTSC : constant := 7_159_090; -- CHIPSET_CLOCK_NTSC / 2 = 3_579_545
   CHIPSET_CLOCK_PAL  : constant := 7_093_790; -- CHIPSET_CLOCK_PAL / 2 = 3_546_895

   ----------------------------------------------------------------------------
   -- CUSTOM
   ----------------------------------------------------------------------------

   type SERDATR_Type is
   record
      DB      : Unsigned_8; -- Data bits
      STP_DB8 : Bits_1;     -- Stop bit if LONG, data bit if not
      STP     : Bits_1;     -- Stop bit
      Unused  : Bits_1;
      RXD     : Bits_1;     -- RXD pin receives UART serial data for direct bit test by the micro.
      TSRE    : Boolean;    -- Serial port transmit shift reg. empty
      TBE     : Boolean;    -- Serial port transmit buffer empty (mirror)
      RBF     : Boolean;    -- Serial port receive buffer full (mirror)
      OVRUN   : Boolean;    -- Serial port receiver overun
   end record with
      Bit_Order => Low_Order_First,
      Size      => 16;
   for SERDATR_Type use
   record
      DB      at 0 range 0 .. 7;
      STP_DB8 at 0 range 8 .. 8;
      STP     at 0 range 9 .. 9;
      Unused  at 0 range 10 .. 10;
      RXD     at 0 range 11 .. 11;
      TSRE    at 0 range 12 .. 12;
      TBE     at 0 range 13 .. 13;
      RBF     at 0 range 14 .. 14;
      OVRUN   at 0 range 15 .. 15;
   end record;

   type SERDAT_Type is
   record
      D : Unsigned_8; -- Data bits
      S : Unsigned_8; -- Stop bit
   end record with
      Bit_Order => Low_Order_First,
      Size      => 16;
   for SERDAT_Type use
   record
      D at 0 range 0 .. 7;
      S at 0 range 8 .. 15;
   end record;

   type SERPER_Type is
   record
      RATE : Bits_15; -- Defines baud rate=1/((N+1)*.2794 microseconds)
      LONG : Boolean; -- Defines serial receive as 9 bit word
   end record with
      Bit_Order => Low_Order_First,
      Size      => 16;
   for SERPER_Type use
   record
      RATE at 0 range 0 .. 14;
      LONG at 0 range 15 .. 15;
   end record;

   type CUSTOM_Type is
   record
      SERDATR : SERDATR_Type with Volatile_Full_Access => True;
      INTENAR : Unsigned_16  with Volatile_Full_Access => True;
      INTREQR : Unsigned_16  with Volatile_Full_Access => True;
      SERDAT  : SERDAT_Type  with Volatile_Full_Access => True;
      SERPER  : SERPER_Type  with Volatile_Full_Access => True;
      COP1LCH : Unsigned_32  with Volatile_Full_Access => True;
      COPJMP1 : Unsigned_16  with Volatile_Full_Access => True;
      DIWSTRT : Unsigned_16  with Volatile_Full_Access => True;
      DIWSTOP : Unsigned_16  with Volatile_Full_Access => True;
      DDFSTRT : Unsigned_16  with Volatile_Full_Access => True;
      DDFSTOP : Unsigned_16  with Volatile_Full_Access => True;
      DMACON  : Unsigned_16  with Volatile_Full_Access => True;
      INTENA  : Unsigned_16  with Volatile_Full_Access => True;
      INTREQ  : Unsigned_16  with Volatile_Full_Access => True;
      BPLCON0 : Unsigned_16  with Volatile_Full_Access => True;
      BPLCON1 : Unsigned_16  with Volatile_Full_Access => True;
      BPL1MOD : Unsigned_16  with Volatile_Full_Access => True;
      BPL2MOD : Unsigned_16  with Volatile_Full_Access => True;
      COLOR00 : Unsigned_16  with Volatile_Full_Access => True;
      COLOR01 : Unsigned_16  with Volatile_Full_Access => True;
      COLOR02 : Unsigned_16  with Volatile_Full_Access => True;
   end record;
   for CUSTOM_Type use
   record
      SERDATR at 16#0018# range 0 .. 15;
      INTENAR at 16#001C# range 0 .. 15;
      INTREQR at 16#001E# range 0 .. 15;
      SERDAT  at 16#0030# range 0 .. 15;
      SERPER  at 16#0032# range 0 .. 15;
      COP1LCH at 16#0080# range 0 .. 31;
      COPJMP1 at 16#0088# range 0 .. 15;
      DIWSTRT at 16#008E# range 0 .. 15;
      DIWSTOP at 16#0090# range 0 .. 15;
      DDFSTRT at 16#0092# range 0 .. 15;
      DDFSTOP at 16#0094# range 0 .. 15;
      DMACON  at 16#0096# range 0 .. 15;
      INTENA  at 16#009A# range 0 .. 15;
      INTREQ  at 16#009C# range 0 .. 15;
      BPLCON0 at 16#0100# range 0 .. 15;
      BPLCON1 at 16#0102# range 0 .. 15;
      BPL1MOD at 16#0108# range 0 .. 15;
      BPL2MOD at 16#010A# range 0 .. 15;
      COLOR00 at 16#0180# range 0 .. 15;
      COLOR01 at 16#0182# range 0 .. 15;
      COLOR02 at 16#0184# range 0 .. 15;
   end record;

   CUSTOM_BASEADDRESS : constant := 16#00DF_F000#;

   CUSTOM : aliased CUSTOM_Type with
      Address    => To_Address (CUSTOM_BASEADDRESS),
      Volatile   => True,
      Import     => True,
      Convention => Ada;

   -- INTENA Interrupt Enable register
   TBE   : constant := 2#0000_0000_0000_0001#;
   SOFT  : constant := 2#0000_0000_0000_0100#;
   PORTS : constant := 2#0000_0000_0000_1000#;
   VERTB : constant := 2#0000_0000_0010_0000#;
   EXTER : constant := 2#0010_0000_0000_0000#;
   INTEN : constant := 2#0100_0000_0000_0000#;

   LACE        : constant := 2#0000_0000_0000_0100#;
   BPU0        : constant := 2#0001_0000_0000_0000#;
   BPU1        : constant := 2#0010_0000_0000_0000#;
   BPU2        : constant := 2#0100_0000_0000_0000#;
   HRES        : constant := 2#1000_0000_0000_0000#;
   NBITPLANES1 : constant := BPU0;
   -- offsets of bit-plane pointer registers to be used in setup Copper
   BPL1PTH     : constant := 16#E0#;
   BPL1PTL     : constant := 16#E2#;
   BPL2PTH     : constant := 16#E4#;
   BPL2PTL     : constant := 16#E6#;
   -- DMACON
   -- 15 SET/CLR 0=clear, 1=set bits that are set to 1 below
   -- 14 BBUSY   Blitter busy status bit (read only)
   -- 13 BZERO   Blitter logic zero status bit (read only)
   -- 12         Reserved/Unused
   -- 11         Reserved/Unused
   -- 10 BLTPRI  Blitter priority, 0=give every 4th cycle to CPU
   -- 09 DMAEN   Enable all DMA below
   -- 08 BPLEN   Bit plane (raster) DMA
   -- 07 COPEN   Copper DMA
   -- 06 BLTEN   Blitter DMA
   -- 05 SPREN   Sprite DMA
   -- 04 DSKEN   Disk DMA
   -- 03 AUD3EN  Audio channel 3 DMA
   -- 02 AUD2EN  Audio channel 2 DMA
   -- 01 AUD1EN  Audio channel 1 DMA
   -- 00 AUD0EN  Audio channel 0 DMA
   DMAF_COPPER : constant := 2#0000_0000_1000_0000#;
   DMAF_RASTER : constant := 2#0000_0001_0000_0000#;
   DMAF_MASTER : constant := 2#0000_0010_0000_0000#;
   DMACON_SET  : constant := 2#1000_0000_0000_0000#;

   procedure INTENA_ClearAll with
      Inline => True;

   procedure INTENA_ClearBitMask (Value : in Unsigned_16) with
      Inline => True;

   procedure INTENA_SetBitMask (Value : in Unsigned_16) with
      Inline => True;

   procedure INTREQ_ClearAll with
      Inline => True;

   procedure INTREQ_ClearBitMask (Value : in Unsigned_16) with
      Inline => True;

   procedure INTREQ_SetBitMask (Value : in Unsigned_16) with
      Inline => True;

   ----------------------------------------------------------------------------
   -- OCS video
   ----------------------------------------------------------------------------

   VIDEO_WIDTH  : constant := 640;
   VIDEO_HEIGHT : constant := 256;

   -- keep in-sync with linker.lds address definition
   FRAMEBUFFER_BASEADDRESS : constant := 16#0003_0000#;

   Framebuffer : aliased Byte_Array (0 .. VIDEO_WIDTH * VIDEO_HEIGHT - 1) with
      Address    => To_Address (FRAMEBUFFER_BASEADDRESS),
      Volatile   => True,
      Import     => True,
      Convention => Ada;

   Copperlist : aliased U16_Array (0 .. 5) with
      Alignment               => 16#0000_1000#,
      Suppress_Initialization => True;

   subtype Video_X_Coordinate_Type is Natural range 0 .. VIDEO_WIDTH / Videofont8x8.Font_Width - 1;
   subtype Video_Y_Coordinate_Type is Natural range 0 .. VIDEO_HEIGHT / Videofont8x8.Font_Height - 1;

   procedure OCS_Setup;
   procedure OCS_Print (
                        X : in Video_X_Coordinate_Type;
                        Y : in Video_Y_Coordinate_Type;
                        C : in Character
                       );
   procedure OCS_Clear_Screen;
   procedure OCS_Print (
                        X : in Video_X_Coordinate_Type;
                        Y : in Video_Y_Coordinate_Type;
                        S : in String
                       );

   ----------------------------------------------------------------------------
   -- CIAs
   ----------------------------------------------------------------------------

   type CIA_PRA_Type is
   record
      PA0 : Boolean;
      PA1 : Boolean;
      PA2 : Boolean;
      PA3 : Boolean;
      PA4 : Boolean;
      PA5 : Boolean;
      PA6 : Boolean;
      PA7 : Boolean;
   end record with
      Bit_Order => Low_Order_First,
      Size      => 8;
   for CIA_PRA_Type use
   record
      PA0 at 0 range 0 .. 0;
      PA1 at 0 range 1 .. 1;
      PA2 at 0 range 2 .. 2;
      PA3 at 0 range 3 .. 3;
      PA4 at 0 range 4 .. 4;
      PA5 at 0 range 5 .. 5;
      PA6 at 0 range 6 .. 6;
      PA7 at 0 range 7 .. 7;
   end record;

   type CIA_PRB_Type is
   record
      PB0 : Boolean;
      PB1 : Boolean;
      PB2 : Boolean;
      PB3 : Boolean;
      PB4 : Boolean;
      PB5 : Boolean;
      PB6 : Boolean;
      PB7 : Boolean;
   end record with
      Bit_Order => Low_Order_First,
      Size      => 8;
   for CIA_PRB_Type use
   record
      PB0 at 0 range 0 .. 0;
      PB1 at 0 range 1 .. 1;
      PB2 at 0 range 2 .. 2;
      PB3 at 0 range 3 .. 3;
      PB4 at 0 range 4 .. 4;
      PB5 at 0 range 5 .. 5;
      PB6 at 0 range 6 .. 6;
      PB7 at 0 range 7 .. 7;
   end record;

   type CIA_DDRA_Type is
   record
      DPA0 : Boolean;
      DPA1 : Boolean;
      DPA2 : Boolean;
      DPA3 : Boolean;
      DPA4 : Boolean;
      DPA5 : Boolean;
      DPA6 : Boolean;
      DPA7 : Boolean;
   end record with
      Bit_Order => Low_Order_First,
      Size      => 8;
   for CIA_DDRA_Type use
   record
      DPA0 at 0 range 0 .. 0;
      DPA1 at 0 range 1 .. 1;
      DPA2 at 0 range 2 .. 2;
      DPA3 at 0 range 3 .. 3;
      DPA4 at 0 range 4 .. 4;
      DPA5 at 0 range 5 .. 5;
      DPA6 at 0 range 6 .. 6;
      DPA7 at 0 range 7 .. 7;
   end record;

   type CIA_DDRB_Type is
   record
      DPB0 : Boolean;
      DPB1 : Boolean;
      DPB2 : Boolean;
      DPB3 : Boolean;
      DPB4 : Boolean;
      DPB5 : Boolean;
      DPB6 : Boolean;
      DPB7 : Boolean;
   end record with
      Bit_Order => Low_Order_First,
      Size      => 8;
   for CIA_DDRB_Type use
   record
      DPB0 at 0 range 0 .. 0;
      DPB1 at 0 range 1 .. 1;
      DPB2 at 0 range 2 .. 2;
      DPB3 at 0 range 3 .. 3;
      DPB4 at 0 range 4 .. 4;
      DPB5 at 0 range 5 .. 5;
      DPB6 at 0 range 6 .. 6;
      DPB7 at 0 range 7 .. 7;
   end record;

--   type CIA_ICR_Type is
--   record
--   end record with
--      Bit_Order => Low_Order_First,
--      Size      => 8;
--   for CIA_ICR_Type use
--   record
--   end record;

   type CIA_Type is
   record
      PRA      : CIA_PRA_Type  with Volatile_Full_Access => True;
      PRB      : CIA_PRB_Type  with Volatile_Full_Access => True;
      DDRA     : CIA_DDRA_Type with Volatile_Full_Access => True;
      DDRB     : CIA_DDRA_Type with Volatile_Full_Access => True;
      TALO     : Unsigned_8    with Volatile_Full_Access => True;
      TAHI     : Unsigned_8    with Volatile_Full_Access => True;
      TBLO     : Unsigned_8    with Volatile_Full_Access => True;
      TBHI     : Unsigned_8    with Volatile_Full_Access => True;
      TOD10THS : Unsigned_8    with Volatile_Full_Access => True; -- TOD Counter Low Byte
      TODSEC   : Unsigned_8    with Volatile_Full_Access => True; -- TOD Counter Mid Byte
      TODMIN   : Unsigned_8    with Volatile_Full_Access => True; -- TOD Counter High Byte
      TODHR    : Unsigned_8    with Volatile_Full_Access => True; -- not connected
      SDR      : Unsigned_8    with Volatile_Full_Access => True; -- Serial Data Register
      ICR      : Unsigned_8    with Volatile_Full_Access => True;
      CRA      : Unsigned_8    with Volatile_Full_Access => True;
      CRB      : Unsigned_8    with Volatile_Full_Access => True;
   end record;
   for CIA_Type use
   record
      PRA      at 16#0000# range 0 .. 7;
      PRB      at 16#0100# range 0 .. 7;
      DDRA     at 16#0200# range 0 .. 7;
      DDRB     at 16#0300# range 0 .. 7;
      TALO     at 16#0400# range 0 .. 7;
      TAHI     at 16#0500# range 0 .. 7;
      TBLO     at 16#0600# range 0 .. 7;
      TBHI     at 16#0700# range 0 .. 7;
      TOD10THS at 16#0800# range 0 .. 7;
      TODSEC   at 16#0900# range 0 .. 7;
      TODMIN   at 16#0A00# range 0 .. 7;
      TODHR    at 16#0B00# range 0 .. 7;
      SDR      at 16#0C00# range 0 .. 7;
      ICR      at 16#0D00# range 0 .. 7;
      CRA      at 16#0E00# range 0 .. 7;
      CRB      at 16#0F00# range 0 .. 7;
   end record;

   CIAA_BASEADDRESS : constant := 16#00BF_E001#; -- wired on D16..D23

   CIAA : aliased CIA_Type with
      Address    => To_Address (CIAA_BASEADDRESS),
      Volatile   => True,
      Import     => True,
      Convention => Ada;

   -- CIA B PRA
   -- 0 BUSY - Centronics busy (parallel port pin 11)
   -- 1 POUT - Centronics paper out (pin 12)
   -- 2 SEL  - Centronics select (pin 13)
   -- 3 DSR  - RS232 data set ready (serial port pin 6)
   -- 4 CTS  - RS232 clear to send (pin 5)
   -- 5 DCD  - RS232 carrier detect (pin 8)
   -- 6 RTS  - RS232 request to send (pin 4)
   -- 7 DTR  - RS232 data terminal ready (pin 20)
   -- CIA B PRB
   -- 0 STEP - Move drive head by one track in direction specified by the DIR bit
   -- 1 DIR  - Direction to move drive head (1 = out to 0, 0 = in to track 79+)
   -- 2 SIDE - Select drive head (1 = bottom, 0 = top)
   -- 3 SEL0 - 0 = Select DF0:  1 = not selected
   -- 4 SEL1 - 0 = Select DF1:
   -- 5 SEL2 - 0 = Select DF2:
   -- 6 SEL3 - 0 = Select DF3:
   -- 7 MTR  - Motor on/off status (1 = motor off, 0 = motor on)

   CIAB_BASEADDRESS : constant := 16#00BF_D000#; -- wired on D24..D31

   CIAB : aliased CIA_Type with
      Address    => To_Address (CIAB_BASEADDRESS),
      Volatile   => True,
      Import     => True,
      Convention => Ada;

   procedure CIAA_ICR_ClearAll with
      Inline => True;

   procedure CIAA_ICR_ClearBitMask (Value : in Unsigned_8) with
      Inline => True;

   procedure CIAA_ICR_SetBitMask (Value : in Unsigned_8) with
      Inline => True;

   procedure Serialport_Init;

   procedure Serialport_RX (C : out Character);

   procedure Serialport_TX (C : in Character);

   procedure Tclk_Init;

   ----------------------------------------------------------------------------
   -- RTC
   ----------------------------------------------------------------------------

   RTC_BASEADDRESS : constant := 16#00D8_0001#; -- wired on D16..D23

   ----------------------------------------------------------------------------
   -- Zorro II
   ----------------------------------------------------------------------------

   ZORROII_CFGSPACE_BASEADDRESS : constant := 16#00E8_0000#;

   -- Zorro II memory space = 64k (32k 16-bit words)
   ZorroII_Cfg_Space : aliased U16_Array (0 .. 2**15 - 1) with
      Address    => To_Address (ZORROII_CFGSPACE_BASEADDRESS),
      Volatile   => True,
      Import     => True,
      Convention => Ada;

   function ZorroII_Signature_Read (Offset : Storage_Offset) return Unsigned_8 with
      Inline => True;

   ----------------------------------------------------------------------------
   -- IOEMU
   ----------------------------------------------------------------------------

   IOEMU_CIA_BASEADDRESS         : constant := CIAB_BASEADDRESS + 16#80#;
   IOEMU_SERIALPORT1_BASEADDRESS : constant := CIAB_BASEADDRESS + 16#C0#;
   IOEMU_SERIALPORT2_BASEADDRESS : constant := CIAB_BASEADDRESS + 16#E0#;

   -- IO0 @ 0x00BFD080
   IOEMU_CIA_IO0 : Unsigned_8 with
      Address    => To_Address (IOEMU_CIA_BASEADDRESS + 16#00#),
      Volatile   => True,
      Import     => True,
      Convention => Ada;
   -- IO1 @ 0x00BFD084
   IOEMU_CIA_IO1 : Unsigned_8 with
      Address    => To_Address (IOEMU_CIA_BASEADDRESS + 16#04#),
      Volatile   => True,
      Import     => True,
      Convention => Ada;
   -- IO2 @ 0x00BFD088
   IOEMU_CIA_IO2 : Unsigned_8 with
      Address    => To_Address (IOEMU_CIA_BASEADDRESS + 16#08#),
      Volatile   => True,
      Import     => True,
      Convention => Ada;
   -- IO3 @ 0x00BFD08C
   IOEMU_CIA_IO3 : Unsigned_8 with
      Address    => To_Address (IOEMU_CIA_BASEADDRESS + 16#0C#),
      Volatile   => True,
      Import     => True,
      Convention => Ada;
   -- IO4 @ 0x00BFD090
   IOEMU_CIA_IO4 : Unsigned_8 with
      Address    => To_Address (IOEMU_CIA_BASEADDRESS + 16#10#),
      Volatile   => True,
      Import     => True,
      Convention => Ada;
   -- IO5 @ 0x00BFD094
   IOEMU_CIA_IO5 : Unsigned_8 with
      Address    => To_Address (IOEMU_CIA_BASEADDRESS + 16#14#),
      Volatile   => True,
      Import     => True,
      Convention => Ada;
   -- IO6 @ 0x00BFD098
   IOEMU_CIA_IO6 : Unsigned_8 with
      Address    => To_Address (IOEMU_CIA_BASEADDRESS + 16#18#),
      Volatile   => True,
      Import     => True,
      Convention => Ada;
   -- IO7 @ 0x00BFD09C
   IOEMU_CIA_IO7 : Unsigned_8 with
      Address    => To_Address (IOEMU_CIA_BASEADDRESS + 16#1C#),
      Volatile   => True,
      Import     => True,
      Convention => Ada;

end Amiga;

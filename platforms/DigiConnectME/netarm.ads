-----------------------------------------------------------------------------------------------------------------------
--                                                     SweetAda                                                      --
-----------------------------------------------------------------------------------------------------------------------
-- __HDS__                                                                                                           --
-- __FLN__ netarm.ads                                                                                                --
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
with Bits;

package NETARM is

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

   -- Part number/version: 90000353_G
   -- Release date: September 2007
   -- www.digiembedded.com
   -- NS7520 Hardware Reference

   -- base address of the hardware in the NCC ASIC
   EFE_BASEADDRESS   : constant := 16#FF80_0000#;
   DMA_BASEADDRESS   : constant := 16#FF90_0000#;
   PC_BASEADDRESS    : constant := 16#FFA0_0000#;
   GEN_BASEADDRESS   : constant := 16#FFB0_0000#;
   MEM_BASEADDRESS   : constant := 16#FFC0_0000#;
   SER_BASEADDRESS   : constant := 16#FFD0_0000#;
   CACHE_BASEADDRESS : constant := 16#FFF0_0000#;

   -- NCC type
   NETA15   : constant := 4;
   NETA15_1 : constant := 5;
   NETA20M  : constant := 16;
   NETA20UM : constant := 40;         -- 0x28
   NETA40   : constant := 8;
   NETA40_1 : constant := NETA40 + 1;
   NETA40_2 : constant := NETA40 + 2;
   NETA40_3 : constant := NETA40 + 3;
   NETA40_4 : constant := NETA40 + 3;
   NETA50   : constant := 24;
   NETA50_1 : constant := NETA50 + 1;

   NETA_MAX_REVISIONS : constant := 3;

   CACHE_SIZE : constant := 8192; -- size of cache in bytes

   -- the following masks should be applied to (dma_sr_t *)->bitsi.isrc
   NCIP_MASK : constant := 8;
   ECIP_MASK : constant := 4;
   NRIP_MASK : constant := 2;
   CAIP_MASK : constant := 1;

   -- GEN_BASE registers ------------------------------------------------------

   SCR : Unsigned_32 with
      Address    => To_Address (GEN_BASEADDRESS + 16#0000#),
      Volatile   => True,
      Import     => True,
      Convention => Ada;

   SSR : Unsigned_32 with
      Address    => To_Address (GEN_BASEADDRESS + 16#0004#),
      Volatile   => True,
      Import     => True,
      Convention => Ada;

   -- PLL Control register

   type PLLCR_Type is
   record
      Reserved1 : Bits.Bits_24;
      PLLCNT    : Bits.Bits_4;
      Reserved2 : Bits.Bits_4;
   end record with
      Bit_Order => Low_Order_First,
      Size      => 32;
   for PLLCR_Type use
   record
      Reserved1 at 0 range 0 .. 23;
      PLLCNT    at 0 range 24 .. 27;
      Reserved2 at 0 range 28 .. 31;
   end record;

   PLLCR_ADDRESS : constant := GEN_BASEADDRESS + 16#0008#;

   PLL_Control : Unsigned_32 with
      Address    => To_Address (GEN_BASEADDRESS + 16#0008#),
      Volatile   => True,
      Import     => True,
      Convention => Ada;

   SWSR : Unsigned_32 with
      Address    => To_Address (GEN_BASEADDRESS + 16#000C#),
      Volatile   => True,
      Import     => True,
      Convention => Ada;

   TCR1 : Unsigned_32 with
      Address    => To_Address (GEN_BASEADDRESS + 16#0010#),
      Volatile   => True,
      Import     => True,
      Convention => Ada;

   TSR1 : Unsigned_32 with
      Address    => To_Address (GEN_BASEADDRESS + 16#0014#),
      Volatile   => True,
      Import     => True,
      Convention => Ada;

   TCR2 : Unsigned_32 with
      Address    => To_Address (GEN_BASEADDRESS + 16#0018#),
      Volatile   => True,
      Import     => True,
      Convention => Ada;

   TSR2 : Unsigned_32 with
      Address    => To_Address (GEN_BASEADDRESS + 16#001C#),
      Volatile   => True,
      Import     => True,
      Convention => Ada;

   PORTA : Unsigned_32 with
      Address    => To_Address (GEN_BASEADDRESS + 16#0020#),
      Volatile   => True,
      Import     => True,
      Convention => Ada;

   PORTB : Unsigned_32 with
      Address    => To_Address (GEN_BASEADDRESS + 16#0024#),
      Volatile   => True,
      Import     => True,
      Convention => Ada;

   PORTC : Unsigned_32 with
      Address    => To_Address (GEN_BASEADDRESS + 16#0028#),
      Volatile   => True,
      Import     => True,
      Convention => Ada;

   PLL_Settings : Unsigned_32 with
      Address    => To_Address (GEN_BASEADDRESS + 16#0040#),
      Volatile   => True,
      Import     => True,
      Convention => Ada;

   -- MEM_BASE registers ------------------------------------------------------

   MMCR : Unsigned_32 with
      Address    => To_Address (MEM_BASEADDRESS + 16#0000#),
      Volatile   => True,
      Import     => True,
      Convention => Ada;

   CSBAR0 : Unsigned_32 with
      Address    => To_Address (MEM_BASEADDRESS + 16#0010#),
      Volatile   => True,
      Import     => True,
      Convention => Ada;

   CSOR0A : Unsigned_32 with
      Address    => To_Address (MEM_BASEADDRESS + 16#0014#),
      Volatile   => True,
      Import     => True,
      Convention => Ada;

   CSOR0B : Unsigned_32 with
      Address    => To_Address (MEM_BASEADDRESS + 16#0018#),
      Volatile   => True,
      Import     => True,
      Convention => Ada;

   CSBAR1 : Unsigned_32 with
      Address    => To_Address (MEM_BASEADDRESS + 16#0020#),
      Volatile   => True,
      Import     => True,
      Convention => Ada;

   CSOR1A : Unsigned_32 with
      Address    => To_Address (MEM_BASEADDRESS + 16#0024#),
      Volatile   => True,
      Import     => True,
      Convention => Ada;

   CSOR1B : Unsigned_32 with
      Address    => To_Address (MEM_BASEADDRESS + 16#0028#),
      Volatile   => True,
      Import     => True,
      Convention => Ada;

   CSBAR2 : Unsigned_32 with
      Address    => To_Address (MEM_BASEADDRESS + 16#0030#),
      Volatile   => True,
      Import     => True,
      Convention => Ada;

   CSOR2A : Unsigned_32 with
      Address    => To_Address (MEM_BASEADDRESS + 16#0034#),
      Volatile   => True,
      Import     => True,
      Convention => Ada;

   CSOR2B : Unsigned_32 with
      Address    => To_Address (MEM_BASEADDRESS + 16#0038#),
      Volatile   => True,
      Import     => True,
      Convention => Ada;

   -- SER_BASE registers ------------------------------------------------------

   -- Serial Channel Control Register A

   type SCCRA_Type is
   record
      ETXDMA   : Boolean;     -- Interrupt enable: Enables transmit DMA requests
      ETXBC    : Boolean;     -- Interrupt enable: Transmit buffer closed
      ETXHALF  : Boolean;     -- Interrupt enable: Transmit FIFO half-empty
      ETXOBE   : Boolean;     -- Interrupt enable: Transmit register empty
      ETXCTS   : Boolean;     -- Interrupt enable: Change in CTS interrupt enable
      ERXDSR   : Boolean;     -- Interrupt enable: Change in DSR interrupt enable
      ERXRI    : Boolean;     -- Interrupt enable: Change in RI interrupt enable
      ERXDCD   : Boolean;     -- Interrupt enable: Change in DCD interrupt enable
      ERXDMA   : Boolean;     -- Interrupt enable: Enables receive DMA requests
      ERXBC    : Boolean;     -- Interrupt enable: Receive buffer closed
      ERXHALF  : Boolean;     -- Interrupt enable: Receive FIFO half-full
      ERXDRDY  : Boolean;     -- Interrupt enable: Receive register ready
      ERXORUN  : Boolean;     -- Interrupt enable: Receive overrun
      ERXPE    : Boolean;     -- Interrupt enable: Receive parity error
      ERXFE    : Boolean;     -- Interrupt enable: Receive framing error
      ERXBRK   : Boolean;     -- Interrupt enable: Receive break
      RTS      : Boolean;     -- Request-to-send active
      DTR      : Boolean;     -- Data terminal ready active
      OUT2     : Boolean;     -- General purpose output 1
      OUT1     : Boolean;     -- General purpose output 2
      LL       : Boolean;     -- Local loopback
      RL       : Boolean;     -- Remote loopback
      RTSRX    : Boolean;     -- Enable active RTS (only when RX FIFO has space)
      CTSTX    : Boolean;     -- Enable the transmitter with active CTS
      WLS      : Bits.Bits_2; -- Data word length select
      STOP     : Bits.Bits_1; -- Number of stop bits
      PE       : Boolean;     -- Parity enable
      EPS      : Boolean;     -- Even parity select
      STICKP   : Boolean;     -- Stick parity
      BRK      : Boolean;     -- Send break
      CE       : Boolean;     -- Channel enable
   end record with
      Bit_Order => Low_Order_First,
      Size      => 32;
   for SCCRA_Type use
   record
      ETXDMA  at 0 range 0 .. 0;
      ETXBC   at 0 range 1 .. 1;
      ETXHALF at 0 range 2 .. 2;
      ETXOBE  at 0 range 3 .. 3;
      ETXCTS  at 0 range 4 .. 4;
      ERXDSR  at 0 range 5 .. 5;
      ERXRI   at 0 range 6 .. 6;
      ERXDCD  at 0 range 7 .. 7;
      ERXDMA  at 0 range 8 .. 8;
      ERXBC   at 0 range 9 .. 9;
      ERXHALF at 0 range 10 .. 10;
      ERXDRDY at 0 range 11 .. 11;
      ERXORUN at 0 range 12 .. 12;
      ERXPE   at 0 range 13 .. 13;
      ERXFE   at 0 range 14 .. 14;
      ERXBRK  at 0 range 15 .. 15;
      RTS     at 0 range 16 .. 16;
      DTR     at 0 range 17 .. 17;
      OUT2    at 0 range 18 .. 18;
      OUT1    at 0 range 19 .. 19;
      LL      at 0 range 20 .. 20;
      RL      at 0 range 21 .. 21;
      RTSRX   at 0 range 22 .. 22;
      CTSTX   at 0 range 23 .. 23;
      WLS     at 0 range 24 .. 25;
      STOP    at 0 range 26 .. 26;
      PE      at 0 range 27 .. 27;
      EPS     at 0 range 28 .. 28;
      STICKP  at 0 range 29 .. 29;
      BRK     at 0 range 30 .. 30;
      CE      at 0 range 31 .. 31;
   end record;

   SCCRA_ADDRESS : constant := SER_BASEADDRESS + 16#00#;

   SCCRA : aliased SCCRA_Type with
      Address              => To_Address (SCCRA_ADDRESS),
      Volatile_Full_Access => True,
      Import               => True,
      Convention           => Ada;

   -- Serial Channel Control Register B

   type SCCRB_Type is
   record
      Reserved1 : Bits.Bits_17;
      MAM2      : Boolean;     -- Match address mode 2
      MAM1      : Boolean;     -- Match address mode 1
      BITORDR   : Boolean;     -- Bit ordering
      MODE      : Bits.Bits_2; -- SCC mode
      Reserved2 : Bits.Bits_4;
      RCGT      : Boolean;     -- Enable receive character gap timer
      RBGT      : Boolean;     -- Enable receive buffer gap timer
      RDM4      : Boolean;     -- Enable receive data match 4
      RDM3      : Boolean;     -- Enable receive data match 3
      RDM2      : Boolean;     -- Enable receive data match 2
      RDM1      : Boolean;     -- Enable receive data match 1
   end record with
      Bit_Order => Low_Order_First,
      Size      => 32;
   for SCCRB_Type use
   record
      Reserved1 at 0 range 0 .. 16;
      MAM2      at 0 range 17 .. 17;
      MAM1      at 0 range 18 .. 18;
      BITORDR   at 0 range 19 .. 19;
      MODE      at 0 range 20 .. 21;
      Reserved2 at 0 range 22 .. 25;
      RCGT      at 0 range 26 .. 26;
      RBGT      at 0 range 27 .. 27;
      RDM4      at 0 range 28 .. 28;
      RDM3      at 0 range 29 .. 29;
      RDM2      at 0 range 30 .. 30;
      RDM1      at 0 range 31 .. 31;
   end record;

   SCCRB_ADDRESS : constant := SER_BASEADDRESS + 16#04#;

   SCCRB : aliased SCCRB_Type with
      Address              => To_Address (SCCRB_ADDRESS),
      Volatile_Full_Access => True,
      Import               => True,
      Convention           => Ada;

   -- Serial Channel Status Register

   type SCSR_Type is
   record
      TXEMPTY  : Boolean;
      TXBC     : Boolean;
      TXHALF   : Boolean;
      TXRDY    : Boolean;
      TXCTSI   : Boolean;
      RXDSRI   : Boolean;
      RXRII    : Boolean;
      RXDCDI   : Boolean;
      RXFULL   : Boolean;
      RXBC     : Boolean;
      RXHALF   : Boolean;
      RXRDY    : Boolean;
      RXOVER   : Boolean;
      RXPE     : Boolean;
      RXFE     : Boolean;
      RXBRK    : Boolean;
      CTS      : Boolean;
      DSR      : Boolean;
      RI       : Boolean;
      DCD      : Boolean;
      RXFDB    : Bits.Bits_2;
      Reserved : Bits.Bits_4;
      CGAP     : Boolean;
      BGAP     : Boolean;
      MATCH4   : Boolean;
      MATCH3   : Boolean;
      MATCH2   : Boolean;
      MATCH1   : Boolean;
   end record with
      Bit_Order => Low_Order_First,
      Size      => 32;
   for SCSR_Type use
   record
      TXEMPTY  at 0 range 0 .. 0;
      TXBC     at 0 range 1 .. 1;
      TXHALF   at 0 range 2 .. 2;
      TXRDY    at 0 range 3 .. 3;
      TXCTSI   at 0 range 4 .. 4;
      RXDSRI   at 0 range 5 .. 5;
      RXRII    at 0 range 6 .. 6;
      RXDCDI   at 0 range 7 .. 7;
      RXFULL   at 0 range 8 .. 8;
      RXBC     at 0 range 9 .. 9;
      RXHALF   at 0 range 10 .. 10;
      RXRDY    at 0 range 11 .. 11;
      RXOVER   at 0 range 12 .. 12;
      RXPE     at 0 range 13 .. 13;
      RXFE     at 0 range 14 .. 14;
      RXBRK    at 0 range 15 .. 15;
      CTS      at 0 range 16 .. 16;
      DSR      at 0 range 17 .. 17;
      RI       at 0 range 18 .. 18;
      DCD      at 0 range 19 .. 19;
      RXFDB    at 0 range 20 .. 21;
      Reserved at 0 range 22 .. 25;
      CGAP     at 0 range 26 .. 26;
      BGAP     at 0 range 27 .. 27;
      MATCH4   at 0 range 28 .. 28;
      MATCH3   at 0 range 29 .. 29;
      MATCH2   at 0 range 30 .. 30;
      MATCH1   at 0 range 31 .. 31;
   end record;

   SCSR_ADDRESS : constant := SER_BASEADDRESS + 16#08#;

   SCSR : aliased SCSR_Type with
      Address              => To_Address (SCSR_ADDRESS),
      Volatile_Full_Access => True,
      Import               => True,
      Convention           => Ada;

   -- Serial Channel Bit-Rate Generator Reg

   TMODE_16X       : constant := 0;
   TMODE_TDCR_RDCR : constant := 1;

   BRG_FXTALE   : constant := 16#00#; -- Input clock defined by FXTALE
   BRG_FSYSCLK  : constant := 16#01#; -- Input clock defined by FSYSCLK
   BRG_PORTA4B4 : constant := 16#10#; -- Input clock defined by input on PORTA4/B4
   BRG_PORTC5C7 : constant := 16#11#; -- Input clock defined by input on PORTC5/C7

   type SCBRGR_Type is
   record
      NREG      : Bits.Bits_11; -- BRG frequency
      Reserved1 : Bits.Bits_1;
      RICS      : Boolean;
      RSVD      : Boolean;
      TICS      : Boolean;
      Reserved2 : Bits.Bits_1;
      RDCR      : Bits.Bits_2;
      Reserved3 : Bits.Bits_1;
      TDCR      : Bits.Bits_2;
      CLKINV    : Boolean;
      RXCINV    : Boolean;
      TXCINV    : Boolean;
      CLKMUX    : Bits.Bits_2;
      TXEXT     : Boolean;
      RXEXT     : Boolean;
      TXSRC     : Boolean;
      RXSRC     : Boolean;
      TMODE     : Bits.Bits_1;
      EBIT      : Boolean;
   end record with
      Bit_Order => Low_Order_First,
      Size      => 32;
   for SCBRGR_Type use
   record
      NREG      at 0 range 0 .. 10;
      Reserved1 at 0 range 11 .. 11;
      RICS      at 0 range 12 .. 12;
      RSVD      at 0 range 13 .. 13;
      TICS      at 0 range 14 .. 14;
      Reserved2 at 0 range 15 .. 15;
      RDCR      at 0 range 16 .. 17;
      Reserved3 at 0 range 18 .. 18;
      TDCR      at 0 range 19 .. 20;
      CLKINV    at 0 range 21 .. 21;
      RXCINV    at 0 range 22 .. 22;
      TXCINV    at 0 range 23 .. 23;
      CLKMUX    at 0 range 24 .. 25;
      TXEXT     at 0 range 26 .. 26;
      RXEXT     at 0 range 27 .. 27;
      TXSRC     at 0 range 28 .. 28;
      RXSRC     at 0 range 29 .. 29;
      TMODE     at 0 range 30 .. 30;
      EBIT      at 0 range 31 .. 31;
   end record;

   SCBRGR_ADDRESS : constant := SER_BASEADDRESS + 16#0C#;

   SCBRGR : aliased SCBRGR_Type with
      Address              => To_Address (SCBRGR_ADDRESS),
      Volatile_Full_Access => True,
      Import               => True,
      Convention           => Ada;

   -- Serial Channel FIFO registers

   type SCFIFOR_Type is
   record
      DATA : Bits.U8_Array (0 .. 3);
   end record with
      Size => 4 * 8;

   SCFIFOR_ADDRESS : constant := SER_BASEADDRESS + 16#10#;

   SCFIFOR : aliased SCFIFOR_Type with
      Address    => To_Address (SCFIFOR_ADDRESS),
      Volatile   => True,
      Import     => True,
      Convention => Ada;

   -- subprograms

   procedure Tclk_Init;

end NETARM;

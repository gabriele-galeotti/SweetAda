-----------------------------------------------------------------------------------------------------------------------
--                                                     SweetAda                                                      --
-----------------------------------------------------------------------------------------------------------------------
-- __HDS__                                                                                                           --
-- __FLN__ netarm.ads                                                                                                --
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
with System.Storage_Elements;
with Interfaces;
with Definitions;
with Bits;

package NETARM
   with Preelaborate => True
   is

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
   use Definitions;
   use Bits;

pragma Style_Checks (Off);

   ----------------------------------------------------------------------------
   -- Part number/version: 90000353_G
   -- Release date: September 2007
   -- www.digiembedded.com
   -- NS7520 Hardware Reference
   ----------------------------------------------------------------------------

   -- base address of the hardware in the NCC ASIC
   EFE_BASEADDRESS   : constant := 16#FF80_0000#;
   DMA_BASEADDRESS   : constant := 16#FF90_0000#;
   PC_BASEADDRESS    : constant := 16#FFA0_0000#;
   GEN_BASEADDRESS   : constant := 16#FFB0_0000#;
   MEM_BASEADDRESS   : constant := 16#FFC0_0000#;
   SER_BASEADDRESS   : constant := 16#FFD0_0000#;
   CACHE_BASEADDRESS : constant := 16#FFF0_0000#;

   -- NCC types
   NETA15   : constant := 4;          -- 0x04
   NETA15_1 : constant := 5;          -- 0x05
   NETA20M  : constant := 16;         -- 0x10
   NETA20UM : constant := 40;         -- 0x28
   NETA40   : constant := 8;          -- 0x08
   NETA40_1 : constant := NETA40 + 1; -- 0x09
   NETA40_2 : constant := NETA40 + 2; -- 0x0A
   NETA40_3 : constant := NETA40 + 3; -- 0x0B
   NETA40_4 : constant := NETA40 + 3; -- 0x0B
   NETA50   : constant := 24;         -- 0x18
   NETA50_1 : constant := NETA50 + 1; -- 0x19

   NETA_MAX_REVISIONS : constant := 3;

   CACHE_SIZE : constant := kB8; -- size of cache in bytes

   -- the following masks should be applied to (dma_sr_t *)->bitsi.isrc
   NCIP_MASK : constant := 8;
   ECIP_MASK : constant := 4;
   NRIP_MASK : constant := 2;
   CAIP_MASK : constant := 1;

   ----------------------------------------------------------------------------
   -- GEN_BASE registers
   ----------------------------------------------------------------------------

   SCR : aliased Unsigned_32
      with Address              => To_Address (GEN_BASEADDRESS + 16#0000#),
           Volatile_Full_Access => True,
           Import               => True,
           Convention           => Ada;

   SSR : aliased Unsigned_32
      with Address              => To_Address (GEN_BASEADDRESS + 16#0004#),
           Volatile_Full_Access => True,
           Import               => True,
           Convention           => Ada;

   SWSR : aliased Unsigned_32
      with Address              => To_Address (GEN_BASEADDRESS + 16#000C#),
           Volatile_Full_Access => True,
           Import               => True,
           Convention           => Ada;

   ----------------------------------------------------------------------------
   -- PLL registers
   ----------------------------------------------------------------------------

   type PLL_Control_Type is record
      Reserved1 : Bits_24;
      PLLCNT    : Bits_4;
      Reserved2 : Bits_4;
   end record
      with Bit_Order => Low_Order_First,
           Size      => 32;
   for PLL_Control_Type use record
      Reserved1 at 0 range  0 .. 23;
      PLLCNT    at 0 range 24 .. 27;
      Reserved2 at 0 range 28 .. 31;
   end record;

   PLL_Control : aliased PLL_Control_Type
      with Address              => To_Address (GEN_BASEADDRESS + 16#0008#),
           Volatile_Full_Access => True,
           Import               => True,
           Convention           => Ada;

   PLL_Settings : aliased Unsigned_32
      with Address              => To_Address (GEN_BASEADDRESS + 16#0040#),
           Volatile_Full_Access => True,
           Import               => True,
           Convention           => Ada;

   ----------------------------------------------------------------------------
   -- TIMER registers
   ----------------------------------------------------------------------------

   TCR1 : aliased Unsigned_32
      with Address              => To_Address (GEN_BASEADDRESS + 16#0010#),
           Volatile_Full_Access => True,
           Import               => True,
           Convention           => Ada;

   TSR1 : aliased Unsigned_32
      with Address              => To_Address (GEN_BASEADDRESS + 16#0014#),
           Volatile_Full_Access => True,
           Import               => True,
           Convention           => Ada;

   TCR2 : aliased Unsigned_32
      with Address              => To_Address (GEN_BASEADDRESS + 16#0018#),
           Volatile_Full_Access => True,
           Import               => True,
           Convention           => Ada;

   TSR2 : aliased Unsigned_32
      with Address              => To_Address (GEN_BASEADDRESS + 16#001C#),
           Volatile_Full_Access => True,
           Import               => True,
           Convention           => Ada;

   ----------------------------------------------------------------------------
   -- PORTA/PORTC registers
   ----------------------------------------------------------------------------

   type LEBitmap_8_Idx_Type is (bi7, bi6, bi5, bi4, bi3, bi2, bi1, bi0);

   type LEBitmap_8 is array (LEBitmap_8_Idx_Type) of Boolean
      with Component_Size => 1,
           Size           => 8;

   -- PORTA Configuration register

   type PORTA_Type is record
      ADATA    : LEBitmap_8;
      Reserved : Bits_8;
      ADIR     : LEBitmap_8;
      AMODE    : LEBitmap_8;
   end record
      with Bit_Order => Low_Order_First,
           Size      => 32;
   for PORTA_Type use record
      ADATA    at 0 range  0 ..  7;
      Reserved at 0 range  8 .. 15;
      ADIR     at 0 range 16 .. 23;
      AMODE    at 0 range 24 .. 31;
   end record;

   PORTA : aliased PORTA_Type
      with Address              => To_Address (GEN_BASEADDRESS + 16#0020#),
           Volatile_Full_Access => True,
           Import               => True,
           Convention           => Ada;

   -- PORTC Configuration register

   type PORTC_Type is record
      CDATA : LEBitmap_8;
      CSF   : LEBitmap_8;
      CDIR  : LEBitmap_8;
      CMODE : LEBitmap_8;
   end record
      with Bit_Order => Low_Order_First,
           Size      => 32;
   for PORTC_Type use record
      CDATA at 0 range  0 ..  7;
      CSF   at 0 range  8 .. 15;
      CDIR  at 0 range 16 .. 23;
      CMODE at 0 range 24 .. 31;
   end record;

   PORTC : aliased PORTC_Type
      with Address              => To_Address (GEN_BASEADDRESS + 16#0028#),
           Volatile_Full_Access => True,
           Import               => True,
           Convention           => Ada;

   ----------------------------------------------------------------------------
   -- MEM_BASE registers
   ----------------------------------------------------------------------------

   MMCR : aliased Unsigned_32
      with Address              => To_Address (MEM_BASEADDRESS + 16#0000#),
           Volatile_Full_Access => True,
           Import               => True,
           Convention           => Ada;

   CSBAR0 : aliased Unsigned_32
      with Address              => To_Address (MEM_BASEADDRESS + 16#0010#),
           Volatile_Full_Access => True,
           Import               => True,
           Convention           => Ada;

   CSOR0A : aliased Unsigned_32
      with Address              => To_Address (MEM_BASEADDRESS + 16#0014#),
           Volatile_Full_Access => True,
           Import               => True,
           Convention           => Ada;

   CSOR0B : aliased Unsigned_32
      with Address              => To_Address (MEM_BASEADDRESS + 16#0018#),
           Volatile_Full_Access => True,
           Import               => True,
           Convention           => Ada;

   CSBAR1 : aliased Unsigned_32
      with Address              => To_Address (MEM_BASEADDRESS + 16#0020#),
           Volatile_Full_Access => True,
           Import               => True,
           Convention           => Ada;

   CSOR1A : aliased Unsigned_32
      with Address              => To_Address (MEM_BASEADDRESS + 16#0024#),
           Volatile_Full_Access => True,
           Import               => True,
           Convention           => Ada;

   CSOR1B : aliased Unsigned_32
      with Address              => To_Address (MEM_BASEADDRESS + 16#0028#),
           Volatile_Full_Access => True,
           Import               => True,
           Convention           => Ada;

   CSBAR2 : aliased Unsigned_32
      with Address              => To_Address (MEM_BASEADDRESS + 16#0030#),
           Volatile_Full_Access => True,
           Import               => True,
           Convention           => Ada;

   CSOR2A : aliased Unsigned_32
      with Address              => To_Address (MEM_BASEADDRESS + 16#0034#),
           Volatile_Full_Access => True,
           Import               => True,
           Convention           => Ada;

   CSOR2B : aliased Unsigned_32
      with Address              => To_Address (MEM_BASEADDRESS + 16#0038#),
           Volatile_Full_Access => True,
           Import               => True,
           Convention           => Ada;

   ----------------------------------------------------------------------------
   -- SER_BASE registers
   ----------------------------------------------------------------------------

   -- Serial Channel Control Register A

   type SCCRA_Type is record
      ETXDMA   : Boolean; -- Interrupt enable: Enables transmit DMA requests
      ETXBC    : Boolean; -- Interrupt enable: Transmit buffer closed
      ETXHALF  : Boolean; -- Interrupt enable: Transmit FIFO half-empty
      ETXOBE   : Boolean; -- Interrupt enable: Transmit register empty
      ETXCTS   : Boolean; -- Interrupt enable: Change in CTS interrupt enable
      ERXDSR   : Boolean; -- Interrupt enable: Change in DSR interrupt enable
      ERXRI    : Boolean; -- Interrupt enable: Change in RI interrupt enable
      ERXDCD   : Boolean; -- Interrupt enable: Change in DCD interrupt enable
      ERXDMA   : Boolean; -- Interrupt enable: Enables receive DMA requests
      ERXBC    : Boolean; -- Interrupt enable: Receive buffer closed
      ERXHALF  : Boolean; -- Interrupt enable: Receive FIFO half-full
      ERXDRDY  : Boolean; -- Interrupt enable: Receive register ready
      ERXORUN  : Boolean; -- Interrupt enable: Receive overrun
      ERXPE    : Boolean; -- Interrupt enable: Receive parity error
      ERXFE    : Boolean; -- Interrupt enable: Receive framing error
      ERXBRK   : Boolean; -- Interrupt enable: Receive break
      RTS      : Boolean; -- Request-to-send active
      DTR      : Boolean; -- Data terminal ready active
      OUT2     : Boolean; -- General purpose output 1
      OUT1     : Boolean; -- General purpose output 2
      LL       : Boolean; -- Local loopback
      RL       : Boolean; -- Remote loopback
      RTSRX    : Boolean; -- Enable active RTS (only when RX FIFO has space)
      CTSTX    : Boolean; -- Enable the transmitter with active CTS
      WLS      : Bits_2;  -- Data word length select
      STOP     : Bits_1;  -- Number of stop bits
      PE       : Boolean; -- Parity enable
      EPS      : Boolean; -- Even parity select
      STICKP   : Boolean; -- Stick parity
      BRK      : Boolean; -- Send break
      CE       : Boolean; -- Channel enable
   end record
      with Bit_Order => Low_Order_First,
           Size      => 32;
   for SCCRA_Type use
   record
      ETXDMA  at 0 range  0 ..  0;
      ETXBC   at 0 range  1 ..  1;
      ETXHALF at 0 range  2 ..  2;
      ETXOBE  at 0 range  3 ..  3;
      ETXCTS  at 0 range  4 ..  4;
      ERXDSR  at 0 range  5 ..  5;
      ERXRI   at 0 range  6 ..  6;
      ERXDCD  at 0 range  7 ..  7;
      ERXDMA  at 0 range  8 ..  8;
      ERXBC   at 0 range  9 ..  9;
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

   SCCRA : aliased SCCRA_Type
      with Address              => To_Address (SCCRA_ADDRESS),
           Volatile_Full_Access => True,
           Import               => True,
           Convention           => Ada;

   -- Serial Channel Control Register B

   type SCCRB_Type is record
      Reserved1 : Bits_17;
      MAM2      : Boolean; -- Match address mode 2
      MAM1      : Boolean; -- Match address mode 1
      BITORDR   : Boolean; -- Bit ordering
      MODE      : Bits_2;  -- SCC mode
      Reserved2 : Bits_4;
      RCGT      : Boolean; -- Enable receive character gap timer
      RBGT      : Boolean; -- Enable receive buffer gap timer
      RDM4      : Boolean; -- Enable receive data match 4
      RDM3      : Boolean; -- Enable receive data match 3
      RDM2      : Boolean; -- Enable receive data match 2
      RDM1      : Boolean; -- Enable receive data match 1
   end record
      with Bit_Order => Low_Order_First,
           Size      => 32;
   for SCCRB_Type use record
      Reserved1 at 0 range  0 .. 16;
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

   SCCRB : aliased SCCRB_Type
      with Address              => To_Address (SCCRB_ADDRESS),
           Volatile_Full_Access => True,
           Import               => True,
           Convention           => Ada;

   -- Serial Channel Status Register

   type SCSR_Type is record
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
      RXFDB    : Bits_2;
      Reserved : Bits_4;
      CGAP     : Boolean;
      BGAP     : Boolean;
      MATCH4   : Boolean;
      MATCH3   : Boolean;
      MATCH2   : Boolean;
      MATCH1   : Boolean;
   end record
      with Bit_Order => Low_Order_First,
           Size      => 32;
   for SCSR_Type use record
      TXEMPTY  at 0 range  0 ..  0;
      TXBC     at 0 range  1 ..  1;
      TXHALF   at 0 range  2 ..  2;
      TXRDY    at 0 range  3 ..  3;
      TXCTSI   at 0 range  4 ..  4;
      RXDSRI   at 0 range  5 ..  5;
      RXRII    at 0 range  6 ..  6;
      RXDCDI   at 0 range  7 ..  7;
      RXFULL   at 0 range  8 ..  8;
      RXBC     at 0 range  9 ..  9;
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

   SCSR : aliased SCSR_Type
      with Address              => To_Address (SCSR_ADDRESS),
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

   type SCBRGR_Type is record
      NREG      : Bits_11; -- BRG frequency
      Reserved1 : Bits_1;
      RICS      : Boolean;
      RSVD      : Boolean;
      TICS      : Boolean;
      Reserved2 : Bits_1;
      RDCR      : Bits_2;
      Reserved3 : Bits_1;
      TDCR      : Bits_2;
      CLKINV    : Boolean;
      RXCINV    : Boolean;
      TXCINV    : Boolean;
      CLKMUX    : Bits_2;
      TXEXT     : Boolean;
      RXEXT     : Boolean;
      TXSRC     : Boolean;
      RXSRC     : Boolean;
      TMODE     : Bits_1;
      EBIT      : Boolean;
   end record
      with Bit_Order => Low_Order_First,
           Size      => 32;
   for SCBRGR_Type use record
      NREG      at 0 range  0 .. 10;
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

   SCBRGR : aliased SCBRGR_Type
      with Address              => To_Address (SCBRGR_ADDRESS),
           Volatile_Full_Access => True,
           Import               => True,
           Convention           => Ada;

   -- Serial Channel FIFO registers

   type SCFIFOR_Type is record
      DATA : U8_Array (0 .. 3);
   end record
      with Size => 4 * 8;

   SCFIFOR_ADDRESS : constant := SER_BASEADDRESS + 16#10#;

   SCFIFOR : aliased SCFIFOR_Type
      with Address    => To_Address (SCFIFOR_ADDRESS),
           Volatile   => True,
           Import     => True,
           Convention => Ada;

pragma Style_Checks (On);

   ----------------------------------------------------------------------------
   -- subprograms
   ----------------------------------------------------------------------------

   procedure Tclk_Init;

end NETARM;

-----------------------------------------------------------------------------------------------------------------------
--                                                     SweetAda                                                      --
-----------------------------------------------------------------------------------------------------------------------
-- __HDS__                                                                                                           --
-- __FLN__ sh7032.ads                                                                                                --
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
with Bits;

package SH7032
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
   use Interfaces;
   use Bits;

pragma Style_Checks (Off);

   ----------------------------------------------------------------------------
   -- SH7032, SH7034 Hardware Manual
   -- Rev.7.00 2006.01
   ----------------------------------------------------------------------------

   ----------------------------------------------------------------------------
   -- Section 8 Bus State Controller (BSC)
   ----------------------------------------------------------------------------

   -- 8.2.1 Bus Control Register (BCR)

   BAS_WRHLA0 : constant := 0; -- WRH, WRL, and A0 enabled
   BAS_LHBSWR : constant := 1; -- LBS, WR, and HBS enabled

   RDDTY_50 : constant := 0; -- RD signal high-level duty cycle is 50% of T1 state
   RDDTY_35 : constant := 1; -- RD signal high-level duty cycle is 35% of T1 state

   type BCR_Type is record
      Reserved : Bits_11 := 0;
      BAS      : Bits_1  := BAS_WRHLA0; -- Byte Access Select
      RDDTY    : Bits_1  := RDDTY_50;   -- RD Duty
      WARP     : Boolean := False;      -- Warp Mode Bit
      IOE      : Boolean := False;      -- Multiplexed I/O Enable Bit
      DRAME    : Boolean := False;      -- DRAM Enable Bit
   end record
      with Bit_Order => Low_Order_First,
           Size      => 16;
   for BCR_Type use record
      Reserved at 0 range  0 .. 10;
      BAS      at 0 range 11 .. 11;
      RDDTY    at 0 range 12 .. 12;
      WARP     at 0 range 13 .. 13;
      IOE      at 0 range 14 .. 14;
      DRAME    at 0 range 15 .. 15;
   end record;

   BCR_ADDRESS : constant := 16#05FF_FFA0#;

   BCR : aliased BCR_Type
      with Address              => System'To_Address (BCR_ADDRESS),
           Volatile_Full_Access => True,
           Import               => True,
           Convention           => Ada;

   ----------------------------------------------------------------------------
   -- Section 13 Serial Communication Interface (SCI)
   ----------------------------------------------------------------------------

   -- 13.2.1 Receive Shift Register
   -- 13.2.2 Receive Data Register
   -- 13.2.3 Transmit Shift Register
   -- 13.2.4 Transmit Data Register

   -- 13.2.5 Serial Mode Register

   CKS_SYSCLOCK       : constant := 2#00#; -- System clock (φ)
   CKS_SYSCLOCK_DIV4  : constant := 2#01#; -- φ/4
   CKS_SYSCLOCK_DIV16 : constant := 2#10#; -- φ/16
   CKS_SYSCLOCK_DIV64 : constant := 2#11#; -- φ/64

   STOP_1 : constant := 0; -- One stop bit
   STOP_2 : constant := 1; -- Two stop bits.

   OE_EVEN : constant := 0; -- Even parity
   OE_ODD  : constant := 1; -- Odd parity

   CHR_8 : constant := 0; -- Eight-bit data
   CHR_7 : constant := 1; -- Seven-bit data.

   CA_ASYNC : constant := 0; -- Asynchronous mode
   CA_SYNC  : constant := 1; -- Synchronous mode

   type SMR_Type is record
      CKS  : Bits_2   := CKS_SYSCLOCK; -- Clock Select 1 and 0
      MP   : Boolean  := False;        -- Multiprocessor Mode
      STOP : Bits_1   := STOP_1;       -- Stop Bit Length
      OE   : Bits_1   := OE_EVEN;      -- Parity Mode
      PE   : Boolean  := False;        -- Parity Enable
      CHR  : Bits_1   := CHR_8;        -- Character Length
      CA   : Bits_1   := CA_ASYNC;     -- Communication Mode
   end record
      with Bit_Order => Low_Order_First,
           Size      => 8;
   for SMR_Type use record
      CKS  at 0 range 0 .. 1;
      MP   at 0 range 2 .. 2;
      STOP at 0 range 3 .. 3;
      OE   at 0 range 4 .. 4;
      PE   at 0 range 5 .. 5;
      CHR  at 0 range 6 .. 6;
      CA   at 0 range 7 .. 7;
   end record;

   -- 13.2.6 Serial Control Register

   CKE_ASYNC_INTCLK_SCKIO   : constant := 2#00#; -- Asynchronous mode Internal clock, SCK pin used for input pin (input signal is ignored) or output pin (output level is undefined)
   CKE_SYNC_INTCLK_SCKOUT   : constant := 2#00#; -- Synchronous mode Internal clock, SCK pin used for serial clock output
   CKE_ASYNC_INTCLK_SCKOUT  : constant := 2#01#; -- Asynchronous mode Internal clock, SCK pin used for clock output
   CKE_SYNC_INTCLK_SCKOUT_2 : constant := 2#01#; -- Synchronous mode Internal clock, SCK pin used for serial clock output
   CKE_ASYNC_EXTCLK_SCKIN   : constant := 2#10#; -- Asynchronous mode External clock, SCK pin used for clock input
   CKE_SYNC_EXTCLK_SCKOUT   : constant := 2#10#; -- Synchronous mode External clock, SCK pin used for serial clock input
   CKE_ASYNC_EXTCLK_SCKIN_2 : constant := 2#11#; -- Asynchronous mode External clock, SCK pin used for clock input
   CKE_SYNC_EXTCLK_SCKIN    : constant := 2#11#; -- Synchronous mode External clock, SCK pin used for serial clock input

   type SCR_Type is record
      CKE  : Bits_2  := CKE_ASYNC_INTCLK_SCKIO; -- Clock Enable 1 and 0 (CKE1 and CKE0)
      TEIE : Boolean := False;                  -- Transmit-End Interrupt Enable (TEIE)
      MPIE : Boolean := False;                  -- Multiprocessor Interrupt Enable (MPIE)
      RE   : Boolean := False;                  -- Receive Enable (RE)
      TE   : Boolean := False;                  -- Transmit Enable (TE)
      RIE  : Boolean := False;                  -- Receive Interrupt Enable (RIE)
      TIE  : Boolean := False;                  -- Transmit Interrupt Enable (TIE)
   end record
      with Bit_Order => Low_Order_First,
           Size      => 8;
   for SCR_Type use record
      CKE  at 0 range 0 .. 1;
      TEIE at 0 range 2 .. 2;
      MPIE at 0 range 3 .. 3;
      RE   at 0 range 4 .. 4;
      TE   at 0 range 5 .. 5;
      RIE  at 0 range 6 .. 6;
      TIE  at 0 range 7 .. 7;
   end record;

   -- 13.2.7 Serial Status Register

   type SSR_Type is record
      MPBT : Bits_1  := 0;     -- Multiprocessor Bit Transfer (MPBT)
      MPB  : Bits_1  := 0;     -- Multiprocessor Bit (MPB)
      TEND : Boolean := False; -- Transmit End (TEND)
      PER  : Boolean := True;  -- Parity Error (PER)
      FER  : Boolean := True;  -- Framing Error (FER)
      ORER : Boolean := True;  -- Overrun Error (ORER)
      RDRF : Boolean := True;  -- Receive Data Register Full (RDRF)
      TDRE : Boolean := True;  -- Transmit Data Register Empty (TDRE)
   end record
      with Bit_Order => Low_Order_First,
           Size      => 8;
   for SSR_Type use record
      MPBT at 0 range 0 .. 0;
      MPB  at 0 range 1 .. 1;
      TEND at 0 range 2 .. 2;
      PER  at 0 range 3 .. 3;
      FER  at 0 range 4 .. 4;
      ORER at 0 range 5 .. 5;
      RDRF at 0 range 6 .. 6;
      TDRE at 0 range 7 .. 7;
   end record;

   -- 13.2.8 Bit Rate Register (BRR)

   -- 13.1.4 Register Configuration

   type SCI_Type is record
      SMR : SMR_Type   with Volatile_Full_Access => True;
      BRR : Unsigned_8 with Volatile_Full_Access => True;
      SCR : SCR_Type   with Volatile_Full_Access => True;
      TDR : Unsigned_8 with Volatile_Full_Access => True;
      SSR : SSR_Type   with Volatile_Full_Access => True;
      RDR : Unsigned_8 with Volatile_Full_Access => True;
   end record
      with Size => 6 * 8;
   for SCI_Type use record
      SMR at 0 range 0 .. 7;
      BRR at 1 range 0 .. 7;
      SCR at 2 range 0 .. 7;
      TDR at 3 range 0 .. 7;
      SSR at 4 range 0 .. 7;
      RDR at 5 range 0 .. 7;
   end record;

   SCI0 : aliased SCI_Type
      with Address    => System'To_Address (16#05FF_FEC0#),
           Volatile   => True,
           Import     => True,
           Convention => Ada;

   SCI1 : aliased SCI_Type
      with Address    => System'To_Address (16#05FF_FEC8#),
           Volatile   => True,
           Import     => True,
           Convention => Ada;

   ----------------------------------------------------------------------------
   -- Section 15 Pin Function Controller (PFC)
   ----------------------------------------------------------------------------

   type LEBitmap_8_IDX_Type  is (bi7, bi6, bi5, bi4, bi3, bi2, bi1, bi0);
   type LEBitmap_16_IDX_Type is (bi15, bi14, bi13, bi12, bi11, bi10, bi9, bi8,
                                 bi7,  bi6,  bi5,  bi4,  bi3,  bi2,  bi1, bi0);

   type LEBitmap_8  is array (LEBitmap_8_IDX_Type) of Boolean
      with Component_Size => 1,
           Size           => 8;
   type LEBitmap_16 is array (LEBitmap_16_IDX_Type) of Boolean
      with Component_Size => 1,
           Size           => 16;

   -- 15.3.1 Port A I/O Register (PAIOR)

   type PAIOR_Type is record
      PA : LEBitmap_16 := [others => False];
   end record
      with Bit_Order => Low_Order_First,
           Size      => 16;
   for PAIOR_Type use record
      PA at 0 range 0 .. 15;
   end record;

   -- 15.3.2 Port A Control Registers (PACR1 and PACR2)

   PA8_PA8  : constant := 0; -- Input/output (PA8)
   PA8_BREQ : constant := 1; -- Bus request input (/BREQ)

   PA9_PA9    : constant := 2#00#; -- Input/output (PA9)
   PA9_AH     : constant := 2#01#; -- Address hold output (AH)
   PA9_ADTRG  : constant := 2#10#; -- A/D conversion trigger input (/ADTRG)
   PA9_IRQOUT : constant := 2#11#; -- Interrupt request output (/IRQOUT)

   PA10_PA10   : constant := 2#00#; -- Input/output (PA10)
   PA10_DPL    : constant := 2#01#; -- Lower data bus parity input/output (DPL)
   PA10_TIOCA1 : constant := 2#10#; -- ITU input capture/output compare (TIOCA1)
   PA10_RSVD   : constant := 2#11#; -- Reserved

   PA11_PA11   : constant := 2#00#; -- Input/output (PA11)
   PA11_DPH    : constant := 2#01#; -- Upper data bus parity input/output (DPH)
   PA11_TIOCB1 : constant := 2#10#; -- ITU input capture/output compare (TIOCB1)
   PA11_RSVD   : constant := 2#11#; -- Reserved

   PA12_PA12  : constant := 2#00#; -- Input/output (PA12)
   PA12_IRQ0  : constant := 2#01#; -- Interrupt request input (/IRQ0)
   PA12_TCLKA : constant := 2#10#; -- ITU timer clock input (TCLKA)
   PA12_DACK0 : constant := 2#11#; -- DMA transfer acknowledge output (DACK0)

   PA13_PA13  : constant := 2#00#; -- Input/output (PA13)
   PA13_IRQ1  : constant := 2#01#; -- Interrupt request input (/IRQ1)
   PA13_TCLKB : constant := 2#10#; -- ITU timer clock input (TCLKB)
   PA13_DREQ0 : constant := 2#11#; -- DMA transfer request input (/DREQ0)

   PA14_PA14  : constant := 2#00#; -- Input/output (PA14)
   PA14_IRQ2  : constant := 2#01#; -- Interrupt request input (/IRQ2)
   PA14_RSVD  : constant := 2#10#; -- Reserved
   PA14_DACK1 : constant := 2#11#; -- DMA transfer acknowledge output (DACK1)

   PA15_PA15  : constant := 2#00#; -- Input/output (PA15)
   PA15_IRQ3  : constant := 2#01#; -- Interrupt request input (/IRQ3)
   PA15_RSVD  : constant := 2#10#; -- Reserved
   PA15_DREQ1 : constant := 2#11#; -- DMA transfer request input (DREQ1)

   type PACR1_Type is record
      PA8    : Bits_1 := PA8_PA8;    -- PA8 Mode (PA8MD): PA8MD selects the function of the PA8//BREQ pin.
      Unused : Bits_1 := 1;
      PA9    : Bits_2 := PA9_PA9;    -- PA9 Mode (PA9MD1 and PA9MD0): PA9MD1 and PA9MD0 select the function of the PA9/AH//IRQOUT//ADTRG pin.
      PA10   : Bits_2 := PA10_PA10;  -- PA10 Mode (PA10MD1 and PA10MD0): PA10MD1 and MA10MD0 select the function of the PA10/DPL/TIOCA1 pin.
      PA11   : Bits_2 := PA11_PA11;  -- PA11 Mode (PA11MD1 and PA11MD0): PA11MD1 and PA11MD0 select the function of the PA11/DPH/TIOCB1 pin.
      PA12   : Bits_2 := PA12_DACK0; -- PA12 Mode (PA12MD1 and PA12MD0): PA12MD1 and PA12MD0 select the function of the PA12//IRQ0/DACK0/TCLKA pin.
      PA13   : Bits_2 := PA13_PA13;  -- PA13 Mode (PA13MD1 and PA13MD0): PA13MD1 and PA13MD0 select the function of the PA13//IRQ1//DREQ0/TCLKB pin.
      PA14   : Bits_2 := PA14_DACK1; -- PA14 Mode (PA14MD1 and PA14MD0): PA14MD1 and PA14MD0 select the function of the PA14//IRQ2/DACK1 pin.
      PA15   : Bits_2 := PA15_PA15;  -- PA15 Mode (PA15MD1 and PA15MD0): PA15MD1 and PA15MD0 select the function of the PA15//IRQ3//DREQ1 pin.
   end record
      with Bit_Order => Low_Order_First,
           Size      => 16;
   for PACR1_Type use record
      PA8    at 0 range  0 ..  0;
      Unused at 0 range  1 ..  1;
      PA9    at 0 range  2 ..  3;
      PA10   at 0 range  4 ..  5;
      PA11   at 0 range  6 ..  7;
      PA12   at 0 range  8 ..  9;
      PA13   at 0 range 10 .. 11;
      PA14   at 0 range 12 .. 13;
      PA15   at 0 range 14 .. 15;
   end record;

   PACR1 : aliased PACR1_Type
      with Address              => System'To_Address (16#05FF_FFC8#),
           Volatile_Full_Access => True,
           Import               => True,
           Convention           => Ada;

   PA0_PA0    : constant := 2#00#; -- Input/output (PA0)
   PA0_CS4    : constant := 2#01#; -- Chip select output (CS4)
   PA0_TIOCA0 : constant := 2#10#; -- ITU input capture/output compare (TIOCA0)
   PA0_RSVD   : constant := 2#11#; -- Reserved

   PA1_PA1  : constant := 2#00#; -- Input/output (PA1)
   PA1_CS5  : constant := 2#01#; -- Chip select output (/CS5)
   PA1_RAS  : constant := 2#10#; -- Row address strobe output (/RAS)
   PA1_RSVD : constant := 2#11#; -- Reserved

   PA2_PA2    : constant := 2#00#; -- Input/output (PA2)
   PA2_CS6    : constant := 2#01#; -- Chip select output (/CS6)
   PA2_TIOCB0 : constant := 2#10#; -- ITU input capture/output compare (TIOCB0)
   PA2_RSVD   : constant := 2#11#; -- Reserved

   PA3_PA3  : constant := 2#00#; -- Input/output (PA3)
   PA3_CS7  : constant := 2#01#; -- Chip select output (/CS7)
   PA3_WAIT : constant := 2#10#; -- Wait state input (/WAIT)
   PA3_RSVD : constant := 2#11#; -- Reserved

   PA4_PA4 : constant := 0; -- Input/output (PA4)
   PA4_WRL : constant := 1; -- Lower write output (/WRL) or write output (/WR)

   PA5_PA5 : constant := 0; -- Input/output (PA5)
   PA5_WRH : constant := 1; -- Upper write output (/WRH) or lower byte strobe output (/LBS)

   PA6_PA6 : constant := 0; -- Input/output (PA6)
   PA6_RD  : constant := 1; -- Read output (/RD)

   PA7_PA7  : constant := 0; -- Input/output (PA7)
   PA7_BACK : constant := 1; -- Bus request acknowledge output (/BACK)

   type PACR2_Type is record
      PA0     : Bits_2 := PA0_CS4;  -- PA0 Mode (PA0MD1 and PA0MD0): PA0MD1 and PA0MD0 select the function of the PA0//CS4/TIOCA0 pin.
      PA1     : Bits_2 := PA1_CS5;  -- PA1 Mode (PA1MD1 and PA1MD0): PA1MD1 and PA1MD0 select the function of the PA1//CS5//RAS pin.
      PA2     : Bits_2 := PA2_CS6;  -- PA2 Mode (PA2MD1 and PA2MD0): PA2MD1 and PA2MD0 select the function of the PA2//CS6/TIOCB0 pin.
      PA3     : Bits_2 := PA3_WAIT; -- PA3 Mode (PA3MD1 and PA3MD0): PA3MD1 and PA3MD0 select the function of the PA3//CS7//WAIT pin.
      PA4     : Bits_1 := PA4_WRL;  -- PA4 Mode (PA4MD): PA4MD selects the function of the PA4//WRL (/WR) pin.
      Unused1 : Bits_1 := 1;
      PA5     : Bits_1 := PA5_WRH;  -- PA5 Mode (PA5MD): PA5MD selects the function of the PA5//WRH (/LBS) pin.
      Unused2 : Bits_1 := 1;
      PA6     : Bits_1 := PA6_RD;   -- PA6 Mode (PA6MD): PA6MD selects the function of the PA6//RD pin.
      Unused3 : Bits_1 := 1;
      PA7     : Bits_1 := PA7_BACK; -- PA7 Mode (PA7MD): PA7MD selects the function of the PA7//BACK pin.
      Unused4 : Bits_1 := 1;
   end record
      with Bit_Order => Low_Order_First,
           Size      => 16;
   for PACR2_Type use record
      PA0     at 0 range  0 ..  1;
      PA1     at 0 range  2 ..  3;
      PA2     at 0 range  4 ..  5;
      PA3     at 0 range  6 ..  7;
      PA4     at 0 range  8 ..  8;
      Unused1 at 0 range  9 ..  9;
      PA5     at 0 range 10 .. 10;
      Unused2 at 0 range 11 .. 11;
      PA6     at 0 range 12 .. 12;
      Unused3 at 0 range 13 .. 13;
      PA7     at 0 range 14 .. 14;
      Unused4 at 0 range 15 .. 15;
   end record;

   PACR2 : aliased PACR2_Type
      with Address              => System'To_Address (16#05FF_FFCA#),
           Volatile_Full_Access => True,
           Import               => True,
           Convention           => Ada;

   -- 15.3.3 Port B I/O Register (PBIOR)

   type PBIOR_Type is record
      PB : LEBitmap_16 := [others => False];
   end record
      with Bit_Order => Low_Order_First,
           Size      => 16;
   for PBIOR_Type use record
      PB at 0 range 0 .. 15;
   end record;

   PBIOR : aliased PBIOR_Type
      with Address              => System'To_Address (16#05FF_FFC6#),
           Volatile_Full_Access => True,
           Import               => True,
           Convention           => Ada;

   -- 15.3.4 Port B Control Registers (PBCR1 and PBCR2)

   PB8_PB8  : constant := 2#00#; -- Input/output (PB8)
   PB8_RSVD : constant := 2#01#; -- Reserved
   PB8_RxD0 : constant := 2#10#; -- Receive data input (RxD0)
   PB8_TP8  : constant := 2#11#; -- Timing pattern output (TP8)

   PB9_PB9  : constant := 2#00#; -- Input/output (PB9)
   PB9_RSVD : constant := 2#01#; -- Reserved
   PB9_TxD0 : constant := 2#10#; -- Transmit data output (TxD0)
   PB9_TP9  : constant := 2#11#; -- Timing pattern output (TP9)

   PB10_PB10 : constant := 2#00#; -- Input/output (PB10)
   PB10_RSVD : constant := 2#01#; -- Reserved
   PB10_RxD1 : constant := 2#10#; -- Receive data input (RxD1)
   PB10_TP10 : constant := 2#11#; -- Timing pattern output (TP10)

   PB11_PB11 : constant := 2#00#; -- Input/output (PB11)
   PB11_RSVD : constant := 2#01#; -- Reserved
   PB11_TxD1 : constant := 2#10#; -- Transmit data output (TxD1)
   PB11_TP11 : constant := 2#11#; -- Timing pattern output (TP11)

   PB12_PB12 : constant := 2#00#; -- Input/output (PB12)
   PB12_IRQ4 : constant := 2#01#; -- Interrupt request input (/IRQ4)
   PB12_SCK0 : constant := 2#10#; -- Serial clock input/output (SCK0)
   PB12_TP12 : constant := 2#11#; -- Timing pattern output (TP12)

   PB13_PB13 : constant := 2#00#; -- Input/output (PB13)
   PB13_IRQ5 : constant := 2#01#; -- Interrupt request input (/IRQ5)
   PB13_SCK1 : constant := 2#10#; -- Serial clock input/output (SCK1)
   PB13_TP13 : constant := 2#11#; -- Timing pattern output (TP13)

   PB14_PB14 : constant := 2#00#; -- Input/output (PB14)
   PB14_IRQ6 : constant := 2#01#; -- Interrupt request input (/IRQ6)
   PB14_RSVD : constant := 2#10#; -- Reserved
   PB14_TP14 : constant := 2#11#; -- Timing pattern output (TP14)

   PB15_PB15 : constant := 2#00#; -- Input/output (PB15)
   PB15_IRQ7 : constant := 2#01#; -- Interrupt request input (/IRQ7)
   PB15_RSVD : constant := 2#10#; -- Reserved
   PB15_TP15 : constant := 2#11#; -- Timing pattern output (TP15)

   type PBCR1_Type is record
      PB8  : Bits_2 := PB8_PB8;   -- PB8 Mode (PB8MD1 and PB8MD0): PB8MD1 and PB8MD0 select the function of the PB8/TP8/RxD0 pin.
      PB9  : Bits_2 := PB9_PB9;   -- PB9 Mode (PB9MD1 and PB9MD0): PB9MD1 and PB9MD0 select the function of the PB9/TP9/TxD0 pin.
      PB10 : Bits_2 := PB10_PB10; -- PB10 Mode (PB10MD1 and PB10MD0): PB10MD1 and PB10MD0 select the function of the PB10/TP10/RxD1 pin.
      PB11 : Bits_2 := PB11_PB11; -- PB11 Mode—PB11MD1 and PB11MD0): PB11MD1 and PB11MD0 select the function of the PB11/TP11/TxD1 pin.
      PB12 : Bits_2 := PB12_PB12; -- PB12 Mode (PB12MD1 and PB12MD0): PB12MD1 and PB12MD0 select the function of the PB12/TP12//IRQ4/SCK0 pin.
      PB13 : Bits_2 := PB13_PB13; -- PB13 Mode (PB13MD1 and PB13MD0): PB13MD1 and PB13MD0 select the function of the PB13/TP13//IRQ5/SCK1 pin.
      PB14 : Bits_2 := PB14_PB14; -- PB14 Mode (PB14MD1 and PB14MD0): PB14MD1 and PB14MD0 select the function of the PB14/TP14//IRQ6 pin.
      PB15 : Bits_2 := PB15_PB15; -- PB15 Mode (PB15MD1 and PB15MD0): PB15MD1 and PB15MD0 select the function of the PB15/TP15//IRQ7 pin.
   end record
      with Bit_Order => Low_Order_First,
           Size      => 16;
   for PBCR1_Type use record
      PB8  at 0 range  0 ..  1;
      PB9  at 0 range  2 ..  3;
      PB10 at 0 range  4 ..  5;
      PB11 at 0 range  6 ..  7;
      PB12 at 0 range  8 ..  9;
      PB13 at 0 range 10 .. 11;
      PB14 at 0 range 12 .. 13;
      PB15 at 0 range 14 .. 15;
   end record;

   PBCR1 : aliased PBCR1_Type
      with Address              => System'To_Address (16#05FF_FFCC#),
           Volatile_Full_Access => True,
           Import               => True,
           Convention           => Ada;

   PB0_PB0    : constant := 2#00#; -- Input/output (PB0)
   PB0_RSVD   : constant := 2#01#; -- Reserved
   PB0_TIOCA2 : constant := 2#10#; -- ITU input capture/output compare (TIOCA2)
   PB0_TP0    : constant := 2#11#; -- Timing pattern output (TP0)

   PB1_PB1    : constant := 2#00#; -- Input/output (PB1)
   PB1_RSVD   : constant := 2#01#; -- Reserved
   PB1_TIOCB2 : constant := 2#10#; -- ITU input capture/output compare (TIOCB2)
   PB1_TP1    : constant := 2#11#; -- Timing pattern output (TP1)

   PB2_PB2    : constant := 2#00#; -- Input/output (PB2)
   PB2_RSVD   : constant := 2#01#; -- Reserved
   PB2_TIOCA3 : constant := 2#10#; -- ITU input capture/output compare (TIOCA3)
   PB2_TP2    : constant := 2#11#; -- Timing pattern output (TP2)

   PB3_PB3    : constant := 2#00#; -- Input/output (PB3)
   PB3_RSVD   : constant := 2#01#; -- Reserved
   PB3_TIOCB3 : constant := 2#10#; -- ITU input capture/output compare (TIOCB3)
   PB3_TP3    : constant := 2#11#; -- Timing pattern output (TP3)

   PB4_PB4    : constant := 2#00#; -- Input/output (PB4)
   PB4_RSVD   : constant := 2#01#; -- Reserved
   PB4_TIOCA4 : constant := 2#10#; -- ITU input capture/output compare (TIOCA4)
   PB4_TP4    : constant := 2#11#; -- Timing pattern output (TP4)

   PB5_PB5    : constant := 2#00#; -- Input/output (PB5)
   PB5_RSVD   : constant := 2#01#; -- Reserved
   PB5_TIOCB4 : constant := 2#10#; -- ITU input capture/output compare (TIOCB4)
   PB5_TP5    : constant := 2#11#; -- Timing pattern output (TP5)

   PB6_PB6    : constant := 2#00#; -- Input/output (PB6)
   PB6_TCLKC  : constant := 2#01#; -- ITU timer clock input (TCLKC)
   PB6_TOCXA4 : constant := 2#10#; -- ITU output compare (TOCXA4)
   PB6_TP6    : constant := 2#11#; -- Timing pattern output (TP6)

   PB7_PB7    : constant := 2#00#; -- Input/output (PB7)
   PB7_TCLKD  : constant := 2#01#; -- ITU timer clock input (TCLKD)
   PB7_TOCXB4 : constant := 2#10#; -- ITU output compare (TOCXB4)
   PB7_TP7    : constant := 2#11#; -- Timing pattern output (TP7)

   type PBCR2_Type is record
      PB0 : Bits_2 := PB0_PB0; -- PB0 Mode (PB0MD1 and PB0MD0): PB0MD1 and PB0MD0 select the function of the PB0/TP0/TIOCA2 pin.
      PB1 : Bits_2 := PB1_PB1; -- PB1 Mode (PB1MD1 and PB1MD0): PB1MD1 and PB1MD0 select the function of the PB1/TP1/TIOCB2 pin.
      PB2 : Bits_2 := PB2_PB2; -- PB2 Mode (PB2MD1 and PB2MD0): PB2MD1 and PB2MD0 select the function of the PB2/TP2/TIOCA3 pin.
      PB3 : Bits_2 := PB3_PB3; -- PB3 Mode (PB3MD1 and PB3MD0): PB3MD1 and PB3MD0 select the function of the PB3/TP3/TIOCB3 pin.
      PB4 : Bits_2 := PB4_PB4; -- PB4 Mode (PB4MD1 and PB4MD0): PB4MD1 and PB4MD0 select the function of the PB4/TP4/TIOCA4 pin.
      PB5 : Bits_2 := PB5_PB5; -- PB5 Mode (PB5MD1 and PB5MD0): PB5MD1 and PB5MD0 select the function of the PB5/TP5/TIOCB4 pin.
      PB6 : Bits_2 := PB6_PB6; -- PB6 Mode (PB6MD1 and PB6MD0): PB6MD1 and PB6MD0 select the function of the PB6/TP6/TOCXA4/TCLKC pin.
      PB7 : Bits_2 := PB7_PB7; -- PB7 Mode (PB7MD1 and PB7MD0): PB7MD1 and PB7MD0 select the function of the PB7/TP7/TOCXB4/TCLKD pin.
   end record
      with Bit_Order => Low_Order_First,
           Size      => 16;
   for PBCR2_Type use record
      PB0 at 0 range  0 ..  1;
      PB1 at 0 range  2 ..  3;
      PB2 at 0 range  4 ..  5;
      PB3 at 0 range  6 ..  7;
      PB4 at 0 range  8 ..  9;
      PB5 at 0 range 10 .. 11;
      PB6 at 0 range 12 .. 13;
      PB7 at 0 range 14 .. 15;
   end record;

   PBCR2 : aliased PBCR2_Type
      with Address              => System'To_Address (16#05FF_FFCE#),
           Volatile_Full_Access => True,
           Import               => True,
           Convention           => Ada;

   -- 15.3.5 Column Address Strobe Pin Control Register (CASCR)

   CASL_RSVD1 : constant := 2#00#; -- Reserved
   CASL_CS3   : constant := 2#01#; -- Chip select output (/CS3)
   CASL_CASL  : constant := 2#10#; -- Column address strobe output (/CASL)
   CASL_RSVD2 : constant := 2#11#; -- Reserved

   CASH_RSVD1 : constant := 2#00#; -- Reserved
   CASH_CS1   : constant := 2#01#; -- Chip select output (/CS1)
   CASH_CASH  : constant := 2#10#; -- Column address strobe output (/CASH)
   CASH_RSVD2 : constant := 2#11#; -- Reserved

   type CASCR_Type is record
      Unused : Bits_12 := 16#FFF#;
      CASL   : Bits_2  := CASL_CS3; -- CASL Mode (CASLMD1 and CASLMD0): CASLMD1 and CASLMD0 select the function of the /CS3//CASL pin.
      CASH   : Bits_2  := CASH_CS1; -- CASH Mode (CASHMD1 and CASHMD0): CASHMD1 and CASHMD0 select the function of the /CS1//CASH pin.
   end record
      with Bit_Order => Low_Order_First,
           Size      => 16;
   for CASCR_Type use record
      Unused at 0 range  0 .. 11;
      CASL   at 0 range 12 .. 13;
      CASH   at 0 range 14 .. 15;
   end record;

   CASCR : aliased CASCR_Type
      with Address              => System'To_Address (16#05FF_FFEE#),
           Volatile_Full_Access => True,
           Import               => True,
           Convention           => Ada;

pragma Style_Checks (On);

end SH7032;

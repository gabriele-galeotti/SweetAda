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
   -- 13.2.7 Serial Status Register
   -- 13.2.8 Bit Rate Register (BRR)

   -- 13.1.4 Register Configuration

   type SCI_Type is record
      SMR : SMR_Type   with Volatile_Full_Access => True;
      BRR : Unsigned_8 with Volatile_Full_Access => True;
      TDR : Unsigned_8 with Volatile_Full_Access => True;
      RDR : Unsigned_8 with Volatile_Full_Access => True;
   end record
      with Size => 6 * 8;
   for SCI_Type use record
      SMR at 0 range 0 .. 7;
      BRR at 1 range 0 .. 7;
      TDR at 3 range 0 .. 7;
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

pragma Style_Checks (On);

end SH7032;

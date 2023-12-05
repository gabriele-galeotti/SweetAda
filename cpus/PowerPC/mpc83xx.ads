-----------------------------------------------------------------------------------------------------------------------
--                                                     SweetAda                                                      --
-----------------------------------------------------------------------------------------------------------------------
-- __HDS__                                                                                                           --
-- __FLN__ mpc83xx.ads                                                                                               --
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

package MPC83XX is

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

   IMMRBAR : constant := 16#FF40_0000#;

   GPIO1_BASEADDRESS : constant := IMMRBAR + 16#0000_0C00#;
   GPIO2_BASEADDRESS : constant := IMMRBAR + 16#0000_0D00#;
   I2C1_BASEADDRESS  : constant := IMMRBAR + 16#0000_3000#;
   I2C2_BASEADDRESS  : constant := IMMRBAR + 16#0000_3100#;
   UART1_BASEADDRESS : constant := IMMRBAR + 16#0000_4500#;
   UART2_BASEADDRESS : constant := IMMRBAR + 16#0000_4600#;
   eSDHC_BASEADDRESS : constant := IMMRBAR + 16#0002_E000#;

   -- 4.3.2.1 Reset Configuration Word Low Register (RCWLR)

   RCWLR : aliased Unsigned_32
      with Address              => To_Address (IMMRBAR + 16#0900#),
           Volatile_Full_Access => True,
           Import               => True,
           Convention           => Ada;

   -- 4.3.2.2 Reset Configuration Word High Register (RCWHR)

   RCWHR : aliased Unsigned_32
      with Address              => To_Address (IMMRBAR + 16#0904#),
           Volatile_Full_Access => True,
           Import               => True,
           Convention           => Ada;

   -- 6.3.2.5 System I/O Configuration Register 1 (SICR_1)

   SICR_1 : aliased Unsigned_32
      with Address              => To_Address (IMMRBAR + 16#0114#),
           Volatile_Full_Access => True,
           Import               => True,
           Convention           => Ada;

   -- 6.3.2.6 System I/O Configuration Register 2 (SICR_2)

   SICR_2 : aliased Unsigned_32
      with Address              => To_Address (IMMRBAR + 16#0118#),
           Volatile_Full_Access => True,
           Import               => True,
           Convention           => Ada;

   -- 12.4.7 Present State Register (PRSSTAT)

   type PRSSTAT_Type is record
      Reserved1 : Bits_4;
      DLSL_3    : Boolean;
      DLSL_2    : Boolean;
      DLSL_1    : Boolean;
      DLSL_0    : Boolean;
      CLSL      : Boolean;
      Reserved2 : Bits_3;
      WPSPL     : Boolean;
      CDPL      : Boolean;
      Reserved3 : Bits_1;
      CINS      : Boolean;
      Reserved4 : Bits_4;
      BREN      : Boolean;
      BWEN      : Boolean;
      RTA       : Boolean;
      WTA       : Boolean;
      SD_OFF    : Boolean;
      PER_OFF   : Boolean;
      HCK_OFF   : Boolean;
      IPG_OFF   : Boolean;
      SDSTB     : Boolean;
      DLA       : Boolean;
      CDIHB     : Boolean;
      CIHB      : Boolean;
   end record
      with Bit_Order => High_Order_First,
           Size      => 32;
   for PRSSTAT_Type use record
      Reserved1 at 0 range  0 ..  3;
      DLSL_3    at 0 range  4 ..  4;
      DLSL_2    at 0 range  5 ..  5;
      DLSL_1    at 0 range  6 ..  6;
      DLSL_0    at 0 range  7 ..  7;
      CLSL      at 0 range  8 ..  8;
      Reserved2 at 0 range  9 .. 11;
      WPSPL     at 0 range 12 .. 12;
      CDPL      at 0 range 13 .. 13;
      Reserved3 at 0 range 14 .. 14;
      CINS      at 0 range 15 .. 15;
      Reserved4 at 0 range 16 .. 19;
      BREN      at 0 range 20 .. 20;
      BWEN      at 0 range 21 .. 21;
      RTA       at 0 range 22 .. 22;
      WTA       at 0 range 23 .. 23;
      SD_OFF    at 0 range 24 .. 24;
      PER_OFF   at 0 range 25 .. 25;
      HCK_OFF   at 0 range 26 .. 26;
      IPG_OFF   at 0 range 27 .. 27;
      SDSTB     at 0 range 28 .. 28;
      DLA       at 0 range 29 .. 29;
      CDIHB     at 0 range 30 .. 30;
      CIHB      at 0 range 31 .. 31;
   end record;

   PRSSTAT_ADDRESS : constant := eSDHC_BASEADDRESS + 16#24#;

   PRSSTAT : aliased PRSSTAT_Type
      with Address              => To_Address (PRSSTAT_ADDRESS),
           Volatile_Full_Access => True,
           Import               => True,
           Convention           => Ada;

   -- 17.3.1.1 I2Cn Address Register (I2CnADR)

   type I2CnADR_Type is record
      ADDR     : Bits_7; -- Slave address.
      Reserved : Bits_1;
   end record
      with Bit_Order => High_Order_First,
           Size      => 8;
   for I2CnADR_Type use record
      ADDR     at 0 range 0 .. 6;
      Reserved at 0 range 7 .. 7;
   end record;

   -- 17.3.1.3 I2Cn Control Register (I2CnCR)

   MTX_Receive  : constant := 0;
   MTX_Transmit : constant := 1;

   type I2CnCR_Type is record
      MEN      : Boolean; -- Module enable.
      MIEN     : Boolean; -- Module interrupt enable
      MSTA     : Boolean; -- Master/slave mode START
      MTX      : Bits_1;  -- Transmit/receive mode select.
      TXAK     : Boolean; -- Transfer acknowledge.
      RSTA     : Boolean; -- Repeated START.
      Reserved : Bits_1;
      BCST     : Boolean; -- Broadcast
   end record
      with Bit_Order => High_Order_First,
           Size      => 8;
   for I2CnCR_Type use record
      MEN      at 0 range 0 .. 0;
      MIEN     at 0 range 1 .. 1;
      MSTA     at 0 range 2 .. 2;
      MTX      at 0 range 3 .. 3;
      TXAK     at 0 range 4 .. 4;
      RSTA     at 0 range 5 .. 5;
      Reserved at 0 range 6 .. 6;
      BCST     at 0 range 7 .. 7;
   end record;

   -- 17.3.1.4 I2Cn Status Register (I2CnSR)

   SRW_Receive  : constant := 0; -- Slave receive, master writing to slave
   SRW_Transmit : constant := 1; -- Slave transmit, master reading from slave.

   type I2CnSR_Type is record
      MCF   : Boolean; -- Data transfer.
      MAAS  : Boolean; -- Addressed as a slave.
      MBB   : Boolean; -- Bus busy.
      MAL   : Boolean; -- Arbitration lost.
      BCSTM : Boolean; -- Broadcast match.
      SRW   : Bits_1;  -- Slave read/write.
      MIF   : Boolean; -- Module interrupt.
      RXAK  : Boolean; -- Received acknowledge. (negated)
   end record
      with Bit_Order => High_Order_First,
           Size      => 8;
   for I2CnSR_Type use record
      MCF   at 0 range 0 .. 0;
      MAAS  at 0 range 1 .. 1;
      MBB   at 0 range 2 .. 2;
      MAL   at 0 range 3 .. 3;
      BCSTM at 0 range 4 .. 4;
      SRW   at 0 range 5 .. 5;
      MIF   at 0 range 6 .. 6;
      RXAK  at 0 range 7 .. 7;
   end record;

   type I2C_Type is record
      ADR   : I2CnADR_Type with Volatile_Full_Access => True;
      Pad1  : Bits_24;
      FDR   : Unsigned_8   with Volatile_Full_Access => True;
      Pad2  : Bits_24;
      CR    : I2CnCR_Type  with Volatile_Full_Access => True;
      Pad3  : Bits_24;
      SR    : I2CnSR_Type  with Volatile_Full_Access => True;
      Pad4  : Bits_24;
      DR    : Unsigned_8   with Volatile_Full_Access => True;
      Pad5  : Bits_24;
      DFSRR : Unsigned_8   with Volatile_Full_Access => True;
   end record
      with Size => 21 * 8;
   for I2C_Type use record
      ADR   at 16#00# range 0 ..  7;
      Pad1  at 16#00# range 8 .. 31;
      FDR   at 16#04# range 0 ..  7;
      Pad2  at 16#04# range 8 .. 31;
      CR    at 16#08# range 0 ..  7;
      Pad3  at 16#08# range 8 .. 31;
      SR    at 16#0C# range 0 ..  7;
      Pad4  at 16#0C# range 8 .. 31;
      DR    at 16#10# range 0 ..  7;
      Pad5  at 16#10# range 8 .. 31;
      DFSRR at 16#14# range 0 ..  7;
   end record;

   I2C : aliased I2C_Type
      with Address    => To_Address (I2C1_BASEADDRESS),
           Volatile   => True,
           Import     => True,
           Convention => Ada;

   -- 21.3.1 GPIOn Direction Register (GP1DIR–GP2DIR)

   GP1DIR : aliased Unsigned_32
      with Address              => To_Address (GPIO1_BASEADDRESS + 16#00#),
           Volatile_Full_Access => True,
           Import               => True,
           Convention           => Ada;

   -- 21.3.2 GPIOn Open Drain Register (GP1ODR–GP2ODR)

   GP1ODR : aliased Unsigned_32
      with Address              => To_Address (GPIO1_BASEADDRESS + 16#04#),
           Volatile_Full_Access => True,
           Import               => True,
           Convention           => Ada;

   -- 21.3.3 GPIOn Data Register (GP1DAT–GP2DAT)

   GP1DAT : aliased Unsigned_32
      with Address              => To_Address (GPIO1_BASEADDRESS + 16#08#),
           Volatile_Full_Access => True,
           Import               => True,
           Convention           => Ada;

end MPC83XX;

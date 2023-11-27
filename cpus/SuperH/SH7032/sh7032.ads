-----------------------------------------------------------------------------------------------------------------------
--                                                     SweetAda                                                      --
-----------------------------------------------------------------------------------------------------------------------
-- __HDS__                                                                                                           --
-- __FLN__ sh7032.ads                                                                                                --
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

package SH7032 is

   --========================================================================--
   --                                                                        --
   --                                                                        --
   --                               Public part                              --
   --                                                                        --
   --                                                                        --
   --========================================================================--

   pragma Preelaborate;

   use System;
   use System.Storage_Elements;
   use Interfaces;
   use Bits;

   ----------------------------------------------------------------------------
   -- Section 8 Bus State Controller (BSC)
   ----------------------------------------------------------------------------

   -- 8.2.1 Bus Control Register (BCR)

   BAS_WRHLA0 : constant := 0; -- WRH, WRL, and A0 enabled
   BAS_LHBSWR : constant := 1; -- LBS, WR, and HBS enabled

   RDDTY_50 : constant := 0; -- RD signal high-level duty cycle is 50% of T1 state
   RDDTY_35 : constant := 1; -- RD signal high-level duty cycle is 35% of T1 state

   type Bus_Control_Register_Type is
   record
      Reserved : Bits_11 := 0;
      BAS      : Bits_1;       -- Byte Access Select
      RDDTY    : Bits_1;       -- RD Duty
      WARP     : Boolean;      -- Warp Mode Bit
      IOE      : Boolean;      -- Multiplexed I/O Enable Bit
      DRAME    : Boolean;      -- DRAM Enable Bit
   end record with
      Bit_Order => Low_Order_First,
      Size      => 16;
   for Bus_Control_Register_Type use
   record
      Reserved at 0 range  0 .. 10;
      BAS      at 0 range 11 .. 11;
      RDDTY    at 0 range 12 .. 12;
      WARP     at 0 range 13 .. 13;
      IOE      at 0 range 14 .. 14;
      DRAME    at 0 range 15 .. 15;
   end record;

   BCR_ADDRESS : constant := 16#05FF_FFA0#;

   BCR : aliased Bus_Control_Register_Type
      with Address              => To_Address (BCR_ADDRESS),
           Volatile_Full_Access => True,
           Import               => True,
           Convention           => Ada;

   ----------------------------------------------------------------------------
   -- Section 13 Serial Communication Interface (SCI)
   ----------------------------------------------------------------------------

   -- 13.2.5 Serial Mode Register

   SCI_SYSCLOCK    : constant Bits_2 := 2#00#;
   SCI_SYSCLOCK_4  : constant Bits_2 := 2#01#;
   SCI_SYSCLOCK_16 : constant Bits_2 := 2#10#;
   SCI_SYSCLOCK_64 : constant Bits_2 := 2#11#;

   SCI_STOPBIT_1 : constant Bits_1 := 0;
   SCI_STOPBIT_2 : constant Bits_1 := 1;

   SCI_PARITY_EVEN : constant Bits_1 := 0;
   SCI_PARITY_ODD  : constant Bits_1 := 1;

   SCI_DATA_8 : constant Bits_1 := 0;
   SCI_DATA_7 : constant Bits_1 := 1;

   SCI_MODE_ASYNC : constant Bits_1 := 0;
   SCI_MODE_SYNC  : constant Bits_1 := 1;

   type Serial_Mode_Register_Type is
   record
      CKS  : Bits_2;
      MP   : Boolean;
      STOP : Bits_1;
      OE   : Bits_1;
      PE   : Boolean;
      CHR  : Bits_1;
      CA   : Bits_1;
   end record with
      Bit_Order => Low_Order_First,
      Size      => 8;
   for Serial_Mode_Register_Type use
   record
      CKS  at 0 range 0 .. 1;
      MP   at 0 range 2 .. 2;
      STOP at 0 range 3 .. 3;
      OE   at 0 range 4 .. 4;
      PE   at 0 range 5 .. 5;
      CHR  at 0 range 6 .. 6;
      CA   at 0 range 7 .. 7;
   end record;

   -- 13.1.4 Register Configuration

   type SCI_Type is
   record
      SMR : Serial_Mode_Register_Type with Volatile_Full_Access => True;
      BRR : Unsigned_8                with Volatile_Full_Access => True;
      TDR : Unsigned_8                with Volatile_Full_Access => True;
      RDR : Unsigned_8                with Volatile_Full_Access => True;
   end record with
      Size => 48;
   for SCI_Type use
   record
      SMR at 0 range 0 .. 7;
      BRR at 1 range 0 .. 7;
      TDR at 3 range 0 .. 7;
      RDR at 5 range 0 .. 7;
   end record;

   SCI0 : aliased SCI_Type
      with Address    => To_Address (16#05FF_FEC0#),
           Volatile   => True,
           Import     => True,
           Convention => Ada;

   SCI1 : aliased SCI_Type
      with Address    => To_Address (16#05FF_FEC8#),
           Volatile   => True,
           Import     => True,
           Convention => Ada;

end SH7032;

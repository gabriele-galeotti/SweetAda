-----------------------------------------------------------------------------------------------------------------------
--                                                     SweetAda                                                      --
-----------------------------------------------------------------------------------------------------------------------
-- __HDS__                                                                                                           --
-- __FLN__ msp432p401r.ads                                                                                           --
-- __DSC__                                                                                                           --
-- __HSH__ e69de29bb2d1d6434b8b29ae775ad8c2e48c5391                                                                  --
-- __HDE__                                                                                                           --
-----------------------------------------------------------------------------------------------------------------------
-- Copyright (C) 2020-2024 Gabriele Galeotti                                                                         --
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

package MSP432P401R
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
   use Bits;

   -- 3.3.1 RSTCTL_RESET_REQ

   type RSTCTL_RESET_REQ_Type is record
      SOFT_REQ  : Boolean;      -- If written with 1, generates a Hard Reset request to the Reset Controller
      HARD_REQ  : Boolean;      -- If written with 1, generates a Soft Reset request to the Reset Controller
      Reserved1 : Bits_6 := 0;
      RSTKEY    : Bits_8;       -- Must be written with 69h to enable writes to bits 1-0 (in the same write ...
      Reserved2 : Bits_16 := 0;
   end record
      with Bit_Order => Low_Order_First,
           Size      => 32;
   for RSTCTL_RESET_REQ_Type use record
      SOFT_REQ  at 0 range  0 ..  0;
      HARD_REQ  at 0 range  1 ..  1;
      Reserved1 at 0 range  2 ..  7;
      RSTKEY    at 0 range  8 .. 15;
      Reserved2 at 0 range 16 .. 31;
   end record;

   RSTCTL_RESET_REQ_ADDRESS : constant := 16#E004_2000#;

   RSTCTL_RESET_REQ : aliased RSTCTL_RESET_REQ_Type
      with Address              => To_Address (RSTCTL_RESET_REQ_ADDRESS),
           Volatile_Full_Access => True,
           Import               => True,
           Convention           => Ada;

   -- 3.3.2 RSTCTL_HARDRESET_STAT
   -- 3.3.5 RSTCTL_SOFTRESET_STAT

   type RSTCTL_RESET_STAT_Type is record
      SRC0     : Boolean;      -- If 1, indicates that SRC... was the source of the Hard/Soft Reset
      SRC1     : Boolean;      -- ''
      SRC2     : Boolean;      -- ''
      SRC3     : Boolean;      -- ''
      SRC4     : Boolean;      -- ''
      SRC5     : Boolean;      -- ''
      SRC6     : Boolean;      -- ''
      SRC7     : Boolean;      -- ''
      SRC8     : Boolean;      -- ''
      SRC9     : Boolean;      -- ''
      SRC10    : Boolean;      -- ''
      SRC11    : Boolean;      -- ''
      SRC12    : Boolean;      -- ''
      SRC13    : Boolean;      -- ''
      SRC14    : Boolean;      -- ''
      SRC15    : Boolean;      -- ''
      Reserved : Bits_16 := 0;
   end record
      with Bit_Order => Low_Order_First,
           Size      => 32;
   for RSTCTL_RESET_STAT_Type use record
      SRC0     at 0 range  0 ..  0;
      SRC1     at 0 range  1 ..  1;
      SRC2     at 0 range  2 ..  2;
      SRC3     at 0 range  3 ..  3;
      SRC4     at 0 range  4 ..  4;
      SRC5     at 0 range  5 ..  5;
      SRC6     at 0 range  6 ..  6;
      SRC7     at 0 range  7 ..  7;
      SRC8     at 0 range  8 ..  8;
      SRC9     at 0 range  9 ..  9;
      SRC10    at 0 range 10 .. 10;
      SRC11    at 0 range 11 .. 11;
      SRC12    at 0 range 12 .. 12;
      SRC13    at 0 range 13 .. 13;
      SRC14    at 0 range 14 .. 14;
      SRC15    at 0 range 15 .. 15;
      Reserved at 0 range 16 .. 31;
   end record;

   RSTCTL_HARDRESET_STAT_ADDRESS : constant := 16#E004_2004#;

   RSTCTL_HARDRESET_STAT : aliased RSTCTL_RESET_STAT_Type
      with Address              => To_Address (RSTCTL_HARDRESET_STAT_ADDRESS),
           Volatile_Full_Access => True,
           Import               => True,
           Convention           => Ada;

   RSTCTL_SOFTRESET_STAT_ADDRESS : constant := 16#E004_2010#;

   RSTCTL_SOFTRESET_STAT : aliased RSTCTL_RESET_STAT_Type
      with Address              => To_Address (RSTCTL_SOFTRESET_STAT_ADDRESS),
           Volatile_Full_Access => True,
           Import               => True,
           Convention           => Ada;

   -- 3.3.3 RSTCTL_HARDRESET_CLR
   -- 3.3.6 RSTCTL_SOFTRESET_CLR

   type RSTCTL_RESET_CLR_Type is record
      SRC0     : Boolean := False; -- Write 1 clears the corresponding bit in the RSTCTL_????RESET_STAT
      SRC1     : Boolean := False; -- ''
      SRC2     : Boolean := False; -- ''
      SRC3     : Boolean := False; -- ''
      SRC4     : Boolean := False; -- ''
      SRC5     : Boolean := False; -- ''
      SRC6     : Boolean := False; -- ''
      SRC7     : Boolean := False; -- ''
      SRC8     : Boolean := False; -- ''
      SRC9     : Boolean := False; -- ''
      SRC10    : Boolean := False; -- ''
      SRC11    : Boolean := False; -- ''
      SRC12    : Boolean := False; -- ''
      SRC13    : Boolean := False; -- ''
      SRC14    : Boolean := False; -- ''
      SRC15    : Boolean := False; -- ''
      Reserved : Bits_16 := 0;
   end record
      with Bit_Order => Low_Order_First,
           Size      => 32;
   for RSTCTL_RESET_CLR_Type use record
      SRC0     at 0 range  0 ..  0;
      SRC1     at 0 range  1 ..  1;
      SRC2     at 0 range  2 ..  2;
      SRC3     at 0 range  3 ..  3;
      SRC4     at 0 range  4 ..  4;
      SRC5     at 0 range  5 ..  5;
      SRC6     at 0 range  6 ..  6;
      SRC7     at 0 range  7 ..  7;
      SRC8     at 0 range  8 ..  8;
      SRC9     at 0 range  9 ..  9;
      SRC10    at 0 range 10 .. 10;
      SRC11    at 0 range 11 .. 11;
      SRC12    at 0 range 12 .. 12;
      SRC13    at 0 range 13 .. 13;
      SRC14    at 0 range 14 .. 14;
      SRC15    at 0 range 15 .. 15;
      Reserved at 0 range 16 .. 31;
   end record;

   RSTCTL_HARDRESET_CLR_ADDRESS : constant := 16#E004_2008#;

   RSTCTL_HARDRESET_CLR : aliased RSTCTL_RESET_CLR_Type
      with Address              => To_Address (RSTCTL_HARDRESET_CLR_ADDRESS),
           Volatile_Full_Access => True,
           Import               => True,
           Convention           => Ada;

   RSTCTL_SOFTRESET_CLR_ADDRESS : constant := 16#E004_2014#;

   RSTCTL_SOFTRESET_CLR : aliased RSTCTL_RESET_CLR_Type
      with Address              => To_Address (RSTCTL_SOFTRESET_CLR_ADDRESS),
           Volatile_Full_Access => True,
           Import               => True,
           Convention           => Ada;

   -- 3.3.4 RSTCTL_HARDRESET_SET
   -- 3.3.7 RSTCTL_SOFTRESET_SET

   type RSTCTL_RESET_SET_Type is record
      SRC0     : Boolean := False; -- Write 1 sets the corresponding bit in the RSTCTL_????RESET_STAT ...
      SRC1     : Boolean := False; -- ''
      SRC2     : Boolean := False; -- ''
      SRC3     : Boolean := False; -- ''
      SRC4     : Boolean := False; -- ''
      SRC5     : Boolean := False; -- ''
      SRC6     : Boolean := False; -- ''
      SRC7     : Boolean := False; -- ''
      SRC8     : Boolean := False; -- ''
      SRC9     : Boolean := False; -- ''
      SRC10    : Boolean := False; -- ''
      SRC11    : Boolean := False; -- ''
      SRC12    : Boolean := False; -- ''
      SRC13    : Boolean := False; -- ''
      SRC14    : Boolean := False; -- ''
      SRC15    : Boolean := False; -- ''
      Reserved : Bits_16 := 0;
   end record
      with Bit_Order => Low_Order_First,
           Size      => 32;
   for RSTCTL_RESET_SET_Type use record
      SRC0     at 0 range  0 ..  0;
      SRC1     at 0 range  1 ..  1;
      SRC2     at 0 range  2 ..  2;
      SRC3     at 0 range  3 ..  3;
      SRC4     at 0 range  4 ..  4;
      SRC5     at 0 range  5 ..  5;
      SRC6     at 0 range  6 ..  6;
      SRC7     at 0 range  7 ..  7;
      SRC8     at 0 range  8 ..  8;
      SRC9     at 0 range  9 ..  9;
      SRC10    at 0 range 10 .. 10;
      SRC11    at 0 range 11 .. 11;
      SRC12    at 0 range 12 .. 12;
      SRC13    at 0 range 13 .. 13;
      SRC14    at 0 range 14 .. 14;
      SRC15    at 0 range 15 .. 15;
      Reserved at 0 range 16 .. 31;
   end record;

   RSTCTL_HARDRESET_SET_ADDRESS : constant := 16#E004_200C#;

   RSTCTL_HARDRESET_SET : aliased RSTCTL_RESET_SET_Type
      with Address              => To_Address (RSTCTL_HARDRESET_SET_ADDRESS),
           Volatile_Full_Access => True,
           Import               => True,
           Convention           => Ada;

   RSTCTL_SOFTRESET_SET_ADDRESS : constant := 16#E004_2018#;

   RSTCTL_SOFTRESET_SET : aliased RSTCTL_RESET_SET_Type
      with Address              => To_Address (RSTCTL_SOFTRESET_SET_ADDRESS),
           Volatile_Full_Access => True,
           Import               => True,
           Convention           => Ada;

   -- 12.4 Digital I/O Registers

   PORT_BASE : constant := 16#4000_4C00#;

   P1OUT_L : aliased Unsigned_8
      with Address    => To_Address (PORT_BASE + 16#02#),
           Volatile   => True,
           Import     => True,
           Convention => Ada;
   P1DIR_L : aliased Unsigned_8
      with Address    => To_Address (PORT_BASE + 16#04#),
           Volatile   => True,
           Import     => True,
           Convention => Ada;
   P2OUT_L : aliased Unsigned_8
      with Address    => To_Address (PORT_BASE + 16#03#),
           Volatile   => True,
           Import     => True,
           Convention => Ada;
   P2DIR_L : aliased Unsigned_8
      with Address    => To_Address (PORT_BASE + 16#05#),
           Volatile   => True,
           Import     => True,
           Convention => Ada;

   -- 17.3.1 WDTCTL Register

   WDTIS_DIV2E31 : constant := 2#000#; -- Watchdog clock source / 2^31 (18:12:16 at 32.768 kHz)
   WDTIS_DIV2E27 : constant := 2#001#; -- Watchdog clock source / 2^27 (01:08:16 at 32.768 kHz)
   WDTIS_DIV2E23 : constant := 2#010#; -- Watchdog clock source / 2^23 (00:04:16 at 32.768 kHz)
   WDTIS_DIV2E19 : constant := 2#011#; -- Watchdog clock source / 2^19 (00:00:16 at 32.768 kHz)
   WDTIS_DIV2E15 : constant := 2#100#; -- Watchdog clock source / 2^15 (1 s at 32.768 kHz)
   WDTIS_DIV2E13 : constant := 2#101#; -- Watchdog clock source / 2^13 (250 ms at 32.768 kHz)
   WDTIS_DIV2E9  : constant := 2#110#; -- Watchdog clock source / 2^9 (15.625 ms at 32.768 kHz)
   WDTIS_DIV2E6  : constant := 2#111#; -- Watchdog clock source / 2^6 (1.95 ms at 32.768 kHz)

   WDTTMSEL_WATCHDOG : constant := 0; -- Watchdog mode
   WDTTMSEL_TIMER    : constant := 1; -- Interval timer mode

   WDTSSEL_SMCLK  : constant := 2#00#; -- SMCLK
   WDTSSEL_ACLK   : constant := 2#01#; -- ACLK
   WDTSSEL_VLOCLK : constant := 2#10#; -- VLOCLK
   WDTSSEL_BCLK   : constant := 2#11#; -- BCLK

   WDTPW_PASSWD : constant := 16#5A#;

   type WDTCTL_Type is record
      WDTIS    : Bits_3;  -- Watchdog timer interval select.
      WDTCNTCL : Boolean; -- Watchdog timer counter clear.
      WDTTMSEL : Bits_1;  -- Watchdog timer mode select
      WDTSSEL  : Bits_2;  -- Watchdog timer clock source select
      WDTHOLD  : Boolean; -- Watchdog timer hold.
      WDTPW    : Bits_8;  -- Watchdog timer password.
   end record
      with Bit_Order => Low_Order_First,
           Size      => 16;
   for WDTCTL_Type use record
      WDTIS    at 0 range 0 ..  2;
      WDTCNTCL at 0 range 3 ..  3;
      WDTTMSEL at 0 range 4 ..  4;
      WDTSSEL  at 0 range 5 ..  6;
      WDTHOLD  at 0 range 7 ..  7;
      WDTPW    at 0 range 8 .. 15;
   end record;

   WDTCTL_ADDRESS : constant := 16#4000_480C#;

   WDTCTL : aliased WDTCTL_Type
      with Address    => To_Address (WDTCTL_ADDRESS),
           Volatile   => True,
           Import     => True,
           Convention => Ada;

end MSP432P401R;

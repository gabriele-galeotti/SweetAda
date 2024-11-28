-----------------------------------------------------------------------------------------------------------------------
--                                                     SweetAda                                                      --
-----------------------------------------------------------------------------------------------------------------------
-- __HDS__                                                                                                           --
-- __FLN__ rtc.ads                                                                                                   --
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
with Bits;
with Time;

package RTC
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
   use Bits;
   use Time;

   -- register type for S1, MI1, H1, D1, MO1, Y1, Y10
   type DATA4_Type is record
      DATA   : Bits_4;
      Unused : Bits_4 := 0;
   end record
      with Bit_Order => Low_Order_First,
           Size      => 8;
   for DATA4_Type use record
      DATA   at 0 range 0 .. 3;
      Unused at 0 range 4 .. 7;
   end record;

   -- register type for S10, MI10, W
   type DATA3_Type is record
      DATA   : Bits_3;
      Unused : Bits_5 := 0;
   end record
      with Bit_Order => Low_Order_First,
           Size      => 8;
   for DATA3_Type use record
      DATA   at 0 range 0 .. 2;
      Unused at 0 range 3 .. 7;
   end record;

   -- register type for H10
   type H10_Type is record
      H      : Bits_2;
      PM_AM  : Bits_1;
      Unused : Bits_5 := 0;
   end record
      with Bit_Order => Low_Order_First,
           Size      => 8;
   for H10_Type use record
      H      at 0 range 0 .. 1;
      PM_AM  at 0 range 2 .. 2;
      Unused at 0 range 3 .. 7;
   end record;

   -- register type for D10
   type D10_Type is record
      D      : Bits_2;
      Unused : Bits_6 := 0;
   end record
      with Bit_Order => Low_Order_First,
           Size      => 8;
   for D10_Type use record
      D      at 0 range 0 .. 1;
      Unused at 0 range 2 .. 7;
   end record;

   -- register type for MO10
   type MO10_Type is record
      M      : Bits_1;
      Unused : Bits_7 := 0;
   end record
      with Bit_Order => Low_Order_First,
           Size      => 8;
   for MO10_Type use record
      M      at 0 range 0 .. 0;
      Unused at 0 range 1 .. 7;
   end record;

   -- register type for CD
   type CD_Type is record
      HOLD     : Boolean;      -- inhibits the 1Hz clock to the S1 counter
      BUSY     : Boolean;      -- shows the interface condition with microcontroller/microprocessors.
      IRQ_FLAG : Boolean;      -- indicates that an interrupt has occurred to the microcomputer if IRQ = 1.
      ADJ30    : Boolean;      -- 30-second adjustment
      Unused   : Bits_4  := 0;
   end record
      with Bit_Order => Low_Order_First,
           Size      => 8;
   for CD_Type use record
      HOLD     at 0 range 0 .. 0;
      BUSY     at 0 range 1 .. 1;
      IRQ_FLAG at 0 range 2 .. 2;
      ADJ30    at 0 range 3 .. 3;
      Unused   at 0 range 4 .. 7;
   end record;

   -- constants for CE
   ITRPT_STND_STD : constant := 0; -- fixed cycle wave-form with a low-level pulse width of 7.8125ms ...
   ITRPT_STND_INT : constant := 1; -- no fixed cycle
   T_2      : constant := 2#00#; -- Duty CYCLE of "0" level when ITRPT/STND bit is "0".
   T_128    : constant := 2#01#; -- ''
   T_7680   : constant := 2#10#; -- ''
   T_460800 : constant := 2#11#; -- ''

   -- register type for CE
   type CE_Type is record
      MASK       : Boolean;      -- This bit controls the STD.P output.
      ITRPT_STND : Bits_1;       -- used to switch the STD.P output between its two modes of operation
      T          : Bits_2;       -- determine the period of the STD.P output in both interrupt and Fixed timing ...
      Unused     : Bits_4  := 0;
   end record
      with Bit_Order => Low_Order_First,
           Size      => 8;
   for CE_Type use record
      MASK       at 0 range 0 .. 0;
      ITRPT_STND at 0 range 1 .. 1;
      T          at 0 range 2 .. 3;
      Unused     at 0 range 4 .. 7;
   end record;

   -- constants for CF
   HOUR_MODE_12 : constant := 0; -- 12 hour mode is selected and the PM/AM bit is valid.
   HOUR_MODE_24 : constant := 1; -- 24 hour mode is selected and the PM/AM bit is invalid.

   -- register type for CF
   type CF_Type is record
      REST      : Boolean;      -- used to clear the clock's internal divider/counter of less than a second.
      STOP      : Boolean;      -- inhibits carries into the 8192Hz divider stage.
      HOUR_MODE : Bits_1;       -- selection of 24/12 hour time modes.
      TEST      : Boolean;      -- the input to the SECONDS counter comes from the counter/divider stage instead of ...
      Unused    : Bits_4  := 0;
   end record
      with Bit_Order => Low_Order_First,
           Size      => 8;
   for CF_Type use record
      REST      at 0 range 0 .. 0;
      STOP      at 0 range 1 .. 1;
      HOUR_MODE at 0 range 2 .. 2;
      TEST      at 0 range 3 .. 3;
      Unused    at 0 range 4 .. 7;
   end record;

   type MSM6242B_Type is record
      S1   : DATA4_Type with Volatile_Full_Access => True; -- 1-second digit register
      S10  : DATA3_Type with Volatile_Full_Access => True; -- 10-second digit register
      MI1  : DATA4_Type with Volatile_Full_Access => True; -- 1-minute digit register
      MI10 : DATA3_Type with Volatile_Full_Access => True; -- 10-minute digit register
      H1   : DATA4_Type with Volatile_Full_Access => True; -- 1-hour digit register
      H10  : H10_Type   with Volatile_Full_Access => True; -- PM/AM, 10-hour digit register
      D1   : DATA4_Type with Volatile_Full_Access => True; -- 1-day digit register
      D10  : D10_Type   with Volatile_Full_Access => True; -- 10-day digit register
      MO1  : DATA4_Type with Volatile_Full_Access => True; -- 1-month digit register
      MO10 : MO10_Type  with Volatile_Full_Access => True; -- 10-month digit register
      Y1   : DATA4_Type with Volatile_Full_Access => True; -- 1-year digit register
      Y10  : DATA4_Type with Volatile_Full_Access => True; -- 10-year digit register
      W    : DATA3_Type with Volatile_Full_Access => True; -- Week register
      CD   : CD_Type    with Volatile_Full_Access => True; -- Control Register D
      CE   : CE_Type    with Volatile_Full_Access => True; -- Control Register E
      CF   : CF_Type    with Volatile_Full_Access => True; -- Control Register F
   end record
      with Size => 16#3D# * 8;
   for MSM6242B_Type use record
      S1   at 16#00# range 0 .. 7;
      S10  at 16#04# range 0 .. 7;
      MI1  at 16#08# range 0 .. 7;
      MI10 at 16#0C# range 0 .. 7;
      H1   at 16#10# range 0 .. 7;
      H10  at 16#14# range 0 .. 7;
      D1   at 16#18# range 0 .. 7;
      D10  at 16#1C# range 0 .. 7;
      MO1  at 16#20# range 0 .. 7;
      MO10 at 16#24# range 0 .. 7;
      Y1   at 16#28# range 0 .. 7;
      Y10  at 16#2C# range 0 .. 7;
      W    at 16#30# range 0 .. 7;
      CD   at 16#34# range 0 .. 7;
      CE   at 16#38# range 0 .. 7;
      CF   at 16#3C# range 0 .. 7;
   end record;

   -- MSM6242B U801, wired on D0..D7

   MSM6242B_ADDRESS : constant := 16#00DC_0001#;

   MSM6242B : aliased MSM6242B_Type
      with Address    => System'To_Address (MSM6242B_ADDRESS),
           Volatile   => True,
           Import     => True,
           Convention => Ada;

   procedure Read_Clock
      (T : out TM_Time);

end RTC;

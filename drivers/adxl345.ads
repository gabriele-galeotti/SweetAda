-----------------------------------------------------------------------------------------------------------------------
--                                                     SweetAda                                                      --
-----------------------------------------------------------------------------------------------------------------------
-- __HDS__                                                                                                           --
-- __FLN__ adxl345.ads                                                                                               --
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
with Bits;

package ADXL345
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

pragma Style_Checks (Off);

   ----------------------------------------------------------------------------
   -- ADXL345
   -- 3-Axis, ±2 g/±4 g/±8 g/±16 g Digital Accelerometer
   -- Rev. G
   ----------------------------------------------------------------------------

   -- 7-bit I2C address
   I2C_ADDRESS     : constant := 16#53#; -- SDO/ALT ADDRESS pin = GND
   I2C_ADDRESS_ALT : constant := 16#1D#; -- SDO/ALT ADDRESS pin = HIGH

   -- REGISTER MAP Table 19

   DEVID          : constant := 16#00#; -- R   11100101 Device ID
   -- 0x01 to 0x1C 1 to 28 Reserved     -- Reserved; do not access
   THRESH_TAP     : constant := 16#1D#; -- R/W 00000000 Tap threshold
   OFSX           : constant := 16#1E#; -- R/W 00000000 X-axis offset
   OFSY           : constant := 16#1F#; -- R/W 00000000 Y-axis offset
   OFSZ           : constant := 16#20#; -- R/W 00000000 Z-axis offset
   DUR            : constant := 16#21#; -- R/W 00000000 Tap duration
   Latent         : constant := 16#22#; -- R/W 00000000 Tap latency
   Window         : constant := 16#23#; -- R/W 00000000 Tap window
   THRESH_ACT     : constant := 16#24#; -- R/W 00000000 Activity threshold
   THRESH_INACT   : constant := 16#25#; -- R/W 00000000 Inactivity threshold
   TIME_INACT     : constant := 16#26#; -- R/W 00000000 Inactivity time
   ACT_INACT_CTL  : constant := 16#27#; -- R/W 00000000 Axis enable control for activity and inactivity detection
   THRESH_FF      : constant := 16#28#; -- R/W 00000000 Free-fall threshold
   TIME_FF        : constant := 16#29#; -- R/W 00000000 Free-fall time
   TAP_AXES       : constant := 16#2A#; -- R/W 00000000 Axis control for single tap/double tap
   ACT_TAP_STATUS : constant := 16#2B#; -- R   00000000 Source of single tap/double tap
   BW_RATE        : constant := 16#2C#; -- R/W 00001010 Data rate and power mode control
   POWER_CTL      : constant := 16#2D#; -- R/W 00000000 Power-saving features control
   INT_ENABLE     : constant := 16#2E#; -- R/W 00000000 Interrupt enable control
   INT_MAP        : constant := 16#2F#; -- R/W 00000000 Interrupt mapping control
   INT_SOURCE     : constant := 16#30#; -- R   00000010 Source of interrupts
   DATA_FORMAT    : constant := 16#31#; -- R/W 00000000 Data format control
   DATAX0         : constant := 16#32#; -- R   00000000 X-Axis Data 0
   DATAX1         : constant := 16#33#; -- R   00000000 X-Axis Data 1
   DATAY0         : constant := 16#34#; -- R   00000000 Y-Axis Data 0
   DATAY1         : constant := 16#35#; -- R   00000000 Y-Axis Data 1
   DATAZ0         : constant := 16#36#; -- R   00000000 Z-Axis Data 0
   DATAZ1         : constant := 16#37#; -- R   00000000 Z-Axis Data 1
   FIFO_CTL       : constant := 16#38#; -- R/W 00000000 FIFO control
   FIFO_STATUS    : constant := 16#39#; -- R   00000000 FIFO status

   -- Register 0x00—DEVID (Read Only)

   -- Register 0x1D—THRESH_TAP (Read/Write)

   -- Register 0x1E, Register 0x1F, Register 0x20—OFSX, OFSY, OFSZ (Read/Write)

   -- Register 0x21—DUR (Read/Write)

   -- Register 0x22—Latent (Read/Write)

   -- Register 0x23—Window (Read/Write)

   -- Register 0x24—THRESH_ACT (Read/Write)

   -- Register 0x25—THRESH_INACT (Read/Write)

   -- Register 0x26—TIME_INACT (Read/Write)

   -- Register 0x27—ACT_INACT_CTL (Read/Write)

   INACT_DC : constant := 0; -- selects dc-coupled operation
   INACT_AC : constant := 1; -- enables ac-coupled operation

   ACT_DC : constant := 0; -- selects dc-coupled operation
   ACT_AC : constant := 1; -- enables ac-coupled operation

   type ACT_INACT_CTL_Type is record
      INACT_Z : Boolean; -- enable
      INACT_Y : Boolean; -- enable
      INACT_X : Boolean; -- enable
      INACT   : Bits_1;  -- ac/dc
      ACT_Z   : Boolean; -- enable
      ACT_Y   : Boolean; -- enable
      ACT_X   : Boolean; -- enable
      ACT     : Bits_1;  -- ac/dc
   end record
      with Bit_Order => Low_Order_First,
           Size      => 8;
   for ACT_INACT_CTL_Type use record
      INACT_Z at 0 range 0 .. 0;
      INACT_Y at 0 range 1 .. 1;
      INACT_X at 0 range 2 .. 2;
      INACT   at 0 range 3 .. 3;
      ACT_Z   at 0 range 4 .. 4;
      ACT_Y   at 0 range 5 .. 5;
      ACT_X   at 0 range 6 .. 6;
      ACT     at 0 range 7 .. 7;
   end record;

   -- Register 0x28—THRESH_FF (Read/Write)

   -- Register 0x29—TIME_FF (Read/Write)

   -- Register 0x2A—TAP_AXES (Read/Write)

   type TAP_AXES_Type is record
      TAP_Z    : Boolean; -- enable
      TAP_Y    : Boolean; -- enable
      TAP_X    : Boolean; -- enable
      Suppress : Boolean; -- Suppress
      Unused   : Bits_4;
   end record
      with Bit_Order => Low_Order_First,
           Size      => 8;
   for TAP_AXES_Type use record
      TAP_Z    at 0 range 0 .. 0;
      TAP_Y    at 0 range 1 .. 1;
      TAP_X    at 0 range 2 .. 2;
      Suppress at 0 range 3 .. 3;
      Unused   at 0 range 4 .. 7;
   end record;

   -- Register 0x2B—ACT_TAP_STATUS (Read Only)

   type ACT_TAP_STATUS_Type is record
      TAP_Z  : Boolean; -- source
      TAP_Y  : Boolean; -- source
      TAP_X  : Boolean; -- source
      Asleep : Boolean; -- Asleep
      ACT_Z  : Boolean; -- source
      ACT_Y  : Boolean; -- source
      ACT_X  : Boolean; -- source
      Unused : Bits_1;
   end record
      with Bit_Order => Low_Order_First,
           Size      => 8;
   for ACT_TAP_STATUS_Type use record
      TAP_Z  at 0 range 0 .. 0;
      TAP_Y  at 0 range 1 .. 1;
      TAP_X  at 0 range 2 .. 2;
      Asleep at 0 range 3 .. 3;
      ACT_Z  at 0 range 4 .. 4;
      ACT_Y  at 0 range 5 .. 5;
      ACT_X  at 0 range 6 .. 6;
      Unused at 0 range 7 .. 7;
   end record;

   -- Register 0x2C—BW_RATE (Read/Write)

   --                        Code        Output Data Rate (Hz) Bandwidth (Hz) Rate Code IDD (μA)
   Rate_3200   : constant := 2#1111#; -- 3200                  1600           140
   Rate_1600   : constant := 2#1110#; -- 1600                  800            90
   Rate_800    : constant := 2#1101#; -- 800                   400            140
   Rate_400    : constant := 2#1100#; -- 400                   200            140
   Rate_200    : constant := 2#1011#; -- 200                   100            140
   Rate_100    : constant := 2#1010#; -- 100                   50             140
   Rate_50     : constant := 2#1001#; -- 50                    25             90
   Rate_25     : constant := 2#1000#; -- 25                    12.5           60
   Rate_12R5   : constant := 2#0111#; -- 12.5                  6.25           50
   Rate_6R25   : constant := 2#0110#; -- 6.25                  3.13           45
   Rate_3R13   : constant := 2#0101#; -- 3.13                  1.56           40
   Rate_1R56   : constant := 2#0100#; -- 1.56                  0.78           34
   Rate_0R78   : constant := 2#0011#; -- 0.78                  0.39           23
   Rate_0R39   : constant := 2#0010#; -- 0.39                  0.20           23
   Rate_0R20   : constant := 2#0001#; -- 0.20                  0.10           23
   Rate_0R10   : constant := 2#0000#; -- 0.10                  0.05           23
   -- LOW POWER
   Rate_LP400  : constant := 2#1100#; -- 400                   200            90
   Rate_LP200  : constant := 2#1011#; -- 200                   100            60
   Rate_LP100  : constant := 2#1010#; -- 100                   50             50
   Rate_LP50   : constant := 2#1001#; -- 50                    25             45
   Rate_LP25   : constant := 2#1000#; -- 25                    12.5           40
   Rate_LP12R5 : constant := 2#0111#; -- 12.5                  6.25           34

   type BW_RATE_Type is record
      Rate      : Bits_4;  -- device bandwidth and output data rate
      LOW_POWER : Boolean; -- reduced power operation
      Unused    : Bits_3;
   end record
      with Bit_Order => Low_Order_First,
           Size      => 8;
   for BW_RATE_Type use record
      Rate      at 0 range 0 .. 3;
      LOW_POWER at 0 range 4 .. 4;
      Unused    at 0 range 5 .. 7;
   end record;

   -- Register 0x2D—POWER_CTL (Read/Write)

   Wakeup_8 : constant := 2#00#; -- 8 Hz
   Wakeup_4 : constant := 2#01#; -- 4 Hz
   Wakeup_2 : constant := 2#10#; -- 2 Hz
   Wakeup_1 : constant := 2#11#; -- 1 Hz

   type POWER_CTL_Type is record
      Wakeup     : Bits_2;  -- frequency of readings in sleep mode
      Sleep      : Boolean; -- Sleep
      Measure    : Boolean; -- Measure
      AUTO_SLEEP : Boolean; -- auto-sleep functionality
      Link       : Boolean; -- enabled delays the start of the activity function until inactivity is detected
      Unused     : Bits_2;
   end record
      with Bit_Order => Low_Order_First,
           Size      => 8;
   for POWER_CTL_Type use record
      Wakeup     at 0 range 0 .. 1;
      Sleep      at 0 range 2 .. 2;
      Measure    at 0 range 3 .. 3;
      AUTO_SLEEP at 0 range 4 .. 4;
      Link       at 0 range 5 .. 5;
      Unused     at 0 range 6 .. 7;
   end record;

   -- Register 0x2E—INT_ENABLE (Read/Write)

   type INT_ENABLE_Type is record
      Overrun    : Boolean; -- enables function to generate interrupt
      Watermark  : Boolean; -- ''
      FREE_FALL  : Boolean; -- ''
      Inactivity : Boolean; -- ''
      Activity   : Boolean; -- ''
      DOUBLE_TAP : Boolean; -- ''
      SINGLE_TAP : Boolean; -- ''
      DATA_READY : Boolean; -- ''
   end record
      with Bit_Order => Low_Order_First,
           Size      => 8;
   for INT_ENABLE_Type use record
      Overrun    at 0 range 0 .. 0;
      Watermark  at 0 range 1 .. 1;
      FREE_FALL  at 0 range 2 .. 2;
      Inactivity at 0 range 3 .. 3;
      Activity   at 0 range 4 .. 4;
      DOUBLE_TAP at 0 range 5 .. 5;
      SINGLE_TAP at 0 range 6 .. 6;
      DATA_READY at 0 range 7 .. 7;
   end record;

   -- Register 0x2F—INT_MAP (R/W)

   type INTPIN_Type is new Bits_1;

   INTPIN_INT1 : constant INTPIN_Type := 0; -- send interrupt to the INT1 pin
   INTPIN_INT2 : constant INTPIN_Type := 1; -- send interrupt to the INT2 pin

   type INT_MAP_Type is record
      Overrun    : INTPIN_Type; -- send interrupt to the INT1 pin or INT2 pin
      Watermark  : INTPIN_Type; -- ''
      FREE_FALL  : INTPIN_Type; -- ''
      Inactivity : INTPIN_Type; -- ''
      Activity   : INTPIN_Type; -- ''
      DOUBLE_TAP : INTPIN_Type; -- ''
      SINGLE_TAP : INTPIN_Type; -- ''
      DATA_READY : INTPIN_Type; -- ''
   end record
      with Bit_Order => Low_Order_First,
           Size      => 8;
   for INT_MAP_Type use record
      Overrun    at 0 range 0 .. 0;
      Watermark  at 0 range 1 .. 1;
      FREE_FALL  at 0 range 2 .. 2;
      Inactivity at 0 range 3 .. 3;
      Activity   at 0 range 4 .. 4;
      DOUBLE_TAP at 0 range 5 .. 5;
      SINGLE_TAP at 0 range 6 .. 6;
      DATA_READY at 0 range 7 .. 7;
   end record;

   -- Register 0x30—INT_SOURCE (Read Only)

   type INT_SOURCE_Type is record
      Overrun    : Boolean; -- function has triggered an event
      Watermark  : Boolean; -- ''
      FREE_FALL  : Boolean; -- ''
      Inactivity : Boolean; -- ''
      Activity   : Boolean; -- ''
      DOUBLE_TAP : Boolean; -- ''
      SINGLE_TAP : Boolean; -- ''
      DATA_READY : Boolean; -- ''
   end record
      with Bit_Order => Low_Order_First,
           Size      => 8;
   for INT_SOURCE_Type use record
      Overrun    at 0 range 0 .. 0;
      Watermark  at 0 range 1 .. 1;
      FREE_FALL  at 0 range 2 .. 2;
      Inactivity at 0 range 3 .. 3;
      Activity   at 0 range 4 .. 4;
      DOUBLE_TAP at 0 range 5 .. 5;
      SINGLE_TAP at 0 range 6 .. 6;
      DATA_READY at 0 range 7 .. 7;
   end record;

   -- Register 0x31—DATA_FORMAT (Read/Write)

   Rang3_2  : constant := 2#00#; -- ±2 g
   Rang3_4  : constant := 2#01#; -- ±4 g
   Rang3_8  : constant := 2#10#; -- ±8 g
   Rang3_16 : constant := 2#11#; -- ±16 g

   Justify_RIGHT : constant := 0; -- selects right-justified mode with sign extension
   Justify_LEFT  : constant := 1; -- selects left-justified (MSB) mode

   INT_INVERT_HIGH : constant := 0; -- sets the interrupts to active high
   INT_INVERT_LOW  : constant := 1; -- sets the interrupts to active low

   SPI_4WIRE : constant := 0; -- sets the device to 4-wire SPI mode
   SPI_3WIRE : constant := 1; -- sets the device to 3-wire SPI mode

   type DATA_FORMAT_Type is record
      Rang3      : Bits_2;  -- g range
      Justify    : Bits_1;  -- Justify
      FULL_RES   : Boolean; -- full resolution mode
      Unused     : Bits_1;
      INT_INVERT : Bits_1;  -- INT_INVERT
      SPI        : Bits_1;  -- SPI
      SELF_TEST  : Boolean; -- applies a self-test force to the sensor
   end record
      with Bit_Order => Low_Order_First,
           Size      => 8;
   for DATA_FORMAT_Type use record
      Rang3      at 0 range 0 .. 1;
      Justify    at 0 range 2 .. 2;
      FULL_RES   at 0 range 3 .. 3;
      Unused     at 0 range 4 .. 4;
      INT_INVERT at 0 range 5 .. 5;
      SPI        at 0 range 6 .. 6;
      SELF_TEST  at 0 range 7 .. 7;
   end record;

   -- Register 0x32 to Register 0x37—DATAX0, DATAX1, DATAY0, DATAY1, DATAZ0, DATAZ1 (Read Only)

   -- Register 0x38—FIFO_CTL (Read/Write)

   Trigger_INT1 : constant := 0; -- links the trigger event of trigger mode to INT1
   Trigger_INT2 : constant := 1; -- links the trigger event to INT2.

   FIFO_MODE_BYPASS  : constant := 2#00#; -- Bypass
   FIFO_MODE_FIFO    : constant := 2#01#; -- FIFO
   FIFO_MODE_STREAM  : constant := 2#10#; -- Stream
   FIFO_MODE_TRIGGER : constant := 2#11#; -- Trigger

   type FIFO_CTL_Type is record
      Samples   : Bits_5; -- Samples
      Trigger   : Bits_1; -- Trigger
      FIFO_MODE : Bits_2; -- FIFO_MODE
   end record
      with Bit_Order => Low_Order_First,
           Size      => 8;
   for FIFO_CTL_Type use record
      Samples   at 0 range 0 .. 4;
      Trigger   at 0 range 5 .. 5;
      FIFO_MODE at 0 range 6 .. 7;
   end record;

   -- Register 0x39—FIFO_STATUS (Read Only)

   type FIFO_STATUS_Type is record
      Entries   : Bits_6;  -- Entries
      Unused    : Bits_1;
      FIFO_TRIG : Boolean; -- FIFO_TRIG
   end record
      with Bit_Order => Low_Order_First,
           Size      => 8;
   for FIFO_STATUS_Type use record
      Entries   at 0 range 0 .. 5;
      Unused    at 0 range 6 .. 6;
      FIFO_TRIG at 0 range 7 .. 7;
   end record;

pragma Style_Checks (On);

end ADXL345;

-----------------------------------------------------------------------------------------------------------------------
--                                                     SweetAda                                                      --
-----------------------------------------------------------------------------------------------------------------------
-- __HDS__                                                                                                           --
-- __FLN__ ina233.ads                                                                                                --
-- __DSC__                                                                                                           --
-- __HSH__ e69de29bb2d1d6434b8b29ae775ad8c2e48c5391                                                                  --
-- __HDE__                                                                                                           --
-----------------------------------------------------------------------------------------------------------------------
-- Copyright (C) 2020-2026 Gabriele Galeotti                                                                         --
--                                                                                                                   --
-- SweetAda web page: http://sweetada.org                                                                            --
-- contact address: gabriele.galeotti@sweetada.org                                                                   --
-- This work is licensed under the terms of the MIT License.                                                         --
-- Please consult the LICENSE.txt file located in the top-level directory.                                           --
-----------------------------------------------------------------------------------------------------------------------

pragma Style_Checks (Off);

with System;
with Bits;

package INA233
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

   ----------------------------------------------------------------------------
   -- INA233 36V, 16-Bit, Ultra-Precise I2C and PMBus Output Current, Voltage,
   -- Power, and Energy Monitor With Alert
   -- SBOS790A – APRIL 2017 – REVISED MARCH 2025
   ----------------------------------------------------------------------------

   CLEAR_FAULTS        : constant := 16#03#;
   RESTORE_DEFAULT_ALL : constant := 16#12#;
   CAPABILITY          : constant := 16#19#;
   IOUT_OC_WARN_LIMIT  : constant := 16#4A#;
   VIN_OV_WARN_LIMIT   : constant := 16#57#;
   VIN_UV_WARN_LIMIT   : constant := 16#58#;
   PIN_OP_WARN_LIMIT   : constant := 16#6B#;
   STATUS_BYTE         : constant := 16#78#;
   STATUS_WORD         : constant := 16#79#;
   STATUS_IOUT         : constant := 16#7B#;
   STATUS_INPUT        : constant := 16#7C#;
   STATUS_CML          : constant := 16#7E#;
   STATUS_MFR_SPECIFIC : constant := 16#80#;
   READ_EIN            : constant := 16#86#;
   READ_VIN            : constant := 16#88#;
   READ_IIN            : constant := 16#89#;
   READ_VOUT           : constant := 16#8B#;
   READ_IOUT           : constant := 16#8C#;
   READ_POUT           : constant := 16#96#;
   READ_PIN            : constant := 16#97#;
   MFR_ID              : constant := 16#99#;
   MFR_MODEL           : constant := 16#9A#;
   MFR_REVISION        : constant := 16#9B#;
   MFR_ADC_CONFIG      : constant := 16#D0#;
   MFR_READ_VSHUNT     : constant := 16#D1#;
   MFR_ALERT_MASK      : constant := 16#D2#;
   MFR_CALIBRATION     : constant := 16#D4#;
   MFR_DEVICE_CONFIG   : constant := 16#D5#;
   CLEAR_EIN           : constant := 16#D6#;
   TI_MFR_ID           : constant := 16#E0#;
   TI_MFR_MODEL        : constant := 16#E1#;
   TI_MFR_REVISION     : constant := 16#E2#;

   -- 6.6.2.4 IOUT_OC_WARN_LIMIT (4Ah)

   type IOUT_OC_WARN_LIMIT_Type is record
      Reserved1 : Bits_3  := 0;
      IO        : Bits_12 := 16#FFF#; -- These bits control the IOUT_OC_WARN_LIMIT.
      Reserved2 : Bits_1  := 0;
   end record
   with Bit_Order => Low_Order_First,
        Size      => 16;
   for IOUT_OC_WARN_LIMIT_Type use record
      Reserved1 at 0 range  0 ..  2;
      IO        at 0 range  3 .. 14;
      Reserved2 at 0 range 15 .. 15;
   end record;

   -- 6.6.2.5 VIN_OV_WARN_LIMIT (57h)

   type VIN_OV_WARN_LIMIT_Type is record
      Reserved1 : Bits_3  := 0;
      V         : Bits_12 := 16#FFF#; -- These bits control the VIN_OV_WARN_LIMIT.
      Reserved2 : Bits_1  := 0;
   end record
   with Bit_Order => Low_Order_First,
        Size      => 16;
   for VIN_OV_WARN_LIMIT_Type use record
      Reserved1 at 0 range  0 ..  2;
      V         at 0 range  3 .. 14;
      Reserved2 at 0 range 15 .. 15;
   end record;

   -- 6.6.2.6 VIN_UV_WARN_LIMIT (58h)

   type VIN_UV_WARN_LIMIT_Type is record
      Reserved1 : Bits_3  := 0;
      V         : Bits_12 := 0; -- These bits control the VIN_UV_WARN_LIMIT.
      Reserved2 : Bits_1  := 0;
   end record
   with Bit_Order => Low_Order_First,
        Size      => 16;
   for VIN_UV_WARN_LIMIT_Type use record
      Reserved1 at 0 range  0 ..  2;
      V         at 0 range  3 .. 14;
      Reserved2 at 0 range 15 .. 15;
   end record;

   -- 6.6.2.7 PIN_OP_WARN_LIMIT (6Bh)

   type PIN_OP_WARN_LIMIT_Type is record
      Reserved : Bits_4  := 0;
      D        : Bits_12 := 16#FFF#; -- These bits control the VIN_UV_WARN_LIMIT.
   end record
   with Bit_Order => Low_Order_First,
        Size      => 16;
   for PIN_OP_WARN_LIMIT_Type use record
      Reserved at 0 range 0 ..  3;
      D        at 0 range 4 .. 15;
   end record;

   -- 6.6.2.8 STATUS_BYTE (78h)

   type STATUS_BYTE_Type is record
      NONE        : Boolean; -- A fault or warning not listed in bits[7:1] has occurred
      CML         : Boolean; -- A communication fault has occurred
      TEMPERATURE : Boolean; -- Not supported
      VIN_UV      : Boolean; -- Not supported
      IOUT_OC     : Boolean; -- Not supported
      VOUT_OV     : Boolean; -- Not supported
      OFF         : Boolean; -- Not supported
      BUSY        : Boolean; -- Not supported
   end record
   with Bit_Order => Low_Order_First,
        Size      => 8;
   for STATUS_BYTE_Type use record
      NONE        at 0 range 0 .. 0;
      CML         at 0 range 1 .. 1;
      TEMPERATURE at 0 range 2 .. 2;
      VIN_UV      at 0 range 3 .. 3;
      IOUT_OC     at 0 range 4 .. 4;
      VOUT_OV     at 0 range 5 .. 5;
      OFF         at 0 range 6 .. 6;
      BUSY        at 0 range 7 .. 7;
   end record;

   -- 6.6.2.9 STATUS_WORD (79h)

   type STATUS_WORD_Type is record
      NONE        : Boolean; -- A fault or warning not listed in bits[7:1] has occurred
      CML         : Boolean; -- A communication fault has occurred
      TEMPERATURE : Boolean; -- Not supported
      VIN_UV      : Boolean; -- Not supported
      IOUT_OC     : Boolean; -- Not supported
      VOUT_OV     : Boolean; -- Not supported
      OFF         : Boolean; -- Not supported
      BUSY        : Boolean; -- Not supported
      UNKNOWN     : Boolean; -- Not supported
      OTHER       : Boolean; -- Not supported
      FANS        : Boolean; -- Not supported
      POWER_GOOD  : Boolean; -- Not supported
      MFR         : Boolean; -- A manufacturer-specific fault or warning has occurred
      INPUT       : Boolean; -- An input voltage, current, or power warning has occurred
      IOUT_POUT   : Boolean; -- An output current or power warning has occurred
      VOUT        : Boolean; -- Not supported
   end record
   with Bit_Order => Low_Order_First,
        Size      => 16;
   for STATUS_WORD_Type use record
      NONE        at 0 range  0 ..  0;
      CML         at 0 range  1 ..  1;
      TEMPERATURE at 0 range  2 ..  2;
      VIN_UV      at 0 range  3 ..  3;
      IOUT_OC     at 0 range  4 ..  4;
      VOUT_OV     at 0 range  5 ..  5;
      OFF         at 0 range  6 ..  6;
      BUSY        at 0 range  7 ..  7;
      UNKNOWN     at 0 range  8 ..  8;
      OTHER       at 0 range  9 ..  9;
      FANS        at 0 range 10 .. 10;
      POWER_GOOD  at 0 range 11 .. 11;
      MFR         at 0 range 12 .. 12;
      INPUT       at 0 range 13 .. 13;
      IOUT_POUT   at 0 range 14 .. 14;
      VOUT        at 0 range 15 .. 15;
   end record;

   -- 6.6.2.10 STATUS_IOUT (7Bh)
   -- 6.6.2.11 STATUS_INPUT (7Ch)
   -- 6.6.2.12 STATUS_CML (7Eh)
   -- 6.6.2.13 STATUS_MFR_SPECIFIC (80h)
   -- 6.6.2.14 READ_EIN (86h)
   -- 6.6.2.15 READ_VIN (88h)
   -- 6.6.2.16 READ_IIN (89h)
   -- 6.6.2.17 READ_VOUT (8Bh)
   -- 6.6.2.18 READ_IOUT (8Ch, R)
   -- 6.6.2.19 READ_POUT (96h, R)
   -- 6.6.2.20 READ_PIN (97h, R)
   -- 6.6.2.21 MFR_ID (99h)
   -- 6.6.2.22 MFR_MODEL (9Ah)
   -- 6.6.2.23 MFR_REVISION (9Bh)

   -- 6.6.3.1 MFR_ADC_CONFIG (D0h)

   MODE_POWER_DOWN           : constant := 2#000#; -- Power-down (or shutdown)
   MODE_SHUNT_TRIGGERED      : constant := 2#001#; -- Shunt voltage, triggered
   MODE_BUS_TRIGGERED        : constant := 2#010#; -- Bus voltage, triggered
   MODE_SHUNT_BUS_TRIGGERED  : constant := 2#011#; -- Shunt and bus, triggered
   MODE_POWER_DOWN_2         : constant := 2#100#; -- Power-down (or shutdown)
   MODE_SHUNT_CONTINUOUS     : constant := 2#101#; -- Shunt voltage, continuous
   MODE_BUS_CONTINUOUS       : constant := 2#110#; -- Bus voltage, continuous
   MODE_SHUNT_BUS_CONTINUOUS : constant := 2#111#; -- Shunt and bus, continuous (default)

   VSHCT_140us  : constant := 2#000#; -- 140 µs
   VSHCT_204us  : constant := 2#001#; -- 204 µs
   VSHCT_332us  : constant := 2#010#; -- 332 µs
   VSHCT_588us  : constant := 2#011#; -- 588 µs
   VSHCT_1ms1   : constant := 2#100#; -- 1.1 ms (default)
   VSHCT_2ms116 : constant := 2#101#; -- 2.116 ms
   VSHCT_4ms156 : constant := 2#110#; -- 4.156 ms
   VSHCT_8ms244 : constant := 2#111#; -- 8.244 ms

   VBUSCT_140us  renames VSHCT_140us;
   VBUSCT_204us  renames VSHCT_204us;
   VBUSCT_332us  renames VSHCT_332us;
   VBUSCT_588us  renames VSHCT_588us;
   VBUSCT_1ms1   renames VSHCT_1ms1;
   VBUSCT_2ms116 renames VSHCT_2ms116;
   VBUSCT_4ms156 renames VSHCT_4ms156;
   VBUSCT_8ms244 renames VSHCT_8ms244;

   AVG_1    : constant := 2#000#; -- NUMBER OF AVERAGES 1 (default)
   AVG_4    : constant := 2#001#; -- NUMBER OF AVERAGES 4
   AVG_16   : constant := 2#010#; -- NUMBER OF AVERAGES 16
   AVG_64   : constant := 2#011#; -- NUMBER OF AVERAGES 64
   AVG_128  : constant := 2#100#; -- NUMBER OF AVERAGES 128
   AVG_256  : constant := 2#101#; -- NUMBER OF AVERAGES 256
   AVG_512  : constant := 2#110#; -- NUMBER OF AVERAGES 512
   AVG_1024 : constant := 2#111#; -- NUMBER OF AVERAGES 1024

   type MFR_ADC_CONFIG_Type is record
      MODE     : Bits_3 := MODE_SHUNT_BUS_CONTINUOUS; -- Operating mode.
      VSHCT    : Bits_3 := VSHCT_1ms1;                -- Shunt voltage conversion time.
      VBUSCT   : Bits_3 := VBUSCT_1ms1;               -- Bus voltage conversion time.
      AVG      : Bits_3 := AVG_1;                     -- Averaging mode.
      Reserved : Bits_4 := 2#0100#;
   end record
   with Bit_Order => Low_Order_First,
        Size      => 16;
   for MFR_ADC_CONFIG_Type use record
      MODE     at 0 range  0 ..  2;
      VSHCT    at 0 range  3 ..  5;
      VBUSCT   at 0 range  6 ..  8;
      AVG      at 0 range  9 .. 11;
      Reserved at 0 range 12 .. 15;
   end record;

   -- 6.6.3.2 MFR_READ_VSHUNT (D1h)

   -- 6.6.3.3 MFR_ALERT_MASK (D2h)

   type MFR_ALERT_MASK_Type is record
      IN_UV_WARNING         : Boolean := False; -- Input undervoltage warning mask
      IN_OV_WARNING         : Boolean := False; -- Input overvoltage warning mask
      IN_OC_WARNING         : Boolean := False; -- Input overcurrent warning mask
      IN_OP_WARNING         : Boolean := False; -- Input overpower warning mask
      Communications        : Boolean := True;  -- Communications or memory fault (or of STATUS_CML)
      POR_event_detected    : Boolean := True;  -- Masks the detection of a power-on-reset event.
      ADC_overflow_detected : Boolean := True;  -- Masks the ADC overflow detection
      Conversion_ready      : Boolean := True;  -- Masks the conversion ready signal to the ALERT pin (masked by default).
   end record
   with Bit_Order => Low_Order_First,
        Size      => 8;
   for MFR_ALERT_MASK_Type use record
      IN_UV_WARNING         at 0 range 0 .. 0;
      IN_OV_WARNING         at 0 range 1 .. 1;
      IN_OC_WARNING         at 0 range 2 .. 2;
      IN_OP_WARNING         at 0 range 3 .. 3;
      Communications        at 0 range 4 .. 4;
      POR_event_detected    at 0 range 5 .. 5;
      ADC_overflow_detected at 0 range 6 .. 6;
      Conversion_ready      at 0 range 7 .. 7;
   end record;

   -- 6.6.3.4 MFR_CALIBRATION (D4h)
   -- 6.6.3.5 MFR_DEVICE_CONFIG (D5h)
   -- 6.6.3.6 CLEAR_EIN (D6h)
   -- 6.6.3.7 TI_MFR_ID (E0h)
   -- 6.6.3.8 TI_MFR_MODEL (E1h)
   -- 6.6.3.9 TI_MFR_REVISION (E2h)

end INA233;

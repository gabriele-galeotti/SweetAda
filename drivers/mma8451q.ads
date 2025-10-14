-----------------------------------------------------------------------------------------------------------------------
--                                                     SweetAda                                                      --
-----------------------------------------------------------------------------------------------------------------------
-- __HDS__                                                                                                           --
-- __FLN__ mma8451q.ads                                                                                              --
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

package MMA8451Q
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
   -- MMA8451Q, 3-axis, 14-bit/8-bit digital accelerometer
   -- Document Number: MMA8451Q
   -- Rev. 10.3, 02/2017
   ----------------------------------------------------------------------------

   WHO_AM_I_ID : constant := 16#1A#; -- WHO_AM_I Device ID

   -- Table 10. I2C address selection table

   -- 7-bit I2C address
   I2C_ADDRESS_LO : constant := 16#1C#; -- Slave address (SA0 = 0)
   I2C_ADDRESS_HI : constant := 16#1D#; -- Slave address (SA0 = 1)

   ----------------------------------------------------------------------------
   -- 6.1 Data registers
   ----------------------------------------------------------------------------

   -- F_MODE = 00: 0x00 STATUS: Data status register (read only)

   type STATUS_Type is record
      XDR   : Boolean; -- X-axis new data available.
      YDR   : Boolean; -- Y-axis new data available.
      ZDR   : Boolean; -- Z-axis new data available.
      ZYXDR : Boolean; -- X, Y, Z-axis new data ready.
      XOW   : Boolean; -- X-axis data overwrite.
      YOW   : Boolean; -- Y-axis data overwrite.
      ZOW   : Boolean; -- Z-axis data overwrite.
      ZYXOW : Boolean; -- X, Y, Z-axis data overwrite.
   end record
      with Bit_Order => Low_Order_First,
           Size      => 8;
   for STATUS_Type use record
      XDR   at 0 range 0 .. 0;
      YDR   at 0 range 1 .. 1;
      ZDR   at 0 range 2 .. 2;
      ZYXDR at 0 range 3 .. 3;
      XOW   at 0 range 4 .. 4;
      YOW   at 0 range 5 .. 5;
      ZOW   at 0 range 6 .. 6;
      ZYXOW at 0 range 7 .. 7;
   end record;

   -- 0x01: OUT_X_MSB: X_MSB register (read only)

   type OUT_X_MSB_Type is record
      XD : Bits_8; -- output sample data expressed as 2's complement numbers
   end record
      with Bit_Order => Low_Order_First,
           Size      => 8;
   for OUT_X_MSB_Type use record
      XD at 0 range 0 .. 7;
   end record;

   -- 0x02: OUT_X_LSB: X_LSB register (read only)

   type OUT_X_LSB_Type is record
      Unused : Bits_2;
      XD     : Bits_6; -- output sample data expressed as 2's complement numbers
   end record
      with Bit_Order => Low_Order_First,
           Size      => 8;
   for OUT_X_LSB_Type use record
      Unused at 0 range 0 .. 1;
      XD     at 0 range 2 .. 7;
   end record;

   -- 0x03: OUT_Y_MSB: Y_MSB register (read only)

   type OUT_Y_MSB_Type is record
      XD : Bits_8; -- output sample data expressed as 2's complement numbers
   end record
      with Bit_Order => Low_Order_First,
           Size      => 8;
   for OUT_Y_MSB_Type use record
      XD at 0 range 0 .. 7;
   end record;

   -- 0x04: OUT_Y_LSB: Y_LSB register (read only)

   type OUT_Y_LSB_Type is record
      Unused : Bits_2;
      XD     : Bits_6; -- output sample data expressed as 2's complement numbers
   end record
      with Bit_Order => Low_Order_First,
           Size      => 8;
   for OUT_Y_LSB_Type use record
      Unused at 0 range 0 .. 1;
      XD     at 0 range 2 .. 7;
   end record;

   -- 0x05: OUT_Z_MSB: Z_MSB register (read only)

   type OUT_Z_MSB_Type is record
      XD : Bits_8; -- output sample data expressed as 2's complement numbers
   end record
      with Bit_Order => Low_Order_First,
           Size      => 8;
   for OUT_Z_MSB_Type use record
      XD at 0 range 0 .. 7;
   end record;

   -- 0x06: OUT_Z_LSB: Z_LSB register (read only)

   type OUT_Z_LSB_Type is record
      Unused : Bits_2;
      XD     : Bits_6; -- output sample data expressed as 2's complement numbers
   end record
      with Bit_Order => Low_Order_First,
           Size      => 8;
   for OUT_Z_LSB_Type use record
      Unused at 0 range 0 .. 1;
      XD     at 0 range 2 .. 7;
   end record;

   ----------------------------------------------------------------------------
   -- 6.2 32-sample FIFO
   ----------------------------------------------------------------------------

   -- 0x00: F_STATUS: FIFO status register (read only)

   type F_STATUS_Type is record
      F_CNT       : Bits_6;  -- FIFO sample counter.
      F_WMRK_FLAG : Boolean; -- FIFO watermark event detected.
      F_OVF       : Boolean; -- FIFO event detected; FIFO has overflowed.
   end record
      with Bit_Order => Low_Order_First,
           Size      => 8;
   for F_STATUS_Type use record
      F_CNT       at 0 range 0 .. 5;
      F_WMRK_FLAG at 0 range 6 .. 6;
      F_OVF       at 0 range 7 .. 7;
   end record;

   -- 0x09 F_SETUP: FIFO setup register (read/write)

   F_MODE_DISABLE : constant := 2#00#; -- FIFO is disabled.
   F_MODE_RECENT  : constant := 2#01#; -- FIFO contains the most recent samples when overflowed (circular buffer).
   F_MODE_OVFSTOP : constant := 2#10#; -- FIFO stops accepting new samples when overflowed.
   F_MODE_TRIGGER : constant := 2#11#; -- Trigger mode.

   type F_SETUP_Type is record
      F_WMRK : Bits_6 := 0;              -- FIFO event sample count watermark.
      F_MODE : Bits_2 := F_MODE_DISABLE; -- FIFO buffer overflow mode.
   end record
      with Bit_Order => Low_Order_First,
           Size      => 8;
   for F_SETUP_Type use record
      F_WMRK at 0 range 0 .. 5;
      F_MODE at 0 range 6 .. 7;
   end record;

   -- 0x0A: TRIG_CFG trigger configuration register (read/write)

   type TRIG_CFG_Type is record
      Unused1     : Bits_2  := 0;
      Trig_FF_MT  : Boolean := False; -- Freefall/motion trigger bit.
      Trig_PULSE  : Boolean := False; -- Pulse interrupt trigger bit.
      Trig_LNDPRT : Boolean := False; -- Landscape/portrait orientation interrupt trigger bit.
      Trig_TRANS  : Boolean := False; -- Transient interrupt trigger bit.
      Unused2     : Bits_2  := 0;
   end record
      with Bit_Order => Low_Order_First,
           Size      => 8;
   for TRIG_CFG_Type use record
      Unused1     at 0 range 0 .. 1;
      Trig_FF_MT  at 0 range 2 .. 2;
      Trig_PULSE  at 0 range 3 .. 3;
      Trig_LNDPRT at 0 range 4 .. 4;
      Trig_TRANS  at 0 range 5 .. 5;
      Unused2     at 0 range 6 .. 7;
   end record;

   -- 0x0B: SYSMOD: System mode register (read only)

   SYSMOD_STANDBY : constant := 2#00#; -- Standby mode
   SYSMOD_WAKE    : constant := 2#01#; -- Wake mode
   SYSMOD_SLEEP   : constant := 2#10#; -- Sleep mode

   type SYSMOD_Type is record
      SYSMOD : Bits_2;  -- System mode.
      FGT    : Bits_5;  -- Number of ODR time units since FGERR was asserted.
      FGERR  : Boolean; -- FIFO gate error.
   end record
      with Bit_Order => Low_Order_First,
           Size      => 8;
   for SYSMOD_Type use record
      SYSMOD at 0 range 0 .. 1;
      FGT    at 0 range 2 .. 6;
      FGERR  at 0 range 7 .. 7;
   end record;

   -- 0x0C: INT_SOURCE: system interrupt status register (read only)

   type INT_SOURCE_Type is record
      SRC_DRDY   : Boolean; -- Data-ready interrupt bit status.
      Unused     : Bits_1;
      SRC_FF_MT  : Boolean; -- Freefall/motion interrupt status bit.
      SRC_PULSE  : Boolean; -- Pulse interrupt status bit.
      SRC_LNDPRT : Boolean; -- Landscape/portrait orientation interrupt status bit.
      SRC_TRANS  : Boolean; -- Transient interrupt status bit.
      SRC_FIFO   : Boolean; -- FIFO interrupt status bit.
      SRC_ASLP   : Boolean; -- Auto-sleep/wake interrupt status bit.
   end record
      with Bit_Order => Low_Order_First,
           Size      => 8;
   for INT_SOURCE_Type use record
      SRC_DRDY   at 0 range 0 .. 0;
      Unused     at 0 range 1 .. 1;
      SRC_FF_MT  at 0 range 2 .. 2;
      SRC_PULSE  at 0 range 3 .. 3;
      SRC_LNDPRT at 0 range 4 .. 4;
      SRC_TRANS  at 0 range 5 .. 5;
      SRC_FIFO   at 0 range 6 .. 6;
      SRC_ASLP   at 0 range 7 .. 7;
   end record;

   -- 0x0D: WHO_AM_I Device ID register (read only)

   type WHO_AM_I_Type is record
      ID : Bits_8 := WHO_AM_I_ID; -- The device identification register identifies the part.
   end record
      with Bit_Order => Low_Order_First,
           Size      => 8;
   for WHO_AM_I_Type use record
      ID at 0 range 0 .. 7;
   end record;

   -- 0x0E: XYZ_DATA_CFG (read/write)

   FS_2    : constant := 2#00#; -- Full-scale range = 2
   FS_4    : constant := 2#01#; -- Full-scale range = 4
   FS_8    : constant := 2#10#; -- Full-scale range = 8
   FS_RSVD : constant := 2#11#; -- Full-scale range = Reserved

   type XYZ_DATA_CFG_Type is record
      FS      : Bits_2  := FS_2;  -- Output buffer data format full scale.
      Unused1 : Bits_2  := 0;
      HPF_OUT : Boolean := False; -- Enable high-pass output data 1 = output data high-pass filtered.
      Unused2 : Bits_3  := 0;
   end record
      with Bit_Order => Low_Order_First,
           Size      => 8;
   for XYZ_DATA_CFG_Type use record
      FS      at 0 range 0 .. 1;
      Unused1 at 0 range 2 .. 3;
      HPF_OUT at 0 range 4 .. 4;
      Unused2 at 0 range 5 .. 7;
   end record;

   -- 0x0F: HP_FILTER_CUTOFF: high-pass filter register (read/write)

   SEL_0 : constant := 2#00#; -- Table 23. High-pass filter cutoff options
   SEL_1 : constant := 2#01#; -- Table 23. High-pass filter cutoff options
   SEL_2 : constant := 2#10#; -- Table 23. High-pass filter cutoff options
   SEL_3 : constant := 2#11#; -- Table 23. High-pass filter cutoff options

   type HP_FILTER_CUTOFF_Type is record
      SEL           : Bits_2  := SEL_0; -- HPF cutoff frequency selection.
      Unused1       : Bits_2  := 0;
      Pulse_LPF_EN  : Boolean := False; -- Enable low-pass filter (LPF) for pulse processing function.
      Pulse_HPF_BYP : Boolean := False; -- Bypass high-pass filter (HPF) for pulse processing function.
      Unused2       : Bits_2  := 0;
   end record
      with Bit_Order => Low_Order_First,
           Size      => 8;
   for HP_FILTER_CUTOFF_Type use record
      SEL           at 0 range 0 .. 1;
      Unused1       at 0 range 2 .. 3;
      Pulse_LPF_EN  at 0 range 4 .. 4;
      Pulse_HPF_BYP at 0 range 5 .. 5;
      Unused2       at 0 range 6 .. 7;
   end record;

   ----------------------------------------------------------------------------
   -- 6.3 Portrait/landscape embedded function registers
   ----------------------------------------------------------------------------

   -- 0x10: PL_STATUS register (read only)

   BAFRO_FRONT : constant := 0; -- Front: Equipment is in the front facing orientation.
   BAFRO_BACK  : constant := 1; -- Back: Equipment is in the back facing orientation.

   LAPO_PU : constant := 2#00#; -- Portrait up: Equipment standing vertically in the normal orientation
   LAPO_PD : constant := 2#01#; -- Portrait down: Equipment standing vertically in the inverted orientation
   LAPO_LR : constant := 2#10#; -- Landscape right: Equipment is in landscape mode to the right
   LAPO_LL : constant := 2#11#; -- Landscape left: Equipment is in landscape mode to the left.

   type PL_STATUS_Type is record
      BAFRO  : Bits_1;  -- Back or front orientation.
      LAPO   : Bits_2;  -- Landscape/portrait orientation.
      Unused : Bits_3;
      LO     : Boolean; -- Z-tilt angle lockout.
      NEWLP  : Boolean; -- Landscape/portrait status change flag.
   end record
      with Bit_Order => Low_Order_First,
           Size      => 8;
   for PL_STATUS_Type use record
      BAFRO  at 0 range 0 .. 0;
      LAPO   at 0 range 1 .. 2;
      Unused at 0 range 3 .. 5;
      LO     at 0 range 6 .. 6;
      NEWLP  at 0 range 7 .. 7;
   end record;

   -- 0x11: PL_CFG register (read/write)

   DBCNTM_DECRDB : constant := 0; -- Decrements debounce whenever condition of interest is no longer valid.
   DBCNTM_CLRCNT : constant := 1; -- Clears counter whenever condition of interest is no longer valid.

   type PL_CFG_Type is record
      Unused : Bits_6  := 0;
      PL_EN  : Boolean := False;         -- Portrait/landscape detection enable.
      DBCNTM : Bits_1  := DBCNTM_CLRCNT; -- Debounce counter mode selection.
   end record
      with Bit_Order => Low_Order_First,
           Size      => 8;
   for PL_CFG_Type use record
      Unused at 0 range 0 .. 5;
      PL_EN  at 0 range 6 .. 6;
      DBCNTM at 0 range 7 .. 7;
   end record;

   -- 0x12: PL_COUNT register (read/write)

   type PL_COUNT_Type is record
      DBCNE : Unsigned_8; -- Debounce count value.
   end record
      with Bit_Order => Low_Order_First,
           Size      => 8;
   for PL_COUNT_Type use record
      DBCNE at 0 range 0 .. 7;
   end record;

   -- 0x13: PL_BF_ZCOMP register (read/write)

   ZLOCK_14 : constant := 16#00#; -- 14°
   ZLOCK_18 : constant := 16#01#; -- 18°
   ZLOCK_21 : constant := 16#02#; -- 21°
   ZLOCK_25 : constant := 16#03#; -- 25°
   ZLOCK_29 : constant := 16#04#; -- 29°
   ZLOCK_33 : constant := 16#05#; -- 33°
   ZLOCK_37 : constant := 16#06#; -- 37°
   ZLOCK_42 : constant := 16#07#; -- 42°

   -- Back/front transition
   BKFR_BF80Z280 : constant := 2#00#; -- Z < 80° or Z > 280°
   BKFR_BF75Z285 : constant := 2#01#; -- Z < 75° or Z > 285°
   BKFR_BF70Z290 : constant := 2#10#; -- Z < 70° or Z > 290°
   BKFR_BF65Z295 : constant := 2#11#; -- Z < 65° or Z > 295°
   -- Front/back transition
   BKFR_FB100Z260 : constant := 2#00#; -- Z > 100° and Z < 260°
   BKFR_FB105Z255 : constant := 2#01#; -- Z > 105° and Z < 255°
   BKFR_FB110Z250 : constant := 2#10#; -- Z > 110° and Z < 250°
   BKFR_FB115Z245 : constant := 2#11#; -- Z > 115° and Z < 245°

   type PL_BF_ZCOMP_Type is record
      ZLOCK  : Bits_3 := ZLOCK_29;      -- Z-lock angle threshold.
      Unused : Bits_3 := 0;
      BKFR   : Bits_2 := BKFR_BF75Z285; -- Back/front trip angle threshold.
   end record
      with Bit_Order => Low_Order_First,
           Size      => 8;
   for PL_BF_ZCOMP_Type use record
      ZLOCK  at 0 range 0 .. 2;
      Unused at 0 range 3 .. 5;
      BKFR   at 0 range 6 .. 7;
   end record;

   -- 0x14: PL_THS_REG register (read/write)

   HYS_0  : constant := 0; -- ±0 45° 45°
   HYS_4  : constant := 1; -- ±4 49° 41°
   HYS_7  : constant := 2; -- ±7 52° 38°
   HYS_11 : constant := 3; -- ±11 56° 34°
   HYS_14 : constant := 4; -- ±14 59° 31°
   HYS_17 : constant := 5; -- ±17 62° 28°
   HYS_21 : constant := 6; -- ±21 66° 24°
   HYS_24 : constant := 7; -- ±24 69° 21°

   PL_THS_15 : constant := 16#07#; -- 15°
   PL_THS_20 : constant := 16#09#; -- 20°
   PL_THS_30 : constant := 16#0C#; -- 30°
   PL_THS_35 : constant := 16#0D#; -- 35°
   PL_THS_40 : constant := 16#0F#; -- 40°
   PL_THS_45 : constant := 16#10#; -- 45°
   PL_THS_55 : constant := 16#13#; -- 55°
   PL_THS_60 : constant := 16#14#; -- 60°
   PL_THS_70 : constant := 16#17#; -- 70°
   PL_THS_75 : constant := 16#19#; -- 75°

   type PL_THS_REG_Type is record
      HYS    : Bits_3 := HYS_14;    -- This angle is added to the threshold angle for a smoother transition from portrait to landscape and landscape to portrait.
      PL_THS : Bits_5 := PL_THS_45; -- Portrait/landscape trip threshold angle from 15° to 75°.
   end record
      with Bit_Order => Low_Order_First,
           Size      => 8;
   for PL_THS_REG_Type use record
      HYS    at 0 range 0 .. 2;
      PL_THS at 0 range 3 .. 7;
   end record;

   ----------------------------------------------------------------------------
   -- 6.4 Motion and freefall embedded function registers
   ----------------------------------------------------------------------------

   -- 0x15: FF_MT_CFG register (read/write)

   type FF_MT_CFG_Type is record
      Unused : Bits_3  := 0;
      XEFE   : Boolean := False; -- Event flag enable on X event.
      YEFE   : Boolean := False; -- Event flag enable on Y event.
      ZEFE   : Boolean := False; -- Event flag enable on Z.
      OAE    : Boolean := False; -- Motion detect/freefall detect flag selection.
      ELE    : Boolean := False; -- Event latch enable: Event flags are latched into FF_MT_SRC register.
   end record
      with Bit_Order => Low_Order_First,
           Size      => 8;
   for FF_MT_CFG_Type use record
      Unused at 0 range 0 .. 2;
      XEFE   at 0 range 3 .. 3;
      YEFE   at 0 range 4 .. 4;
      ZEFE   at 0 range 5 .. 5;
      OAE    at 0 range 6 .. 6;
      ELE    at 0 range 7 .. 7;
   end record;

   -- 0x16: FF_MT_SRC freefall and motion source register (read only)

   XHP_POSITIVE : constant := 0; -- X event was positive g
   XHP_NEGATIVE : constant := 1; -- X event was negative g

   YHP_POSITIVE : constant := 0; -- Y event was positive g
   YHP_NEGATIVE : constant := 1; -- Y event was negative g

   ZHP_POSITIVE : constant := 0; -- Z event was positive g
   ZHP_NEGATIVE : constant := 1; -- Z event was negative g

   type FF_MT_SRC_Type is record
      XHP    : Bits_1;  -- X-motion polarity flag.
      XHE    : Boolean; -- X-motion flag.
      YHP    : Bits_1;  -- Y-motion polarity flag.
      YHE    : Boolean; -- Y-motion flag.
      ZHP    : Bits_1;  -- Z-motion polarity flag.
      ZHE    : Boolean; -- Z-motion flag.
      Unused : Bits_1;
      EA     : Boolean; -- Event active flag.
   end record
      with Bit_Order => Low_Order_First,
           Size      => 8;
   for FF_MT_SRC_Type use record
      XHP    at 0 range 0 .. 0;
      XHE    at 0 range 1 .. 1;
      YHP    at 0 range 2 .. 2;
      YHE    at 0 range 3 .. 3;
      ZHP    at 0 range 4 .. 4;
      ZHE    at 0 range 5 .. 5;
      Unused at 0 range 6 .. 6;
      EA     at 0 range 7 .. 7;
   end record;

   -- 0x17: FF_MT_THS register (read/write)

   DBCNTM_DEBOUNCE : constant := 0; -- increments or decrements debounce
   DBCNTM_COUNTER  : constant := 1; -- increments or clears counter

   type FF_MT_THS_Type is record
      THS    : Bits_7 := 0;               -- Freefall/motion threshold
      DBCNTM : Bits_1 := DBCNTM_DEBOUNCE; -- Debounce counter mode selection.
   end record
      with Bit_Order => Low_Order_First,
           Size      => 8;
   for FF_MT_THS_Type use record
      THS    at 0 range 0 .. 6;
      DBCNTM at 0 range 7 .. 7;
   end record;

   -- 0x18: FF_MT_COUNT register (read/write)

   type FF_MT_COUNT_Type is record
      D : Unsigned_8; -- Count value
   end record
      with Bit_Order => Low_Order_First,
           Size      => 8;
   for FF_MT_COUNT_Type use record
      D at 0 range 0 .. 7;
   end record;

   ----------------------------------------------------------------------------
   -- 6.5 Transient (HPF) acceleration detection
   ----------------------------------------------------------------------------

   -- 0x1D: TRANSIENT_CFG register (read/write)

   type TRANSIENT_CFG_Type is record
      HPF_BYP : Boolean := False; -- Bypass high-pass filter.
      XTEFE   : Boolean := False; -- Event flag enable on X transient acceleration greater than transient threshold event.
      YTEFE   : Boolean := False; -- Event flag enable on Y transient acceleration greater than transient threshold event.
      ZTEFE   : Boolean := False; -- Event flag enable on Z transient acceleration greater than transient threshold event.
      ELE     : Boolean := False; -- Transient event flags are latched into the TRANSIENT_SRC register.
      Unused  : Bits_3  := 0;
   end record
      with Bit_Order => Low_Order_First,
           Size      => 8;
   for TRANSIENT_CFG_Type use record
      HPF_BYP at 0 range 0 .. 0;
      XTEFE   at 0 range 1 .. 1;
      YTEFE   at 0 range 2 .. 2;
      ZTEFE   at 0 range 3 .. 3;
      ELE     at 0 range 4 .. 4;
      Unused  at 0 range 5 .. 7;
   end record;

   -- 0x1E: TRANSIENT_SRC register (read only)

   X_Trans_Pol_POSITIVE : constant := 0; -- 0: X event was positive g
   X_Trans_Pol_NEGATIVE : constant := 1; -- 1: X event was negative g

   Y_Trans_Pol_POSITIVE : constant := 0; -- 0: Y event was positive g
   Y_Trans_Pol_NEGATIVE : constant := 1; -- 1: Y event was negative g

   Z_Trans_Pol_POSITIVE : constant := 0; -- 0: Z event was positive g
   Z_Trans_Pol_NEGATIVE : constant := 1; -- 1: Z event was negative g

   type TRANSIENT_SRC_Type is record
      X_Trans_Pol : Bits_1;  -- Polarity of X-transient event that triggered interrupt.
      XTRANSE     : Boolean; -- X-transient event.
      Y_Trans_Pol : Bits_1;  -- Polarity of X-transient event that triggered interrupt.
      YTRANSE     : Boolean; -- Y-transient event.
      Z_Trans_Pol : Bits_1;  -- Polarity of X-transient event that triggered interrupt.
      ZTRANSE     : Boolean; -- X-transient event.
      EA          : Boolean; -- Event active flag.
      Unused      : Bits_1;
   end record
      with Bit_Order => Low_Order_First,
           Size      => 8;
   for TRANSIENT_SRC_Type use record
      X_Trans_Pol at 0 range 0 .. 0;
      XTRANSE     at 0 range 1 .. 1;
      Y_Trans_Pol at 0 range 2 .. 2;
      YTRANSE     at 0 range 3 .. 3;
      Z_Trans_Pol at 0 range 4 .. 4;
      ZTRANSE     at 0 range 5 .. 5;
      EA          at 0 range 6 .. 6;
      Unused      at 0 range 7 .. 7;
   end record;

   -- 0x1F: TRANSIENT_THS register (read/write)

   -- DBCNTM_* already defined at 6.4

   type TRANSIENT_THS_Type is record
      THS    : Bits_7 := 0;               -- Transient threshold
      DBCNTM : Bits_1 := DBCNTM_DEBOUNCE; -- Debounce counter mode selection.
   end record
      with Bit_Order => Low_Order_First,
           Size      => 8;
   for TRANSIENT_THS_Type use record
      THS    at 0 range 0 .. 6;
      DBCNTM at 0 range 7 .. 7;
   end record;

   -- 0x20: TRANSIENT_COUNT register (read/write)

   type TRANSIENT_COUNT_Type is record
      D : Unsigned_8; -- Count value
   end record
      with Bit_Order => Low_Order_First,
           Size      => 8;
   for TRANSIENT_COUNT_Type use record
      D at 0 range 0 .. 7;
   end record;

   ----------------------------------------------------------------------------
   -- 6.6 Single, double and directional tap detection registers
   ----------------------------------------------------------------------------

   -- 0x21: PULSE_CFG register (read/write)

   type PULSE_CFG_Type is record
      XSPEFE : Boolean := False; -- Event flag enable on single pulse event on X-axis.
      XDPEFE : Boolean := False; -- Event flag enable on double pulse event on X-axis.
      YSPEFE : Boolean := False; -- Event flag enable on single pulse event on Y-axis.
      YDPEFE : Boolean := False; -- Event flag enable on double pulse event on Y-axis.
      ZSPEFE : Boolean := False; -- Event flag enable on single pulse event on Z-axis.
      ZDPEFE : Boolean := False; -- Event flag enable on double pulse event on Z-axis.
      ELE    : Boolean := False; -- Pulse event flags are latched into the PULSE_SRC register.
      DPA    : Boolean := False; -- Double-pulse abort.
   end record
      with Bit_Order => Low_Order_First,
           Size      => 8;
   for PULSE_CFG_Type use record
      XSPEFE at 0 range 0 .. 0;
      XDPEFE at 0 range 1 .. 1;
      YSPEFE at 0 range 2 .. 2;
      YDPEFE at 0 range 3 .. 3;
      ZSPEFE at 0 range 4 .. 4;
      ZDPEFE at 0 range 5 .. 5;
      ELE    at 0 range 6 .. 6;
      DPA    at 0 range 7 .. 7;
   end record;

   -- 0x22: PULSE_SRC register (read only)

   PolX_POSITIVE : constant := 0; -- Pulse Event that triggered interrupt was positive
   PolX_NEGATIVE : constant := 1; -- Pulse Event that triggered interrupt was negative

   PolY_POSITIVE : constant := 0; -- Pulse Event that triggered interrupt was positive
   PolY_NEGATIVE : constant := 1; -- Pulse Event that triggered interrupt was negative

   PolZ_POSITIVE : constant := 0; -- Pulse Event that triggered interrupt was positive
   PolZ_NEGATIVE : constant := 1; -- Pulse Event that triggered interrupt was negative

   type PULSE_SRC_Type is record
      PolX : Bits_1;  -- Pulse polarity of X-axis Event.
      PolY : Bits_1;  -- Pulse polarity of Y-axis Event.
      PolZ : Bits_1;  -- Pulse polarity of Z-axis Event.
      DPE  : Boolean; -- Double pulse on first event.
      AxX  : Boolean; -- X-axis event.
      AxY  : Boolean; -- Y-axis event.
      AxZ  : Boolean; -- Z-axis event.
      EA   : Boolean; -- Event active flag.
   end record
      with Bit_Order => Low_Order_First,
           Size      => 8;
   for PULSE_SRC_Type use record
      PolX at 0 range 0 .. 0;
      PolY at 0 range 1 .. 1;
      PolZ at 0 range 2 .. 2;
      DPE  at 0 range 3 .. 3;
      AxX  at 0 range 4 .. 4;
      AxY  at 0 range 5 .. 5;
      AxZ  at 0 range 6 .. 6;
      EA   at 0 range 7 .. 7;
   end record;

   -- 0x23: PULSE_THSX register (read/write)

   type PULSE_THSX_Type is record
      THSX   : Bits_7;     -- Pulse threshold on X-axis.
      Unused : Bits_1 := 0;
   end record
      with Bit_Order => Low_Order_First,
           Size      => 8;
   for PULSE_THSX_Type use record
      THSX   at 0 range 0 .. 6;
      Unused at 0 range 7 .. 7;
   end record;

   -- 0x24: PULSE_THSY register (read/write)

   type PULSE_THSY_Type is record
      THSY   : Bits_7;     -- Pulse threshold on Y-axis.
      Unused : Bits_1 := 0;
   end record
      with Bit_Order => Low_Order_First,
           Size      => 8;
   for PULSE_THSY_Type use record
      THSY   at 0 range 0 .. 6;
      Unused at 0 range 7 .. 7;
   end record;

   -- 0x25: PULSE_THSZ register (read/write)

   type PULSE_THSZ_Type is record
      THSZ   : Bits_7;     -- Pulse threshold on Z-axis.
      Unused : Bits_1 := 0;
   end record
      with Bit_Order => Low_Order_First,
           Size      => 8;
   for PULSE_THSZ_Type use record
      THSZ   at 0 range 0 .. 6;
      Unused at 0 range 7 .. 7;
   end record;

   -- 0x26: PULSE_TMLT register (read/write)

   type PULSE_TMLT_Type is record
      TMLT : Unsigned_8; -- Pulse time limit.
   end record
      with Bit_Order => Low_Order_First,
           Size      => 8;
   for PULSE_TMLT_Type use record
      TMLT at 0 range 0 .. 7;
   end record;

   -- 0x27: PULSE_LTCY register (read/write)

   type PULSE_LTCY_Type is record
      LTCY : Unsigned_8; -- Latency time limit.
   end record
      with Bit_Order => Low_Order_First,
           Size      => 8;
   for PULSE_LTCY_Type use record
      LTCY at 0 range 0 .. 7;
   end record;

   -- 0x28: PULSE_WIND register (read/write)

   type PULSE_WIND_Type is record
      WIND : Unsigned_8; -- Second pulse time window.
   end record
      with Bit_Order => Low_Order_First,
           Size      => 8;
   for PULSE_WIND_Type use record
      WIND at 0 range 0 .. 7;
   end record;

   ----------------------------------------------------------------------------
   -- 6.7 Auto-wake/sleep detection
   ----------------------------------------------------------------------------

   -- 0x29: ASLP_COUNT register (read/write)

   type ASLP_COUNT_Type is record
      D : Unsigned_8; -- Duration value.
   end record
      with Bit_Order => Low_Order_First,
           Size      => 8;
   for ASLP_COUNT_Type use record
      D at 0 range 0 .. 7;
   end record;

   ----------------------------------------------------------------------------
   -- 6.8 Control registers
   ----------------------------------------------------------------------------

   -- 0x2A: CTRL_REG1 register (read/write)

   DR_800Hz : constant := 2#000#; -- 800 Hz 1.25 ms
   DR_400Hz : constant := 2#001#; -- 400 Hz 2.5 ms
   DR_200Hz : constant := 2#010#; -- 200 Hz 5 ms
   DR_100Hz : constant := 2#011#; -- 100 Hz 10 ms
   DR_50Hz  : constant := 2#100#; -- 50 Hz 20 ms
   DR_12Hz5 : constant := 2#101#; -- 12.5 Hz 80 ms
   DR_6Hz25 : constant := 2#110#; -- 6.25 Hz 160 ms
   DR_1Hz56 : constant := 2#111#; -- 1.56 Hz 640 ms

   ASLP_RATE_50Hz  : constant := 2#00#; -- 50
   ASLP_RATE_12Hz5 : constant := 2#01#; -- 12.5
   ASLP_RATE_6Hz25 : constant := 2#10#; -- 6.25
   ASLP_RATE_1Hz56 : constant := 2#11#; -- 1.56

   type CTRL_REG1_Type is record
      ACTIVE    : Boolean := False;          -- Full-scale selection.
      F_READ    : Boolean := False;          -- Fast read mode
      LNOISE    : Boolean := False;          -- Reduced noise reduced maximum range mode.
      DR        : Bits_3  := DR_800Hz;       -- Data-rate selection.
      ASLP_RATE : Bits_2  := ASLP_RATE_50Hz; -- Configures the auto-wake sample frequency when the device is in sleep mode.
   end record
      with Bit_Order => Low_Order_First,
           Size      => 8;
   for CTRL_REG1_Type use record
      ACTIVE    at 0 range 0 .. 0;
      F_READ    at 0 range 1 .. 1;
      LNOISE    at 0 range 2 .. 2;
      DR        at 0 range 3 .. 5;
      ASLP_RATE at 0 range 6 .. 7;
   end record;

   -- 0x2B: CTRL_REG2 register (read/write)

   MODS_Normal  : constant := 2#00#; -- Normal
   MODS_LPLN    : constant := 2#01#; -- Low Noise Low Power
   MODS_HighRes : constant := 2#10#; -- High Resolution
   MODS_LP      : constant := 2#11#; -- Low Power

   SMODS_Normal  renames MODS_Normal;
   SMODS_LPLN    renames MODS_LPLN;
   SMODS_HighRes renames MODS_HighRes;
   SMODS_LP      renames MODS_LP;

   type CTRL_REG2_Type is record
      MODS   : Bits_2  := MODS_Normal;  -- Active mode power scheme selection.
      SLPE   : Boolean := False;        -- Auto-sleep enable.
      SMODS  : Bits_2  := SMODS_Normal; -- Sleep mode power scheme selection.
      Unused : Bits_1  := 0;
      RST    : Boolean := False;        -- Software reset.
      ST     : Boolean := False;        -- Self-test enable.
   end record
      with Bit_Order => Low_Order_First,
           Size      => 8;
   for CTRL_REG2_Type use record
      MODS   at 0 range 0 .. 1;
      SLPE   at 0 range 2 .. 2;
      SMODS  at 0 range 3 .. 4;
      Unused at 0 range 5 .. 5;
      RST    at 0 range 6 .. 6;
      ST     at 0 range 7 .. 7;
   end record;

   -- 0x2C: CTRL_REG3 register (read/write)

   PP_OD_PUSHPULL  : constant := 0; -- Push-pull
   PP_OD_OPENDRAIN : constant := 1; -- Open drain

   IPOL_ACTIVELOW  : constant := 0; -- Active low
   IPOL_ACTIVEHIGH : constant := 1; -- Active high

   type CTRL_REG3_Type is record
      PP_OD       : Bits_1  := PP_OD_PUSHPULL; -- Push-pull/open drain selection on interrupt pad.
      IPOL        : Bits_1  := IPOL_ACTIVELOW; -- Interrupt polarity active high, or active low.
      Unused      : Bits_1  := 0;
      WAKE_FF_MT  : Boolean := False;          -- Freefall/motion function interrupt can wake up
      WAKE_PULSE  : Boolean := False;          -- Pulse function interrupt can wake up system
      WAKE_LNDPRT : Boolean := False;          -- Orientation function interrupt can wake up system
      WAKE_TRANS  : Boolean := False;          -- Transient function interrupt can wake up system
      FIFO_GATE   : Boolean := False;          -- The FIFO input buffer is blocked when transitioning from wake to sleep mode or from sleep to wake mode until the FIFO is flushed.
   end record
      with Bit_Order => Low_Order_First,
           Size      => 8;
   for CTRL_REG3_Type use record
      PP_OD       at 0 range 0 .. 0;
      IPOL        at 0 range 1 .. 1;
      Unused      at 0 range 2 .. 2;
      WAKE_FF_MT  at 0 range 3 .. 3;
      WAKE_PULSE  at 0 range 4 .. 4;
      WAKE_LNDPRT at 0 range 5 .. 5;
      WAKE_TRANS  at 0 range 6 .. 6;
      FIFO_GATE   at 0 range 7 .. 7;
   end record;

   -- 0x2D: CTRL_REG4 register (read/write)

   type CTRL_REG4_Type is record
      INT_EN_DRDY   : Boolean := False; -- Data-ready interrupt enabled
      Unused        : Bits_1  := 0;
      INT_EN_FF_MT  : Boolean := False; -- Freefall/motion interrupt enabled
      INT_EN_PULSE  : Boolean := False; -- Pulse detection interrupt enabled
      INT_EN_LNDPRT : Boolean := False; -- Orientation (landscape/portrait) interrupt enabled.
      INT_EN_TRANS  : Boolean := False; -- Transient interrupt enabled.
      INT_EN_FIFO   : Boolean := False; -- FIFO interrupt enabled.
      INT_EN_ASLP   : Boolean := False; -- Auto-sleep/wake interrupt enabled.
   end record
      with Bit_Order => Low_Order_First,
           Size      => 8;
   for CTRL_REG4_Type use record
      INT_EN_DRDY   at 0 range 0 .. 0;
      Unused        at 0 range 1 .. 1;
      INT_EN_FF_MT  at 0 range 2 .. 2;
      INT_EN_PULSE  at 0 range 3 .. 3;
      INT_EN_LNDPRT at 0 range 4 .. 4;
      INT_EN_TRANS  at 0 range 5 .. 5;
      INT_EN_FIFO   at 0 range 6 .. 6;
      INT_EN_ASLP   at 0 range 7 .. 7;
   end record;

   -- 0x2E: CTRL_REG5 register (read/write)

   INT_CFG_DRDY_INT2 : constant := 0; -- Interrupt is routed to INT2 pin
   INT_CFG_DRDY_INT1 : constant := 1; -- Interrupt is routed to INT1 pin

   INT_CFG_FF_MT_INT2 renames INT_CFG_DRDY_INT2;
   INT_CFG_FF_MT_INT1 renames INT_CFG_DRDY_INT1;

   INT_CFG_PULSE_INT2 renames INT_CFG_DRDY_INT2;
   INT_CFG_PULSE_INT1 renames INT_CFG_DRDY_INT1;

   INT_CFG_LNDPRT_INT2 renames INT_CFG_DRDY_INT2;
   INT_CFG_LNDPRT_INT1 renames INT_CFG_DRDY_INT1;

   INT_CFG_TRANS_INT2 renames INT_CFG_DRDY_INT2;
   INT_CFG_TRANS_INT1 renames INT_CFG_DRDY_INT1;

   INT_CFG_FIFO_INT2 renames INT_CFG_DRDY_INT2;
   INT_CFG_FIFO_INT1 renames INT_CFG_DRDY_INT1;

   INT_CFG_ASLP_INT2 renames INT_CFG_DRDY_INT2;
   INT_CFG_ASLP_INT1 renames INT_CFG_DRDY_INT1;

   type CTRL_REG5_Type is record
      INT_CFG_DRDY   : Bits_1 := INT_CFG_DRDY_INT2;   -- INT1/INT2 configuration.
      Unused         : Bits_1 := 0;
      INT_CFG_FF_MT  : Bits_1 := INT_CFG_FF_MT_INT2;  -- INT1/INT2 configuration.
      INT_CFG_PULSE  : Bits_1 := INT_CFG_PULSE_INT2;  -- INT1/INT2 configuration.
      INT_CFG_LNDPRT : Bits_1 := INT_CFG_LNDPRT_INT2; -- INT1/INT2 configuration.
      INT_CFG_TRANS  : Bits_1 := INT_CFG_TRANS_INT2;  -- INT1/INT2 configuration.
      INT_CFG_FIFO   : Bits_1 := INT_CFG_FIFO_INT2;   -- INT1/INT2 configuration.
      INT_CFG_ASLP   : Bits_1 := INT_CFG_ASLP_INT2;   -- INT1/INT2 configuration.
   end record
      with Bit_Order => Low_Order_First,
           Size      => 8;
   for CTRL_REG5_Type use record
      INT_CFG_DRDY   at 0 range 0 .. 0;
      Unused         at 0 range 1 .. 1;
      INT_CFG_FF_MT  at 0 range 2 .. 2;
      INT_CFG_PULSE  at 0 range 3 .. 3;
      INT_CFG_LNDPRT at 0 range 4 .. 4;
      INT_CFG_TRANS  at 0 range 5 .. 5;
      INT_CFG_FIFO   at 0 range 6 .. 6;
      INT_CFG_ASLP   at 0 range 7 .. 7;
   end record;

   ----------------------------------------------------------------------------
   -- 6.9 User offset correction registers
   ----------------------------------------------------------------------------

   -- 0x2F: OFF_X register (read/write)

   type OFF_X_Type is record
      D : Unsigned_8; -- X-axis offset value
   end record
      with Bit_Order => Low_Order_First,
           Size      => 8;
   for OFF_X_Type use record
      D at 0 range 0 .. 7;
   end record;

   -- 0x30: OFF_Y register (read/write)

   type OFF_Y_Type is record
      D : Unsigned_8; -- Y-axis offset value
   end record
      with Bit_Order => Low_Order_First,
           Size      => 8;
   for OFF_Y_Type use record
      D at 0 range 0 .. 7;
   end record;

   -- 0x31: OFF_Z register (read/write)

   type OFF_Z_Type is record
      D : Unsigned_8; -- Z-axis offset value
   end record
      with Bit_Order => Low_Order_First,
           Size      => 8;
   for OFF_Z_Type use record
      D at 0 range 0 .. 7;
   end record;

pragma Style_Checks (On);

end MMA8451Q;

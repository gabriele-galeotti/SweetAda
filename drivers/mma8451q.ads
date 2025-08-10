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
   use Bits;

pragma Style_Checks (Off);

   ----------------------------------------------------------------------------
   -- MMA8451Q, 3-axis, 14-bit/8-bit digital accelerometer
   -- Document Number: MMA8451Q
   -- Rev. 10.3, 02/2017
   ----------------------------------------------------------------------------

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
      ID : Bits_8; -- The device identification register identifies the part.
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

   type PL_STATUS_Type is record DATA : Bits_8; end record with Bit_Order => Low_Order_First, Size => 8;
   for PL_STATUS_Type use record DATA at 0 range 0 .. 7; end record;

   -- 0x11: PL_CFG register (read/write)

   type PL_CFG_Type is record DATA : Bits_8; end record with Bit_Order => Low_Order_First, Size => 8;
   for PL_CFG_Type use record DATA at 0 range 0 .. 7; end record;

   -- 0x12: PL_COUNT register (read/write)

   type PL_COUNT_Type is record DATA : Bits_8; end record with Bit_Order => Low_Order_First, Size => 8;
   for PL_COUNT_Type use record DATA at 0 range 0 .. 7; end record;

   -- 0x13: PL_BF_ZCOMP register (read/write)

   type PL_BF_ZCOMP_Type is record DATA : Bits_8; end record with Bit_Order => Low_Order_First, Size => 8;
   for PL_BF_ZCOMP_Type use record DATA at 0 range 0 .. 7; end record;

   -- 0x14: PL_THS_REG register (read/write)

   type PL_THS_REG_Type is record DATA : Bits_8; end record with Bit_Order => Low_Order_First, Size => 8;
   for PL_THS_REG_Type use record DATA at 0 range 0 .. 7; end record;

   ----------------------------------------------------------------------------
   -- 6.4 Motion and freefall embedded function registers
   ----------------------------------------------------------------------------

   -- 0x15: FF_MT_CFG register (read/write)

   type FF_MT_CFG_Type is record DATA : Bits_8; end record with Bit_Order => Low_Order_First, Size => 8;
   for FF_MT_CFG_Type use record DATA at 0 range 0 .. 7; end record;

   -- 0x16: FF_MT_SRC freefall and motion source register (read only)

   type FF_MT_SRC_Type is record DATA : Bits_8; end record with Bit_Order => Low_Order_First, Size => 8;
   for FF_MT_SRC_Type use record DATA at 0 range 0 .. 7; end record;

   -- 0x17: FF_MT_THS register (read/write)

   type FF_MT_THS_Type is record DATA : Bits_8; end record with Bit_Order => Low_Order_First, Size => 8;
   for FF_MT_THS_Type use record DATA at 0 range 0 .. 7; end record;

   -- 0x18: FF_MT_COUNT register (read/write)

   type FF_MT_COUNT_Type is record DATA : Bits_8; end record with Bit_Order => Low_Order_First, Size => 8;
   for FF_MT_COUNT_Type use record DATA at 0 range 0 .. 7; end record;

   ----------------------------------------------------------------------------
   -- 6.5 Transient (HPF) acceleration detection
   ----------------------------------------------------------------------------

   -- 0x1D: TRANSIENT_CFG register (read/write)

   type TRANSIENT_CFG_Type is record DATA : Bits_8; end record with Bit_Order => Low_Order_First, Size => 8;
   for TRANSIENT_CFG_Type use record DATA at 0 range 0 .. 7; end record;

   -- 0x1E: TRANSIENT_SRC register (read only)

   type TRANSIENT_SRC_Type is record DATA : Bits_8; end record with Bit_Order => Low_Order_First, Size => 8;
   for TRANSIENT_SRC_Type use record DATA at 0 range 0 .. 7; end record;

   -- 0x1F: TRANSIENT_THS register (read/write)

   type TRANSIENT_THS_Type is record DATA : Bits_8; end record with Bit_Order => Low_Order_First, Size => 8;
   for TRANSIENT_THS_Type use record DATA at 0 range 0 .. 7; end record;

   -- 0x20: TRANSIENT_COUNT register (read/write)

   type TRANSIENT_COUNT_Type is record DATA : Bits_8; end record with Bit_Order => Low_Order_First, Size => 8;
   for TRANSIENT_COUNT_Type use record DATA at 0 range 0 .. 7; end record;

   ----------------------------------------------------------------------------
   -- 6.6 Single, double and directional tap detection registers
   ----------------------------------------------------------------------------

   -- 0x21: PULSE_CFG register (read/write)

   type PULSE_CFG_Type is record DATA : Bits_8; end record with Bit_Order => Low_Order_First, Size => 8;
   for PULSE_CFG_Type use record DATA at 0 range 0 .. 7; end record;

   -- 0x22: PULSE_SRC register (read only)

   type PULSE_SRC_Type is record DATA : Bits_8; end record with Bit_Order => Low_Order_First, Size => 8;
   for PULSE_SRC_Type use record DATA at 0 range 0 .. 7; end record;

   -- 0x23: PULSE_THSX register (read/write)

   type PULSE_THSX_Type is record DATA : Bits_8; end record with Bit_Order => Low_Order_First, Size => 8;
   for PULSE_THSX_Type use record DATA at 0 range 0 .. 7; end record;

   -- 0x24: PULSE_THSY register (read/write)

   type PULSE_THSY_Type is record DATA : Bits_8; end record with Bit_Order => Low_Order_First, Size => 8;
   for PULSE_THSY_Type use record DATA at 0 range 0 .. 7; end record;

   -- 0x25: PULSE_THSZ register (read/write)

   type PULSE_THSZ_Type is record DATA : Bits_8; end record with Bit_Order => Low_Order_First, Size => 8;
   for PULSE_THSZ_Type use record DATA at 0 range 0 .. 7; end record;

   -- 0x26: PULSE_TMLT register (read/write)

   type PULSE_TMLT_Type is record DATA : Bits_8; end record with Bit_Order => Low_Order_First, Size => 8;
   for PULSE_TMLT_Type use record DATA at 0 range 0 .. 7; end record;

   -- 0x27: PULSE_LTCY register (read/write)

   type PULSE_LTCY_Type is record DATA : Bits_8; end record with Bit_Order => Low_Order_First, Size => 8;
   for PULSE_LTCY_Type use record DATA at 0 range 0 .. 7; end record;

   -- 0x28: PULSE_WIND register (read/write)

   type PULSE_WIND_Type is record DATA : Bits_8; end record with Bit_Order => Low_Order_First, Size => 8;
   for PULSE_WIND_Type use record DATA at 0 range 0 .. 7; end record;

   ----------------------------------------------------------------------------
   -- 6.7 Auto-wake/sleep detection
   ----------------------------------------------------------------------------

   -- 0x29: ASLP_COUNT register (read/write)

   type ASLP_COUNT_Type is record DATA : Bits_8; end record with Bit_Order => Low_Order_First, Size => 8;
   for ASLP_COUNT_Type use record DATA at 0 range 0 .. 7; end record;

   ----------------------------------------------------------------------------
   -- 6.8 Control registers
   ----------------------------------------------------------------------------

   -- 0x2A: CTRL_REG1 register (read/write)

   type CTRL_REG1_Type is record DATA : Bits_8; end record with Bit_Order => Low_Order_First, Size => 8;
   for CTRL_REG1_Type use record DATA at 0 range 0 .. 7; end record;

   -- 0x2B: CTRL_REG2 register (read/write)

   type CTRL_REG2_Type is record DATA : Bits_8; end record with Bit_Order => Low_Order_First, Size => 8;
   for CTRL_REG2_Type use record DATA at 0 range 0 .. 7; end record;

   -- 0x2C: CTRL_REG3 register (read/write)

   type CTRL_REG3_Type is record DATA : Bits_8; end record with Bit_Order => Low_Order_First, Size => 8;
   for CTRL_REG3_Type use record DATA at 0 range 0 .. 7; end record;

   -- 0x2D: CTRL_REG4 register (read/write)

   type CTRL_REG4_Type is record DATA : Bits_8; end record with Bit_Order => Low_Order_First, Size => 8;
   for CTRL_REG4_Type use record DATA at 0 range 0 .. 7; end record;

   -- 0x2E: CTRL_REG5 register (read/write)

   type CTRL_REG5_Type is record DATA : Bits_8; end record with Bit_Order => Low_Order_First, Size => 8;
   for CTRL_REG5_Type use record DATA at 0 range 0 .. 7; end record;

   ----------------------------------------------------------------------------
   -- 6.9 User offset correction registers
   ----------------------------------------------------------------------------

   -- 0x2F: OFF_X register (read/write)

   type OFF_X_Type is record DATA : Bits_8; end record with Bit_Order => Low_Order_First, Size => 8;
   for OFF_X_Type use record DATA at 0 range 0 .. 7; end record;

   -- 0x30: OFF_Y register (read/write)

   type OFF_Y_Type is record DATA : Bits_8; end record with Bit_Order => Low_Order_First, Size => 8;
   for OFF_Y_Type use record DATA at 0 range 0 .. 7; end record;

   -- 0x31: OFF_Z register (read/write)

   type OFF_Z_Type is record DATA : Bits_8; end record with Bit_Order => Low_Order_First, Size => 8;
   for OFF_Z_Type use record DATA at 0 range 0 .. 7; end record;

pragma Style_Checks (On);

end MMA8451Q;

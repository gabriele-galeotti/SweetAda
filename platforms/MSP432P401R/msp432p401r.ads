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

   ----------------------------------------------------------------------------
   -- 3 Reset Controller (RSTCTL)
   ----------------------------------------------------------------------------

   -- 3.3.1 RSTCTL_RESET_REQ

   RSTCTL_RESET_REQ_RSTKEY : constant := 16#69#;

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

   -- common definitions for RSTCTL_[HARD|SOFT]RESET_[STAT|CLR|SET]

   -- indexes into bitmaps
   SRC0  : constant := 0;
   SRC1  : constant := 1;
   SRC2  : constant := 2;
   SRC3  : constant := 3;
   SRC4  : constant := 4;
   SRC5  : constant := 5;
   SRC6  : constant := 6;
   SRC7  : constant := 7;
   SRC8  : constant := 8;
   SRC9  : constant := 9;
   SRC10 : constant := 10;
   SRC11 : constant := 11;
   SRC12 : constant := 12;
   SRC13 : constant := 13;
   SRC14 : constant := 14;
   SRC15 : constant := 15;

   type RSTCTL_RESET_Type is record
      SRC      : Bitmap_16 := [others => False];
      Reserved : Bits_16 := 0;
   end record
      with Bit_Order => Low_Order_First,
           Size      => 32;
   for RSTCTL_RESET_Type use record
      SRC      at 0 range  0 .. 15;
      Reserved at 0 range 16 .. 31;
   end record;

   -- 3.3.2 RSTCTL_HARDRESET_STAT
   -- 3.3.3 RSTCTL_HARDRESET_CLR
   -- 3.3.4 RSTCTL_HARDRESET_SET
   -- 3.3.5 RSTCTL_SOFTRESET_STAT
   -- 3.3.6 RSTCTL_SOFTRESET_CLR
   -- 3.3.7 RSTCTL_SOFTRESET_SET
   -- Table 6-32. Debug Zone Memory Map
   -- Table 6-33. RSTCTL Registers

   RSTCTL_BASEADDRESS : constant := 16#E004_2000#;

   RSTCTL_HARDRESET_STAT : aliased RSTCTL_RESET_Type
      with Address              => To_Address (RSTCTL_BASEADDRESS + 16#04#),
           Volatile_Full_Access => True,
           Import               => True,
           Convention           => Ada;

   RSTCTL_HARDRESET_CLR : aliased RSTCTL_RESET_Type
      with Address              => To_Address (RSTCTL_BASEADDRESS + 16#08#),
           Volatile_Full_Access => True,
           Import               => True,
           Convention           => Ada;

   RSTCTL_HARDRESET_SET : aliased RSTCTL_RESET_Type
      with Address              => To_Address (RSTCTL_BASEADDRESS + 16#0C#),
           Volatile_Full_Access => True,
           Import               => True,
           Convention           => Ada;

   RSTCTL_SOFTRESET_STAT : aliased RSTCTL_RESET_Type
      with Address              => To_Address (RSTCTL_BASEADDRESS + 16#10#),
           Volatile_Full_Access => True,
           Import               => True,
           Convention           => Ada;

   RSTCTL_SOFTRESET_CLR : aliased RSTCTL_RESET_Type
      with Address              => To_Address (RSTCTL_BASEADDRESS + 16#14#),
           Volatile_Full_Access => True,
           Import               => True,
           Convention           => Ada;

   RSTCTL_SOFTRESET_SET : aliased RSTCTL_RESET_Type
      with Address              => To_Address (RSTCTL_BASEADDRESS + 16#18#),
           Volatile_Full_Access => True,
           Import               => True,
           Convention           => Ada;

   ----------------------------------------------------------------------------
   -- 4 System Controller (SYSCTL)
   ----------------------------------------------------------------------------

   -- 4.11.1 SYS_REBOOT_CTL Register Reboot Control Register

   SYS_REBOOT_CTL_WKEY : constant := 16#69#;

   type SYS_REBOOT_CTL_Type is record
      REBOOT    : Boolean;      -- Write 1 initiates a Reboot of the device
      Reserved1 : Bits_7 := 0;
      WKEY      : Bits_8;       -- Key to enable writes to bit 0.
      Reserved2 : Bits_16 := 0;
   end record
      with Bit_Order => Low_Order_First,
           Size      => 32;
   for SYS_REBOOT_CTL_Type use record
      REBOOT    at 0 range  0 ..  0;
      Reserved1 at 0 range  1 ..  7;
      WKEY      at 0 range  8 .. 15;
      Reserved2 at 0 range 16 .. 31;
   end record;

   -- Table 6-34. SYSCTL Registers

   SYSCTL_BASEADDRESS : constant := 16#E004_3000#;

   SYS_REBOOT_CTL : aliased SYS_REBOOT_CTL_Type
      with Address              => To_Address (SYSCTL_BASEADDRESS + 16#0000#),
           Volatile_Full_Access => True,
           Import               => True,
           Convention           => Ada;

   ----------------------------------------------------------------------------
   -- 6 Clock System (CS)
   ----------------------------------------------------------------------------

   -- 6.3.1 CSKEY Register Clock System Key Register

   CSKEY_CSKEY : constant := 16#695A#;

   type CSKEY_Type is record
      CSKEY    : Unsigned_16;  -- Write CSKEY = xxxx_695Ah to unlock CS registers. All 16 LSBs need to be written together.
      Reserved : Bits_16 := 0;
   end record
      with Bit_Order => Low_Order_First,
           Size      => 32;
   for CSKEY_Type use record
      CSKEY    at 0 range  0 .. 15;
      Reserved at 0 range 16 .. 31;
   end record;

   -- 6.3.2 CSCTL0 Register Clock System Control 0 Register

   DCORSEL_1M5      : constant := 2#000#; -- Nominal DCO Frequency (MHz): 1.5; Nominal DCO Frequency Range (MHz): 1 to 2
   DCORSEL_3M       : constant := 2#001#; -- Nominal DCO Frequency (MHz): 3; Nominal DCO Frequency Range (MHz): 2 to 4
   DCORSEL_6M       : constant := 2#010#; -- Nominal DCO Frequency (MHz): 6; Nominal DCO Frequency Range (MHz): 4 to 8
   DCORSEL_12M      : constant := 2#011#; -- Nominal DCO Frequency (MHz): 12; Nominal DCO Frequency Range (MHz): 8 to 16
   DCORSEL_24M      : constant := 2#100#; -- Nominal DCO Frequency (MHz): 24; Nominal DCO Frequency Range (MHz): 16 to 32
   DCORSEL_48M      : constant := 2#101#; -- Nominal DCO Frequency (MHz): 48; Nominal DCO Frequency Range (MHz): 32 to 64
   DCORSEL_RSVD1M5  : constant := 2#110#; -- Nominal DCO Frequency (MHz): Reserved--defaults to 1.5 when selected;
   DCORSEL_RSVD1OR2 : constant := 2#111#; -- Nominal DCO Frequency Range (MHz): Reserved--defaults to 1 to 2 when selected.

   type CSCTL0_Type is record
      DCOTUNE   : Bits_10;     -- DCO frequency tuning select.
      Reserved1 : Bits_3 := 0;
      Reserved2 : Bits_3 := 0;
      DCORSEL   : Bits_3;      -- DCO frequency range select.
      Reserved3 : Bits_3 := 0;
      DCORES    : Boolean;     -- Enables the DCO external resistor mode.
      DCOEN     : Boolean;     -- Enables the DCO oscillator regardless if used as a clock resource.
      Reserved4 : Bits_1 := 0;
      Reserved5 : Bits_7 := 0;
   end record
      with Bit_Order => Low_Order_First,
           Size      => 32;
   for CSCTL0_Type use record
      DCOTUNE   at 0 range  0 ..  9;
      Reserved1 at 0 range 10 .. 12;
      Reserved2 at 0 range 13 .. 15;
      DCORSEL   at 0 range 16 .. 18;
      Reserved3 at 0 range 19 .. 21;
      DCORES    at 0 range 22 .. 22;
      DCOEN     at 0 range 23 .. 23;
      Reserved4 at 0 range 24 .. 24;
      Reserved5 at 0 range 25 .. 31;
   end record;

   -- 6.3.3 CSCTL1 Register Clock System Control 1 Register

   SELM_LFXTCLK     : constant := 2#000#; -- LFXTCLK
   SELM_VLOCLK      : constant := 2#001#; -- VLOCLK
   SELM_REFOCLK     : constant := 2#010#; -- REFOCLK
   SELM_DCOCLK      : constant := 2#011#; -- DCOCLK
   SELM_MODOSC      : constant := 2#100#; -- MODOSC
   SELM_HFXTCLK     : constant := 2#101#; -- HFXTCLK
   SELM_RSVDDCOCLK1 : constant := 2#110#; -- Reserved for future use. Defaults to DCOCLK.
   SELM_RSVDDCOCLK2 : constant := 2#111#; -- Reserved for future use. Defaults to DCOCLK.

   SELS_LFXTCLK     : constant := 2#000#; -- LFXTCLK
   SELS_VLOCLK      : constant := 2#001#; -- VLOCLK
   SELS_REFOCLK     : constant := 2#010#; -- REFOCLK
   SELS_DCOCLK      : constant := 2#011#; -- DCOCLK
   SELS_MODOSC      : constant := 2#100#; -- MODOSC
   SELS_HFXTCLK     : constant := 2#101#; -- HFXTCLK
   SELS_RSVDDCOCLK1 : constant := 2#110#; -- Reserved for future use. Defaults to DCOCLK.
   SELS_RSVDDCOCLK2 : constant := 2#111#; -- Reserved for future use. Defaults to DCOCLK.

   SELA_LFXTCLK      : constant := 2#000#; -- LFXTCLK
   SELA_VLOCLK       : constant := 2#001#; -- VLOCLK
   SELA_REFOCLK      : constant := 2#010#; -- REFOCLK
   SELA_RSVDREFOCLK1 : constant := 2#011#; -- Reserved for future use. Defaults to REFOCLK.
   SELA_RSVDREFOCLK2 : constant := 2#100#; -- Reserved for future use. Defaults to REFOCLK.
   SELA_RSVDREFOCLK3 : constant := 2#101#; -- Reserved for future use. Defaults to REFOCLK.
   SELA_RSVDREFOCLK4 : constant := 2#110#; -- Reserved for future use. Defaults to REFOCLK.
   SELA_RSVDREFOCLK5 : constant := 2#111#; -- Reserved for future use. Defaults to REFOCLK.

   SELB_LFXTCLK : constant := 0; -- LFXTCLK
   SELB_REFOCLK : constant := 1; -- REFOCLK

   DIVM_DIV1   : constant := 2#000#; -- f(MCLK)/1
   DIVM_DIV2   : constant := 2#001#; -- f(MCLK)/2
   DIVM_DIV4   : constant := 2#010#; -- f(MCLK)/4
   DIVM_DIV8   : constant := 2#011#; -- f(MCLK)/8
   DIVM_DIV16  : constant := 2#100#; -- f(MCLK)/16
   DIVM_DIV32  : constant := 2#101#; -- f(MCLK)/32
   DIVM_DIV64  : constant := 2#110#; -- f(MCLK)/64
   DIVM_DIV128 : constant := 2#111#; -- f(MCLK)/128

   DIVHS_DIV1   : constant := 2#000#; -- f(HSMCLK)/1
   DIVHS_DIV2   : constant := 2#001#; -- f(HSMCLK)/2
   DIVHS_DIV4   : constant := 2#010#; -- f(HSMCLK)/4
   DIVHS_DIV8   : constant := 2#011#; -- f(HSMCLK)/8
   DIVHS_DIV16  : constant := 2#100#; -- f(HSMCLK)/16
   DIVHS_DIV32  : constant := 2#101#; -- f(HSMCLK)/32
   DIVHS_DIV64  : constant := 2#110#; -- f(HSMCLK)/64
   DIVHS_DIV128 : constant := 2#111#; -- f(HSMCLK)/128

   DIVA_DIV1   : constant := 2#000#; -- f(ACLK)/1
   DIVA_DIV2   : constant := 2#001#; -- f(ACLK)/2
   DIVA_DIV4   : constant := 2#010#; -- f(ACLK)/4
   DIVA_DIV8   : constant := 2#011#; -- f(ACLK)/8
   DIVA_DIV16  : constant := 2#100#; -- f(ACLK)/16
   DIVA_DIV32  : constant := 2#101#; -- f(ACLK)/32
   DIVA_DIV64  : constant := 2#110#; -- f(ACLK)/64
   DIVA_DIV128 : constant := 2#111#; -- f(ACLK)/128

   DIVS_DIV1   : constant := 2#000#; -- f(SCLK)/1
   DIVS_DIV2   : constant := 2#001#; -- f(SCLK)/2
   DIVS_DIV4   : constant := 2#010#; -- f(SCLK)/4
   DIVS_DIV8   : constant := 2#011#; -- f(SCLK)/8
   DIVS_DIV16  : constant := 2#100#; -- f(SCLK)/16
   DIVS_DIV32  : constant := 2#101#; -- f(SCLK)/32
   DIVS_DIV64  : constant := 2#110#; -- f(SCLK)/64
   DIVS_DIV128 : constant := 2#111#; -- f(SCLK)/128

   type CSCTL1_Type is record
      SELM      : Bits_3;      -- Selects the MCLK source.
      Reserved1 : Bits_1 := 0;
      SELS      : Bits_3;      -- Selects the SMCLK and HSMCLK source.
      Reserved2 : Bits_1 := 0;
      SELA      : Bits_3;      -- Selects the ACLK source.
      Reserved3 : Bits_1 := 0;
      SELB      : Bits_1;      -- Selects the BCLK source.
      Reserved4 : Bits_3 := 0;
      DIVM      : Bits_3;      -- MCLK source divider.
      Reserved5 : Bits_1 := 0;
      DIVHS     : Bits_3;      -- HSMCLK source divider.
      Reserved6 : Bits_1 := 0;
      DIVA      : Bits_3;      -- ACLK source divider.
      Reserved7 : Bits_1 := 0;
      DIVS      : Bits_3;      -- SMCLK source divider.
      Reserved8 : Bits_1 := 0;
   end record
      with Bit_Order => Low_Order_First,
           Size      => 32;
   for CSCTL1_Type use record
      SELM      at 0 range  0 ..  2;
      Reserved1 at 0 range  3 ..  3;
      SELS      at 0 range  4 ..  6;
      Reserved2 at 0 range  7 ..  7;
      SELA      at 0 range  8 .. 10;
      Reserved3 at 0 range 11 .. 11;
      SELB      at 0 range 12 .. 12;
      Reserved4 at 0 range 13 .. 15;
      DIVM      at 0 range 16 .. 18;
      Reserved5 at 0 range 19 .. 19;
      DIVHS     at 0 range 20 .. 22;
      Reserved6 at 0 range 23 .. 23;
      DIVA      at 0 range 24 .. 26;
      Reserved7 at 0 range 27 .. 27;
      DIVS      at 0 range 28 .. 30;
      Reserved8 at 0 range 31 .. 31;
   end record;

   -- 6.3.4 CSCTL2 Register Clock System Control 2 Register

   LFXTDRIVE_0 : constant := 0; -- Lowest drive strength and current consumption LFXT oscillator.
   LFXTDRIVE_1 : constant := 1; -- Increased drive strength LFXT oscillator.
   LFXTDRIVE_2 : constant := 2; -- Increased drive strength LFXT oscillator.
   LFXTDRIVE_3 : constant := 3; -- Maximum drive strength and maximum current consumption LFXT oscillator.

   LFXTBYPASS_EXTAL : constant := 0; -- LFXT sourced by external crystal.
   LFXTBYPASS_SQRWV : constant := 1; -- LFXT sourced by external square wave.

   HFXTDRIVE_1_4   : constant := 0; -- To be used for HFXTFREQ setting 000b
   HFXTDRIVE_OTHER : constant := 1; -- To be used for HFXTFREQ settings 001b to 110b

   HFXTFREQ_1_4      : constant := 2#000#; -- 1 MHz to 4 MHz
   HFXTFREQ_4_8      : constant := 2#001#; -- >4 MHz to 8 MHz
   HFXTFREQ_8_16     : constant := 2#010#; -- >8 MHz to 16 MHz
   HFXTFREQ_16_24    : constant := 2#011#; -- >16 MHz to 24 MHz
   HFXTFREQ_24_32    : constant := 2#100#; -- >24 MHz to 32 MHz
   HFXTFREQ_32_40    : constant := 2#101#; -- >32 MHz to 40 MHz
   HFXTFREQ_40_48    : constant := 2#110#; -- >40 MHz to 48 MHz
   HFXTFREQ_RESERVED : constant := 2#111#; -- Reserved for future use.

   HFXTBYPASS_EXTAL : constant := 0; -- HFXT sourced by external crystal.
   HFXTBYPASS_SQRWV : constant := 1; -- HFXT sourced by external square wave.

   type CSCTL2_Type is record
      LFXTDRIVE  : Bits_2;      -- The LFXT oscillator current can be adjusted to its drive needs.
      Reserved1  : Bits_1 := 0;
      Reserved2  : Bits_4 := 0;
      Reserved3  : Bits_1 := 0;
      LFXT_EN    : Boolean;     -- Turns on the LFXT oscillator regardless if used as a clock resource.
      LFXTBYPASS : Bits_1;      -- LFXT bypass select.
      Reserved4  : Bits_6 := 0;
      HFXTDRIVE  : Bits_1;      -- HFXT oscillator drive selection.
      Reserved5  : Bits_2 := 0;
      Reserved6  : Bits_1 := 0;
      HFXTFREQ   : Bits_3;      -- HFXT frequency selection.
      Reserved7  : Bits_1 := 0;
      HFXT_EN    : Boolean;     -- Turns on the HFXT oscillator regardless if used as a clock resource.
      HFXTBYPASS : Bits_1;      -- HFXT bypass select.
      Reserved8  : Bits_6 := 0;
   end record
      with Bit_Order => Low_Order_First,
           Size      => 32;
   for CSCTL2_Type use record
      LFXTDRIVE  at 0 range  0 ..  1;
      Reserved1  at 0 range  2 ..  2;
      Reserved2  at 0 range  3 ..  6;
      Reserved3  at 0 range  7 ..  7;
      LFXT_EN    at 0 range  8 ..  8;
      LFXTBYPASS at 0 range  9 ..  9;
      Reserved4  at 0 range 10 .. 15;
      HFXTDRIVE  at 0 range 16 .. 16;
      Reserved5  at 0 range 17 .. 18;
      Reserved6  at 0 range 19 .. 19;
      HFXTFREQ   at 0 range 20 .. 22;
      Reserved7  at 0 range 23 .. 23;
      HFXT_EN    at 0 range 24 .. 24;
      HFXTBYPASS at 0 range 25 .. 25;
      Reserved8  at 0 range 26 .. 31;
   end record;

   -- 6.3.5 CSCTL3 Register Clock System Control 3 Register

   FCNTLF_4k  : constant := 2#00#; -- 4096 cycles
   FCNTLF_8k  : constant := 2#01#; -- 8192 cycles
   FCNTLF_16k : constant := 2#10#; -- 16384 cycles
   FCNTLF_32k : constant := 2#11#; -- 32768 cycles

   FCNTHF_4k  : constant := 2#00#; -- 4096 cycles
   FCNTHF_8k  : constant := 2#01#; -- 8192 cycles
   FCNTHF_16k : constant := 2#10#; -- 16384 cycles
   FCNTHF_32k : constant := 2#11#; -- 32768 cycles

   type CSCTL3_Type is record
      FCNTLF    : Bits_2;       -- Start flag counter for LFXT.
      RFCNTLF   : Boolean;      -- Reset start fault counter for LFXT.
      FCNTLF_EN : Boolean;      -- Enable start fault counter for LFXT.
      FCNTHF    : Bits_2;       -- Start flag counter for HFXT.
      RFCNTHF   : Boolean;      -- Reset start fault counter for HFXT.
      FCNTHF_EN : Boolean;      -- Enable start fault counter for HFXT.
      Reserved  : Bits_24 := 0;
   end record
      with Bit_Order => Low_Order_First,
           Size      => 32;
   for CSCTL3_Type use record
      FCNTLF    at 0 range 0 ..  1;
      RFCNTLF   at 0 range 2 ..  2;
      FCNTLF_EN at 0 range 3 ..  3;
      FCNTHF    at 0 range 4 ..  5;
      RFCNTHF   at 0 range 6 ..  6;
      FCNTHF_EN at 0 range 7 ..  7;
      Reserved  at 0 range 8 .. 31;
   end record;

   -- 6.3.6 CSCLKEN Register Clock System Clock Enable Register

   REFOFSEL_32k  : constant := 0; -- 32.768 kHz
   REFOFSEL_128k : constant := 1; -- 128 kHz

   type CSCLKEN_Type is record
      ACLK_EN   : Boolean;      -- ACLK system clock conditional request enable
      MCLK_EN   : Boolean;      -- MCLK system clock conditional request enable
      HSMCLK_EN : Boolean;      -- HSMCLK system clock conditional request enable
      SMCLK_EN  : Boolean;      -- SMCLK system clock conditional request enable
      Reserved1 : Bits_4 := 0;
      VLO_EN    : Boolean;      -- Turns on the VLO oscillator regardless if used as a clock resource.
      REFO_EN   : Boolean;      -- Turns on the REFO oscillator regardless if used as a clock resource.
      MODOSC_EN : Boolean;      -- Turns on the MODOSC oscillator regardless if used as a clock resource.
      Reserved2 : Bits_4 := 0;
      REFOFSEL  : Bits_1;       -- Selects REFO nominal frequency.
      Reserved3 : Bits_16 := 0;
   end record
      with Bit_Order => Low_Order_First,
           Size      => 32;
   for CSCLKEN_Type use record
      ACLK_EN   at 0 range  0 ..  0;
      MCLK_EN   at 0 range  1 ..  1;
      HSMCLK_EN at 0 range  2 ..  2;
      SMCLK_EN  at 0 range  3 ..  3;
      Reserved1 at 0 range  4 ..  7;
      VLO_EN    at 0 range  8 ..  8;
      REFO_EN   at 0 range  9 ..  9;
      MODOSC_EN at 0 range 10 .. 10;
      Reserved2 at 0 range 11 .. 14;
      REFOFSEL  at 0 range 15 .. 15;
      Reserved3 at 0 range 16 .. 31;
   end record;

   -- 6.3.7 CSSTAT Register Clock System Status Register

   type CSSTAT_Type is record
      DCO_ON       : Boolean; -- DCO status
      DCOBIAS_ON   : Boolean; -- DCO bias status
      HFXT_ON      : Boolean; -- HFXT status.
      Reserved1    : Bits_1;
      MODOSC_ON    : Boolean; -- MODOSC status
      VLO_ON       : Boolean; -- VLO status
      LFXT_ON      : Boolean; -- LFXT status.
      REFO_ON      : Boolean; -- REFO status
      Reserved2    : Bits_8;
      ACLK_ON      : Boolean; -- ACLK system clock status
      MCLK_ON      : Boolean; -- MCLK system clock status
      HSMCLK_ON    : Boolean; -- HSMCLK system clock status
      SMCLK_ON     : Boolean; -- SMCLK system clock status
      MODCLK_ON    : Boolean; -- MODCLK system clock status
      VLOCLK_ON    : Boolean; -- VLOCLK system clock status
      LFXTCLK_ON   : Boolean; -- LFXTCLK system clock status
      REFOCLK_ON   : Boolean; -- REFOCLK system clock status
      ACLK_READY   : Boolean; -- ACLK Ready status.
      MCLK_READY   : Boolean; -- MCLK Ready status.
      HSMCLK_READY : Boolean; -- HSMCLK Ready status.
      SMCLK_READY  : Boolean; -- SMCLK Ready status.
      BCLK_READY   : Boolean; -- BCLK Ready status.
      Reserved3    : Bits_3;
   end record
      with Bit_Order => Low_Order_First,
           Size      => 32;
   for CSSTAT_Type use record
      DCO_ON       at 0 range  0 ..  0;
      DCOBIAS_ON   at 0 range  1 ..  1;
      HFXT_ON      at 0 range  2 ..  2;
      Reserved1    at 0 range  3 ..  3;
      MODOSC_ON    at 0 range  4 ..  4;
      VLO_ON       at 0 range  5 ..  5;
      LFXT_ON      at 0 range  6 ..  6;
      REFO_ON      at 0 range  7 ..  7;
      Reserved2    at 0 range  8 .. 15;
      ACLK_ON      at 0 range 16 .. 16;
      MCLK_ON      at 0 range 17 .. 17;
      HSMCLK_ON    at 0 range 18 .. 18;
      SMCLK_ON     at 0 range 19 .. 19;
      MODCLK_ON    at 0 range 20 .. 20;
      VLOCLK_ON    at 0 range 21 .. 21;
      LFXTCLK_ON   at 0 range 22 .. 22;
      REFOCLK_ON   at 0 range 23 .. 23;
      ACLK_READY   at 0 range 24 .. 24;
      MCLK_READY   at 0 range 25 .. 25;
      HSMCLK_READY at 0 range 26 .. 26;
      SMCLK_READY  at 0 range 27 .. 27;
      BCLK_READY   at 0 range 28 .. 28;
      Reserved3    at 0 range 29 .. 31;
   end record;

   -- 6.3.8 CSIE Register Clock System Interrupt Enable Register

   type CSIE_Type is record
      LFXTIE     : Boolean;      -- LFXT oscillator fault flag interrupt enable.
      HFXTIE     : Boolean;      -- HFXT oscillator fault flag interrupt enable.
      Reserved1  : Bits_1 := 0;
      Reserved2  : Bits_1 := 0;
      Reserved3  : Bits_1 := 0;
      Reserved4  : Bits_1 := 0;
      DCOR_OPNIE : Boolean;      -- DCO external resistor open circuit fault flag interrupt enable.
      Reserved5  : Bits_1 := 0;
      FCNTLFIE   : Boolean;      -- Start fault counter interrupt enable LFXT.
      FCNTHFIE   : Boolean;      -- Start fault counter interrupt enable HFXT.
      Reserved6  : Bits_22 := 0;
   end record
      with Bit_Order => Low_Order_First,
           Size      => 32;
   for CSIE_Type use record
      LFXTIE     at 0 range  0 ..  0;
      HFXTIE     at 0 range  1 ..  1;
      Reserved1  at 0 range  2 ..  2;
      Reserved2  at 0 range  3 ..  3;
      Reserved3  at 0 range  4 ..  4;
      Reserved4  at 0 range  5 ..  5;
      DCOR_OPNIE at 0 range  6 ..  6;
      Reserved5  at 0 range  7 ..  7;
      FCNTLFIE   at 0 range  8 ..  8;
      FCNTHFIE   at 0 range  9 ..  9;
      Reserved6  at 0 range 10 .. 31;
   end record;

   -- 6.3.9 CSIFG Register Clock System Interrupt Flag Register

   type CSIFG_Type is record
      LFXTIFG     : Boolean; -- LFXT oscillator fault flag.
      HFXTIFG     : Boolean; -- HFXT oscillator fault flag.
      Reserved1   : Bits_1;
      Reserved2   : Bits_1;
      Reserved3   : Bits_1;
      DCOR_SHTIFG : Boolean; -- DCO external resistor short circuit fault flag.
      DCOR_OPNIFG : Boolean; -- DCO external resistor open circuit fault flag.
      Reserved4   : Bits_1;
      FCNTLFIFG   : Boolean; -- Start fault counter interrupt flag LFXT.
      FCNTHFIFG   : Boolean; -- Start fault counter interrupt flag HFXT.
      Reserved5   : Bits_22;
   end record
      with Bit_Order => Low_Order_First,
           Size      => 32;
   for CSIFG_Type use record
      LFXTIFG     at 0 range  0 ..  0;
      HFXTIFG     at 0 range  1 ..  1;
      Reserved1   at 0 range  2 ..  2;
      Reserved2   at 0 range  3 ..  3;
      Reserved3   at 0 range  4 ..  4;
      DCOR_SHTIFG at 0 range  5 ..  5;
      DCOR_OPNIFG at 0 range  6 ..  6;
      Reserved4   at 0 range  7 ..  7;
      FCNTLFIFG   at 0 range  8 ..  8;
      FCNTHFIFG   at 0 range  9 ..  9;
      Reserved5   at 0 range 10 .. 31;
   end record;

   -- 6.3.10 CSCLRIFG Register Clock System Clear Interrupt Flag Register

   type CSCLRIFG_Type is record
      CLR_LFXTIFG     : Boolean;      -- Clear LFXT oscillator fault interrupt flag.
      CLR_HFXTIFG     : Boolean;      -- Clear HFXT oscillator fault interrupt flag.
      Reserved1       : Bits_1 := 0;
      Reserved2       : Bits_1 := 0;
      Reserved3       : Bits_1 := 0;
      Reserved4       : Bits_1 := 0;
      CLR_DCOR_OPNIFG : Boolean;      -- Clear DCO external resistor open circuit fault interrupt flag.
      Reserved5       : Bits_1 := 0;
      CLR_FCNTLFIFG   : Boolean;      -- Start fault counter clear interrupt flag LFXT.
      CLR_FCNTHFIFG   : Boolean;      -- Start fault counter clear interrupt flag HFXT.
      Reserved6       : Bits_22 := 0;
   end record
      with Bit_Order => Low_Order_First,
           Size      => 32;
   for CSCLRIFG_Type use record
      CLR_LFXTIFG     at 0 range  0 ..  0;
      CLR_HFXTIFG     at 0 range  1 ..  1;
      Reserved1       at 0 range  2 ..  2;
      Reserved2       at 0 range  3 ..  3;
      Reserved3       at 0 range  4 ..  4;
      Reserved4       at 0 range  5 ..  5;
      CLR_DCOR_OPNIFG at 0 range  6 ..  6;
      Reserved5       at 0 range  7 ..  7;
      CLR_FCNTLFIFG   at 0 range  8 ..  8;
      CLR_FCNTHFIFG   at 0 range  9 ..  9;
      Reserved6       at 0 range 10 .. 31;
   end record;

   -- 6.3.11 CSSETIFG Register Clock System Clear Interrupt Flag Register

   type CSSETIFG_Type is record
      SET_LFXTIFG     : Boolean;      -- Set LFXT oscillator fault interrupt flag.
      SET_HFXTIFG     : Boolean;      -- Set HFXT oscillator fault interrupt flag.
      Reserved1       : Bits_1 := 0;
      Reserved2       : Bits_1 := 0;
      Reserved3       : Bits_1 := 0;
      Reserved4       : Bits_1 := 0;
      SET_DCOR_OPNIFG : Boolean;      -- Set DCO external resistor open circuit fault interrupt flag.
      Reserved5       : Bits_1 := 0;
      SET_FCNTLFIFG   : Boolean;      -- Start fault counter set interrupt flag LFXT.
      SET_FCNTHFIFG   : Boolean;      -- Start fault counter set interrupt flag HFXT.
      Reserved6       : Bits_22 := 0;
   end record
      with Bit_Order => Low_Order_First,
           Size      => 32;
   for CSSETIFG_Type use record
      SET_LFXTIFG     at 0 range  0 ..  0;
      SET_HFXTIFG     at 0 range  1 ..  1;
      Reserved1       at 0 range  2 ..  2;
      Reserved2       at 0 range  3 ..  3;
      Reserved3       at 0 range  4 ..  4;
      Reserved4       at 0 range  5 ..  5;
      SET_DCOR_OPNIFG at 0 range  6 ..  6;
      Reserved5       at 0 range  7 ..  7;
      SET_FCNTLFIFG   at 0 range  8 ..  8;
      SET_FCNTHFIFG   at 0 range  9 ..  9;
      Reserved6       at 0 range 10 .. 31;
   end record;

   -- 6.3.12 CSDCOERCAL0 Register DCO External Resistor Calibration 0 Register

   type CSDCOERCAL0_Type is record
      DCO_TCCAL       : Bits_2;       -- DCO Temperature compensation calibration.
      Reserved1       : Bits_14 := 0;
      DCO_FCAL_RSEL04 : Bits_10;      -- DCO frequency calibration for DCO frequency range (DCORSEL) 0 to 4.
      Reserved2       : Bits_6 := 0;
   end record
      with Bit_Order => Low_Order_First,
           Size      => 32;
   for CSDCOERCAL0_Type use record
      DCO_TCCAL       at 0 range  0 ..  1;
      Reserved1       at 0 range  2 .. 15;
      DCO_FCAL_RSEL04 at 0 range 16 .. 25;
      Reserved2       at 0 range 26 .. 31;
   end record;

   -- 6.3.13 CSDCOERCAL1 Register DCO External Resistor Calibration 1 Register

   type CSDCOERCAL1_Type is record
      DCO_FCAL_RSEL5 : Bits_10;      -- DCO frequency calibration for DCO frequency range (DCORSEL) 5.
      Reserved       : Bits_22 := 0;
   end record
      with Bit_Order => Low_Order_First,
           Size      => 32;
   for CSDCOERCAL1_Type use record
      DCO_FCAL_RSEL5 at 0 range  0 ..  9;
      Reserved       at 0 range 10 .. 31;
   end record;

   -- Table 6-28. CS Registers (Base Address: 0x4001_0400)

   CS_BASEADDRESS : constant := 16#4001_0400#;

   CSKEY : aliased CSKEY_Type
      with Address              => To_Address (CS_BASEADDRESS + 16#00#),
           Volatile_Full_Access => True,
           Import               => True,
           Convention           => Ada;

   CSCTL0 : aliased CSCTL0_Type
      with Address              => To_Address (CS_BASEADDRESS + 16#04#),
           Volatile_Full_Access => True,
           Import               => True,
           Convention           => Ada;

   CSCTL1 : aliased CSCTL1_Type
      with Address              => To_Address (CS_BASEADDRESS + 16#08#),
           Volatile_Full_Access => True,
           Import               => True,
           Convention           => Ada;

   CSCTL2 : aliased CSCTL2_Type
      with Address              => To_Address (CS_BASEADDRESS + 16#0C#),
           Volatile_Full_Access => True,
           Import               => True,
           Convention           => Ada;

   CSCTL3 : aliased CSCTL3_Type
      with Address              => To_Address (CS_BASEADDRESS + 16#10#),
           Volatile_Full_Access => True,
           Import               => True,
           Convention           => Ada;

   CSCLKEN : aliased CSCLKEN_Type
      with Address              => To_Address (CS_BASEADDRESS + 16#30#),
           Volatile_Full_Access => True,
           Import               => True,
           Convention           => Ada;

   CSSTAT : aliased CSSTAT_Type
      with Address              => To_Address (CS_BASEADDRESS + 16#34#),
           Volatile_Full_Access => True,
           Import               => True,
           Convention           => Ada;

   CSIE : aliased CSIE_Type
      with Address              => To_Address (CS_BASEADDRESS + 16#40#),
           Volatile_Full_Access => True,
           Import               => True,
           Convention           => Ada;

   CSIFG : aliased CSIFG_Type
      with Address              => To_Address (CS_BASEADDRESS + 16#48#),
           Volatile_Full_Access => True,
           Import               => True,
           Convention           => Ada;

   CSCLRIFG : aliased CSCLRIFG_Type
      with Address              => To_Address (CS_BASEADDRESS + 16#50#),
           Volatile_Full_Access => True,
           Import               => True,
           Convention           => Ada;

   CSSETIFG : aliased CSSETIFG_Type
      with Address              => To_Address (CS_BASEADDRESS + 16#58#),
           Volatile_Full_Access => True,
           Import               => True,
           Convention           => Ada;

   CSDCOERCAL0 : aliased CSDCOERCAL0_Type
      with Address              => To_Address (CS_BASEADDRESS + 16#60#),
           Volatile_Full_Access => True,
           Import               => True,
           Convention           => Ada;

   CSDCOERCAL1 : aliased CSDCOERCAL1_Type
      with Address              => To_Address (CS_BASEADDRESS + 16#64#),
           Volatile_Full_Access => True,
           Import               => True,
           Convention           => Ada;

   ----------------------------------------------------------------------------
   -- 7 Power Supply System (PSS)
   ----------------------------------------------------------------------------

   -- 7.3.1 PSSKEY Register PSS Key Register

   PSSKEY_KEY : constant := 16#A596#;

   type PSSKEY_Type is record
      PSSKEY   : Unsigned_16;  -- PSS key.
      Reserved : Bits_16 := 0;
   end record
      with Bit_Order => Low_Order_First,
           Size      => 32;
   for PSSKEY_Type use record
      PSSKEY   at 0 range  0 .. 15;
      Reserved at 0 range 16 .. 31;
   end record;

   -- 7.3.2 PSSCTL0 Register PSS Control 0 Register

   SVSMHS_SVSH : constant := 0; -- Configure as SVSH
   SVSMHS_SVMH : constant := 1; -- Configure as SVMH

   SVSMHTH_0 : constant := 2#000#; -- Table 5-22. PSS, SVSMH
   SVSMHTH_1 : constant := 2#001#; -- ''
   SVSMHTH_2 : constant := 2#010#; -- ''
   SVSMHTH_3 : constant := 2#011#; -- ''
   SVSMHTH_4 : constant := 2#100#; -- ''
   SVSMHTH_5 : constant := 2#101#; -- ''
   SVSMHTH_6 : constant := 2#110#; -- ''
   SVSMHTH_7 : constant := 2#111#; -- ''

   type PSSCTL0_Type is record
      SVSMHOFF     : Boolean;      -- SVSM high-side off
      SVSMHLP      : Boolean;      -- SVSM high-side low power normal performance mode
      SVSMHS       : Bits_1;       -- Supply supervisor or monitor selection for the high-side
      SVSMHTH      : Bits_3;       -- SVSM high-side reset voltage level.
      SVMHOE       : Boolean;      -- SVSM high-side output enable
      SVMHOUTPOLAL : Boolean;      -- SVMHOUT pin polarity active low.
      Reserved1    : Bits_2 := 0;
      DCDC_FORCE   : Boolean;      -- Force DC/DC regulator operation.
      Reserved2    : Bits_1 := 0;
      Reserved3    : Bits_2 := 2;
      Reserved4    : Bits_18 := 0;
   end record
      with Bit_Order => Low_Order_First,
           Size      => 32;
   for PSSCTL0_Type use record
      SVSMHOFF     at 0 range  0 ..  0;
      SVSMHLP      at 0 range  1 ..  1;
      SVSMHS       at 0 range  2 ..  2;
      SVSMHTH      at 0 range  3 ..  5;
      SVMHOE       at 0 range  6 ..  6;
      SVMHOUTPOLAL at 0 range  7 ..  7;
      Reserved1    at 0 range  8 ..  9;
      DCDC_FORCE   at 0 range 10 .. 10;
      Reserved2    at 0 range 11 .. 11;
      Reserved3    at 0 range 12 .. 13;
      Reserved4    at 0 range 14 .. 31;
   end record;

   -- Table 6-29. PSS Registers

   PSS_BASEADDRESS : constant := 16#4001_0800#;

   PSSKEY : aliased PSSKEY_Type
      with Address              => To_Address (PSS_BASEADDRESS + 16#00#),
           Volatile_Full_Access => True,
           Import               => True,
           Convention           => Ada;

   PSSCTL0 : aliased PSSCTL0_Type
      with Address              => To_Address (PSS_BASEADDRESS + 16#04#),
           Volatile_Full_Access => True,
           Import               => True,
           Convention           => Ada;

   ----------------------------------------------------------------------------
   -- 12 Digital I/O
   ----------------------------------------------------------------------------

   type PORT16_Type is record
      PxIN   : Bitmap_16 with Volatile_Full_Access => True;
      PxOUT  : Bitmap_16 with Volatile_Full_Access => True;
      PxDIR  : Bitmap_16 with Volatile_Full_Access => True;
      PxREN  : Bitmap_16 with Volatile_Full_Access => True;
      PxDS   : Bitmap_16 with Volatile_Full_Access => True;
      PxSEL0 : Bitmap_16 with Volatile_Full_Access => True;
      PxSEL1 : Bitmap_16 with Volatile_Full_Access => True;
      PxSELC : Bitmap_16 with Volatile_Full_Access => True;
      PxIES  : Bitmap_16 with Volatile_Full_Access => True;
      PxIE   : Bitmap_16 with Volatile_Full_Access => True;
      PxIFG  : Bitmap_16 with Volatile_Full_Access => True;
   end record
      with Bit_Order => Low_Order_First,
           Size      => 16#1E# * 8;
   for PORT16_Type use record
      PxIN   at 16#00# range 0 .. 15;
      PxOUT  at 16#02# range 0 .. 15;
      PxDIR  at 16#04# range 0 .. 15;
      PxREN  at 16#06# range 0 .. 15;
      PxDS   at 16#08# range 0 .. 15;
      PxSEL0 at 16#0A# range 0 .. 15;
      PxSEL1 at 16#0C# range 0 .. 15;
      PxSELC at 16#16# range 0 .. 15;
      PxIES  at 16#18# range 0 .. 15;
      PxIE   at 16#1A# range 0 .. 15;
      PxIFG  at 16#1C# range 0 .. 15;
   end record;

   type PORTJ16_Type is record
      PxIN     : Bitmap_16 with Volatile_Full_Access => True;
      PxOUT    : Bitmap_16 with Volatile_Full_Access => True;
      PxDIR    : Bitmap_16 with Volatile_Full_Access => True;
      PxREN    : Bitmap_16 with Volatile_Full_Access => True;
      PxDS     : Bitmap_16 with Volatile_Full_Access => True;
      PxSEL0   : Bitmap_16 with Volatile_Full_Access => True;
      PxSEL1   : Bitmap_16 with Volatile_Full_Access => True;
      PxSELC   : Bitmap_16 with Volatile_Full_Access => True;
   end record
      with Bit_Order => Low_Order_First,
           Size      => 16#18# * 8;
   for PORTJ16_Type use record
      PxIN   at 16#00# range 0 .. 15;
      PxOUT  at 16#02# range 0 .. 15;
      PxDIR  at 16#04# range 0 .. 15;
      PxREN  at 16#06# range 0 .. 15;
      PxDS   at 16#08# range 0 .. 15;
      PxSEL0 at 16#0A# range 0 .. 15;
      PxSEL1 at 16#0C# range 0 .. 15;
      PxSELC at 16#16# range 0 .. 15;
   end record;

   type PORTL8_Type is record
      PxIN   : Bitmap_8    with Volatile_Full_Access => True;
      PxOUT  : Bitmap_8    with Volatile_Full_Access => True;
      PxDIR  : Bitmap_8    with Volatile_Full_Access => True;
      PxREN  : Bitmap_8    with Volatile_Full_Access => True;
      PxDS   : Bitmap_8    with Volatile_Full_Access => True;
      PxSEL0 : Bitmap_8    with Volatile_Full_Access => True;
      PxSEL1 : Bitmap_8    with Volatile_Full_Access => True;
      PxIV   : Unsigned_16 with Volatile_Full_Access => True;
      PxSELC : Bitmap_8    with Volatile_Full_Access => True;
      PxIES  : Bitmap_8    with Volatile_Full_Access => True;
      PxIE   : Bitmap_8    with Volatile_Full_Access => True;
      PxIFG  : Bitmap_8    with Volatile_Full_Access => True;
   end record
      with Bit_Order => Low_Order_First,
           Size      => 16#1E# * 8;
   for PORTL8_Type use record
      PxIN   at 16#00# range 0 ..  7;
      PxOUT  at 16#02# range 0 ..  7;
      PxDIR  at 16#04# range 0 ..  7;
      PxREN  at 16#06# range 0 ..  7;
      PxDS   at 16#08# range 0 ..  7;
      PxSEL0 at 16#0A# range 0 ..  7;
      PxSEL1 at 16#0C# range 0 ..  7;
      PxIV   at 16#0E# range 0 .. 15;
      PxSELC at 16#16# range 0 ..  7;
      PxIES  at 16#18# range 0 ..  7;
      PxIE   at 16#1A# range 0 ..  7;
      PxIFG  at 16#1C# range 0 ..  7;
   end record;

   type PORTH8_Type is record
      PxIN   : Bitmap_8    with Volatile_Full_Access => True;
      PxOUT  : Bitmap_8    with Volatile_Full_Access => True;
      PxDIR  : Bitmap_8    with Volatile_Full_Access => True;
      PxREN  : Bitmap_8    with Volatile_Full_Access => True;
      PxDS   : Bitmap_8    with Volatile_Full_Access => True;
      PxSEL0 : Bitmap_8    with Volatile_Full_Access => True;
      PxSEL1 : Bitmap_8    with Volatile_Full_Access => True;
      PxSELC : Bitmap_8    with Volatile_Full_Access => True;
      PxIES  : Bitmap_8    with Volatile_Full_Access => True;
      PxIE   : Bitmap_8    with Volatile_Full_Access => True;
      PxIFG  : Bitmap_8    with Volatile_Full_Access => True;
      PxIV   : Unsigned_16 with Volatile_Full_Access => True;
   end record
      with Bit_Order => Low_Order_First,
           Size      => 16#20# * 8;
   for PORTH8_Type use record
      PxIN   at 16#01# range 0 ..  7;
      PxOUT  at 16#03# range 0 ..  7;
      PxDIR  at 16#05# range 0 ..  7;
      PxREN  at 16#07# range 0 ..  7;
      PxDS   at 16#09# range 0 ..  7;
      PxSEL0 at 16#0B# range 0 ..  7;
      PxSEL1 at 16#0D# range 0 ..  7;
      PxSELC at 16#17# range 0 ..  7;
      PxIES  at 16#19# range 0 ..  7;
      PxIE   at 16#1B# range 0 ..  7;
      PxIFG  at 16#1D# range 0 ..  7;
      PxIV   at 16#1E# range 0 .. 15;
   end record;

   -- Table 6-21. Port Registers (Base Address: 0x4000_4C00)

   PORT_BASEADDRESS : constant := 16#4000_4C00#;

pragma Style_Checks (Off);
   PA  : aliased PORT16_Type with Address => To_Address (PORT_BASEADDRESS + 16#000#), Volatile => True, Import => True, Convention => Ada;
   PB  : aliased PORT16_Type with Address => To_Address (PORT_BASEADDRESS + 16#020#), Volatile => True, Import => True, Convention => Ada;
   PC  : aliased PORT16_Type with Address => To_Address (PORT_BASEADDRESS + 16#040#), Volatile => True, Import => True, Convention => Ada;
   PD  : aliased PORT16_Type with Address => To_Address (PORT_BASEADDRESS + 16#060#), Volatile => True, Import => True, Convention => Ada;
   PE  : aliased PORT16_Type with Address => To_Address (PORT_BASEADDRESS + 16#080#), Volatile => True, Import => True, Convention => Ada;
   P1  : aliased PORTL8_Type with Address => To_Address (PORT_BASEADDRESS + 16#000#), Volatile => True, Import => True, Convention => Ada;
   P2  : aliased PORTH8_Type with Address => To_Address (PORT_BASEADDRESS + 16#000#), Volatile => True, Import => True, Convention => Ada;
   P3  : aliased PORTL8_Type with Address => To_Address (PORT_BASEADDRESS + 16#020#), Volatile => True, Import => True, Convention => Ada;
   P4  : aliased PORTH8_Type with Address => To_Address (PORT_BASEADDRESS + 16#020#), Volatile => True, Import => True, Convention => Ada;
   P5  : aliased PORTL8_Type with Address => To_Address (PORT_BASEADDRESS + 16#040#), Volatile => True, Import => True, Convention => Ada;
   P6  : aliased PORTH8_Type with Address => To_Address (PORT_BASEADDRESS + 16#040#), Volatile => True, Import => True, Convention => Ada;
   P7  : aliased PORTL8_Type with Address => To_Address (PORT_BASEADDRESS + 16#060#), Volatile => True, Import => True, Convention => Ada;
   P8  : aliased PORTH8_Type with Address => To_Address (PORT_BASEADDRESS + 16#060#), Volatile => True, Import => True, Convention => Ada;
   P9  : aliased PORTL8_Type with Address => To_Address (PORT_BASEADDRESS + 16#080#), Volatile => True, Import => True, Convention => Ada;
   P10 : aliased PORTH8_Type with Address => To_Address (PORT_BASEADDRESS + 16#080#), Volatile => True, Import => True, Convention => Ada;
   PJ  : aliased PORT16_Type with Address => To_Address (PORT_BASEADDRESS + 16#120#), Volatile => True, Import => True, Convention => Ada;
pragma Style_Checks (On);

   ----------------------------------------------------------------------------
   -- 17 Watchdog Timer (WDT_A)
   ----------------------------------------------------------------------------

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

   -- Table 6-20. WDT_A Registers (Base Address: 0x4000_4800)

   WDTCTL_ADDRESS : constant := 16#4000_480C#;

   WDTCTL : aliased WDTCTL_Type
      with Address    => To_Address (WDTCTL_ADDRESS),
           Volatile   => True,
           Import     => True,
           Convention => Ada;

   ----------------------------------------------------------------------------
   -- 24 Enhanced Universal Serial Communication Interface (eUSCI) – UART Mode
   ----------------------------------------------------------------------------

   -- 24.4.1 UCAxCTLW0 Register Control Word Register 0

   UCSSELx_UCLK    : constant := 2#00#; -- UCLK
   UCSSELx_ACLK    : constant := 2#01#; -- ACLK
   UCSSELx_SMCLK   : constant := 2#10#; -- SMCLK
   UCSSELx_SMCLK_2 : constant := 2#11#; -- SMCLK

   UCMODEx_UART     : constant := 2#00#; -- UART mode
   UCMODEx_IDLEMP   : constant := 2#01#; -- Idle-line multiprocessor mode
   UCMODEx_ADDRMP   : constant := 2#10#; -- Address-bit multiprocessor mode
   UCMODEx_UARTAUTO : constant := 2#11#; -- UART mode with automatic baud-rate detection

   UCSPB_1 : constant := 0; -- One stop bit
   UCSPB_2 : constant := 1; -- Two stop bits

   UC7BIT_8 : constant := 0; -- 8-bit data
   UC7BIT_7 : constant := 1; -- 7-bit data

   UCMSB_LSB : constant := 0; -- LSB first
   UCMSB_MSB : constant := 1; -- MSB first

   UCPAR_ODD  : constant := 0; -- Odd parity
   UCPAR_EVEN : constant := 1; -- Even parity

   type UCAxCTLW0_Type is record
      UCSWRST  : Boolean; -- Software reset enable
      UCTXBRK  : Boolean; -- Transmit break.
      UCTXADDR : Boolean; -- Transmit address.
      UCDORM   : Boolean; -- Dormant.
      UCBRKIE  : Boolean; -- Receive break character interrupt enable
      UCRXEIE  : Boolean; -- Receive erroneous-character interrupt enable
      UCSSELx  : Bits_2;  -- eUSCI_A clock source select.
      UCSYNC   : Boolean; -- Synchronous mode enable
      UCMODEx  : Bits_2;  -- eUSCI_A mode.
      UCSPB    : Bits_1;  -- Stop bit select.
      UC7BIT   : Bits_1;  -- Character length.
      UCMSB    : Bits_1;  -- MSB first select.
      UCPAR    : Bits_1;  -- Parity select.
      UCPEN    : Boolean; -- Parity enable
   end record
      with Bit_Order => Low_Order_First,
           Size      => 16;
   for UCAxCTLW0_Type use record
      UCSWRST  at 0 range  0 .. 0;
      UCTXBRK  at 0 range  1 .. 1;
      UCTXADDR at 0 range  2 .. 2;
      UCDORM   at 0 range  3 .. 3;
      UCBRKIE  at 0 range  4 .. 4;
      UCRXEIE  at 0 range  5 .. 5;
      UCSSELx  at 0 range  6 .. 7;
      UCSYNC   at 0 range  8 .. 8;
      UCMODEx  at 0 range  9 .. 10;
      UCSPB    at 0 range 11 .. 11;
      UC7BIT   at 0 range 12 .. 12;
      UCMSB    at 0 range 13 .. 13;
      UCPAR    at 0 range 14 .. 14;
      UCPEN    at 0 range 15 .. 15;
   end record;

   -- 24.4.2 UCAxCTLW1 Register Control Word Register 1

   UCGLITx_5ns  : constant := 2#00#; -- Approximately 5 ns
   UCGLITx_20ns : constant := 2#01#; -- Approximately 20 ns
   UCGLITx_30ns : constant := 2#10#; -- Approximately 30 ns
   UCGLITx_50ns : constant := 2#11#; -- Approximately 50 ns

   type UCAxCTLW1_Type is record
      UCGLITx  : Bits_2;       -- Deglitch time
      Reserved : Bits_14 := 0;
   end record
      with Bit_Order => Low_Order_First,
           Size      => 16;
   for UCAxCTLW1_Type use record
      UCGLITx  at 0 range 0 ..  1;
      Reserved at 0 range 2 .. 15;
   end record;

   -- 24.4.4 UCAxMCTLW Register Modulation Control Word Register

   type UCAxMCTLW_Type is record
      UCOS16   : Boolean;     -- Oversampling mode enabled
      Reserved : Bits_3 := 0;
      UCBRFx   : Bits_4;      -- First modulation stage select.
      UCBRSx   : Bits_8;      -- Second modulation stage select.
   end record
      with Bit_Order => Low_Order_First,
           Size      => 16;
   for UCAxMCTLW_Type use record
      UCOS16   at 0 range 0 ..  0;
      Reserved at 0 range 1 ..  3;
      UCBRFx   at 0 range 4 ..  7;
      UCBRSx   at 0 range 8 .. 15;
   end record;

   -- 24.4.5 UCAxSTATW Register Status Register

   type UCAxSTATW_Type is record
      UCBUSY        : Boolean;     -- eUSCI_A busy.
      UCADDR_UCIDLE : Boolean;     -- UCADDR: Address received in address-bit multiprocessor mode. UCIDLE: ...
      UCRXERR       : Boolean;     -- Receive error flag.
      UCBRK         : Boolean;     -- Break detect flag.
      UCPE          : Boolean;     -- Parity error flag.
      UCOE          : Boolean;     -- Overrun error flag.
      UCFE          : Boolean;     -- Framing error flag.
      UCLISTEN      : Boolean;     -- Listen enable.
      Reserved      : Bits_8 := 0;
   end record
      with Bit_Order => Low_Order_First,
           Size      => 16;
   for UCAxSTATW_Type use record
      UCBUSY        at 0 range 0 ..  0;
      UCADDR_UCIDLE at 0 range 1 ..  1;
      UCRXERR       at 0 range 2 ..  2;
      UCBRK         at 0 range 3 ..  3;
      UCPE          at 0 range 4 ..  4;
      UCOE          at 0 range 5 ..  5;
      UCFE          at 0 range 6 ..  6;
      UCLISTEN      at 0 range 7 ..  7;
      Reserved      at 0 range 8 .. 15;
   end record;

   -- 24.4.6 UCAxRXBUF Register

   type UCAxRXBUF_Type is record
      UCRXBUFx : Unsigned_8;  -- The receive-data buffer is user accessible and contains the last received ...
      Reserved : Bits_8 := 0;
   end record
      with Bit_Order => Low_Order_First,
           Size      => 16;
   for UCAxRXBUF_Type use record
      UCRXBUFx at 0 range 0 ..  7;
      Reserved at 0 range 8 .. 15;
   end record;

   -- 24.4.7 UCAxTXBUF Register Transmit Buffer Register

   type UCAxTXBUF_Type is record
      UCTXBUFx : Unsigned_8;  -- The transmit data buffer is user accessible and holds the data waiting to be ...
      Reserved : Bits_8 := 0;
   end record
      with Bit_Order => Low_Order_First,
           Size      => 16;
   for UCAxTXBUF_Type use record
      UCTXBUFx at 0 range 0 ..  7;
      Reserved at 0 range 8 .. 15;
   end record;

   -- 24.4.8 UCAxABCTL Register Auto Baud Rate Control Register

   UCDELIMx_1 : constant := 2#00#; -- 1 bit time
   UCDELIMx_2 : constant := 2#01#; -- 2 bit times
   UCDELIMx_3 : constant := 2#10#; -- 3 bit times
   UCDELIMx_4 : constant := 2#11#; -- 4 bit times

   type UCAxABCTL_Type is record
      UCABDEN   : Boolean;      -- Automatic baud-rate detect enable
      Reserved1 : Bits_1 := 0;
      UCBTOE    : Boolean;      -- Break time out error
      UCSTOE    : Boolean;      -- Synch field time out error
      UCDELIMx  : Bits_2;       -- Break/synch delimiter length
      Reserved2 : Bits_10 := 0;
   end record
      with Bit_Order => Low_Order_First,
           Size      => 16;
   for UCAxABCTL_Type use record
      UCABDEN   at 0 range 0 ..  0;
      Reserved1 at 0 range 1 ..  1;
      UCBTOE    at 0 range 2 ..  2;
      UCSTOE    at 0 range 3 ..  3;
      UCDELIMx  at 0 range 4 ..  5;
      Reserved2 at 0 range 6 .. 15;
   end record;

   -- 24.4.9 UCAxIRCTL Register IrDA Control Word Register

   UCIRTXCLK_BRCLK          : constant := 0; -- BRCLK
   UCIRTXCLK_UCOS16BITCLK16 : constant := 1; -- BITCLK16 when UCOS16 = 1. Otherwise, BRCLK.

   UCIRRXPL_HI : constant := 0; -- IrDA transceiver delivers a high pulse when a light pulse is seen.
   UCIRRXPL_LO : constant := 1; -- IrDA transceiver delivers a low pulse when a light pulse is seen.

   type UCAxIRCTL_Type is record
      UCIREN    : Boolean; -- IrDA encoder and decoder enable
      UCIRTXCLK : Bits_1;  -- IrDA transmit pulse clock select
      UCIRTXPLx : Bits_6;  -- Transmit pulse length.
      UCIRRXFE  : Boolean; -- IrDA receive filter enabled
      UCIRRXPL  : Bits_1;  -- IrDA receive input UCAxRXD polarity
      UCIRRXFLx : Bits_6;  -- Receive filter length.
   end record
      with Bit_Order => Low_Order_First,
           Size      => 16;
   for UCAxIRCTL_Type use record
      UCIREN    at 0 range  0 ..  0;
      UCIRTXCLK at 0 range  1 ..  1;
      UCIRTXPLx at 0 range  2 ..  7;
      UCIRRXFE  at 0 range  8 ..  8;
      UCIRRXPL  at 0 range  9 ..  9;
      UCIRRXFLx at 0 range 10 .. 15;
   end record;

   -- 24.4.10 UCAxIE Register Interrupt Enable Register

   type UCAxIE_Type is record
      UCRXIE    : Boolean;      -- Receive interrupt enable
      UCTXIE    : Boolean;      -- Transmit interrupt enable
      UCSTTIE   : Boolean;      -- Start bit interrupt enable
      UCTXCPTIE : Boolean;      -- Transmit complete interrupt enable
      Reserved  : Bits_12 := 0;
   end record
      with Bit_Order => Low_Order_First,
           Size      => 16;
   for UCAxIE_Type use record
      UCRXIE    at 0 range 0 ..  0;
      UCTXIE    at 0 range 1 ..  1;
      UCSTTIE   at 0 range 2 ..  2;
      UCTXCPTIE at 0 range 3 ..  3;
      Reserved  at 0 range 4 .. 15;
   end record;

   -- 24.4.11 UCAxIFG Register Interrupt Flag Register

   type UCAxIFG_Type is record
      UCRXIFG    : Boolean;      -- Receive interrupt flag.
      UCTXIFG    : Boolean;      -- Transmit interrupt flag.
      UCSTTIFG   : Boolean;      -- Start bit interrupt flag.
      UCTXCPTIFG : Boolean;      -- Transmit complete interrupt flag.
      Reserved   : Bits_12 := 0;
   end record
      with Bit_Order => Low_Order_First,
           Size      => 16;
   for UCAxIFG_Type use record
      UCRXIFG    at 0 range 0 ..  0;
      UCTXIFG    at 0 range 1 ..  1;
      UCSTTIFG   at 0 range 2 ..  2;
      UCTXCPTIFG at 0 range 3 ..  3;
      Reserved   at 0 range 4 .. 15;
   end record;

   -- 24.4.12 UCAxIV Register Interrupt Vector Register

   UCAxIV_NONE    : constant := 16#00#; -- No interrupt pending
   UCAxIV_RXFULL  : constant := 16#02#; -- Interrupt Source: Receive buffer full; Interrupt Flag: UCRXIFG; ...: Highest
   UCAxIV_TXEMPTY : constant := 16#04#; -- Interrupt Source: Transmit buffer empty; Interrupt Flag: UCTXIFG
   UCAxIV_START   : constant := 16#06#; -- Interrupt Source: Start bit received; Interrupt Flag: UCSTTIFG
   UCAxIV_TXDONE  : constant := 16#08#; -- Interrupt Source: Transmit complete; Interrupt Flag: UCTXCPTIFG; ...: Lowest

end MSP432P401R;

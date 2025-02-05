-----------------------------------------------------------------------------------------------------------------------
--                                                     SweetAda                                                      --
-----------------------------------------------------------------------------------------------------------------------
-- __HDS__                                                                                                           --
-- __FLN__ definitions.ads                                                                                           --
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

with Ada.Characters.Latin_1;

package Definitions
   with Pure       => True,
        SPARK_Mode => On
   is

   --========================================================================--
   --                                                                        --
   --                                                                        --
   --                               Public part                              --
   --                                                                        --
   --                                                                        --
   --========================================================================--

   package ISO88591 renames Ada.Characters.Latin_1;

   -- common character/string constants
   CRLF : constant String := ISO88591.CR & ISO88591.LF;

   -- ANSI sequences
   ANSI_CLS     : constant String := ISO88591.ESC & "[" & "2J";   -- clear terminal screen
   ANSI_CUPHOME : constant String := ISO88591.ESC & "[" & "1;1H"; -- reset cursor position at (1,1)

   -- VT100 sequences
   VT100_LINEWRAP : constant String := ISO88591.ESC & "[" & "7h"; -- enable line wrap

   -- memory sizes as powers of 2
   kB1    : constant := 2**10;
   kB2    : constant := 2**11;
   kB4    : constant := 2**12;
   kB8    : constant := 2**13;
   kB16   : constant := 2**14;
   kB32   : constant := 2**15;
   kB64   : constant := 2**16;
   kB128  : constant := 2**17;
   kB256  : constant := 2**18;
   kB512  : constant := 2**19;
   kB1024 : constant := 2**20;
   MB1    : constant := kB1024;
   MB2    : constant := 2**21;
   MB4    : constant := 2**22;
   MB8    : constant := 2**23;
   MB16   : constant := 2**24;
   MB32   : constant := 2**25;
   MB64   : constant := 2**26;
   MB128  : constant := 2**27;
   MB256  : constant := 2**28;
   MB512  : constant := 2**29;
   MB1024 : constant := 2**30;
   GB1    : constant := MB1024;
   GB2    : constant := 2**31;
   GB4    : constant := 2**32;
   GB8    : constant := 2**33;
   GB16   : constant := 2**34;
   GB32   : constant := 2**35;
   GB64   : constant := 2**36;
   GB128  : constant := 2**37;
   GB256  : constant := 2**38;
   GB512  : constant := 2**39;
   GB1024 : constant := 2**40;
   TB1    : constant := GB1024;

   -- various constants
   kHz1 : constant := 1_000;
   MHz1 : constant := 1_000 * kHz1;
   GHz1 : constant := 1_000 * MHz1;

   -- common known clock rates in Hz
   CLK_RTC32k   : constant :=      32_768; -- 2**15
   CLK_1M       : constant :=   1_000_000; -- standard value
   CLK_RTC1M    : constant :=   1_048_576; -- 2**20
   CLK_UART1M8  : constant :=   1_843_200; -- 115_200 * 16
   CLK_2M       : constant :=   2_000_000; -- standard value
   CLK_RTC2M    : constant :=   2_097_152; -- 2**21
   CLK_UART2M4  : constant :=   2_457_600; -- 9_600 * 16**2 = CLK_UART1M8 * 4/3
   CLK_2M5      : constant :=   2_500_000; -- MIIM
   CLK_NTSC     : constant :=   3_579_545; -- 315_000_000 / 88
   CLK_UART3M6  : constant :=   3_686_400; -- CLK_UART1M8 * 2
   CLK_4M       : constant :=   4_000_000; -- standard value
   CLK_RTC4M    : constant :=   4_194_304; -- 2**22
   CLK_PAL      : constant :=   4_433_619; -- 283.75 * 15625 + 25
   CLK_PC5150   : constant :=   4_772_727; -- CLK_NTSC * 4/3
   CLK_UART4M9  : constant :=   4_915_200; -- CLK_UART1M8 * 8/3
   CLK_6M       : constant :=   6_000_000; -- standard value
   CLK_PALAmiga : constant :=   7_093_790; -- CLK_PAL * 8/5 = CLK_PAL28M / 4
   CLK_NTSCx2   : constant :=   7_159_090; -- CLK_NTSC * 2
   CLK_UART7M3  : constant :=   7_372_800; -- CLK_UART1M8 * 4
   CLK_8M       : constant :=   8_000_000; -- standard value
   CLK_10M      : constant :=  10_000_000; -- standard value
   CLK_12M      : constant :=  12_000_000; -- USB
   CLK_NTSCx4   : constant :=  14_318_182; -- CLK_NTSC * 4
   CLK_UART14M  : constant :=  14_745_600; -- CLK_UART1M8 * 8
   CLK_16M      : constant :=  16_000_000; -- standard value
   CLK_UART18M  : constant :=  18_432_000; -- CLK_UART1M8 * 10
   CLK_20M      : constant :=  20_000_000; -- standard value
   CLK_PAL28M   : constant :=  28_375_160; -- CLK_PAL * 64/10
   CLK_25M      : constant :=  25_000_000; -- MII PHY
   CLK_33M      : constant :=  33_000_000; -- standard value
   CLK_33M33    : constant :=  33_330_000; -- PCI
   CLK_40M      : constant :=  40_000_000; -- standard value
   CLK_50M      : constant :=  50_000_000; -- RMII PHY
   CLK_66M      : constant :=  66_000_000; -- standard value
   CLK_66M66    : constant :=  66_667_000; -- PCI
   CLK_75M      : constant :=  75_000_000; -- standard value
   CLK_80M      : constant :=  80_000_000; -- standard value
   CLK_100M     : constant := 100_000_000; -- standard value
   CLK_120M     : constant := 120_000_000; -- standard value
   CLK_133M     : constant := 133_000_000; -- standard value
   CLK_150M     : constant := 150_000_000; -- standard value

   -- serial port baud rates
   type Baud_Rate_Type is
      (BR_50,
       BR_75,
       BR_110,
       BR_134,
       BR_150,
       BR_200,
       BR_300,
       BR_600,
       BR_1200,
       BR_1800,
       BR_2400,
       BR_4800,
       BR_9600,
       BR_19200,
       BR_28800,
       BR_38400,
       BR_57600,
       BR_76800,
       BR_115200,
       BR_230400,
       BR_460800,
       BR_576000,
       BR_921600);
   for Baud_Rate_Type use
      (50,
       75,
       110,
       134,
       150,
       200,
       300,
       600,
       1_200,
       1_800,
       2_400,
       4_800,
       9_600,
       19_200,
       28_800,
       38_400,
       57_600,
       76_800,
       115_200,
       230_400,
       460_800,
       576_000,
       921_600);

end Definitions;

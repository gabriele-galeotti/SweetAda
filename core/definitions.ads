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

   -- sizes as powers of 2
   Ki1    : constant := 2**10;
   Ki2    : constant := 2**11;
   Ki4    : constant := 2**12;
   Ki8    : constant := 2**13;
   Ki16   : constant := 2**14;
   Ki32   : constant := 2**15;
   Ki64   : constant := 2**16;
   Ki128  : constant := 2**17;
   Ki256  : constant := 2**18;
   Ki512  : constant := 2**19;
   Ki1024 : constant := 2**20;
   Mi1    : constant := Ki1024;
   Mi2    : constant := 2**21;
   Mi4    : constant := 2**22;
   Mi8    : constant := 2**23;
   Mi16   : constant := 2**24;
   Mi32   : constant := 2**25;
   Mi64   : constant := 2**26;
   Mi128  : constant := 2**27;
   Mi256  : constant := 2**28;
   Mi512  : constant := 2**29;
   Mi1024 : constant := 2**30;
   Gi1    : constant := Mi1024;
   Gi2    : constant := 2**31;
   Gi4    : constant := 2**32;
   Gi8    : constant := 2**33;
   Gi16   : constant := 2**34;
   Gi32   : constant := 2**35;
   Gi64   : constant := 2**36;
   Gi128  : constant := 2**37;
   Gi256  : constant := 2**38;
   Gi512  : constant := 2**39;
   Gi1024 : constant := 2**40;
   Ti1    : constant := Gi1024;

   -- byte sizes as powers of 2
   KiB1    renames Ki1;
   KiB2    renames Ki2;
   KiB4    renames Ki4;
   KiB8    renames Ki8;
   KiB16   renames Ki16;
   KiB32   renames Ki32;
   KiB64   renames Ki64;
   KiB128  renames Ki128;
   KiB256  renames Ki256;
   KiB512  renames Ki512;
   KiB1024 renames Ki1024;
   MiB1    renames Mi1;
   MiB2    renames Mi2;
   MiB4    renames Mi4;
   MiB8    renames Mi8;
   MiB16   renames Mi16;
   MiB32   renames Mi32;
   MiB64   renames Mi64;
   MiB128  renames Mi128;
   MiB256  renames Mi256;
   MiB512  renames Mi512;
   MiB1024 renames Mi1024;
   GiB1    renames Gi1;
   GiB2    renames Gi2;
   GiB4    renames Gi4;
   GiB8    renames Gi8;
   GiB16   renames Gi16;
   GiB32   renames Gi32;
   GiB64   renames Gi64;
   GiB128  renames Gi128;
   GiB256  renames Gi256;
   GiB512  renames Gi512;
   GiB1024 renames Gi1024;
   TiB1    renames Ti1;

   -- frequency rates
   kHz1 : constant := 1_000;
   MHz1 : constant := 1_000 * kHz1;
   GHz1 : constant := 1_000 * MHz1;

   -- common known clock rates in Hz
   -- MHz-fractional rates are written in full form
   CLK_RTC32k   : constant :=      32_768; -- 2**15
   CLK_1M       : constant :=    1 * MHz1; -- standard value
   CLK_RTC1M    : constant :=   1_048_576; -- 2**20
   CLK_UART1M8  : constant :=   1_843_200; -- 115_200 * 16
   CLK_2M       : constant :=    2 * MHz1; -- standard value
   CLK_RTC2M    : constant :=   2_097_152; -- 2**21
   CLK_UART2M4  : constant :=   2_457_600; -- 9_600 * 16**2 = CLK_UART1M8 * 4/3
   CLK_2M5      : constant :=   2_500_000; -- MIIM
   CLK_NTSC     : constant :=   3_579_545; -- 315_000_000 / 88
   CLK_UART3M6  : constant :=   3_686_400; -- CLK_UART1M8 * 2
   CLK_4M       : constant :=    4 * MHz1; -- standard value
   CLK_RTC4M    : constant :=   4_194_304; -- 2**22
   CLK_PAL      : constant :=   4_433_619; -- 283.75 * 15_625 + 25
   CLK_PC5150   : constant :=   4_772_727; -- CLK_NTSC * 4/3
   CLK_UART4M9  : constant :=   4_915_200; -- CLK_UART1M8 * 8/3
   CLK_6M       : constant :=    6 * MHz1; -- standard value
   CLK_PALAmiga : constant :=   7_093_790; -- CLK_PAL * 8/5 = CLK_PAL28M / 4
   CLK_NTSCx2   : constant :=   7_159_090; -- CLK_NTSC * 2
   CLK_UART7M3  : constant :=   7_372_800; -- CLK_UART1M8 * 4
   CLK_8M       : constant :=    8 * MHz1; -- standard value
   CLK_10M      : constant :=   10 * MHz1; -- standard value
   CLK_12M      : constant :=   12 * MHz1; -- USB
   CLK_NTSCx4   : constant :=  14_318_182; -- CLK_NTSC * 4
   CLK_UART14M  : constant :=  14_745_600; -- CLK_UART1M8 * 8
   CLK_16M      : constant :=   16 * MHz1; -- standard value
   CLK_UART18M  : constant :=  18_432_000; -- CLK_UART1M8 * 10
   CLK_20M      : constant :=   20 * MHz1; -- standard value
   CLK_25M      : constant :=   25 * MHz1; -- MII PHY
   CLK_VGA25M   : constant :=  25_175_000; -- VGA 800 ppl
   CLK_VGA28M   : constant :=  28_322_000; -- VGA 900 ppl
   CLK_PAL28M   : constant :=  28_375_160; -- CLK_PAL * 64/10
   CLK_33M      : constant :=   33 * MHz1; -- standard value
   CLK_33M33    : constant :=  33_330_000; -- PCI
   CLK_40M      : constant :=   40 * MHz1; -- standard value
   CLK_48M      : constant :=   48 * MHz1; -- standard value
   CLK_50M      : constant :=   50 * MHz1; -- RMII PHY
   CLK_66M      : constant :=   66 * MHz1; -- standard value
   CLK_66M66    : constant :=  66_667_000; -- PCI
   CLK_75M      : constant :=   75 * MHz1; -- standard value
   CLK_80M      : constant :=   80 * MHz1; -- standard value
   CLK_90M      : constant :=   90 * MHz1; -- standard value
   CLK_100M     : constant :=  100 * MHz1; -- standard value
   CLK_120M     : constant :=  120 * MHz1; -- standard value
   CLK_133M     : constant :=  133 * MHz1; -- standard value
   CLK_150M     : constant :=  150 * MHz1; -- standard value
   CLK_180M     : constant :=  180 * MHz1; -- standard value
   CLK_200M     : constant :=  200 * MHz1; -- standard value

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

-----------------------------------------------------------------------------------------------------------------------
--                                                     SweetAda                                                      --
-----------------------------------------------------------------------------------------------------------------------
-- __HDS__                                                                                                           --
-- __FLN__ definitions.ads                                                                                           --
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

with Ada.Characters.Latin_1;

package Definitions
   with Pure => True
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

   -- various constants
   kHz1 : constant := 1_000;
   MHz1 : constant := 1_000 * kHz1;
   GHz1 : constant := 1_000 * MHz1;

   -- common known clock rates in Hz
   CLK_RTC32k   : constant :=     32_768; -- 2**15
   CLK_RTC1M    : constant :=  1_048_576; -- 2**20
   CLK_UART1M8  : constant :=  1_843_200; -- 3**2 * 5**2 * 2**13
   CLK_RTC2M    : constant :=  2_097_152; -- 2**21
   CLK_UART2M4  : constant :=  2_457_600; -- CLK_UART1M8 * 4/3
   CLK_NTSC     : constant :=  3_579_545; -- 5 * 10**6 * 63/88
   CLK_UART3M6  : constant :=  3_686_400; -- CLK_UART1M8 * 2
   CLK_RTC4M    : constant :=  4_194_304; -- 2**22
   CLK_PAL      : constant :=  4_433_619; -- 283.75 * 15625 + 25
   CLK_UART4M9  : constant :=  4_915_200; -- CLK_UART1M8 * 8/3
   CLK_PALAmiga : constant :=  7_093_790; -- CLK_PAL28M / 4
   CLK_NTSCx2   : constant :=  7_159_090;
   CLK_UART7M3  : constant :=  7_372_800; -- CLK_UART1M8 * 4
   CLK_NTSCx4   : constant := 14_318_182;
   CLK_UART14M  : constant := 14_745_600; -- CLK_UART1M8 * 8
   CLK_UART18M  : constant := 18_432_000; -- CLK_UART1M8 * 10
   CLK_PAL28M   : constant := 28_375_160; -- CLK_PAL * 64/10

   -- serial port baud rates
   type Baud_Rate_Type is
      (BR_300,
       BR_1200,
       BR_2400,
       BR_4800,
       BR_9600,
       BR_19200,
       BR_38400,
       BR_57600,
       BR_115200,
       BR_230400);
   for Baud_Rate_Type use
      (300,
       1_200,
       2_400,
       4_800,
       9_600,
       19_200,
       38_400,
       57_600,
       115_200,
       230_400);

end Definitions;

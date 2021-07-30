-----------------------------------------------------------------------------------------------------------------------
--                                                     SweetAda                                                      --
-----------------------------------------------------------------------------------------------------------------------
-- __HDS__                                                                                                           --
-- __FLN__ definitions.ads                                                                                           --
-- __DSC__                                                                                                           --
-- __HSH__ e69de29bb2d1d6434b8b29ae775ad8c2e48c5391                                                                  --
-- __HDE__                                                                                                           --
-----------------------------------------------------------------------------------------------------------------------
-- Copyright (C) 2020, 2021 Gabriele Galeotti                                                                        --
--                                                                                                                   --
-- SweetAda web page: http://sweetada.org                                                                            --
-- contact address: gabriele.galeotti@sweetada.org                                                                   --
-- This work is licensed under the terms of the MIT License.                                                         --
-- Please consult the LICENSE.txt file located in the top-level directory.                                           --
-----------------------------------------------------------------------------------------------------------------------

with Ada.Characters.Latin_1;

package Definitions is

   --========================================================================--
   --                                                                        --
   --                                                                        --
   --                               Public part                              --
   --                                                                        --
   --                                                                        --
   --========================================================================--

   pragma Pure;

   package ISO88591 renames Ada.Characters.Latin_1;

   -- common character/string constants
   CRLF     : constant String := ISO88591.CR & ISO88591.LF;
   ANSI_CLS : constant String := ISO88591.CSI & "2J";       -- clear terminal screen

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

   -- common known clock rates in Hz
   RTC32_CLK    : constant := 32_768;
   UART18_CLK   : constant := 1_843_200;
   UART24_CLK   : constant := 2_457_600;
   NTSC_CLK     : constant := 3_579_545;
   PAL_CLK      : constant := 4_433_619;
   NTSC_CLK4    : constant := 14_318_182;
   UART18_CLK10 : constant := UART18_CLK * 10;

   -- serial port bit rates
   type Baud_Rate_Type is (
                           BR_300,
                           BR_1200,
                           BR_2400,
                           BR_4800,
                           BR_9600,
                           BR_19200,
                           BR_38400,
                           BR_57600,
                           BR_115200,
                           BR_230400
                          );
   for Baud_Rate_Type use (
                           300,
                           1_200,
                           2_400,
                           4_800,
                           9_600,
                           19_200,
                           38_400,
                           57_600,
                           115_200,
                           230_400
                          );

end Definitions;

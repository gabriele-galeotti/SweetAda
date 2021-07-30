-----------------------------------------------------------------------------------------------------------------------
--                                                     SweetAda                                                      --
-----------------------------------------------------------------------------------------------------------------------
-- __HDS__                                                                                                           --
-- __FLN__ ansicolors.ads                                                                                            --
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

package ANSICOLORS is

   --========================================================================--
   --                                                                        --
   --                                                                        --
   --                               Public part                              --
   --                                                                        --
   --                                                                        --
   --========================================================================--

   pragma Pure;

   package ISO88591 renames Ada.Characters.Latin_1;

   COLOR_BLACK   : constant String := ISO88591.CSI & "30m";
   COLOR_RED     : constant String := ISO88591.CSI & "31m";
   COLOR_GREEN   : constant String := ISO88591.CSI & "32m";
   COLOR_YELLOW  : constant String := ISO88591.CSI & "33m";
   COLOR_BLUE    : constant String := ISO88591.CSI & "34m";
   COLOR_MAGENTA : constant String := ISO88591.CSI & "35m";
   COLOR_CYAN    : constant String := ISO88591.CSI & "36m";
   COLOR_WHITE   : constant String := ISO88591.CSI & "37m";

   COLOR_BBLACK   : constant String := ISO88591.CSI & "30;1m";
   COLOR_BRED     : constant String := ISO88591.CSI & "31;1m";
   COLOR_BGREEN   : constant String := ISO88591.CSI & "32;1m";
   COLOR_BYELLOW  : constant String := ISO88591.CSI & "33;1m";
   COLOR_BBLUE    : constant String := ISO88591.CSI & "34;1m";
   COLOR_BMAGENTA : constant String := ISO88591.CSI & "35;1m";
   COLOR_BCYAN    : constant String := ISO88591.CSI & "36;1m";
   COLOR_BWHITE   : constant String := ISO88591.CSI & "37;1m";

   COLOR_BGNDBLACK   : constant String := ISO88591.CSI & "40m";
   COLOR_BGNDRED     : constant String := ISO88591.CSI & "41m";
   COLOR_BGNDGREEN   : constant String := ISO88591.CSI & "42m";
   COLOR_BGNDYELLOW  : constant String := ISO88591.CSI & "43m";
   COLOR_BGNDBLUE    : constant String := ISO88591.CSI & "44m";
   COLOR_BGNDMAGENTA : constant String := ISO88591.CSI & "45m";
   COLOR_BGNDCYAN    : constant String := ISO88591.CSI & "46m";
   COLOR_BGNDWHITE   : constant String := ISO88591.CSI & "47m";

   COLOR_BBGNDBLACK   : constant String := ISO88591.CSI & "40;1m";
   COLOR_BBGNDRED     : constant String := ISO88591.CSI & "41;1m";
   COLOR_BBGNDGREEN   : constant String := ISO88591.CSI & "42;1m";
   COLOR_BBGNDYELLOW  : constant String := ISO88591.CSI & "43;1m";
   COLOR_BBGNDBLUE    : constant String := ISO88591.CSI & "44;1m";
   COLOR_BBGNDMAGENTA : constant String := ISO88591.CSI & "45;1m";
   COLOR_BBGNDCYAN    : constant String := ISO88591.CSI & "46;1m";
   COLOR_BBGNDWHITE   : constant String := ISO88591.CSI & "47;1m";

   COLOR_RESET : constant String := ISO88591.CSI & "0m";

end ANSICOLORS;

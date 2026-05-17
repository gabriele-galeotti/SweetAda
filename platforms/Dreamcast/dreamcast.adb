-----------------------------------------------------------------------------------------------------------------------
--                                                     SweetAda                                                      --
-----------------------------------------------------------------------------------------------------------------------
-- __HDS__                                                                                                           --
-- __FLN__ dreamcast.adb                                                                                             --
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

with System.Machine_Code;
with Definitions;

package body Dreamcast
   is

   --========================================================================--
   --                                                                        --
   --                                                                        --
   --                           Local declarations                           --
   --                                                                        --
   --                                                                        --
   --========================================================================--

   use System.Machine_Code;
   use Definitions;

   --========================================================================--
   --                                                                        --
   --                                                                        --
   --                           Package subprograms                          --
   --                                                                        --
   --                                                                        --
   --========================================================================--

   ----------------------------------------------------------------------------
   -- Video_Cable
   ----------------------------------------------------------------------------
   function Video_Cable
      return Video_Cable_Type
      is
      PortA : aliased Unsigned_32
         with Address              => System'To_Address (16#FF80_002C#),
              Volatile_Full_Access => True,
              Import               => True,
              Convention           => Ada;
      Port89 : aliased Unsigned_16
         with Address              => System'To_Address (16#FF80_0030#),
              Volatile_Full_Access => True,
              Import               => True,
              Convention           => Ada;
   begin
      -- set PORT8 and PORT9 to input
      PortA := (PortA and 16#FFF0_FFFF#) or 16#000A_0000#;
      case Bits_2 (Shift_Right (Port89, 8) and 16#0003#) is
         when 0 => return CABLE_VGA;
         when 1 => return CABLE_NONE;
         when 2 => return CABLE_RGB;
         when 3 => return CABLE_COMPOSITE;
      end case;
   end Video_Cable;

   ----------------------------------------------------------------------------
   -- Video_Font
   ----------------------------------------------------------------------------
   function Video_Font
      return Address
      is
      Result : System.Address;
   begin
      Asm (
           Template => ""                       & CRLF &
                       "        mov.l   @%1,r0" & CRLF &
                       "        jsr     @r0   " & CRLF &
                       "        mov     #0,r1 " & CRLF &
                       "        mov     r0,%0 " & CRLF &
                       "",
           Outputs  => Address'Asm_Output ("=r", Result),
           Inputs   => Address'Asm_Input ("r", System'To_Address (16#8C00_00B4#)),
           Clobber  => "pr,r0,r1",
           Volatile => True
          );
      return Result;
   end Video_Font;

   ----------------------------------------------------------------------------
   -- RTC_Read
   ----------------------------------------------------------------------------
   -- The Epoch of the RTC counter is January 1, 1950 00:00:00.
   -- Since leap years happen in 1952, 1956, 1960, 1964, 1968, we have:
   -- EPOCH_50_70 = (20 * 365 + 5) * 24 * 60 * 60 = 631_152_000
   ----------------------------------------------------------------------------
   function RTC_Read
      return Unsigned_32
      is
      EPOCH_50_70 : constant := 631_152_000;
   begin
      return 0; -- __TBD__
   end RTC_Read;

end Dreamcast;

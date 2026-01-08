-----------------------------------------------------------------------------------------------------------------------
--                                                     SweetAda                                                      --
-----------------------------------------------------------------------------------------------------------------------
-- __HDS__                                                                                                           --
-- __FLN__ tod.adb                                                                                                   --
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

with System.Machine_Code;
with Definitions;
with Bits;

package body TOD
   is

   --========================================================================--
   --                                                                        --
   --                                                                        --
   --                           Local declarations                           --
   --                                                                        --
   --                                                                        --
   --========================================================================--

   use System.Machine_Code;
   use Interfaces;
   use Definitions;

   -- 1 s in TOD units
   TOD_S : constant := 4_096_000_000;

   -- EPOCH_1900 is the duration starting 1900-01-01 and ending 1970-01-01,
   -- in TOD units. Since 1 s (TOD) = 4096*E+6 and EPOCH_1900 = 25,567 days,
   -- we find this result by computing 25_567 * 86_400 * 4_096_000_000
   EPOCH_1900 : constant := 9_048_018_124_800_000_000;

   --========================================================================--
   --                                                                        --
   --                                                                        --
   --                           Package subprograms                          --
   --                                                                        --
   --                                                                        --
   --========================================================================--

   ----------------------------------------------------------------------------
   -- Read
   ----------------------------------------------------------------------------
   function Read
      return Unsigned_64
      is
      Value : Unsigned_64;
   begin
      Asm (
           Template => ""                   & CRLF &
                       "        stck    %0" & CRLF &
                       "",
           Outputs  => Unsigned_64'Asm_Output ("=m", Value),
           Inputs   => No_Input_Operands,
           Clobber  => "",
           Volatile => True
          );
      return Value;
   end Read;

   ----------------------------------------------------------------------------
   -- To_Epoch
   ----------------------------------------------------------------------------
   procedure To_Epoch
      (Value : in     Unsigned_64;
       TM    :    out Time.TM_Time)
      is
      T : Unsigned_64 := Value;
   begin
      T := @ - EPOCH_1900; -- TOD offset 1900-01-01 -> 1970-01-01
      T := @ / TOD_S;      -- scale to number of seconds
      Time.Make_Time (Bits.LWord (T), TM);
   end To_Epoch;

end TOD;

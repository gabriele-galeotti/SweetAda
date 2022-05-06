-----------------------------------------------------------------------------------------------------------------------
--                                                     SweetAda                                                      --
-----------------------------------------------------------------------------------------------------------------------
-- __HDS__                                                                                                           --
-- __FLN__ integer_math.adb                                                                                          --
-- __DSC__                                                                                                           --
-- __HSH__ e69de29bb2d1d6434b8b29ae775ad8c2e48c5391                                                                  --
-- __HDE__                                                                                                           --
-----------------------------------------------------------------------------------------------------------------------
-- Copyright (C) 2020, 2021, 2022 Gabriele Galeotti                                                                  --
--                                                                                                                   --
-- SweetAda web page: http://sweetada.org                                                                            --
-- contact address: gabriele.galeotti@sweetada.org                                                                   --
-- This work is licensed under the terms of the MIT License.                                                         --
-- Please consult the LICENSE.txt file located in the top-level directory.                                           --
-----------------------------------------------------------------------------------------------------------------------

with Interfaces;
with Bits;

package body Integer_Math is

   --========================================================================--
   --                                                                        --
   --                                                                        --
   --                           Package subprograms                          --
   --                                                                        --
   --                                                                        --
   --========================================================================--

   ----------------------------------------------------------------------------
   -- Log2
   ----------------------------------------------------------------------------
   function Log2 (Value : Positive) return Log_Integer is
      Modulo : Positive := Value;
      Result : Log_Integer;
   begin
      Result := 0;
      while Modulo > 255 loop
         Modulo := @ / 2**8;
         Result := @ + 8;
      end loop;
      return Result + Bits.FirstMSBit (Interfaces.Unsigned_8 (Modulo));
   end Log2;

   ----------------------------------------------------------------------------
   -- Roundup
   ----------------------------------------------------------------------------
   function Roundup (Value : Natural; Modulo : Positive) return Natural is
      Result    : Natural;
      Remainder : Natural;
   begin
      Result := Value;
      Remainder := Result mod Modulo;
      if Remainder /= 0 then
         Result := @ + (Modulo - Remainder);
      end if;
      return Result;
   end Roundup;

   ----------------------------------------------------------------------------
   -- Rounddown
   ----------------------------------------------------------------------------
   function Rounddown (Value : Natural; Modulo : Positive) return Natural is
      Result    : Natural;
      Remainder : Natural;
   begin
      Result := Value;
      Remainder := Result mod Modulo;
      if Remainder /= 0 then
         Result := @ - Remainder;
      end if;
      return Result;
   end Rounddown;

end Integer_Math;

-----------------------------------------------------------------------------------------------------------------------
--                                                     SweetAda                                                      --
-----------------------------------------------------------------------------------------------------------------------
-- __HDS__                                                                                                           --
-- __FLN__ floating_point.adb                                                                                        --
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

with Console;

package body Floating_Point is

   --========================================================================--
   --                                                                        --
   --                                                                        --
   --                           Local declarations                           --
   --                                                                        --
   --                                                                        --
   --========================================================================--

   Buffer_Size : constant := 32;
   Buffer      : String (1 .. Buffer_Size);
   Buffer_Idx  : Integer;

   function Exp10 (N : Integer) return Float;
   function Log10 (F : Float) return Integer;

   --========================================================================--
   --                                                                        --
   --                                                                        --
   --                           Package subprograms                          --
   --                                                                        --
   --                                                                        --
   --========================================================================--

   ----------------------------------------------------------------------------
   -- Exp10
   ----------------------------------------------------------------------------
   -- Compute 10^n.
   ----------------------------------------------------------------------------
   function Exp10 (N : Integer) return Float is
      E : Integer := N;
      V : Float := 1.0;
   begin
      while E > 0 loop
         if E >= 5 then
            V := @ * 100000.0;
            E := @ - 5;
         else
            V := @ * 10.0;
            E := @ - 1;
         end if;
      end loop;
      while E < 0 loop
         if E <= -5 then
            V := @ / 100000.0;
            E := @ + 5;
         else
            V := @ / 10.0;
            E := @ + 1;
         end if;
      end loop;
      return V;
   end Exp10;

   ----------------------------------------------------------------------------
   -- Log10
   ----------------------------------------------------------------------------
   -- Compute log10(n).
   ----------------------------------------------------------------------------
   function Log10 (F : Float) return Integer is
      V : Float := F;
      L : Integer := 0;
   begin
      while V >= 10.0 loop
         if V >= 100000.0 then
            V := @ / 100000.0;
            L := @ + 5;
         else
            V := @ / 10.0;
            L := @ + 1;
         end if;
      end loop;
      while V < 1.0 loop
         if V < 0.00001 then
            V := @ * 100000.0;
            L := @ - 5;
         else
            V := @ * 10.0;
            L := @ - 1;
         end if;
      end loop;
      return L;
   end Log10;

   ----------------------------------------------------------------------------
   -- Print (Float)
   ----------------------------------------------------------------------------
   procedure Print_Float (
                          Value     : in Float;
                          Precision : in Integer := 6;
                          NL        : in Boolean := False;
                          Prefix    : in String := "";
                          Suffix    : in String := ""
                         ) is
      F     : Float := Value;
      S     : Character;
      E     : Integer := 0;
      M     : Integer := 0;
      W     : Float;
      D     : Decimal_Digit_Type;
      Error : Boolean := False;
   begin
      if F < 0.0 then
         F := -@;
         S := '-';
      else
         S := '+';
      end if;
      if F /= 0.0 then
         F := @ + Exp10 (Log10 (F) - Precision) / 2.0; -- round (nearest)
         E := Log10 (F);
         if E > 99 or else Precision + 7 >= Buffer_Size then
            Error := True;
            Buffer (1 .. 8) := "OVERFLOW";
            Buffer_Idx := 8;
         else
            if E < -99 then
               E := -99;
            end if;
            F := @ / Exp10 (E); -- normalize
         end if;
      end if;
      if not Error then
         -- sign
         Buffer_Idx := 1;
         Buffer (Buffer_Idx) := S;
         -- significand
         Buffer_Idx := @ + 1;
         while True loop
            if M = -1 then
               Buffer (Buffer_Idx) := '.';
               Buffer_Idx := @ + 1;
            end if;
            W := Exp10 (M); -- highest digit
            D := Decimal_Digit_Type (Float'Floor (F / W));
            Buffer (Buffer_Idx) := To_Ch (D);
            Buffer_Idx := @ + 1;
            F := @ - Float (D) * W;
            M := @ - 1;
            exit when M < -Precision;
         end loop;
         -- exponent
         Buffer (Buffer_Idx) := 'E';
         Buffer_Idx := @ + 1;
         if E < 0 then
            E := -@;
            Buffer (Buffer_Idx) := '-';
         else
            Buffer (Buffer_Idx) := '+';
         end if;
         Buffer_Idx := @ + 1;
         Buffer (Buffer_Idx) := To_Ch (E / 10);
         Buffer_Idx := @ + 1;
         Buffer (Buffer_Idx) := To_Ch (E rem 10);
      end if;
      -- print
      if Prefix'Length /= 0 then
         Print (Prefix);
      end if;
      Print (Buffer (1 .. Buffer_Idx), NL => False);
      if Suffix'Length /= 0 then
         Print (Suffix);
      end if;
      if NL then
         Print_NewLine;
      end if;
   end Print_Float;

end Floating_Point;

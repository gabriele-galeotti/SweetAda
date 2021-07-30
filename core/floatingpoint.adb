-----------------------------------------------------------------------------------------------------------------------
--                                                     SweetAda                                                      --
-----------------------------------------------------------------------------------------------------------------------
-- __HDS__                                                                                                           --
-- __FLN__ floatingpoint.adb                                                                                         --
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

with Ada.Unchecked_Conversion;
with Bits;
with Console;

package body FloatingPoint is

   --========================================================================--
   --                                                                        --
   --                                                                        --
   --                           Local declarations                           --
   --                                                                        --
   --                                                                        --
   --========================================================================--

   use Bits;

   E           : constant := 8;                          -- # of bits
   M           : constant := 24;                         -- # of bits, plus hidden bit
   E_Mask      : constant Unsigned_32 := 2**E - 1;
   Sticky_Mask : constant Unsigned_32 := 2**(E - 1) - 1;

   Zero     : constant := 16#0000_0000#;
   Minus1   : constant := 16#BF80_0000#;
   OneTenth : constant := 16#3DCC_CCCD#;
   OneHalf  : constant := 16#3F00_0000#;
   One      : constant := 16#3F80_0000#;
   Two      : constant := 16#4000_0000#;
   Ten      : constant := 16#4120_0000#;

   function To_U32 (Value : Boolean) return Unsigned_32 with
      Inline => True;
   procedure Unpack (Value : in Unsigned_32; Exponent : out Integer_32; Mantissa : out Unsigned_32);
   procedure RoundAndPack (Exponent : in Integer_32; Mantissa : in Unsigned_32; R : out Unsigned_32);

   --========================================================================--
   --                                                                        --
   --                                                                        --
   --                           Package subprograms                          --
   --                                                                        --
   --                                                                        --
   --========================================================================--

   ----------------------------------------------------------------------------
   -- To_U32
   ----------------------------------------------------------------------------
   function To_U32 (Value : Boolean) return Unsigned_32 is
   begin
      if Value then
         return 1;
      else
         return 0;
      end if;
   end To_U32;

   ----------------------------------------------------------------------------
   -- Unpack
   ----------------------------------------------------------------------------
   procedure Unpack (Value : in Unsigned_32; Exponent : out Integer_32; Mantissa : out Unsigned_32) is
   begin
      Exponent := Signed (ShRA (Value, M - 1));
      Mantissa := ShL (Value and (ShL (1, M - 1) - 1), E);
   end Unpack;

   ----------------------------------------------------------------------------
   -- RoundAndPack
   ----------------------------------------------------------------------------
   procedure RoundAndPack (Exponent : in Integer_32; Mantissa : in Unsigned_32; R : out Unsigned_32) is
      T : Unsigned_32;
   begin
      R := ShL (Unsigned (Exponent), M - 1) or ShR (Mantissa, E);
      T := (ShR (Mantissa, E - 1) and 1) and
              ((Mantissa and To_U32 (Mantissa /= 0)) or (ShR (Mantissa, E) and 1));
      R := R + T;
   end RoundAndPack;

   ----------------------------------------------------------------------------
   -- AddSF3
   ----------------------------------------------------------------------------
   function AddSF3 (A : in FP_Type; B : FP_Type) return FP_Type is
      Ae : Integer_32;
      Am : Unsigned_32;
      Be : Integer_32;
      Bm : Unsigned_32;
      Te : Integer_32;
      R  : FP_Type;
      Re : Integer_32;
      Rm : Unsigned_32;
   begin

      Unpack (A, Ae, Am);
--      Console.Print (Unsigned (Ae), Prefix => "Exponent: ", NL => True);
--      Console.Print (Am, Prefix => "Mantissa: ", NL => True);
      Unpack (B, Be, Bm);
--      Console.Print (Unsigned (Be), Prefix => "Exponent: ", NL => True);
--      Console.Print (Bm, Prefix => "Mantissa: ", NL => True);

      if Signed (Unsigned (Ae) xor Unsigned (Be)) >= 0 then
         ----------------------------------------------------------------------
         -- ADDITION
         ----------------------------------------------------------------------
         -- subtract the exponents; they are both biased, so their difference reflects the true, unbiased difference
         Te := Ae - Be;
         if    Te > 0 then
            -- A > B
            Re := Ae;
            if (Unsigned (Be) and E_Mask) = 0 then
               -- B is 0 or denormalized
               if Bm = 0 then
                  return A; -- A + 0
               else
                  Te := Te - 1;
               end if;
            end if;
         elsif Te < 0 then
            -- A < B
            null;
         else
            -- A and B have the same exponent
            if (Unsigned (Ae + 1) and E_Mask) <= 1 then -- or Be, since they are equal
               -- U and V are zero or denormalized
               if    Am = 0 then
                  return B; -- (+0)+(+0), (+0)+(+D), (-0)+(-0), (-0)+(-D)
               -- U is denormalized, V is zero or denormalized
               elsif Bm = 0 then
                  return A; -- (+D)+(+0), (-D)+(-0)
               else
               -- (+D)+(+D), (-D)+(-D)
                  Rm := Am + Bm;
                  -- __FIX__ __TBD__
               end if;
            end if;
            -- the implicit most significant bits of A and B make it necessary
            -- to always shift back the result of the addition below
            Rm := Am + Bm;
            Rm := ShR (Rm, 1);
            Re := Ae + 1;
            if ((not Unsigned (Re)) and E_Mask) = 0 then
               Rm := 0; -- too large result, R = Inf
            end if;
         end if;
      else
         ----------------------------------------------------------------------
         -- SUBTRACTION
         ----------------------------------------------------------------------
         null;
      end if;

      RoundAndPack (Re, Rm, R);
      return R;

   end AddSF3;

end FloatingPoint;

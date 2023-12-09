-----------------------------------------------------------------------------------------------------------------------
--                                                     SweetAda                                                      --
-----------------------------------------------------------------------------------------------------------------------
-- __HDS__                                                                                                           --
-- __FLN__ integer_math.ads                                                                                          --
-- __DSC__                                                                                                           --
-- __HSH__ e69de29bb2d1d6434b8b29ae775ad8c2e48c5391                                                                  --
-- __HDE__                                                                                                           --
-----------------------------------------------------------------------------------------------------------------------
-- Copyright (C) 2020-2023 Gabriele Galeotti                                                                         --
--                                                                                                                   --
-- SweetAda web page: http://sweetada.org                                                                            --
-- contact address: gabriele.galeotti@sweetada.org                                                                   --
-- This work is licensed under the terms of the MIT License.                                                         --
-- Please consult the LICENSE.txt file located in the top-level directory.                                           --
-----------------------------------------------------------------------------------------------------------------------

package Integer_Math is

   --========================================================================--
   --                                                                        --
   --                                                                        --
   --                               Public part                              --
   --                                                                        --
   --                                                                        --
   --========================================================================--

   pragma Pure;

   subtype Log_Integer is Integer range 0 .. Integer'Size;

   ----------------------------------------------------------------------------
   -- GCD - Greatest Common Divisor
   ----------------------------------------------------------------------------
   function GCD
      (Value1 : Integer;
       Value2 : Integer)
      return Natural;

   ----------------------------------------------------------------------------
   -- LCM - Least Common Multiple
   ----------------------------------------------------------------------------
   function LCM
      (Value1 : Integer;
       Value2 : Integer)
      return Natural;

   ----------------------------------------------------------------------------
   -- Log2 - compute log2(x)
   ----------------------------------------------------------------------------
   function Log2
      (Value : Positive)
      return Log_Integer;

   ----------------------------------------------------------------------------
   -- Roundup - round up x modulo m
   ----------------------------------------------------------------------------
   function Roundup
      (Value  : Natural;
       Modulo : Positive)
      return Natural;

   ----------------------------------------------------------------------------
   -- Rounddown - round down up x modulo m
   ----------------------------------------------------------------------------
   function Rounddown
      (Value  : Natural;
       Modulo : Positive)
      return Natural;

end Integer_Math;

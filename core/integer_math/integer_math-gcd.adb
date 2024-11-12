-----------------------------------------------------------------------------------------------------------------------
--                                                     SweetAda                                                      --
-----------------------------------------------------------------------------------------------------------------------
-- __HDS__                                                                                                           --
-- __FLN__ integer_math-gcd.adb                                                                                      --
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

separate (Integer_Math)
function GCD
   (Value1 : Integer;
    Value2 : Integer)
   return Natural
   is
   V1 : Natural := abs (Value1);
   V2 : Natural := abs (Value2);
   T  : Natural;
begin
   if V2 > V1 then
      T := V1;
      V1 := V2;
      V2 := T;
   end if;
   while V2 /= 0 loop
      T := V2;
      V2 := V1 mod @;
      V1 := T;
   end loop;
   return V1;
end GCD;

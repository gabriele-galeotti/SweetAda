-----------------------------------------------------------------------------------------------------------------------
--                                                     SweetAda                                                      --
-----------------------------------------------------------------------------------------------------------------------
-- __HDS__                                                                                                           --
-- __FLN__ gcc_types.ads                                                                                             --
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

with System;
with Interfaces;

package GCC_Types
   with Pure       => True,
        SPARK_Mode => On
   is

   --========================================================================--
   --                                                                        --
   --                                                                        --
   --                               Public part                              --
   --                                                                        --
   --                                                                        --
   --========================================================================--

   -- 8-bit
   type QI_Type is range -2**((System.Storage_Unit * 1) - 1) ..
                         +2**((System.Storage_Unit * 1) - 1) - 1
      with Alignment => Interfaces.Integer_8'Alignment,
           Size      => System.Storage_Unit * 1;
   type UQI_Type is mod 2**(System.Storage_Unit * 1)
      with Alignment => Interfaces.Unsigned_8'Alignment,
           Size      => System.Storage_Unit * 1;
   -- 16-bit
   type HI_Type is range -2**((System.Storage_Unit * 2) - 1) ..
                         +2**((System.Storage_Unit * 2) - 1) - 1
      with Alignment => Interfaces.Integer_16'Alignment,
           Size      => System.Storage_Unit * 2;
   type UHI_Type is mod 2**(System.Storage_Unit * 2)
      with Alignment => Interfaces.Unsigned_16'Alignment,
           Size      => System.Storage_Unit * 2;
   -- 32-bit
   type SI_Type is range -2**((System.Storage_Unit * 4) - 1) ..
                         +2**((System.Storage_Unit * 4) - 1) - 1
      with Alignment => Interfaces.Integer_32'Alignment,
           Size      => System.Storage_Unit * 4;
   type USI_Type is mod 2**(System.Storage_Unit * 4)
      with Alignment => Interfaces.Unsigned_32'Alignment,
           Size      => System.Storage_Unit * 4;
   -- 64-bit
   type DI_Type is range -2**((System.Storage_Unit * 8) - 1) ..
                         +2**((System.Storage_Unit * 8) - 1) - 1
      with Alignment => Interfaces.Integer_64'Alignment,
           Size      => System.Storage_Unit * 8;
   type UDI_Type is mod 2**(System.Storage_Unit * 8)
      with Alignment => Interfaces.Unsigned_64'Alignment,
           Size      => System.Storage_Unit * 8;
   -- 128-bit
   type TI_Type is new Interfaces.Integer_128;
   type UTI_Type is new Interfaces.Unsigned_128;

   function Shift_Left
      (Value  : USI_Type;
       Amount : Natural)
      return USI_Type
      with Import     => True,
           Convention => Intrinsic;
   function Shift_Right
      (Value  : USI_Type;
       Amount : Natural)
      return USI_Type
      with Import     => True,
           Convention => Intrinsic;

   function Shift_Left
      (Value  : UDI_Type;
       Amount : Natural)
      return UDI_Type
      with Import     => True,
           Convention => Intrinsic;
   function Shift_Right
      (Value  : UDI_Type;
       Amount : Natural)
      return UDI_Type
      with Import     => True,
           Convention => Intrinsic;

end GCC_Types;

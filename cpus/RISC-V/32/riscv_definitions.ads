-----------------------------------------------------------------------------------------------------------------------
--                                                     SweetAda                                                      --
-----------------------------------------------------------------------------------------------------------------------
-- __HDS__                                                                                                           --
-- __FLN__ riscv_definitions.ads                                                                                     --
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

with Interfaces;
with Bits;

package RISCV_Definitions is

   --========================================================================--
   --                                                                        --
   --                                                                        --
   --                               Public part                              --
   --                                                                        --
   --                                                                        --
   --========================================================================--

   pragma Pure;

   use Interfaces;
   use Bits;

   XLEN : constant := 32;

   type mtime_Type is
   record
      L : Unsigned_32 with Volatile_Full_Access => True;
      H : Unsigned_32 with Volatile_Full_Access => True;
   end record with
      Size => 64;
   for mtime_Type use
   record
      L at BE_ByteOrder * 4 + LE_ByteOrder * 0 range 0 .. 31;
      H at BE_ByteOrder * 0 + LE_ByteOrder * 4 range 0 .. 31;
   end record;

end RISCV_Definitions;

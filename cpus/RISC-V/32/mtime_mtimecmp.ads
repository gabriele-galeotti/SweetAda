-----------------------------------------------------------------------------------------------------------------------
--                                                     SweetAda                                                      --
-----------------------------------------------------------------------------------------------------------------------
-- __HDS__                                                                                                           --
-- __FLN__ mtime_mtimecmp.ads                                                                                        --
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

with System;
with System.Storage_Elements;
with Interfaces;
with Bits;
with RISCV_Definitions;

package MTime_MTimeCmp is

   --========================================================================--
   --                                                                        --
   --                                                                        --
   --                               Public part                              --
   --                                                                        --
   --                                                                        --
   --========================================================================--

   pragma Preelaborate;

   use System;
   use System.Storage_Elements;
   use Interfaces;
   use Bits;
   use RISCV_Definitions;

   ----------------------------------------------------------------------------
   -- Timer CSRs
   ----------------------------------------------------------------------------

   type MTime_Type is
   record
      L : Unsigned_32 with Volatile_Full_Access => True;
      H : Unsigned_32 with Volatile_Full_Access => True;
   end record with
      Size => 64;
   for MTime_Type use
   record
      L at BE_ByteOrder * 4 + LE_ByteOrder * 0 range 0 .. 31;
      H at BE_ByteOrder * 0 + LE_ByteOrder * 4 range 0 .. 31;
   end record;

   MTime : MTime_Type with
      Address    => To_Address (MTIME_ADDRESS),
      Volatile   => True,
      Import     => True,
      Convention => Ada;

   MTimeCmp : MTime_Type with
      Address    => To_Address (MTIMECMP_ADDRESS),
      Volatile   => True,
      Import     => True,
      Convention => Ada;

   function MTIME_Read return Unsigned_64;
   procedure MTIMECMP_Write (Value : in Unsigned_64);

end MTime_MTimeCmp;

-----------------------------------------------------------------------------------------------------------------------
--                                                     SweetAda                                                      --
-----------------------------------------------------------------------------------------------------------------------
-- __HDS__                                                                                                           --
-- __FLN__ cortexm4.ads                                                                                              --
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

with System;
with System.Storage_Elements;
with Interfaces;
with Bits;
with ARMv7M;

package CortexM4 is

   --========================================================================--
   --                                                                        --
   --                                                                        --
   --                               Public part                              --
   --                                                                        --
   --                                                                        --
   --========================================================================--

   use System;
   use System.Storage_Elements;
   use Interfaces;
   use Bits;

   -- Auxiliary Control Register

   ACTLR_ADDRESS renames ARMv7M.ACTLR_ADDRESS;

   type ACTLR_Type is
   record
      DISMCYCINT : Boolean;      -- Disables interruption of multi-cycle instructions.
      DISDEFWBUF : Boolean;      -- Disables write buffer use during default memory map accesses.
      DISFOLD    : Boolean;      -- Disables folding of IT instructions.
      Reserved1  : Bits_5 := 0;
      DISFPCA    : Boolean;      -- SBZP.
      DISOOFP    : Boolean;      -- Disables FP instructions completing out of order with respect to integer instructions.
      Reserved2  : Bits_22 := 0;
   end record with
      Bit_Order => Low_Order_First,
      Size      => 32;
   for ACTLR_Type use
   record
      DISMCYCINT at 0 range 0 .. 0;
      DISDEFWBUF at 0 range 1 .. 1;
      DISFOLD    at 0 range 2 .. 2;
      Reserved1  at 0 range 3 .. 7;
      DISFPCA    at 0 range 8 .. 8;
      DISOOFP    at 0 range 9 .. 9;
      Reserved2  at 0 range 10 .. 31;
   end record;

   ACTLR : aliased ACTLR_Type with
      Address              => To_Address (ACTLR_ADDRESS),
      Volatile_Full_Access => True,
      Import               => True,
      Convention           => Ada;

end CortexM4;

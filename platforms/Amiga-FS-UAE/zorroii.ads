-----------------------------------------------------------------------------------------------------------------------
--                                                     SweetAda                                                      --
-----------------------------------------------------------------------------------------------------------------------
-- __HDS__                                                                                                           --
-- __FLN__ zorroii.ads                                                                                               --
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

with System;
with System.Storage_Elements;
with Interfaces;
with Bits;

package ZorroII is

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

   CFGSPACE_BASEADDRESS : constant := 16#00E8_0000#;

   -- configuration space = 64k (32k 16-bit words)
   Cfg_Space : aliased U16_Array (0 .. 2**15 - 1) with
      Address    => To_Address (CFGSPACE_BASEADDRESS),
      Volatile   => True,
      Import     => True,
      Convention => Ada;

   type PIC_Type is
   record
     Board           : Unsigned_8;
     ID_Product      : Unsigned_8;
     ID_Manufacturer : Unsigned_16;
   end record;

   function Signature_Read (Offset : Storage_Offset) return Unsigned_8 with
      Inline => True;

   function Read return PIC_Type;

end ZorroII;

-----------------------------------------------------------------------------------------------------------------------
--                                                     SweetAda                                                      --
-----------------------------------------------------------------------------------------------------------------------
-- __HDS__                                                                                                           --
-- __FLN__ zorroii.adb                                                                                               --
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
with MMIO;

package body ZorroII is

   --========================================================================--
   --                                                                        --
   --                                                                        --
   --                           Package subprograms                          --
   --                                                                        --
   --                                                                        --
   --========================================================================--

   ----------------------------------------------------------------------------
   -- Signature_Read
   ----------------------------------------------------------------------------
   function Signature_Read (Offset : Storage_Offset) return Unsigned_8 is
      Value : Unsigned_8;
   begin
      Value := (MMIO.Read (Cfg_Space'Address + Offset)          and 16#F0#) or
               (MMIO.Read (Cfg_Space'Address + Offset + 16#02#) and 16#F0#) / 2**4;
      if Offset /= 16#00# and then Offset /= 16#40# then
         Value := not @;
      end if;
      return Value;
   end Signature_Read;

   ----------------------------------------------------------------------------
   -- Read
   ----------------------------------------------------------------------------
   function Read return PIC_Type is
      PIC : PIC_Type;
   begin
      PIC.Board           := Signature_Read (16#00#);
      PIC.ID_Product      := Signature_Read (16#04#);
      PIC.ID_Manufacturer := Bits.Make_Word (Signature_Read (16#10#), Signature_Read (16#14#));
      return PIC;
   end Read;

end ZorroII;

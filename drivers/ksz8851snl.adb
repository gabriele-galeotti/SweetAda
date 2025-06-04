-----------------------------------------------------------------------------------------------------------------------
--                                                     SweetAda                                                      --
-----------------------------------------------------------------------------------------------------------------------
-- __HDS__                                                                                                           --
-- __FLN__ ksz8851snl.adb                                                                                            --
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

with Ada.Unchecked_Conversion;

package body KSZ8851SNL
   is

   --========================================================================--
   --                                                                        --
   --                                                                        --
   --                           Local declarations                           --
   --                                                                        --
   --                                                                        --
   --========================================================================--

   function To_B16 is new Ada.Unchecked_Conversion (Command_IntRegs_Type, Bits_16);

   function To_RegAddress
      (Register_Address : Unsigned_8)
      return Bits_6
      with Inline => True;

   --========================================================================--
   --                                                                        --
   --                                                                        --
   --                           Package subprograms                          --
   --                                                                        --
   --                                                                        --
   --========================================================================--

   function To_RegAddress
      (Register_Address : Unsigned_8)
      return Bits_6
      is
   begin
      return Bits_6 (Shift_Right (Register_Address, 2));
   end To_RegAddress;

   ----------------------------------------------------------------------------
   -- Command_Create
   ----------------------------------------------------------------------------
   function Command_Create
      (Register    : Unsigned_8;
       Byte_Enable : Byte_Enable_Type;
       Opcode      : Opcode_Type)
      return Bits_16
      is
   begin
      return To_B16 (Command_IntRegs_Type'(
         Register_Address => To_RegAddress (Register),
         Byte_Enable      => Byte_Enable,
         Opcode           => Opcode,
         others           => <>
         ));
   end Command_Create;

end KSZ8851SNL;

-----------------------------------------------------------------------------------------------------------------------
--                                                     SweetAda                                                      --
-----------------------------------------------------------------------------------------------------------------------
-- __HDS__                                                                                                           --
-- __FLN__ ksz8851snl.adb                                                                                            --
-- __DSC__                                                                                                           --
-- __HSH__ e69de29bb2d1d6434b8b29ae775ad8c2e48c5391                                                                  --
-- __HDE__                                                                                                           --
-----------------------------------------------------------------------------------------------------------------------
-- Copyright (C) 2020-2026 Gabriele Galeotti                                                                         --
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
   --                           Package subprograms                          --
   --                                                                        --
   --                                                                        --
   --========================================================================--

   ----------------------------------------------------------------------------
   -- Command_REGISTERS
   ----------------------------------------------------------------------------
   function Command_REGISTERS
      (Opcode      : OPCODE_REGS_Type;
       Register    : Unsigned_8;
       Byte_Enable : BYTE_ENABLE_Type)
      return Bits_16
      is
      function To_B16 is new Ada.Unchecked_Conversion (Command_REGISTERS_Type, Bits_16);
   begin
      return To_B16 (Command_REGISTERS_Type'(
         Opcode           => Opcode,
         Register_Address => Bits_6 (Shift_Right (Register, 2)),
         Byte_Enable      => Byte_Enable,
         others           => <>
         ));
   end Command_REGISTERS;

   ----------------------------------------------------------------------------
   -- Command_TXQRXQ
   ----------------------------------------------------------------------------
   function Command_TXQRXQ
      (Opcode : OPCODE_FIFO_Type)
      return Bits_16
      is
      function To_B16 is new Ada.Unchecked_Conversion (Command_TXQRXQ_Type, Bits_16);
   begin
      return To_B16 (Command_TXQRXQ_Type'(Opcode => Opcode, others => <>));
   end Command_TXQRXQ;

end KSZ8851SNL;

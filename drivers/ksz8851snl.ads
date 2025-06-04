-----------------------------------------------------------------------------------------------------------------------
--                                                     SweetAda                                                      --
-----------------------------------------------------------------------------------------------------------------------
-- __HDS__                                                                                                           --
-- __FLN__ ksz8851snl.ads                                                                                            --
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
with Bits;

package KSZ8851SNL
   is

   --========================================================================--
   --                                                                        --
   --                                                                        --
   --                               Public part                              --
   --                                                                        --
   --                                                                        --
   --========================================================================--

   use System;
   use Interfaces;
   use Bits;

pragma Style_Checks (Off);

   ----------------------------------------------------------------------------
   -- KSZ8851SNL/SNLI
   -- DS00002381B
   ----------------------------------------------------------------------------

   -- 4.1.1 I/O REGISTERS

   CIDER : constant := 16#C0#;

   type Opcode_Type is new Bits_2;
   Opcode_RegRead  : constant Opcode_Type := 2#00#; -- Internal I/O Register Read
   Opcode_RegWrite : constant Opcode_Type := 2#01#; -- Internal I/O Register Write
   Opcode_RXQFIFO  : constant Opcode_Type := 2#10#; -- RXQ FIFO Read
   Opcode_TXQFIFO  : constant Opcode_Type := 2#11#; -- TXQ FIFO Write

   -- 3.4 Serial Peripheral Interface (SPI)

   type Byte_Enable_Idx is (BYTE0, BYTE1, BYTE2, BYTE3);
   type Byte_Enable_Type is array (Byte_Enable_Idx) of Boolean
      with Pack => True;

   type Command_IntRegs_Type is record
      DONTCARE         : Bits_4           := 0;
      Register_Address : Bits_6           := 0;                -- Register Address
      Byte_Enable      : Byte_Enable_Type := [others => True]; -- Byte Enable
      Opcode           : Opcode_Type      := Opcode_RegRead;   -- Opcode
   end record
      with Bit_Order => Low_Order_First,
           Size      => 16;
   for Command_IntRegs_Type use record
      DONTCARE         at 0 range  0 ..  3;
      Register_Address at 0 range  4 ..  9;
      Byte_Enable      at 0 range 10 .. 13;
      Opcode           at 0 range 14 .. 15;
   end record;

   type Command_TXQRXQ_Type is record
      DONTCARE : Bits_6      := 0;
      Opcode   : Opcode_Type := Opcode_RXQFIFO; -- Opcode
   end record
      with Bit_Order => Low_Order_First,
           Size      => 8;
   for Command_TXQRXQ_Type use record
      DONTCARE at 0 range 0 .. 5;
      Opcode   at 0 range 6 .. 7;
   end record;

   function Command_Create
      (Register    : Unsigned_8;
       Byte_Enable : Byte_Enable_Type;
       Opcode      : Opcode_Type)
      return Bits_16;

pragma Style_Checks (On);

end KSZ8851SNL;

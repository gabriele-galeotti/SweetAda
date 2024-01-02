-----------------------------------------------------------------------------------------------------------------------
--                                                     SweetAda                                                      --
-----------------------------------------------------------------------------------------------------------------------
-- __HDS__                                                                                                           --
-- __FLN__ zorroii.adb                                                                                               --
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

with Ada.Unchecked_Conversion;
with Bits;
with MMIO;

package body ZorroII is

   --========================================================================--
   --                                                                        --
   --                                                                        --
   --                           Local declarations                           --
   --                                                                        --
   --                                                                        --
   --========================================================================--

   CFGSPACE_BASEADDRESS : constant := 16#00E8_0000#;

   -- configuration space = 64k (32k 16-bit words)
   Cfg_Space : aliased Bits.U16_Array (0 .. 2**15 - 1) with
      Address    => To_Address (CFGSPACE_BASEADDRESS),
      Volatile   => True,
      Import     => True,
      Convention => Ada;

   function Byte_Read (Offset : Storage_Offset) return Unsigned_8;

   --========================================================================--
   --                                                                        --
   --                                                                        --
   --                           Package subprograms                          --
   --                                                                        --
   --                                                                        --
   --========================================================================--

   ----------------------------------------------------------------------------
   -- Byte_Read
   ----------------------------------------------------------------------------
   function Byte_Read (Offset : Storage_Offset) return Unsigned_8 is
      Value : Unsigned_8;
   begin
      Value := (MMIO.Read (Cfg_Space'Address + Offset)          and 16#F0#) or
               (MMIO.Read (Cfg_Space'Address + Offset + 16#02#) and 16#F0#) / 2**4;
      if Offset /= 16#00# and then Offset /= 16#40# then
         Value := not @;
      end if;
      return Value;
   end Byte_Read;

   ----------------------------------------------------------------------------
   -- Read
   ----------------------------------------------------------------------------
   function Read return PIC_Type is
      PIC : PIC_Type;
   begin
      PIC.Board           := Byte_Read (16#00#);
      PIC.ID_Product      := Byte_Read (16#04#);
      PIC.ID_Manufacturer := Bits.Make_Word (Byte_Read (16#10#), Byte_Read (16#14#));
      PIC.Serial_Number   := Bits.Make_Word (
                                             Byte_Read (16#18#),
                                             Byte_Read (16#1C#),
                                             Byte_Read (16#20#),
                                             Byte_Read (16#24#)
                                            );
      PIC.Control_Status  := Byte_Read (16#40#);
      return PIC;
   end Read;

   ----------------------------------------------------------------------------
   -- Setup
   ----------------------------------------------------------------------------
   procedure Setup (Base_Address : in Integer_Address) is
      E_Byte : Unsigned_8;
      function To_U32 is new Ada.Unchecked_Conversion (Integer_Address, Unsigned_32);
   begin
      E_Byte := Bits.NByte (To_U32 (Base_Address));
      MMIO.Write (Cfg_Space'Address + 16#4A#, Shift_Left (E_Byte, 4));
      MMIO.Write (Cfg_Space'Address + 16#48#, E_Byte);
   end Setup;

   ----------------------------------------------------------------------------
   -- Shutup
   ----------------------------------------------------------------------------
   procedure Shutup is
   begin
      MMIO.Write (Cfg_Space'Address + 16#4C#, Unsigned_8'(0));
   end Shutup;

end ZorroII;

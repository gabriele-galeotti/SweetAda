-----------------------------------------------------------------------------------------------------------------------
--                                                     SweetAda                                                      --
-----------------------------------------------------------------------------------------------------------------------
-- __HDS__                                                                                                           --
-- __FLN__ gt64120.adb                                                                                               --
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

with MMIO;

package body GT64120
   is

   --========================================================================--
   --                                                                        --
   --                                                                        --
   --                           Package subprograms                          --
   --                                                                        --
   --                                                                        --
   --========================================================================--

   ----------------------------------------------------------------------------
   -- CPU Interface Configuration Read/Write
   ----------------------------------------------------------------------------

   procedure CPUIC_Read
      (A     : in     Address;
       CPUIC :    out CPU_Interface_Configuration_Type)
      is
   begin
      if Bits.BigEndian then
         CPUIC := To_CPUIC (MMIO.ReadAS (A));
      else
         CPUIC := To_CPUIC (MMIO.ReadA (A));
      end if;
   end CPUIC_Read;

   procedure CPUIC_Write
      (A     : in Address;
       CPUIC : in CPU_Interface_Configuration_Type)
      is
   begin
      if Bits.BigEndian then
         MMIO.WriteAS (A, To_U32 (CPUIC));
      else
         MMIO.WriteA (A, To_U32 (CPUIC));
      end if;
   end CPUIC_Write;

   ----------------------------------------------------------------------------
   -- Make_PCILD
   ----------------------------------------------------------------------------
   function Make_PCILD
      (Start_Address : Unsigned_64)
      return PCI_Low_Decode_Address_Type
      is
      PCILD : PCI_Low_Decode_Address_Type;
   begin
      PCILD.Low  := Bits_15 (Shift_Right (Start_Address, 21));
      if Bits.BigEndian then
         return To_PCILD (Byte_Swap (To_U32 (PCILD)));
      else
         return PCILD;
      end if;
   end Make_PCILD;

   ----------------------------------------------------------------------------
   -- Make_PCIHD
   ----------------------------------------------------------------------------
   function Make_PCIHD
      (Start_Address : Unsigned_64;
       Size          : Unsigned_64)
      return PCI_High_Decode_Address_Type
      is
      PCIHD : PCI_High_Decode_Address_Type;
   begin
      PCIHD.High := Bits_7 (Shift_Right (Start_Address + Size - 1, 21) and 16#7F#);
      if Bits.BigEndian then
         return To_PCIHD (Byte_Swap (To_U32 (PCIHD)));
      else
         return PCIHD;
      end if;
   end Make_PCIHD;

end GT64120;

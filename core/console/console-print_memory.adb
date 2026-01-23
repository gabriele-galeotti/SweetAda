-----------------------------------------------------------------------------------------------------------------------
--                                                     SweetAda                                                      --
-----------------------------------------------------------------------------------------------------------------------
-- __HDS__                                                                                                           --
-- __FLN__ console-print_memory.adb                                                                                  --
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

separate (Console)
procedure Print_Memory
   (Start_Address : in System.Address;
    Data_Size     : in Bits.Bytesize;
    Row_Size      : in Row_Size_Type := 16)
   is
   IAddress   : SSE.Integer_Address;
   IAddress_H : SSE.Integer_Address; -- row starting address
   IAddress_L : SSE.Integer_Address; -- byte offset in a row
   NBytes     : Bits.Bytesize;
   Item_Count : Natural;
   NBytes_Row : Bits.Bytesize;
   ASCII_Syms : String (1 .. Integer (Row_Size_Type'Last));
begin
   IAddress   := SSE.To_Integer (Start_Address);
   IAddress_L := IAddress mod SSE.Integer_Address (Row_Size);
   IAddress_H := IAddress - IAddress_L;
   NBytes     := Data_Size;
   loop
      Print (IAddress_H, Suffix => ":");
      Item_Count := 0;
      -- compute maximum # of bytes to print in this row
      NBytes_Row := Bits.Bytesize (Row_Size) - Bits.Bytesize (IAddress_L);
      -- clamp to (possibly 0) upper limit
      if NBytes_Row > NBytes then
         NBytes_Row := NBytes;
      end if;
      -- pad with spaces until start of data
      while Item_Count < Natural (IAddress_L) loop
         Item_Count := @ + 1;
         Print ("   ");
         ASCII_Syms (Item_Count) := ' ';
      end loop;
      -- print a sequence of bytes
      for Byte_Offset in IAddress_L .. IAddress_L + SSE.Integer_Address (NBytes_Row) - 1 loop
         declare
            Byte : Interfaces.Unsigned_8
               with Address  => SSE.To_Address (IAddress_H + Byte_Offset);
         begin
            Item_Count := @ + 1;
            Print (Byte, Prefix => " ");
            if Byte in 16#20# .. 16#7F# then
               ASCII_Syms (Item_Count) := Bits.To_Ch (Byte);
            else
               ASCII_Syms (Item_Count) := '.';
            end if;
         end;
      end loop;
      -- pad with spaces until end of row
      while Item_Count < Natural (Row_Size) loop
         Item_Count := @ + 1;
         Print ("   ");
         ASCII_Syms (Item_Count) := ' ';
      end loop;
      -- print ASCII encoding
      Print ("    ");
      Print (ASCII_Syms (1 .. Item_Count));
      -- close row
      Print_NewLine;
      -- compute address of next block of bytes
      -- IAddress_H := @ + SSE.Integer_Address (Row_Size);
      IAddress_H := IAddress_H + SSE.Integer_Address (Row_Size);
      exit when IAddress_H >= IAddress + SSE.Integer_Address (Data_Size);
      -- update # of bytes remaining
      NBytes := @ - NBytes_Row;
      -- re-start at offset 0
      IAddress_L := 0;
   end loop;
end Print_Memory;

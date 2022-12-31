-----------------------------------------------------------------------------------------------------------------------
--                                                     SweetAda                                                      --
-----------------------------------------------------------------------------------------------------------------------
-- __HDS__                                                                                                           --
-- __FLN__ mbr.adb                                                                                                   --
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

with System.Storage_Elements;
with Bits;
with Memory_Functions;

package body MBR is

   --========================================================================--
   --                                                                        --
   --                                                                        --
   --                           Local declarations                           --
   --                                                                        --
   --                                                                        --
   --========================================================================--

   use System.Storage_Elements;
   use Bits;

   ----------------------------------------------------------------------------
   -- filesystem I/O
   ----------------------------------------------------------------------------

   type Block_IO_Descriptor_Type is
   record
      Read  : IO_Read_Ptr;  -- block read procedure
      -- Write : IO_Write_Ptr; -- block write procedure
   end record;

   IO_Context : Block_IO_Descriptor_Type := (Read => null);

   --========================================================================--
   --                                                                        --
   --                                                                        --
   --                           Package subprograms                          --
   --                                                                        --
   --                                                                        --
   --========================================================================--

   ----------------------------------------------------------------------------
   -- Init
   ----------------------------------------------------------------------------
   procedure Init (Block_Read : IO_Read_Ptr) is
   begin
      IO_Context.Read := Block_Read;
   end Init;

   ----------------------------------------------------------------------------
   -- Read
   ----------------------------------------------------------------------------
   procedure Read (
                   Partition_Number : in  Partition_Number_Type;
                   Partition        : out Partition_Entry_Type;
                   Success          : out Boolean
                  ) is
      Block  : aliased Block_Type (0 .. 16#01FF#);
      Offset : Storage_Offset;
   begin
      IO_Context.Read (0, Block, Success);
      if Success then
         if Block (16#01FE# .. 16#01FF#) = (16#55#, 16#AA#) then
            case Partition_Number is
               when PARTITION1 => Offset := 16#01BE#;
               when PARTITION2 => Offset := 16#01CE#;
               when PARTITION3 => Offset := 16#01DE#;
               when PARTITION4 => Offset := 16#01EE#;
            end case;
            -- explicit assignment could cause misaligned access (e.g., MIPS)
            Memory_Functions.Cpymem (
                                     Block'Address + Offset,
                                     Partition'Address,
                                     PARTITION_ENTRY_SIZE
                                    );
            if BigEndian then
               Partition.LBA_Start := Byte_Swap_32 (Partition.LBA_Start);
               Partition.LBA_Size  := Byte_Swap_32 (Partition.LBA_Size);
            end if;
         else
            Success := False;
         end if;
      end if;
   end Read;

end MBR;

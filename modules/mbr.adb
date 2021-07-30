-----------------------------------------------------------------------------------------------------------------------
--                                                     SweetAda                                                      --
-----------------------------------------------------------------------------------------------------------------------
-- __HDS__                                                                                                           --
-- __FLN__ mbr.adb                                                                                                   --
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

with System.Storage_Elements;
with Bits;
with LLutils;
with Memory_Functions;
with IDE;

package body MBR is

   --========================================================================--
   --                                                                        --
   --                                                                        --
   --                           Local declarations                           --
   --                                                                        --
   --                                                                        --
   --========================================================================--

   use System.Storage_Elements;
   use Interfaces;
   use Bits;
   use LLutils;

   ----------------------------------------------------------------------------
   -- filesystem I/O
   ----------------------------------------------------------------------------

   type Block_IO_Descriptor_Type is
   record
      Read  : BlockDevices.IO_Read_Ptr;  -- block read procedure
      Write : BlockDevices.IO_Write_Ptr; -- block write procedure
   end record;

   IO_Context : Block_IO_Descriptor_Type := (null, null);

   --========================================================================--
   --                                                                        --
   --                                                                        --
   --                           Package subprograms                          --
   --                                                                        --
   --                                                                        --
   --========================================================================--

   ----------------------------------------------------------------------------
   -- Initialize
   ----------------------------------------------------------------------------
   procedure Initialize is
   begin
      -- defaults to IDE
      IO_Context.Read := IDE.Read'Access;
   end Initialize;

   ----------------------------------------------------------------------------
   -- Read
   ----------------------------------------------------------------------------
   procedure Read (
                   Success          : out Boolean;
                   Partition_Number : in  Partition_Number_Type;
                   Partition        : out Partition_Entry_Type
                  ) is
      B      : aliased BlockDevices.Block_Type (0 .. 511);
      Offset : Storage_Offset;
   begin
      Partition.LBA_Start := 0;
      IO_Context.Read (0, B, Success);
      if Success then
         if B (510) = 16#55# and then B (511) = 16#AA# then
            case Partition_Number is
               when PARTITION1 => Offset := 16#01BE#;
               when PARTITION2 => Offset := 16#01CE#;
               when PARTITION3 => Offset := 16#01DE#;
               when PARTITION4 => Offset := 16#01EE#;
            end case;
            -- explicit assignment could cause misaligned access (e.g., MIPS)
            Memory_Functions.Cpymem (
                                     B'Address + Offset,
                                     Partition'Address,
                                     Partition_ENTRY_SIZE
                                    );
            if BigEndian then
               Byte_Swap_32 (Partition.LBA_Start'Address);
               Byte_Swap_32 (Partition.LBA_Size'Address);
            end if;
            -- DEBUG
            -- Console.Print (P.CHS_First_Sector.CH * 256 + P.CHS_First_Sector.CL, Prefix => "CHS start C: ", NL => True);
            -- Console.Print (P.CHS_First_Sector.H, Prefix => "CHS start H: ", NL => True);
            -- Console.Print (P.CHS_First_Sector.S, Prefix => "CHS start S: ", NL => True);
            -- Console.Print (P.CHS_Last_Sector.CH * 256 + P.CHS_First_Sector.CL, Prefix => "CHS end C: ", NL => True);
            -- Console.Print (P.CHS_Last_Sector.H, Prefix => "CHS end H: ", NL => True);
            -- Console.Print (P.CHS_Last_Sector.S, Prefix => "CHS end S: ", NL => True);
            -- Console.Print (P.LBA_Start, Prefix => "LBA start: ", NL => True);
            -- Console.Print (P.LBA_Size, Prefix => "LBA size: ", NL => True);
         end if;
      end if;
   end Read;

end MBR;

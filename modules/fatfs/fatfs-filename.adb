-----------------------------------------------------------------------------------------------------------------------
--                                                     SweetAda                                                      --
-----------------------------------------------------------------------------------------------------------------------
-- __HDS__                                                                                                           --
-- __FLN__ fatfs-filename.adb                                                                                        --
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

with FATFS.Utilities;

package body FATFS.Filename is

   --========================================================================--
   --                                                                        --
   --                                                                        --
   --                           Package subprograms                          --
   --                                                                        --
   --                                                                        --
   --========================================================================--

   ----------------------------------------------------------------------------
   -- Get_Name
   ----------------------------------------------------------------------------
   -- Return the directory entry filename.
   ----------------------------------------------------------------------------
   procedure Get_Name (DE : in Directory_Entry_Type; FName : out String) is
      FIndex : Integer;
   begin
      FIndex := FName'First;
      -- __FIX__
      -- if Directory.Is_Deleted (DE) then
      --    FName := (others => ' ');
      -- end if;
      for I in DE.Filename'Range loop
         exit when DE.Filename (I) = ' ';
         FName (FIndex) := Utilities.To_Upper (DE.Filename (I));
         FIndex := FIndex + 1;
      end loop;
      if DE.Extension (DE.Extension'First) /= ' ' then
         FName (FIndex) := '.';
         FIndex := FIndex + 1;
         for I in DE.Extension'Range loop
            exit when DE.Extension (I) = ' ';
            FName (FIndex) := Utilities.To_Upper (DE.Extension (I));
            FIndex := FIndex + 1;
         end loop;
      end if;
      if Character'Pos (FName (FName'First)) = 16#05# then
         FName (FName'First) := Character'Val (16#E5#);
      end if;
   end Get_Name;

   ----------------------------------------------------------------------------
   -- Get_Index
   ----------------------------------------------------------------------------
   -- Return the index of the start of the file name without directory.
   ----------------------------------------------------------------------------
   -- function Get_Index (FName : String) return Natural is
   -- begin
   --    for I in reverse FName'Range loop
   --       if Utilities.Is_Separator (FName (I)) then
   --          return I + 1;
   --       end if;
   --    end loop;
   --    return FName'First;
   -- end Get_Index;

   ----------------------------------------------------------------------------
   -- Parse
   ----------------------------------------------------------------------------
   -- Parse a file name in an 8.3 format.
   ----------------------------------------------------------------------------
   procedure Parse (
                    Base    : out String;
                    Ext     : out String;
                    FName   : in  String;
                    Success : out Boolean
                   ) is
      Index : Natural;
   begin
      Base := (others => ' ');
      Ext  := (others => ' ');
      Index := FName'First;
      for I in Base'Range loop
         exit when Index > FName'Last;
         exit when FName (Index) = '.';
         Base (I) := Utilities.To_Upper (FName (Index));
         Index := Index + 1;
      end loop;
      if Index <= FName'Last and then FName (Index) = '.' then
         Index := Index + 1;
         for I in Ext'Range loop
            exit when Index > FName'Last;
            exit when FName (Index) = '.';
            Ext (I) := Utilities.To_Upper (FName (Index));
            Index := Index + 1;
         end loop;
      end if;
      Success := Index = FName'Last + 1;
   end Parse;

end FATFS.Filename;

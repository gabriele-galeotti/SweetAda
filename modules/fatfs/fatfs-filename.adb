-----------------------------------------------------------------------------------------------------------------------
--                                                     SweetAda                                                      --
-----------------------------------------------------------------------------------------------------------------------
-- __HDS__                                                                                                           --
-- __FLN__ fatfs-filename.adb                                                                                        --
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

package body FATFS.Filename
   is

   --========================================================================--
   --                                                                        --
   --                                                                        --
   --                           Local declarations                           --
   --                                                                        --
   --                                                                        --
   --========================================================================--

   ----------------------------------------------------------------------------
   -- To_Upper
   ----------------------------------------------------------------------------
   -- Implemented in order to avoid the use of Ada.Characters.Handling with a
   -- ZFP-style RTS.
   ----------------------------------------------------------------------------
   function To_Upper
      (C : in Character)
      return Character
      with Inline => True;

   --========================================================================--
   --                                                                        --
   --                                                                        --
   --                           Package subprograms                          --
   --                                                                        --
   --                                                                        --
   --========================================================================--

   ----------------------------------------------------------------------------
   -- To_Upper
   ----------------------------------------------------------------------------
   function To_Upper
      (C : in Character)
      return Character
      is
      UCASE2LCASE : constant := Character'Pos ('A') - Character'Pos ('a');
   begin
      if C in 'a' .. 'z' then
         return Character'Val (Character'Pos (C) - UCASE2LCASE);
      else
         return C;
      end if;
   end To_Upper;

   ----------------------------------------------------------------------------
   -- Get
   ----------------------------------------------------------------------------
   procedure Get
      (DE        : in     Directory_Entry_Type;
       File_Name :    out String)
      is
      Index : Natural;
   begin
      Index := File_Name'First;
      -- __FIX__
      -- if Directory.Is_Deleted (DE) then
      --    FName := (others => ' ');
      -- end if;
      for I in DE.File_Name'Range loop
         exit when DE.File_Name (I) = ' ';
         File_Name (Index) := To_Upper (DE.File_Name (I));
         Index := @ + 1;
      end loop;
      if DE.Extension (DE.Extension'First) /= ' ' then
         File_Name (Index) := '.';
         Index := @ + 1;
         for I in DE.Extension'Range loop
            exit when DE.Extension (I) = ' ';
            File_Name (Index) := To_Upper (DE.Extension (I));
            Index := @ + 1;
         end loop;
      end if;
      if Character'Pos (File_Name (File_Name'First)) = 16#05# then
         File_Name (File_Name'First) := Character'Val (16#E5#);
      end if;
   end Get;

   ----------------------------------------------------------------------------
   -- Parse
   ----------------------------------------------------------------------------
   procedure Parse
      (Base      :    out String;
       Ext       :    out String;
       File_Name : in     String;
       Success   :    out Boolean)
      is
      Index : Natural;
   begin
      Base := [others => ' '];
      Ext  := [others => ' '];
      Index := File_Name'First;
      for I in Base'Range loop
         exit when Index > File_Name'Last;
         exit when File_Name (Index) = '.';
         Base (I) := To_Upper (File_Name (Index));
         Index := @ + 1;
      end loop;
      if Index <= File_Name'Last and then File_Name (Index) = '.' then
         Index := @ + 1;
         for I in Ext'Range loop
            exit when Index > File_Name'Last;
            exit when File_Name (Index) = '.';
            Ext (I) := To_Upper (File_Name (Index));
            Index := @ + 1;
         end loop;
      end if;
      Success := Index = File_Name'Last + 1;
   end Parse;

end FATFS.Filename;

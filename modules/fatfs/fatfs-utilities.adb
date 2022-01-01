-----------------------------------------------------------------------------------------------------------------------
--                                                     SweetAda                                                      --
-----------------------------------------------------------------------------------------------------------------------
-- __HDS__                                                                                                           --
-- __FLN__ fatfs-utilities.adb                                                                                       --
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

package body FATFS.Utilities is

   --========================================================================--
   --                                                                        --
   --                                                                        --
   --                           Package subprograms                          --
   --                                                                        --
   --                                                                        --
   --========================================================================--

   ----------------------------------------------------------------------------
   -- Is_Separator
   ----------------------------------------------------------------------------
   -- Return True if C is a pathname separator.
   ----------------------------------------------------------------------------
   function Is_Separator (C : Character) return Boolean is
   begin
      return C = '/' or else C = '\';
   end Is_Separator;

   ----------------------------------------------------------------------------
   -- To_Upper
   ----------------------------------------------------------------------------
   -- Implemented in order to avoid the use of Ada.Characters.Handling with a
   -- ZFP-style RTS.
   ----------------------------------------------------------------------------
   function To_Upper (C : Character) return Character is
      UCASE2LCASE : constant := Character'Pos ('A') - Character'Pos ('a');
      function Is_Lower (C : Character) return Boolean;
      function Is_Lower (C : Character) return Boolean is
      begin
         return C in 'a' .. 'z';
      end Is_Lower;
   begin
      if Is_Lower (C) then
         return Character'Val (Character'Pos (C) - UCASE2LCASE);
      else
         return C;
      end if;
   end To_Upper;

   ----------------------------------------------------------------------------
   -- Make_Uppercase
   ----------------------------------------------------------------------------
   procedure Make_Uppercase (S : in out String) is
   begin
      for I in S'Range loop
         S (I) := To_Upper (S (I));
      end loop;
   end Make_Uppercase;

   ----------------------------------------------------------------------------
   -- Time_Set
   ----------------------------------------------------------------------------
   procedure Time_Set (T : in Time_Type) is
   begin
      FS_Time := T;
   end Time_Set;

   ----------------------------------------------------------------------------
   -- Time_Get
   ----------------------------------------------------------------------------
   procedure Time_Get (T : out Time_Type) is
   begin
      T := FS_Time;
   end Time_Get;

end FATFS.Utilities;

-----------------------------------------------------------------------------------------------------------------------
--                                                     SweetAda                                                      --
-----------------------------------------------------------------------------------------------------------------------
-- __HDS__                                                                                                           --
-- __FLN__ ebcdic.adb                                                                                                --
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

package body EBCDIC
   is

   --========================================================================--
   --                                                                        --
   --                                                                        --
   --                           Package subprograms                          --
   --                                                                        --
   --                                                                        --
   --========================================================================--

   ----------------------------------------------------------------------------
   -- To_EBCDIC
   ----------------------------------------------------------------------------
   procedure To_EBCDIC
      (S1 : in     String;
       S2 :    out EBCDIC_String)
      is
      S2_Index : Positive := S2'First;
   begin
      for S1_Index in S1'Range loop
         S2 (S2_Index) := ASCII2EBCDIC (Character'Pos (S1 (S1_Index)));
         S2_Index := @ + 1;
      end loop;
   end To_EBCDIC;

end EBCDIC;

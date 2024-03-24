-----------------------------------------------------------------------------------------------------------------------
--                                                     SweetAda                                                      --
-----------------------------------------------------------------------------------------------------------------------
-- __HDS__                                                                                                           --
-- __FLN__ mmu-amiga-68030.adb                                                                                       --
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

package body MMU.Amiga
   is

   --========================================================================--
   --                                                                        --
   --                                                                        --
   --                           Package subprograms                          --
   --                                                                        --
   --                                                                        --
   --========================================================================--

   procedure Setup
      is
   begin
      Init;
      declare
         A : Unsigned_32;
      begin
         -- RAM 1st MByte (256 * 4k)
         A := 0;
         for Idx in 0 .. 255 loop
            Page_Setup (Idx, DT_PAGEDSC, A);
            A := @ + 16#1000#;
         end loop;
         Page_Setup (16#BFD#, DT_PAGEDSC, 16#00BF_D000#); -- CIAB
         Page_Setup (16#BFE#, DT_PAGEDSC, 16#00BF_E000#); -- CIAA
         Page_Setup (16#DC0#, DT_PAGEDSC, 16#00DC_0000#); -- RTC
         Page_Setup (16#DD2#, DT_PAGEDSC, 16#00DD_2000#); -- Gayle
         Page_Setup (16#DFF#, DT_PAGEDSC, 16#00DF_F000#); -- CUSTOM
         -- ZORROII
         A := 16#00E8_0000#;
         for Idx in 16#E80# .. 16#EFF# loop
            Page_Setup (Idx, DT_PAGEDSC, A);
            A := @ + 16#1000#;
         end loop;
         -- ROM
         A := 16#00FC_0000#;
         for Idx in 16#FC0# .. 16#FFF# loop
            Page_Setup (Idx, DT_PAGEDSC, A);
            A := @ + 16#1000#;
         end loop;
      end;
      Enable;
   end Setup;

end MMU.Amiga;

-----------------------------------------------------------------------------------------------------------------------
--                                                     SweetAda                                                      --
-----------------------------------------------------------------------------------------------------------------------
-- __HDS__                                                                                                           --
-- __FLN__ core-expanded.adb                                                                                         --
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

package body Core.Expanded
   is

   --========================================================================--
   --                                                                        --
   --                                                                        --
   --                           Local declarations                           --
   --                                                                        --
   --                                                                        --
   --========================================================================--

   GNAT_RT_Init_Count : Integer := 0
      with Export        => True,
           Convention    => C,
           External_Name => "__gnat_rt_init_count";

   --========================================================================--
   --                                                                        --
   --                                                                        --
   --                           Package subprograms                          --
   --                                                                        --
   --                                                                        --
   --========================================================================--

   ----------------------------------------------------------------------------
   -- Runtime_Initialize
   ----------------------------------------------------------------------------
   procedure Runtime_Initialize
      (Install_Handler : in Integer)
      is
   begin
      GNAT_RT_Init_Count := @ + 1;
      if not (GNAT_RT_Init_Count > 1) then
         pragma Warnings (Off);
         null; -- __gnat_install_handler()
         pragma Warnings (On);
      end if;
   end Runtime_Initialize;

end Core.Expanded;

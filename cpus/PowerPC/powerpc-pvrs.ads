-----------------------------------------------------------------------------------------------------------------------
--                                                     SweetAda                                                      --
-----------------------------------------------------------------------------------------------------------------------
-- __HDS__                                                                                                           --
-- __FLN__ powerpc-pvrs.ads                                                                                          --
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

package PowerPC.PVRs
is

   --========================================================================--
   --                                                                        --
   --                                                                        --
   --                               Public part                              --
   --                                                                        --
   --                                                                        --
   --========================================================================--

   PVR_601   : constant := 16#0001#;
   PVR_603   : constant := 16#0003#;
   PVR_604   : constant := 16#0004#;
   PVR_602   : constant := 16#0005#;
   PVR_603e  : constant := 16#0006#;
   PVR_603ev : constant := 16#0007#;
   PVR_603r  : constant := 16#0007#;
   PVR_440EP : constant := 16#4222#;

   ----------------------------------------------------------------------------
   -- Read PVR register and return a string if CPU has been identified.
   ----------------------------------------------------------------------------
   function PVR_Name
      (Value : in Unsigned_16)
      return String;

end PowerPC.PVRs;

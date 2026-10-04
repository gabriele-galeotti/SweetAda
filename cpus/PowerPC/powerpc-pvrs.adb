-----------------------------------------------------------------------------------------------------------------------
--                                                     SweetAda                                                      --
-----------------------------------------------------------------------------------------------------------------------
-- __HDS__                                                                                                           --
-- __FLN__ powerpc-pvrs.adb                                                                                          --
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

package body PowerPC.PVRs
is

   --========================================================================--
   --                                                                        --
   --                                                                        --
   --                           Local declarations                           --
   --                                                                        --
   --                                                                        --
   --========================================================================--

   --========================================================================--
   --                                                                        --
   --                                                                        --
   --                           Package subprograms                          --
   --                                                                        --
   --                                                                        --
   --========================================================================--

   ----------------------------------------------------------------------------
   -- PVR_Name
   ----------------------------------------------------------------------------
   function PVR_Name
      (Value : in Unsigned_16)
      return String
   is
   begin
      case Value is
         when PVR_601   => return "601";
         when PVR_603   => return "603";
         when PVR_604   => return "604";
         when PVR_602   => return "602";
         when PVR_603e  => return "603e";
         when PVR_603ev => return "603ev/603r";
         -- when PVR_603r  => return "603ev/603r";
         when PVR_440EP => return "440EP";
         when others    => return "UNKNOWN";
      end case;
   end PVR_Name;

end PowerPC.PVRs;

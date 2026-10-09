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

pragma Restrictions (No_Elaboration_Code);

package body PowerPC.PVRs
is

   --========================================================================--
   --                                                                        --
   --                                                                        --
   --                           Local declarations                           --
   --                                                                        --
   --                                                                        --
   --========================================================================--

   String_601     : aliased constant String := "601";
   String_603     : aliased constant String := "603";
   String_604     : aliased constant String := "604";
   String_602     : aliased constant String := "602";
   String_603e    : aliased constant String := "603e";
   String_603ev   : aliased constant String := "603ev/603r";
   String_440EP   : aliased constant String := "440EP";
   String_UNKNOWN : aliased constant String := "UNKNOWN";

   MsgPtr_601     : constant access constant String := String_601'Access;
   MsgPtr_603     : constant access constant String := String_603'Access;
   MsgPtr_604     : constant access constant String := String_604'Access;
   MsgPtr_602     : constant access constant String := String_602'Access;
   MsgPtr_603e    : constant access constant String := String_603e'Access;
   MsgPtr_603ev   : constant access constant String := String_603ev'Access;
   MsgPtr_440EP   : constant access constant String := String_440EP'Access;
   MsgPtr_UNKNOWN : constant access constant String := String_UNKNOWN'Access;

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
      return access constant String
   is
   begin
      case Value is
         when PVR_601   => return MsgPtr_601;
         when PVR_603   => return MsgPtr_603;
         when PVR_604   => return MsgPtr_604;
         when PVR_602   => return MsgPtr_602;
         when PVR_603e  => return MsgPtr_603e;
         when PVR_603ev => return MsgPtr_603ev; -- PVR_603r
         when PVR_440EP => return MsgPtr_440EP;
         when others    => return MsgPtr_UNKNOWN;
      end case;
   end PVR_Name;

end PowerPC.PVRs;

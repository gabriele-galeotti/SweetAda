-----------------------------------------------------------------------------------------------------------------------
--                                                     SweetAda                                                      --
-----------------------------------------------------------------------------------------------------------------------
-- __HDS__                                                                                                           --
-- __FLN__ core-base.adb                                                                                             --
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

with Interfaces.C;

package body Core.Base
is

   --========================================================================--
   --                                                                        --
   --                                                                        --
   --                           Package subprograms                          --
   --                                                                        --
   --                                                                        --
   --========================================================================--

   ----------------------------------------------------------------------------
   -- Stack_Check
   ----------------------------------------------------------------------------
   function Stack_Check
      (Stack_Address : System.Address with Unreferenced => True)
      return Stack_Access
   is
   begin
      return null;
   end Stack_Check;

   ----------------------------------------------------------------------------
   -- Get_Env
   ----------------------------------------------------------------------------
   procedure Get_Env
      (Name   : in System.Address with Unreferenced => True;
       Length : in System.Address;
       Ptr    : in System.Address with Unreferenced => True)
   is
      use Interfaces.C;
      GNAT_INIT_SCALARS_String : constant char_array :=
         "GNAT_INIT_SCALARS" & nul
         with Unreferenced => True;
      L                        : aliased size_t
         with Address => Length,
              Import  => True;
   begin
      L := 0;
   end Get_Env;

end Core.Base;

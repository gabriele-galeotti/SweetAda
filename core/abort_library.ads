-----------------------------------------------------------------------------------------------------------------------
--                                                     SweetAda                                                      --
-----------------------------------------------------------------------------------------------------------------------
-- __HDS__                                                                                                           --
-- __FLN__ abort_library.ads                                                                                         --
-- __DSC__                                                                                                           --
-- __HSH__ e69de29bb2d1d6434b8b29ae775ad8c2e48c5391                                                                  --
-- __HDE__                                                                                                           --
-----------------------------------------------------------------------------------------------------------------------
-- Copyright (C) 2020-2023 Gabriele Galeotti                                                                         --
--                                                                                                                   --
-- SweetAda web page: http://sweetada.org                                                                            --
-- contact address: gabriele.galeotti@sweetada.org                                                                   --
-- This work is licensed under the terms of the MIT License.                                                         --
-- Please consult the LICENSE.txt file located in the top-level directory.                                           --
-----------------------------------------------------------------------------------------------------------------------

with System;

package Abort_Library is

   --========================================================================--
   --                                                                        --
   --                                                                        --
   --                               Public part                              --
   --                                                                        --
   --                                                                        --
   --========================================================================--

   pragma Preelaborate;

   ----------------------------------------------------------------------------
   -- System_Abort (parameterless)
   ----------------------------------------------------------------------------
   -- This subprogram may be called by the C Library.
   ----------------------------------------------------------------------------
   procedure System_Abort
      with No_Return => True;

   ----------------------------------------------------------------------------
   -- System_Abort (parameterized)
   ----------------------------------------------------------------------------
   -- This subprogram is called by the standard, not-overriden, version of
   -- Last_Chance_handler and all the subprograms in GNAT_Exceptions.
   ----------------------------------------------------------------------------
   procedure System_Abort
      (File    : in System.Address;
       Line    : in Integer;
       Column  : in Integer;
       Message : in System.Address)
      with No_Return => True;

end Abort_Library;

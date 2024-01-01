-----------------------------------------------------------------------------------------------------------------------
--                                                     SweetAda                                                      --
-----------------------------------------------------------------------------------------------------------------------
-- __HDS__                                                                                                           --
-- __FLN__ abort_library.adb                                                                                         --
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

package body Abort_Library
   is

   --========================================================================--
   --                                                                        --
   --                                                                        --
   --                           Local declarations                           --
   --                                                                        --
   --                                                                        --
   --========================================================================--

   procedure System_Abort_Parameterless
      with Export        => True,
           Convention    => Ada,
           External_Name => "abort_library__system_abort_parameterless",
           No_Return     => True;

   procedure System_Abort_Parameterized
      (File    : in System.Address;
       Line    : in Integer;
       Column  : in Integer;
       Message : in System.Address)
      with No_Return => True;

   --========================================================================--
   --                                                                        --
   --                                                                        --
   --                           Package subprograms                          --
   --                                                                        --
   --                                                                        --
   --========================================================================--

   ----------------------------------------------------------------------------
   -- System_Abort_Parameterless
   ----------------------------------------------------------------------------
   procedure System_Abort_Parameterless
      is
   separate;

   ----------------------------------------------------------------------------
   -- System_Abort_Parameterized
   ----------------------------------------------------------------------------
   procedure System_Abort_Parameterized
      (File    : in System.Address;
       Line    : in Integer;
       Column  : in Integer;
       Message : in System.Address)
      is
   separate;

   ----------------------------------------------------------------------------
   -- System_Abort (parameterless)
   ----------------------------------------------------------------------------
   procedure System_Abort
      renames System_Abort_Parameterless;

   ----------------------------------------------------------------------------
   -- System_Abort (parameterized)
   ----------------------------------------------------------------------------
   procedure System_Abort
      (File    : in System.Address;
       Line    : in Integer;
       Column  : in Integer;
       Message : in System.Address)
      renames System_Abort_Parameterized;

end Abort_Library;

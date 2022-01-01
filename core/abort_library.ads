-----------------------------------------------------------------------------------------------------------------------
--                                                     SweetAda                                                      --
-----------------------------------------------------------------------------------------------------------------------
-- __HDS__                                                                                                           --
-- __FLN__ abort_library.ads                                                                                         --
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

   procedure System_Abort;

   procedure System_Abort (
                           File    : in System.Address;
                           Line    : in Integer;
                           Column  : in Integer;
                           Message : in System.Address
                          );

private

   --========================================================================--
   --                                                                        --
   --                                                                        --
   --                              Private part                              --
   --                                                                        --
   --                                                                        --
   --========================================================================--

   pragma No_Return (System_Abort);

   procedure Export_Abort renames System_Abort;
   pragma Export (C, Export_Abort, "abort");

   procedure Export_Abort_P (
                             File    : in System.Address;
                             Line    : in Integer;
                             Column  : in Integer;
                             Message : in System.Address
                            ) renames System_Abort;
   pragma Export (C, Export_Abort_P, "system_abort");

end Abort_Library;

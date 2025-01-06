-----------------------------------------------------------------------------------------------------------------------
--                                                     SweetAda                                                      --
-----------------------------------------------------------------------------------------------------------------------
-- __HDS__                                                                                                           --
-- __FLN__ last_chance_handler.adb                                                                                   --
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

separate (Last_Chance_Handler)
procedure Last_Chance_Handler
   (Source_Location : in System.Address;
    Line            : in Integer)
   is
   procedure GEMI_Last_Chance_Handler
      (SL : in System.Address;
       L  : in Integer)
      with Import        => True,
           Convention    => C,
           External_Name => "__gemi_last_chance_handler",
           No_Return     => True;
begin
   GEMI_Last_Chance_Handler (Source_Location, Line);
end Last_Chance_Handler;

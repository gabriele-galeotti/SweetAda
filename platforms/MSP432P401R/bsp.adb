-----------------------------------------------------------------------------------------------------------------------
--                                                     SweetAda                                                      --
-----------------------------------------------------------------------------------------------------------------------
-- __HDS__                                                                                                           --
-- __FLN__ bsp.adb                                                                                                   --
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

package body BSP is

   --========================================================================--
   --                                                                        --
   --                                                                        --
   --                           Package subprograms                          --
   --                                                                        --
   --                                                                        --
   --========================================================================--

   ----------------------------------------------------------------------------
   -- Console wrappers
   ----------------------------------------------------------------------------

   procedure Console_Putchar (C : in Character) is
   begin
      null;
   end Console_Putchar;

   procedure Console_Getchar (C : out Character) is
   begin
      C := Character'Val (0);
   end Console_Getchar;

   ----------------------------------------------------------------------------
   -- Setup
   ----------------------------------------------------------------------------
   procedure Setup is
   begin
      -- Console --------------------------------------------------------------
      -- Console.Console_Descriptor.Write := Console_Putchar'Access;
      -- Console.Console_Descriptor.Read  := Console_Getchar'Access;
      -------------------------------------------------------------------------
      null;
   end Setup;

end BSP;

-----------------------------------------------------------------------------------------------------------------------
--                                                     SweetAda                                                      --
-----------------------------------------------------------------------------------------------------------------------
-- __HDS__                                                                                                           --
-- __FLN__ exceptions.ads                                                                                            --
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

with Interfaces;

package Exceptions
   is

   --========================================================================--
   --                                                                        --
   --                                                                        --
   --                               Public part                              --
   --                                                                        --
   --                                                                        --
   --========================================================================--

   use Interfaces;

   type Vectors_Table_Type is array (Natural range <>) of Unsigned_32
      with Pack => True;

   Vectors_Table : aliased Vectors_Table_Type (0 .. 191)
      with Size          => 192 * Unsigned_32'Object_Size,
           Volatile      => True,
           Import        => True,
           External_Name => "vectors_table";

   procedure Exception_Process
      with Export        => True,
           Convention    => Asm,
           External_Name => "exception_process";

   procedure Irq_Process
      with Export        => True,
           Convention    => Asm,
           External_Name => "irq_process";

   procedure Init;

end Exceptions;

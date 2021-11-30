-----------------------------------------------------------------------------------------------------------------------
--                                                     SweetAda                                                      --
-----------------------------------------------------------------------------------------------------------------------
-- __HDS__                                                                                                           --
-- __FLN__ core.ads                                                                                                  --
-- __DSC__                                                                                                           --
-- __HSH__ e69de29bb2d1d6434b8b29ae775ad8c2e48c5391                                                                  --
-- __HDE__                                                                                                           --
-----------------------------------------------------------------------------------------------------------------------
-- Copyright (C) 2020, 2021 Gabriele Galeotti                                                                        --
--                                                                                                                   --
-- SweetAda web page: http://sweetada.org                                                                            --
-- contact address: gabriele.galeotti@sweetada.org                                                                   --
-- This work is licensed under the terms of the MIT License.                                                         --
-- Please consult the LICENSE.txt file located in the top-level directory.                                           --
-----------------------------------------------------------------------------------------------------------------------

with System;
with Interfaces;

package Core is

   --========================================================================--
   --                                                                        --
   --                                                                        --
   --                               Public part                              --
   --                                                                        --
   --                                                                        --
   --========================================================================--

   pragma Preelaborate;

   KERNEL_NAME      : constant String := "Archaea";
   KERNEL_VERSION   : constant String := "0.0";
   KERNEL_THREAD_ID : constant := 1;

   -- AVR CPU version with no "Atomic" aspect
   Tick_Count : aliased Interfaces.Unsigned_32 := 0 with
      Volatile      => True,
      Export        => True,
      Convention    => Asm,
      External_Name => "tick_count";

   ----------------------------------------------------------------------------
   -- RTS-related
   ----------------------------------------------------------------------------

   -- System.Parameters imports this value
   Default_Stack_Size_Value : Integer := -1;

   -- stack checking
   type Stack_Access is access all Integer;
   function Stack_Check (Stack_Address : System.Address) return Stack_Access;

private

   --========================================================================--
   --                                                                        --
   --                                                                        --
   --                              Private part                              --
   --                                                                        --
   --                                                                        --
   --========================================================================--

   pragma Export (C, Default_Stack_Size_Value, "__gl_default_stack_size");
   pragma Export (C, Stack_Check, "_gnat_stack_check");

end Core;

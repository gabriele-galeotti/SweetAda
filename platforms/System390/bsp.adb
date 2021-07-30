-----------------------------------------------------------------------------------------------------------------------
--                                                     SweetAda                                                      --
-----------------------------------------------------------------------------------------------------------------------
-- __HDS__                                                                                                           --
-- __FLN__ bsp.adb                                                                                                   --
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
with System.Storage_Elements;
with Interfaces.C;
with Definitions;
with Malloc;
with CPU;
with S390;
with X3270;

package body BSP is

   --========================================================================--
   --                                                                        --
   --                                                                        --
   --                           Local declarations                           --
   --                                                                        --
   --                                                                        --
   --========================================================================--

   use System;
   use System.Storage_Elements;
   use Interfaces.C;
   use S390;

   -- Malloc memory area
   Heap : aliased Storage_Array (0 .. Definitions.kB64 - 1) with
       Alignment               => 16#1000#,
       Suppress_Initialization => True; -- pragma Initialize_Scalars

   --========================================================================--
   --                                                                        --
   --                                                                        --
   --                           Package subprograms                          --
   --                                                                        --
   --                                                                        --
   --========================================================================--

   ----------------------------------------------------------------------------
   -- BSP_Setup
   ----------------------------------------------------------------------------
   procedure BSP_Setup is
   begin
      -------------------------------------------------------------------------
      Tclk_Init;
      -------------------------------------------------------------------------
      Malloc.Init (Heap'Address, Heap'Size / Storage_Unit, False);
      -------------------------------------------------------------------------
      -- This fragment of code waits for "Attn" to be pressed on the X3270
      -- terminal keypad, then writes a message. Loops over 10 times.
      -------------------------------------------------------------------------
      X3270.Clear_Screen;
      for R in 1 .. 10 loop
         -- X3270.Write_Message ("Welcome to SweetAda S/390 ...", R, 0);
         X3270.Write_Message ("Welcome to SweetAda S/390 ...");
      end loop;
      -------------------------------------------------------------------------
   end BSP_Setup;

end BSP;

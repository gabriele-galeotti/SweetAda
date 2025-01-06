-----------------------------------------------------------------------------------------------------------------------
--                                                     SweetAda                                                      --
-----------------------------------------------------------------------------------------------------------------------
-- __HDS__                                                                                                           --
-- __FLN__ bsp.adb                                                                                                   --
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

with System;
with System.Machine_Code;
with System.Storage_Elements;
with Definitions;
with Bits;
with Malloc;

package body BSP
   is

   --========================================================================--
   --                                                                        --
   --                                                                        --
   --                           Local declarations                           --
   --                                                                        --
   --                                                                        --
   --========================================================================--

   use System;
   use System.Machine_Code;
   use System.Storage_Elements;
   use Interfaces;
   use Definitions;
   use Bits;

   -- Malloc memory area
   Heap : aliased Storage_Array (0 .. kB64 - 1)
      with Alignment               => 16#1000#,
           Suppress_Initialization => True; -- pragma Initialize_Scalars

   procedure Tclk_Init;

   --========================================================================--
   --                                                                        --
   --                                                                        --
   --                           Package subprograms                          --
   --                                                                        --
   --                                                                        --
   --========================================================================--

   ----------------------------------------------------------------------------
   -- Tclk_Init
   ----------------------------------------------------------------------------
   -- TOD clock
   ----------------------------------------------------------------------------
   procedure Tclk_Init
      is
      init_timer_cc : Unsigned_64;
      cc            : Unsigned_32;
   begin
      Asm (
           Template => ""                      & CRLF &
                       "        stck    %1   " & CRLF &
                       "        ipm     %0   " & CRLF &
                       "        srl     %0,28" & CRLF &
                       "",
           Outputs  => Unsigned_32'Asm_Output ("=r", cc),
           Inputs   => Unsigned_64'Asm_Input ("m", init_timer_cc),
           Clobber  => "memory",
           Volatile => True
          );
   end Tclk_Init;

   ----------------------------------------------------------------------------
   -- Setup
   ----------------------------------------------------------------------------
   procedure Setup
      is
   begin
      -------------------------------------------------------------------------
      Tclk_Init;
      -------------------------------------------------------------------------
      Malloc.Init (Heap'Address, Heap'Size / Storage_Unit, False);
      -------------------------------------------------------------------------
   end Setup;

end BSP;

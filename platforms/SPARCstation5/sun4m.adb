-----------------------------------------------------------------------------------------------------------------------
--                                                     SweetAda                                                      --
-----------------------------------------------------------------------------------------------------------------------
-- __HDS__                                                                                                           --
-- __FLN__ sun4m.adb                                                                                                 --
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

with Ada.Unchecked_Conversion;

package body Sun4m
   is

   --========================================================================--
   --                                                                        --
   --                                                                        --
   --                           Package subprograms                          --
   --                                                                        --
   --                                                                        --
   --========================================================================--

   -- E_CSR conversion functions

   function To_U32
      (Value : E_CSR_Type)
      return Unsigned_32
      is
      function Convert is new Ada.Unchecked_Conversion (E_CSR_Type, Unsigned_32);
   begin
      return Convert (Value);
   end To_U32;

   function To_E_CSR
      (Value : Unsigned_32)
      return E_CSR_Type
      is
      function Convert is new Ada.Unchecked_Conversion (Unsigned_32, E_CSR_Type);
   begin
      return Convert (Value);
   end To_E_CSR;

   ----------------------------------------------------------------------------
   -- System_Timer_ClearLR
   ----------------------------------------------------------------------------
   -- pp. 6-41 Counter-Timers
   -- "The interrupt is cleared and the limit bits reset by reading the
   -- appropriate limit register."
   ----------------------------------------------------------------------------
   procedure System_Timer_ClearLR
      is
      Unused : Slavio_Timer_Limit_Type with Unreferenced => True;
   begin
      Unused := System_Timer.Limit;
   end System_Timer_ClearLR;

   ----------------------------------------------------------------------------
   -- Tclk_Init
   -- The 31-bit counter is incremented every 500ns.
   -- interrupt_level_10 22 0x1A
   ----------------------------------------------------------------------------
   procedure Tclk_Init
      is
   begin
      System_Timer.Limit.Limit := 2000; -- 1 ms
   end Tclk_Init;

end Sun4m;

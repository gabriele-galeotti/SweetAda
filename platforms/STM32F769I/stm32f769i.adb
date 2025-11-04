-----------------------------------------------------------------------------------------------------------------------
--                                                     SweetAda                                                      --
-----------------------------------------------------------------------------------------------------------------------
-- __HDS__                                                                                                           --
-- __FLN__ stm32f769i.adb                                                                                            --
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

package body STM32F769I
   is

   --========================================================================--
   --                                                                        --
   --                                                                        --
   --                           Package subprograms                          --
   --                                                                        --
   --                                                                        --
   --========================================================================--

   ----------------------------------------------------------------------------
   -- DATAST_HCLK
   ----------------------------------------------------------------------------
   function DATAST_HCLK
      (Cycles : Bits_8)
      return Bits_8
      is
   begin
      if Cycles = 0 then
         raise Constraint_Error;
      end if;
      return Cycles;
   end DATAST_HCLK;

   ----------------------------------------------------------------------------
   -- MEMSET_HCLK
   ----------------------------------------------------------------------------
   function MEMSET_HCLK
      (Cycles : Bits_8)
      return Bits_8
      is
   begin
      if Cycles = 0 then
         raise Constraint_Error;
      end if;
      return Cycles - 1;
   end MEMSET_HCLK;

   ----------------------------------------------------------------------------
   -- MEMWAIT_HCLK
   ----------------------------------------------------------------------------
   function MEMWAIT_HCLK
      (Cycles : Bits_8)
      return Bits_8
      is
   begin
      if Cycles < 2 then
         raise Constraint_Error;
      end if;
      return Cycles - 1;
   end MEMWAIT_HCLK;

   ----------------------------------------------------------------------------
   -- MEMHOLD_HCLK
   ----------------------------------------------------------------------------
   function MEMHOLD_HCLK
      (Cycles : Bits_8)
      return Bits_8
      is
   begin
      if Cycles = 0 or else Cycles = 255 then
         raise Constraint_Error;
      end if;
      return Cycles;
   end MEMHOLD_HCLK;

   ----------------------------------------------------------------------------
   -- MEMHIZ_HCLK
   ----------------------------------------------------------------------------
   function MEMHIZ_HCLK
      (Cycles : Bits_8)
      return Bits_8
      is
   begin
      if Cycles = 0 then
         raise Constraint_Error;
      end if;
      return Cycles - 1;
   end MEMHIZ_HCLK;

   ----------------------------------------------------------------------------
   -- ATTSET_HCLK
   ----------------------------------------------------------------------------
   function ATTSET_HCLK
      (Cycles : Bits_8)
      return Bits_8
      is
   begin
      if Cycles = 0 then
         raise Constraint_Error;
      end if;
      return Cycles - 1;
   end ATTSET_HCLK;

   ----------------------------------------------------------------------------
   -- ATTWAIT_HCLK
   ----------------------------------------------------------------------------
   function ATTWAIT_HCLK
      (Cycles : Bits_8)
      return Bits_8
      is
   begin
      if Cycles < 2 then
         raise Constraint_Error;
      end if;
      return Cycles - 1;
   end ATTWAIT_HCLK;

   ----------------------------------------------------------------------------
   -- ATTHOLD_HCLK
   ----------------------------------------------------------------------------
   function ATTHOLD_HCLK
      (Cycles : Bits_8)
      return Bits_8
      is
   begin
      if Cycles = 0 or else Cycles = 255 then
         raise Constraint_Error;
      end if;
      return Cycles;
   end ATTHOLD_HCLK;

   ----------------------------------------------------------------------------
   -- ATTHIZ_HCLK
   ----------------------------------------------------------------------------
   function ATTHIZ_HCLK
      (Cycles : Bits_8)
      return Bits_8
      is
   begin
      if Cycles = 0 then
         raise Constraint_Error;
      end if;
      return Cycles - 1;
   end ATTHIZ_HCLK;

   ----------------------------------------------------------------------------
   -- CCx_MODEIN
   ----------------------------------------------------------------------------
   function CCx_MODEIN
      (CCxS   : Bits_2;
       ICxPSC : Bits_2;
       ICxF   : Bits_4)
      return Bits_8
      is
   begin
      if CCxS = CCxS_OUT then
         raise Constraint_Error;
      end if;
      return Bits_8 (
         Shift_Left (Unsigned_8 (CCxS),   0) or
         Shift_Left (Unsigned_8 (ICxPSC), 2) or
         Shift_Left (Unsigned_8 (ICxF),   4)
         );
   end CCx_MODEIN;

   ----------------------------------------------------------------------------
   -- CCx_MODEOUT_BASE
   ----------------------------------------------------------------------------
   function CCx_MODEOUT_BASE
      (CCxS  : Bits_2;
       OCxFE : Boolean;
       OCxPE : Boolean;
       OCxM  : Bits_4;
       OCxCE : Boolean)
      return Bits_8
      is
   begin
      if CCxS /= CCxS_OUT then
         raise Constraint_Error;
      end if;
      return Bits_8 (
         Shift_Left (Unsigned_8 (To_Bits_1 (OCxFE)), 0) or
         Shift_Left (Unsigned_8 (To_Bits_1 (OCxPE)), 1) or
         Shift_Left (Unsigned_8 (OCxM and 2#111#),   2) or
         Shift_Left (Unsigned_8 (To_Bits_1 (OCxCE)), 7)
         );
   end CCx_MODEOUT_BASE;

   ----------------------------------------------------------------------------
   -- CCx_MODEOUT_OCxM3
   ----------------------------------------------------------------------------
   function CCx_MODEOUT_OCxM3
      (CCxS  : Bits_2;
       OCxFE : Boolean;
       OCxPE : Boolean;
       OCxM  : Bits_4;
       OCxCE : Boolean)
      return Bits_1
      is
      pragma Unreferenced (OCxFE);
      pragma Unreferenced (OCxPE);
      pragma Unreferenced (OCxCE);
   begin
      if CCxS /= CCxS_OUT then
         raise Constraint_Error;
      end if;
      return (if (OCxM and 2#1000#) /= 0 then 1 else 0);
   end CCx_MODEOUT_OCxM3;

end STM32F769I;

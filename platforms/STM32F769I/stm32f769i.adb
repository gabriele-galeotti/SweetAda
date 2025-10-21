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

end STM32F769I;

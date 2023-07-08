-----------------------------------------------------------------------------------------------------------------------
--                                                     SweetAda                                                      --
-----------------------------------------------------------------------------------------------------------------------
-- __HDS__                                                                                                           --
-- __FLN__ bsp.ads                                                                                                   --
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

with Interfaces;
with UART16x50;

package BSP is

   --========================================================================--
   --                                                                        --
   --                                                                        --
   --                               Public part                              --
   --                                                                        --
   --                                                                        --
   --========================================================================--

   Tick_Count : aliased Interfaces.Unsigned_32 := 0 with
      Atomic        => True,
      Export        => True,
      Convention    => Asm,
      External_Name => "tick_count";

   UART1_Descriptor : aliased UART16x50.Descriptor_Type := UART16x50.DESCRIPTOR_INVALID;
   UART2_Descriptor : aliased UART16x50.Descriptor_Type := UART16x50.DESCRIPTOR_INVALID;

   procedure Console_Putchar (C : in Character);
   procedure Console_Getchar (C : out Character);
   procedure Setup;

end BSP;

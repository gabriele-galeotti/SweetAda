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

with UARTIOEMU;
with IDE;

package BSP is

   --========================================================================--
   --                                                                        --
   --                                                                        --
   --                               Public part                              --
   --                                                                        --
   --                                                                        --
   --========================================================================--

   UART1_Descriptor : aliased UARTIOEMU.UartIOEMU_Descriptor_Type := UARTIOEMU.UartIOEMU_DESCRIPTOR_INVALID;
   UART2_Descriptor : aliased UARTIOEMU.UartIOEMU_Descriptor_Type := UARTIOEMU.UartIOEMU_DESCRIPTOR_INVALID;
   IDE_Descriptor   : aliased IDE.IDE_Descriptor_Type := IDE.IDE_DESCRIPTOR_INVALID;

   procedure Console_Putchar (C : in Character);
   procedure Console_Getchar (C : out Character);
   procedure BSP_Setup;

end BSP;

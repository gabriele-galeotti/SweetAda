-----------------------------------------------------------------------------------------------------------------------
--                                                     SweetAda                                                      --
-----------------------------------------------------------------------------------------------------------------------
-- __HDS__                                                                                                           --
-- __FLN__ bsp.ads                                                                                                   --
-- __DSC__                                                                                                           --
-- __HSH__ e69de29bb2d1d6434b8b29ae775ad8c2e48c5391                                                                  --
-- __HDE__                                                                                                           --
-----------------------------------------------------------------------------------------------------------------------
-- Copyright (C) 2020, 2021, 2022 Gabriele Galeotti                                                                  --
--                                                                                                                   --
-- SweetAda web page: http://sweetada.org                                                                            --
-- contact address: gabriele.galeotti@sweetada.org                                                                   --
-- This work is licensed under the terms of the MIT License.                                                         --
-- Please consult the LICENSE.txt file located in the top-level directory.                                           --
-----------------------------------------------------------------------------------------------------------------------

with System.Storage_Elements;
with LEON3;

package BSP is

   --========================================================================--
   --                                                                        --
   --                                                                        --
   --                               Public part                              --
   --                                                                        --
   --                                                                        --
   --========================================================================--

   use System.Storage_Elements;
   use LEON3;

   GPTIMER : aliased GPTimer_Type with
      Address    => To_Address (GPTIMER_BASEADDRESS),
      Volatile   => True,
      Import     => True,
      Convention => Ada;

   UART1 : aliased APB_UART_Type with
      Address    => To_Address (APB_UART1_BASEADDRESS),
      Volatile   => True,
      Import     => True,
      Convention => Ada;

   procedure Console_Putchar (C : in Character);
   procedure Console_Getchar (C : out Character);
   procedure BSP_Setup;

private

   --========================================================================--
   --                                                                        --
   --                                                                        --
   --                              Private part                              --
   --                                                                        --
   --                                                                        --
   --========================================================================--

   pragma Export (Asm, BSP_Setup, "bsp_setup");

end BSP;

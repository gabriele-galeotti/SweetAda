-----------------------------------------------------------------------------------------------------------------------
--                                                     SweetAda                                                      --
-----------------------------------------------------------------------------------------------------------------------
-- __HDS__                                                                                                           --
-- __FLN__ stm32vldiscovery.ads                                                                                      --
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

with System;
with System.Storage_Elements;
with Interfaces;
with STM32;

package STM32VLDISCOVERY is

   --========================================================================--
   --                                                                        --
   --                                                                        --
   --                               Public part                              --
   --                                                                        --
   --                                                                        --
   --========================================================================--

   use System;
   use System.Storage_Elements;
   use Interfaces;
   use STM32;

   type USART_Type is
   record
      USART_SR  : USART.USART_SR_Type       with Volatile_Full_Access => True;
      USART_DR  : USART.USART_DR_Type;
      USART_CR1 : USART.USART_CR1_F100_Type with Volatile_Full_Access => True;
   end record with
      Size                    => 16#1C# * 8,
      Suppress_Initialization => True;
   for USART_Type use
   record
      USART_SR  at 16#00# range 0 .. 31;
      USART_DR  at 16#04# range 0 .. 31;
      USART_CR1 at 16#0C# range 0 .. 31;
   end record;

   USART1_BASEADDRESS : constant := 16#4001_3800#;

   USART1 : aliased USART_Type with
      Address    => To_Address (USART1_BASEADDRESS),
      Volatile   => True,
      Import     => True,
      Convention => Ada;

end STM32VLDISCOVERY;

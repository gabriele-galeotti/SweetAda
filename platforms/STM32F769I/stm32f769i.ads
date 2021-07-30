-----------------------------------------------------------------------------------------------------------------------
--                                                     SweetAda                                                      --
-----------------------------------------------------------------------------------------------------------------------
-- __HDS__                                                                                                           --
-- __FLN__ stm32f769i.ads                                                                                            --
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
with Interfaces;

package STM32F769I is

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

   ----------------------------------------------------------------------------
   -- RCC
   ----------------------------------------------------------------------------

   RCC_BASEADDRESS : constant := 16#4002_3800#;

   RCC_CIR : constant := RCC_BASEADDRESS + 16#0C#;

   ----------------------------------------------------------------------------
   -- GPIO
   ----------------------------------------------------------------------------

   type MODE_Register_Type is
   record
      Value : Interfaces.Unsigned_32;
   end record with
      Size                 => 32,
      Volatile_Full_Access => True;

   type OTYPE_Register_Type is
   record
      Value : Interfaces.Unsigned_32;
   end record with
      Size                 => 32,
      Volatile_Full_Access => True;

   type OD_Register_Type is
   record
      Value : Interfaces.Unsigned_32;
   end record with
      Size                 => 32,
      Volatile_Full_Access => True;

   type GPIO_Peripheral is
   record
      MODER   : aliased MODE_Register_Type     with Volatile_Full_Access => True; -- GPIO port mode register
      OTYPER  : aliased OTYPE_Register_Type    with Volatile_Full_Access => True; -- GPIO port output type register
      OSPEEDR : aliased Interfaces.Unsigned_32 with Volatile_Full_Access => True; -- GPIO port output speed register
      PUPDR   : aliased Interfaces.Unsigned_32 with Volatile_Full_Access => True; -- GPIO port pull-up/pull-down register
      IDR     : aliased Interfaces.Unsigned_32 with Volatile_Full_Access => True; -- GPIO port input data register
      ODR     : aliased OD_Register_Type       with Volatile_Full_Access => True; -- GPIO port output data register
      BSRR    : aliased Interfaces.Unsigned_32 with Volatile_Full_Access => True; -- GPIO port bit set/reset register
      LCKR    : aliased Interfaces.Unsigned_32 with Volatile_Full_Access => True; -- GPIO port configuration lock register
      AFRL    : aliased Interfaces.Unsigned_32 with Volatile_Full_Access => True; -- GPIO alternate function low register
      AFRH    : aliased Interfaces.Unsigned_32 with Volatile_Full_Access => True; -- GPIO alternate function high register
      BRR     : aliased Interfaces.Unsigned_32 with Volatile_Full_Access => True; -- GPIO port bit reset register
   end record;
   for GPIO_Peripheral use
   record
      MODER   at 16#00# range 0 .. 31;
      OTYPER  at 16#04# range 0 .. 31;
      OSPEEDR at 16#08# range 0 .. 31;
      PUPDR   at 16#0C# range 0 .. 31;
      IDR     at 16#10# range 0 .. 31;
      ODR     at 16#14# range 0 .. 31;
      BSRR    at 16#18# range 0 .. 31;
      LCKR    at 16#1C# range 0 .. 31;
      AFRL    at 16#20# range 0 .. 31;
      AFRH    at 16#24# range 0 .. 31;
      BRR     at 16#28# range 0 .. 31;
   end record;

   PORT_GPIOJ_BASEADDRESS : constant := 16#4002_2400#;
   -- LD_USER1 PJ13
   -- LD_USER2 PJ5
   PORT_GPIOJ : aliased GPIO_Peripheral with
      Address    => To_Address (PORT_GPIOJ_BASEADDRESS),
      Volatile   => True,
      Import     => True,
      Convention => Ada;

end STM32F769I;

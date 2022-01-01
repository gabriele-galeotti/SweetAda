-----------------------------------------------------------------------------------------------------------------------
--                                                     SweetAda                                                      --
-----------------------------------------------------------------------------------------------------------------------
-- __HDS__                                                                                                           --
-- __FLN__ uartioemu.ads                                                                                             --
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

with System;
with Interfaces;
with Bits;

package UARTIOEMU is

   --========================================================================--
   --                                                                        --
   --                                                                        --
   --                               Public part                              --
   --                                                                        --
   --                                                                        --
   --========================================================================--

   use System;
   use Interfaces;
   use Bits;

   type Register_Read_8_Ptr is access function (Port : Address) return Unsigned_8;
   type Register_Write_8_Ptr is access procedure (Port : in Address; Value : in Unsigned_8);

   type UartIOEMU_Descriptor_Type is
   record
      Base_Address  : Address;
      Scale_Address : Address_Shift;
      Irq           : Natural;
      Read          : Register_Read_8_Ptr;
      Write         : Register_Write_8_Ptr;
   end record;

   UartIOEMU_DESCRIPTOR_INVALID : constant UartIOEMU_Descriptor_Type :=
      (
       Base_Address  => Null_Address,
       Scale_Address => 0,
       Irq           => 0,
       Read          => null,
       Write         => null
      );

   procedure Init (Descriptor : in UartIOEMU_Descriptor_Type);
   procedure TX (Descriptor : in UartIOEMU_Descriptor_Type; Data : in Unsigned_8);
   procedure RX (Descriptor : in UartIOEMU_Descriptor_Type; Data : out Unsigned_8);
   function RXIrqActive (Descriptor : UartIOEMU_Descriptor_Type) return Boolean;
   procedure RXClearIrq (Descriptor : in UartIOEMU_Descriptor_Type);

end UARTIOEMU;

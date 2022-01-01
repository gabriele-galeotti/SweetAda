-----------------------------------------------------------------------------------------------------------------------
--                                                     SweetAda                                                      --
-----------------------------------------------------------------------------------------------------------------------
-- __HDS__                                                                                                           --
-- __FLN__ interrupts.ads                                                                                            --
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
with CPU;

package Interrupts is

   --========================================================================--
   --                                                                        --
   --                                                                        --
   --                               Public part                              --
   --                                                                        --
   --                                                                        --
   --========================================================================--

   type Interrupt_Handler_Ptr is access procedure (Data_Address : in System.Address);

   type Interrupt_Descriptor_Type is
   record
      Irq_Handler  : Interrupt_Handler_Ptr;
      Data_Address : System.Address;
   end record;

   INTERRUPT_DESCRIPTOR_INVALID : constant Interrupt_Descriptor_Type := (null, System.Null_Address);

   procedure Init;
   procedure Install (
                      Irq          : in CPU.Irq_Id_Type;
                      Irq_Handler  : in Interrupt_Handler_Ptr;
                      Data_Address : in System.Address
                     );
   procedure Handler (Irq : in CPU.Irq_Id_Type);

end Interrupts;

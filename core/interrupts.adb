-----------------------------------------------------------------------------------------------------------------------
--                                                     SweetAda                                                      --
-----------------------------------------------------------------------------------------------------------------------
-- __HDS__                                                                                                           --
-- __FLN__ interrupts.adb                                                                                            --
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

package body Interrupts is

   --========================================================================--
   --                                                                        --
   --                                                                        --
   --                           Local declarations                           --
   --                                                                        --
   --                                                                        --
   --========================================================================--

   Interrupt_Handlers : array (CPU.Irq_Id_Type) of Interrupt_Descriptor_Type := (others => INTERRUPT_DESCRIPTOR_INVALID);

   --========================================================================--
   --                                                                        --
   --                                                                        --
   --                           Package subprograms                          --
   --                                                                        --
   --                                                                        --
   --========================================================================--

   ----------------------------------------------------------------------------
   -- Init
   ----------------------------------------------------------------------------
   procedure Init is
   begin
      null;
   end Init;

   ----------------------------------------------------------------------------
   -- Install
   ----------------------------------------------------------------------------
   procedure Install (
                      Irq          : in CPU.Irq_Id_Type;
                      Irq_Handler  : in Interrupt_Handler_Ptr;
                      Data_Address : in System.Address
                     ) is
   begin
      Interrupt_Handlers (Irq).Irq_Handler  := Irq_Handler;
      Interrupt_Handlers (Irq).Data_Address := Data_Address;
   end Install;

   ----------------------------------------------------------------------------
   -- Handler
   ----------------------------------------------------------------------------
   procedure Handler (Irq : in CPU.Irq_Id_Type) is
   begin
      if Interrupt_Handlers (Irq).Irq_Handler /= null then
         Interrupt_Handlers (Irq).Irq_Handler (Interrupt_Handlers (Irq).Data_Address);
      end if;
   end Handler;

end Interrupts;

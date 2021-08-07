-----------------------------------------------------------------------------------------------------------------------
--                                                     SweetAda                                                      --
-----------------------------------------------------------------------------------------------------------------------
-- __HDS__                                                                                                           --
-- __FLN__ niosii.adb                                                                                                --
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

with System.Machine_Code;
with Definitions;

package body NiosII is

   --========================================================================--
   --                                                                        --
   --                                                                        --
   --                           Local declarations                           --
   --                                                                        --
   --                                                                        --
   --========================================================================--

   use System.Machine_Code;

   CRLF : String renames Definitions.CRLF;

   --========================================================================--
   --                                                                        --
   --                                                                        --
   --                           Package subprograms                          --
   --                                                                        --
   --                                                                        --
   --========================================================================--

   ----------------------------------------------------------------------------
   -- Asm_Call
   ----------------------------------------------------------------------------
   procedure Asm_Call (Target_Address : in Address) is
   begin
      Asm (
           Template => " mov r2,%0" & CRLF &
                       " callr r2",
           Outputs  => No_Output_Operands,
           Inputs   => System.Address'Asm_Input ("r", Target_Address),
           Clobber  => "r2",
           Volatile => True
          );
   end Asm_Call;

   ----------------------------------------------------------------------------
   -- Irq_Enable/Disable
   ----------------------------------------------------------------------------

   procedure Irq_Enable is
   begin
      null; -- __TBD__
   end Irq_Enable;

   procedure Irq_Disable is
   begin
      null; -- __TBD__
   end Irq_Disable;

   function Irq_State_Get return Irq_State_Type is
   begin
      return 0; -- __TBD__
   end Irq_State_Get;

   procedure Irq_State_Set (Irq_State : in Irq_State_Type) is
      pragma Unreferenced (Irq_State);
   begin
      null; -- __TBD__
   end Irq_State_Set;

end NiosII;

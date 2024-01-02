-----------------------------------------------------------------------------------------------------------------------
--                                                     SweetAda                                                      --
-----------------------------------------------------------------------------------------------------------------------
-- __HDS__                                                                                                           --
-- __FLN__ gdbstub-cpu.ads                                                                                           --
-- __DSC__                                                                                                           --
-- __HSH__ e69de29bb2d1d6434b8b29ae775ad8c2e48c5391                                                                  --
-- __HDE__                                                                                                           --
-----------------------------------------------------------------------------------------------------------------------
-- Copyright (C) 2020-2024 Gabriele Galeotti                                                                         --
--                                                                                                                   --
-- SweetAda web page: http://sweetada.org                                                                            --
-- contact address: gabriele.galeotti@sweetada.org                                                                   --
-- This work is licensed under the terms of the MIT License.                                                         --
-- Please consult the LICENSE.txt file located in the top-level directory.                                           --
-----------------------------------------------------------------------------------------------------------------------

with System;
with Bits;

package Gdbstub.CPU
   is

   --========================================================================--
   --                                                                        --
   --                                                                        --
   --                               Public part                              --
   --                                                                        --
   --                                                                        --
   --========================================================================--

   procedure Register_Read
      (Register_Number : in Natural);
   procedure Registers_Read;
   procedure Register_Write
      (Register_Number : in Natural;
       Register_Value  : in Bits.Byte_Array;
       Byte_Count      : in Natural);
   procedure Registers_Write;
   function PC_Read
      return System.Address;
   procedure PC_Write
      (Value : in System.Address);
   procedure Breakpoint_Adjust_PC_Backward;
   procedure Breakpoint_Adjust_PC_Forward;
   procedure Breakpoint_Adjust_PC;
   procedure Breakpoint_Skip;
   procedure Breakpoint_Set
      with Inline => True;
   function Step_Execute
      return Boolean;
   procedure Step_Resume;

end Gdbstub.CPU;

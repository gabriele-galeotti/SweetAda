-----------------------------------------------------------------------------------------------------------------------
--                                                     SweetAda                                                      --
-----------------------------------------------------------------------------------------------------------------------
-- __HDS__                                                                                                           --
-- __FLN__ armv7m-fpu.adb                                                                                            --
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

with System.Machine_Code;
with Definitions;

package body ARMv7M.FPU
   is

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
   -- FPSCR_Read/Write
   ----------------------------------------------------------------------------

   function FPSCR_Read
      return FPSCR_Type
      is
      Value : FPSCR_Type;
   begin
      Asm (
           Template => ""                         & CRLF &
                       "        vmrs    %0,fpscr" & CRLF &
                       "",
           Outputs  => FPSCR_Type'Asm_Output ("=r", Value),
           Inputs   => No_Input_Operands,
           Clobber  => "",
           Volatile => True
          );
      return Value;
   end FPSCR_Read;

   procedure FPSCR_Write
      (Value : in FPSCR_Type)
      is
   begin
      Asm (
           Template => ""                         & CRLF &
                       "        vmsr    fpscr,%0" & CRLF &
                       "",
           Outputs  => No_Output_Operands,
           Inputs   => FPSCR_Type'Asm_Input ("r", Value),
           Clobber  => "",
           Volatile => True
          );
   end FPSCR_Write;

end ARMv7M.FPU;

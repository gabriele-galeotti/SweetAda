-----------------------------------------------------------------------------------------------------------------------
--                                                     SweetAda                                                      --
-----------------------------------------------------------------------------------------------------------------------
-- __HDS__                                                                                                           --
-- __FLN__ m68040.adb                                                                                                --
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

package body M68040 is

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
   -- URP_Set
   ----------------------------------------------------------------------------
   procedure URP_Set (URP_Address : in Address) is
   begin
      Asm (
           Template => "        movec %0,%%urp",
           Outputs  => No_Output_Operands,
           Inputs   => System.Address'Asm_Input ("d", URP_Address),
           Clobber  => "",
           Volatile => True
          );
   end URP_Set;

   ----------------------------------------------------------------------------
   -- SRP_Set
   ----------------------------------------------------------------------------
   procedure SRP_Set (SRP_Address : in Address) is
   begin
      Asm (
           Template => "        movec %0,%%srp",
           Outputs  => No_Output_Operands,
           Inputs   => System.Address'Asm_Input ("d", SRP_Address),
           Clobber  => "",
           Volatile => True
          );
   end SRP_Set;

   ----------------------------------------------------------------------------
   -- TCR_Set
   ----------------------------------------------------------------------------
   procedure TCR_Set (Value : in TCR_Register_Type) is
   begin
      Asm (
           Template => "        movec %0,%%tcr",
           Outputs  => No_Output_Operands,
           Inputs   => TCR_Register_Type'Asm_Input ("d", Value),
           Clobber  => "",
           Volatile => True
          );
   end TCR_Set;

end M68040;

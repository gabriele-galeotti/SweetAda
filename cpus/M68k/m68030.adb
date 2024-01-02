-----------------------------------------------------------------------------------------------------------------------
--                                                     SweetAda                                                      --
-----------------------------------------------------------------------------------------------------------------------
-- __HDS__                                                                                                           --
-- __FLN__ m68030.adb                                                                                                --
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

package body M68030
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
   -- CRP_Set
   ----------------------------------------------------------------------------
   procedure CRP_Set
      (CRP_Address : in Address)
      is
   begin
      Asm (
           Template => ""                          & CRLF &
                       "        pmove   %0@,%%crp" & CRLF &
                       "",
           Outputs  => No_Output_Operands,
           Inputs   => System.Address'Asm_Input ("a", CRP_Address),
           Clobber  => "memory",
           Volatile => True
          );
   end CRP_Set;

   ----------------------------------------------------------------------------
   -- SRP_Set
   ----------------------------------------------------------------------------
   procedure SRP_Set
      (SRP_Address : in Address)
      is
   begin
      Asm (
           Template => ""                          & CRLF &
                       "        pmove   %0@,%%srp" & CRLF &
                       "",
           Outputs  => No_Output_Operands,
           Inputs   => System.Address'Asm_Input ("a", SRP_Address),
           Clobber  => "memory",
           Volatile => True
          );
   end SRP_Set;

   ----------------------------------------------------------------------------
   -- TCR_Set
   ----------------------------------------------------------------------------
   procedure TCR_Set
      (Value : in TCR_Type)
      is
      TCR : aliased TCR_Type := Value;
   begin
      Asm (
           Template => ""                          & CRLF &
                       "        pmove   %0@,%%tcr" & CRLF &
                       "",
           Outputs  => No_Output_Operands,
           Inputs   => Address'Asm_Input ("a", TCR'Address),
           Clobber  => "memory",
           Volatile => True
          );
   end TCR_Set;

end M68030;

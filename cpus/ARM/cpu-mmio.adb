-----------------------------------------------------------------------------------------------------------------------
--                                                     SweetAda                                                      --
-----------------------------------------------------------------------------------------------------------------------
-- __HDS__                                                                                                           --
-- __FLN__ cpu-mmio.adb                                                                                              --
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

with System.Machine_Code;
with Definitions;

package body CPU.MMIO is

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

   function Read_U8 (Memory_Address : System.Address) return Interfaces.Unsigned_8 is
      Result : Interfaces.Unsigned_8;
   begin
      Asm (
           Template => " ldrb %0,[%1]",
           Outputs  => Interfaces.Unsigned_8'Asm_Output ("=r", Result),
           Inputs   => System.Address'Asm_Input ("r", Memory_Address),
           Clobber  => "",
           Volatile => True
          );
      return Result;
   end Read_U8;

   function Read_U16 (Memory_Address : System.Address) return Interfaces.Unsigned_16 is
      Result : Interfaces.Unsigned_16;
   begin
      Asm (
           Template => " ldrh %0,[%1]",
           Outputs  => Interfaces.Unsigned_16'Asm_Output ("=r", Result),
           Inputs   => System.Address'Asm_Input ("r", Memory_Address),
           Clobber  => "",
           Volatile => True
          );
      return Result;
   end Read_U16;

   function Read_U32 (Memory_Address : System.Address) return Interfaces.Unsigned_32 is
      Result : Interfaces.Unsigned_32;
   begin
      Asm (
           Template => " ldr %0,[%1]",
           Outputs  => Interfaces.Unsigned_32'Asm_Output ("=r", Result),
           Inputs   => System.Address'Asm_Input ("r", Memory_Address),
           Clobber  => "",
           Volatile => True
          );
      return Result;
   end Read_U32;

   procedure Write_U8 (Memory_Address : in System.Address; Value : in Interfaces.Unsigned_8) is
   begin
      Asm (
           Template => " strb %0,[%1]",
           Outputs  => No_Output_Operands,
           Inputs   => (
                        Interfaces.Unsigned_8'Asm_Input ("r", Value),
                        System.Address'Asm_Input ("r", Memory_Address)
                       ),
           Clobber  => "memory",
           Volatile => True
          );
   end Write_U8;

   procedure Write_U16 (Memory_Address : in System.Address; Value : in Interfaces.Unsigned_16) is
   begin
      Asm (
           Template => " strh %0,[%1]",
           Outputs  => No_Output_Operands,
           Inputs   => (
                        Interfaces.Unsigned_16'Asm_Input ("r", Value),
                        System.Address'Asm_Input ("r", Memory_Address)
                       ),
           Clobber  => "memory",
           Volatile => True
          );
   end Write_U16;

   procedure Write_U32 (Memory_Address : in System.Address; Value : in Interfaces.Unsigned_32) is
   begin
      Asm (
           Template => " str %0,[%1]",
           Outputs  => No_Output_Operands,
           Inputs   => (
                        Interfaces.Unsigned_32'Asm_Input ("r", Value),
                        System.Address'Asm_Input ("r", Memory_Address)
                       ),
           Clobber  => "memory",
           Volatile => True
          );
   end Write_U32;

end CPU.MMIO;

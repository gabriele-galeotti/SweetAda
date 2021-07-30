-----------------------------------------------------------------------------------------------------------------------
--                                                     SweetAda                                                      --
-----------------------------------------------------------------------------------------------------------------------
-- __HDS__                                                                                                           --
-- __FLN__ cpu-io.adb                                                                                                --
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
with Ada.Unchecked_Conversion;
with Definitions;

package body CPU.IO is

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
   -- PortIn/PortOut
   ----------------------------------------------------------------------------

   function PortIn (Port : Unsigned_16) return Unsigned_8 is
      Result : Unsigned_8;
   begin
      Asm (
           Template => " inb %w1,%0",
           Outputs  => Unsigned_8'Asm_Output ("=a", Result),
           Inputs   => Unsigned_16'Asm_Input ("d", Port),
           Clobber  => "",
           Volatile => True
          );
      return Result;
   end PortIn;

   function PortIn (Port : Unsigned_16) return Unsigned_16 is
      Result : Unsigned_16;
   begin
      Asm (
           Template => " inw %w1,%0",
           Outputs  => Unsigned_16'Asm_Output ("=a", Result),
           Inputs   => Unsigned_16'Asm_Input ("d", Port),
           Clobber  => "",
           Volatile => True
          );
      return Result;
   end PortIn;

   function PortIn (Port : Unsigned_16) return Unsigned_32 is
      Result : Unsigned_32;
   begin
      Asm (
           Template => " inl %w1,%0",
           Outputs  => Unsigned_32'Asm_Output ("=a", Result),
           Inputs   => Unsigned_16'Asm_Input ("d", Port),
           Clobber  => "",
           Volatile => True
          );
      return Result;
   end PortIn;

   procedure PortOut (Port : in Unsigned_16; Value : in Unsigned_8) is
   begin
      Asm (
           Template => " outb %b0,%w1",
           Outputs  => No_Output_Operands,
           Inputs   => (
                        Unsigned_8'Asm_Input ("a", Value),
                        Unsigned_16'Asm_Input ("d", Port)
                       ),
           Clobber  => "",
           Volatile => True
          );
   end PortOut;

   procedure PortOut (Port : in Unsigned_16; Value : in Unsigned_16) is
   begin
      Asm (
           Template => " outw %w0,%w1",
           Outputs  => No_Output_Operands,
           Inputs   => (
                        Unsigned_16'Asm_Input ("a", Value),
                        Unsigned_16'Asm_Input ("d", Port)
                       ),
           Clobber  => "",
           Volatile => True
          );
   end PortOut;

   procedure PortOut (Port : in Unsigned_16; Value : in Unsigned_32) is
   begin
      Asm (
           Template => " outl %0,%w1",
           Outputs  => No_Output_Operands,
           Inputs   => (
                        Unsigned_32'Asm_Input ("a", Value),
                        Unsigned_16'Asm_Input ("d", Port)
                       ),
           Clobber  => "",
           Volatile => True
          );
   end PortOut;

   ----------------------------------------------------------------------------
   -- I/O operations referenced by addresses
   ----------------------------------------------------------------------------

   function A_To_U64 is new Ada.Unchecked_Conversion (Address, Unsigned_64);

   -- Unsigned_8
   function IO_Read (Port_Address : Address) return Unsigned_8 is
   begin
      return PortIn (Unsigned_16 (A_To_U64 (Port_Address) and 16#0000_0000_0000_FFFF#));
   end IO_Read;
   procedure IO_Write (Port_Address : in Address; Value : in Unsigned_8) is
   begin
      PortOut (Unsigned_16 (A_To_U64 (Port_Address) and 16#0000_0000_0000_FFFF#), Value);
   end IO_Write;

   -- Unsigned_16
   function IO_Read (Port_Address : Address) return Unsigned_16 is
   begin
      return PortIn (Unsigned_16 (A_To_U64 (Port_Address) and 16#0000_0000_0000_FFFF#));
   end IO_Read;
   procedure IO_Write (Port_Address : in Address; Value : in Unsigned_16) is
   begin
      PortOut (Unsigned_16 (A_To_U64 (Port_Address) and 16#0000_0000_0000_FFFF#), Value);
   end IO_Write;

   -- Unsigned_32
   function IO_Read (Port_Address : Address) return Unsigned_32 is
   begin
      return PortIn (Unsigned_16 (A_To_U64 (Port_Address) and 16#0000_0000_0000_FFFF#));
   end IO_Read;
   procedure IO_Write (Port_Address : in Address; Value : in Unsigned_32) is
   begin
      PortOut (Unsigned_16 (A_To_U64 (Port_Address) and 16#0000_0000_0000_FFFF#), Value);
   end IO_Write;

end CPU.IO;

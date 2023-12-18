-----------------------------------------------------------------------------------------------------------------------
--                                                     SweetAda                                                      --
-----------------------------------------------------------------------------------------------------------------------
-- __HDS__                                                                                                           --
-- __FLN__ cpu-io.adb                                                                                                --
-- __DSC__                                                                                                           --
-- __HSH__ e69de29bb2d1d6434b8b29ae775ad8c2e48c5391                                                                  --
-- __HDE__                                                                                                           --
-----------------------------------------------------------------------------------------------------------------------
-- Copyright (C) 2020-2023 Gabriele Galeotti                                                                         --
--                                                                                                                   --
-- SweetAda web page: http://sweetada.org                                                                            --
-- contact address: gabriele.galeotti@sweetada.org                                                                   --
-- This work is licensed under the terms of the MIT License.                                                         --
-- Please consult the LICENSE.txt file located in the top-level directory.                                           --
-----------------------------------------------------------------------------------------------------------------------

with System.Machine_Code;
with Ada.Unchecked_Conversion;
with Definitions;
with Bits;

package body CPU.IO
   is

   --========================================================================--
   --                                                                        --
   --                                                                        --
   --                           Local declarations                           --
   --                                                                        --
   --                                                                        --
   --========================================================================--

   use System.Machine_Code;
   use Bits;

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

   function PortIn
      (Port : Unsigned_16)
      return Unsigned_8
      is
      Result : Unsigned_8;
   begin
      Asm (
           Template => ""                        & CRLF &
                       "        inb     %w1,%b0" & CRLF &
                       "",
           Outputs  => Unsigned_8'Asm_Output ("=a", Result),
           Inputs   => Unsigned_16'Asm_Input ("d", Port),
           Clobber  => "",
           Volatile => True
          );
      return Result;
   end PortIn;

   function PortIn
      (Port : Unsigned_16)
      return Unsigned_16
      is
      Result : Unsigned_16;
   begin
      Asm (
           Template => ""                        & CRLF &
                       "        inw     %w1,%w0" & CRLF &
                       "",
           Outputs  => Unsigned_16'Asm_Output ("=a", Result),
           Inputs   => Unsigned_16'Asm_Input ("d", Port),
           Clobber  => "",
           Volatile => True
          );
      return Result;
   end PortIn;

   function PortIn
      (Port : Unsigned_16)
      return Unsigned_32
      is
      Result : Unsigned_32;
   begin
      Asm (
           Template => ""                       & CRLF &
                       "        inl     %w1,%0" & CRLF &
                       "",
           Outputs  => Unsigned_32'Asm_Output ("=a", Result),
           Inputs   => Unsigned_16'Asm_Input ("d", Port),
           Clobber  => "",
           Volatile => True
          );
      return Result;
   end PortIn;

   procedure PortOut
      (Port  : in Unsigned_16;
       Value : in Unsigned_8)
      is
   begin
      Asm (
           Template => ""                        & CRLF &
                       "        outb    %b0,%w1" & CRLF &
                       "",
           Outputs  => No_Output_Operands,
           Inputs   => [
                        Unsigned_8'Asm_Input ("a", Value),
                        Unsigned_16'Asm_Input ("d", Port)
                       ],
           Clobber  => "",
           Volatile => True
          );
   end PortOut;

   procedure PortOut
      (Port  : in Unsigned_16;
       Value : in Unsigned_16)
      is
   begin
      Asm (
           Template => ""                        & CRLF &
                       "        outw    %w0,%w1" & CRLF &
                       "",
           Outputs  => No_Output_Operands,
           Inputs   => [
                        Unsigned_16'Asm_Input ("a", Value),
                        Unsigned_16'Asm_Input ("d", Port)
                       ],
           Clobber  => "",
           Volatile => True
          );
   end PortOut;

   procedure PortOut
      (Port  : in Unsigned_16;
       Value : in Unsigned_32)
      is
   begin
      Asm (
           Template => ""                       & CRLF &
                       "        outl    %0,%w1" & CRLF &
                       "",
           Outputs  => No_Output_Operands,
           Inputs   => [
                        Unsigned_32'Asm_Input ("a", Value),
                        Unsigned_16'Asm_Input ("d", Port)
                       ],
           Clobber  => "",
           Volatile => True
          );
   end PortOut;

   ----------------------------------------------------------------------------
   -- I/O operations referenced by addresses
   ----------------------------------------------------------------------------

   function To_U32 is new Ada.Unchecked_Conversion (Address, Unsigned_32);

   -- Unsigned_8

   function IO_Read
      (Port_Address : Address)
      return Unsigned_8
      is
   begin
      return PortIn (Unsigned_16 (To_U32 (Port_Address) and Unsigned_16_Mask));
   end IO_Read;

   procedure IO_Write
      (Port_Address : in Address;
       Value        : in Unsigned_8)
      is
   begin
      PortOut (Unsigned_16 (To_U32 (Port_Address) and Unsigned_16_Mask), Value);
   end IO_Write;

   -- Unsigned_16

   function IO_Read
      (Port_Address : Address)
      return Unsigned_16
      is
   begin
      return PortIn (Unsigned_16 (To_U32 (Port_Address) and Unsigned_16_Mask));
   end IO_Read;

   procedure IO_Write
      (Port_Address : in Address;
       Value        : in Unsigned_16)
      is
   begin
      PortOut (Unsigned_16 (To_U32 (Port_Address) and Unsigned_16_Mask), Value);
   end IO_Write;

   -- Unsigned_32

   function IO_Read
      (Port_Address : Address)
      return Unsigned_32
      is
   begin
      return PortIn (Unsigned_16 (To_U32 (Port_Address) and Unsigned_16_Mask));
   end IO_Read;

   procedure IO_Write
      (Port_Address : in Address;
       Value        : in Unsigned_32)
      is
   begin
      PortOut (Unsigned_16 (To_U32 (Port_Address) and Unsigned_16_Mask), Value);
   end IO_Write;

end CPU.IO;

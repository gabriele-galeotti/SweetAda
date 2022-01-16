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
with System.Storage_Elements;
with Definitions;
with Bits;

package body CPU.MMIO is

   --========================================================================--
   --                                                                        --
   --                                                                        --
   --                           Local declarations                           --
   --                                                                        --
   --                                                                        --
   --========================================================================--

   use System.Machine_Code;
   use System.Storage_Elements;

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
           Template => ""                       & CRLF &
                       "        mov.b   @%1,%0" & CRLF &
                       "",
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
           Template => ""                       & CRLF &
                       "        mov.w   @%1,%0" & CRLF &
                       "",
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
           Template => ""                       & CRLF &
                       "        mov.l   @%1,%0" & CRLF &
                       "",
           Outputs  => Interfaces.Unsigned_32'Asm_Output ("=r", Result),
           Inputs   => System.Address'Asm_Input ("r", Memory_Address),
           Clobber  => "",
           Volatile => True
          );
      return Result;
   end Read_U32;

   function Read_U64 (Memory_Address : System.Address) return Interfaces.Unsigned_64 is
   begin
      return Bits.Make_Word (Read_U32 (Memory_Address), Read_U32 (Memory_Address + 4));
   end Read_U64;

end CPU.MMIO;

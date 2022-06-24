-----------------------------------------------------------------------------------------------------------------------
--                                                     SweetAda                                                      --
-----------------------------------------------------------------------------------------------------------------------
-- __HDS__                                                                                                           --
-- __FLN__ llutils.ads                                                                                               --
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

with System;
with System.Storage_Elements;
with Interfaces;
with Bits;

package LLutils is

   --========================================================================--
   --                                                                        --
   --                                                                        --
   --                               Public part                              --
   --                                                                        --
   --                                                                        --
   --========================================================================--

   pragma Preelaborate;

   package SSE renames System.Storage_Elements;

   procedure Byte_Swap_16 (Object_Address : in System.Address) with
      Inline => True;
   procedure Byte_Swap_32 (Object_Address : in System.Address) with
      Inline => True;
   procedure Byte_Swap_64 (Object_Address : in System.Address) with
      Inline => True;

   procedure Byte_Swap (
                        Object_Address : in System.Address;
                        Size           : in Bits.Bitsize
                       ) with
      Inline => True;

   procedure Byte_Swap_Next (
                             Object_Address : in out System.Address;
                             Size           : in     Bits.Bitsize
                            );

   function Select_Address_Bits (
                                 Address_Pattern : System.Address;
                                 LSBit           : Bits.Address_Bit_Number;
                                 MSBit           : Bits.Address_Bit_Number;
                                 BE_Layout       : Boolean := False
                                ) return SSE.Integer_Address with
      Inline => True;

   function Address_Displacement (
                                  Local_Address  : System.Address;
                                  Target_Address : System.Address;
                                  Scale_Address  : Bits.Address_Shift
                                 ) return SSE.Storage_Offset with
      Inline => True;

   function Build_Address (
                           Base_Address  : System.Address;
                           Offset        : SSE.Storage_Offset;
                           Scale_Address : Bits.Address_Shift
                          ) return System.Address with
      Inline => True;

   procedure HexDigit_To_U8 (
                             C       : in     Character;
                             MSD     : in     Boolean;
                             Value   : in out Interfaces.Unsigned_8;
                             Success : out    Boolean
                            );

   procedure U8_To_HexDigit (
                             Value : in  Interfaces.Unsigned_8;
                             MSD   : in  Boolean;
                             LCase : in  Boolean;
                             C     : out Character
                            );

end LLutils;

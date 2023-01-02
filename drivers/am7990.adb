-----------------------------------------------------------------------------------------------------------------------
--                                                     SweetAda                                                      --
-----------------------------------------------------------------------------------------------------------------------
-- __HDS__                                                                                                           --
-- __FLN__ am7990.adb                                                                                                --
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

with LLutils;

package body Am7990 is

   --========================================================================--
   --                                                                        --
   --                                                                        --
   --                           Local declarations                           --
   --                                                                        --
   --                                                                        --
   --========================================================================--

   use LLutils;

   --========================================================================--
   --                                                                        --
   --                                                                        --
   --                           Package subprograms                          --
   --                                                                        --
   --                                                                        --
   --========================================================================--

   ----------------------------------------------------------------------------
   -- Register_Read
   ----------------------------------------------------------------------------
   function Register_Read (
                           Descriptor : Am7990_Descriptor_Type;
                           Register   : Am7990_Register_Type
                          ) return Unsigned_16 is
   begin
      Descriptor.Write_16 (
                           Build_Address (
                                          Descriptor.Base_Address,
                                          RAP_OFFSET,
                                          Descriptor.Scale_Address
                                         ),
                           Am7990_Register_Type'Enum_Rep (Register)
                          );
      return Descriptor.Read_16 (
                                 Build_Address (
                                                Descriptor.Base_Address,
                                                RDP_OFFSET,
                                                Descriptor.Scale_Address
                                               )
                                );
   end Register_Read;

   ----------------------------------------------------------------------------
   -- Register_Write
   ----------------------------------------------------------------------------
   procedure Register_Write (
                             Descriptor : in Am7990_Descriptor_Type;
                             Register   : in Am7990_Register_Type;
                             Value      : in Unsigned_16
                            ) is
   begin
      Descriptor.Write_16 (
                           Build_Address (
                                          Descriptor.Base_Address,
                                          RAP_OFFSET,
                                          Descriptor.Scale_Address
                                         ),
                           Am7990_Register_Type'Enum_Rep (Register)
                          );
      Descriptor.Write_16 (
                           Build_Address (
                                          Descriptor.Base_Address,
                                          RDP_OFFSET,
                                          Descriptor.Scale_Address
                                         ),
                           Value
                          );
   end Register_Write;

end Am7990;

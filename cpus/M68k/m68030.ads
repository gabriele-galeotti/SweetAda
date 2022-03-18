-----------------------------------------------------------------------------------------------------------------------
--                                                     SweetAda                                                      --
-----------------------------------------------------------------------------------------------------------------------
-- __HDS__                                                                                                           --
-- __FLN__ m68030.ads                                                                                                --
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

package M68030 is

   --========================================================================--
   --                                                                        --
   --                                                                        --
   --                               Public part                              --
   --                                                                        --
   --                                                                        --
   --========================================================================--

   ----------------------------------------------------------------------------
   -- M68030-style MMU
   ----------------------------------------------------------------------------

   subtype UDT_Type is Bits_2;

   UDT_INVALID  : constant UDT_Type := 2#00#;
   UDT_RESIDENT : constant UDT_Type := 2#11#;

   type Root_Table_Descriptor_Type is
   record
      UDT                   : UDT_Type;
      Write_Protected       : Boolean;
      Used                  : Boolean;
      Pointer_Table_Address : Bits_23;
   end record with
      Size => 32;
   for Root_Table_Descriptor_Type use
   record
      UDT                   at 0 range 0 .. 1;
      Write_Protected       at 0 range 2 .. 2;
      Used                  at 0 range 3 .. 3;
      Pointer_Table_Address at 0 range 9 .. 31;
   end record;

   type Root_Table_Type is array (0 .. 2**7 - 1) of Root_Table_Descriptor_Type with
      Pack      => True,
      Alignment => 2**9;

   PAGESIZE4k : constant Bits_1 := 0;
   PAGESIZE8k : constant Bits_1 := 1;

   -- Translation Control Register
   type TCR_Register_Type is
   record
      Page_Size : Bits_1;
      Enable    : Boolean;
   end record with
      Size => 16;
   for TCR_Register_Type use
   record
      Page_Size at 0 range 14 .. 14;
      Enable    at 0 range 15 .. 15;
   end record;

   procedure CRP_Set (CRP_Address : in Address) with
      Inline => True;
   procedure SRP_Set (SRP_Address : in Address) with
      Inline => True;
   procedure TCR_Set (Value : in TCR_Register_Type) with
      Inline => True;

end M68030;

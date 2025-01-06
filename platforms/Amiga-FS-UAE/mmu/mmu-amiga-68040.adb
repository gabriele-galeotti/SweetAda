-----------------------------------------------------------------------------------------------------------------------
--                                                     SweetAda                                                      --
-----------------------------------------------------------------------------------------------------------------------
-- __HDS__                                                                                                           --
-- __FLN__ mmu-amiga-68040.adb                                                                                       --
-- __DSC__                                                                                                           --
-- __HSH__ e69de29bb2d1d6434b8b29ae775ad8c2e48c5391                                                                  --
-- __HDE__                                                                                                           --
-----------------------------------------------------------------------------------------------------------------------
-- Copyright (C) 2020-2025 Gabriele Galeotti                                                                         --
--                                                                                                                   --
-- SweetAda web page: http://sweetada.org                                                                            --
-- contact address: gabriele.galeotti@sweetada.org                                                                   --
-- This work is licensed under the terms of the MIT License.                                                         --
-- Please consult the LICENSE.txt file located in the top-level directory.                                           --
-----------------------------------------------------------------------------------------------------------------------

with System.Storage_Elements;
with Interfaces;
with Bits;
with LLutils;

package body MMU.Amiga
   is

   --========================================================================--
   --                                                                        --
   --                                                                        --
   --                           Local declarations                           --
   --                                                                        --
   --                                                                        --
   --========================================================================--

   use System.Storage_Elements;
   use Interfaces;
   use Bits;
   use LLutils;

   -- Memory space
   type Memory_Descriptor_Type is record
      Base_Address   : Integer_Address;
      Descriptor_Ptr : Page4k_Ptr;
   end record;

   Page_Table_RAM1     : aliased Page4k_Type with Suppress_Initialization => True; -- RAM 256k
   Page_Table_RAM2     : aliased Page4k_Type with Suppress_Initialization => True; -- RAM 512k
   Page_Table_RAM3     : aliased Page4k_Type with Suppress_Initialization => True; -- RAM 768k
   Page_Table_RAM4     : aliased Page4k_Type with Suppress_Initialization => True; -- RAM 1M
   Page_Table_CIA      : aliased Page4k_Type with Suppress_Initialization => True; -- CIAs
   Page_Table_CUSTOM   : aliased Page4k_Type with Suppress_Initialization => True; -- CUSTOM
   Page_Table_ZORROII1 : aliased Page4k_Type with Suppress_Initialization => True; -- ZORROII 1
   Page_Table_ZORROII2 : aliased Page4k_Type with Suppress_Initialization => True; -- ZORROII 2
   Page_Table_ROM      : aliased Page4k_Type with Suppress_Initialization => True; -- ROM

   Memory_Space : constant array (Natural range <>) of Memory_Descriptor_Type :=
      [
       (Base_Address => 16#0000_0000#, Descriptor_Ptr => Page_Table_RAM1'Access),
       (Base_Address => 16#0004_0000#, Descriptor_Ptr => Page_Table_RAM2'Access),
       (Base_Address => 16#0008_0000#, Descriptor_Ptr => Page_Table_RAM3'Access),
       (Base_Address => 16#000C_0000#, Descriptor_Ptr => Page_Table_RAM4'Access),
       (Base_Address => 16#00BC_0000#, Descriptor_Ptr => Page_Table_CIA'Access),
       (Base_Address => 16#00DC_0000#, Descriptor_Ptr => Page_Table_CUSTOM'Access),
       (Base_Address => 16#00E8_0000#, Descriptor_Ptr => Page_Table_ZORROII1'Access),
       (Base_Address => 16#00EC_0000#, Descriptor_Ptr => Page_Table_ZORROII2'Access),
       (Base_Address => 16#00FC_0000#, Descriptor_Ptr => Page_Table_ROM'Access)
      ];

   --========================================================================--
   --                                                                        --
   --                                                                        --
   --                           Package subprograms                          --
   --                                                                        --
   --                                                                        --
   --========================================================================--

   procedure Setup
      is
      Page_Address : Integer_Address;
   begin
      MMU.Init;
      -- 1st 32-MB block, 128 * 256-kB blocks, 0x00000000..0x02000000
      Root_Table (0) := (
         UDT    => UDT_RESIDENT, -- Upper Level Descriptor Type
         W      => False,        -- Write Protected
         U      => False,        -- Used
         PTA    => Bits_23 (Select_Address_Bits (Pointer_Table (0)'Address, 9, 31)),
         others => <>
         );
      -- 1-1 mapping
      for Idx in Memory_Space'Range loop
         Page_Address := Memory_Space (Idx).Base_Address;
         Page_Setup (Memory_Space (Idx).Descriptor_Ptr, To_Address (Page_Address));
         Pointer_Table (Natural (Page_Address / 2**18)) := (
             PAGESIZE => PAGESIZE4k,
             UDT      => UDT_RESIDENT,
             W        => False,
             U        => False,
             PTA4     => Bits_24 (Select_Address_Bits (Memory_Space (Idx).Descriptor_Ptr.all (0)'Address, 8, 31)),
             others   => <>
            );
      end loop;
      MMU.Enable;
   end Setup;

end MMU.Amiga;

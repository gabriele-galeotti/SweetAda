-----------------------------------------------------------------------------------------------------------------------
--                                                     SweetAda                                                      --
-----------------------------------------------------------------------------------------------------------------------
-- __HDS__                                                                                                           --
-- __FLN__ mmu.adb                                                                                                   --
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

with System;
with System.Storage_Elements;
with Interfaces;
with Bits;
with LLutils;
with M68040;

package body MMU is

   --========================================================================--
   --                                                                        --
   --                                                                        --
   --                           Local declarations                           --
   --                                                                        --
   --                                                                        --
   --========================================================================--

   use System;
   use System.Storage_Elements;
   use Interfaces;
   use Bits;
   use LLutils;
   use M68040;

   -- RI: A31 .. A25, 128 * 32 MByte blocks

   type Root_Table_Type is array (Natural range <>) of RTDSC_Type with
      Alignment => 2**8,
      Pack      => True;

   Root_Table : aliased Root_Table_Type (0 .. 127) with
      Volatile                => True,
      Suppress_Initialization => True;

   -- PI: A24 .. A18, 128 * 256 kByte blocks

pragma Warnings (Off, "pragma Pack affects convention ""C"" components");
   type Pointer_Table_4k_Type is array (Natural range <>) of PTDSC_Type (PAGESIZE => PAGESIZE4k) with
      Alignment => 2**9,
      Pack      => True;
pragma Warnings (On, "pragma Pack affects convention ""C"" components");

   Pointer_Table : aliased Pointer_Table_4k_Type (0 .. 127) with
      Volatile                => True,
      Suppress_Initialization => True;

   -- PGI: A17 .. A12/13

   type Page4k_Type is array (0 .. 63) of P4DSC_Type with
      Alignment => 2**8,
      Pack      => True;

   type Page4k_Ptr is access all Page4k_Type;

   -- Memory space

   type Memory_Descriptor_Type is
   record
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

   -- local subprograms

   procedure Page_Setup (P : in Page4k_Ptr; BA : in Address);

   --========================================================================--
   --                                                                        --
   --                                                                        --
   --                           Package subprograms                          --
   --                                                                        --
   --                                                                        --
   --========================================================================--

   ----------------------------------------------------------------------------
   -- Page_Setup
   ----------------------------------------------------------------------------
   procedure Page_Setup (P : in Page4k_Ptr; BA : in Address) is
      Page         : P4DSC_Type;
      Base_Address : Address := BA;
   begin
      Page := (
               PDT => PDT_RESIDENT, -- Page Descriptor Type
               W   => False,        -- Write Protected
               U   => False,        -- Used
               M   => False,        -- Modified
               CM  => CM_NC,        -- Cache Mode
               S   => False,        -- Supervisor Protected
               U0  => 0,            -- User Page Attributes
               U1  => 0,            -- User Page Attributes
               G   => True,         -- Global
               UR0 => 0,            -- User Reserved
               PA4 => 0             -- Physical Address
              );
      for Idx in P.all'Range loop
         Page.PA4 := Bits_20 (Select_Address_Bits (Base_Address, 12, 31));
         P.all (Idx) := Page;
         Base_Address := @ + 16#1000#;
      end loop;
   end Page_Setup;

   ----------------------------------------------------------------------------
   -- Init
   ----------------------------------------------------------------------------
   procedure Init is
      Page_Address : Integer_Address;
   begin
      -- Root table cleanup
      for Idx in Root_Table'Range loop
         Root_Table (Idx) := (
                              UDT    => UDT_INVALID, -- Upper Level Descriptor Type
                              W      => False,       -- Write Protected
                              U      => False,       -- Used
                              PTA    => 0,           -- Pointer Table Address
                              others => <>
                             );
      end loop;
      -- Pointer table cleanup
      for Idx in Pointer_Table'Range loop
         Pointer_Table (Idx) := (
                                 PAGESIZE => PAGESIZE4k,
                                 UDT      => UDT_INVALID,
                                 W        => False,
                                 U        => False,
                                 PTA4     => 0,
                                 others   => <>
                                );
      end loop;
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
         Pointer_Table (Natural (Page_Address / 2**18)) :=
            (
             PAGESIZE => PAGESIZE4k,
             UDT      => UDT_RESIDENT,
             W        => False,
             U        => False,
             PTA4     => Bits_24 (Select_Address_Bits (Memory_Space (Idx).Descriptor_Ptr.all (0)'Address, 8, 31)),
             others   => <>
            );
      end loop;
      -- Enable MMU.
      -- URP_Set (Root_Table (0)'Address);
      SRP_Set (Root_Table (0)'Address);
      PFLUSHA;
      TCR_Set ((
                P      => PAGESIZE4k,
                E      => True,
                others => <>
               ));
   end Init;

end MMU;

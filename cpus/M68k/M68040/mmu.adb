-----------------------------------------------------------------------------------------------------------------------
--                                                     SweetAda                                                      --
-----------------------------------------------------------------------------------------------------------------------
-- __HDS__                                                                                                           --
-- __FLN__ mmu.adb                                                                                                   --
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

with System.Storage_Elements;
with Interfaces;
with Bits;
with LLutils;

package body MMU
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
   procedure Page_Setup
      (P  : in Page4k_Ptr;
       BA : in Address)
      is
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
   -- Enable
   ----------------------------------------------------------------------------
   procedure Enable
      is
   begin
      -- URP_Set (Root_Table (0)'Address);
      SRP_Set (Root_Table (0)'Address);
      PFLUSHA;
      TCR_Set ((
         P      => PAGESIZE4k,
         E      => True,
         others => <>
         ));
   end Enable;

   ----------------------------------------------------------------------------
   -- Init
   ----------------------------------------------------------------------------
   procedure Init
      is
      Page_Address : Integer_Address;
   begin
      for Idx in Root_Table'Range loop
         Root_Table (Idx) := (
            UDT    => UDT_INVALID, -- Upper Level Descriptor Type
            W      => False,       -- Write Protected
            U      => False,       -- Used
            PTA    => 0,           -- Pointer Table Address
            others => <>
            );
      end loop;
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
   end Init;

end MMU;

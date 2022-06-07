-----------------------------------------------------------------------------------------------------------------------
--                                                     SweetAda                                                      --
-----------------------------------------------------------------------------------------------------------------------
-- __HDS__                                                                                                           --
-- __FLN__ mmu.adb                                                                                                   --
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
with Bits;
with CPU;
with CPU_x86;
with CPU_i586;

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
   use Bits;
   use CPU;
   use CPU_x86;
   use CPU_i586;

   PD : aliased PD4M_Type with
      Volatile                => True,
      Suppress_Initialization => True;

   --========================================================================--
   --                                                                        --
   --                                                                        --
   --                           Package subprograms                          --
   --                                                                        --
   --                                                                        --
   --========================================================================--

   ----------------------------------------------------------------------------
   -- Init
   ----------------------------------------------------------------------------
   -- 4-MiB page version (PSE)
   ----------------------------------------------------------------------------
   procedure Init is
      CR0                      : CR0_Type;
      CR3                      : CR3_Type;
      CR4                      : CR4_Type;
      Page_Frame_Address_Start : Address;
   begin
      -- clear page directory to prevent false mappings
      Page_Frame_Address_Start := To_Address (16#0000_0000#);
      for Index in PD'Range loop
         PD (Index)     := PDENTRY_4M_INVALID;
         PD (Index).PFA := Select_Address_Bits_PDE (Page_Frame_Address_Start);
         Page_Frame_Address_Start := @ + PAGESIZE4M;
      end loop;
      -- 1-1 map
      PD (16#000#).P := True; -- 0x00000000-0x003FFFFF 1st 4 MiB
      PD (16#3FB#).P := True; -- IOAPIC_BASEADDRESS 0xFEC00000, LAPIC_BASEADDRESS 0xFEE00000
      -- enable 4-MiB paging by setting PSE
      CR4     := CR4_Read;
      CR4.PSE := True;
      CR4.PAE := False;
      CR4_Write (CR4);
      -- writing to CR3 does a TLB flush
      CR3     := CR3_Read;
      CR3.PWT := False;
      CR3.PCD := False;
      CR3.PDB := Select_Address_Bits_PFA (PD'Address);
      CR3_Write (CR3);
      -- enable paging
      CR0    := CR0_Read;
      CR0.PG := True;
      CR0_Write (CR0);
   end Init;

end MMU;

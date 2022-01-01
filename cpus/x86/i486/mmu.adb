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

   PD : aliased PD4k_Type with
      Volatile                => True,
      Suppress_Initialization => True;

   -- first page table
   PTE0 : aliased PT_Type with
      Volatile => True;

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
   -- 4-KiB page version
   ----------------------------------------------------------------------------

   procedure Init is
      CR0                      : CR0_Register_Type;
      CR3                      : CR3_Register_Type;
      Page_Frame_Address_Start : Address;
      Page_Frame_Address_End   : Address;
   begin
      -- clear page directory to prevent false mappings
      for Index in PD'Range loop
         PD (Index) := (
                        PS                 => PAGESELECT4k,
                        Present            => False,
                        RW                 => 1,
                        US                 => 1,
                        PWT                => 0,
                        PCD                => 0,
                        A                  => 0,
                        Page_Table_Address => 0
                       );
      end loop;
      Page_Frame_Address_Start := To_Address (16#0000_0000#);
      -- enable all PTE #0 page table entries (1024 * 4 KiB = 4 MiB)
      for Index in PTE0'Range loop
         Page_Frame_Address_End := Page_Frame_Address_Start + PAGESIZE4k;
         PTE0 (Index) := (
                          Present            => True,
                          RW                 => 1,
                          US                 => 1,
                          PWT                => 0,
                          PCD                => 0,
                          A                  => 0,
                          D                  => 0,
                          PAT                => 0,
                          G                  => 0,
                          Page_Frame_Address => Select_Address_Bits_PFA (Page_Frame_Address_Start)
                         );
         Page_Frame_Address_Start := Page_Frame_Address_End;
      end loop;
      -- enable PTE #0 in page directory
      PD (0).Page_Table_Address := Select_Address_Bits_PFA (PTE0'Address);
      PD (0).Present := True;
      -- writing to CR3 does a TLB flush
      CR3 := CR3_Read;
      CR3.PWT                    := False;
      CR3.PCD                    := False;
      CR3.Page_Directory_Address := Select_Address_Bits_PFA (PD'Address);
      CR3_Write (CR3);
      -- enable paging
      CR0 := CR0_Read;
      CR0.PG := True;
      CR0_Write (CR0);
   end Init;

end MMU;

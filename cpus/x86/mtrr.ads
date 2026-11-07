-----------------------------------------------------------------------------------------------------------------------
--                                                     SweetAda                                                      --
-----------------------------------------------------------------------------------------------------------------------
-- __HDS__                                                                                                           --
-- __FLN__ mtrr.ads                                                                                                  --
-- __DSC__                                                                                                           --
-- __HSH__ e69de29bb2d1d6434b8b29ae775ad8c2e48c5391                                                                  --
-- __HDE__                                                                                                           --
-----------------------------------------------------------------------------------------------------------------------
-- Copyright (C) 2020-2026 Gabriele Galeotti                                                                         --
--                                                                                                                   --
-- SweetAda web page: http://sweetada.org                                                                            --
-- contact address: gabriele.galeotti@sweetada.org                                                                   --
-- This work is licensed under the terms of the MIT License.                                                         --
-- Please consult the LICENSE.txt file located in the top-level directory.                                           --
-----------------------------------------------------------------------------------------------------------------------

pragma Restrictions (No_Elaboration_Code);

with System;
with Interfaces;
with Bits;
with i586;

package MTRR
is

   --========================================================================--
   --                                                                        --
   --                                                                        --
   --                               Public part                              --
   --                                                                        --
   --                                                                        --
   --========================================================================--

   use System;
   use Interfaces;
   use Bits;
   use i586;

   -- Table 11-8. Memory Types That Can Be Encoded in MTRRs

   type MemoryType_Type is new Bits_8 range 0 .. 16#06#;

   Uncacheable     : constant MemoryType_Type := 16#00#; -- UC
   Write_Combining : constant MemoryType_Type := 16#01#; -- WC
   Reserved1       : constant MemoryType_Type := 16#02#;
   Reserved2       : constant MemoryType_Type := 16#03#;
   Write_through   : constant MemoryType_Type := 16#04#; -- WT
   Write_protected : constant MemoryType_Type := 16#05#; -- WP
   Writeback       : constant MemoryType_Type := 16#06#; -- WB

   -- 11.11.1 MTRR Feature Identification

   IA32_MTRRCAP : constant MSR_Type := 16#0000_00FE#;

   type IA32_MTRRCAP_Type is record
      VCNT      : Unsigned_8; -- Number of variable range registers
      FIX       : Boolean;    -- Fixed range registers supported
      Reserved1 : Bits_1;
      WC        : Boolean;    -- Write-combining memory type supported
      SMRR      : Boolean;    -- SMRR interface supported
      Reserved2 : Bits_52;
   end record
      with Bit_Order => Low_Order_First,
           Size      => 64;
   for IA32_MTRRCAP_Type use record
      VCNT      at 0 range  0 ..  7;
      FIX       at 0 range  8 ..  8;
      Reserved1 at 0 range  9 ..  9;
      WC        at 0 range 10 .. 10;
      SMRR      at 0 range 11 .. 11;
      Reserved2 at 0 range 12 .. 63;
   end record;

   -- 11.11.2.1 IA32_MTRR_DEF_TYPE MSR

   IA32_MTRR_DEF_TYPE : constant MSR_Type := 16#0000_02FF#;

   -- __INF__ use "Typ3" instead of "Type"
   type IA32_MTRR_DEF_TYPE_Type is record
      Typ3      : MemoryType_Type;      -- Default memory type
      Reserved1 : Bits_2          := 0;
      FE        : Boolean;              -- Fixed-range MTRRs enable/disable
      E         : Boolean;              -- MTRR enable/disable
      Reserved2 : Bits_52         := 0;
   end record
      with Bit_Order => Low_Order_First,
           Size      => 64;
   for IA32_MTRR_DEF_TYPE_Type use record
      Typ3      at 0 range  0 ..  7;
      Reserved1 at 0 range  8 ..  9;
      FE        at 0 range 10 .. 10;
      E         at 0 range 11 .. 11;
      Reserved2 at 0 range 12 .. 63;
   end record;

   -- 11.11.2.2 Fixed Range MTRRs

   IA32_MTRR_FIX64K_00000 : constant MSR_Type := 16#0000_0250#;

   type IA32_MTRR_FIX64K_00000_Type is record
      RANGE_00000_0FFFF : MemoryType_Type;
      RANGE_10000_1FFFF : MemoryType_Type;
      RANGE_20000_2FFFF : MemoryType_Type;
      RANGE_30000_3FFFF : MemoryType_Type;
      RANGE_40000_4FFFF : MemoryType_Type;
      RANGE_50000_5FFFF : MemoryType_Type;
      RANGE_60000_6FFFF : MemoryType_Type;
      RANGE_70000_7FFFF : MemoryType_Type;
   end record
      with Bit_Order => Low_Order_First,
           Size      => 64;
   for IA32_MTRR_FIX64K_00000_Type use record
      RANGE_00000_0FFFF at 0 range  0 ..  7;
      RANGE_10000_1FFFF at 0 range  8 .. 15;
      RANGE_20000_2FFFF at 0 range 16 .. 23;
      RANGE_30000_3FFFF at 0 range 24 .. 31;
      RANGE_40000_4FFFF at 0 range 32 .. 39;
      RANGE_50000_5FFFF at 0 range 40 .. 47;
      RANGE_60000_6FFFF at 0 range 48 .. 55;
      RANGE_70000_7FFFF at 0 range 56 .. 63;
   end record;

   IA32_MTRR_FIX64K_80000 : constant MSR_Type := 16#0000_0258#;

   type IA32_MTRR_FIX16K_80000_Type is record
      RANGE_80000_83FFF : MemoryType_Type;
      RANGE_84000_87FFF : MemoryType_Type;
      RANGE_88000_8BFFF : MemoryType_Type;
      RANGE_8C000_8FFFF : MemoryType_Type;
      RANGE_90000_93FFF : MemoryType_Type;
      RANGE_94000_97FFF : MemoryType_Type;
      RANGE_98000_9BFFF : MemoryType_Type;
      RANGE_9C000_9FFFF : MemoryType_Type;
   end record
      with Bit_Order => Low_Order_First,
           Size      => 64;
   for IA32_MTRR_FIX16K_80000_Type use record
      RANGE_80000_83FFF at 0 range  0 ..  7;
      RANGE_84000_87FFF at 0 range  8 .. 15;
      RANGE_88000_8BFFF at 0 range 16 .. 23;
      RANGE_8C000_8FFFF at 0 range 24 .. 31;
      RANGE_90000_93FFF at 0 range 32 .. 39;
      RANGE_94000_97FFF at 0 range 40 .. 47;
      RANGE_98000_9BFFF at 0 range 48 .. 55;
      RANGE_9C000_9FFFF at 0 range 56 .. 63;
   end record;

   IA32_MTRR_FIX64K_A0000 : constant MSR_Type := 16#0000_0259#;

   type IA32_MTRR_FIX16K_A0000_Type is record
      RANGE_A0000_A3FFF : MemoryType_Type;
      RANGE_A4000_A7FFF : MemoryType_Type;
      RANGE_A8000_ABFFF : MemoryType_Type;
      RANGE_AC000_AFFFF : MemoryType_Type;
      RANGE_B0000_B3FFF : MemoryType_Type;
      RANGE_B4000_B7FFF : MemoryType_Type;
      RANGE_B8000_BBFFF : MemoryType_Type;
      RANGE_BC000_BFFFF : MemoryType_Type;
   end record
      with Bit_Order => Low_Order_First,
           Size      => 64;
   for IA32_MTRR_FIX16K_A0000_Type use record
      RANGE_A0000_A3FFF at 0 range  0 ..  7;
      RANGE_A4000_A7FFF at 0 range  8 .. 15;
      RANGE_A8000_ABFFF at 0 range 16 .. 23;
      RANGE_AC000_AFFFF at 0 range 24 .. 31;
      RANGE_B0000_B3FFF at 0 range 32 .. 39;
      RANGE_B4000_B7FFF at 0 range 40 .. 47;
      RANGE_B8000_BBFFF at 0 range 48 .. 55;
      RANGE_BC000_BFFFF at 0 range 56 .. 63;
   end record;

   IA32_MTRR_FIX64K_C0000 : constant MSR_Type := 16#0000_0268#;

   type IA32_MTRR_FIX4K_C0000_Type is record
      RANGE_C0000_C0FFF : MemoryType_Type;
      RANGE_C1000_C1FFF : MemoryType_Type;
      RANGE_C2000_C2FFF : MemoryType_Type;
      RANGE_C3000_C3FFF : MemoryType_Type;
      RANGE_C4000_C4FFF : MemoryType_Type;
      RANGE_C5000_C5FFF : MemoryType_Type;
      RANGE_C6000_C6FFF : MemoryType_Type;
      RANGE_C7000_C7FFF : MemoryType_Type;
   end record
      with Bit_Order => Low_Order_First,
           Size      => 64;
   for IA32_MTRR_FIX4K_C0000_Type use record
      RANGE_C0000_C0FFF at 0 range  0 ..  7;
      RANGE_C1000_C1FFF at 0 range  8 .. 15;
      RANGE_C2000_C2FFF at 0 range 16 .. 23;
      RANGE_C3000_C3FFF at 0 range 24 .. 31;
      RANGE_C4000_C4FFF at 0 range 32 .. 39;
      RANGE_C5000_C5FFF at 0 range 40 .. 47;
      RANGE_C6000_C6FFF at 0 range 48 .. 55;
      RANGE_C7000_C7FFF at 0 range 56 .. 63;
   end record;

   IA32_MTRR_FIX64K_C8000 : constant MSR_Type := 16#0000_0269#;

   type IA32_MTRR_FIX4K_C8000_Type is record
      RANGE_C8000_C8FFF : MemoryType_Type;
      RANGE_C9000_C9FFF : MemoryType_Type;
      RANGE_CA000_CAFFF : MemoryType_Type;
      RANGE_CB000_CBFFF : MemoryType_Type;
      RANGE_CC000_CCFFF : MemoryType_Type;
      RANGE_CD000_CDFFF : MemoryType_Type;
      RANGE_CE000_CEFFF : MemoryType_Type;
      RANGE_CF000_CFFFF : MemoryType_Type;
   end record
      with Bit_Order => Low_Order_First,
           Size      => 64;
   for IA32_MTRR_FIX4K_C8000_Type use record
      RANGE_C8000_C8FFF at 0 range  0 ..  7;
      RANGE_C9000_C9FFF at 0 range  8 .. 15;
      RANGE_CA000_CAFFF at 0 range 16 .. 23;
      RANGE_CB000_CBFFF at 0 range 24 .. 31;
      RANGE_CC000_CCFFF at 0 range 32 .. 39;
      RANGE_CD000_CDFFF at 0 range 40 .. 47;
      RANGE_CE000_CEFFF at 0 range 48 .. 55;
      RANGE_CF000_CFFFF at 0 range 56 .. 63;
   end record;

   IA32_MTRR_FIX64K_D0000 : constant MSR_Type := 16#0000_026A#;

   type IA32_MTRR_FIX4K_D0000_Type is record
      RANGE_D0000_D0FFF : MemoryType_Type;
      RANGE_D1000_D1FFF : MemoryType_Type;
      RANGE_D2000_D2FFF : MemoryType_Type;
      RANGE_D3000_D3FFF : MemoryType_Type;
      RANGE_D4000_D4FFF : MemoryType_Type;
      RANGE_D5000_D5FFF : MemoryType_Type;
      RANGE_D6000_D6FFF : MemoryType_Type;
      RANGE_D7000_D7FFF : MemoryType_Type;
   end record
      with Bit_Order => Low_Order_First,
           Size      => 64;
   for IA32_MTRR_FIX4K_D0000_Type use record
      RANGE_D0000_D0FFF at 0 range  0 ..  7;
      RANGE_D1000_D1FFF at 0 range  8 .. 15;
      RANGE_D2000_D2FFF at 0 range 16 .. 23;
      RANGE_D3000_D3FFF at 0 range 24 .. 31;
      RANGE_D4000_D4FFF at 0 range 32 .. 39;
      RANGE_D5000_D5FFF at 0 range 40 .. 47;
      RANGE_D6000_D6FFF at 0 range 48 .. 55;
      RANGE_D7000_D7FFF at 0 range 56 .. 63;
   end record;

   IA32_MTRR_FIX64K_D8000 : constant MSR_Type := 16#0000_026B#;

   type IA32_MTRR_FIX4K_D8000_Type is record
      RANGE_D8000_D8FFF : MemoryType_Type;
      RANGE_D9000_D9FFF : MemoryType_Type;
      RANGE_DA000_DAFFF : MemoryType_Type;
      RANGE_DB000_DBFFF : MemoryType_Type;
      RANGE_DC000_DCFFF : MemoryType_Type;
      RANGE_DD000_DDFFF : MemoryType_Type;
      RANGE_DE000_DEFFF : MemoryType_Type;
      RANGE_DF000_DFFFF : MemoryType_Type;
   end record
      with Bit_Order => Low_Order_First,
           Size      => 64;
   for IA32_MTRR_FIX4K_D8000_Type use record
      RANGE_D8000_D8FFF at 0 range  0 ..  7;
      RANGE_D9000_D9FFF at 0 range  8 .. 15;
      RANGE_DA000_DAFFF at 0 range 16 .. 23;
      RANGE_DB000_DBFFF at 0 range 24 .. 31;
      RANGE_DC000_DCFFF at 0 range 32 .. 39;
      RANGE_DD000_DDFFF at 0 range 40 .. 47;
      RANGE_DE000_DEFFF at 0 range 48 .. 55;
      RANGE_DF000_DFFFF at 0 range 56 .. 63;
   end record;

   IA32_MTRR_FIX64K_E0000 : constant MSR_Type := 16#0000_026C#;

   type IA32_MTRR_FIX4K_E0000_Type is record
      RANGE_E0000_E0FFF : MemoryType_Type;
      RANGE_E1000_E1FFF : MemoryType_Type;
      RANGE_E2000_E2FFF : MemoryType_Type;
      RANGE_E3000_E3FFF : MemoryType_Type;
      RANGE_E4000_E4FFF : MemoryType_Type;
      RANGE_E5000_E5FFF : MemoryType_Type;
      RANGE_E6000_E6FFF : MemoryType_Type;
      RANGE_E7000_E7FFF : MemoryType_Type;
   end record
      with Bit_Order => Low_Order_First,
           Size      => 64;
   for IA32_MTRR_FIX4K_E0000_Type use record
      RANGE_E0000_E0FFF at 0 range  0 ..  7;
      RANGE_E1000_E1FFF at 0 range  8 .. 15;
      RANGE_E2000_E2FFF at 0 range 16 .. 23;
      RANGE_E3000_E3FFF at 0 range 24 .. 31;
      RANGE_E4000_E4FFF at 0 range 32 .. 39;
      RANGE_E5000_E5FFF at 0 range 40 .. 47;
      RANGE_E6000_E6FFF at 0 range 48 .. 55;
      RANGE_E7000_E7FFF at 0 range 56 .. 63;
   end record;

   IA32_MTRR_FIX64K_E8000 : constant MSR_Type := 16#0000_026D#;

   type IA32_MTRR_FIX4K_E8000_Type is record
      RANGE_E8000_E8FFF : MemoryType_Type;
      RANGE_E9000_E9FFF : MemoryType_Type;
      RANGE_EA000_EAFFF : MemoryType_Type;
      RANGE_EB000_EBFFF : MemoryType_Type;
      RANGE_EC000_ECFFF : MemoryType_Type;
      RANGE_ED000_EDFFF : MemoryType_Type;
      RANGE_EE000_EEFFF : MemoryType_Type;
      RANGE_EF000_EFFFF : MemoryType_Type;
   end record
      with Bit_Order => Low_Order_First,
           Size      => 64;
   for IA32_MTRR_FIX4K_E8000_Type use record
      RANGE_E8000_E8FFF at 0 range  0 ..  7;
      RANGE_E9000_E9FFF at 0 range  8 .. 15;
      RANGE_EA000_EAFFF at 0 range 16 .. 23;
      RANGE_EB000_EBFFF at 0 range 24 .. 31;
      RANGE_EC000_ECFFF at 0 range 32 .. 39;
      RANGE_ED000_EDFFF at 0 range 40 .. 47;
      RANGE_EE000_EEFFF at 0 range 48 .. 55;
      RANGE_EF000_EFFFF at 0 range 56 .. 63;
   end record;

   IA32_MTRR_FIX64K_F0000 : constant MSR_Type := 16#0000_026E#;

   type IA32_MTRR_FIX4K_F0000_Type is record
      RANGE_F0000_F0FFF : MemoryType_Type;
      RANGE_F1000_F1FFF : MemoryType_Type;
      RANGE_F2000_F2FFF : MemoryType_Type;
      RANGE_F3000_F3FFF : MemoryType_Type;
      RANGE_F4000_F4FFF : MemoryType_Type;
      RANGE_F5000_F5FFF : MemoryType_Type;
      RANGE_F6000_F6FFF : MemoryType_Type;
      RANGE_F7000_F7FFF : MemoryType_Type;
   end record
      with Bit_Order => Low_Order_First,
           Size      => 64;
   for IA32_MTRR_FIX4K_F0000_Type use record
      RANGE_F0000_F0FFF at 0 range  0 ..  7;
      RANGE_F1000_F1FFF at 0 range  8 .. 15;
      RANGE_F2000_F2FFF at 0 range 16 .. 23;
      RANGE_F3000_F3FFF at 0 range 24 .. 31;
      RANGE_F4000_F4FFF at 0 range 32 .. 39;
      RANGE_F5000_F5FFF at 0 range 40 .. 47;
      RANGE_F6000_F6FFF at 0 range 48 .. 55;
      RANGE_F7000_F7FFF at 0 range 56 .. 63;
   end record;

   IA32_MTRR_FIX64K_F8000 : constant MSR_Type := 16#0000_026F#;

   type IA32_MTRR_FIX4K_F8000_Type is record
      RANGE_F8000_F8FFF : MemoryType_Type;
      RANGE_F9000_F9FFF : MemoryType_Type;
      RANGE_FA000_FAFFF : MemoryType_Type;
      RANGE_FB000_FBFFF : MemoryType_Type;
      RANGE_FC000_FCFFF : MemoryType_Type;
      RANGE_FD000_FDFFF : MemoryType_Type;
      RANGE_FE000_FEFFF : MemoryType_Type;
      RANGE_FF000_FFFFF : MemoryType_Type;
   end record
      with Bit_Order => Low_Order_First,
           Size      => 64;
   for IA32_MTRR_FIX4K_F8000_Type use record
      RANGE_F8000_F8FFF at 0 range  0 ..  7;
      RANGE_F9000_F9FFF at 0 range  8 .. 15;
      RANGE_FA000_FAFFF at 0 range 16 .. 23;
      RANGE_FB000_FBFFF at 0 range 24 .. 31;
      RANGE_FC000_FCFFF at 0 range 32 .. 39;
      RANGE_FD000_FDFFF at 0 range 40 .. 47;
      RANGE_FE000_FEFFF at 0 range 48 .. 55;
      RANGE_FF000_FFFFF at 0 range 56 .. 63;
   end record;

end MTRR;

-----------------------------------------------------------------------------------------------------------------------
--                                                     SweetAda                                                      --
-----------------------------------------------------------------------------------------------------------------------
-- __HDS__                                                                                                           --
-- __FLN__ mmu.adb                                                                                                   --
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

with System;
with System.Storage_Elements;
with Ada.Unchecked_Conversion;
with Bits;

package body MMU
   is

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

   type Table4k_Type is array (Natural range <>) of SFPDSC_Type
      with Alignment => 16,
           Pack      => True;

   Table_1 : aliased Table4k_Type (0 .. 4095)
      with Volatile                => True,
           Suppress_Initialization => True;

   Root_Pointer : aliased RPDSC_Type;

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
      (Idx : in Natural;
       DT  : in DT_Type;
       BA  : in Unsigned_32)
      is
   begin
      -- the right shift is equivalent to mask off the first 8 bits of the
      -- address, which are occupied by the flags; this way the address
      -- (masked) appears "normally" laid out, with LSB in the 0 position
      Table_1 (Idx) := (
         DT     => DT,
         WP     => False,
         U      => False,
         M      => False,
         CI     => False,
         PA     => Bits_24 (Shift_Right (BA, 8) and 16#00FF_FFFF#),
         others => <>
         );
   end Page_Setup;

   ----------------------------------------------------------------------------
   -- Enable
   ----------------------------------------------------------------------------
   procedure Enable
      is
      TA  : Unsigned_32;
      TCR : TCR_Type;
      function To_U32 is new Ada.Unchecked_Conversion (Integer_Address, Unsigned_32);
   begin
      TA := To_U32 (To_Integer (Table_1 (0)'Address));
      Root_Pointer := (
         TA_LO  => Bits_12 (Shift_Right (LWord (TA), 4)), -- Table Address 4 .. 15
         TA_HI  => HWord (TA),                            -- Table Address 16 .. 31
         DT     => DT_VALID4,                             -- Descriptor Type
         LIMIT  => 16#4000#,                              -- Limit
         LU     => LU_UPPER,                              -- Lower/Upper
         others => <>
         );
      CRP_Set (Root_Pointer'Address);
      TCR := (
         TID    => 0,     -- Table Index
         TIC    => 0,     -- Table Index
         TIB    => 0,     -- Table Index
         TIA    => 12,    -- Table Index (1st table has 4096 entries)
         ISHIFT => 8,     -- Initial Shift 24-bit address
         PS     => PS_4k, -- Page Size (12-bit)
         FCL    => False, -- Function Code Lookup
         SRE    => False, -- use CRP
         E      => True,  -- Enable
         others => <>
         );
      TCR_Set (TCR);
   end Enable;

   ----------------------------------------------------------------------------
   -- Init
   ----------------------------------------------------------------------------
   procedure Init
      is
   begin
      for Idx in Table_1'Range loop
         Page_Setup (Idx, DT_INVALID, 0);
      end loop;
   end Init;

end MMU;

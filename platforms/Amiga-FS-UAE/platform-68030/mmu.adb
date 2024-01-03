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

with System;
with System.Storage_Elements;
with Ada.Unchecked_Conversion;
with Interfaces;
with Bits;
with M68030;

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
   use Interfaces;
   use Bits;
   use M68030;

   Root_Pointer : aliased RPDSC_Type;

   type Table4k_Type is array (Natural range <>) of SFPDSC_Type
      with Alignment => 16,
           Pack      => True;

   Table_1 : aliased Table4k_Type (0 .. 4095)
      with Volatile                => True,
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
   procedure Init is
      A   : Unsigned_32;
      TA  : Unsigned_32;
      TCR : TCR_Type;
      function To_U32 is new Ada.Unchecked_Conversion (Integer_Address, Unsigned_32);
      procedure Page_Setup
         (Idx : in Natural;
          DT  : in DT_Type;
          BA  : in Unsigned_32);
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
   begin
      -- cleanup
      for Idx in Table_1'Range loop
         Page_Setup (Idx, DT_INVALID, 0);
      end loop;
      -- RAM 1st MByte (256 * 4k)
      A := 0;
      for Idx in 0 .. 255 loop
         Page_Setup (Idx, DT_PAGEDSC, A);
         A := @ + 16#1000#;
      end loop;
      Page_Setup (16#BFD#, DT_PAGEDSC, 16#00BF_D000#); -- CIAB
      Page_Setup (16#BFE#, DT_PAGEDSC, 16#00BF_E000#); -- CIAA
      Page_Setup (16#DD2#, DT_PAGEDSC, 16#00DD_2000#); -- Gayle
      Page_Setup (16#DFF#, DT_PAGEDSC, 16#00DF_F000#); -- CUSTOM
      -- ZORROII
      A := 16#00E8_0000#;
      for Idx in 16#E80# .. 16#EFF# loop
         Page_Setup (Idx, DT_PAGEDSC, A);
         A := @ + 16#1000#;
      end loop;
      -- ROM
      A := 16#00FC_0000#;
      for Idx in 16#FC0# .. 16#FFF# loop
         Page_Setup (Idx, DT_PAGEDSC, A);
         A := @ + 16#1000#;
      end loop;
      -- enable MMU
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
   end Init;

end MMU;

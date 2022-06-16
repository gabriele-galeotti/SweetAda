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

with System;
with Interfaces;
with Bits;

package M68030 is

   --========================================================================--
   --                                                                        --
   --                                                                        --
   --                               Public part                              --
   --                                                                        --
   --                                                                        --
   --========================================================================--

   pragma Preelaborate;

   use System;
   use Interfaces;
   use Bits;

   -- 9.5.1.2 ROOT POINTER DESCRIPTOR

   type RPDSC_Type is
   record
      Unused1 : Bits_4 := 0;
      TA_LO   : Bits_12;      -- Table Address
      TA_HI   : Unsigned_16;  -- Table Address
      DT      : Bits_2;       -- Descriptor Type
      Unused2 : Bits_14 := 0;
      LIMIT   : Bits_15;      -- Limit
      LU      : Bits_1;       -- Lower/Upper
   end record with
      Bit_Order => Low_Order_First,
      Size      => 64;
   for RPDSC_Type use
   record
      Unused1 at 0 range 0 .. 3;
      TA_LO   at 0 range 4 .. 15;
      TA_HI   at 0 range 16 .. 31;
      DT      at 0 range 32 .. 33;
      Unused2 at 0 range 34 .. 47;
      LIMIT   at 0 range 48 .. 62;
      LU      at 0 range 63 .. 63;
   end record;

   -- 9.7.2 Translation Control Register

   type TCR_Type is
   record
      TID    : Bits_4;      -- Table Index
      TIC    : Bits_4;      -- Table Index
      TIB    : Bits_4;      -- Table Index
      TIA    : Bits_4;      -- Table Index
      ISHIFT : Bits_4;      -- Initial Shift
      PS     : Bits_4;      -- Page Size
      FCL    : Boolean;     -- Function Code Lookup
      SRE    : Boolean;     -- Supervisor Root Pointer Enable
      Unused : Bits_5 := 0;
      E      : Boolean;     -- Enable
   end record with
      Bit_Order => Low_Order_First,
      Size      => 32;
   for TCR_Type use
   record
      TID    at 0 range 0 .. 3;
      TIC    at 0 range 4 .. 7;
      TIB    at 0 range 8 .. 11;
      TIA    at 0 range 12 .. 15;
      ISHIFT at 0 range 16 .. 19;
      PS     at 0 range 20 .. 23;
      FCL    at 0 range 24 .. 24;
      SRE    at 0 range 25 .. 25;
      Unused at 0 range 26 .. 30;
      E      at 0 range 31 .. 31;
   end record;

   procedure CRP_Set (CRP_Address : in Address) with
      Inline => True;
   procedure SRP_Set (SRP_Address : in Address) with
      Inline => True;
   procedure TCR_Set (Value : in TCR_Type) with
      Inline => True;

end M68030;

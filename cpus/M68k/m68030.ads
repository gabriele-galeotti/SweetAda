-----------------------------------------------------------------------------------------------------------------------
--                                                     SweetAda                                                      --
-----------------------------------------------------------------------------------------------------------------------
-- __HDS__                                                                                                           --
-- __FLN__ m68030.ads                                                                                                --
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
with Interfaces;
with Bits;

package M68030
   with Preelaborate => True
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

   ----------------------------------------------------------------------------
   -- MMU
   ----------------------------------------------------------------------------

   type PS_Type is new Bits_4;
   PS_256 : constant PS_Type := 2#1000#; -- 256 bytes
   PS_512 : constant PS_Type := 2#1001#; -- 512 bytes
   PS_1k  : constant PS_Type := 2#1010#; -- 1k bytes
   PS_2k  : constant PS_Type := 2#1011#; -- 2k bytes
   PS_4k  : constant PS_Type := 2#1100#; -- 4k bytes
   PS_8k  : constant PS_Type := 2#1101#; -- 8k bytes
   PS_16k : constant PS_Type := 2#1110#; -- 16k bytes
   PS_32k : constant PS_Type := 2#1111#; -- 32k bytes

   type DT_Type is new Bits_2;
   DT_INVALID : constant := 2#00#; -- invalid descriptor
   DT_PAGEDSC : constant := 2#01#; -- page descriptor
   DT_VALID4  : constant := 2#10#; -- next table to be accessed contains short-format descriptors
   DT_VALID8  : constant := 2#11#; -- next table to be accessed contains long-format descriptors

   -- 9.5.1.2 ROOT POINTER DESCRIPTOR

   LU_UPPER : constant := 0; -- limit field is the unsigned upper limit of the translation table indexes
   LU_LOWER : constant := 1; -- limit field is the unsigned lower limit of the translation table indexes

   type RPDSC_Type is record
      Unused   : Bits_4 := 0;
      TA_LO    : Bits_12;      -- Table Address
      TA_HI    : Unsigned_16;  -- Table Address
      DT       : Bits_2;       -- Descriptor Type
      Reserved : Bits_14 := 0;
      LIMIT    : Bits_15;      -- Limit
      LU       : Bits_1;       -- Lower/Upper
   end record
      with Bit_Order => Low_Order_First,
           Size      => 64;
   for RPDSC_Type use record
      Unused   at 0 range  0 ..  3;
      TA_LO    at 0 range  4 .. 15;
      TA_HI    at 0 range 16 .. 31;
      DT       at 0 range 32 .. 33;
      Reserved at 0 range 34 .. 47;
      LIMIT    at 0 range 48 .. 62;
      LU       at 0 range 63 .. 63;
   end record;

   -- 9.5.1.3 SHORT-FORMAT TABLE DESCRIPTOR

   type SFTDSC_Type is record
      DT : DT_Type; -- descriptor type
      WP : Boolean; -- write protection
      U  : Boolean; -- accessed (depends)
      TA : Bits_28; -- Table Address
   end record
      with Bit_Order => Low_Order_First,
           Size      => 32;
   for SFTDSC_Type use record
      DT at 0 range 0 ..  1;
      WP at 0 range 2 ..  2;
      U  at 0 range 3 ..  3;
      TA at 0 range 4 .. 31;
   end record;

   -- 9.5.1.5 SHORT-FORMAT EARLY TERMINATION PAGE DESCRIPTOR
   -- 9.5.1.7 SHORT-FORMAT PAGE DESCRIPTOR

   type SFPDSC_Type is record
      DT        : DT_Type;     -- descriptor type
      WP        : Boolean;     -- write protection
      U         : Boolean;     -- accessed (depends)
      M         : Boolean;     -- Modified
      Reserved1 : Bits_1 := 0;
      CI        : Boolean;     -- Cache Inhibit
      Reserved2 : Bits_1 := 0;
      PA        : Bits_24;     -- Page Address
   end record
      with Bit_Order => Low_Order_First,
           Size      => 32;
   for SFPDSC_Type use record
      DT        at 0 range 0 ..  1;
      WP        at 0 range 2 ..  2;
      U         at 0 range 3 ..  3;
      M         at 0 range 4 ..  4;
      Reserved1 at 0 range 5 ..  5;
      CI        at 0 range 6 ..  6;
      Reserved2 at 0 range 7 ..  7;
      PA        at 0 range 8 .. 31;
   end record;

   -- 9.7.2 Translation Control Register

   type TCR_Type is record
      TID      : Natural range 0 .. 15; -- Table Index
      TIC      : Natural range 0 .. 15; -- Table Index
      TIB      : Natural range 0 .. 15; -- Table Index
      TIA      : Natural range 0 .. 15; -- Table Index
      ISHIFT   : Natural range 0 .. 15; -- Initial Shift
      PS       : PS_Type;               -- Page Size
      FCL      : Boolean;               -- Function Code Lookup
      SRE      : Boolean;               -- Supervisor Root Pointer Enable
      Reserved : Bits_5 := 0;
      E        : Boolean;               -- Enable
   end record
      with Bit_Order => Low_Order_First,
           Size      => 32;
   for TCR_Type use record
      TID      at 0 range  0 ..  3;
      TIC      at 0 range  4 ..  7;
      TIB      at 0 range  8 .. 11;
      TIA      at 0 range 12 .. 15;
      ISHIFT   at 0 range 16 .. 19;
      PS       at 0 range 20 .. 23;
      FCL      at 0 range 24 .. 24;
      SRE      at 0 range 25 .. 25;
      Reserved at 0 range 26 .. 30;
      E        at 0 range 31 .. 31;
   end record;

   -- 9.7.3 Transparent Translation Registers

   RW_W : constant := 0; -- Write accesses transparent
   RW_R : constant := 1; -- Read accesses transparent

   type TTR_Type is record
      FCMASK    : Bits_3;      -- Function Code Mask
      Reserved1 : Bits_1 := 0;
      FCBASE    : Bits_3;      -- Function Code Base
      Reserved2 : Bits_1 := 0;
      RWM       : Boolean;     -- Read/Write Mask
      RW        : Bits_1;      -- Read/Write
      CI        : Boolean;     -- Cache Inhibit
      Reserved3 : Bits_4 := 0;
      E         : Boolean;     -- Enable
      LAM       : Unsigned_8;  -- LOGICAL ADDRESS MASK
      LAB       : Unsigned_8;  -- LOGICAL ADDRESS BASE
   end record
      with Bit_Order => Low_Order_First,
           Size      => 32;
   for TTR_Type use record
      FCMASK    at 0 range  0 ..  2;
      Reserved1 at 0 range  3 ..  3;
      FCBASE    at 0 range  4 ..  6;
      Reserved2 at 0 range  7 ..  7;
      RWM       at 0 range  8 ..  8;
      RW        at 0 range  9 ..  9;
      CI        at 0 range 10 .. 10;
      Reserved3 at 0 range 11 .. 14;
      E         at 0 range 15 .. 15;
      LAM       at 0 range 16 .. 23;
      LAB       at 0 range 24 .. 31;
   end record;

   -- 9.7.4 MMU Status Register

   type MMUSR_Type is record
      N         : Bits_3;      -- Number of Levels
      Reserved1 : Bits_3 := 0;
      T         : Boolean;     -- Transparent
      Reserved2 : Bits_2 := 0;
      M         : Boolean;     -- Modified
      I         : Boolean;     -- Invalid
      W         : Boolean;     -- Write Protected
      Reserved3 : Bits_1 := 0;
      S         : Boolean;     -- Supervisor Violation
      L         : Boolean;     -- Limit
      B         : Boolean;     -- Bus Error
   end record
      with Bit_Order => Low_Order_First,
           Size      => 16;
   for MMUSR_Type use record
      N         at 0 range  0 ..  2;
      Reserved1 at 0 range  3 ..  5;
      T         at 0 range  6 ..  6;
      Reserved2 at 0 range  7 ..  8;
      M         at 0 range  9 ..  9;
      I         at 0 range 10 .. 10;
      W         at 0 range 11 .. 11;
      Reserved3 at 0 range 12 .. 12;
      S         at 0 range 13 .. 13;
      L         at 0 range 14 .. 14;
      B         at 0 range 15 .. 15;
   end record;

   -- subprograms

   procedure CRP_Set
      (CRP_Address : in Address)
      with Inline => True;
   procedure SRP_Set
      (SRP_Address : in Address)
      with Inline => True;
   procedure TCR_Set
      (Value : in TCR_Type)
      with Inline => True;

end M68030;

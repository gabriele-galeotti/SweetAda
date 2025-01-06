-----------------------------------------------------------------------------------------------------------------------
--                                                     SweetAda                                                      --
-----------------------------------------------------------------------------------------------------------------------
-- __HDS__                                                                                                           --
-- __FLN__ m68040.ads                                                                                                --
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
with Interfaces;
with Bits;

package M68040
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

   --========================================================================--
   --                                                                        --
   --                                                                        --
   --                               Public part                              --
   --                                                                        --
   --                                                                        --
   --========================================================================--

   PAGESIZE4k : constant Bits_1 := 0; -- 4 kbytes
   PAGESIZE8k : constant Bits_1 := 1; -- 8 kbytes

   CM_WT  : constant := 2#00#; -- Cachable, Write-through
   CM_CB  : constant := 2#01#; -- Cachable, Copyback
   CM_NCS : constant := 2#10#; -- Noncachable, Serialized
   CM_NC  : constant := 2#11#; -- Noncachable

   subtype UDT_Type is Bits_2;
   UDT_INVALID   : constant UDT_Type := 2#00#;
   UDT_INVALID2  : constant UDT_Type := 2#01#;
   UDT_RESIDENT  : constant UDT_Type := 2#10#;
   UDT_RESIDENT2 : constant UDT_Type := 2#11#;

   subtype PDT_Type is Bits_2;
   PDT_INVALID   : constant PDT_Type := 2#00#;
   PDT_RESIDENT  : constant PDT_Type := 2#01#;
   PDT_INDIRECT  : constant PDT_Type := 2#10#;
   PDT_RESIDENT2 : constant PDT_Type := 2#11#;

   -- 3.2.2.1 TABLE DESCRIPTORS

   -- ROOT TABLE DESCRIPTOR (ROOT LEVEL)
   type RTDSC_Type is record
      UDT      : UDT_Type;      -- Upper Level Descriptor Type
      W        : Boolean;       -- Write Protected
      U        : Boolean;       -- Used
      Reserved : Bits_5   := 0;
      PTA      : Bits_23;       -- Pointer Table Address
   end record
      with Bit_Order => Low_Order_First,
           Size      => 32;
   for RTDSC_Type use record
      UDT      at 0 range 0 ..  1;
      W        at 0 range 2 ..  2;
      U        at 0 range 3 ..  3;
      Reserved at 0 range 4 ..  8;
      PTA      at 0 range 9 .. 31;
   end record;

   -- 4K, 8K POINTER TABLE DESCRIPTOR (POINTER LEVEL)
   type PTDSC_Type (PAGESIZE : Bits_1) is record
      UDT : UDT_Type;                 -- Upper Level Descriptor Type
      W   : Boolean;                  -- Write Protected
      U   : Boolean;                  -- Used
      case PAGESIZE is
         when PAGESIZE4k =>
            Reserved1 : Bits_4  := 0;
            PTA4      : Bits_24;      -- Page Table Address
         when PAGESIZE8k =>
            Reserved2 : Bits_3  := 0;
            PTA8      : Bits_25;      -- Page Table Address
      end case;
   end record
      with Bit_Order       => Low_Order_First,
           Size            => 32,
           Unchecked_Union => True;
   for PTDSC_Type use record
      UDT       at 0 range 0 ..  1;
      W         at 0 range 2 ..  2;
      U         at 0 range 3 ..  3;
      Reserved1 at 0 range 4 ..  7;
      PTA4      at 0 range 8 .. 31;
      Reserved2 at 0 range 4 ..  6;
      PTA8      at 0 range 7 .. 31;
   end record;

   -- 3.2.2.2 PAGE DESCRIPTORS

   type P4DSC_Type is record
      PDT : PDT_Type; -- Page Descriptor Type
      W   : Boolean;  -- Write Protected
      U   : Boolean;  -- Used
      M   : Boolean;  -- Modified
      CM  : Bits_2;   -- Cache Mode
      S   : Boolean;  -- Supervisor Protected
      U0  : Bits_1;   -- User Page Attributes
      U1  : Bits_1;   -- User Page Attributes
      G   : Boolean;  -- Global
      UR0 : Bits_1;   -- User Reserved
      PA4 : Bits_20;  -- Physical Address
   end record
      with Bit_Order => Low_Order_First,
           Size      => 32;
   for P4DSC_Type use record
      PDT at 0 range  0 ..  1;
      W   at 0 range  2 ..  2;
      U   at 0 range  3 ..  3;
      M   at 0 range  4 ..  4;
      CM  at 0 range  5 ..  6;
      S   at 0 range  7 ..  7;
      U0  at 0 range  8 ..  8;
      U1  at 0 range  9 ..  9;
      G   at 0 range 10 .. 10;
      UR0 at 0 range 11 .. 11;
      PA4 at 0 range 12 .. 31;
   end record;

   type P8DSC_Type is record
      PDT : PDT_Type; -- Page Descriptor Type
      W   : Boolean;  -- Write Protected
      U   : Boolean;  -- Used
      M   : Boolean;  -- Modified
      CM  : Bits_2;   -- Cache Mode
      S   : Boolean;  -- Supervisor Protected
      U0  : Bits_1;   -- User Page Attributes
      U1  : Bits_1;   -- User Page Attributes
      G   : Boolean;  -- Global
      UR0 : Bits_1;   -- User Reserved
      UR1 : Bits_1;   -- User Reserved
      PA8 : Bits_19;  -- Physical Address
   end record
      with Bit_Order => Low_Order_First,
           Size      => 32;
   for P8DSC_Type use record
      PDT at 0 range  0 ..  1;
      W   at 0 range  2 ..  2;
      U   at 0 range  3 ..  3;
      M   at 0 range  4 ..  4;
      CM  at 0 range  5 ..  6;
      S   at 0 range  7 ..  7;
      U0  at 0 range  8 ..  8;
      U1  at 0 range  9 ..  9;
      G   at 0 range 10 .. 10;
      UR0 at 0 range 11 .. 11;
      UR1 at 0 range 12 .. 12;
      PA8 at 0 range 13 .. 31;
   end record;

   type P48DSC_Type (PAGESIZE : Bits_1) is record
      PDT : PDT_Type;      -- Page Descriptor Type
      W   : Boolean;       -- Write Protected
      U   : Boolean;       -- Used
      M   : Boolean;       -- Modified
      CM  : Bits_2;        -- Cache Mode
      S   : Boolean;       -- Supervisor Protected
      U0  : Bits_1;        -- User Page Attributes
      U1  : Bits_1;        -- User Page Attributes
      G   : Boolean;       -- Global
      UR0 : Bits_1;        -- User Reserved
      case PAGESIZE is
         when PAGESIZE4k =>
            PA4 : Bits_20; -- Physical Address
         when PAGESIZE8k =>
            UR1 : Bits_1;  -- User Reserved
            PA8 : Bits_19; -- Physical Address
      end case;
   end record
      with Bit_Order       => Low_Order_First,
           Size            => 32,
           Unchecked_Union => True;
   for P48DSC_Type use record
      PDT at 0 range  0 ..  1;
      W   at 0 range  2 ..  2;
      U   at 0 range  3 ..  3;
      M   at 0 range  4 ..  4;
      CM  at 0 range  5 ..  6;
      S   at 0 range  7 ..  7;
      U0  at 0 range  8 ..  8;
      U1  at 0 range  9 ..  9;
      G   at 0 range 10 .. 10;
      UR0 at 0 range 11 .. 11;
      PA4 at 0 range 12 .. 31;
      UR1 at 0 range 12 .. 12;
      PA8 at 0 range 13 .. 31;
   end record;

   type PINDDSC_Type is record
      PDT : PDT_Type; -- Page Descriptor Type
      DA  : Bits_30;  -- Descriptor Address
   end record
      with Bit_Order => Low_Order_First,
           Size      => 32;
   for PINDDSC_Type use record
      PDT at 0 range 0 ..  1;
      DA  at 0 range 2 .. 31;
   end record;

   -- 3.1.2 Translation Control Register

   type TCR_Type is record
      Reserved : Bits_14 := 0;
      P        : Bits_1;       -- Page Size
      E        : Boolean;      -- Enable
   end record
      with Bit_Order => Low_Order_First,
           Size      => 16;
   for TCR_Type use record
      Reserved at 0 range  0 .. 13;
      P        at 0 range 14 .. 14;
      E        at 0 range 15 .. 15;
   end record;

   -- 3.1.3 Transparent Translation Registers

   S_U    : constant := 2#00#; -- Match only if FC2 = 0 (user mode access)
   S_S    : constant := 2#01#; -- Match only if FC2 = 1 (supervisor mode access)
   S_IGN  : constant := 2#10#; -- Ignore FC2 when matching
   S_IGN2 : constant := 2#11#; -- Ignore FC2 when matching

   type TTR_Type is record
      Reserved1 : Bits_2     := 0;
      W         : Boolean;         -- Write Protect
      Reserved2 : Bits_2     := 0;
      CM        : Bits_2;          -- Cache Mode
      Reserved3 : Bits_1     := 0;
      U0        : Bits_1;          -- User Page Attributes
      U1        : Bits_1;          -- User Page Attributes
      Reserved4 : Bits_3     := 0;
      S         : Bits_2;          -- Supervisor Mode
      E         : Boolean;         -- Enable
      LAM       : Unsigned_8;      -- Logical Address Mask
      LAB       : Unsigned_8;      -- Logical Address Base
   end record
      with Bit_Order => Low_Order_First,
           Size      => 32;
   for TTR_Type use record
      Reserved1 at 0 range  0 ..  1;
      W         at 0 range  2 ..  2;
      Reserved2 at 0 range  3 ..  4;
      CM        at 0 range  5 ..  6;
      Reserved3 at 0 range  7 ..  7;
      U0        at 0 range  8 ..  8;
      U1        at 0 range  9 ..  9;
      Reserved4 at 0 range 10 .. 12;
      S         at 0 range 13 .. 14;
      E         at 0 range 15 .. 15;
      LAM       at 0 range 16 .. 23;
      LAB       at 0 range 24 .. 31;
   end record;

   -- 3.1.4 MMU Status Register

   type MMUSR_Type is record
      R        : Boolean;      -- Resident
      T        : Boolean;      -- Transparent Translation Register Hit
      W        : Boolean;      -- Write Protect
      Reserved : Bits_1  := 0;
      M        : Boolean;      -- Modified
      CM       : Bits_2;       -- Cache Mode
      S        : Bits_1;       -- Supervisor Protection
      U0       : Bits_1;       -- User Page Attributes
      U1       : Bits_1;       -- User Page Attributes
      G        : Boolean;      -- Global
      B        : Boolean;      -- Bus Error
      PA       : Bits_20;      -- Physical Address
   end record
      with Bit_Order => Low_Order_First,
           Size      => 32;
   for MMUSR_Type use record
      R        at 0 range  0 ..  0;
      T        at 0 range  1 ..  1;
      W        at 0 range  2 ..  2;
      Reserved at 0 range  3 ..  3;
      M        at 0 range  4 ..  4;
      CM       at 0 range  5 ..  6;
      S        at 0 range  7 ..  7;
      U0       at 0 range  8 ..  8;
      U1       at 0 range  9 ..  9;
      G        at 0 range 10 .. 10;
      B        at 0 range 11 .. 11;
      PA       at 0 range 12 .. 31;
   end record;

   -- subprograms

   procedure URP_Set
      (URP_Address : in Address)
      with Inline => True;
   procedure SRP_Set
      (SRP_Address : in Address)
      with Inline => True;
   procedure TCR_Set
      (Value : in TCR_Type)
      with Inline => True;
   procedure PFLUSHA
      with Inline => True;

end M68040;

-----------------------------------------------------------------------------------------------------------------------
--                                                     SweetAda                                                      --
-----------------------------------------------------------------------------------------------------------------------
-- __HDS__                                                                                                           --
-- __FLN__ mips-r3000.ads                                                                                            --
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

package R3000
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
   -- Status Register (CP0 register 12)
   ----------------------------------------------------------------------------

   type Status_Type is record
      IEc     : Boolean;      -- IEc is set 0 to prevent the CPU taking any interrupt, 1 to enable.
      KUc     : Boolean;      -- KUc is set 1 when running with kernel privileges, 0 for user mode.
      IEp     : Boolean;      -- IE previous
      KUp     : Boolean;      -- KU previous
      IEo     : Boolean;      -- IE old
      KUo     : Boolean;      -- KU old
      Unused1 : Bits_2  := 0;
      IM0     : Boolean;      -- interrupt mask 0 - software interrupt
      IM1     : Boolean;      -- interrupt mask 1 - software interrupt
      IM2     : Boolean;      -- interrupt mask 2 - int0 - Cause bit reads 1 when pin low (active)
      IM3     : Boolean;      -- interrupt mask 3 - int1
      IM4     : Boolean;      -- interrupt mask 4 - int2
      IM5     : Boolean;      -- interrupt mask 5 - int3 - Usual choice for FPA.
      IM6     : Boolean;      -- interrupt mask 6 - int4
      IM7     : Boolean;      -- interrupt mask 7 - int5
      IsC     : Boolean;      -- isolate (data) cache
      SwC     : Boolean;      -- swap caches
      PZ      : Boolean;      -- When set, cache parity bits are written as zero and not checked.
      CM      : Boolean;      -- shows the result of the last load operation performed with the D-cache isolated
      PE      : Boolean;      -- set if a cache parity error has occurred.
      TS      : Boolean;      -- TLB shutdown
      BEV     : Boolean;      -- boot exception vectors
      Unused2 : Bits_2  := 0;
      RE      : Boolean;      -- reverse endianness in user mode
      Unused3 : Bits_2  := 0;
      CU0     : Boolean;      -- co-processor 0 usable
      CU1     : Boolean;      -- co-processor 1 usable
      Unused4 : Bits_2  := 0;
   end record
      with Bit_Order => Low_Order_First,
           Size      => 32;
   for Status_Type use record
      IEc     at 0 range  0 ..  0;
      KUc     at 0 range  1 ..  1;
      IEp     at 0 range  2 ..  2;
      KUp     at 0 range  3 ..  3;
      IEo     at 0 range  4 ..  4;
      KUo     at 0 range  5 ..  5;
      Unused1 at 0 range  6 ..  7;
      IM0     at 0 range  8 ..  8;
      IM1     at 0 range  9 ..  9;
      IM2     at 0 range 10 .. 10;
      IM3     at 0 range 11 .. 11;
      IM4     at 0 range 12 .. 12;
      IM5     at 0 range 13 .. 13;
      IM6     at 0 range 14 .. 14;
      IM7     at 0 range 15 .. 15;
      IsC     at 0 range 16 .. 16;
      SwC     at 0 range 17 .. 17;
      PZ      at 0 range 18 .. 18;
      CM      at 0 range 19 .. 19;
      PE      at 0 range 20 .. 20;
      TS      at 0 range 21 .. 21;
      BEV     at 0 range 22 .. 22;
      Unused2 at 0 range 23 .. 24;
      RE      at 0 range 25 .. 25;
      Unused3 at 0 range 26 .. 27;
      CU0     at 0 range 28 .. 28;
      CU1     at 0 range 29 .. 29;
      Unused4 at 0 range 30 .. 31;
   end record;

   function CP0_SR_Read
      return Status_Type
      with Inline => True;
   procedure CP0_SR_Write
      (Value : in Status_Type)
      with Inline => True;

   ----------------------------------------------------------------------------
   -- PRId register (CP0 register 15)
   ----------------------------------------------------------------------------

   type PRId_Type is record
      Rev    : Unsigned_8;
      Imp    : Unsigned_8;
      Unused : Bits_16    := 0;
   end record
      with Bit_Order => Low_Order_First,
           Size      => 32;
   for PRId_Type use record
      Rev    at 0 range  0 ..  7;
      Imp    at 0 range  8 .. 15;
      Unused at 0 range 16 .. 31;
   end record;

   function CP0_PRId_Read
      return PRId_Type
      with Inline => True;

   ----------------------------------------------------------------------------
   -- Cache management
   ----------------------------------------------------------------------------

   function Cache_Size
      (ICache : Boolean)
      return Unsigned_32;

   ----------------------------------------------------------------------------
   -- Interrupts
   ----------------------------------------------------------------------------

   subtype Intcontext_Type is Unsigned_32;
   type Irq_Id_Type is new Natural;

   procedure Intcontext_Get
      (Intcontext : out Intcontext_Type)
      with Inline => True;
   procedure Intcontext_Set
      (Intcontext : in Intcontext_Type)
      with Inline => True;

   procedure Irq_Enable
      with Inline => True;
   procedure Irq_Disable
      with Inline => True;

end R3000;

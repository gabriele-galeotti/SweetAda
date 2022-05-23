-----------------------------------------------------------------------------------------------------------------------
--                                                     SweetAda                                                      --
-----------------------------------------------------------------------------------------------------------------------
-- __HDS__                                                                                                           --
-- __FLN__ x86_64.ads                                                                                                --
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
with Ada.Unchecked_Conversion;
with Interfaces;
with Bits;

package x86_64 is

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
   -- Basic definitions
   ----------------------------------------------------------------------------

   -- Privilege Levels

   type PL_Type is new Bits_2;
   PL0 : constant PL_Type := 0; -- RING0
   PL1 : constant PL_Type := 1; -- RING1
   PL2 : constant PL_Type := 2; -- RING2
   PL3 : constant PL_Type := 3; -- RING3

   ----------------------------------------------------------------------------
   -- Registers
   ----------------------------------------------------------------------------

   -- RFLAGS

   type RFLAGS_Type is
   record
      CF        : Boolean; -- Carry Flag
      Reserved1 : Bits_1;
      PF        : Boolean; -- Parity Flag
      Reserved2 : Bits_1;
      AF        : Boolean; -- Auxiliary Carry Flag
      Reserved3 : Bits_1;
      ZF        : Boolean; -- Zero Flag
      SF        : Boolean; -- Sign Flag
      TF        : Boolean; -- Trap Flag
      IFlag     : Boolean; -- Interrupt Enable Flag
      DF        : Boolean; -- Direction Flag
      OFlag     : Boolean; -- Overflow Flag
      IOPL      : PL_Type; -- I/O Privilege Level
      NT        : Boolean; -- Nested Task Flag
      Reserved4 : Bits_1;
      RF        : Boolean; -- Resume Flag
      VM        : Boolean; -- Virtual-8086 Mode
      AC        : Boolean; -- Alignment Check / Access Control
      VIF       : Boolean; -- Virtual Interrupt Flag
      VIP       : Boolean; -- Virtual Interrupt Pending
      ID        : Boolean; -- Identification Flag
      Reserved5 : Bits_10;
      Reserved6 : Bits_32;
   end record with
      Bit_Order => Low_Order_First,
      Size      => 64;
   for RFLAGS_Type use
   record
      CF        at 0 range 0 .. 0;
      Reserved1 at 0 range 1 .. 1;
      PF        at 0 range 2 .. 2;
      Reserved2 at 0 range 3 .. 3;
      AF        at 0 range 4 .. 4;
      Reserved3 at 0 range 5 .. 5;
      ZF        at 0 range 6 .. 6;
      SF        at 0 range 7 .. 7;
      TF        at 0 range 8 .. 8;
      IFlag     at 0 range 9 .. 9;
      DF        at 0 range 10 .. 10;
      OFlag     at 0 range 11 .. 11;
      IOPL      at 0 range 12 .. 13;
      NT        at 0 range 14 .. 14;
      Reserved4 at 0 range 15 .. 15;
      RF        at 0 range 16 .. 16;
      VM        at 0 range 17 .. 17;
      AC        at 0 range 18 .. 18;
      VIF       at 0 range 19 .. 19;
      VIP       at 0 range 20 .. 20;
      ID        at 0 range 21 .. 21;
      Reserved5 at 0 range 22 .. 31;
      Reserved6 at 0 range 32 .. 63;
   end record;

   -- CR0

   type CR0_Type is
   record
      PE        : Boolean;      -- Protected mode Enable
      MP        : Boolean;      -- Monitor Co-processor
      EM        : Boolean;      -- Emulation (no x87 FPU unit present)
      TS        : Boolean;      -- Task Switched
      ET        : Boolean;      -- Extension Type (287/387)
      NE        : Boolean;      -- Numeric Error (x87 error reporting)
      Reserved1 : Bits_10;
      WP        : Boolean;      -- Write Protect (RO pages, CPL3)
      Reserved2 : Bits_1;
      AM        : Boolean;      -- Alignment Mask (EFLAGS[AC], CPL3)
      Reserved3 : Bits_10;
      NW        : Boolean;      -- Not Write through
      CD        : Boolean;      -- Cache Disable
      PG        : Boolean;      -- Paging enable
      Reserved4 : Bits_32 := 0;
   end record with
      Bit_Order => Low_Order_First,
      Size      => 64;
   for CR0_Type use
   record
      PE        at 0 range 0 .. 0;
      MP        at 0 range 1 .. 1;
      EM        at 0 range 2 .. 2;
      TS        at 0 range 3 .. 3;
      ET        at 0 range 4 .. 4;
      NE        at 0 range 5 .. 5;
      Reserved1 at 0 range 6 .. 15;
      WP        at 0 range 16 .. 16;
      Reserved2 at 0 range 17 .. 17;
      AM        at 0 range 18 .. 18;
      Reserved3 at 0 range 19 .. 28;
      NW        at 0 range 29 .. 29;
      CD        at 0 range 30 .. 30;
      PG        at 0 range 31 .. 31;
      Reserved4 at 0 range 32 .. 63;
   end record;

   function To_CR0 is new Ada.Unchecked_Conversion (Unsigned_64, CR0_Type);
   function To_U64 is new Ada.Unchecked_Conversion (CR0_Type, Unsigned_64);

   -- IA32_EFER

   IA32_EFER : constant := 16#C000_0080#;

   type IA32_EFER_Type is
   record
      SCE       : Boolean; -- SYSCALL Enable
      Reserved1 : Bits_7;
      LME       : Boolean; -- IA-32e Mode Enable
      Reserved2 : Bits_1;
      LMA       : Boolean; -- IA-32e Mode Active
      NXE       : Boolean; -- Execute Disable Bit Enable
      Reserved3 : Bits_20;
      Reserved4 : Bits_32;
   end record with
      Bit_Order => Low_Order_First,
      Size      => 64;
   for IA32_EFER_Type use
   record
      SCE       at 0 range 0 .. 0;
      Reserved1 at 0 range 1 .. 7;
      LME       at 0 range 8 .. 8;
      Reserved2 at 0 range 9 .. 9;
      LMA       at 0 range 10 .. 10;
      NXE       at 0 range 11 .. 11;
      Reserved3 at 0 range 12 .. 31;
      Reserved4 at 0 range 32 .. 63;
   end record;

   function To_IA32_EFER is new Ada.Unchecked_Conversion (Unsigned_64, IA32_EFER_Type);
   function To_U64 is new Ada.Unchecked_Conversion (IA32_EFER_Type, Unsigned_64);

   ----------------------------------------------------------------------------
   -- MSRs
   ----------------------------------------------------------------------------

   function MSR_Read (MSRn : Unsigned_32) return Unsigned_64 with
      Inline => True;

   ----------------------------------------------------------------------------
   -- Generic definitions
   ----------------------------------------------------------------------------

   procedure NOP with
      Inline => True;

   ----------------------------------------------------------------------------
   -- Exceptions and interrupts
   ----------------------------------------------------------------------------

   EXCEPTION_ITEMS : constant := 256;

   type Irq_State_Type is new CPU_Unsigned;
   -- Exception_Id_Type is a subtype of Unsigned_32, allowing handlers to
   -- accept the 32-bit parameter code from low-level exception frames
   subtype Exception_Id_Type is Unsigned_32 range 0 .. EXCEPTION_ITEMS - 1;
   subtype Irq_Id_Type is Exception_Id_Type range 16#20# .. Exception_Id_Type'Last;

   procedure Irq_Enable;
   procedure Irq_Disable;
   function Irq_State_Get return Irq_State_Type;
   procedure Irq_State_Set (Irq_State : in Irq_State_Type);

   ----------------------------------------------------------------------------
   -- Locking
   ----------------------------------------------------------------------------

   LOCK_UNLOCK : constant CPU_Unsigned := 0;
   LOCK_LOCK   : constant CPU_Unsigned := 1;

   type Lock_Type is
   record
      Lock : aliased CPU_Unsigned := LOCK_UNLOCK with Atomic => True;
   end record with
      Size => CPU_Unsigned'Size;

   procedure Lock_Try (Lock_Object : in out Lock_Type; Success : out Boolean);
   procedure Lock (Lock_Object : in out Lock_Type);
   procedure Unlock (Lock_Object : out Lock_Type);

end x86_64;

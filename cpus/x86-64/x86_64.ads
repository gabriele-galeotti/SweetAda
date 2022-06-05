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

   pragma Preelaborate;

   use System;
   use Interfaces;
   use Bits;

   ----------------------------------------------------------------------------
   -- Basic definitions
   ----------------------------------------------------------------------------

   -- Privilege Levels

   type PL_Type is new Bits_2;
   PL0 : constant PL_Type := 2#00#; -- RING0
   PL1 : constant PL_Type := 2#01#; -- RING1
   PL2 : constant PL_Type := 2#10#; -- RING2
   PL3 : constant PL_Type := 2#11#; -- RING3

   -- Table Indicator

   type TI_Type is new Bits_1;
   TI_GDT : constant TI_Type := 0; -- GDT
   TI_LDT : constant TI_Type := 1; -- current LDT

   -- Segment Selectors

   type Selector_Index_Type is new Bits_13; -- theoretically GDT could have 8192 entries

   type Selector_Type is
   record
      RPL   : PL_Type;             -- requested Privilege Level
      TI    : TI_Type;             -- GDT or LDT
      Index : Selector_Index_Type; -- index into table
   end record with
      Bit_Order => Low_Order_First,
      Size      => 16;
   for Selector_Type use
   record
      RPL   at 0 range 0 .. 1;
      TI    at 0 range 2 .. 2;
      Index at 0 range 3 .. 15;
   end record;

   NULL_Segment : constant Selector_Type := (PL0, TI_GDT, 0);

   -- Descriptor type

   type Descriptor_Type is new Bits_1;
   DESCRIPTOR_SYSTEM   : constant := 0; -- "system" TSS/GATE segment (system objects)
   DESCRIPTOR_CODEDATA : constant := 1; -- "storage application" code/data segment (memory objects)

   -- Segment/Gate descriptor type

   type Segment_Gate_Type is new Bits_4;
   -- Code- and Data-Segment Types
   --                         EWA
   DATA_R    : constant := 2#0000#; -- Data Read-Only
   DATA_RA   : constant := 2#0001#; -- Data Read-Only, accessed
   DATA_RW   : constant := 2#0010#; -- Data Read/Write
   DATA_RWA  : constant := 2#0011#; -- Data Read/Write, accessed
   DATA_RE   : constant := 2#0100#; -- Data Read-Only, expand-down
   DATA_REA  : constant := 2#0101#; -- Data Read-Only, expand-down, accessed
   DATA_RWE  : constant := 2#0110#; -- Data Read/Write, expand-down
   DATA_RWEA : constant := 2#0111#; -- Data Read/Write, expand-down, accessed
   --                         CRA
   CODE_E    : constant := 2#1000#; -- Code Execute-Only
   CODE_EA   : constant := 2#1001#; -- Code Execute-Only, accessed
   CODE_ER   : constant := 2#1010#; -- Code Execute/Read
   CODE_ERA  : constant := 2#1011#; -- Code Execute/Read, accessed
   CODE_EC   : constant := 2#1100#; -- Code Execute-Only, conforming
   CODE_ECA  : constant := 2#1101#; -- Code Execute-Only, conforming, accessed
   CODE_ERC  : constant := 2#1110#; -- Code Execute/Read, conforming
   CODE_ERCA : constant := 2#1111#; -- Code Execute/Read, conforming, accessed
   -- System-Segment and Gate-Descriptor Types
   --                                       32-Bit Mode            IA-32e Mode
   SYSGATE_DSCBIG : constant := 2#0000#; -- Reserved               Upper 8 byte of an 16-byte descriptor
   SYSGATE_TSSA16 : constant := 2#0001#; -- 16-bit TSS (Available) Reserved
   SYSGATE_LDT    : constant := 2#0010#; -- LDT                    LDT
   SYSGATE_TSSB16 : constant := 2#0011#; -- 16-bit TSS (Busy)      Reserved
   SYSGATE_CALL16 : constant := 2#0100#; -- 16-bit Call Gate       Reserved
   SYSGATE_TASK   : constant := 2#0101#; -- Task Gate              Reserved
   SYSGATE_INT16  : constant := 2#0110#; -- 16-bit Interrupt Gate  Reserved
   SYSGATE_TRAP16 : constant := 2#0111#; -- 16-bit Trap Gate       Reserved
   SYSGATE_RES1   : constant := 2#1000#; -- Reserved               Reserved
   SYSGATE_TSSA   : constant := 2#1001#; -- 32-bit TSS (Available) 64-bit TSS (Available)
   SYSGATE_RES2   : constant := 2#1010#; -- Reserved               Reserved
   SYSGATE_TSSB   : constant := 2#1011#; -- 32-bit TSS (Busy)      64-bit TSS (Busy)
   SYSGATE_CALL   : constant := 2#1100#; -- 32-bit Call Gate       64-bit Call Gate
   SYSGATE_RES3   : constant := 2#1101#; -- Reserved               Reserved
   SYSGATE_INT    : constant := 2#1110#; -- 32-bit Interrupt Gate  64-bit Interrupt Gate
   SYSGATE_TRAP   : constant := 2#1111#; -- 32-bit Trap Gate       64-bit Trap Gate

   -- Default Operand Size

   type Default_OpSize_Type is new Bits_1;
   DEFAULT_OPSIZE16 : constant := 0;
   DEFAULT_OPSIZE32 : constant := 1;

   -- Segment Granularity

   type Granularity_Type is new Bits_1;
   GRANULARITY_BYTE : constant := 0;
   GRANULARITY_4k   : constant := 1;

   ----------------------------------------------------------------------------
   -- Segment descriptor
   ----------------------------------------------------------------------------

   SEGMENT_DESCRIPTOR_ALIGNMENT : constant := 8;

   type Segment_Descriptor_Type is
   record
      Limit_LO : Unsigned_16;         -- Segment Limit 0 .. 15
      Base_LO  : Unsigned_16;         -- Segment base address 0 .. 15
      Base_MI  : Unsigned_8;          -- Segment base address 16 .. 23
      SegType  : Segment_Gate_Type;   -- Segment type
      S        : Descriptor_Type;     -- Descriptor type
      DPL      : PL_Type;             -- Descriptor privilege level
      P        : Boolean;             -- Segment present
      Limit_HI : Bits_4;              -- Segment Limit 16 .. 19
      AVL      : Bits_1;              -- Available for use by system software
      L        : Boolean;             -- 64-bit code segment (IA-32e mode only)
      D_B      : Default_OpSize_Type; -- Default operation size
      G        : Granularity_Type;    -- Granularity
      Base_HI  : Unsigned_8;          -- Segment base address 24 .. 31
   end record with
      Alignment => SEGMENT_DESCRIPTOR_ALIGNMENT,
      Bit_Order => Low_Order_First,
      Size      => 64;
   for Segment_Descriptor_Type use
   record
      Limit_LO at 0 range 0 .. 15;
      Base_LO  at 2 range 0 .. 15;
      Base_MI  at 4 range 0 .. 7;
      SegType  at 5 range 0 .. 3;
      S        at 5 range 4 .. 4;
      DPL      at 5 range 5 .. 6;
      P        at 5 range 7 .. 7;
      Limit_HI at 6 range 0 .. 3;
      AVL      at 6 range 4 .. 4;
      L        at 6 range 5 .. 5;
      D_B      at 6 range 6 .. 6;
      G        at 6 range 7 .. 7;
      Base_HI  at 7 range 0 .. 7;
   end record;

   SEGMENT_DESCRIPTOR_INVALID : constant Segment_Descriptor_Type :=
      (
       Limit_LO => 0,
       Base_LO  => 0,
       Base_MI  => 0,
       SegType  => SYSGATE_RES1,
       S        => DESCRIPTOR_SYSTEM,
       DPL      => PL0,
       P        => False,
       Limit_HI => 0,
       AVL      => 0,
       L        => True,
       D_B      => DEFAULT_OPSIZE16,
       G        => GRANULARITY_4k,
       Base_HI  => 0
      );

-- pragma Warnings (Off, "size is not a multiple of alignment");
   type GDT_Descriptor_Type is
   record
      Limit   : Unsigned_16;
      Base_LO : Unsigned_16;
      Base_HI : Unsigned_16;
   end record with
      Alignment => 2,
      Bit_Order => Low_Order_First,
      Size      => 48;
   for GDT_Descriptor_Type use
   record
      Limit   at 0 range 0 .. 15;
      Base_LO at 2 range 0 .. 15;
      Base_HI at 4 range 0 .. 15;
   end record;
-- pragma Warnings (On, "size is not a multiple of alignment");

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

   -- CR3

   type CR3_Type is
   record
      Reserved1 : Bits_3;
      PWT       : Boolean; -- Page-level Write-Through
      PCD       : Boolean; -- Page-level Cache Disable
      Reserved2 : Bits_7;
      PDB       : Bits_52; -- Page-Directory Base
   end record with
      Bit_Order => Low_Order_First,
      Size      => 64;
   for CR3_Type use
   record
      Reserved1 at 0 range 0 .. 2;
      PWT       at 0 range 3 .. 3;
      PCD       at 0 range 4 .. 4;
      Reserved2 at 0 range 5 .. 11;
      PDB       at 0 range 12 .. 63;
   end record;

   function To_CR3 is new Ada.Unchecked_Conversion (Unsigned_64, CR3_Type);
   function To_U64 is new Ada.Unchecked_Conversion (CR3_Type, Unsigned_64);

   -- CR4

   type CR4_Type is
   record
      VME        : Boolean;      -- Virtual-8086 Mode Extensions
      PVI        : Boolean;      -- Protected-Mode Virtual Interrupts
      TSD        : Boolean;      -- Time Stamp Disable
      DE         : Boolean;      -- Debugging Extensions
      PSE        : Boolean;      -- Page Size Extensions
      PAE        : Boolean;      -- Physical Address Extension
      MCE        : Boolean;      -- Machine-Check Enable
      PGE        : Boolean;      -- Page Global Enable
      PCE        : Boolean;      -- Performance-Monitoring Counter Enable
      OSFXSR     : Boolean;      -- Operating System Support for FXSAVE and FXRSTOR instructions
      OSXMMEXCPT : Boolean;      -- Operating System Support for Unmasked SIMD Floating-Point Exceptions
      Reserved1  : Bits_2;
      VMXE       : Boolean;      -- VMX-Enable Bit
      SMXE       : Boolean;      -- SMX-Enable Bit
      Reserved2  : Bits_1;
      FSGSBASE   : Boolean;      -- FSGSBASE-Enable Bit
      PCIDE      : Boolean;      -- PCID-Enable Bit
      OSXSAVE    : Boolean;      -- XSAVE and Processor Extended States-Enable Bit
      Reserved3  : Bits_1;
      SMEP       : Boolean;      -- SMEP-Enable Bit
      SMAP       : Boolean;      -- SMAP-Enable Bit
      PKE        : Boolean;      -- Protection-Key-Enable Bit
      Reserved4  : Bits_9;
      Reserved5  : Bits_32 := 0;
   end record with
      Bit_Order => Low_Order_First,
      Size      => 64;
   for CR4_Type use
   record
      VME        at 0 range 0 .. 0;
      PVI        at 0 range 1 .. 1;
      TSD        at 0 range 2 .. 2;
      DE         at 0 range 3 .. 3;
      PSE        at 0 range 4 .. 4;
      PAE        at 0 range 5 .. 5;
      MCE        at 0 range 6 .. 6;
      PGE        at 0 range 7 .. 7;
      PCE        at 0 range 8 .. 8;
      OSFXSR     at 0 range 9 .. 9;
      OSXMMEXCPT at 0 range 10 .. 10;
      Reserved1  at 0 range 11 .. 12;
      VMXE       at 0 range 13 .. 13;
      SMXE       at 0 range 14 .. 14;
      Reserved2  at 0 range 15 .. 15;
      FSGSBASE   at 0 range 16 .. 16;
      PCIDE      at 0 range 17 .. 17;
      OSXSAVE    at 0 range 18 .. 18;
      Reserved3  at 0 range 19 .. 19;
      SMEP       at 0 range 20 .. 20;
      SMAP       at 0 range 21 .. 21;
      PKE        at 0 range 22 .. 22;
      Reserved4  at 0 range 23 .. 31;
      Reserved5  at 0 range 32 .. 63;
   end record;

   function To_CR4 is new Ada.Unchecked_Conversion (Unsigned_64, CR4_Type);
   function To_U64 is new Ada.Unchecked_Conversion (CR4_Type, Unsigned_64);

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

   procedure Lock_Try (Lock_Object : in out Lock_Type; Success : out Boolean) with
      Inline => True;
   procedure Lock (Lock_Object : in out Lock_Type) with
      Inline => True;
   procedure Unlock (Lock_Object : out Lock_Type) with
      Inline => True;

end x86_64;

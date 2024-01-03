-----------------------------------------------------------------------------------------------------------------------
--                                                     SweetAda                                                      --
-----------------------------------------------------------------------------------------------------------------------
-- __HDS__                                                                                                           --
-- __FLN__ x86_64.ads                                                                                                --
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
with Ada.Unchecked_Conversion;
with Interfaces;
with Bits;

package x86_64
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

   type Selector_Type is record
      RPL   : PL_Type;             -- requested Privilege Level
      TI    : TI_Type;             -- GDT or LDT
      Index : Selector_Index_Type; -- index into table
   end record
      with Bit_Order => Low_Order_First,
           Size      => 16;
   for Selector_Type use record
      RPL   at 0 range 0 ..  1;
      TI    at 0 range 2 ..  2;
      Index at 0 range 3 .. 15;
   end record;

   NULL_Selector : constant Selector_Type := (PL0, TI_GDT, 0);

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

   type Segment_Descriptor_Type is record
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
   end record
      with Alignment => SEGMENT_DESCRIPTOR_ALIGNMENT,
           Bit_Order => Low_Order_First,
           Size      => 64;
   for Segment_Descriptor_Type use record
      Limit_LO at 0 range 0 .. 15;
      Base_LO  at 2 range 0 .. 15;
      Base_MI  at 4 range 0 ..  7;
      SegType  at 5 range 0 ..  3;
      S        at 5 range 4 ..  4;
      DPL      at 5 range 5 ..  6;
      P        at 5 range 7 ..  7;
      Limit_HI at 6 range 0 ..  3;
      AVL      at 6 range 4 ..  4;
      L        at 6 range 5 ..  5;
      D_B      at 6 range 6 ..  6;
      G        at 6 range 7 ..  7;
      Base_HI  at 7 range 0 ..  7;
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
       L        => False,
       D_B      => DEFAULT_OPSIZE16,
       G        => GRANULARITY_4k,
       Base_HI  => 0
      );

   ----------------------------------------------------------------------------
   -- GDT
   ----------------------------------------------------------------------------

   type GDT_Descriptor_Type is record
      Limit   : Unsigned_16;
      Base_LO : Unsigned_16;
      Base_HI : Unsigned_16;
   end record
      with Alignment => 2,
           Bit_Order => Low_Order_First,
           Size      => 48;
   for GDT_Descriptor_Type use record
      Limit   at 0 range 0 .. 15;
      Base_LO at 2 range 0 .. 15;
      Base_HI at 4 range 0 .. 15;
   end record;

   ----------------------------------------------------------------------------
   -- Exception descriptor
   ----------------------------------------------------------------------------

   EXCEPTION_DESCRIPTOR_ALIGNMENT : constant := 16;

   type Exception_Descriptor_Type is record
      Offset_LO : Unsigned_16;       -- Offset to procedure entry point 0 .. 15
      Selector  : Selector_Type;     -- Segment Selector for destination code segment
      IST       : Bits_3 := 0;       -- Interrupt Stack Table
      Reserved1 : Bits_2 := 0;
      Reserved2 : Bits_3 := 0;
      SegType   : Segment_Gate_Type; -- (D is implicit)
      Reserved3 : Bits_1 := 0;       -- (Descriptor_Type := DESCRIPTOR_SYSTEM)
      DPL       : PL_Type;           -- Descriptor Privilege Level
      P         : Boolean;           -- Segment Present flag
      Offset_MI : Unsigned_16;       -- Offset to procedure entry point 16 .. 31
      Offset_HI : Unsigned_32;       -- Offset to procedure entry point 32 .. 63
      Reserved4 : Unsigned_32;
   end record
      with Alignment => EXCEPTION_DESCRIPTOR_ALIGNMENT,
           Bit_Order => Low_Order_First,
           Size      => 128;
   for Exception_Descriptor_Type use record
      Offset_LO at 0  range 0 .. 15;
      Selector  at 2  range 0 .. 15;
      IST       at 4  range 0 ..  2;
      Reserved1 at 4  range 3 ..  4;
      Reserved2 at 4  range 5 ..  7;
      SegType   at 5  range 0 ..  3;
      Reserved3 at 5  range 4 ..  4;
      DPL       at 5  range 5 ..  6;
      P         at 5  range 7 ..  7;
      Offset_MI at 6  range 0 .. 15;
      Offset_HI at 8  range 0 .. 31;
      Reserved4 at 12 range 0 .. 31;
   end record;

   EXCEPTION_DESCRIPTOR_INVALID : constant Exception_Descriptor_Type :=
      (
       Offset_LO => 0,
       Selector  => (PL0, TI_GDT, 0),
       IST       => 0,
       SegType   => SYSGATE_RES1,
       DPL       => PL0,
       P         => False,
       Offset_MI => 0,
       Offset_HI => 0,
       others    => <>
      );

   ----------------------------------------------------------------------------
   -- IDT
   ----------------------------------------------------------------------------

   type IDT_Descriptor_Type is record
      Limit   : Unsigned_16;
      Base_LO : Unsigned_16;
      Base_MI : Unsigned_16;
      Base_HI : Unsigned_32;
   end record
      with Alignment => 2,
           Bit_Order => Low_Order_First,
           Size      => 80;
   for IDT_Descriptor_Type use record
      Limit   at 0 range 0 .. 15;
      Base_LO at 2 range 0 .. 15;
      Base_MI at 4 range 0 .. 15;
      Base_HI at 6 range 0 .. 31;
   end record;

   IDT_DESCRIPTOR_INVALID : constant IDT_Descriptor_Type :=
      (
       Limit   => 0,
       Base_LO => 0,
       Base_MI => 0,
       Base_HI => 0
      );

   EXCEPTION_ITEMS : constant := 256;

   type Irq_State_Type is new CPU_Unsigned;
   -- Exception_Id_Type is a subtype of Unsigned_32, allowing handlers to
   -- accept the 32-bit parameter code from low-level exception frames
   subtype Exception_Id_Type is Unsigned_32 range 0 .. EXCEPTION_ITEMS - 1;
   subtype Irq_Id_Type is Exception_Id_Type range 16#20# .. Exception_Id_Type'Last;

   Exception_DE : constant := 16#00#; -- Divide Error
   Exception_DB : constant := 16#01#; -- Debug Exception
   Exception_NN : constant := 16#02#; -- NMI Interrupt
   Exception_BP : constant := 16#03#; -- Breakpoint (One Byte Interrupt)
   Exception_OF : constant := 16#04#; -- Overflow
   Exception_BR : constant := 16#05#; -- BOUND Range Exceeded
   Exception_UD : constant := 16#06#; -- Invalid Opcode (Undefined Opcode)
   Exception_NM : constant := 16#07#; -- Device Not Available (No Math Coprocessor)
   Exception_DF : constant := 16#08#; -- Double Fault
   Exception_CS : constant := 16#09#; -- Coprocessor Segment Overrun (reserved)
   Exception_TS : constant := 16#0A#; -- Invalid TSS
   Exception_NP : constant := 16#0B#; -- Segment Not Present
   Exception_SS : constant := 16#0C#; -- Stack-Segment Fault
   Exception_GP : constant := 16#0D#; -- General Protection
   Exception_PF : constant := 16#0E#; -- Page Fault
   Reserved0F   : constant := 16#0F#;
   Exception_MF : constant := 16#10#; -- x87 FPU Floating-Point Error (Math Fault)
   Exception_AC : constant := 16#11#; -- Alignment Check
   Exception_MC : constant := 16#12#; -- Machine Check
   Exception_XM : constant := 16#13#; -- SIMD Floating-Point Exception
   Exception_VE : constant := 16#14#; -- Virtualization Exception
   Reserved15   : constant := 16#15#;
   Reserved16   : constant := 16#16#;
   Reserved17   : constant := 16#17#;
   Reserved18   : constant := 16#18#;
   Reserved19   : constant := 16#19#;
   Reserved1A   : constant := 16#1A#;
   Reserved1B   : constant := 16#1B#;
   Reserved1C   : constant := 16#1C#;
   Reserved1D   : constant := 16#1D#;
   Reserved1E   : constant := 16#1E#;
   Reserved1F   : constant := 16#1F#;

   String_DIVISION_BY_0        : aliased constant String := "Divide Error";
   String_DEBUG                : aliased constant String := "Debug";
   String_NMI_INTERRUPT        : aliased constant String := "NMI Interrupt";
   String_BREAKPOINT           : aliased constant String := "Breakpoint";
   String_OVERFLOW             : aliased constant String := "Overflow";
   String_ARRAY_BOUNDS         : aliased constant String := "BOUND Range Exceeded";
   String_INVALID_OPCODE       : aliased constant String := "Invalid Opcode";
   String_DEVICE_NOT_AVAILABLE : aliased constant String := "Device Not Available";
   String_DOUBLE_FAULT         : aliased constant String := "Double Fault";
   String_CP_SEGMENT_OVERRUN   : aliased constant String := "Coprocessor Segment Overrun";
   String_INVALID_TSS          : aliased constant String := "Invalid TSS";
   String_SEGMENT_NOT_PRESENT  : aliased constant String := "Segment Not Present";
   String_STACK_FAULT          : aliased constant String := "Stack Fault";
   String_GENERAL_PROTECTION   : aliased constant String := "General Protection";
   String_PAGE_FAULT           : aliased constant String := "Page-Fault";
   String_CP_ERROR             : aliased constant String := "x87 FPU Floating-Point Error";
   String_ALIGN_CHECK          : aliased constant String := "Alignment Check";
   String_MACHINE_CHECK        : aliased constant String := "Machine Check";
   String_SIMD_FP              : aliased constant String := "SIMD Floating-Point";
   String_VIRTUALIZATION       : aliased constant String := "Virtualization";
   String_UNKNOWN              : aliased constant String := "UNKNOWN";

   MsgPtr_DIVISION_BY_0        : constant access constant String := String_DIVISION_BY_0'Access;
   MsgPtr_DEBUG                : constant access constant String := String_DEBUG'Access;
   MsgPtr_NMI_INTERRUPT        : constant access constant String := String_NMI_INTERRUPT'Access;
   MsgPtr_BREAKPOINT           : constant access constant String := String_BREAKPOINT'Access;
   MsgPtr_OVERFLOW             : constant access constant String := String_OVERFLOW'Access;
   MsgPtr_ARRAY_BOUNDS         : constant access constant String := String_ARRAY_BOUNDS'Access;
   MsgPtr_INVALID_OPCODE       : constant access constant String := String_INVALID_OPCODE'Access;
   MsgPtr_DEVICE_NOT_AVAILABLE : constant access constant String := String_DEVICE_NOT_AVAILABLE'Access;
   MsgPtr_DOUBLE_FAULT         : constant access constant String := String_DOUBLE_FAULT'Access;
   MsgPtr_CP_SEGMENT_OVERRUN   : constant access constant String := String_CP_SEGMENT_OVERRUN'Access;
   MsgPtr_INVALID_TSS          : constant access constant String := String_INVALID_TSS'Access;
   MsgPtr_SEGMENT_NOT_PRESENT  : constant access constant String := String_SEGMENT_NOT_PRESENT'Access;
   MsgPtr_STACK_FAULT          : constant access constant String := String_STACK_FAULT'Access;
   MsgPtr_GENERAL_PROTECTION   : constant access constant String := String_GENERAL_PROTECTION'Access;
   MsgPtr_PAGE_FAULT           : constant access constant String := String_PAGE_FAULT'Access;
   MsgPtr_CP_ERROR             : constant access constant String := String_CP_ERROR'Access;
   MsgPtr_ALIGN_CHECK          : constant access constant String := String_ALIGN_CHECK'Access;
   MsgPtr_MACHINE_CHECK        : constant access constant String := String_MACHINE_CHECK'Access;
   MsgPtr_SIMD_FP              : constant access constant String := String_SIMD_FP'Access;
   MsgPtr_VIRTUALIZATION       : constant access constant String := String_VIRTUALIZATION'Access;
   MsgPtr_UNKNOWN              : constant access constant String := String_UNKNOWN'Access;

   type IDT_Type is array (Exception_Id_Type range <>) of Exception_Descriptor_Type
      with Pack => True;

   subtype IDT_Length_Type is Positive range 1 .. EXCEPTION_ITEMS;

   procedure LIDTR
      (IDT_Descriptor : in IDT_Descriptor_Type)
      with Inline => True;
   procedure IDT_Set
      (IDT_Descriptor : in out IDT_Descriptor_Type;
       IDT_Address    : in     Address;
       IDT_Length     : in     IDT_Length_Type)
      with Inline => True;
   procedure IDT_Set_Handler
      (IDT_Entry         : in out Exception_Descriptor_Type;
       Exception_Handler : in     Address;
       Selector          : in     Selector_Type;
       SegType           : in     Segment_Gate_Type);

   ----------------------------------------------------------------------------
   -- Registers
   ----------------------------------------------------------------------------

   -- RFLAGS

   type RFLAGS_Type is record
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
   end record
      with Bit_Order => Low_Order_First,
           Size      => 64;
   for RFLAGS_Type use record
      CF        at 0 range  0 ..  0;
      Reserved1 at 0 range  1 ..  1;
      PF        at 0 range  2 ..  2;
      Reserved2 at 0 range  3 ..  3;
      AF        at 0 range  4 ..  4;
      Reserved3 at 0 range  5 ..  5;
      ZF        at 0 range  6 ..  6;
      SF        at 0 range  7 ..  7;
      TF        at 0 range  8 ..  8;
      IFlag     at 0 range  9 ..  9;
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

   type CR0_Type is record
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
   end record
      with Bit_Order => Low_Order_First,
           Size      => 64;
   for CR0_Type use record
      PE        at 0 range  0 ..  0;
      MP        at 0 range  1 ..  1;
      EM        at 0 range  2 ..  2;
      TS        at 0 range  3 ..  3;
      ET        at 0 range  4 ..  4;
      NE        at 0 range  5 ..  5;
      Reserved1 at 0 range  6 .. 15;
      WP        at 0 range 16 .. 16;
      Reserved2 at 0 range 17 .. 17;
      AM        at 0 range 18 .. 18;
      Reserved3 at 0 range 19 .. 28;
      NW        at 0 range 29 .. 29;
      CD        at 0 range 30 .. 30;
      PG        at 0 range 31 .. 31;
      Reserved4 at 0 range 32 .. 63;
   end record;

   function To_U64 is new Ada.Unchecked_Conversion (CR0_Type, Unsigned_64);
   function To_CR0 is new Ada.Unchecked_Conversion (Unsigned_64, CR0_Type);

   -- CR3

   type CR3_Type is record
      Reserved1 : Bits_3;
      PWT       : Boolean; -- Page-level Write-Through
      PCD       : Boolean; -- Page-level Cache Disable
      Reserved2 : Bits_7;
      PDB       : Bits_52; -- Page-Directory Base
   end record
      with Bit_Order => Low_Order_First,
           Size      => 64;
   for CR3_Type use record
      Reserved1 at 0 range  0 ..  2;
      PWT       at 0 range  3 ..  3;
      PCD       at 0 range  4 ..  4;
      Reserved2 at 0 range  5 .. 11;
      PDB       at 0 range 12 .. 63;
   end record;

   function To_U64 is new Ada.Unchecked_Conversion (CR3_Type, Unsigned_64);
   function To_CR3 is new Ada.Unchecked_Conversion (Unsigned_64, CR3_Type);

   -- CR4

   type CR4_Type is record
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
   end record
      with Bit_Order => Low_Order_First,
           Size      => 64;
   for CR4_Type use record
      VME        at 0 range  0 ..  0;
      PVI        at 0 range  1 ..  1;
      TSD        at 0 range  2 ..  2;
      DE         at 0 range  3 ..  3;
      PSE        at 0 range  4 ..  4;
      PAE        at 0 range  5 ..  5;
      MCE        at 0 range  6 ..  6;
      PGE        at 0 range  7 ..  7;
      PCE        at 0 range  8 ..  8;
      OSFXSR     at 0 range  9 ..  9;
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

   function To_U64 is new Ada.Unchecked_Conversion (CR4_Type, Unsigned_64);
   function To_CR4 is new Ada.Unchecked_Conversion (Unsigned_64, CR4_Type);

   ----------------------------------------------------------------------------
   -- MSRs
   ----------------------------------------------------------------------------

   type MSR_Type is new Unsigned_32;

   IA32_P5_MC_ADDR          : constant MSR_Type := 16#0000_0000#;
   IA32_P5_MC_TYPE          : constant MSR_Type := 16#0000_0001#;
   IA32_MONITOR_FILTER_SIZE : constant MSR_Type := 16#0000_0006#;
   IA32_TIME_STAMP_COUNTER  : constant MSR_Type := 16#0000_0010#;
   IA32_PLATFORM_ID         : constant MSR_Type := 16#0000_0017#;
   IA32_APIC_BASE           : constant MSR_Type := 16#0000_001B#;
   IA32_FEATURE_CONTROL     : constant MSR_Type := 16#0000_003A#;
   IA32_TSC_ADJUST          : constant MSR_Type := 16#0000_003B#;
   IA32_BIOS_UPDT_TRIG      : constant MSR_Type := 16#0000_0079#;
   IA32_BIOS_SIGN_ID        : constant MSR_Type := 16#0000_008B#;
   IA32_SMM_MONITOR_CTL     : constant MSR_Type := 16#0000_009B#;
   IA32_SMBASE              : constant MSR_Type := 16#0000_009E#;
   IA32_PMC0                : constant MSR_Type := 16#0000_00C1#;
   IA32_PMC1                : constant MSR_Type := 16#0000_00C2#;
   IA32_PMC2                : constant MSR_Type := 16#0000_00C3#;
   IA32_PMC3                : constant MSR_Type := 16#0000_00C4#;
   IA32_PMC4                : constant MSR_Type := 16#0000_00C5#;
   IA32_PMC5                : constant MSR_Type := 16#0000_00C6#;
   IA32_PMC6                : constant MSR_Type := 16#0000_00C7#;
   IA32_PMC7                : constant MSR_Type := 16#0000_00C8#;
   IA32_MPERF               : constant MSR_Type := 16#0000_00E7#;
   IA32_APERF               : constant MSR_Type := 16#0000_00E8#;
   IA32_MTRRCAP             : constant MSR_Type := 16#0000_00FE#;
   IA32_SYSENTER_CS         : constant MSR_Type := 16#0000_0174#;
   IA32_SYSENTER_ESP        : constant MSR_Type := 16#0000_0175#;
   IA32_SYSENTER_EIP        : constant MSR_Type := 16#0000_0176#;
   IA32_EFER                : constant MSR_Type := 16#C000_0080#;

   -- IA32_APIC_BASE

   type IA32_APIC_BASE_Type is record
      Reserved1          : Bits_8;
      BSP                : Boolean; -- Indicates if the processor is the bootstrap processor (BSP).
      Reserved2          : Bits_1;
      Enable_x2APIC_mode : Boolean;
      APIC_Global_Enable : Boolean; -- Enables or disables the local APIC
      APIC_Base          : Bits_24; -- Specifies the base address of the APIC registers.
      Reserved3          : Bits_28;
   end record
      with Bit_Order => Low_Order_First,
           Size      => 64;
   for IA32_APIC_BASE_Type use record
      Reserved1          at 0 range  0 ..  7;
      BSP                at 0 range  8 ..  8;
      Reserved2          at 0 range  9 ..  9;
      Enable_x2APIC_mode at 0 range 10 .. 10;
      APIC_Global_Enable at 0 range 11 .. 11;
      APIC_Base          at 0 range 12 .. 35;
      Reserved3          at 0 range 36 .. 63;
   end record;

   function To_U64 is new Ada.Unchecked_Conversion (IA32_APIC_BASE_Type, Unsigned_64);
   function To_IA32_APIC_BASE is new Ada.Unchecked_Conversion (Unsigned_64, IA32_APIC_BASE_Type);

   -- IA32_EFER

   type IA32_EFER_Type is record
      SCE       : Boolean; -- SYSCALL Enable
      Reserved1 : Bits_7;
      LME       : Boolean; -- IA-32e Mode Enable
      Reserved2 : Bits_1;
      LMA       : Boolean; -- IA-32e Mode Active
      NXE       : Boolean; -- Execute Disable Bit Enable
      Reserved3 : Bits_20;
      Reserved4 : Bits_32;
   end record
      with Bit_Order => Low_Order_First,
           Size      => 64;
   for IA32_EFER_Type use record
      SCE       at 0 range  0 ..  0;
      Reserved1 at 0 range  1 ..  7;
      LME       at 0 range  8 ..  8;
      Reserved2 at 0 range  9 ..  9;
      LMA       at 0 range 10 .. 10;
      NXE       at 0 range 11 .. 11;
      Reserved3 at 0 range 12 .. 31;
      Reserved4 at 0 range 32 .. 63;
   end record;

   function To_U64 is new Ada.Unchecked_Conversion (IA32_EFER_Type, Unsigned_64);
   function To_IA32_EFER is new Ada.Unchecked_Conversion (Unsigned_64, IA32_EFER_Type);

   -- subprograms

   function RDMSR
      (MSR_Register_Number : MSR_Type)
      return Unsigned_64
      with Inline => True;
   procedure WRMSR
      (MSR_Register_Number : in MSR_Type;
       Value               : in Unsigned_64)
      with Inline => True;

   ----------------------------------------------------------------------------
   -- CPU helper subprograms
   ----------------------------------------------------------------------------

   -- INT $3
   Opcode_BREAKPOINT      : constant := 16#CC#;
   Opcode_BREAKPOINT_Size : constant := 1;

   BREAKPOINT_Asm_String : constant String := ".byte   0xCC";

   procedure NOP
      with Inline => True;
   procedure BREAKPOINT
      with Inline => True;
   procedure Asm_Call
      (Target_Address : in Address)
      with Inline => True;

   ----------------------------------------------------------------------------
   -- Exceptions and interrupts
   ----------------------------------------------------------------------------

   procedure Irq_Enable
      with Inline => True;
   procedure Irq_Disable
      with Inline => True;
   function Irq_State_Get
      return Irq_State_Type
      with Inline => True;
   procedure Irq_State_Set
      (Irq_State : in Irq_State_Type)
      with Inline => True;

end x86_64;

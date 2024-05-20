-----------------------------------------------------------------------------------------------------------------------
--                                                     SweetAda                                                      --
-----------------------------------------------------------------------------------------------------------------------
-- __HDS__                                                                                                           --
-- __FLN__ x86.ads                                                                                                   --
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
with Definitions;
with Bits;

package x86
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
   use System.Storage_Elements;
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
      RPL   : PL_Type             := PL0;    -- requested Privilege Level
      TI    : TI_Type             := TI_GDT; -- GDT or LDT
      Index : Selector_Index_Type := 0;      -- index into table
   end record
      with Bit_Order => Low_Order_First,
           Size      => 16;
   for Selector_Type use record
      RPL   at 0 range 0 ..  1;
      TI    at 0 range 2 ..  2;
      Index at 0 range 3 .. 15;
   end record;

   NULL_Selector : constant Selector_Type := (PL0, TI_GDT, 0);

   function To_U16 is new Ada.Unchecked_Conversion (Selector_Type, Unsigned_16);
   function To_Selector is new Ada.Unchecked_Conversion (Unsigned_16, Selector_Type);

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
   -- Registers
   ----------------------------------------------------------------------------

   EAX    : constant := 16#00#; -- 0
   EBX    : constant := 16#01#; -- 1
   ECX    : constant := 16#02#; -- 2
   EDX    : constant := 16#03#; -- 3
   ESP    : constant := 16#04#; -- 4
   EBP    : constant := 16#05#; -- 5
   ESI    : constant := 16#06#; -- 6
   EDI    : constant := 16#07#; -- 7
   EIP    : constant := 16#08#; -- 8
   EFLAGS : constant := 16#09#; -- 9
   CS     : constant := 16#0A#; -- 10
   SS     : constant := 16#0B#; -- 11
   DS     : constant := 16#0C#; -- 12
   ES     : constant := 16#0D#; -- 13
   FS     : constant := 16#0E#; -- 14
   GS     : constant := 16#0F#; -- 15
   ST0    : constant := 16#10#; -- 16
   ST1    : constant := 16#11#; -- 17
   ST2    : constant := 16#12#; -- 18
   ST3    : constant := 16#13#; -- 19
   ST4    : constant := 16#14#; -- 20
   ST5    : constant := 16#15#; -- 21
   ST6    : constant := 16#16#; -- 22
   ST7    : constant := 16#17#; -- 23
   FCTRL  : constant := 16#18#; -- 24
   FSTAT  : constant := 16#19#; -- 25
   FTAG   : constant := 16#1A#; -- 26
   FISEG  : constant := 16#1B#; -- 27
   FIOFF  : constant := 16#1C#; -- 28
   FOSEG  : constant := 16#1D#; -- 29
   FOOFF  : constant := 16#1E#; -- 30
   FOP    : constant := 16#1F#; -- 31

   subtype Register_Number_Type is Natural range EAX .. FOP;

   -- ST0 .. ST7 registers
   ST_REGISTER_SIZE : constant := 10;
   subtype ST_Register_Type is Byte_Array (0 .. ST_REGISTER_SIZE - 1);

   -- EFLAGS

   type EFLAGS_Type is record
      CF        : Boolean;      -- Carry Flag
      Reserved1 : Bits_1  := 1;
      PF        : Boolean;      -- Parity Flag
      Reserved2 : Bits_1  := 0;
      AF        : Boolean;      -- Auxiliary Carry Flag
      Reserved3 : Bits_1  := 0;
      ZF        : Boolean;      -- Zero Flag
      SF        : Boolean;      -- Sign Flag
      TF        : Boolean;      -- Trap Flag
      IFlag     : Boolean;      -- Interrupt Enable Flag
      DF        : Boolean;      -- Direction Flag
      OFlag     : Boolean;      -- Overflow Flag
      IOPL      : PL_Type;      -- I/O Privilege Level
      NT        : Boolean;      -- Nested Task Flag
      Reserved4 : Bits_1  := 0;
      RF        : Boolean;      -- Resume Flag
      VM        : Boolean;      -- Virtual-8086 Mode
      AC        : Boolean;      -- Alignment Check / Access Control
      VIF       : Boolean;      -- Virtual Interrupt Flag
      VIP       : Boolean;      -- Virtual Interrupt Pending
      ID        : Boolean;      -- Identification Flag
      Reserved5 : Bits_10 := 0;
   end record
      with Bit_Order => Low_Order_First,
           Size      => 32;
   for EFLAGS_Type use record
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
   end record;

   ----------------------------------------------------------------------------
   -- Segment descriptor
   ----------------------------------------------------------------------------

   SEGMENT_DESCRIPTOR_ALIGNMENT : constant := 8;

   type Segment_Descriptor_Type is record
      Limit_LO : Unsigned_16         := 0;                 -- Segment Limit 0 .. 15
      Base_LO  : Unsigned_16         := 0;                 -- Segment base address 0 .. 15
      Base_MI  : Unsigned_8          := 0;                 -- Segment base address 16 .. 23
      SegType  : Segment_Gate_Type   := SYSGATE_RES1;      -- Segment type
      S        : Descriptor_Type     := DESCRIPTOR_SYSTEM; -- Descriptor type
      DPL      : PL_Type             := PL0;               -- Descriptor privilege level
      P        : Boolean             := False;             -- Segment present
      Limit_HI : Bits_4              := 0;                 -- Segment Limit 16 .. 19
      AVL      : Bits_1              := 0;                 -- Available for use by system software
      L        : Boolean             := False;             -- 64-bit code segment (IA-32e mode only)
      D_B      : Default_OpSize_Type := DEFAULT_OPSIZE32;  -- Default operation size
      G        : Granularity_Type    := GRANULARITY_4k;    -- Granularity
      Base_HI  : Unsigned_8          := 0;                 -- Segment base address 24 .. 31
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
       D_B      => DEFAULT_OPSIZE32,
       G        => GRANULARITY_4k,
       Base_HI  => 0
      );

   ----------------------------------------------------------------------------
   -- GDT
   ----------------------------------------------------------------------------

   type GDT_Descriptor_Type is record
      Limit   : Unsigned_16 := 0;
      Base_LO : Unsigned_16 := 0;
      Base_HI : Unsigned_16 := 0;
   end record
      with Alignment => 2,
           Bit_Order => Low_Order_First,
           Size      => 6 * 8;
   for GDT_Descriptor_Type use record
      Limit   at 0 range 0 .. 15;
      Base_LO at 2 range 0 .. 15;
      Base_HI at 4 range 0 .. 15;
   end record;

   GDT_DESCRIPTOR_INVALID : constant GDT_Descriptor_Type :=
      (
       Limit   => 0,
       Base_LO => 0,
       Base_HI => 0
      );

   subtype GDT_Index_Type is Natural range 0 .. 2**Selector_Index_Type'Size - 1;
   type GDT_Type is array (GDT_Index_Type range <>) of Segment_Descriptor_Type
      with Pack => True;

   procedure LGDTR
      (GDT_Descriptor          : in GDT_Descriptor_Type;
       GDT_Code_Selector_Index : in GDT_Index_Type)
      with Inline => True;
   procedure GDT_Set
      (GDT_Descriptor          : in out GDT_Descriptor_Type;
       GDT_Address             : in     Address;
       GDT_Length              : in     GDT_Index_Type;
       GDT_Code_Selector_Index : in     GDT_Index_Type)
      with Inline => True;
   procedure GDT_Set_Entry
      (GDT_Entry   : in out Segment_Descriptor_Type;
       Base        : in     Address;
       Limit       : in     Storage_Offset;
       SegType     : in     Segment_Gate_Type;
       S           : in     Descriptor_Type;
       DPL         : in     PL_Type;
       P           : in     Boolean;
       D_B         : in     Default_OpSize_Type;
       G           : in     Granularity_Type);

   -- this is a memory artifact used as a jump target when reloading GDT (see LGDTR procedure)
   type Selector_Address_Target_Type is record
      Offset   : Address;
      Selector : Selector_Type;
   end record
      with Size => 6 * 8;
   for Selector_Address_Target_Type use record
      Offset   at 0 range 0 .. 31;
      Selector at 4 range 0 .. 15;
   end record;

   ----------------------------------------------------------------------------
   -- Exception descriptor
   ----------------------------------------------------------------------------

   EXCEPTION_DESCRIPTOR_ALIGNMENT : constant := 8;

   type Exception_Descriptor_Type is record
      Offset_LO : Unsigned_16;            -- Offset to procedure entry point 0 .. 15
      Selector  : Selector_Type;          -- Segment Selector for destination code segment
      Reserved1 : Bits_5            := 0;
      Reserved2 : Bits_3            := 0;
      SegType   : Segment_Gate_Type;      -- (D is implicit)
      Reserved3 : Bits_1            := 0; -- (Descriptor_Type := DESCRIPTOR_SYSTEM)
      DPL       : PL_Type;                -- Descriptor Privilege Level
      P         : Boolean;                -- Segment Present flag
      Offset_HI : Unsigned_16;            -- Offset to procedure entry point 16 .. 31
   end record
      with Alignment => EXCEPTION_DESCRIPTOR_ALIGNMENT,
           Bit_Order => Low_Order_First,
           Size      => 64;
   for Exception_Descriptor_Type use record
      Offset_LO at 0 range 0 .. 15;
      Selector  at 2 range 0 .. 15;
      Reserved1 at 4 range 0 ..  4;
      Reserved2 at 4 range 5 ..  7;
      SegType   at 5 range 0 ..  3;
      Reserved3 at 5 range 4 ..  4;
      DPL       at 5 range 5 ..  6;
      P         at 5 range 7 ..  7;
      Offset_HI at 6 range 0 .. 15;
   end record;

   EXCEPTION_DESCRIPTOR_INVALID : constant Exception_Descriptor_Type :=
      (
       Offset_LO => 0,
       Selector  => (PL0, TI_GDT, 0),
       SegType   => SYSGATE_RES1,
       DPL       => PL0,
       P         => False,
       Offset_HI => 0,
       others    => <>
      );

   ----------------------------------------------------------------------------
   -- IDT
   ----------------------------------------------------------------------------

   type IDT_Descriptor_Type is record
      Limit   : Unsigned_16;
      Base_LO : Unsigned_16;
      Base_HI : Unsigned_16;
   end record
      with Alignment => 2,
           Bit_Order => Low_Order_First,
           Size      => 6 * 8;
   for IDT_Descriptor_Type use record
      Limit   at 0 range 0 .. 15;
      Base_LO at 2 range 0 .. 15;
      Base_HI at 4 range 0 .. 15;
   end record;

   IDT_DESCRIPTOR_INVALID : constant IDT_Descriptor_Type :=
      (
       Limit   => 0,
       Base_LO => 0,
       Base_HI => 0
      );

   EXCEPTION_ITEMS : constant := 256;

   type Intcontext_Type is new CPU_Unsigned;
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
      with Pack                    => True,
           Suppress_Initialization => True;

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
   -- Paging
   ----------------------------------------------------------------------------
   -- 386s and 486 have only 4-KiB page size.
   ----------------------------------------------------------------------------

   PAGESIZE4k : constant := Definitions.kB4;
   PAGESIZE4M : constant := Definitions.MB4;

   type Page_Select_Type is new Bits_1;

   PAGESELECT4k : constant Page_Select_Type := 0;
   PAGESELECT4M : constant Page_Select_Type := 1;

   PAGE_RO : constant := 0;
   PAGE_RW : constant := 1;
   PAGE_S  : constant := 0;
   PAGE_U  : constant := 1;

   -- Page Table Entry

   type PTEntry_Type is record
      P   : Boolean; -- Present
      RW  : Bits_1;  -- Read/write
      US  : Bits_1;  -- User/supervisor
      PWT : Boolean; -- Page-level write-through
      PCD : Boolean; -- Page-level cache disable
      A   : Boolean; -- Accessed
      D   : Boolean; -- Dirty
      PAT : Boolean; -- Page Attribute Table
      G   : Boolean; -- Global
      PFA : Bits_20; -- Address of 4KB page frame
   end record
      with Bit_Order => Low_Order_First,
           Size      => 32;
   for PTEntry_Type use record
      P   at 0 range  0 ..  0;
      RW  at 0 range  1 ..  1;
      US  at 0 range  2 ..  2;
      PWT at 0 range  3 ..  3;
      PCD at 0 range  4 ..  4;
      A   at 0 range  5 ..  5;
      D   at 0 range  6 ..  6;
      PAT at 0 range  7 ..  7;
      G   at 0 range  8 ..  8;
      PFA at 0 range 12 .. 31;
   end record;

   -- Page table: 1024 entries aligned on 4k boundary

   type PT_Type is array (0 .. 2**10 - 1) of PTEntry_Type
      with Alignment               => PAGESIZE4k,
           Pack                    => True,
           Suppress_Initialization => True;

   -- Page Directory Entry

   type PDEntry_Type (PS : Page_Select_Type) is record
      P   : Boolean;         -- Present
      RW  : Bits_1;          -- Read/write
      US  : Bits_1;          -- User/supervisor
      PWT : Boolean;         -- Page-level write-through
      PCD : Boolean;         -- Page-level cache disable
      A   : Boolean;         -- Accessed
      case PS is
         when PAGESELECT4k =>
            PTA   : Bits_20; -- Address of page table
         when PAGESELECT4M =>
            D     : Boolean; -- Dirty
            G     : Boolean; -- Global
            PAT   : Boolean; -- Page Attribute Table
            PFA36 : Bits_4;  -- 36-bit address
            PFA   : Bits_10; -- Address of 4MB page frame
      end case;
   end record
      with Bit_Order => Low_Order_First,
           Size      => 32;
   for PDEntry_Type use record
      P     at 0 range  0 ..  0;
      RW    at 0 range  1 ..  1;
      US    at 0 range  2 ..  2;
      PWT   at 0 range  3 ..  3;
      PCD   at 0 range  4 ..  4;
      A     at 0 range  5 ..  5;
      D     at 0 range  6 ..  6;
      PS    at 0 range  7 ..  7;
      G     at 0 range  8 ..  8;
      PAT   at 0 range 12 .. 12;
      PFA36 at 0 range 13 .. 16;
      PFA   at 0 range 22 .. 31;
      PTA   at 0 range 12 .. 31;
   end record;

   PDENTRY_4k_INVALID : constant PDEntry_Type :=
      (
       PS  => PAGESELECT4k,
       P   => False,
       RW  => PAGE_RO,
       US  => PAGE_S,
       PWT => False,
       PCD => False,
       A   => False,
       PTA => 0
      );

   PDENTRY_4M_INVALID : constant PDEntry_Type :=
      (
       PS    => PAGESELECT4M,
       P     => False,
       RW    => PAGE_RO,
       US    => PAGE_S,
       PWT   => False,
       PCD   => False,
       A     => False,
       D     => False,
       G     => False,
       PAT   => False,
       PFA36 => 0,
       PFA   => 0
      );

   -- Page directory (4k): 1024 entries aligned on 4k boundary
   type PD4k_Type is array (0 .. 2**10 - 1) of PDEntry_Type (PAGESELECT4k)
      with Alignment               => PAGESIZE4k,
           Pack                    => True,
           Suppress_Initialization => True;

   -- offset in a 4-KiB page
   function Select_Address_Bits_OFS
      (CPU_Address : Address)
      return Bits_12
      with Inline => True;
   -- 4-KiB page
   function Select_Address_Bits_PFA
      (CPU_Address : Address)
      return Bits_20
      with Inline => True;
   -- page table entry for 4-MiB page
   function Select_Address_Bits_PTE
      (CPU_Address : Address)
      return Bits_10
      with Inline => True;
   -- page directory entry
   function Select_Address_Bits_PDE
      (CPU_Address : Address)
      return Bits_10
      with Inline => True;

   ----------------------------------------------------------------------------
   -- CRX registers
   ----------------------------------------------------------------------------

   -- CR0

   type CR0_Type is record
      PE        : Boolean; -- Protected mode Enable
      MP        : Boolean; -- Monitor Co-processor
      EM        : Boolean; -- Emulation (no x87 FPU unit present)
      TS        : Boolean; -- Task Switched
      ET        : Boolean; -- Extension Type (287/387)
      NE        : Boolean; -- Numeric Error (x87 error reporting)
      Reserved1 : Bits_10;
      WP        : Boolean; -- Write Protect (RO pages, CPL3)
      Reserved2 : Bits_1;
      AM        : Boolean; -- Alignment Mask (EFLAGS[AC], CPL3)
      Reserved3 : Bits_10;
      NW        : Boolean; -- Not Write through
      CD        : Boolean; -- Cache Disable
      PG        : Boolean; -- Paging enable
   end record
      with Bit_Order => Low_Order_First,
           Size      => 32;
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
   end record;

   -- CR3

   type CR3_Type is record
      Reserved1 : Bits_3;
      PWT       : Boolean; -- Page-level Write-Through
      PCD       : Boolean; -- Page-level Cache Disable
      Reserved2 : Bits_7;
      PDB       : Bits_20; -- Page-Directory Base
   end record
      with Bit_Order => Low_Order_First,
           Size      => 32;
   for CR3_Type use record
      Reserved1 at 0 range  0 ..  2;
      PWT       at 0 range  3 ..  3;
      PCD       at 0 range  4 ..  4;
      Reserved2 at 0 range  5 .. 11;
      PDB       at 0 range 12 .. 31;
   end record;

   -- 386s do not have CR4

   -- subprograms

   function CR0_Read
      return CR0_Type
      with Inline => True;
   procedure CR0_Write
      (Value : in CR0_Type)
      with Inline => True;
   function CR2_Read
      return Address
      with Inline => True;
   function CR3_Read
      return CR3_Type
      with Inline => True;
   procedure CR3_Write
      (Value : in CR3_Type)
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
   procedure HLT
      with Inline => True;
   procedure BREAKPOINT
      with Inline => True;
   function ESP_Read
      return Address
      with Inline => True;
   procedure Asm_Call
      (Target_Address : in Address)
      with Inline => True;

   ----------------------------------------------------------------------------
   -- Exceptions and interrupts
   ----------------------------------------------------------------------------

   type Exception_Stack_Frame_Type is record
      EIP    : Address;
      CS     : Selector_Type;
      Unused : Bits_16;
      EFLAGS : EFLAGS_Type;
   end record
      with Size => 96;
   for Exception_Stack_Frame_Type use record
      EIP    at 0 range  0 .. 31;
      CS     at 4 range  0 .. 15;
      Unused at 4 range 16 .. 31;
      EFLAGS at 8 range  0 .. 31;
   end record;

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

end x86;

-----------------------------------------------------------------------------------------------------------------------
--                                                     SweetAda                                                      --
-----------------------------------------------------------------------------------------------------------------------
-- __HDS__                                                                                                           --
-- __FLN__ cpu_x86.ads                                                                                               --
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
with System.Storage_Elements;
with Ada.Unchecked_Conversion;
with Interfaces;
with Definitions;
with Bits;

package CPU_x86 is

   --========================================================================--
   --                                                                        --
   --                                                                        --
   --                               Public part                              --
   --                                                                        --
   --                                                                        --
   --========================================================================--

   pragma Preelaborate;

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

   function To_U16 is new Ada.Unchecked_Conversion (Selector_Type, Unsigned_16);
   function To_Selector_Type is new Ada.Unchecked_Conversion (Unsigned_16, Selector_Type);

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

   GDT_Alignment : constant := 8;

   type GDT_Entry_Descriptor_Type is
   record
      Limit_Low   : Unsigned_16;
      Base_Low    : Unsigned_16;         -- base address 0 .. 15
      Base_Mid    : Unsigned_8;          -- base address 16 .. 23
      Segment     : Segment_Gate_Type;
      Descriptor  : Descriptor_Type;
      DPL         : PL_Type;
      Present     : Boolean;
      Limit_High  : Bits_4;
      AVL         : Bits_1;              -- available for use by system software
      L           : Boolean;             -- 64-bit code segment (IA-32e mode only)
      D_B         : Default_OpSize_Type;
      Granularity : Granularity_Type;
      Base_High   : Unsigned_8;          -- base address 24 .. 31
   end record with
      Alignment => GDT_Alignment,
      Size      => 64;
   for GDT_Entry_Descriptor_Type use
   record
      Limit_Low   at 0 range 0 .. 15;
      Base_Low    at 2 range 0 .. 15;
      Base_Mid    at 4 range 0 .. 7;
      Segment     at 5 range 0 .. 3;
      Descriptor  at 5 range 4 .. 4;
      DPL         at 5 range 5 .. 6;
      Present     at 5 range 7 .. 7;
      Limit_High  at 6 range 0 .. 3;
      AVL         at 6 range 4 .. 4;
      L           at 6 range 5 .. 5;
      D_B         at 6 range 6 .. 6;
      Granularity at 6 range 7 .. 7;
      Base_High   at 7 range 0 .. 7;
   end record;

   GDT_ENTRY_DESCRIPTOR_INVALID : constant GDT_Entry_Descriptor_Type :=
      (
       Base_Low    => 0,
       Base_Mid    => 0,
       Base_High   => 0,
       Limit_Low   => 0,
       Limit_High  => 0,
       Segment     => SYSGATE_RES1,
       Descriptor  => DESCRIPTOR_SYSTEM,
       DPL         => PL0,
       Present     => False,
       AVL         => 0,
       L           => False,
       D_B         => 0,
       Granularity => 0
      );

   ----------------------------------------------------------------------------
   -- GDT
   ----------------------------------------------------------------------------

pragma Warnings (Off, "size is not a multiple of alignment");
   type GDT_Descriptor_Type is
   record
      Limit     : Unsigned_16;
      Base_Low  : Unsigned_16;
      Base_High : Unsigned_16;
   end record with
      Alignment => GDT_Alignment,
      Size      => 48;
   for GDT_Descriptor_Type use
   record
      Limit     at 0 range 0 .. 15;
      Base_Low  at 2 range 0 .. 15;
      Base_High at 4 range 0 .. 15;
   end record;
pragma Warnings (On, "size is not a multiple of alignment");

   GDT_DESCRIPTOR_INVALID : constant GDT_Descriptor_Type := (0, 0, 0);

   subtype GDT_Index_Type is Natural range 0 .. 2**Selector_Index_Type'Size - 1;
   type GDT_Type is array (GDT_Index_Type range <>) of GDT_Entry_Descriptor_Type with
      Pack => True;

   procedure LGDTR (GDT_Descriptor : in GDT_Descriptor_Type; GDT_Code_Selector_Index : in GDT_Index_Type) with
      Inline => True;
   procedure GDT_Set (
                      GDT_Descriptor          : in out GDT_Descriptor_Type;
                      GDT_Address             : in     Address;
                      GDT_Length              : in     GDT_Index_Type;
                      GDT_Code_Selector_Index : in     GDT_Index_Type
                     ) with
      Inline => True;
   procedure GDT_Set_Entry (
                            GDT_Entry   : in out GDT_Entry_Descriptor_Type;
                            Base        : in     Address;
                            Limit       : in     Storage_Offset;
                            Segment     : in     Segment_Gate_Type;
                            Descriptor  : in     Descriptor_Type;
                            DPL         : in     PL_Type;
                            Present     : in     Boolean;
                            D_B         : in     Default_OpSize_Type;
                            Granularity : in     Granularity_Type
                           );

   -- this is a memory artifact used as a jump target when reloading GDT (see LGDTR procedure)
   type Selector_Address_Target_Type is
   record
      Offset   : Address;
      Selector : Selector_Type;
   end record with
      Size => 48;
   for Selector_Address_Target_Type use
   record
      Offset   at 0 range 0 .. 31;
      Selector at 4 range 0 .. 15;
   end record;

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

   -- offset in a 4-KiB page
   function Select_Address_Bits_OFS (CPU_Address : Address) return Bits_12 with
      Inline => True;
   -- 4-KiB page
   function Select_Address_Bits_PFA (CPU_Address : Address) return Bits_20 with
      Inline => True;
   -- page table entry for 4-MiB page
   function Select_Address_Bits_PTE (CPU_Address : Address) return Bits_10 with
      Inline => True;
   -- page directory entry
   function Select_Address_Bits_PDE (CPU_Address : Address) return Bits_10 with
      Inline => True;

   -- Page Table Entry

   type PTEntry_Type is
   record
      Present            : Boolean;
      RW                 : Bits_1;
      US                 : Bits_1;  -- 0 = Supervisor level, 1 = User level
      PWT                : Bits_1;
      PCD                : Bits_1;
      A                  : Bits_1;
      D                  : Bits_1;
      PAT                : Bits_1;
      G                  : Bits_1;
      Page_Frame_Address : Bits_20;
   end record with
      Bit_Order => Low_Order_First,
      Size      => 32;
   for PTEntry_Type use
   record
      Present            at 0 range 0 .. 0;
      RW                 at 0 range 1 .. 1;
      US                 at 0 range 2 .. 2;
      PWT                at 0 range 3 .. 3;
      PCD                at 0 range 4 .. 4;
      A                  at 0 range 5 .. 5;
      D                  at 0 range 6 .. 6;
      PAT                at 0 range 7 .. 7;
      G                  at 0 range 8 .. 8;
      Page_Frame_Address at 0 range 12 .. 31;
   end record;

   -- Page table: 1024 entries aligned on 4k boundary

   type PT_Type is array (0 .. 2**10 - 1) of PTEntry_Type with
      Alignment => PAGESIZE4k,
      Pack      => True;

   ----------------------------------------------------------------------------
   -- Page Directory Entry
   ----------------------------------------------------------------------------

   type PDEntry_Type (PS : Page_Select_Type) is
   record
      Present : Boolean;
      RW      : Bits_1;                      -- Read/Write
      US      : Bits_1;                      -- User/Supervisor
      PWT     : Bits_1;                      -- Page-level write-through
      PCD     : Bits_1;                      -- Page-level cache disable
      A       : Bits_1;                      -- Accessed
      case PS is
         when PAGESELECT4k =>
            Page_Table_Address    : Bits_20;
         when PAGESELECT4M =>
            D                     : Bits_1;  -- Dirty
            G                     : Bits_1;  -- Global
            PAT                   : Bits_1;  -- Page Attribute Table
            Page_Frame_Address_36 : Bits_4;
            Page_Frame_Address    : Bits_10;
      end case;
   end record with
      Bit_Order => Low_Order_First,
      Size      => 32;
   for PDEntry_Type use
   record
      Present               at 0 range 0 .. 0;
      RW                    at 0 range 1 .. 1;
      US                    at 0 range 2 .. 2;
      PWT                   at 0 range 3 .. 3;
      PCD                   at 0 range 4 .. 4;
      A                     at 0 range 5 .. 5;
      D                     at 0 range 6 .. 6;
      PS                    at 0 range 7 .. 7;
      G                     at 0 range 8 .. 8;
      PAT                   at 0 range 12 .. 12;
      Page_Frame_Address_36 at 0 range 13 .. 16;
      Page_Frame_Address    at 0 range 22 .. 31;
      Page_Table_Address    at 0 range 12 .. 31;
   end record;

   PDENTRY_4k_INVALID : constant PDEntry_Type := (PAGESELECT4k, False, 0, 0, 0, 0, 0, 0);
   PDENTRY_4M_INVALID : constant PDEntry_Type := (PAGESELECT4M, False, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0);

   -- Page directory (4k): 1024 entries aligned on 4k boundary
   type PD4k_Type is array (0 .. 2**10 - 1) of PDEntry_Type (PAGESELECT4k) with
      Alignment               => PAGESIZE4k,
      Pack                    => True,
      Suppress_Initialization => True;

   ----------------------------------------------------------------------------
   -- Registers
   ----------------------------------------------------------------------------

   -- EFLAGS

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

   type EFLAGS_Type is
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
   end record with
      Bit_Order => Low_Order_First,
      Size      => 32;
   for EFLAGS_Type use
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
   end record;

   -- CR0

   type CR0_Register_Type is
   record
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
   end record with
      Bit_Order => Low_Order_First,
      Size      => 32;
   for CR0_Register_Type use
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
   end record;

   -- CR3

   type CR3_Register_Type is
   record
      Reserved1 : Bits_3;
      PWT       : Boolean; -- Page-level write-through
      PCD       : Boolean; -- Page-level cache disable
      Reserved2 : Bits_7;
      PDB       : Bits_20; -- Physical address of the 4-KiB aligned page directory
   end record with
      Bit_Order => Low_Order_First,
      Size      => 32;
   for CR3_Register_Type use
   record
      Reserved1 at 0 range 0 .. 2;
      PWT       at 0 range 3 .. 3;
      PCD       at 0 range 4 .. 4;
      Reserved2 at 0 range 5 .. 11;
      PDB       at 0 range 12 .. 31;
   end record;

   -- 386s do not have CR4

   function ESP_Read return Address with
      Inline => True;
   function CR0_Read return CR0_Register_Type with
      Inline => True;
   procedure CR0_Write (Value : in CR0_Register_Type) with
      Inline => True;
   function CR2_Read return Address with
      Inline => True;
   function CR3_Read return CR3_Register_Type with
      Inline => True;
   procedure CR3_Write (Value : in CR3_Register_Type) with
      Inline => True;

   -- ST0 .. ST7 registers
   ST_REGISTER_SIZE : constant := 10;
   subtype ST_Register_Type is Byte_Array (0 .. ST_REGISTER_SIZE - 1);

   ----------------------------------------------------------------------------
   -- CPU helper subprograms
   ----------------------------------------------------------------------------

   -- INT $3
   Opcode_BREAKPOINT      : constant := 16#CC#;
   Opcode_BREAKPOINT_Size : constant := 1;

   BREAKPOINT_Asm_String : constant String := ".byte   0xCC";

   procedure NOP with
      Inline => True;
   procedure BREAKPOINT with
      Inline => True;
   procedure Asm_Call (Target_Address : in Address) with
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

   Exception_DE : constant Exception_Id_Type := 16#00#; -- Divide Error
   Exception_DB : constant Exception_Id_Type := 16#01#; -- Debug Exception
   Exception_NN : constant Exception_Id_Type := 16#02#; -- NMI Interrupt
   Exception_BP : constant Exception_Id_Type := 16#03#; -- Breakpoint (One Byte Interrupt)
   Exception_OF : constant Exception_Id_Type := 16#04#; -- Overflow
   Exception_BR : constant Exception_Id_Type := 16#05#; -- Bound Range Exceeded
   Exception_UD : constant Exception_Id_Type := 16#06#; -- Invalid Opcode
   Exception_NM : constant Exception_Id_Type := 16#07#; -- Device Not Available
   Exception_DF : constant Exception_Id_Type := 16#08#; -- Double Fault
   Exception_CS : constant Exception_Id_Type := 16#09#; -- Coprocessor Segment Overrun
   Exception_TS : constant Exception_Id_Type := 16#0A#; -- Invalid TSS
   Exception_NP : constant Exception_Id_Type := 16#0B#; -- Segment Not Present
   Exception_SS : constant Exception_Id_Type := 16#0C#; -- Stack-Segment Fault
   Exception_GP : constant Exception_Id_Type := 16#0D#; -- General Protection
   Exception_PF : constant Exception_Id_Type := 16#0E#; -- Page Fault
   Reserved0f   : constant Exception_Id_Type := 16#0F#;
   Exception_MF : constant Exception_Id_Type := 16#10#; -- x87 FPU Floating-Point Error
   Reserved11   : constant Exception_Id_Type := 16#11#;
   Reserved12   : constant Exception_Id_Type := 16#12#;
   Reserved13   : constant Exception_Id_Type := 16#13#;
   Reserved14   : constant Exception_Id_Type := 16#14#;
   Exception_AC : constant Exception_Id_Type := 16#11#; -- Alignment Check
   Exception_MC : constant Exception_Id_Type := 16#12#; -- Machine Check
   Exception_XM : constant Exception_Id_Type := 16#13#; -- SIMD Floating-Point Exception
   Exception_VE : constant Exception_Id_Type := 16#14#; -- Virtualization Exception
   Reserved15   : constant Exception_Id_Type := 16#15#;
   Reserved16   : constant Exception_Id_Type := 16#16#;
   Reserved17   : constant Exception_Id_Type := 16#17#;
   Reserved18   : constant Exception_Id_Type := 16#18#;
   Reserved19   : constant Exception_Id_Type := 16#19#;
   Reserved1a   : constant Exception_Id_Type := 16#1A#;
   Reserved1b   : constant Exception_Id_Type := 16#1B#;
   Reserved1c   : constant Exception_Id_Type := 16#1C#;
   Reserved1d   : constant Exception_Id_Type := 16#1D#;
   Reserved1e   : constant Exception_Id_Type := 16#1E#;
   Reserved1f   : constant Exception_Id_Type := 16#1F#;

   type Exception_Stack_Frame_Type is
   record
      EIP    : Address;
      CS     : Selector_Type;
      Unused : Bits_16;
      EFLAGS : EFLAGS_Type;
   end record with
      Size => 96;
   for Exception_Stack_Frame_Type use
   record
      EIP    at 0 range 0 .. 31;
      CS     at 4 range 0 .. 15;
      Unused at 4 range 16 .. 31;
      EFLAGS at 8 range 0 .. 31;
   end record;

   ----------------------------------------------------------------------------
   -- IDT
   ----------------------------------------------------------------------------

   IDT_Alignment : constant := 8;

   type IDT_Exception_Descriptor_Type is
   record
      Offset_Low  : Unsigned_16;
      Selector    : Selector_Type;
      Reserved    : Bits_8;
      Gate        : Segment_Gate_Type;
      Descriptor  : Descriptor_Type;
      DPL         : PL_Type;
      Present     : Boolean;
      Offset_High : Unsigned_16;
   end record with
      Alignment => IDT_Alignment,
      Size      => 64;
   for IDT_Exception_Descriptor_Type use
   record
      Offset_Low  at 0 range 0 .. 15;
      Selector    at 2 range 0 .. 15;
      Reserved    at 4 range 0 .. 7;
      Gate        at 5 range 0 .. 3;
      Descriptor  at 5 range 4 .. 4;
      DPL         at 5 range 5 .. 6;
      Present     at 5 range 7 .. 7;
      Offset_High at 6 range 0 .. 15;
   end record;

pragma Warnings (Off, "size is not a multiple of alignment");
   type IDT_Descriptor_Type is
   record
      Limit     : Unsigned_16;
      Base_Low  : Unsigned_16;
      Base_High : Unsigned_16;
   end record with
      Alignment => IDT_Alignment,
      Size      => 48;
   for IDT_Descriptor_Type use
   record
      Limit     at 0 range 0 .. 15;
      Base_Low  at 2 range 0 .. 15;
      Base_High at 4 range 0 .. 15;
   end record;
pragma Warnings (On, "size is not a multiple of alignment");

   type IDT_Type is array (Exception_Id_Type range <>) of IDT_Exception_Descriptor_Type with
      Pack => True;

   subtype IDT_Length_Type is Positive range 1 .. EXCEPTION_ITEMS;

   procedure LIDTR (IDT_Descriptor : in IDT_Descriptor_Type) with
      Inline => True;
   procedure IDT_Set (
                      IDT_Descriptor : in out IDT_Descriptor_Type;
                      IDT_Address    : in     Address;
                      IDT_Length     : in     IDT_Length_Type
                     ) with
      Inline => True;
   procedure IDT_Set_Handler (
                              IDT_Entry         : in out IDT_Exception_Descriptor_Type;
                              Exception_Handler : in     Address;
                              Selector          : in     Selector_Type;
                              Gate              : in     Segment_Gate_Type
                             );

   ----------------------------------------------------------------------------
   -- Irq handling
   ----------------------------------------------------------------------------

   procedure Irq_Enable with
      Inline => True;
   procedure Irq_Disable with
      Inline => True;
   function Irq_State_Get return Irq_State_Type with
      Inline => True;
   procedure Irq_State_Set (Irq_State : in Irq_State_Type) with
      Inline => True;

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

end CPU_x86;

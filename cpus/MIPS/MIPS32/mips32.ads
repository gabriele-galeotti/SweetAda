-----------------------------------------------------------------------------------------------------------------------
--                                                     SweetAda                                                      --
-----------------------------------------------------------------------------------------------------------------------
-- __HDS__                                                                                                           --
-- __FLN__ mips32.ads                                                                                                --
-- __DSC__                                                                                                           --
-- __HSH__ e69de29bb2d1d6434b8b29ae775ad8c2e48c5391                                                                  --
-- __HDE__                                                                                                           --
-----------------------------------------------------------------------------------------------------------------------
-- Copyright (C) 2020-2026 Gabriele Galeotti                                                                         --
--                                                                                                                   --
-- SweetAda web page: http://sweetada.org                                                                            --
-- contact address: gabriele.galeotti@sweetada.org                                                                   --
-- This work is licensed under the terms of the MIT License.                                                         --
-- Please consult the LICENSE.txt file located in the top-level directory.                                           --
-----------------------------------------------------------------------------------------------------------------------

with System;
with Interfaces;
with Bits;
with MIPS;

package MIPS32
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
   use MIPS;

   ----------------------------------------------------------------------------
   -- 6.2.10 Count Register (CP0 Register 9, Select 0)
   ----------------------------------------------------------------------------

   function CP0_Count_Read
      return Unsigned_32
      with Inline => True;
   procedure CP0_Count_Write
      (Value : in Unsigned_32)
      with Inline => True;

   ----------------------------------------------------------------------------
   -- 6.2.12 Compare Register (CP0 Register 11, Select 0)
   ----------------------------------------------------------------------------

   function CP0_Compare_Read
      return Unsigned_32
      with Inline => True;
   procedure CP0_Compare_Write
      (Value : in Unsigned_32)
      with Inline => True;

   ----------------------------------------------------------------------------
   -- 6.2.13 Status Register (CP0 Register 12, Select 0)
   ----------------------------------------------------------------------------

   KSU_Kernel     : constant := 2#00#; -- Base mode is Kernel Mode
   KSU_Supervisor : constant := 2#01#; -- Base mode is Supervisor Mode
   KSU_User       : constant := 2#10#; -- Base mode is User Mode
   KSU_Reserved   : constant := 2#11#; -- Reserved

   FR_32  : constant := 0; -- FP registers can contain any 32-bit datatype. 64-bit in even-odd pairs of registers
   FR_ANY : constant := 1; -- FP registers can contain any datatype

   type Status_Type is record
      IE        : Boolean;      -- Interrupt Enable
      EXL       : Boolean;      -- Exception Level
      ERL       : Boolean;      -- Error Level
      KSU       : Bits_2;       -- base operating mode of the processor
      Reserved1 : Bits_1  := 0; -- UX
      Reserved2 : Bits_1  := 0; -- SX
      Reserved3 : Bits_1  := 0; -- KX
      IM        : Bits_8;       -- Interrupt Mask (or IPL)
      Reserved4 : Bits_1  := 0;
      CEE       : Boolean;      -- CorExtend Enable
      ZERO      : Bits_1  := 0; -- Reserved
      NMI       : Boolean;      -- entry through the reset exception vector was due to an NMI
      SR        : Boolean;      -- entry through the reset exception vector was due to a Soft Reset
      TS        : Boolean;      -- TLB shutdown
      BEV       : Boolean;      -- Controls the location of exception vectors
      Reserved5 : Bits_1  := 0;
      MX        : Boolean;      -- Enables access to DSP ASE resources
      RE        : Boolean;      -- enable reverse-endian memory references while the processor is running in user mode
      FR        : Bits_1;       -- control the floating point register mode for 64-bit floating point units
      RP        : Boolean;      -- Enables reduced power mode
      CU0       : Boolean;
      CU1       : Boolean;
      CU2       : Boolean;
      CU3       : Boolean;
   end record
      with Bit_Order => Low_Order_First,
           Size      => 32;
   for Status_Type use record
      IE        at 0 range  0 ..  0;
      EXL       at 0 range  1 ..  1;
      ERL       at 0 range  2 ..  2;
      KSU       at 0 range  3 ..  4;
      Reserved1 at 0 range  5 ..  5;
      Reserved2 at 0 range  6 ..  6;
      Reserved3 at 0 range  7 ..  7;
      IM        at 0 range  8 .. 15;
      Reserved4 at 0 range 16 .. 16;
      CEE       at 0 range 17 .. 17;
      ZERO      at 0 range 18 .. 18;
      NMI       at 0 range 19 .. 19;
      SR        at 0 range 20 .. 20;
      TS        at 0 range 21 .. 21;
      BEV       at 0 range 22 .. 22;
      Reserved5 at 0 range 23 .. 23;
      MX        at 0 range 24 .. 24;
      RE        at 0 range 25 .. 25;
      FR        at 0 range 26 .. 26;
      RP        at 0 range 27 .. 27;
      CU0       at 0 range 28 .. 28;
      CU1       at 0 range 29 .. 29;
      CU2       at 0 range 30 .. 30;
      CU3       at 0 range 31 .. 31;
   end record;

   function CP0_SR_Read
      return Status_Type
      with Inline => True;
   procedure CP0_SR_Write
      (Value : in Status_Type)
      with Inline => True;

   ----------------------------------------------------------------------------
   -- 6.2.17 Cause Register (CP0 Register 13, Select 0)
   ----------------------------------------------------------------------------

   ExcCode_Int        : constant := 16#00#; -- Interrupt
   ExcCode_Mod        : constant := 16#01#; -- TLB modification exception
   ExcCode_TLBL       : constant := 16#02#; -- TLB exception (load or instruction fetch)
   ExcCode_TLBS       : constant := 16#03#; -- TLB exception (store)
   ExcCode_AdEL       : constant := 16#04#; -- Address error exception (load or instruction fetch)
   ExcCode_AdES       : constant := 16#05#; -- Address error exception (store)
   ExcCode_IBE        : constant := 16#06#; -- Bus error exception (instruction fetch)
   ExcCode_DBE        : constant := 16#07#; -- Bus error exception (data reference: load or store)
   ExcCode_Sys        : constant := 16#08#; -- Syscall exception
   ExcCode_Bp         : constant := 16#09#; -- Breakpoint exception.
   ExcCode_RI         : constant := 16#0A#; -- Reserved instruction exception
   ExcCode_CpU        : constant := 16#0B#; -- Coprocessor Unusable exception
   ExcCode_Ov         : constant := 16#0C#; -- Arithmetic Overflow exception
   ExcCode_Tr         : constant := 16#0D#; -- Trap exception
   ExcCode_Reserved1  : constant := 16#0E#;
   ExcCode_FPE        : constant := 16#0F#; -- Floating point exception
   ExcCode_IS1        : constant := 16#10#; -- Coprocessor 2 implementation specific exception
   ExcCode_CEU        : constant := 16#11#; -- CorExtend Unusable
   ExcCode_C2E        : constant := 16#12#; -- Precise Coprocessor 2 exception
   ExcCode_Reserved2  : constant := 16#13#;
   ExcCode_Reserved3  : constant := 16#14#;
   ExcCode_Reserved4  : constant := 16#15#;
   ExcCode_Reserved5  : constant := 16#16#;
   ExcCode_WATCH      : constant := 16#17#; -- Reference to WatchHi/WatchLo address
   ExcCode_MCheck     : constant := 16#18#; -- Machine checkcore
   ExcCode_Reserved6  : constant := 16#19#;
   ExcCode_Reserved7  : constant := 16#1A#;
   ExcCode_Reserved8  : constant := 16#1B#;
   ExcCode_Reserved9  : constant := 16#1C#;
   ExcCode_Reserved10 : constant := 16#1D#;
   ExcCode_CacheErr   : constant := 16#1E#; -- Cache error
   ExcCode_Reserved11 : constant := 16#1F#;

   IV_Exception : constant := 0; -- Use the general exception vector (16#180)
   IV_Interrupt : constant := 1; -- Use the special interrupt vector (16#200)

   type Cause_Type is record
      Reserved1 : Bits_2  := 0;
      ExcCode   : Bits_5  := 0;            -- Exception Code
      Reserved2 : Bits_1  := 0;
      IP        : Bits_8  := 0;            -- Interrupt Pending (or RIPL)
      Reserved3 : Bits_6  := 0;
      WP        : Boolean := False;        -- Indicates that a watch exception was deferred
      IV        : Bits_1  := IV_Exception; -- general or special interrupt vector
      Reserved4 : Bits_2  := 0;
      PCI       : Boolean := False;        -- Performance Counter Interrupt
      DC        : Boolean := False;        -- Disable Count register
      CE        : Bits_2  := 0;            -- Coprocessor unit number referenced
      Reserved5 : Bits_1  := 0;
      BD        : Boolean := False;        -- Branch Delay
   end record
      with Bit_Order => Low_Order_First,
           Size      => 32;
   for Cause_Type use record
      Reserved1 at 0 range  0 ..  1;
      ExcCode   at 0 range  2 ..  6;
      Reserved2 at 0 range  7 ..  7;
      IP        at 0 range  8 .. 15;
      Reserved3 at 0 range 16 .. 21;
      WP        at 0 range 22 .. 22;
      IV        at 0 range 23 .. 23;
      Reserved4 at 0 range 24 .. 25;
      PCI       at 0 range 26 .. 26;
      DC        at 0 range 27 .. 27;
      CE        at 0 range 28 .. 29;
      Reserved5 at 0 range 30 .. 30;
      BD        at 0 range 31 .. 31;
   end record;

   function CP0_Cause_Read
      return Unsigned_32
      with Inline => True;
   procedure CP0_Cause_Write
      (Value : in Unsigned_32)
      with Inline => True;

   ----------------------------------------------------------------------------
   -- 6.2.18 Exception Program Counter (CP0 Register 14, Select 0)
   ----------------------------------------------------------------------------

   function CP0_EPC_Read
      return Unsigned_32
      with Inline => True;
   procedure CP0_EPC_Write
      (Value : in Unsigned_32)
      with Inline => True;

   ----------------------------------------------------------------------------
   -- 6.2.19 Processor Identification (CP0 Register 15, Select 0)
   ----------------------------------------------------------------------------

   type PRId_Type is record
      Revision        : Unsigned_8; -- Rev
      CPU_ID          : Unsigned_8; -- Imp
      Company_ID      : Unsigned_8;
      Company_Options : Unsigned_8;
   end record
      with Bit_Order => Low_Order_First,
           Size      => 32;
   for PRId_Type use record
      Revision        at 0 range  0 ..  7;
      CPU_ID          at 0 range  8 .. 15;
      Company_ID      at 0 range 16 .. 23;
      Company_Options at 0 range 24 .. 31;
   end record;

   function CP0_PRId_Read
      return PRId_Type
      with Inline => True;

   ----------------------------------------------------------------------------
   -- 6.2.21 Config Register (CP0 Register 16, Select 0)
   ----------------------------------------------------------------------------

   function CP0_Config_Read
      return Unsigned_32
      with Inline => True;
   procedure CP0_Config_Write
      (Value : in Unsigned_32)
      with Inline => True;

   ----------------------------------------------------------------------------
   -- 6.2.22 Config1 Register (CP0 Register 16, Select 1)
   ----------------------------------------------------------------------------

   type Config1_Type is record
      FP       : Boolean; -- FPU implemented.
      EP       : Boolean; -- EJTAG present
      CA       : Boolean; -- Code compression (MIPS16) implemented.
      WR       : Boolean; -- Watch registers implemented.
      PC       : Boolean; -- Performance Counter registers implemented.
      MD       : Boolean; -- MDMX implemented.
      C2       : Boolean; -- Coprocessor 2 present.
      DA       : Bits_3;  -- This field contains the type of set associativity for the data cache
      DL       : Bits_3;  -- This field contains the data cache line size.
      DS       : Bits_3;  -- This field contains the number of data cache sets per way.
      IcA      : Bits_3;  -- This field contains the level of instruction cache associativity
      IcL      : Bits_3;  -- This field contains the instruction cache line size
      IcS      : Bits_3;  -- This field contains the number of instruction cache sets per way.
      MMU_Size : Bits_6;  -- This field contains the number of entries in the TLB minus one.
      M        : Bits_1;  -- This bit is hardwired to ‘1’ to indicate the presence of the Config2 register.
   end record
      with Bit_Order => Low_Order_First,
           Size      => 32;
   for Config1_Type use record
      FP       at 0 range  0 ..  0;
      EP       at 0 range  1 ..  1;
      CA       at 0 range  2 ..  2;
      WR       at 0 range  3 ..  3;
      PC       at 0 range  4 ..  4;
      MD       at 0 range  5 ..  5;
      C2       at 0 range  6 ..  6;
      DA       at 0 range  7 ..  9;
      DL       at 0 range 10 .. 12;
      DS       at 0 range 13 .. 15;
      IcA      at 0 range 16 .. 18;
      IcL      at 0 range 19 .. 21;
      IcS      at 0 range 22 .. 24;
      MMU_Size at 0 range 25 .. 30;
      M        at 0 range 31 .. 31;
   end record;

   function CP0_Config1_Read
      return Unsigned_32
      with Inline => True;
   procedure CP0_Config1_Write
      (Value : in Unsigned_32)
      with Inline => True;

   ----------------------------------------------------------------------------
   -- 6.2.28 Debug Register (CP0 Register 23, Select 0)
   ----------------------------------------------------------------------------

   function CP0_Debug_Read
      return Unsigned_32
      with Inline => True;
   procedure CP0_Debug_Write
      (Value : in Unsigned_32)
      with Inline => True;

   ----------------------------------------------------------------------------
   -- Interrupts
   ----------------------------------------------------------------------------

   type Intcontext_Type is new Natural;
   type Irq_Id_Type is new Natural;
   subtype Irq_Level_Type is Unsigned_16 range 0 .. 63;

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
   procedure Irq_Level_Set
      (Irq_Level : in Irq_Level_Type)
      with Inline => True;

   ----------------------------------------------------------------------------
   -- Locking
   ----------------------------------------------------------------------------

   procedure Lock_Try
      (Lock_Object : in out Lock_Type;
       Success     :    out Boolean)
      with Inline => True;
   procedure Lock
      (Lock_Object : in out Lock_Type)
      with Inline => True;
   procedure Unlock
      (Lock_Object : out Lock_Type)
      with Inline => True;

end MIPS32;

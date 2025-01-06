-----------------------------------------------------------------------------------------------------------------------
--                                                     SweetAda                                                      --
-----------------------------------------------------------------------------------------------------------------------
-- __HDS__                                                                                                           --
-- __FLN__ armv8a.ads                                                                                                --
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

package ARMv8A
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

pragma Style_Checks (Off);

   ----------------------------------------------------------------------------
   -- Arm® Architecture Reference Manual
   -- for A-profile architecture
   -- ARM DDI 0487J.a (ID042523)
   ----------------------------------------------------------------------------

   ----------------------------------------------------------------------------
   -- CurrentEL
   ----------------------------------------------------------------------------

   EL0 : constant := 2#00#;
   EL1 : constant := 2#01#;
   EL2 : constant := 2#10#;
   EL3 : constant := 2#11#;

   type EL_Type is record
      Reserved1 : Bits_2;
      EL        : Bits_2;  -- Current Exception level.
      Reserved2 : Bits_28;
      Reserved3 : Bits_32;
   end record
      with Bit_Order => Low_Order_First,
           Size      => 64;
   for EL_Type use record
      Reserved1 at 0 range  0 ..  1;
      EL        at 0 range  2 ..  3;
      Reserved2 at 0 range  4 .. 31;
      Reserved3 at 0 range 32 .. 63;
   end record;

   function CurrentEL_Read
      return EL_Type
      with Inline => True;

   ----------------------------------------------------------------------------
   -- Memory attributes (D19.2.100 .. D19.2.102)
   ----------------------------------------------------------------------------

   type Memory_Attribute_Type is new Bits_8;

   -- "device" memory

   type Device_Attribute_Type is (
      DEVICE_nGnRnE, -- Device_nGnRnE
      DEVICE_nGnRE,  -- Device_nGnRE
      DEVICE_nGRE,   -- Device_nGRE
      DEVICE_GRE     -- Device_GRE
      );

   function Device_Memory_Attribute
      (Device : Device_Attribute_Type;
       XS     : Boolean)
      return Memory_Attribute_Type;

   --  "normal" memory

   type Normal_Memory_Attribute_Type is (
      NORMAL_XS_InCOnC,          -- If FEAT_XS is implemented: Normal Inner Non-cacheable, Outer Non-cacheable memory with the XS attribute set to 0. Otherwise, UNPREDICTABLE.
      NORMAL_XS_IWTCOWTCRAnWAnT, -- If FEAT_XS is implemented: Normal Inner Write-through Cacheable, Outer Write-through Cacheable, Read-Allocate, No-Write Allocate, Non-transient memory with the XS attribute set to 0. Otherwise, UNPREDICTABLE.
      NORMAL_MTE2_TIWBOWBRAWAnT, -- If FEAT_MTE2 is implemented: Tagged Normal Inner Write-Back, Outer Write-Back, Read-Allocate, Write-Allocate Non-transient memory. Otherwise, UNPREDICTABLE.
      NORMAL                     -- everything else
      );

   type Normal_Memory_Policy_Type is (
      WTT,  -- Write-Through Transient (RW not 00)
      nC,   -- Non-cacheable (RW = 00)
      WBT,  -- Write-Back Transient (RW not 00)
      WTnT, -- Write-Through Non-transient
      WBnT  -- Write-Back Non-transient
      );

   NoAllocate : constant := 0;
   Allocate   : constant := 1;

   function Normal_Memory_Attribute
      (Attribute      : Normal_Memory_Attribute_Type;
       Inner_Policy   : Normal_Memory_Policy_Type;
       Inner_R_Policy : Bits_1;
       Inner_W_Policy : Bits_1;
       Outer_Policy   : Normal_Memory_Policy_Type;
       Outer_R_Policy : Bits_1;
       Outer_W_Policy : Bits_1)
      return Memory_Attribute_Type;

   ----------------------------------------------------------------------------
   -- C5.2 Special-purpose registers
   ----------------------------------------------------------------------------

   -- C5.2.8 FPCR, Floating-point Control Register

   RMode_RN : constant := 2#00#; -- Round to Nearest (RN) mode.
   RMode_RP : constant := 2#01#; -- Round towards Plus Infinity (RP) mode.
   RMode_RM : constant := 2#10#; -- Round towards Minus Infinity (RM) mode.
   RMode_RZ : constant := 2#11#; -- Round towards Zero (RZ) mode.

   type FPCR_Type is record
      FIZ       : Boolean;      -- Flush Inputs to Zero.
      AH        : Boolean;      -- Alternate Handling.
      NEP       : Boolean;      -- Controls how the output elements other than the lowest element of the vector are determined for Advanced SIMD scalar instructions.
      Reserved1 : Bits_5  := 0;
      IOE       : Boolean;      -- Invalid Operation floating-point exception trap enable.
      DZE       : Boolean;      -- Divide by Zero floating-point exception trap enable.
      OFE       : Boolean;      -- Overflow floating-point exception trap enable.
      UFE       : Boolean;      -- Underflow floating-point exception trap enable.
      IXE       : Boolean;      -- Inexact floating-point exception trap enable.
      Reserved2 : Bits_2  := 0;
      IDE       : Boolean;      -- Input Denormal floating-point exception trap enable.
      Len       : Bits_3  := 0; -- This field has no function in AArch64 state, and nonzero values are ignored during execution in AArch64 state.
      FZ16      : Boolean;      -- Flushing denormalized numbers to zero control bit on half-precision data-processing instructions.
      Stride    : Bits_2  := 0; -- This field has no function in AArch64 state, and nonzero values are ignored during execution in AArch64 state.
      RMode     : Bits_2;       -- Rounding Mode control field.
      FZ        : Boolean;      -- Flushing denormalized numbers to zero control bit.
      DN        : Boolean;      -- Default NaN use for NaN propagation.
      AHP       : Boolean;      -- Alternative half-precision control bit.
      Reserved3 : Bits_5  := 0;
      Reserved4 : Bits_32 := 0;
   end record
      with Bit_Order => Low_Order_First,
           Size      => 64;
   for FPCR_Type use record
      FIZ       at 0 range  0 ..  0;
      AH        at 0 range  1 ..  1;
      NEP       at 0 range  2 ..  2;
      Reserved1 at 0 range  3 ..  7;
      IOE       at 0 range  8 ..  8;
      DZE       at 0 range  9 ..  9;
      OFE       at 0 range 10 .. 10;
      UFE       at 0 range 11 .. 11;
      IXE       at 0 range 12 .. 12;
      Reserved2 at 0 range 13 .. 14;
      IDE       at 0 range 15 .. 15;
      Len       at 0 range 16 .. 18;
      FZ16      at 0 range 19 .. 19;
      Stride    at 0 range 20 .. 21;
      RMode     at 0 range 22 .. 23;
      FZ        at 0 range 24 .. 24;
      DN        at 0 range 25 .. 25;
      AHP       at 0 range 26 .. 26;
      Reserved3 at 0 range 27 .. 31;
      Reserved4 at 0 range 32 .. 63;
   end record;

   function FPCR_Read
      return FPCR_Type
      with Inline => True;
   procedure FPCR_Write
      (Value : in FPCR_Type)
      with Inline => True;

   -- C5.2.9 FPSR, Floating-point Status Register

   type FPSR_Type is record
      IOC       : Boolean;      -- Invalid Operation cumulative exception bit.
      DZC       : Boolean;      -- Division by Zero cumulative exception bit.
      OFC       : Boolean;      -- Overflow cumulative exception bit.
      UFC       : Boolean;      -- Underflow cumulative exception bit.
      IXC       : Boolean;      -- Inexact cumulative exception bit.
      Reserved1 : Bits_2  := 0;
      IDC       : Boolean;      -- Input Denormal cumulative exception bit.
      Reserved2 : Bits_19 := 0;
      QC        : Boolean;      -- Cumulative saturation bit, Advanced SIMD only.
      V         : Boolean;      -- Overflow condition flag.
      C         : Boolean;      -- Carry condition flag.
      Z         : Boolean;      -- Zero condition flag.
      N         : Boolean;      -- Negative condition flag.
      Reserved3 : Bits_32 := 0;
   end record
      with Bit_Order => Low_Order_First,
           Size      => 64;
   for FPSR_Type use record
      IOC       at 0 range  0 ..  0;
      DZC       at 0 range  1 ..  1;
      OFC       at 0 range  2 ..  2;
      UFC       at 0 range  3 ..  3;
      IXC       at 0 range  4 ..  4;
      Reserved1 at 0 range  5 ..  6;
      IDC       at 0 range  7 ..  7;
      Reserved2 at 0 range  8 .. 26;
      QC        at 0 range 27 .. 27;
      V         at 0 range 28 .. 28;
      C         at 0 range 29 .. 29;
      Z         at 0 range 30 .. 30;
      N         at 0 range 31 .. 31;
      Reserved3 at 0 range 32 .. 63;
   end record;

   function FPSR_Read
      return FPSR_Type
      with Inline => True;
   procedure FPSR_Write
      (Value : in FPSR_Type)
      with Inline => True;

   ----------------------------------------------------------------------------
   -- D19.2 General system control registers
   ----------------------------------------------------------------------------

   -- D19.2.1 ACCDATA_EL1, Accelerator Data

   type ACCDATA_EL1_Type is record
      ACCDATA  : Bits_32;      -- Holds the lower 32 bits of the data that is stored by an ST64BV0, Single-copy atomic 64-byte EL0 store instruction.
      Reserved : Bits_32 := 0;
   end record
      with Bit_Order => Low_Order_First,
           Size      => 64;
   for ACCDATA_EL1_Type use record
      ACCDATA  at 0 range  0 .. 31;
      Reserved at 0 range 32 .. 63;
   end record;

   -- D19.2.2 ACTLR_EL1, Auxiliary Control Register (EL1)
   -- D19.2.3 ACTLR_EL2, Auxiliary Control Register (EL2)
   -- D19.2.4 ACTLR_EL3, Auxiliary Control Register (EL3)
   -- D19.2.5 AFSR0_EL1, Auxiliary Fault Status Register 0 (EL1)
   -- D19.2.6 AFSR0_EL2, Auxiliary Fault Status Register 0 (EL2)
   -- D19.2.7 AFSR0_EL3, Auxiliary Fault Status Register 0 (EL3)
   -- D19.2.8 AFSR1_EL1, Auxiliary Fault Status Register 1 (EL1)
   -- D19.2.9 AFSR1_EL2, Auxiliary Fault Status Register 1 (EL2)
   -- D19.2.10 AFSR1_EL3, Auxiliary Fault Status Register 1 (EL3)
   -- D19.2.11 AIDR_EL1, Auxiliary ID Register
   -- D19.2.12 AMAIR_EL1, Auxiliary Memory Attribute Indirection Register (EL1)
   -- D19.2.13 AMAIR_EL2, Auxiliary Memory Attribute Indirection Register (EL2)
   -- D19.2.14 AMAIR_EL3, Auxiliary Memory Attribute Indirection Register (EL3)
   -- D19.2.15 APDAKeyHi_EL1, Pointer Authentication Key A for Data (bits[127:64])
   -- D19.2.16 APDAKeyLo_EL1, Pointer Authentication Key A for Data (bits[63:0])
   -- D19.2.17 APDBKeyHi_EL1, Pointer Authentication Key B for Data (bits[127:64])
   -- D19.2.18 APDBKeyLo_EL1, Pointer Authentication Key B for Data (bits[63:0])
   -- D19.2.19 APGAKeyHi_EL1, Pointer Authentication Key A for Code (bits[127:64])
   -- D19.2.20 APGAKeyLo_EL1, Pointer Authentication Key A for Code (bits[63:0])
   -- D19.2.21 APIAKeyHi_EL1, Pointer Authentication Key A for Instruction (bits[127:64])
   -- D19.2.22 APIAKeyLo_EL1, Pointer Authentication Key A for Instruction (bits[63:0])
   -- D19.2.23 APIBKeyHi_EL1, Pointer Authentication Key B for Instruction (bits[127:64])
   -- D19.2.24 APIBKeyLo_EL1, Pointer Authentication Key B for Instruction (bits[63:0])

   -- D19.2.25 CCSIDR2_EL1, Current Cache Size ID Register 2

   type CCSIDR2_EL1_Type is record
      NumSets  : Bits_24;      -- (Number of sets in cache) - 1, therefore a value of 0 indicates 1 set in the cache. The number of sets does not have to be a power of 2.
      Reserved : Bits_40 := 0;
   end record
      with Bit_Order => Low_Order_First,
           Size      => 64;
   for CCSIDR2_EL1_Type use record
      NumSets  at 0 range  0 .. 23;
      Reserved at 0 range 24 .. 63;
   end record;

   -- D19.2.26 CCSIDR_EL1, Current Cache Size ID Register

   type CCSIDR_EL1_Type is record
      LineSize      : Bits_3;       -- (Log2(Number of bytes in cache line)) - 4.
      Associativity : Bits_21;      -- (Associativity of cache) - 1, therefore a value of 0 indicates an associativity of 1.
      Reserved1     : Bits_8  := 0;
      NumSets       : Bits_24;      -- (Number of sets in cache) - 1, therefore a value of 0 indicates 1 set in the cache. The number of sets does not have to be a power of 2.
      Reserved2     : Bits_8  := 0;
   end record
      with Bit_Order => Low_Order_First,
           Size      => 64;
   for CCSIDR_EL1_Type use record
      LineSize      at 0 range  0 ..  2;
      Associativity at 0 range  3 .. 23;
      Reserved1     at 0 range 24 .. 31;
      NumSets       at 0 range 32 .. 55;
      Reserved2     at 0 range 56 .. 63;
   end record;

   -- D19.2.27 CLIDR_EL1, Cache Level ID Register
   -- D19.2.28 CONTEXTIDR_EL1, Context ID Register (EL1)
   -- D19.2.29 CONTEXTIDR_EL2, Context ID Register (EL2)
   -- D19.2.30 CPACR_EL1, Architectural Feature Access Control Register
   -- D19.2.31 CPTR_EL2, Architectural Feature Trap Register (EL2)
   -- D19.2.32 CPTR_EL3, Architectural Feature Trap Register (EL3)
   -- D19.2.33 CSSELR_EL1, Cache Size Selection Register
   -- D19.2.34 CTR_EL0, Cache Type Register
   -- D19.2.35 DACR32_EL2, Domain Access Control Register
   -- D19.2.36 DCZID_EL0, Data Cache Zero ID register
   -- D19.2.37 ESR_EL1, Exception Syndrome Register (EL1)
   -- D19.2.38 ESR_EL2, Exception Syndrome Register (EL2)
   -- D19.2.39 ESR_EL3, Exception Syndrome Register (EL3)

   -- D19.2.40 FAR_EL1, Fault Address Register (EL1)

   function FAR_EL1_Read
      return Unsigned_64
      with Inline => True;

   -- D19.2.41 FAR_EL2, Fault Address Register (EL2)

   function FAR_EL2_Read
      return Unsigned_64
      with Inline => True;

   -- D19.2.42 FAR_EL3, Fault Address Register (EL3)

   function FAR_EL3_Read
      return Unsigned_64
      with Inline => True;

   -- D19.2.43 FPEXC32_EL2, Floating-Point Exception Control register

   type FPEXC32_EL2_Type is record
      IOF       : Boolean;      -- Invalid Operation floating-point exception trap enable.
      DZF       : Boolean;      -- Divide by Zero floating-point exception trap enable.
      OFF       : Boolean;      -- Overflow floating-point exception trap enable.
      UFF       : Boolean;      -- Underflow floating-point exception trap enable.
      IXF       : Boolean;      -- Inexact floating-point exception trap enable.
      Reserved1 : Bits_2  := 0;
      IDF       : Boolean;      -- Input Denormal floating-point exception trap enable.
      VECITR    : Bits_3;
      Reserved2 : Bits_15 := 0;
      TFV       : Boolean;      -- Trapped Fault Valid bit.
      VV        : Boolean;      -- VECITR valid bit.
      FP2V      : Boolean;      -- FPINST2 instruction valid bit.
      DEX       : Boolean;      -- Defined synchronous exception on floating-point execution.
      EN        : Boolean;      -- Enables access to the Advanced SIMD and floating-point functionality from all Exception levels, except that setting this field to 0 does not disable the following: ...
      EX        : Boolean;      -- Exception bit.
      Reserved3 : Bits_32 := 0;
   end record
      with Bit_Order => Low_Order_First,
           Size      => 64;
   for FPEXC32_EL2_Type use record
      IOF       at 0 range  0 ..  0;
      DZF       at 0 range  1 ..  1;
      OFF       at 0 range  2 ..  2;
      UFF       at 0 range  3 ..  3;
      IXF       at 0 range  4 ..  4;
      Reserved1 at 0 range  5 ..  6;
      IDF       at 0 range  7 ..  7;
      VECITR    at 0 range  8 .. 10;
      Reserved2 at 0 range 11 .. 25;
      TFV       at 0 range 26 .. 26;
      VV        at 0 range 27 .. 27;
      FP2V      at 0 range 28 .. 28;
      DEX       at 0 range 29 .. 29;
      EN        at 0 range 30 .. 30;
      EX        at 0 range 31 .. 31;
      Reserved3 at 0 range 32 .. 63;
   end record;

   function FPEXC32_EL2_Read
      return FPEXC32_EL2_Type
      with Inline => True;
   procedure FPEXC32_EL2_Write
      (Value : in FPEXC32_EL2_Type)
      with Inline => True;

   -- D19.2.44 GCR_EL1, Tag Control Register.
   -- D19.2.45 GMID_EL1, Multiple tag transfer ID register
   -- D19.2.46 HACR_EL2, Hypervisor Auxiliary Control Register
   -- D19.2.47 HAFGRTR_EL2, Hypervisor Activity Monitors Fine-Grained Read Trap Register

   -- D19.2.48 HCR_EL2, Hypervisor Configuration Register

   type HCR_EL2_Type is record
      VM        : Boolean;      -- Virtualization enable.
      SWIO      : Boolean;      -- Set/Way Invalidation Override.
      PTW       : Boolean;      -- Protected Table Walk.
      FMO       : Boolean;      -- Physical FIQ Routing.
      IMO       : Boolean;      -- Physical IRQ Routing.
      AMO       : Boolean;      -- Physical SError interrupt routing.
      VF        : Boolean;      -- Virtual FIQ Interrupt
      VI        : Boolean;      -- Virtual IRQ Interrupt.
      VSE       : Boolean;      -- Virtual SError interrupt.
      FB        : Boolean;      -- Force broadcast.
      BSU       : Bits_2;       -- Barrier Shareability upgrade.
      DC        : Boolean;      -- Default Cacheability.
      TWI       : Boolean;      -- Traps EL0 and EL1 execution of WFI instructions to EL2, when EL2 is enabled in the current Security state, from both Execution states, reported using EC syndrome value 0x01.
      TWE       : Boolean;      -- Traps EL0 and EL1 execution of WFE instructions to EL2, when EL2 is enabled in the current Security state, from both Execution states, reported using EC syndrome value 0x01.
      TID0      : Boolean;      -- Trap ID group 0.
      TID1      : Boolean;      -- Trap ID group 1.
      TID2      : Boolean;      -- Trap ID group 2.
      TID3      : Boolean;      -- Trap ID group 3.
      TSC       : Boolean;      -- Trap SMC instructions.
      TIDCP     : Boolean;      -- Trap IMPLEMENTATION DEFINED functionality.
      TACR      : Boolean;      -- Trap Auxiliary Control Registers.
      TSW       : Boolean;      -- Trap data or unified cache maintenance instructions that operate by Set/Way.
      TPCP      : Boolean;      -- Trap data or unified cache mainte instrs that operate to the Point of Coherency or Persistence.
      TPU       : Boolean;      -- Trap cache maintenance instructions that operate to the Point of Unification.
      TTLB      : Boolean;      -- Trap TLB maintenance instructions.
      TVM       : Boolean;      -- Trap Virtual Memory controls.
      TGE       : Boolean;      -- Trap General Exceptions, from EL0.
      TDZ       : Boolean;      -- Trap DC ZVA instructions.
      HCD       : Boolean;      -- HVC instruction disable.
      TRVM      : Boolean;      -- Trap Reads of Virtual Memory controls.
      RV        : Boolean;      -- Execution state control for lower Exception levels
      CD        : Boolean;      -- Stage 2 Data access cacheability disable.
      ID        : Boolean;      -- Stage 2 Instruction access cacheability disable.
      E2H       : Boolean;      -- EL2 Host.
      TLOR      : Boolean;      -- Trap LOR registers.
      TERR      : Boolean;      -- Trap Error record accesses.
      TEA       : Boolean;      -- Route synchronous External abort exceptions to EL2.
      MIOCNCE   : Boolean;      -- Mismatched Inner/Outer Cacheable Non-Coherency Enable, for the EL1&0 translation regimes.
      Reserved1 : Bits_1  := 0;
      APK       : Boolean;      -- Trap registers holding "key" values for Pointer Authentication.
      API       : Boolean;      -- Controls the use of instructions related to Pointer Authentication
      NV        : Boolean;      -- Nested Virtualization.
      NV1       : Boolean;      -- Nested Virtualization.
      AddrTr    : Boolean;      -- Address Translation.
      NV2       : Boolean;      -- Nested Virtualization.
      FWB       : Boolean;      -- Forced Write-Back.
      FIEN      : Boolean;      -- Fault Injection Enable.
      Reserved2 : Bits_1  := 0;
      TID4      : Boolean;      -- Trap ID group 4.
      TICAB     : Boolean;      -- Trap ICIALLUIS/IC IALLUIS cache maintenance instructions.
      AMVOFFEN  : Boolean;      -- Activity Monitors Virtual Offsets Enable.
      TOCU      : Boolean;      -- Trap cache maintenance instructions that operate to the Point of Unification.
      EnSCXT    : Boolean;      -- Enable Access to the SCXTNUM_EL1 and SCXTNUM_EL0 registers.
      TTLBIS    : Boolean;      -- Trap TLB maintenance instructions that operate on the Inner Shareable domain.
      TTLBOS    : Boolean;      -- Trap TLB maintenance instructions that operate on the Outer Shareable domain.
      ATA       : Boolean;      -- Allocation Tag Access.
      DCT       : Boolean;      -- Default Cacheability Tagging.
      TID5      : Boolean;      -- Trap ID group 5.
      TWEDEn    : Boolean;      -- TWE Delay Enable.
      TWEDEL    : Bits_4  := 0; -- TWE Delay.
   end record
      with Bit_Order => Low_Order_First,
           Size      => 64;
   for HCR_EL2_Type use record
      VM        at 0 range  0 ..  0;
      SWIO      at 0 range  1 ..  1;
      PTW       at 0 range  2 ..  2;
      FMO       at 0 range  3 ..  3;
      IMO       at 0 range  4 ..  4;
      AMO       at 0 range  5 ..  5;
      VF        at 0 range  6 ..  6;
      VI        at 0 range  7 ..  7;
      VSE       at 0 range  8 ..  8;
      FB        at 0 range  9 ..  9;
      BSU       at 0 range 10 .. 11;
      DC        at 0 range 12 .. 12;
      TWI       at 0 range 13 .. 13;
      TWE       at 0 range 14 .. 14;
      TID0      at 0 range 15 .. 15;
      TID1      at 0 range 16 .. 16;
      TID2      at 0 range 17 .. 17;
      TID3      at 0 range 18 .. 18;
      TSC       at 0 range 19 .. 19;
      TIDCP     at 0 range 20 .. 20;
      TACR      at 0 range 21 .. 21;
      TSW       at 0 range 22 .. 22;
      TPCP      at 0 range 23 .. 23;
      TPU       at 0 range 24 .. 24;
      TTLB      at 0 range 25 .. 25;
      TVM       at 0 range 26 .. 26;
      TGE       at 0 range 27 .. 27;
      TDZ       at 0 range 28 .. 28;
      HCD       at 0 range 29 .. 29;
      TRVM      at 0 range 30 .. 30;
      RV        at 0 range 31 .. 31;
      CD        at 0 range 32 .. 32;
      ID        at 0 range 33 .. 33;
      E2H       at 0 range 34 .. 34;
      TLOR      at 0 range 35 .. 35;
      TERR      at 0 range 36 .. 36;
      TEA       at 0 range 37 .. 37;
      MIOCNCE   at 0 range 38 .. 38;
      Reserved1 at 0 range 39 .. 39;
      APK       at 0 range 40 .. 40;
      API       at 0 range 41 .. 41;
      NV        at 0 range 42 .. 42;
      NV1       at 0 range 43 .. 43;
      AddrTr    at 0 range 44 .. 44;
      NV2       at 0 range 45 .. 45;
      FWB       at 0 range 46 .. 46;
      FIEN      at 0 range 47 .. 47;
      Reserved2 at 0 range 48 .. 48;
      TID4      at 0 range 49 .. 49;
      TICAB     at 0 range 50 .. 50;
      AMVOFFEN  at 0 range 51 .. 51;
      TOCU      at 0 range 52 .. 52;
      EnSCXT    at 0 range 53 .. 53;
      TTLBIS    at 0 range 54 .. 54;
      TTLBOS    at 0 range 55 .. 55;
      ATA       at 0 range 56 .. 56;
      DCT       at 0 range 57 .. 57;
      TID5      at 0 range 58 .. 58;
      TWEDEn    at 0 range 59 .. 59;
      TWEDEL    at 0 range 60 .. 63;
   end record;

   function HCR_EL2_Read
      return HCR_EL2_Type
      with Inline => True;
   procedure HCR_EL2_Write
      (Value : in HCR_EL2_Type)
      with Inline => True;

   -- D19.2.49 HCRX_EL2, Extended Hypervisor Configuration Register
   -- D19.2.50 HDFGRTR_EL2, Hypervisor Debug Fine-Grained Read Trap Register
   -- D19.2.51 HDFGWTR_EL2, Hypervisor Debug Fine-Grained Write Trap Register
   -- D19.2.52 HFGITR_EL2, Hypervisor Fine-Grained Instruction Trap Register
   -- D19.2.53 HFGRTR_EL2, Hypervisor Fine-Grained Read Trap Register
   -- D19.2.54 HFGWTR_EL2, Hypervisor Fine-Grained Write Trap Register
   -- D19.2.55 HPFAR_EL2, Hypervisor IPA Fault Address Register
   -- D19.2.56 HSTR_EL2, Hypervisor System Trap Register
   -- D19.2.57 ID_AA64AFR0_EL1, AArch64 Auxiliary Feature Register 0
   -- D19.2.58 ID_AA64AFR1_EL1, AArch64 Auxiliary Feature Register 1
   -- D19.2.59 ID_AA64DFR0_EL1, AArch64 Debug Feature Register 0
   -- D19.2.60 ID_AA64DFR1_EL1, AArch64 Debug Feature Register 1

   -- D19.2.61 ID_AA64ISAR0_EL1, AArch64 Instruction Set Attribute Register 0

   AES_NONE  : constant := 2#0000#; -- No AES instructions implemented.
   AES_YES   : constant := 2#0001#; -- AESE, AESD, AESMC, and AESIMC instructions implemented.
   AES_PMULL : constant := 2#0010#; -- As for 0b0001, plus PMULL and PMULL2 instructions operating on 64-bit source elements.

   SHA1_NONE : constant := 2#0000#; -- No SHA1 instructions implemented.
   SHA1_YES  : constant := 2#0001#; -- SHA1C, SHA1P, SHA1M, SHA1H, SHA1SU0, and SHA1SU1 instructions implemented.

   SHA2_NONE : constant := 2#0000#; -- No SHA2 instructions implemented.
   SHA2_YES  : constant := 2#0001#; -- Implements instructions: SHA256H, SHA256H2, SHA256SU0, and SHA256SU1.
   SHA2_512  : constant := 2#0010#; -- Implements instructions: SHA256H, SHA256H2, SHA256SU0, and SHA256SU1. SHA512H, SHA512H2, SHA512SU0, and SHA512SU1.

   CRC32_NONE : constant := 2#0000#; -- CRC32 instructions are not implemented.
   CRC32_YES  : constant := 2#0001#; -- CRC32B, CRC32H, CRC32W, CRC32X, CRC32CB, CRC32CH, CRC32CW, and CRC32CX instructions are implemented.

   ATOMIC_NONE : constant := 2#0000#; -- No Atomic instructions implemented.
   ATOMIC_YES  : constant := 2#0010#; -- LDADD, LDCLR, LDEOR, LDSET, LDSMAX, LDSMIN, LDUMAX, LDUMIN, CAS, CASP, and SWP instructions implemented.

   TME_NONE : constant := 2#0000#; -- TME instructions are not implemented.
   TME_YES  : constant := 2#0001#; -- TCANCEL, TCOMMIT, TSTART, and TTEST instructions are implemented.

   RDM_NONE : constant := 2#0000#; -- No RDMA instructions implemented.
   RDM_YES  : constant := 2#0001#; -- SQRDMLAH and SQRDMLSH instructions implemented.

   SHA3_NONE : constant := 2#0000#; -- No SHA3 instructions implemented.
   SHA3_YES  : constant := 2#0001#; -- EOR3, RAX1, XAR, and BCAX instructions implemented.

   SM3_NONE : constant := 2#0000#; -- No SM3 instructions implemented.
   SM3_YES  : constant := 2#0001#; -- SM3SS1, SM3TT1A, SM3TT1B, SM3TT2A, SM3TT2B, SM3PARTW1, and SM3PARTW2 instructions implemented.

   SM4_NONE : constant := 2#0000#; -- No SM4 instructions implemented.
   SM4_YES  : constant := 2#0001#; -- SM4E and SM4EKEY instructions implemented.

   DP_NONE : constant := 2#0000#; -- No Dot Product instructions implemented.
   DP_YES  : constant := 2#0001#; -- UDOT and SDOT instructions implemented.

   FHM_NONE : constant := 2#0000#; -- FMLAL and FMLSL instructions are not implemented.
   FHM_YES  : constant := 2#0001#; -- FMLAL and FMLSL instructions are implemented.

   TS_NONE : constant := 2#0000#; -- No flag manipulation instructions are implemented.
   TS_YES  : constant := 2#0001#; -- CFINV, RMIF, SETF16, and SETF8 instructions are implemented.
   TS_AXXA : constant := 2#0010#; -- CFINV, RMIF, SETF16, SETF8, AXFLAG, and XAFLAG instructions are implemented.

   TLB_NONE  : constant := 2#0000#; -- Outer Shareable and TLB range maintenance instructions are not implemented.
   TLB_YES   : constant := 2#0001#; -- Outer Shareable TLB maintenance instructions are implemented.
   TLB_RANGE : constant := 2#0010#; -- Outer Shareable and TLB range maintenance instructions are implemented.

   RNDR_NONE : constant := 2#0000#; -- No Random Number instructions are implemented.
   RNDR_YES  : constant := 2#0001#; -- RNDR and RNDRRS registers are implemented.

   type ID_AA64ISAR0_EL1_Type is record
      Reserved : Bits_4;
      AES      : Bits_4; -- Indicates support for AES instructions in AArch64 state.
      SHA1     : Bits_4; -- Indicates support for SHA1 instructions in AArch64 state.
      SHA2     : Bits_4; -- Indicates support for SHA2 instructions in AArch64 state.
      CRC32    : Bits_4; -- Indicates support for CRC32 instructions in AArch64 state.
      Atomic   : Bits_4; -- Indicates support for Atomic instructions in AArch64 state.
      TME      : Bits_4; -- Indicates support for TME instructions.
      RDM      : Bits_4; -- Indicates support for SQRDMLAH and SQRDMLSH instructions in AArch64 state.
      SHA3     : Bits_4; -- Indicates support for SHA3 instructions in AArch64 state.
      SM3      : Bits_4; -- Indicates support for SM3 instructions in AArch64 state.
      SM4      : Bits_4; -- Indicates support for SM4 instructions in AArch64 state.
      DP       : Bits_4; -- Indicates support for Dot Product instructions in AArch64 state.
      FHM      : Bits_4; -- Indicates support for FMLAL and FMLSL instructions.
      TS       : Bits_4; -- Indicates support for flag manipulation instructions.
      TLB      : Bits_4; -- Indicates support for Outer Shareable and TLB range maintenance instructions.
      RNDR     : Bits_4; -- Indicates support for Random Number instructions in AArch64 state.
   end record
      with Bit_Order => Low_Order_First,
           Size      => 64;
   for ID_AA64ISAR0_EL1_Type use record
      Reserved at 0 range  0 ..  3;
      AES      at 0 range  4 ..  7;
      SHA1     at 0 range  8 .. 11;
      SHA2     at 0 range 12 .. 15;
      CRC32    at 0 range 16 .. 19;
      Atomic   at 0 range 20 .. 23;
      TME      at 0 range 24 .. 27;
      RDM      at 0 range 28 .. 31;
      SHA3     at 0 range 32 .. 35;
      SM3      at 0 range 36 .. 39;
      SM4      at 0 range 40 .. 43;
      DP       at 0 range 44 .. 47;
      FHM      at 0 range 48 .. 51;
      TS       at 0 range 52 .. 55;
      TLB      at 0 range 56 .. 59;
      RNDR     at 0 range 60 .. 63;
   end record;

   function ID_AA64ISAR0_EL1_Read
      return ID_AA64ISAR0_EL1_Type
      with Inline => True;

   -- D19.2.62 ID_AA64ISAR1_EL1, AArch64 Instruction Set Attribute Register 1

   DPB_NONE  : constant := 2#0000#; -- DC CVAP not supported.
   DPB_YES   : constant := 2#0001#; -- DC CVAP supported.
   DPB_CVADP : constant := 2#0010#; -- DC CVAP and DC CVADP supported.

   APA_NONE : constant := 2#0000#; -- Address Authentication using the QARMA5 algorithm is not implemented.
   APA_1    : constant := 2#0001#; -- Address Authentication using the QARMA5 algorithm is implemented, with the HaveEnhancedPAC() and HaveEnhancedPAC2() functions returning FALSE.
   APA_2    : constant := 2#0010#; -- Address Authentication using the QARMA5 algorithm is implemented, with the HaveEnhancedPAC() function returning TRUE and the HaveEnhancedPAC2() function returning FALSE.
   APA_3    : constant := 2#0011#; -- Address Authentication using the QARMA5 algorithm is implemented, with the HaveEnhancedPAC2() function returning TRUE, the HaveFPAC() function returning FALSE, the HaveFPACCombined() function returning FALSE, and the HaveEnhancedPAC() function returning FALSE.
   APA_4    : constant := 2#0100#; -- Address Authentication using the QARMA5 algorithm is implemented, with the HaveEnhancedPAC2() function returning TRUE, the HaveFPAC() function returning TRUE, the HaveFPACCombined() function returning FALSE, and the HaveEnhancedPAC() function returning FALSE.
   APA_5    : constant := 2#0101#; -- Address Authentication using the QARMA5 algorithm is implemented, with the HaveEnhancedPAC2() function returning TRUE, the HaveFPAC() function returning TRUE, the HaveFPACCombined() function returning TRUE, and the HaveEnhancedPAC() function returning FALSE.

   API_NONE : constant := 2#0000#; -- Address Authentication using an IMPLEMENTATION DEFINED algorithm is not implemented.
   API_1    : constant := 2#0001#; -- Address Authentication using an IMPLEMENTATION DEFINED algorithm is implemented, with the HaveEnhancedPAC() and HaveEnhancedPAC2() functions returning FALSE.
   API_2    : constant := 2#0010#; -- Address Authentication using an IMPLEMENTATION DEFINED algorithm is implemented, with the HaveEnhancedPAC() function returning TRUE, and the HaveEnhancedPAC2() function returning FALSE.
   API_3    : constant := 2#0011#; -- Address Authentication using an IMPLEMENTATION DEFINED algorithm is implemented, with the HaveEnhancedPAC2() function returning TRUE, and the HaveEnhancedPAC() function returning FALSE.
   API_4    : constant := 2#0100#; -- Address Authentication using an IMPLEMENTATION DEFINED algorithm is implemented, with the HaveEnhancedPAC2() function returning TRUE, the HaveFPAC() function returning TRUE, the HaveFPACCombined() function returning FALSE, and the HaveEnhancedPAC() function returning FALSE.
   API_5    : constant := 2#0101#; -- Address Authentication using an IMPLEMENTATION DEFINED algorithm is implemented, with the HaveEnhancedPAC2() function returning TRUE, the HaveFPAC() function returning TRUE, the HaveFPACCombined() function returning TRUE, and the HaveEnhancedPAC() function returning FALSE.

   JSCVT_NONE : constant := 2#0000#; -- The FJCVTZS instruction is not implemented.
   JSCVT_YES  : constant := 2#0001#; -- The FJCVTZS instruction is implemented.

   FCMA_NONE : constant := 2#0000#; -- The FCMLA and FCADD instructions are not implemented.
   FCMA_YES  : constant := 2#0001#; -- The FCMLA and FCADD instructions are implemented.

   LRCPC_NONE      : constant := 2#0000#; -- RCpc instructions are not implemented.
   LRCPC_YES       : constant := 2#0001#; -- The no offset LDAPR, LDAPRB, and LDAPRH instructions are implemented.
   LRCPC_LDAPRSTLR : constant := 2#0010#; -- As 0b0001, and the LDAPR (unscaled immediate) and STLR (unscaled immediate) instructions are implemented.

   GPA_NONE : constant := 2#0000#; -- Generic Authentication using the QARMA5 algorithm is not implemented.
   GPA_YES  : constant := 2#0001#; -- Generic Authentication using the QARMA5 algorithm is implemented. This includes the PACGA instruction.

   GPI_NONE : constant := 2#0000#; -- Generic Authentication using an IMPLEMENTATION DEFINED algorithm is not implemented.
   GPI_YES  : constant := 2#0001#; -- Generic Authentication using an IMPLEMENTATION DEFINED algorithm is implemented. This includes the PACGA instruction.

   FRINTTS_NONE : constant := 2#0000#; -- FRINT32Z, FRINT32X, FRINT64Z, and FRINT64X instructions are not implemented.
   FRINTTS_YES  : constant := 2#0001#; -- FRINT32Z, FRINT32X, FRINT64Z, and FRINT64X instructions are implemented.

   SB_NONE : constant := 2#0000#; -- SB instruction is not implemented.
   SB_YES  : constant := 2#0001#; -- SB instruction is implemented.

   SPECRES_NONE : constant := 2#0000#; -- Prediction invalidation instructions are not implemented.
   SPECRES_YES  : constant := 2#0001#; -- CFP RCTX, DVP RCTX and CPP RCTX instructions are implemented.

   BF16_NONE    : constant := 2#0000#; -- BFloat16 instructions are not implemented.
   BF16_YES     : constant := 2#0001#; -- BFCVT, BFCVTN, BFCVTN2, BFDOT, BFMLALB, BFMLALT, and BFMMLA instructions are implemented.
   BF16_FPCREBF : constant := 2#0010#; -- As 0b0001, but the FPCR.EBF field is also supported.

   DGH_NONE : constant := 2#0000#; -- Data Gathering Hint is not implemented.
   DGH_YES  : constant := 2#0001#; -- Data Gathering Hint is implemented.

   I8MM_NONE : constant := 2#0000#; -- Int8 matrix multiplication instructions are not implemented.
   I8MM_YES  : constant := 2#0001#; -- SMMLA, SUDOT, UMMLA, USMMLA, and USDOT instructions are implemented.

   XS_NONE : constant := 2#0000#; -- The XS attribute, the TLBI and DSB instructions with the nXS qualifier, and the HCRX_EL2.{FGTnXS, FnXS} fields are not supported.
   XS_YES  : constant := 2#0001#; -- The XS attribute, the TLBI and DSB instructions with the nXS qualifier, and the HCRX_EL2.{FGTnXS, FnXS} fields are supported.

   LS64_NONE   : constant := 2#0000#; -- The LD64B, ST64B, ST64BV, and ST64BV0 instructions, the ACCDATA_EL1 register, and associated traps are not supported.
   LS64_YES    : constant := 2#0001#; -- The LD64B and ST64B instructions are supported.
   LS64_TRAPS1 : constant := 2#0010#; -- The LD64B, ST64B, and ST64BV instructions, and their associated traps are supported.
   LS64_TRAPS2 : constant := 2#0011#; -- The LD64B, ST64B, ST64BV, and ST64BV0 instructions, the ACCDATA_EL1 register, and their associated traps are supported.

   type ID_AA64ISAR1_EL1_Type is record
      DPB     : Bits_4; -- Data Persistence writeback. Indicates support for the DC CVAP and DC CVADP instructions in AArch64 state.
      APA     : Bits_4; -- Indicates whether the QARMA5 algorithm is implemented in the PE for address authentication, in AArch64 state.
      API     : Bits_4; -- Indicates whether an IMPLEMENTATION DEFINED algorithm is implemented in the PE for address authentication, in AArch64 state.
      JSCVT   : Bits_4; -- Indicates support for JavaScript conversion from double precision floating point values to integers in AArch64 state.
      FCMA    : Bits_4; -- Indicates support for complex number addition and multiplication, where numbers are stored in vectors.
      LRCPC   : Bits_4; -- Indicates support for weaker release consistency, RCpc, based model.
      GPA     : Bits_4; -- Indicates whether the QARMA5 algorithm is implemented in the PE for generic code authentication in AArch64 state.
      GPI     : Bits_4; -- Indicates support for an IMPLEMENTATION DEFINED algorithm is implemented in the PE for generic code authentication in AArch64 state.
      FRINTTS : Bits_4; -- Indicates support for the FRINT32Z, FRINT32X, FRINT64Z, and FRINT64X instructions are implemented.
      SB      : Bits_4; -- Indicates support for SB instruction in AArch64 state.
      SPECRES : Bits_4; -- Indicates support for prediction invalidation instructions in AArch64 state.
      BF16    : Bits_4; -- Indicates support for Advanced SIMD and Floating-point BFloat16 instructions in AArch64 state.
      DGH     : Bits_4; -- Indicates support for the Data Gathering Hint instruction.
      I8MM    : Bits_4; -- Indicates support for Advanced SIMD and Floating-point Int8 matrix multiplication instructions in AArch64 state.
      XS      : Bits_4; -- Indicates support for the XS attribute, the TLBI and DSB instructions with the nXS qualifier, and the HCRX_EL2.{FGTnXS, FnXS} fields in AArch64 state.
      LS64    : Bits_4; -- Indicates support for LD64B and ST64B* instructions, and the ACCDATA_EL1 register.
   end record
      with Bit_Order => Low_Order_First,
           Size      => 64;
   for ID_AA64ISAR1_EL1_Type use record
      DPB     at 0 range  0 ..  3;
      APA     at 0 range  4 ..  7;
      API     at 0 range  8 .. 11;
      JSCVT   at 0 range 12 .. 15;
      FCMA    at 0 range 16 .. 19;
      LRCPC   at 0 range 20 .. 23;
      GPA     at 0 range 24 .. 27;
      GPI     at 0 range 28 .. 31;
      FRINTTS at 0 range 32 .. 35;
      SB      at 0 range 36 .. 39;
      SPECRES at 0 range 40 .. 43;
      BF16    at 0 range 44 .. 47;
      DGH     at 0 range 48 .. 51;
      I8MM    at 0 range 52 .. 55;
      XS      at 0 range 56 .. 59;
      LS64    at 0 range 60 .. 63;
   end record;

   function ID_AA64ISAR1_EL1_Read
      return ID_AA64ISAR1_EL1_Type
      with Inline => True;

   -- D19.2.63 ID_AA64ISAR2_EL1, AArch64 Instruction Set Attribute Register 2

   WFxT_NONE : constant := 2#0000#; -- WFET and WFIT are not supported.
   WFxT_YES  : constant := 2#0010#; -- WFET and WFIT are supported, and the register number is reported in the ESR_ELx on exceptions.

   RPRES_NONE : constant := 2#0000#; -- When FPCR.AH == 1: Reciprocal and reciprocal square root estimates give 8 bits of mantissa, when FPCR.AH is 1.
   RPRES_YES  : constant := 2#0001#; -- When FPCR.AH == 1: Reciprocal and reciprocal square root estimates give 12 bits of mantissa, when FPCR.AH is 1.

   GPA3_NONE : constant := 2#0000#; -- Generic Authentication using the QARMA3 algorithm is not implemented.
   GPA3_YES  : constant := 2#0001#; -- Generic Authentication using the QARMA3 algorithm is implemented. This includes the PACGA instruction.

   APA3_NONE : constant := 2#0000#; -- Address Authentication using the QARMA3 algorithm is not implemented.
   APA3_1    : constant := 2#0001#; -- Address Authentication using the QARMA3 algorithm is implemented, with the HaveEnhancedPAC() and HaveEnhancedPAC2() functions returning FALSE.
   APA3_2    : constant := 2#0010#; -- Address Authentication using the QARMA3 algorithm is implemented, with the HaveEnhancedPAC() function returning TRUE and the HaveEnhancedPAC2() function returning FALSE.
   APA3_3    : constant := 2#0011#; -- Address Authentication using the QARMA3 algorithm is implemented, with the HaveEnhancedPAC2() function returning TRUE, the HaveFPAC() function returning FALSE, the HaveFPACCombined() function returning FALSE, and the HaveEnhancedPAC() function returning FALSE.
   APA3_4    : constant := 2#0100#; -- Address Authentication using the QARMA3 algorithm is implemented, with the HaveEnhancedPAC2() function returning TRUE, the HaveFPAC() function returning TRUE, the HaveFPACCombined() function returning FALSE, and the HaveEnhancedPAC() function returning FALSE.
   APA3_5    : constant := 2#0101#; -- Address Authentication using the QARMA3 algorithm is implemented, with the HaveEnhancedPAC2() function returning TRUE, the HaveFPAC() function returning TRUE, the HaveFPACCombined() function returning TRUE, and the HaveEnhancedPAC() function returning FALSE.

   MOPS_NONE : constant := 2#0000#; -- The Memory Copy and Memory Set instructions are not implemented in AArch64 state.
   MOPS_YES  : constant := 2#0001#; -- The Memory Copy and Memory Set instructions are implemented in AArch64 state with the following exception. If FEAT_MTE is implemented, then SETGP*, SETGM* and SETGE* instructions are also supported.

   BC_NONE : constant := 2#0000#; -- BC instruction is not implemented.
   BC_YES  : constant := 2#0001#; -- BC instruction is implemented.

   PAC_NONE : constant := 2#0000#; -- ConstPACField() returns FALSE.
   PAC_YES  : constant := 2#0001#; -- ConstPACField() returns TRUE.

   type ID_AA64ISAR2_EL1_Type is record
      WFxT     : Bits_4;  -- Indicates support for the WFET and WFIT instructions in AArch64 state.
      RPRES    : Bits_4;  -- Indicates support for 12 bits of mantissa in reciprocal and reciprocal square root instructions in AArch64 state, when FPCR.AH is 1.
      GPA3     : Bits_4;  -- Indicates whether the QARMA3 algorithm is implemented in the PE for generic code authentication in AArch64 state.
      APA3     : Bits_4;  -- Indicates whether the QARMA3 algorithm is implemented in the PE for address authentication in AArch64 state.
      MOPS     : Bits_4;  -- Indicates support for the Memory Copy and Memory Set instructions in AArch64 state.
      BC       : Bits_4;  -- Indicates support for the BC instruction in AArch64 state.
      PAC      : Bits_4;  -- Indicates whether the ConstPACField() function used as part of the PAC addition returns FALSE or TRUE.
      Reserved : Bits_36;
   end record
      with Bit_Order => Low_Order_First,
           Size      => 64;
   for ID_AA64ISAR2_EL1_Type use record
      WFxT     at 0 range  0 ..  3;
      RPRES    at 0 range  4 ..  7;
      GPA3     at 0 range  8 .. 11;
      APA3     at 0 range 12 .. 15;
      MOPS     at 0 range 16 .. 19;
      BC       at 0 range 20 .. 23;
      PAC      at 0 range 24 .. 27;
      Reserved at 0 range 28 .. 63;
   end record;

   function ID_AA64ISAR2_EL1_Read
      return ID_AA64ISAR2_EL1_Type
      with Inline => True;

   -- D19.2.64 ID_AA64MMFR0_EL1, AArch64 Memory Model Feature Register 0
   -- D19.2.65 ID_AA64MMFR1_EL1, AArch64 Memory Model Feature Register 1
   -- D19.2.66 ID_AA64MMFR2_EL1, AArch64 Memory Model Feature Register 2
   -- D19.2.67 ID_AA64MMFR3_EL1, AArch64 Memory Model Feature Register 3
   -- D19.2.68 ID_AA64MMFR4_EL1, AArch64 Memory Model Feature Register 4
   -- D19.2.69 ID_AA64PFR0_EL1, AArch64 Processor Feature Register 0
   -- D19.2.70 ID_AA64PFR1_EL1, AArch64 Processor Feature Register 1
   -- D19.2.71 ID_AA64PFR2_EL1, AArch64 Processor Feature Register 2
   -- D19.2.72 ID_AA64SMFR0_EL1, SME Feature ID register 0
   -- D19.2.73 ID_AA64ZFR0_EL1, SVE Feature ID register 0
   -- D19.2.74 ID_AFR0_EL1, AArch32 Auxiliary Feature Register 0
   -- D19.2.75 ID_DFR0_EL1, AArch32 Debug Feature Register 0
   -- D19.2.76 ID_DFR1_EL1, Debug Feature Register 1
   -- D19.2.77 ID_ISAR0_EL1, AArch32 Instruction Set Attribute Register 0
   -- D19.2.78 ID_ISAR1_EL1, AArch32 Instruction Set Attribute Register 1
   -- D19.2.79 ID_ISAR2_EL1, AArch32 Instruction Set Attribute Register 2
   -- D19.2.80 ID_ISAR3_EL1, AArch32 Instruction Set Attribute Register 3
   -- D19.2.81 ID_ISAR4_EL1, AArch32 Instruction Set Attribute Register 4
   -- D19.2.82 ID_ISAR5_EL1, AArch32 Instruction Set Attribute Register 5
   -- D19.2.83 ID_ISAR6_EL1, AArch32 Instruction Set Attribute Register 6
   -- D19.2.84 ID_MMFR0_EL1, AArch32 Memory Model Feature Register 0
   -- D19.2.85 ID_MMFR1_EL1, AArch32 Memory Model Feature Register 1
   -- D19.2.86 ID_MMFR2_EL1, AArch32 Memory Model Feature Register 2
   -- D19.2.87 ID_MMFR3_EL1, AArch32 Memory Model Feature Register 3
   -- D19.2.88 ID_MMFR4_EL1, AArch32 Memory Model Feature Register 4
   -- D19.2.89 ID_MMFR5_EL1, AArch32 Memory Model Feature Register 5
   -- D19.2.90 ID_PFR0_EL1, AArch32 Processor Feature Register 0
   -- D19.2.91 ID_PFR1_EL1, AArch32 Processor Feature Register 1
   -- D19.2.92 ID_PFR2_EL1, AArch32 Processor Feature Register 2
   -- D19.2.93 IFSR32_EL2, Instruction Fault Status Register (EL2)

   -- D19.2.94 ISR_EL1, Interrupt Status Register

   type ISR_EL1_Type is record
      Reserved1 : Bits_6;
      F         : Boolean; -- FIQ pending bit.
      I         : Boolean; -- IRQ pending bit.
      A         : Boolean; -- SError interrupt pending bit.
      F_S       : Boolean; -- FIQ with Superpriority pending bit.
      I_S       : Boolean; -- IRQ with Superpriority pending bit.
      Reserved2 : Bits_53;
   end record
      with Bit_Order => Low_Order_First,
           Size      => 64;
   for ISR_EL1_Type use record
      Reserved1 at 0 range  0 ..  5;
      F         at 0 range  6 ..  6;
      I         at 0 range  7 ..  7;
      A         at 0 range  8 ..  8;
      F_S       at 0 range  9 ..  9;
      I_S       at 0 range 10 .. 10;
      Reserved2 at 0 range 11 .. 63;
   end record;

   function ISR_EL1_Read
      return ISR_EL1_Type
      with Inline => True;

   -- D19.2.95 LORC_EL1, LORegion Control (EL1)
   -- D19.2.96 LOREA_EL1, LORegion End Address (EL1)
   -- D19.2.97 LORID_EL1, LORegionID (EL1)
   -- D19.2.98 LORN_EL1, LORegion Number (EL1)
   -- D19.2.99 LORSA_EL1, LORegion Start Address (EL1)

   -- D19.2.100 MAIR_EL1, Memory Attribute Indirection Register (EL1)
   -- D19.2.101 MAIR_EL2, Memory Attribute Indirection Register (EL2)
   -- D19.2.102 MAIR_EL3, Memory Attribute Indirection Register (EL3)

   type MAIR_Array_Type is array (0 .. 7) of Memory_Attribute_Type
      with Pack => True,
           Size => 64;

   type MAIR_ELx_Type is record
      Attr : MAIR_Array_Type;
   end record
      with Size => 64;

   function MAIR_EL1_Read
      return MAIR_ELx_Type
      with Inline => True;
   procedure MAIR_EL1_Write
      (Value : in MAIR_ELx_Type)
      with Inline => True;
   function MAIR_EL2_Read
      return MAIR_ELx_Type
      with Inline => True;
   procedure MAIR_EL2_Write
      (Value : in MAIR_ELx_Type)
      with Inline => True;
   function MAIR_EL3_Read
      return MAIR_ELx_Type
      with Inline => True;
   procedure MAIR_EL3_Write
      (Value : in MAIR_ELx_Type)
      with Inline => True;

   -- D19.2.103 MIDR_EL1, Main ID Register

   -- D19.2.104 MPIDR_EL1, Multiprocessor Affinity Register

   type MPIDR_EL1_Type is record
      Aff0      : Unsigned_8; -- Affinity level 0.
      Aff1      : Unsigned_8; -- Affinity level 1.
      Aff2      : Unsigned_8; -- Affinity level 2.
      MT        : Boolean;    -- Indicates whether the lowest level of affinity consists of logical PEs that are implemented using a multithreading type approach. See the description of Aff0 for more information about affinity levels.
      Reserved1 : Bits_5;
      U         : Boolean;    -- Indicates a Uniprocessor system, as distinct from PE 0 in a multiprocessor system.
      Reserved2 : Bits_1;
      Aff3      : Unsigned_8; -- Affinity level 3.
      Reserved3 : Bits_24;
   end record
      with Bit_Order => Low_Order_First,
           Size      => 64;
   for MPIDR_EL1_Type use record
      Aff0      at 0 range  0 ..  7;
      Aff1      at 0 range  8 .. 15;
      Aff2      at 0 range 16 .. 23;
      MT        at 0 range 24 .. 24;
      Reserved1 at 0 range 25 .. 29;
      U         at 0 range 30 .. 30;
      Reserved2 at 0 range 31 .. 31;
      Aff3      at 0 range 32 .. 39;
      Reserved3 at 0 range 40 .. 63;
   end record;

   function MPIDR_EL1_Read
      return MPIDR_EL1_Type
      with Inline => True;

   -- D19.2.105 MVFR0_EL1, AArch32 Media and VFP Feature Register 0
   -- D19.2.106 MVFR1_EL1, AArch32 Media and VFP Feature Register 1
   -- D19.2.107 MVFR2_EL1, AArch32 Media and VFP Feature Register 2
   -- D19.2.108 PAR_EL1, Physical Address Register
   -- D19.2.109 REVIDR_EL1, Revision ID Register
   -- D19.2.110 RGSR_EL1, Random Allocation Tag Seed Register.
   -- D19.2.111 RMR_EL1, Reset Management Register (EL1)
   -- D19.2.112 RMR_EL2, Reset Management Register (EL2)
   -- D19.2.113 RMR_EL3, Reset Management Register (EL3)
   -- D19.2.114 RNDR, Random Number
   -- D19.2.115 RNDRRS, Reseeded Random Number
   -- D19.2.116 RVBAR_EL1, Reset Vector Base Address Register (if EL2 and EL3 not implemented)
   -- D19.2.117 RVBAR_EL2, Reset Vector Base Address Register (if EL3 not implemented)
   -- D19.2.118 RVBAR_EL3, Reset Vector Base Address Register (if EL3 implemented)
   -- D19.2.119 S3_<op1>_<Cn>_<Cm>_<op2>, IMPLEMENTATION DEFINED registers

   -- D19.2.120 SCR_EL3, Secure Configuration Register

   type Non_Secure_Type is record
      NS  : Bits_1;
      NSE : Bits_1;
   end record;

   Non_Secure_Secure    : constant Non_Secure_Type := (0, 0); -- Secure.
   Non_Secure_NonSecure : constant Non_Secure_Type := (0, 1); -- Non-secure.
   Non_Secure_Reserved  : constant Non_Secure_Type := (1, 0); -- Reserved.
   Non_Secure_Realm     : constant Non_Secure_Type := (1, 1); -- Realm.

   type SCR_EL3_Type is record
      NS        : Bits_1;           -- Non-secure bit.
      IRQ       : Boolean;          -- Physical IRQ Routing.
      FIQ       : Boolean;          -- Physical FIQ Routing.
      EA        : Boolean;          -- External Abort and SError interrupt routing.
      Reserved1 : Bits_2  := 2#11#;
      Reserved2 : Bits_1  := 0;
      SMD       : Boolean;          -- Secure Monitor Call disable.
      HCE       : Boolean;          -- Hypervisor Call instruction enable.
      SIF       : Boolean;          -- Secure instruction fetch.
      RW        : Boolean;          -- Execution state control for lower Exception levels.
      ST        : Boolean;          -- Traps Secure EL1 accesses to the Counter-timer Physical Secure timer registers to EL3, from AArch64 state only, reported using an ESR_ELx.EC value of 0x18.
      TWI       : Boolean;          -- Traps EL2, EL1, and EL0 execution of WFI instructions to EL3, from any Security state and both Execution states, reported using an ESR_ELx.EC value of 0x01 .
      TWE       : Boolean;          -- Traps EL2, EL1, and EL0 execution of WFE instructions to EL3, from any Security state and both Execution states, reported using an ESR_ELx.EC value of 0x01 .
      TLOR      : Boolean;          -- Trap LOR registers.
      TERR      : Boolean;          -- Trap accesses of error record registers.
      APK       : Boolean;          -- Trap registers holding "key" values for Pointer Authentication.
      API       : Boolean;          -- Controls the use of the following instructions related to Pointer Authentication.
      EEL2      : Boolean;          -- Secure EL2 Enable.
      EASE      : Boolean;          -- External aborts to SError interrupt vector.
      NMEA      : Boolean;          -- Non-maskable External Aborts.
      FIEN      : Boolean;          -- Fault Injection enable.
      Reserved3 : Bits_3  := 0;
      EnSCXT    : Boolean;          -- Enables access to the SCXTNUM_EL2, SCXTNUM_EL1, and SCXTNUM_EL0 registers.
      ATA       : Boolean;          -- Allocation Tag Access.
      FGTEn     : Boolean;          -- Fine-Grained Traps Enable.
      ECVEn     : Boolean;          -- ECV Enable.
      TWEDEn    : Boolean;          -- TWE Delay Enable.
      TWEDEL    : Bits_4;           -- TWE Delay.
      TME       : Boolean;          -- Enables access to the TSTART, TCOMMIT, TTEST and TCANCEL instructions at EL0, EL1 and EL2.
      AMVOFFEN  : Boolean;          -- Activity Monitors Virtual Offsets Enable.
      EnAS0     : Boolean;          -- Traps execution of an ST64BV0 instruction at EL0, EL1, or EL2 to EL3.
      ADEn      : Boolean;          -- Enables access to the ACCDATA_EL1 register at EL1 and EL2.
      HXEn      : Boolean;          -- Enables access to the HCRX_EL2 register at EL2 from EL3.
      Reserved4 : Bits_1  := 0;
      TRNDR     : Boolean;          -- Controls trapping of reads of RNDR and RNDRRS.
      EnTP2     : Boolean;          -- Traps instructions executed at EL2, EL1, and EL0 that access TPIDR2_EL0 to EL3.
      Reserved5 : Bits_1  := 0;
      TCR2En    : Boolean;          -- TCR2_ELx register trap control.
      SCTLR2En  : Boolean;          -- SCTLR2_ELx register trap control.
      Reserved6 : Bits_3  := 0;
      GPF       : Boolean;          -- Controls the reporting of Granule protection faults at EL0, EL1 and EL2.
      MECEn     : Boolean;          -- Enables access to the following EL2 MECID registers, from EL2: ...
      Reserved7 : Bits_12 := 0;
      NSE       : Bits_1;           -- This field, evaluated with SCR_EL3.NS, selects the Security state of EL2 and lower Exception levels.
      Reserved8 : Bits_1  := 0;
   end record
      with Bit_Order => Low_Order_First,
           Size      => 64;
   for SCR_EL3_Type use record
      NS        at 0 range  0 ..  0;
      IRQ       at 0 range  1 ..  1;
      FIQ       at 0 range  2 ..  2;
      EA        at 0 range  3 ..  3;
      Reserved1 at 0 range  4 ..  5;
      Reserved2 at 0 range  6 ..  6;
      SMD       at 0 range  7 ..  7;
      HCE       at 0 range  8 ..  8;
      SIF       at 0 range  9 ..  9;
      RW        at 0 range 10 .. 10;
      ST        at 0 range 11 .. 11;
      TWI       at 0 range 12 .. 12;
      TWE       at 0 range 13 .. 13;
      TLOR      at 0 range 14 .. 14;
      TERR      at 0 range 15 .. 15;
      APK       at 0 range 16 .. 16;
      API       at 0 range 17 .. 17;
      EEL2      at 0 range 18 .. 18;
      EASE      at 0 range 19 .. 19;
      NMEA      at 0 range 20 .. 20;
      FIEN      at 0 range 21 .. 21;
      Reserved3 at 0 range 22 .. 24;
      EnSCXT    at 0 range 25 .. 25;
      ATA       at 0 range 26 .. 26;
      FGTEn     at 0 range 27 .. 27;
      ECVEn     at 0 range 28 .. 28;
      TWEDEn    at 0 range 29 .. 29;
      TWEDEL    at 0 range 30 .. 33;
      TME       at 0 range 34 .. 34;
      AMVOFFEN  at 0 range 35 .. 35;
      EnAS0     at 0 range 36 .. 36;
      ADEn      at 0 range 37 .. 37;
      HXEn      at 0 range 38 .. 38;
      Reserved4 at 0 range 39 .. 39;
      TRNDR     at 0 range 40 .. 40;
      EnTP2     at 0 range 41 .. 41;
      Reserved5 at 0 range 42 .. 42;
      TCR2En    at 0 range 43 .. 43;
      SCTLR2En  at 0 range 44 .. 44;
      Reserved6 at 0 range 45 .. 47;
      GPF       at 0 range 48 .. 48;
      MECEn     at 0 range 49 .. 49;
      Reserved7 at 0 range 50 .. 61;
      NSE       at 0 range 62 .. 62;
      Reserved8 at 0 range 63 .. 63;
   end record;

   function SCR_EL3_Read
      return SCR_EL3_Type
      with Inline => True;
   procedure SCR_EL3_Write
      (Value : in SCR_EL3_Type)
      with Inline => True;

   -- D19.2.121 SCTLR2_EL1, System Control Register (EL1)
   -- D19.2.122 SCTLR2_EL2, System Control Register (EL2)
   -- D19.2.123 SCTLR2_EL3, System Control Register (EL3)

   -- D19.2.124 SCTLR_EL1, System Control Register (EL1)

   E0E_LE : constant := 0; -- Explicit data accesses at EL0 are little-endian.
   E0E_BE : constant := 1; -- Explicit data accesses at EL0 are big-endian.

   EE_LE : constant := 0; -- Little-endian.
   EE_BE : constant := 1; -- Big-endian.

   TCF_NONE     : constant := 2#00#; -- Tag Check Faults have no effect on the PE.
   TCF_SYN      : constant := 2#01#; -- Tag Check Faults cause a synchronous exception.
   TCF_ACC      : constant := 2#10#; -- Tag Check Faults are asynchronously accumulated.
   TCF_RSYNWACC : constant := 2#11#; -- [FEAT_MTE3] Tag Check Faults cause a syn exc on reads, and are asyn acc on writes.

   DSSBS_0 : constant := 0; -- PSTATE.SSBS is set to 0 on an exception to EL1.
   DSSBS_1 : constant := 1; -- PSTATE.SSBS is set to 1 on an exception to EL1.

   type SCTLR_EL1_Type is record
      M          : Boolean;      -- MMU enable for EL1&0 stage 1 address translation.
      A          : Boolean;      -- Alignment check enable.
      C          : Boolean;      -- Stage 1 Cacheability control, for data accesses.
      SA         : Boolean;      -- SP Alignment check enable.
      SA0        : Boolean;      -- SP Alignment check enable for EL0.
      CP15BEN    : Boolean;      -- System instruction memory barrier enable.
      nAA        : Boolean;      -- Non-aligned access.
      ITD        : Boolean;      -- IT disable.
      SED        : Boolean;      -- SETEND instruction disable.
      UMA        : Boolean;      -- User Mask Access.
      EnRCTX     : Boolean;      -- Enable EL0 access to the following System instructions: ...
      EOS        : Boolean;      -- Exception Exit is Context Synchronizing.
      I          : Boolean;      -- Stage 1 instruction access Cacheability control, for accesses at EL0 and EL1: ...
      EnDB       : Boolean;      -- Controls enabling of pointer authentication (using the APDBKey_EL1 key) of instruction addresses in the EL1&0 translation regime.
      DZE        : Boolean;      -- Traps EL0 execution of DC ZVA instructions to EL1, or to EL2 when it is implemented and enabled for the current Security state and HCR_EL2.TGE is 1, from AArch64 state only, reported using an ESR_ELx.EC value of 0x18.
      UCT        : Boolean;      -- Traps EL0 accesses to the CTR_EL0 to EL1, or to EL2 when it is implemented and enabled for the current Security state and HCR_EL2.TGE is 1, from AArch64 state only, reported using an ESR_ELx.EC value of 0x18.
      nTWI       : Boolean;      -- Traps EL0 execution of WFI instructions to EL1, or to EL2 when it is implemented and enabled for the current Security state and HCR_EL2.TGE is 1, from both Execution states, reported using an ESR_ELx.EC value of 0x01.
      Reserved1  : Bits_1  := 0;
      nTWE       : Boolean;      -- Traps EL0 execution of WFE instructions to EL1, or to EL2 when it is implemented and enabled for the current Security state and HCR_EL2.TGE is 1, from both Execution states, reported using an ESR_ELx.EC value of 0x01.
      WXN        : Boolean;      -- Write permission implies Execute Never (XN).
      TSCXT      : Boolean;      -- Trap EL0 Access to the SCXTNUM_EL0 register, when EL0 is using AArch64.
      IESB       : Boolean;      -- Implicit Error Synchronization event enable.
      EIS        : Boolean;      -- Exception Entry is Context Synchronizing.
      SPAN       : Boolean;      -- Set Privileged Access Never, on taking an exception to EL1.
      E0E        : Bits_1;       -- Endianness of data accesses at EL0.
      EE         : Bits_1;       -- Endianness of data accesses at EL1, and stage 1 translation table walks in the EL1&0 translation regime.
      UCI        : Boolean;      -- Enables EL0 access to the DC CVAU, DC CIVAC, DC CVAC and IC IVAU instrs in AArch64 state.
      EnDA       : Boolean;      -- Controls enabling of pointer authentication (using the APDAKey_EL1 key) of instruction addresses in the EL1&0 translation regime.
      nTLSMD     : Boolean;      -- No Trap Load Multiple and Store Multiple to Device-nGRE/Device-nGnRE/Device-nGnRnE memory.
      LSMAOE     : Boolean;      -- Load Multiple and Store Multiple Atomicity and Ordering Enable.
      EnIB       : Boolean;      -- Controls enabling of pointer authentication (using the APIBKey_EL1 key) of instruction addresses in the EL1&0 translation regime.
      EnIA       : Boolean;      -- Controls enabling of pointer authentication (using the APIAKey_EL1 key) of instruction addresses in the EL1&0 translation regime.
      CMOW       : Boolean;      -- Controls cache maintenance instruction permission for the following instructions executed at EL0. ...
      MSCEn      : Boolean;      -- Memory Copy and Memory Set instructions Enable.
      Reserved2  : Bits_1  := 0;
      BT0        : Boolean;      -- PAC Branch Type compatibility at EL0.
      BT1        : Boolean;      -- PAC Branch Type compatibility at EL1.
      ITFSB      : Boolean;      -- When synchronous exceptions are not being generated by Tag Check Faults, this field controls whether on exception entry into EL1, all Tag Check Faults due to instructions executed before exception entry, that are reported asynchronously, are synchronized into TFSRE0_EL1 and TFSR_EL1 registers.
      TCF0       : Bits_2;       -- Tag Check Fault in EL0.
      TCF        : Bits_2;       -- Tag Check Fault in EL1.
      ATA0       : Boolean;      -- Allocation Tag Access in EL0.
      ATA        : Boolean;      -- Allocation Tag Access in EL1.
      DSSBS      : Bits_1;       -- Default PSTATE.SSBS value on Exception Entry.
      TWEDEn     : Boolean;      -- TWE Delay Enable.
      TWEDEL     : Bits_4;       -- TWE Delay.
      TMT0       : Boolean;      -- Forces a trivial implementation of the Transactional Memory Extension at EL0.
      TMT        : Boolean;      -- Forces a trivial implementation of the Transactional Memory Extension at EL1.
      TME0       : Boolean;      -- Enables the Transactional Memory Extension at EL0.
      TME        : Boolean;      -- Enables the Transactional Memory Extension at EL1.
      EnASR      : Boolean;      -- When HCR_EL2.{E2H, TGE} != {1, 1}, traps execution of an ST64BV instruction at EL0 to EL1.
      EnAS0      : Boolean;      -- When HCR_EL2.{E2H, TGE} != {1, 1}, traps execution of an ST64BV0 instruction at EL0 to EL1.
      EnALS      : Boolean;      -- When HCR_EL2.{E2H, TGE} != {1, 1}, traps execution of an LD64B or ST64B instruction at EL0 to EL1.
      EPAN       : Boolean;      -- Enhanced Privileged Access Never.
      Reserved3  : Bits_2  := 0;
      EnTP2      : Boolean;      -- Traps instructions executed at EL0 that access TPIDR2_EL0 to EL1, or to EL2 when EL2 is implemented and enabled for the current Security state and HCR_EL2.TGE is 1.
      NMI        : Boolean;      -- Non-maskable Interrupt enable.
      SPINTMASK  : Boolean;      -- SP Interrupt Mask enable.
      TIDCP      : Boolean;      -- Trap IMPLEMENTATION DEFINED functionality.
   end record
      with Bit_Order => Low_Order_First,
           Size      => 64;
   for SCTLR_EL1_Type use record
      M          at 0 range  0 ..  0;
      A          at 0 range  1 ..  1;
      C          at 0 range  2 ..  2;
      SA         at 0 range  3 ..  3;
      SA0        at 0 range  4 ..  4;
      CP15BEN    at 0 range  5 ..  5;
      nAA        at 0 range  6 ..  6;
      ITD        at 0 range  7 ..  7;
      SED        at 0 range  8 ..  8;
      UMA        at 0 range  9 ..  9;
      EnRCTX     at 0 range 10 .. 10;
      EOS        at 0 range 11 .. 11;
      I          at 0 range 12 .. 12;
      EnDB       at 0 range 13 .. 13;
      DZE        at 0 range 14 .. 14;
      UCT        at 0 range 15 .. 15;
      nTWI       at 0 range 16 .. 16;
      Reserved1  at 0 range 17 .. 17;
      nTWE       at 0 range 18 .. 18;
      WXN        at 0 range 19 .. 19;
      TSCXT      at 0 range 20 .. 20;
      IESB       at 0 range 21 .. 21;
      EIS        at 0 range 22 .. 22;
      SPAN       at 0 range 23 .. 23;
      E0E        at 0 range 24 .. 24;
      EE         at 0 range 25 .. 25;
      UCI        at 0 range 26 .. 26;
      EnDA       at 0 range 27 .. 27;
      nTLSMD     at 0 range 28 .. 28;
      LSMAOE     at 0 range 29 .. 29;
      EnIB       at 0 range 30 .. 30;
      EnIA       at 0 range 31 .. 31;
      CMOW       at 0 range 32 .. 32;
      MSCEn      at 0 range 33 .. 33;
      Reserved2  at 0 range 34 .. 34;
      BT0        at 0 range 35 .. 35;
      BT1        at 0 range 36 .. 36;
      ITFSB      at 0 range 37 .. 37;
      TCF0       at 0 range 38 .. 39;
      TCF        at 0 range 40 .. 41;
      ATA0       at 0 range 42 .. 42;
      ATA        at 0 range 43 .. 43;
      DSSBS      at 0 range 44 .. 44;
      TWEDEn     at 0 range 45 .. 45;
      TWEDEL     at 0 range 46 .. 49;
      TMT0       at 0 range 50 .. 50;
      TMT        at 0 range 51 .. 51;
      TME0       at 0 range 52 .. 52;
      TME        at 0 range 53 .. 53;
      EnASR      at 0 range 54 .. 54;
      EnAS0      at 0 range 55 .. 55;
      EnALS      at 0 range 56 .. 56;
      EPAN       at 0 range 57 .. 57;
      Reserved3  at 0 range 58 .. 59;
      EnTP2      at 0 range 60 .. 60;
      NMI        at 0 range 61 .. 61;
      SPINTMASK  at 0 range 62 .. 62;
      TIDCP      at 0 range 63 .. 63;
   end record;

   function SCTLR_EL1_Read
      return SCTLR_EL1_Type
      with Inline => True;
   procedure SCTLR_EL1_Write
      (Value : in SCTLR_EL1_Type)
      with Inline => True;

   -- D19.2.125 SCTLR_EL2, System Control Register (EL2)
   -- D19.2.126 SCTLR_EL3, System Control Register (EL3)
   -- D19.2.127 SCXTNUM_EL0, EL0 Read/Write Software Context Number
   -- D19.2.128 SCXTNUM_EL1, EL1 Read/Write Software Context Number
   -- D19.2.129 SCXTNUM_EL2, EL2 Read/Write Software Context Number
   -- D19.2.130 SCXTNUM_EL3, EL3 Read/Write Software Context Number
   -- D19.2.131 SMCR_EL1, SME Control Register (EL1)
   -- D19.2.132 SMCR_EL2, SME Control Register (EL2)
   -- D19.2.133 SMCR_EL3, SME Control Register (EL3)
   -- D19.2.134 SMIDR_EL1, Streaming Mode Identification Register
   -- D19.2.135 SMPRIMAP_EL2, Streaming Mode Priority Mapping Register
   -- D19.2.136 SMPRI_EL1, Streaming Mode Priority Register

   -- TCR2_EL1/2 are unknown in Cortex A-53

   -- D19.2.137 TCR2_EL1, Extended Translation Control Register (EL1)

   -- type TCR2_EL1_Type is new Bits.Bitmap_64;

   -- function TCR2_EL1_Read
   --    return TCR2_EL1_Type
   --    with Inline => True;
   -- procedure TCR2_EL1_Write
   --    (Value : in TCR2_EL1_Type)
   --    with Inline => True;

   -- D19.2.138 TCR2_EL2, Extended Translation Control Register (EL2)

   -- type TCR2_EL2_Type is new Bits.Bitmap_64;

   -- function TCR2_EL2_Read
   --    return TCR2_EL2_Type
   --    with Inline => True;
   -- procedure TCR2_EL2_Write
   --    (Value : in TCR2_EL2_Type)
   --    with Inline => True;

   -- D19.2.139 TCR_EL1, Translation Control Register (EL1)

   IRGN_NM          : constant := 2#00#; -- Normal memory, Inner Non-cacheable.
   IRGN_NM_IWBRAWAC : constant := 2#01#; -- Normal memory, Inner Write-Back Read-Allocate Write-Allocate Cacheable.
   IRGN_NM_IWTRA    : constant := 2#10#; -- Normal memory, Inner Write-Through Read-Allocate No Write-Allocate Cacheable.
   IRGN_NM_IWBRA    : constant := 2#11#; -- Normal memory, Inner Write-Back Read-Allocate No Write-Allocate Cacheable.

   ORGN_NM          : constant := 2#00#; -- Normal memory, Outer Non-cacheable.
   ORGN_NM_IWBRAWAC : constant := 2#01#; -- Normal memory, Outer Write-Back Read-Allocate Write-Allocate Cacheable.
   ORGN_NM_IWTRA    : constant := 2#10#; -- Normal memory, Outer Write-Through Read-Allocate No Write-Allocate Cacheable.
   ORGN_NM_IWBRA    : constant := 2#11#; -- Normal memory, Outer Write-Back Read-Allocate No Write-Allocate Cacheable.

   SH_NOSHARE : constant := 2#00#; -- Non-shareable
   SH_OUTER   : constant := 2#10#; -- Outer Shareable
   SH_INNER   : constant := 2#11#; -- Inner Shareable

   TG_4  : constant := 2#00#; -- 4KB
   TG_64 : constant := 2#01#; -- 64KB
   TG_16 : constant := 2#10#; -- 16KB

   A1_TTBR0 : constant := 0; -- TTBR0_EL1.ASID defines the ASID.
   A1_TTBR1 : constant := 1; -- TTBR1_EL1.ASID defines the ASID.

   IPS_4G    : constant := 2#000#; -- 32 bits, 4GB.
   IPS_64G   : constant := 2#001#; -- 36 bits, 64GB.
   IPS_1TB   : constant := 2#010#; -- 40 bits, 1TB.
   IPS_4TB   : constant := 2#011#; -- 42 bits, 4TB.
   IPS_16TB  : constant := 2#100#; -- 44 bits, 16TB.
   IPS_256TB : constant := 2#101#; -- 48 bits, 256TB.
   IPS_4PB   : constant := 2#110#; -- 52 bits, 4PB.

   AS_8  : constant := 0; -- 8 bit - the upper 8 bits of TTBR0_EL1 and TTBR1_EL1 are ignored by hardware for every purpose except reading back the register, and are treated as if they are all zeros for when used for allocation and matching entries in the TLB.
   AS_16 : constant := 1; -- 16 bit - the upper 16 bits of TTBR0_EL1 and TTBR1_EL1 are used for allocation and matching in the TLB.

   type TCR_EL1_Type is record
      T0SZ      : Bits_6  := 0;     -- The size offset of the memory region addressed by TTBR0_EL1.
      Reserved1 : Bits_1  := 0;
      EPD0      : Boolean := False; -- Translation table walk disable for translations using TTBR0_EL1.
      IRGN0     : Bits_2  := 0;     -- Inner cacheability attribute for memory associated with translation table walks using TTBR0_EL1.
      ORGN0     : Bits_2  := 0;     -- Outer cacheability attribute for memory associated with translation table walks using TTBR0_EL1.
      SH0       : Bits_2  := 0;     -- Shareability attribute for memory associated with translation table walks using TTBR0_EL1.
      TG0       : Bits_2  := 0;     -- Granule size for the TTBR0_EL1.
      T1SZ      : Bits_6  := 0;     -- The size offset of the memory region addressed by TTBR1_EL1.
      A1        : Bits_1  := 0;     -- Selects whether TTBR0_EL1 or TTBR1_EL1 defines the ASID.
      EPD1      : Boolean := False; -- Translation table walk disable for translations using TTBR1_EL1.
      IRGN1     : Bits_2  := 0;     -- Inner cacheability attribute for memory associated with translation table walks using TTBR1_EL1.
      ORGN1     : Bits_2  := 0;     -- Outer cacheability attribute for memory associated with translation table walks using TTBR1_EL1.
      SH1       : Bits_2  := 0;     -- Shareability attribute for memory associated with translation table walks using TTBR1_EL1.
      TG1       : Bits_2  := 0;     -- Granule size for the TTBR1_EL1.
      IPS       : Bits_3  := 0;     -- Intermediate Physical Address Size.
      Reserved2 : Bits_1  := 0;
      AS        : Boolean := False; -- ASID Size.
      TBI0      : Boolean := False; -- Top Byte ignored. Indicates whether the top byte of an address is used for address match for the TTBR0_EL1 region, or ignored and used for tagged addresses.
      TBI1      : Boolean := False; -- Top Byte ignored. Indicates whether the top byte of an address is used for address match for the TTBR1_EL1 region, or ignored and used for tagged addresses.
      HA        : Boolean := False; -- Hardware Access flag update in stage 1 translations from EL0 and EL1.
      HD        : Boolean := False; -- Hardware management of dirty state in stage 1 translations from EL0 and EL1.
      HPD0      : Boolean := False; -- Hierarchical Permission Disables. This affects the hierarchical control bits, APTable, PXNTable, and UXNTable, except NSTable, in the translation tables pointed to by TTBR0_EL1.
      HPD1      : Boolean := False; -- Hierarchical Permission Disables. This affects the hierarchical control bits, APTable, PXNTable, and UXNTable, except NSTable, in the translation tables pointed to by TTBR1_EL1.
      HWU059    : Boolean := False; -- Hardware Use. Indicates IMPLEMENTATION DEFINED hardware use of bit[59] of the stage 1 translation table Block or Page entry for translations using TTBR0_EL1.
      HWU060    : Boolean := False; -- Hardware Use. Indicates IMPLEMENTATION DEFINED hardware use of bit[60] of the stage 1 translation table Block or Page entry for translations using TTBR0_EL1.
      HWU061    : Boolean := False; -- Hardware Use. Indicates IMPLEMENTATION DEFINED hardware use of bit[61] of the stage 1 translation table Block or Page entry for translations using TTBR0_EL1.
      HWU062    : Boolean := False; -- Hardware Use. Indicates IMPLEMENTATION DEFINED hardware use of bit[62] of the stage 1 translation table Block or Page entry for translations using TTBR0_EL1.
      HWU159    : Boolean := False; -- Hardware Use. Indicates IMPLEMENTATION DEFINED hardware use of bit[59] of the stage 1 translation table Block or Page entry for translations using TTBR1_EL1.
      HWU160    : Boolean := False; -- Hardware Use. Indicates IMPLEMENTATION DEFINED hardware use of bit[60] of the stage 1 translation table Block or Page entry for translations using TTBR1_EL1.
      HWU161    : Boolean := False; -- Hardware Use. Indicates IMPLEMENTATION DEFINED hardware use of bit[61] of the stage 1 translation table Block or Page entry for translations using TTBR1_EL1.
      HWU162    : Boolean := False; -- Hardware Use. Indicates IMPLEMENTATION DEFINED hardware use of bit[62] of the stage 1 translation table Block or Page entry for translations using TTBR1_EL1.
      TBID0     : Boolean := False; -- Controls the use of the top byte of instruction addresses for address matching.
      TBID1     : Boolean := False; -- Controls the use of the top byte of instruction addresses for address matching.
      NFD0      : Boolean := False; -- Non-fault translation timing disable for stage 1 translations using TTBR0_EL1.
      NFD1      : Boolean := False; -- Non-fault translation timing disable for stage 1 translations using TTBR1_EL1.
      E0PD0     : Boolean := False; -- Faulting control for Unprivileged access to any address translated by TTBR0_EL1.
      E0PD1     : Boolean := False; -- Faulting control for Unprivileged access to any address translated by TTBR1_EL1.
      TCMA0     : Boolean := False; -- Controls the generation of Unchecked accesses at EL1, and at EL0 if HCR_EL2.{E2H,TGE}!={1,1}, when address[59:55] = 0b00000.
      TCMA1     : Boolean := False; -- Controls the generation of Unchecked accesses at EL1, and at EL0 if HCR_EL2.{E2H,TGE}!={1,1}, when address[59:55] = 0b11111.
      DS        : Boolean := False; -- This field affects whether a 52-bit output address can be described by the translation tables of the 4KB or 16KB translation granules.
      Reserved3 : Bits_4  := 0;
   end record
      with Bit_Order => Low_Order_First,
           Size      => 64;
   for TCR_EL1_Type use record
      T0SZ      at 0 range  0 ..  5;
      Reserved1 at 0 range  6 ..  6;
      EPD0      at 0 range  7 ..  7;
      IRGN0     at 0 range  8 ..  9;
      ORGN0     at 0 range 10 .. 11;
      SH0       at 0 range 12 .. 13;
      TG0       at 0 range 14 .. 15;
      T1SZ      at 0 range 16 .. 21;
      A1        at 0 range 22 .. 22;
      EPD1      at 0 range 23 .. 23;
      IRGN1     at 0 range 24 .. 25;
      ORGN1     at 0 range 26 .. 27;
      SH1       at 0 range 28 .. 29;
      TG1       at 0 range 30 .. 31;
      IPS       at 0 range 32 .. 34;
      Reserved2 at 0 range 35 .. 35;
      AS        at 0 range 36 .. 36;
      TBI0      at 0 range 37 .. 37;
      TBI1      at 0 range 38 .. 38;
      HA        at 0 range 39 .. 39;
      HD        at 0 range 40 .. 40;
      HPD0      at 0 range 41 .. 41;
      HPD1      at 0 range 42 .. 42;
      HWU059    at 0 range 43 .. 43;
      HWU060    at 0 range 44 .. 44;
      HWU061    at 0 range 45 .. 45;
      HWU062    at 0 range 46 .. 46;
      HWU159    at 0 range 47 .. 47;
      HWU160    at 0 range 48 .. 48;
      HWU161    at 0 range 49 .. 49;
      HWU162    at 0 range 50 .. 50;
      TBID0     at 0 range 51 .. 51;
      TBID1     at 0 range 52 .. 52;
      NFD0      at 0 range 53 .. 53;
      NFD1      at 0 range 54 .. 54;
      E0PD0     at 0 range 55 .. 55;
      E0PD1     at 0 range 56 .. 56;
      TCMA0     at 0 range 57 .. 57;
      TCMA1     at 0 range 58 .. 58;
      DS        at 0 range 59 .. 59;
      Reserved3 at 0 range 60 .. 63;
   end record;

   function TCR_EL1_Read
      return TCR_EL1_Type
      with Inline => True;
   procedure TCR_EL1_Write
      (Value : in TCR_EL1_Type)
      with Inline => True;

   -- D19.2.140 TCR_EL2, Translation Control Register (EL2)
   -- D19.2.141 TCR_EL3, Translation Control Register (EL3)
   -- D19.2.142 TFSRE0_EL1, Tag Fault Status Register (EL0).
   -- D19.2.143 TFSR_EL1, Tag Fault Status Register (EL1)
   -- D19.2.144 TFSR_EL2, Tag Fault Status Register (EL2)
   -- D19.2.145 TFSR_EL3, Tag Fault Status Register (EL3)
   -- D19.2.146 TPIDR2_EL0, EL0 Read/Write Software Thread ID Register 2
   -- D19.2.147 TPIDR_EL0, EL0 Read/Write Software Thread ID Register
   -- D19.2.148 TPIDR_EL1, EL1 Software Thread ID Register
   -- D19.2.149 TPIDR_EL2, EL2 Software Thread ID Register
   -- D19.2.150 TPIDR_EL3, EL3 Software Thread ID Register
   -- D19.2.151 TPIDRRO_EL0, EL0 Read-Only Software Thread ID Register

   -- D19.2.152 TTBR0_EL1, Translation Table Base Register 0 (EL1)
   -- D19.2.153 TTBR0_EL2, Translation Table Base Register 0 (EL2)
   -- D19.2.154 TTBR0_EL3, Translation Table Base Register 0 (EL3)
   -- D19.2.155 TTBR1_EL1, Translation Table Base Register 1 (EL1)
   -- D19.2.156 TTBR1_EL2, Translation Table Base Register 1 (EL2)

   CnP_DIFFER : constant := 0; -- The translation table entries pointed to by TTBR1_EL2 for the current ASID are permitted to differ from corresponding entries for TTBR1_EL2 for other PEs in the Inner Shareable domain.
   CnP_SAME   : constant := 1; -- The translation table entries pointed to by TTBR1_EL2 are the same as the translation table entries for every other PE in the Inner Shareable domain for which the value of TTBR1_EL2.CnP is 1 and all of the following apply: ...

   type TTBR0_EL1_Type is record
      CnP   : Bits_1;  -- Common not Private.
      BADDR : Bits_47; -- Translation table base address
      ASID  : Bits_16; -- An ASID for the translation table base address.
   end record
      with Bit_Order => Low_Order_First,
           Size      => 64;
   for TTBR0_EL1_Type use record
      CnP   at 0 range  0 ..  0;
      BADDR at 0 range  1 .. 47;
      ASID  at 0 range 48 .. 63;
   end record;

   function TTBR0_EL1_Read
      return TTBR0_EL1_Type
      with Inline => True;
   procedure TTBR0_EL1_Write
      (Value : in TTBR0_EL1_Type)
      with Inline => True;

   type TTBR0_EL2_Type is new TTBR0_EL1_Type;

   function TTBR0_EL2_Read
      return TTBR0_EL2_Type
      with Inline => True;
   procedure TTBR0_EL2_Write
      (Value : in TTBR0_EL2_Type)
      with Inline => True;

   type TTBR0_EL3_Type is record
      CnP      : Bits_1;       -- Common not Private.
      BADDR    : Bits_47;      -- Translation table base address
      Reserved : Bits_16 := 0; -- An ASID for the translation table base address.
   end record
      with Bit_Order => Low_Order_First,
           Size      => 64;
   for TTBR0_EL3_Type use record
      CnP      at 0 range  0 ..  0;
      BADDR    at 0 range  1 .. 47;
      Reserved at 0 range 48 .. 63;
   end record;

   function TTBR0_EL3_Read
      return TTBR0_EL3_Type
      with Inline => True;
   procedure TTBR0_EL3_Write
      (Value : in TTBR0_EL3_Type)
      with Inline => True;

   type TTBR1_EL1_Type is new TTBR0_EL1_Type;

   function TTBR1_EL1_Read
      return TTBR1_EL1_Type
      with Inline => True;
   procedure TTBR1_EL1_Write
      (Value : in TTBR1_EL1_Type)
      with Inline => True;

   -- TTBR1_EL2 is not implemented in Cortex A-53

   -- type TTBR1_EL2_Type is new TTBR0_EL1_Type;

   -- function TTBR1_EL2_Read
   --    return TTBR1_EL2_Type
   --    with Inline => True;
   -- procedure TTBR1_EL2_Write
   --    (Value : in TTBR1_EL2_Type)
   --    with Inline => True;

   -- D19.2.157 VBAR_EL1, Vector Base Address Register (EL1)
   -- D19.2.158 VBAR_EL2, Vector Base Address Register (EL2)
   -- D19.2.159 VBAR_EL3, Vector Base Address Register (EL3)

   function VBAR_EL1_Read
      return Unsigned_64
      with Inline => True;
   procedure VBAR_EL1_Write
      (Value : in Unsigned_64)
      with Inline => True;
   function VBAR_EL2_Read
      return Unsigned_64
      with Inline => True;
   procedure VBAR_EL2_Write
      (Value : in Unsigned_64)
      with Inline => True;
   function VBAR_EL3_Read
      return Unsigned_64
      with Inline => True;
   procedure VBAR_EL3_Write
      (Value : in Unsigned_64)
      with Inline => True;

   -- D19.2.160 VMPIDR_EL2, Virtualization Multiprocessor ID Register
   -- D19.2.161 VNCR_EL2, Virtual Nested Control Register
   -- D19.2.162 VPIDR_EL2, Virtualization Processor ID Register
   -- D19.2.163 VSTCR_EL2, Virtualization Secure Translation Control Register
   -- D19.2.164 VSTTBR_EL2, Virtualization Secure Translation Table Base Register
   -- D19.2.165 VTCR_EL2, Virtualization Translation Control Register
   -- D19.2.166 VTTBR_EL2, Virtualization Translation Table Base Register
   -- D19.2.167 ZCR_EL1, SVE Control Register (EL1)
   -- D19.2.168 ZCR_EL2, SVE Control Register (EL2)
   -- D19.2.169 ZCR_EL3, SVE Control Register (EL3)

   ----------------------------------------------------------------------------
   -- D19.12 Generic Timer registers
   ----------------------------------------------------------------------------

   -- D19.12.1 CNTFRQ_EL0, Counter-timer Frequency register

   type CNTFRQ_EL0_Type is record
      Clock_frequency : Unsigned_32;      -- Clock_Frequency.
      Reserved        : Bits_32     := 0;
   end record
      with Bit_Order => Low_Order_First,
           Size      => 64;
   for CNTFRQ_EL0_Type use record
      Clock_frequency at 0 range  0 .. 31;
      Reserved        at 0 range 32 .. 63;
   end record;

   function CNTFRQ_EL0_Read
      return CNTFRQ_EL0_Type
      with Inline => True;

   -- D19.12.2 CNTHCTL_EL2, Counter-timer Hypervisor Control register
   -- D19.12.3 CNTHP_CTL_EL2, Counter-timer Hypervisor Physical Timer Control register
   -- D19.12.4 CNTHP_CVAL_EL2, Counter-timer Physical Timer CompareValue register (EL2)
   -- D19.12.5 CNTHP_TVAL_EL2, Counter-timer Physical Timer TimerValue register (EL2)
   -- D19.12.6 CNTHPS_CTL_EL2, Counter-timer Secure Physical Timer Control register (EL2)
   -- D19.12.7 CNTHPS_CVAL_EL2, Counter-timer Secure Physical Timer CompareValue register (EL2)
   -- D19.12.8 CNTHPS_TVAL_EL2, Counter-timer Secure Physical Timer TimerValue register (EL2)
   -- D19.12.9 CNTHV_CTL_EL2, Counter-timer Virtual Timer Control register (EL2)
   -- D19.12.10 CNTHV_CVAL_EL2, Counter-timer Virtual Timer CompareValue register (EL2)
   -- D19.12.11 CNTHV_TVAL_EL2, Counter-timer Virtual Timer TimerValue Register (EL2)
   -- D19.12.12 CNTHVS_CTL_EL2, Counter-timer Secure Virtual Timer Control register (EL2)
   -- D19.12.13 CNTHVS_CVAL_EL2, Counter-timer Secure Virtual Timer CompareValue register (EL2)
   -- D19.12.14 CNTHVS_TVAL_EL2, Counter-timer Secure Virtual Timer TimerValue register (EL2)
   -- D19.12.15 CNTKCTL_EL1, Counter-timer Kernel Control register

   -- D19.12.16 CNTP_CTL_EL0, Counter-timer Physical Timer Control register

   type CNTP_CTL_EL0_Type is record
      ENABLE    : Boolean;      -- Enables the timer.
      IMASK     : Boolean;      -- Timer interrupt mask bit.
      ISTATUS   : Boolean;      -- The status of the timer.
      Reserved1 : Bits_29 := 0;
      Reserved2 : Bits_32 := 0;
   end record
      with Bit_Order => Low_Order_First,
           Size      => 64;
   for CNTP_CTL_EL0_Type use record
      ENABLE    at 0 range  0 ..  0;
      IMASK     at 0 range  1 ..  1;
      ISTATUS   at 0 range  2 ..  2;
      Reserved1 at 0 range  3 .. 31;
      Reserved2 at 0 range 32 .. 63;
   end record;

   function CNTP_CTL_EL0_Read
      return CNTP_CTL_EL0_Type
      with Inline => True;
   procedure CNTP_CTL_EL0_Write
      (Value : in CNTP_CTL_EL0_Type)
      with Inline => True;

   -- D19.12.17 CNTP_CVAL_EL0, Counter-timer Physical Timer CompareValue register

   function CNTP_CVAL_EL0_Read
      return Unsigned_64
      with Inline => True;
   procedure CNTP_CVAL_EL0_Write
      (Value : in Unsigned_64)
      with Inline => True;

   -- D19.12.18 CNTP_TVAL_EL0, Counter-timer Physical Timer TimerValue register

   type CNTP_TVAL_EL0_Type is record
      TimerValue : Unsigned_32;      -- The TimerValue view of the EL1 physical timer.
      Reserved   : Bits_32     := 0;
   end record
      with Bit_Order => Low_Order_First,
           Size      => 64;
   for CNTP_TVAL_EL0_Type use record
      TimerValue at 0 range  0 .. 31;
      Reserved   at 0 range 32 .. 63;
   end record;

   function CNTP_TVAL_EL0_Read
      return CNTP_TVAL_EL0_Type
      with Inline => True;
   procedure CNTP_TVAL_EL0_Write
      (Value : in CNTP_TVAL_EL0_Type)
      with Inline => True;

   -- D19.12.19 CNTPCTSS_EL0, Counter-timer Self-Synchronized Physical Count register

   -- D19.12.20 CNTPCT_EL0, Counter-timer Physical Count register

   function CNTPCT_EL0_Read
      return Unsigned_64
      with Inline => True;

   -- D19.12.21 CNTPS_CTL_EL1, Counter-timer Physical Secure Timer Control register
   -- D19.12.22 CNTPOFF_EL2, Counter-timer Physical Offset register
   -- D19.12.23 CNTPS_CVAL_EL1, Counter-timer Physical Secure Timer CompareValue register
   -- D19.12.24 CNTPS_TVAL_EL1, Counter-timer Physical Secure Timer TimerValue register
   -- D19.12.25 CNTV_CTL_EL0, Counter-timer Virtual Timer Control register
   -- D19.12.26 CNTV_CVAL_EL0, Counter-timer Virtual Timer CompareValue register
   -- D19.12.27 CNTV_TVAL_EL0, Counter-timer Virtual Timer TimerValue register
   -- D19.12.28 CNTVCTSS_EL0, Counter-timer Self-Synchronized Virtual Count register
   -- D19.12.29 CNTVCT_EL0, Counter-timer Virtual Count register
   -- D19.12.30 CNTVOFF_EL2, Counter-timer Virtual Offset register

   ----------------------------------------------------------------------------
   -- CPU helper subprograms
   ----------------------------------------------------------------------------

   procedure NOP
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

pragma Style_Checks (On);

end ARMv8A;

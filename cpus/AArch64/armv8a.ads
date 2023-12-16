-----------------------------------------------------------------------------------------------------------------------
--                                                     SweetAda                                                      --
-----------------------------------------------------------------------------------------------------------------------
-- __HDS__                                                                                                           --
-- __FLN__ armv8a.ads                                                                                                --
-- __DSC__                                                                                                           --
-- __HSH__ e69de29bb2d1d6434b8b29ae775ad8c2e48c5391                                                                  --
-- __HDE__                                                                                                           --
-----------------------------------------------------------------------------------------------------------------------
-- Copyright (C) 2020-2023 Gabriele Galeotti                                                                         --
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
   -- C5.2 Special-purpose registers
   ----------------------------------------------------------------------------

   -- C5.2.8 FPCR, Floating-point Control Register

   RMode_RN : constant := 2#00#; -- Round to Nearest (RN) mode.
   RMode_RP : constant := 2#01#; -- Round towards Plus Infinity (RP) mode.
   RMode_RM : constant := 2#10#; -- Round towards Minus Infinity (RM) mode.
   RMode_RZ : constant := 2#11#; -- Round towards Zero (RZ) mode.

   type FPCR_Type is record
      FIZ       : Boolean;      -- Flush Inputs to Zero. Controls whether single-precision ...
      AH        : Boolean;      -- Alternate Handling. Controls alternate handling of denormalized floating-point numbers.
      NEP       : Boolean;      -- Controls how the output elements other than the lowest element of the vector ...
      Reserved1 : Bits_5 := 0;
      IOE       : Boolean;      -- Invalid Operation floating-point exception trap enable.
      DZE       : Boolean;      -- Divide by Zero floating-point exception trap enable.
      OFE       : Boolean;      -- Overflow floating-point exception trap enable.
      UFE       : Boolean;      -- Underflow floating-point exception trap enable.
      IXE       : Boolean;      -- Inexact floating-point exception trap enable.
      Reserved2 : Bits_2 := 0;
      IDE       : Boolean;      -- Input Denormal floating-point exception trap enable.
      Len       : Bits_3 := 0;  -- This field has no function in AArch64 state, and non-zero values are ignored ...
      FZ16      : Boolean;      -- Flushing denormalized numbers to zero control bit on half-precision data-processing instructions.
      Stride    : Bits_2 := 0;  -- This field has no function in AArch64 state, and non-zero values are ignored ...
      RMode     : Bits_2;       -- Rounding Mode control field.
      FZ        : Boolean;      -- Flushing denormalized numbers to zero control bit.
      DN        : Boolean;      -- Default NaN use for NaN propagation.
      AHP       : Boolean;      -- Alternative half-precision control bit.
      Reserved3 : Bits_5 := 0;
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
      Reserved1 : Bits_2 := 0;
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
      ACCDATA  : Bits_32;      -- Holds the lower 32 bits of the data that is stored by an ST64BV0, ...
      Reserved : Bits_32 := 0;
   end record
      with Bit_Order => Low_Order_First,
           Size      => 64;
   for ACCDATA_EL1_Type use record
      ACCDATA  at 0 range  0 .. 31;
      Reserved at 0 range 32 .. 63;
   end record;

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
      NumSets  : Bits_24;      -- (Number of sets in cache) - 1, therefore a value of 0 indicates 1 set in the cache. ...
      Reserved : Bits_40 := 0;
   end record
      with Bit_Order => Low_Order_First,
           Size      => 64;
   for CCSIDR2_EL1_Type use record
      NumSets  at 0 range  0 .. 23;
      Reserved at 0 range 24 .. 63;
   end record;

   -- D19.2.43 FPEXC32_EL2, Floating-Point Exception Control register

   type FPEXC32_EL2_Type is record
      IOF       : Boolean;      -- Invalid Operation floating-point exception trap enable.
      DZF       : Boolean;      -- Divide by Zero floating-point exception trap enable.
      OFF       : Boolean;      -- Overflow floating-point exception trap enable.
      UFF       : Boolean;      -- Underflow floating-point exception trap enable.
      IXF       : Boolean;      -- Inexact floating-point exception trap enable.
      Reserved1 : Bits_2 := 0;
      IDF       : Boolean;      -- Input Denormal floating-point exception trap enable.
      VECITR    : Bits_3;
      Reserved2 : Bits_15 := 0;
      TFV       : Boolean;      -- Trapped Fault Valid bit.
      VV        : Boolean;      -- VECITR valid bit.
      FP2V      : Boolean;      -- FPINST2 instruction valid bit.
      DEX       : Boolean;      -- Defined synchronous exception on floating-point execution.
      EN        : Boolean;      -- Enables access to the Advanced SIMD and floating-point functionality ...
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

   -- D19.2.48 HCR_EL2, Hypervisor Configuration Register

   type HCR_EL2_Type is record
      VM        : Boolean;     -- Virtualization enable.
      SWIO      : Boolean;     -- Set/Way Invalidation Override.
      PTW       : Boolean;     -- Protected Table Walk.
      FMO       : Boolean;     -- Physical FIQ Routing.
      IMO       : Boolean;     -- Physical IRQ Routing.
      AMO       : Boolean;     -- Physical SError interrupt routing.
      VF        : Boolean;     -- Virtual FIQ Interrupt
      VI        : Boolean;     -- Virtual IRQ Interrupt.
      VSE       : Boolean;     -- Virtual SError interrupt.
      FB        : Boolean;     -- Force broadcast.
      BSU       : Bits_2;      -- Barrier Shareability upgrade.
      DC        : Boolean;     -- Default Cacheability.
      TWI       : Boolean;     -- Traps EL0 and EL1 execution of WFI instructions to EL2, ...
      TWE       : Boolean;     -- Traps EL0 and EL1 execution of WFE instructions to EL2, ...
      TID0      : Boolean;     -- Trap ID group 0.
      TID1      : Boolean;     -- Trap ID group 1.
      TID2      : Boolean;     -- Trap ID group 2.
      TID3      : Boolean;     -- Trap ID group 3.
      TSC       : Boolean;     -- Trap SMC instructions.
      TIDCP     : Boolean;     -- Trap IMPLEMENTATION DEFINED functionality.
      TACR      : Boolean;     -- Trap Auxiliary Control Registers.
      TSW       : Boolean;     -- Trap data or unified cache maintenance instructions that operate by Set/Way.
      TPCP      : Boolean;     -- Trap data or unified cache mainte instrs that operate to the Point of Coherency or Persistence.
      TPU       : Boolean;     -- Trap cache maintenance instructions that operate to the Point of Unification.
      TTLB      : Boolean;     -- Trap TLB maintenance instructions.
      TVM       : Boolean;     -- Trap Virtual Memory controls.
      TGE       : Boolean;     -- Trap General Exceptions, from EL0.
      TDZ       : Boolean;     -- Trap DC ZVA instructions.
      HCD       : Boolean;     -- HVC instruction disable.
      TRVM      : Boolean;     -- Trap Reads of Virtual Memory controls.
      RV        : Boolean;     -- Execution state control for lower Exception levels
      CD        : Boolean;     -- Stage 2 Data access cacheability disable.
      ID        : Boolean;     -- Stage 2 Instruction access cacheability disable.
      E2H       : Boolean;     -- EL2 Host.
      TLOR      : Boolean;     -- Trap LOR registers.
      TERR      : Boolean;     -- Trap Error record accesses.
      TEA       : Boolean;     -- Route synchronous External abort exceptions to EL2.
      MIOCNCE   : Boolean;     -- Mismatched Inner/Outer Cacheable Non-Coherency Enable, for the EL1&0 translation regimes.
      Reserved1 : Bits_1 := 0;
      APK       : Boolean;     -- Trap registers holding "key" values for Pointer Authentication.
      API       : Boolean;     -- Controls the use of instructions related to Pointer Authentication
      NV        : Boolean;     -- Nested Virtualization.
      NV1       : Boolean;     -- Nested Virtualization.
      AddrTr    : Boolean;     -- Address Translation.
      NV2       : Boolean;     -- Nested Virtualization.
      FWB       : Boolean;     -- Forced Write-Back.
      FIEN      : Boolean;     -- Fault Injection Enable.
      Reserved2 : Bits_1 := 0;
      TID4      : Boolean;     -- Trap ID group 4.
      TICAB     : Boolean;     -- Trap ICIALLUIS/IC IALLUIS cache maintenance instructions.
      AMVOFFEN  : Boolean;     -- Activity Monitors Virtual Offsets Enable.
      TOCU      : Boolean;     -- Trap cache maintenance instructions that operate to the Point of Unification.
      EnSCXT    : Boolean;     -- Enable Access to the SCXTNUM_EL1 and SCXTNUM_EL0 registers.
      TTLBIS    : Boolean;     -- Trap TLB maintenance instructions that operate on the Inner Shareable domain.
      TTLBOS    : Boolean;     -- Trap TLB maintenance instructions that operate on the Outer Shareable domain.
      ATA       : Boolean;     -- Allocation Tag Access.
      DCT       : Boolean;     -- Default Cacheability Tagging.
      TID5      : Boolean;     -- Trap ID group 5.
      TWEDEn    : Boolean;     -- TWE Delay Enable.
      TWEDEL    : Bits_4 := 0; -- TWE Delay.
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
      NS        : Bits_1;          -- Non-secure bit.
      IRQ       : Boolean;         -- Physical IRQ Routing.
      FIQ       : Boolean;         -- Physical FIQ Routing.
      EA        : Boolean;         -- External Abort and SError interrupt routing.
      Reserved1 : Bits_2 := 2#11#;
      Reserved2 : Bits_1 := 0;
      SMD       : Boolean;         -- Secure Monitor Call disable.
      HCE       : Boolean;         -- Hypervisor Call instruction enable.
      SIF       : Boolean;         -- Secure instruction fetch.
      RW        : Boolean;         -- Execution state control for lower Exception levels.
      ST        : Boolean;         -- Traps Secure EL1 accesses to the Counter-timer Physical Secure timer ...
      TWI       : Boolean;         -- Traps EL2, EL1, and EL0 execution of WFI instructions to EL3, from any ...
      TWE       : Boolean;         -- Traps EL2, EL1, and EL0 execution of WFE instructions to EL3, from any ...
      TLOR      : Boolean;         -- Trap LOR registers.
      TERR      : Boolean;         -- Trap accesses of error record registers.
      APK       : Boolean;         -- Trap registers holding "key" values for Pointer Authentication.
      API       : Boolean;         -- Controls the use of the following instructions related to Pointer Authentication.
      EEL2      : Boolean;         -- Secure EL2 Enable.
      EASE      : Boolean;         -- External aborts to SError interrupt vector.
      NMEA      : Boolean;         -- Non-maskable External Aborts.
      FIEN      : Boolean;         -- Fault Injection enable.
      Reserved3 : Bits_3 := 0;
      EnSCXT    : Boolean;         -- Enables access to the SCXTNUM_EL2, SCXTNUM_EL1, and SCXTNUM_EL0 registers.
      ATA       : Boolean;         -- Allocation Tag Access.
      FGTEn     : Boolean;         -- Fine-Grained Traps Enable.
      ECVEn     : Boolean;         -- ECV Enable.
      TWEDEn    : Boolean;         -- TWE Delay Enable.
      TWEDEL    : Bits_4;          -- TWE Delay.
      TME       : Boolean;         -- Enables access to the TSTART, TCOMMIT, TTEST and TCANCEL instructions at ...
      AMVOFFEN  : Boolean;         -- Activity Monitors Virtual Offsets Enable.
      EnAS0     : Boolean;         -- Traps execution of an ST64BV0 instruction at EL0, EL1, or EL2 to EL3.
      ADEn      : Boolean;         -- Enables access to the ACCDATA_EL1 register at EL1 and EL2.
      HXEn      : Boolean;         -- Enables access to the HCRX_EL2 register at EL2 from EL3.
      Reserved4 : Bits_1 := 0;
      TRNDR     : Boolean;         -- Controls trapping of reads of RNDR and RNDRRS.
      EnTP2     : Boolean;         -- Traps instructions executed at EL2, EL1, and EL0 that access TPIDR2_EL0 to EL3.
      Reserved5 : Bits_1 := 0;
      TCR2En    : Boolean;         -- TCR2_ELx register trap control.
      SCTLR2En  : Boolean;         -- SCTLR2_ELx register trap control.
      Reserved6 : Bits_3 := 0;
      GPF       : Boolean;         -- Controls the reporting of Granule protection faults at EL0, EL1 and EL2.
      MECEn     : Boolean;         -- Enables access to the following EL2 MECID registers, from EL2: ...
      Reserved7 : Bits_12 := 0;
      NSE       : Bits_1;          -- This field, evaluated with SCR_EL3.NS, selects the Security state of EL2 and ...
      Reserved8 : Bits_1 := 0;
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
      M          : Boolean;     -- MMU enable for EL1&0 stage 1 address translation.
      A          : Boolean;     -- Alignment check enable.
      C          : Boolean;     -- Stage 1 Cacheability control, for data accesses.
      SA         : Boolean;     -- SP Alignment check enable.
      SA0        : Boolean;     -- SP Alignment check enable for EL0.
      CP15BEN    : Boolean;     -- System instruction memory barrier enable.
      nAA        : Boolean;     -- Non-aligned access.
      ITD        : Boolean;     -- IT disable.
      SED        : Boolean;     -- SETEND instruction disable.
      UMA        : Boolean;     -- User Mask Access.
      EnRCTX     : Boolean;     -- Enable EL0 access to the following System instructions: ...
      EOS        : Boolean;     -- Exception Exit is Context Synchronizing.
      I          : Boolean;     -- Stage 1 instruction access Cacheability control, for accesses at EL0 and EL1: ...
      EnDB       : Boolean;     -- Controls enabling of pointer authentication (using the APDBKey_EL1 key) of instruction ...
      DZE        : Boolean;     -- Traps EL0 execution of DC ZVA instructions ...
      UCT        : Boolean;     -- Traps EL0 accesses to the CTR_EL0 to EL1, or to EL2 when ...
      nTWI       : Boolean;     -- Traps EL0 execution of WFI instructions to EL1, or to EL2 when ...
      Reserved1  : Bits_1 := 0;
      nTWE       : Boolean;     -- Traps EL0 execution of WFE instructions to EL1, or to EL2 when ...
      WXN        : Boolean;     -- Write permission implies Execute Never (XN).
      TSCXT      : Boolean;     -- Trap EL0 Access to the SCXTNUM_EL0 register, when EL0 is using AArch64.
      IESB       : Boolean;     -- Implicit Error Synchronization event enable.
      EIS        : Boolean;     -- Exception Entry is Context Synchronizing.
      SPAN       : Boolean;     -- Set Privileged Access Never, on taking an exception to EL1.
      E0E        : Bits_1;      -- Endianness of data accesses at EL0.
      EE         : Bits_1;      -- Endianness of data accesses at EL1, and stage 1 translation table walks in ...
      UCI        : Boolean;     -- Enables EL0 access to the DC CVAU, DC CIVAC, DC CVAC and IC IVAU instrs in AArch64 state.
      EnDA       : Boolean;     -- Controls enabling of pointer authentication (using the APDAKey_EL1 key) of instruction ...
      nTLSMD     : Boolean;     -- No Trap Load Multiple and Store Multiple to Device-nGRE/Device-nGnRE/Device-nGnRnE memory.
      LSMAOE     : Boolean;     -- Load Multiple and Store Multiple Atomicity and Ordering Enable.
      EnIB       : Boolean;     -- Controls enabling of pointer authentication (using the APIBKey_EL1 key) of instruction ...
      EnIA       : Boolean;     -- Controls enabling of pointer authentication (using the APIAKey_EL1 key) of instruction ...
      CMOW       : Boolean;     -- Controls cache maintenance instruction permission for ...
      MSCEn      : Boolean;     -- Memory Copy and Memory Set instructions Enable.
      Reserved2  : Bits_1 := 0;
      BT0        : Boolean;     -- PAC Branch Type compatibility at EL0.
      BT1        : Boolean;     -- PAC Branch Type compatibility at EL1.
      ITFSB      : Boolean;     -- When synchronous exceptions are not being generated by Tag Check Faults, ...
      TCF0       : Bits_2;      -- Tag Check Fault in EL0.
      TCF        : Bits_2;      -- Tag Check Fault in EL1.
      ATA0       : Boolean;     -- Allocation Tag Access in EL0.
      ATA        : Boolean;     -- Allocation Tag Access in EL1.
      DSSBS      : Bits_1;      -- Default PSTATE.SSBS value on Exception Entry.
      TWEDEn     : Boolean;     -- TWE Delay Enable.
      TWEDEL     : Bits_4;      -- TWE Delay.
      TMT0       : Boolean;     -- Forces a trivial implementation of the Transactional Memory Extension at EL0.
      TMT        : Boolean;     -- Forces a trivial implementation of the Transactional Memory Extension at EL1.
      TME0       : Boolean;     -- Enables the Transactional Memory Extension at EL0.
      TME        : Boolean;     -- Enables the Transactional Memory Extension at EL1.
      EnASR      : Boolean;     -- When HCR_EL2.{E2H, TGE} != {1, 1}, traps execution ...
      EnAS0      : Boolean;     -- When HCR_EL2.{E2H, TGE} != {1, 1}, traps execution ...
      EnALS      : Boolean;     -- When HCR_EL2.{E2H, TGE} != {1, 1}, traps execution ...
      EPAN       : Boolean;     -- Enhanced Privileged Access Never.
      Reserved3  : Bits_2 := 0;
      EnTP2      : Boolean;     -- Traps instructions executed at EL0 that access ...
      NMI        : Boolean;     -- Non-maskable Interrupt enable.
      SPINTMASK  : Boolean;     -- SP Interrupt Mask enable.
      TIDCP      : Boolean;     -- Trap IMPLEMENTATION DEFINED functionality.
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

   ----------------------------------------------------------------------------
   -- D19.12 Generic Timer registers
   ----------------------------------------------------------------------------

   -- D19.12.1 CNTFRQ_EL0, Counter-timer Frequency register

   type CNTFRQ_EL0_Type is record
      Clock_frequency : Unsigned_32;  -- Clock_Frequency.
      Reserved        : Bits_32 := 0;
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
      TimerValue : Unsigned_32;  -- The TimerValue view of the EL1 physical timer.
      Reserved   : Bits_32 := 0;
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

   -- D19.12.20 CNTPCT_EL0, Counter-timer Physical Count register

   function CNTPCT_EL0_Read
      return Unsigned_64
      with Inline => True;

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

end ARMv8A;

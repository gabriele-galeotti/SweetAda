-----------------------------------------------------------------------------------------------------------------------
--                                                     SweetAda                                                      --
-----------------------------------------------------------------------------------------------------------------------
-- __HDS__                                                                                                           --
-- __FLN__ aarch64.ads                                                                                               --
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
with Interfaces;
with Bits;

package AArch64 is

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
   -- CPU helper subprograms
   ----------------------------------------------------------------------------

   procedure NOP with
      Inline => True;
   procedure Asm_Call (Target_Address : in Address) with
      Inline => True;

   ----------------------------------------------------------------------------
   -- CurrentEL
   ----------------------------------------------------------------------------

   EL0 : constant := 2#00#;
   EL1 : constant := 2#01#;
   EL2 : constant := 2#10#;
   EL3 : constant := 2#11#;

   type EL_Type is
   record
      Reserved1 : Bits_2;
      EL        : Bits_2;  -- Current Exception level.
      Reserved2 : Bits_28;
      Reserved3 : Bits_32;
   end record with
      Bit_Order => Low_Order_First,
      Size      => 64;
   for EL_Type use record
      Reserved1 at 0 range 0 .. 1;
      EL        at 0 range 2 .. 3;
      Reserved2 at 0 range 4 .. 31;
      Reserved3 at 0 range 32 .. 63;
   end record;

   function CurrentEL_Read return EL_Type with
      Inline => True;

   ----------------------------------------------------------------------------
   -- HCR_EL2
   ----------------------------------------------------------------------------

   type HCR_EL2_Type is
   record
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
   end record with
      Bit_Order => Low_Order_First,
      Size      => 64;
   for HCR_EL2_Type use record
      VM        at 0 range 0 .. 0;
      SWIO      at 0 range 1 .. 1;
      PTW       at 0 range 2 .. 2;
      FMO       at 0 range 3 .. 3;
      IMO       at 0 range 4 .. 4;
      AMO       at 0 range 5 .. 5;
      VF        at 0 range 6 .. 6;
      VI        at 0 range 7 .. 7;
      VSE       at 0 range 8 .. 8;
      FB        at 0 range 9 .. 9;
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

   function HCR_EL2_Read return HCR_EL2_Type with
      Inline => True;
   procedure HCR_EL2_Write (Value : in HCR_EL2_Type) with
      Inline => True;

   ----------------------------------------------------------------------------
   -- SCTLR_EL1
   ----------------------------------------------------------------------------

   E0E_LE : constant := 0; -- Explicit data accesses at EL0 are little-endian.
   E0E_BE : constant := 1; -- Explicit data accesses at EL0 are big-endian.

   EE_LE : constant := 0; -- Little-endian.
   EE_BE : constant := 1; -- Big-endian.

   type SCTLR_EL1_Type is
   record
      M          : Boolean;         -- MMU enable.
      A          : Boolean;         -- Alignment check enable.
      C          : Boolean;         -- Cache enable.
      SA         : Boolean;         -- Enable Stack Alignment check.
      SA0        : Boolean;         -- Enable EL0 Stack Alignment check.
      CP15BEN    : Boolean;         -- AArch32 CP15 barrier enable.
      THEE       : Boolean;         -- ThumbEE enable.
      ITD        : Boolean;         -- IT instruction disable.
      SED        : Boolean;         -- SETEND instruction disable.
      UMA        : Boolean;         -- User Mask Access.
      Reserved1  : Bits_1 := 0;
      Reserved2  : Bits_1 := 1;
      I          : Boolean;         -- Instruction cache enable.
      Reserved3  : Bits_1 := 0;
      DZE        : Boolean;         -- Enables access to the DC ZVA instruction at EL0.
      UCT        : Boolean;         -- Enables EL0 access to the CTR_EL0 register in AArch64 state.
      nTWI       : Boolean;         -- WFI non-trapping.
      Reserved4  : Bits_1 := 0;
      nTWE       : Boolean;         -- WFE non-trapping.
      WXN        : Boolean;         -- Write permission implies Execute Never (XN).
      Reserved5  : Bits_1 := 1;
      Reserved6  : Bits_1 := 0;
      Reserved7  : Bits_2 := 2#11#;
      E0E        : Bits_1;          -- Endianness of explicit data access at EL0.
      EE         : Bits_1;          -- Exception endianness.
      UCI        : Boolean;         -- Enables EL0 access to the DC CVAU, DC CIVAC, DC CVAC and IC IVAU instrs in AArch64 state.
      Reserved8  : Bits_1 := 0;
      Reserved9  : Bits_2 := 2#11#;
      Reserved10 : Bits_2 := 0;
   end record with
      Bit_Order => Low_Order_First,
      Size      => 32;
   for SCTLR_EL1_Type use record
      M          at 0 range 0 .. 0;
      A          at 0 range 1 .. 1;
      C          at 0 range 2 .. 2;
      SA         at 0 range 3 .. 3;
      SA0        at 0 range 4 .. 4;
      CP15BEN    at 0 range 5 .. 5;
      THEE       at 0 range 6 .. 6;
      ITD        at 0 range 7 .. 7;
      SED        at 0 range 8 .. 8;
      UMA        at 0 range 9 .. 9;
      Reserved1  at 0 range 10 .. 10;
      Reserved2  at 0 range 11 .. 11;
      I          at 0 range 12 .. 12;
      Reserved3  at 0 range 13 .. 13;
      DZE        at 0 range 14 .. 14;
      UCT        at 0 range 15 .. 15;
      nTWI       at 0 range 16 .. 16;
      Reserved4  at 0 range 17 .. 17;
      nTWE       at 0 range 18 .. 18;
      WXN        at 0 range 19 .. 19;
      Reserved5  at 0 range 20 .. 20;
      Reserved6  at 0 range 21 .. 21;
      Reserved7  at 0 range 22 .. 23;
      E0E        at 0 range 24 .. 24;
      EE         at 0 range 25 .. 25;
      UCI        at 0 range 26 .. 26;
      Reserved8  at 0 range 27 .. 27;
      Reserved9  at 0 range 28 .. 29;
      Reserved10 at 0 range 30 .. 31;
   end record;

   function SCTLR_EL1_Read return SCTLR_EL1_Type with
      Inline => True;
   procedure SCTLR_EL1_Write (Value : in SCTLR_EL1_Type) with
      Inline => True;

   ----------------------------------------------------------------------------
   -- VBAR_ELx
   ----------------------------------------------------------------------------

   function VBAR_EL1_Read return Unsigned_64 with
      Inline => True;
   procedure VBAR_EL1_Write (Value : in Unsigned_64) with
      Inline => True;
   function VBAR_EL2_Read return Unsigned_64 with
      Inline => True;
   procedure VBAR_EL2_Write (Value : in Unsigned_64) with
      Inline => True;
   function VBAR_EL3_Read return Unsigned_64 with
      Inline => True;
   procedure VBAR_EL3_Write (Value : in Unsigned_64) with
      Inline => True;

   ----------------------------------------------------------------------------
   -- CNTP_CTL_EL0
   ----------------------------------------------------------------------------

   type CNTP_CTL_EL0_Type is
   record
      ENABLE    : Boolean;      -- Enables the timer.
      IMASK     : Boolean;      -- Timer interrupt mask bit.
      ISTATUS   : Boolean;      -- The status of the timer.
      Reserved1 : Bits_29 := 0;
      Reserved2 : Bits_32 := 0;
   end record with
      Bit_Order => Low_Order_First,
      Size      => 64;
   for CNTP_CTL_EL0_Type use record
      ENABLE    at 0 range 0 .. 0;
      IMASK     at 0 range 1 .. 1;
      ISTATUS   at 0 range 2 .. 2;
      Reserved1 at 0 range 3 .. 31;
      Reserved2 at 0 range 32 .. 63;
   end record;

   function CNTP_CTL_EL0_Read return CNTP_CTL_EL0_Type with
      Inline => True;
   procedure CNTP_CTL_EL0_Write (Value : in CNTP_CTL_EL0_Type) with
      Inline => True;

   ----------------------------------------------------------------------------
   -- CNTP_CVAL_EL0
   ----------------------------------------------------------------------------

   -- Holds the EL1 physical timer CompareValue.

   function CNTP_CVAL_EL0_Read return Unsigned_64 with
      Inline => True;
   procedure CNTP_CVAL_EL0_Write (Value : in Unsigned_64) with
      Inline => True;

   ----------------------------------------------------------------------------
   -- CNTP_TVAL_EL0
   ----------------------------------------------------------------------------

   type CNTP_TVAL_EL0_Type is
   record
      TimerValue : Unsigned_32;  -- The TimerValue view of the EL1 physical timer.
      Reserved   : Bits_32 := 0;
   end record with
      Bit_Order => Low_Order_First,
      Size      => 64;
   for CNTP_TVAL_EL0_Type use record
      TimerValue at 0 range 0 .. 31;
      Reserved   at 0 range 32 .. 63;
   end record;

   function CNTP_TVAL_EL0_Read return CNTP_TVAL_EL0_Type with
      Inline => True;
   procedure CNTP_TVAL_EL0_Write (Value : in CNTP_TVAL_EL0_Type) with
      Inline => True;

   ----------------------------------------------------------------------------
   -- CNTPCT_EL0
   ----------------------------------------------------------------------------

   -- Holds the 64-bit physical count value.

   function CNTPCT_EL0_Read return Unsigned_64 with
      Inline => True;

   ----------------------------------------------------------------------------
   -- CNTFRQ_EL0
   ----------------------------------------------------------------------------

   type CNTFRQ_EL0_Type is
   record
      Clock_frequency : Unsigned_32;  -- Clock_Frequency.
      Reserved        : Bits_32 := 0;
   end record with
      Bit_Order => Low_Order_First,
      Size      => 64;
   for CNTFRQ_EL0_Type use record
      Clock_frequency at 0 range 0 .. 31;
      Reserved        at 0 range 32 .. 63;
   end record;

   function CNTFRQ_EL0_Read return CNTFRQ_EL0_Type with
      Inline => True;

   ----------------------------------------------------------------------------
   -- Exceptions and interrupts
   ----------------------------------------------------------------------------

   procedure Irq_Enable with
      Inline => True;
   procedure Irq_Disable with
      Inline => True;

end AArch64;

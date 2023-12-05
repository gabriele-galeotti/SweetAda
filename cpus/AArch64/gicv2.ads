-----------------------------------------------------------------------------------------------------------------------
--                                                     SweetAda                                                      --
-----------------------------------------------------------------------------------------------------------------------
-- __HDS__                                                                                                           --
-- __FLN__ gic.ads                                                                                                   --
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

package GICv2 is

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
   -- 4.3 Distributor register descriptions
   ----------------------------------------------------------------------------

   -- 4.3.1 Distributor Control Register, GICD_CTLR

   type GICD_CTLR_Type is record
      EnableGrp0 : Boolean;      -- Global enable for forwarding pending Group 0 interrupts from the Distributor ...
      EnableGrp1 : Boolean;      -- Global enable for forwarding pending Group 1 interrupts from the Distributor ...
      Reserved   : Bits_30 := 0;
   end record
      with Bit_Order => Low_Order_First,
           Size      => 32;
   for GICD_CTLR_Type use record
      EnableGrp0 at 0 range  0 ..  0;
      EnableGrp1 at 0 range  1 ..  1;
      Reserved   at 0 range  2 .. 31;
   end record;

   -- 4.3.2 Interrupt Controller Type Register, GICD_TYPER

   type GICD_TYPER_Type is record
      ITLinesNumber : Bits_5;       -- Indicates the maximum number of interrupts that the GIC supports.
      CPUNumber     : Bits_3;       -- Indicates the number of implemented CPU interfaces.
      Reserved1     : Bits_2 := 0;
      SecurityExtn  : Boolean;      -- Indicates whether the GIC implements the Security Extensions.
      LSPI          : Bits_5;       -- If the GIC implements the Security Extensions, the value of this field is the ...
      Reserved2     : Bits_16 := 0;
   end record
      with Bit_Order => Low_Order_First,
           Size      => 32;
   for GICD_TYPER_Type use record
      ITLinesNumber at 0 range  0 ..  4;
      CPUNumber     at 0 range  5 ..  7;
      Reserved1     at 0 range  8 ..  9;
      SecurityExtn  at 0 range 10 .. 10;
      LSPI          at 0 range 11 .. 15;
      Reserved2     at 0 range 16 .. 31;
   end record;

   -- 4.3.3 Distributor Implementer Identification Register, GICD_IIDR

   type GICD_IIDR_Type is record
      Implementer : Bits_12; -- Contains the JEP106 code of the company that implemented the GIC CPU interface:a ...
      Revision    : Bits_4;  -- An IMPLEMENTATION DEFINED revision number for the CPU interface.
      Variant     : Bits_4;  -- The value of this field depends on the GIC architecture version, as follows: ...
      Reserved    : Bits_4;
      ProductID   : Bits_8;  -- An IMPLEMENTATION DEFINED product identifier
   end record
      with Bit_Order => Low_Order_First,
           Size      => 32;
   for GICD_IIDR_Type use record
      Implementer at 0 range  0 .. 11;
      Revision    at 0 range 12 .. 15;
      Variant     at 0 range 16 .. 19;
      Reserved    at 0 range 20 .. 23;
      ProductID   at 0 range 24 .. 31;
   end record;

   -- 4.3.4 Interrupt Group Registers, GICD_IGROUPRn

   type GICD_IGROUPRn_Type is array (Natural range <>) of Bitmap_32
      with Volatile_Components => True;

   -- 4.3.5 Interrupt Set-Enable Registers, GICD_ISENABLERn

   type GICD_ISENABLERn_Type is array (Natural range <>) of Bitmap_32
      with Volatile_Components => True;

   -- 4.3.6 Interrupt Clear-Enable Registers, GICD_ICENABLERn

   type GICD_ICENABLERn_Type is array (Natural range <>) of Bitmap_32
      with Volatile_Components => True;

   -- 4.3.7 Interrupt Set-Pending Registers, GICD_ISPENDRn

   type GICD_ISPENDRn_Type is array (Natural range <>) of Bitmap_32
      with Volatile_Components => True;

   -- 4.3.8 Interrupt Clear-Pending Registers, GICD_ICPENDRn

   type GICD_ICPENDRn_Type is array (Natural range <>) of Bitmap_32
      with Volatile_Components => True;

   -- 4.3.9 Interrupt Set-Active Registers, GICD_ISACTIVERn

   type GICD_ISACTIVERn_Type is array (Natural range <>) of Bitmap_32
      with Volatile_Components => True;

   -- 4.3.10 Interrupt Clear-Active Registers, GICD_ICACTIVERn

   type GICD_ICACTIVERn_Type is array (Natural range <>) of Bitmap_32
      with Volatile_Components => True;

   -- 4.3.11 Interrupt Priority Registers, GICD_IPRIORITYRn

   type IPRIORITY_Type is record
      Priority_bo0 : Unsigned_8; -- Each priority field holds a priority value, from an IMPLEMENTATION DEFINED range
      Priority_bo1 : Unsigned_8;
      Priority_bo2 : Unsigned_8;
      Priority_bo3 : Unsigned_8;
   end record
      with Bit_Order => Low_Order_First,
           Size      => 32;
   for IPRIORITY_Type use record
      Priority_bo0 at 0 range  0 ..  7;
      Priority_bo1 at 0 range  8 .. 15;
      Priority_bo2 at 0 range 16 .. 23;
      Priority_bo3 at 0 range 24 .. 31;
   end record;

   type GICD_IPRIORITYRn_Type is array (Natural range <>) of IPRIORITY_Type
      with Volatile_Components => True;

   -- 4.3.12 Interrupt Processor Targets Registers, GICD_ITARGETSRn

   type ITARGETS_Type is record
      CPUtargets_bo0 : Unsigned_8; -- Processors in the system number from 0, and each bit in a CPU targets field ...
      CPUtargets_bo1 : Unsigned_8;
      CPUtargets_bo2 : Unsigned_8;
      CPUtargets_bo3 : Unsigned_8;
   end record
      with Bit_Order => Low_Order_First,
           Size      => 32;
   for ITARGETS_Type use record
      CPUtargets_bo0 at 0 range  0 ..  7;
      CPUtargets_bo1 at 0 range  8 .. 15;
      CPUtargets_bo2 at 0 range 16 .. 23;
      CPUtargets_bo3 at 0 range 24 .. 31;
   end record;

   type GICD_ITARGETSRn_Type is array (Natural range <>) of ITARGETS_Type
      with Volatile_Components => True;

   -- 4.3.13 Interrupt Configuration Registers, GICD_ICFGRn

   IRQ_LEVEL : constant := 0; -- Corresponding interrupt is level-sensitive.
   IRQ_EGDE  : constant := 1; -- Corresponding interrupt is edge-triggered.

   type Int_Config_Type is record
      Reserved : Bits_1 := 0;
      IRQ_mode : Bits_1;      -- For Int_config[1], the most significant bit, bit [2F+1], the encoding is: ...
   end record
      with Pack => True;

   type ICFGR_Type is array (0 .. 15) of Int_Config_Type
      with Pack => True;

   type GICD_ICFGRn_Type is array (Natural range <>) of ICFGR_Type
      with Volatile_Components => True;

   -- 4.3.14 Non-secure Access Control Registers, GICD_NSACRn

   ACCESS_NO_NONSECURE     : constant := 2#00#; -- No Non-secure access is permitted to fields associated ...
   ACCESS_NONSECURE_WR     : constant := 2#01#; -- Non-secure write access is permitted to fields associated ...
   ACCESS_ADD_NONSECURE_WR : constant := 2#10#; -- Adds Non-secure write access permission to fields associated ...
   ACCESS_ADD_NONSECURE_RW : constant := 2#11#; -- Adds Non-secure read and write access permission to fields associated ...

   type NSACR_Type is array (0 .. 15) of Bits_2
      with Pack => True;

   type GICD_NSACRn_Type is array (Natural range <>) of NSACR_Type
      with Volatile_Components => True;

   -- 4.3.15 Software Generated Interrupt Register, GICD_SGIR

   NSATT_Group0 : constant := 0; -- Forward the SGI specified in the SGIINTID field to ... Group 0 on that interface.
   NSATT_Group1 : constant := 1; -- Forward the SGI specified in the SGIINTID field to ... Group 1 on that interface.

   TargetListFilter_CPUTGTLF  : constant := 2#00#; -- Forward the interrupt to the CPU interfaces specified in the ...
   TargetListFilter_CPUINVERT : constant := 2#01#; -- Forward the interrupt to all CPU interfaces except that of the ...
   TargetListFilter_CPUREQ    : constant := 2#10#; -- Forward the interrupt only to the CPU interface of the processor ...
   TargetListFilter_Reserved  : constant := 2#11#; -- Reserved.

   type GICD_SGIR_Type is record
      SGIINTID         : Bits_4;       -- The Interrupt ID of the SGI to forward to the specified CPU interfaces.
      Reserved1        : Bits_11 := 0;
      NSATT            : Bits_1;       -- Specifies the required security value of the SGI: ...
      CPUTargetList    : Unsigned_8;   -- When TargetList Filter = 0b00, defines the CPU interfaces to which the ...
      TargetListFilter : Bits_2;       -- Determines how the distributor must process the requested SGI:
      Reserved2        : Bits_6 := 0;
   end record
      with Bit_Order => Low_Order_First,
           Size      => 32;
   for GICD_SGIR_Type use record
      SGIINTID         at 0 range  0 ..  3;
      Reserved1        at 0 range  4 .. 14;
      NSATT            at 0 range 15 .. 15;
      CPUTargetList    at 0 range 16 .. 23;
      TargetListFilter at 0 range 24 .. 25;
      Reserved2        at 0 range 26 .. 31;
   end record;

   -- 4.3.16 SGI Clear-Pending Registers, GICD_CPENDSGIRn

   type CPENDSGIR_Type is array (0 .. 3) of Bitmap_8
      with Size => 32;

   type GICD_CPENDSGIRn_Type is array (Natural range <>) of CPENDSGIR_Type
      with Volatile_Components => True;

   -- 4.3.17 SGI Set-Pending Registers, GICD_SPENDSGIRn

   type SPENDSGIR_Type is array (0 .. 3) of Bitmap_8
      with Size => 32;

   type GICD_SPENDSGIRn_Type is array (Natural range <>) of SPENDSGIR_Type
      with Volatile_Components => True;

   -- 4.3.18 Identification registers

   type GICD_ICPIDR2_Type is record
      ImplDef1 : Bits_4;  -- IMPLEMENTATION DEFINED.
      ArchRev  : Bits_4;  -- Revision field for the GIC architecture.
      ImplDef2 : Bits_24; -- IMPLEMENTATION DEFINED.
   end record
      with Bit_Order => Low_Order_First,
           Size      => 32;
   for GICD_ICPIDR2_Type use record
      ImplDef1 at 0 range 0 ..  3;
      ArchRev  at 0 range 4 ..  7;
      ImplDef2 at 0 range 8 .. 31;
   end record;

   -- 4.1.2 Distributor register map

   type GICD_Type is record
      GICD_CTLR       : GICD_CTLR_Type    with Volatile_Full_Access => True;
      GICD_TYPER      : GICD_TYPER_Type   with Volatile_Full_Access => True;
      GICD_IIDR       : GICD_IIDR_Type    with Volatile_Full_Access => True;
      GICD_IGROUPR    : GICD_IGROUPRn_Type    (0 .. 31);
      GICD_ISENABLER  : GICD_ISENABLERn_Type  (0 .. 31);
      GICD_ICENABLER  : GICD_ICENABLERn_Type  (0 .. 31);
      GICD_ISPENDR    : GICD_ISPENDRn_Type    (0 .. 31);
      GICD_ICPENDR    : GICD_ICPENDRn_Type    (0 .. 31);
      GICD_ISACTIVER  : GICD_ISACTIVERn_Type  (0 .. 31);
      GICD_ICACTIVER  : GICD_ICACTIVERn_Type  (0 .. 31);
      GICD_IPRIORITYR : GICD_IPRIORITYRn_Type (0 .. 31);
      GICD_ITARGETSR  : GICD_ITARGETSRn_Type  (0 .. 7);
      GICD_ICFGR      : GICD_ICFGRn_Type      (0 .. 63);
      GICD_NSACR      : GICD_NSACRn_Type      (0 .. 63);
      GICD_SGIR       : GICD_SGIR_Type    with Volatile_Full_Access => True;
      GICD_CPENDSGIR  : GICD_CPENDSGIRn_Type  (0 .. 1);
      GICD_SPENDSGIR  : GICD_SPENDSGIRn_Type  (0 .. 1);
      GICD_ICPIDR2    : GICD_ICPIDR2_Type with Volatile_Full_Access => True;
   end record
      with Size => 16#1000# * 8;
   for GICD_Type use record
      GICD_CTLR       at 16#000# range 0 .. 31;
      GICD_TYPER      at 16#004# range 0 .. 31;
      GICD_IIDR       at 16#008# range 0 .. 31;
      GICD_IGROUPR    at 16#080# range 0 .. 32 * 32 - 1;
      GICD_ISENABLER  at 16#100# range 0 .. 32 * 32 - 1;
      GICD_ICENABLER  at 16#180# range 0 .. 32 * 32 - 1;
      GICD_ISPENDR    at 16#200# range 0 .. 32 * 32 - 1;
      GICD_ICPENDR    at 16#280# range 0 .. 32 * 32 - 1;
      GICD_ISACTIVER  at 16#300# range 0 .. 32 * 32 - 1;
      GICD_ICACTIVER  at 16#380# range 0 .. 32 * 32 - 1;
      GICD_IPRIORITYR at 16#400# range 0 .. 32 * 32 - 1;
      GICD_ITARGETSR  at 16#800# range 0 .. 8 * 32 - 1;
      GICD_ICFGR      at 16#C00# range 0 .. 64 * 32 - 1;
      GICD_NSACR      at 16#E00# range 0 .. 64 * 32 - 1;
      GICD_SGIR       at 16#F00# range 0 .. 31;
      GICD_CPENDSGIR  at 16#F10# range 0 .. 2 * 32 - 1;
      GICD_SPENDSGIR  at 16#F20# range 0 .. 2 * 32 - 1;
      GICD_ICPIDR2    at 16#FE8# range 0 .. 31;
   end record;

   ----------------------------------------------------------------------------
   -- 4.4 CPU interface register descriptions
   ----------------------------------------------------------------------------

   -- 4.4.1 CPU Interface Control Register, GICC_CTLR

   AckCtl_NOACK : constant := 0; -- If the highest priority pending interrupt is a Group 1 interrupt, a read of the ...
   AckCtl_ACK   : constant := 1; -- If the highest priority pending interrupt is a Group 1 interrupt, a read of the ...

   FIQEn_IRQ : constant := 0; -- Signal Group 0 interrupts using the IRQ signal.
   FIQEn_FIQ : constant := 1; -- Signal Group 0 interrupts using the FIQ signal.

   CBPR_BPR0ABPR1 : constant := 0; -- To determine any preemption, use: ...
   CBPR_BPR       : constant := 1; -- To determine any preemption use the GICC_BPR for both Group 0 and Group 1 interrupts.

   EOImodeS_DROPDEACT : constant := 0; -- GICC_EOIR has both priority drop and deactivate interrupt functionality.
   EOImodeS_DROP      : constant := 1; -- GICC_EOIR has priority drop functionality only.

   EOImodeNS_DROPDEACT : constant := 0; -- GICC_EOIR has both priority drop and deactivate interrupt functionality.
   EOImodeNS_DROP      : constant := 1; -- GICC_EOIR has priority drop functionality only.

   type GICC_CTLR_Type is record
      EnableGrp0    : Boolean;      -- Enable for the signaling of Group 0 interrupts by the CPU interface to the connected ...
      EnableGrp1    : Boolean;      -- Enable for the signaling of Group 1 interrupts by the CPU interface to the connected ...
      AckCtl        : Bits_1;       -- When the highest priority pending interrupt is a Group 1 interrupt, determines both: ...
      FIQEn         : Bits_1;       -- Controls whether the CPU interface signals Group 0 interrupts to a target processor ...
      CBPR          : Bits_1;       -- Controls whether the GICC_BPR provides common control to Group 0 and Group 1 ...
      FIQBypDisGrp0 : Boolean;      -- When the signaling of FIQs by the CPU interface is disabled, this bit partly controls ...
      IRQBypDisGrp0 : Boolean;      -- When the signaling of IRQs by the CPU interface is disabled, this bit partly controls ...
      FIQBypDisGrp1 : Boolean;      -- Alias of FIQBypDisGrp1 from the Non-secure copy of this register, ...
      IRQBypDisGrp1 : Boolean;      -- Alias of IRQBypDisGrp1 from the Non-secure copy of this register, ...
      EOImodeS      : Bits_1;       -- Controls the behavior of accesses to GICC_EOIR and GICC_DIR registers.
      EOImodeNS     : Bits_1;       -- Alias of EOImodeNS from the Non-secure copy of this register, ...
      Reserved      : Bits_21 := 0;
   end record
      with Bit_Order => Low_Order_First,
           Size      => 32;
   for GICC_CTLR_Type use record
      EnableGrp0    at 0 range  0 ..  0;
      EnableGrp1    at 0 range  1 ..  1;
      AckCtl        at 0 range  2 ..  2;
      FIQEn         at 0 range  3 ..  3;
      CBPR          at 0 range  4 ..  4;
      FIQBypDisGrp0 at 0 range  5 ..  5;
      IRQBypDisGrp0 at 0 range  6 ..  6;
      FIQBypDisGrp1 at 0 range  7 ..  7;
      IRQBypDisGrp1 at 0 range  8 ..  8;
      EOImodeS      at 0 range  9 ..  9;
      EOImodeNS     at 0 range 10 .. 10;
      Reserved      at 0 range 11 .. 31;
   end record;

   -- 4.4.2 Interrupt Priority Mask Register, GICC_PMR

   type GICC_PMR_Type is record
      Priority : Unsigned_8;   -- The priority mask level for the CPU interface.
      Reserved : Bits_24 := 0;
   end record
      with Bit_Order => Low_Order_First,
           Size      => 32;
   for GICC_PMR_Type use record
      Priority at 0 range 0 ..  7;
      Reserved at 0 range 8 .. 31;
   end record;

   -- 4.4.3 Binary Point Register, GICC_BPR

   type GICC_BPR_Type is record
      Binary_point : Bits_3;       -- The value of this field controls how the 8-bit interrupt priority field is split ...
      Reserved     : Bits_29 := 0;
   end record
      with Bit_Order => Low_Order_First,
           Size      => 32;
   for GICC_BPR_Type use record
      Binary_point at 0 range 0 ..  2;
      Reserved     at 0 range 3 .. 31;
   end record;

   -- 4.4.4 Interrupt Acknowledge Register, GICC_IAR

   type GICC_IAR_Type is record
      Interrupt_ID : Bits_10;      -- The interrupt ID.
      CPUID        : Bits_3;       -- For SGIs in a multiprocessor implementation, this field identifies the processor ...
      Reserved     : Bits_19 := 0;
   end record
      with Bit_Order => Low_Order_First,
           Size      => 32;
   for GICC_IAR_Type use record
      Interrupt_ID at 0 range  0 ..  9;
      CPUID        at 0 range 10 .. 12;
      Reserved     at 0 range 13 .. 31;
   end record;

   -- 4.4.5 End of Interrupt Register, GICC_EOIR

   type GICC_EOIR_Type is record
      EOIINTID : Bits_10;      -- The Interrupt ID value from the corresponding GICC_IAR access.
      CPUID    : Bits_3;       -- On a multiprocessor implementation, if the write refers to an SGI, this field contains ...
      Reserved : Bits_19 := 0;
   end record
      with Bit_Order => Low_Order_First,
           Size      => 32;
   for GICC_EOIR_Type use record
      EOIINTID at 0 range  0 ..  9;
      CPUID    at 0 range 10 .. 12;
      Reserved at 0 range 13 .. 31;
   end record;

   -- 4.4.6 Running Priority Register, GICC_RPR

   type GICC_RPR_Type is record
      Priority : Unsigned_8;   -- The current running priority on the CPU interface.
      Reserved : Bits_24 := 0;
   end record
      with Bit_Order => Low_Order_First,
           Size      => 32;
   for GICC_RPR_Type use record
      Priority at 0 range 0 ..  7;
      Reserved at 0 range 8 .. 31;
   end record;

   -- 4.4.7 Highest Priority Pending Interrupt Register, GICC_HPPIR

   type GICC_HPPIR_Type is record
      PENDINTID : Bits_10;      -- The interrupt ID of the highest priority pending interrupt.
      CPUID     : Bits_3;       -- On a multiprocessor implementation, if the PENDINTID field returns the ID of an SGI, ...
      Reserved  : Bits_19 := 0;
   end record
      with Bit_Order => Low_Order_First,
           Size      => 32;
   for GICC_HPPIR_Type use record
      PENDINTID at 0 range  0 ..  9;
      CPUID     at 0 range 10 .. 12;
      Reserved  at 0 range 13 .. 31;
   end record;

   -- 4.4.8 Aliased Binary Point Register, GICC_ABPR

   type GICC_ABPR_Type is new GICC_BPR_Type;

   -- 4.4.9 Aliased Interrupt Acknowledge Register, GICC_AIAR

   type GICC_AIAR_Type is new GICC_IAR_Type;

   -- 4.4.10 Aliased End of Interrupt Register, GICC_AEOIR

   type GICC_AEOIR_Type is new GICC_EOIR_Type;

   -- 4.4.11 Aliased Highest Priority Pending Interrupt Register, GICC_AHPPIR

   type GICC_AHPPIR_Type is new GICC_HPPIR_Type;

   -- 4.4.12 Active Priorities Registers, GICC_APRn
   -- 4.4.13 Non-secure Active Priorities Registers, GICC_NSAPRn

   -- 4.4.14 CPU Interface Identification Register, GICC_IIDR

   type GICC_IIDR_Type is record
      Implementer          : Bits_12; -- Contains the JEP106 code of the company that implemented the GIC CPU interface:a ...
      Revision             : Bits_4;  -- An IMPLEMENTATION DEFINED revision number for the CPU interface.
      Architecture_version : Bits_4;  -- The value of this field depends on the GIC architecture version, as follows: ...
      ProductID            : Bits_12; -- An IMPLEMENTATION DEFINED product identifier
   end record
      with Bit_Order => Low_Order_First,
           Size      => 32;
   for GICC_IIDR_Type use record
      Implementer          at 0 range  0 .. 11;
      Revision             at 0 range 12 .. 15;
      Architecture_version at 0 range 16 .. 19;
      ProductID            at 0 range 20 .. 31;
   end record;

   -- 4.4.15 Deactivate Interrupt Register, GICC_DIR

   type GICC_DIR_Type is record
      Interrupt_ID : Bits_10;      -- The interrupt ID.
      CPUID        : Bits_3;       -- For an SGI in a multiprocessor implementation, this field identifies the processor ...
      Reserved     : Bits_19 := 0;
   end record
      with Bit_Order => Low_Order_First,
           Size      => 32;
   for GICC_DIR_Type use record
      Interrupt_ID at 0 range  0 ..  9;
      CPUID        at 0 range 10 .. 12;
      Reserved     at 0 range 13 .. 31;
   end record;

   -- 4.1.3 CPU interface register map

   type GICC_Type is record
      GICC_CTLR   : GICC_CTLR_Type   with Volatile_Full_Access => True;
      GICC_PMR    : GICC_PMR_Type    with Volatile_Full_Access => True;
      GICC_BPR    : GICC_BPR_Type    with Volatile_Full_Access => True;
      GICC_IAR    : GICC_IAR_Type    with Volatile_Full_Access => True;
      GICC_EOIR   : GICC_EOIR_Type   with Volatile_Full_Access => True;
      GICC_RPR    : GICC_RPR_Type    with Volatile_Full_Access => True;
      GICC_HPPIR  : GICC_HPPIR_Type  with Volatile_Full_Access => True;
      GICC_ABPR   : GICC_ABPR_Type   with Volatile_Full_Access => True;
      GICC_AIAR   : GICC_AIAR_Type   with Volatile_Full_Access => True;
      GICC_AEOIR  : GICC_AEOIR_Type  with Volatile_Full_Access => True;
      GICC_AHPPIR : GICC_AHPPIR_Type with Volatile_Full_Access => True;
      GICC_APR0   : Unsigned_32      with Volatile_Full_Access => True;
      GICC_APR1   : Unsigned_32      with Volatile_Full_Access => True;
      GICC_APR2   : Unsigned_32      with Volatile_Full_Access => True;
      GICC_APR3   : Unsigned_32      with Volatile_Full_Access => True;
      GICC_NSAPR0 : Unsigned_32      with Volatile_Full_Access => True;
      GICC_NSAPR1 : Unsigned_32      with Volatile_Full_Access => True;
      GICC_NSAPR2 : Unsigned_32      with Volatile_Full_Access => True;
      GICC_NSAPR3 : Unsigned_32      with Volatile_Full_Access => True;
      GICC_IIDR   : GICC_IIDR_Type   with Volatile_Full_Access => True;
      GICC_DIR    : GICC_DIR_Type    with Volatile_Full_Access => True;
   end record
      with Size => 16#1004# * 8;
   for GICC_Type use record
      GICC_CTLR   at 16#0000# range 0 .. 31;
      GICC_PMR    at 16#0004# range 0 .. 31;
      GICC_BPR    at 16#0008# range 0 .. 31;
      GICC_IAR    at 16#000C# range 0 .. 31;
      GICC_EOIR   at 16#0010# range 0 .. 31;
      GICC_RPR    at 16#0014# range 0 .. 31;
      GICC_HPPIR  at 16#0018# range 0 .. 31;
      GICC_ABPR   at 16#001C# range 0 .. 31;
      GICC_AIAR   at 16#0020# range 0 .. 31;
      GICC_AEOIR  at 16#0024# range 0 .. 31;
      GICC_AHPPIR at 16#0028# range 0 .. 31;
      GICC_APR0   at 16#00D0# range 0 .. 31;
      GICC_APR1   at 16#00D4# range 0 .. 31;
      GICC_APR2   at 16#00D8# range 0 .. 31;
      GICC_APR3   at 16#00DC# range 0 .. 31;
      GICC_NSAPR0 at 16#00E0# range 0 .. 31;
      GICC_NSAPR1 at 16#00E4# range 0 .. 31;
      GICC_NSAPR2 at 16#00E8# range 0 .. 31;
      GICC_NSAPR3 at 16#00EC# range 0 .. 31;
      GICC_IIDR   at 16#00FC# range 0 .. 31;
      GICC_DIR    at 16#1000# range 0 .. 31;
   end record;

end GICv2;

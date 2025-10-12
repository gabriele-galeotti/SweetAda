-----------------------------------------------------------------------------------------------------------------------
--                                                     SweetAda                                                      --
-----------------------------------------------------------------------------------------------------------------------
-- __HDS__                                                                                                           --
-- __FLN__ zynqa9.ads                                                                                                --
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

package ZynqA9
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
   -- Zynq-7000 SoC Technical Reference Manual
   -- UG585 (v1.13) April 2, 2021
   ----------------------------------------------------------------------------

   ----------------------------------------------------------------------------
   -- B.3 Module Summary
   ----------------------------------------------------------------------------

   -- Module Name                   Base Address                  Module Type                       Description
   axi_hp0_BASEADDRESS            : constant := 16#F800_8000#; -- axi_hp                            AXI_HP Interface (AFI), Interface 0
   axi_hp1_BASEADDRESS            : constant := 16#F800_9000#; -- axi_hp                            AXI_HP Interface (AFI), Interface 1
   axi_hp2_BASEADDRESS            : constant := 16#F800_A000#; -- axi_hp                            AXI_HP Interface (AFI), Interface 2
   axi_hp3_BASEADDRESS            : constant := 16#F800_B000#; -- axi_hp                            AXI_HP Interface (AFI), Interface 3
   can0_BASEADDRESS               : constant := 16#E000_8000#; -- can                               Controller Area Network
   can1_BASEADDRESS               : constant := 16#E000_9000#; -- can                               Controller Area Network
   ddrc_BASEADDRESS               : constant := 16#F800_6000#; -- ddrc                              DDR memory controller
   debug_cpu_cti0_BASEADDRESS     : constant := 16#F889_8000#; -- cti                               Cross Trigger Interface, CPU 0
   debug_cpu_cti1_BASEADDRESS     : constant := 16#F889_9000#; -- cti                               Cross Trigger Interface, CPU 1
   debug_cpu_pmu0_BASEADDRESS     : constant := 16#F889_1000#; -- cortexa9_pmu                      Cortex A9 Performance Monitoring Unit, CPU 0
   debug_cpu_pmu1_BASEADDRESS     : constant := 16#F889_3000#; -- cortexa9_pmu                      Cortex A9 Performance Monitoring Unit, CPU 1
   debug_cpu_ptm0_BASEADDRESS     : constant := 16#F889_C000#; -- ptm                               CoreSight PTM-A9, CPU 0
   debug_cpu_ptm1_BASEADDRESS     : constant := 16#F889_D000#; -- ptm                               CoreSight PTM-A9, CPU 1
   debug_cti_etb_tpiu_BASEADDRESS : constant := 16#F880_2000#; -- cti                               Cross Trigger Interface, ETB and TPIU
   debug_cti_ftm_BASEADDRESS      : constant := 16#F880_9000#; -- cti                               Cross Trigger Interface, FTM
   debug_dap_rom_BASEADDRESS      : constant := 16#F880_0000#; -- dap                               Debug Access Port ROM Table
   debug_etb_BASEADDRESS          : constant := 16#F880_1000#; -- etb                               Embedded Trace Buffer
   debug_ftm_BASEADDRESS          : constant := 16#F880_B000#; -- ftm                               Fabric Trace Macrocell
   debug_funnel_BASEADDRESS       : constant := 16#F880_4000#; -- funnel                            CoreSight Trace Funnel
   debug_itm_BASEADDRESS          : constant := 16#F880_5000#; -- itm                               Instrumentation Trace Macrocell
   debug_tpiu_BASEADDRESS         : constant := 16#F880_3000#; -- tpiu                              Trace Port Interface Unit
   devcfg_BASEADDRESS             : constant := 16#F800_7000#; -- devcfg                            Device configuraion Interface
   dmac0_ns_BASEADDRESS           : constant := 16#F800_4000#; -- dmac                              Direct Memory Access Controller, PL330, Non-Secure Mode
   dmac0_s_BASEADDRESS            : constant := 16#F800_3000#; -- dmac                              Direct Memory Access Controller, PL330, Secure Mode
   gem0_BASEADDRESS               : constant := 16#E000_B000#; -- GEM                               Gigabit Ethernet Controller
   gem1_BASEADDRESS               : constant := 16#E000_C000#; -- GEM                               Gigabit Ethernet Controller
   gpio_BASEADDRESS               : constant := 16#E000_A000#; -- gpio                              General Purpose Input / Output
   gpv_qos301_cpu_BASEADDRESS     : constant := 16#F894_6000#; -- qos301                            AMBA Network Interconnect Advanced Quality of Service (QoS-301), CPU-to-DDR
   gpv_qos301_dmac_BASEADDRESS    : constant := 16#F894_7000#; -- qos301                            AMBA Network Interconnect Advanced Quality of Service (QoS-301), DMAC
   gpv_qos301_iou_BASEADDRESS     : constant := 16#F894_8000#; -- qos301                            AMBA Network Interconnect Advanced Quality of Service (QoS-301), IOU
   gpv_trustzone_BASEADDRESS      : constant := 16#F890_0000#; -- nic301_addr_region_ctrl_registers AMBA NIC301 TrustZone.
   i2c0_BASEADDRESS               : constant := 16#E000_4000#; -- IIC                               Inter Integrated Circuit (I2C)
   i2c1_BASEADDRESS               : constant := 16#E000_5000#; -- IIC                               Inter Integrated Circuit (I2C)
   l2cache_BASEADDRESS            : constant := 16#F8F0_2000#; -- L2Cpl310                          L2 cache PL310
   mpcore_BASEADDRESS             : constant := 16#F8F0_0000#; -- mpcore                            Mpcore - SCU, Interrupt controller, Counters and Timers
   ocm_BASEADDRESS                : constant := 16#F800_C000#; -- ocm                               On-Chip Memory Registers
   qspi_BASEADDRESS               : constant := 16#E000_D000#; -- qspi                              LQSPI module Registers
   sd0_BASEADDRESS                : constant := 16#E010_0000#; -- sdio                              SD2.0/ SDIO2.0/ MMC3.31 AHB Host ControllerRegisters
   sd1_BASEADDRESS                : constant := 16#E010_1000#; -- sdio                              SD2.0/ SDIO2.0/ MMC3.31 AHB Host ControllerRegisters
   slcr_BASEADDRESS               : constant := 16#F800_0000#; -- slcr                              System Level Control Registers
   smcc_BASEADDRESS               : constant := 16#E000_E000#; -- pl353                             Shared memory controller
   spi0_BASEADDRESS               : constant := 16#E000_6000#; -- SPI                               Serial Peripheral Interface
   spi1_BASEADDRESS               : constant := 16#E000_7000#; -- SPI                               Serial Peripheral Interface
   swdt_BASEADDRESS               : constant := 16#F800_5000#; -- swdt                              System Watchdog Timer Registers
   ttc0_BASEADDRESS               : constant := 16#F800_1000#; -- ttc                               Triple Timer Counter
   ttc1_BASEADDRESS               : constant := 16#F800_2000#; -- ttc                               Triple Timer Counter
   uart0_BASEADDRESS              : constant := 16#E000_0000#; -- UART                              Universal Asynchronous Receiver Transmitter
   uart1_BASEADDRESS              : constant := 16#E000_1000#; -- UART                              Universal Asynchronous Receiver Transmitter
   usb0_BASEADDRESS               : constant := 16#E000_2000#; -- usb                               USB controller registers
   usb1_BASEADDRESS               : constant := 16#E000_3000#; -- usb                               USB controller registers

   ----------------------------------------------------------------------------
   -- B.24 Application Processing Unit (mpcore)
   ----------------------------------------------------------------------------

   -- Register (mpcore) ICCICR

   type ICCICR_Type is record
      EnableS  : Boolean := False; -- Global enable for the signaling of Secure interrupts by the CPU interfaces to the connected processors.
      EnableNS : Boolean := False; -- An alias of the Enable bit in the Non-secure ICCICR.
      AckCtl   : Boolean := False; -- Controls whether a Secure read of the ICCIAR, when the highest priority pending interrupt is Non-secure, causes the CPU interface to acknowledge the interrupt.
      FIQEn    : Boolean := False; -- Controls whether the GIC signals Secure interrupts to a target processor using the FIQ or the IRQ signal.
      SBPR     : Boolean := False; -- Controls whether the CPU interface uses the Secure or Non-secure Binary Point Register for preemption.
      Reserved : Bits_27 := 0;
   end record
      with Bit_Order => Low_Order_First,
           Size      => 32;
   for ICCICR_Type use record
      EnableS  at 0 range 0 ..  0;
      EnableNS at 0 range 1 ..  1;
      AckCtl   at 0 range 2 ..  2;
      FIQEn    at 0 range 3 ..  3;
      SBPR     at 0 range 4 ..  4;
      Reserved at 0 range 5 .. 31;
   end record;

   -- Register (mpcore) ICCPMR

   type ICCPMR_Type is record
      Priority : Unsigned_8 := 0; -- The priority mask level for the CPU interface.
      Reserved : Bits_24    := 0;
   end record
      with Bit_Order => Low_Order_First,
           Size      => 32;
   for ICCPMR_Type use record
      Priority at 0 range 0 ..  7;
      Reserved at 0 range 8 .. 31;
   end record;

   -- Register (mpcore) ICCBPR

   type ICCBPR_Type is record
      Binary_point : Bits_3  := 16#2#; -- The value of this field controls the 8-bit interrupt priority field is split into a group priority field, used to determine interrupt preemption, and a subpriority field.
      Reserved     : Bits_29 := 0;
   end record
      with Bit_Order => Low_Order_First,
           Size      => 32;
   for ICCBPR_Type use record
      Binary_point at 0 range 0 ..  2;
      Reserved     at 0 range 3 .. 31;
   end record;

   -- Register (mpcore) ICCIAR

   type ICCIAR_Type is record
      ACKINTID : Bits_10 := 16#3FF#; -- Identifies the processor that requested the interrupt.
      CPUID    : Bits_3  := 0;       -- The interrupt ID.
      Reserved : Bits_19 := 0;
   end record
      with Bit_Order => Low_Order_First,
           Size      => 32;
   for ICCIAR_Type use record
      ACKINTID at 0 range  0 ..  9;
      CPUID    at 0 range 10 .. 12;
      Reserved at 0 range 13 .. 31;
   end record;

   -- Register (mpcore) ICCEOIR

   type ICCEOIR_Type is record
      EOIINTID : Bits_10 := 0; -- The ACKINTID value from the corresponding ICCIAR access.
      CPUID    : Bits_3  := 0; -- On completion of the processing of an SGI, this field contains the CPUID value from the corresponding ICCIAR access.
      Reserved : Bits_19 := 0;
   end record
      with Bit_Order => Low_Order_First,
           Size      => 32;
   for ICCEOIR_Type use record
      EOIINTID at 0 range  0 ..  9;
      CPUID    at 0 range 10 .. 12;
      Reserved at 0 range 13 .. 31;
   end record;

   -- Register (mpcore) ICCRPR

   type ICCRPR_Type is record
      Priority : Unsigned_8 := 16#FF#; -- The priority value of the highest priority interrupt that is active on the CPU interface.
      Reserved : Bits_24    := 0;
   end record
      with Bit_Order => Low_Order_First,
           Size      => 32;
   for ICCRPR_Type use record
      Priority at 0 range 0 ..  7;
      Reserved at 0 range 8 .. 31;
   end record;

   -- Register (mpcore) ICCHPIR

   type ICCHPIR_Type is record
      PENDINTID : Bits_10 := 16#3FF#; -- The interrupt ID of the highest priority pending interrupt.
      CPUID     : Bits_3  := 0;       -- If the PENDINTID field returns the ID of an SGI, this field contains the CPUID value for that interrupt.
      Reserved  : Bits_19 := 0;
   end record
      with Bit_Order => Low_Order_First,
           Size      => 32;
   for ICCHPIR_Type use record
      PENDINTID at 0 range  0 ..  9;
      CPUID     at 0 range 10 .. 12;
      Reserved  at 0 range 13 .. 31;
   end record;

   -- Register (mpcore) ICCABPR

   type ICCABPR_Type is record
      Binary_point : Bits_3  := 16#3#; -- Provides an alias of the Non-secure ICCBPR.
      Reserved     : Bits_29 := 0;
   end record
      with Bit_Order => Low_Order_First,
           Size      => 32;
   for ICCABPR_Type use record
      Binary_point at 0 range 0 ..  2;
      Reserved     at 0 range 3 .. 31;
   end record;

   -- Register (mpcore) ICCIDR

   type ICCIDR_Type is record
      Implementer          : Bits_12; -- Returns the JEP106 code of the company that implemented the Cortex-A9 processor interface RTL.
      Revision_number      : Bits_4;  -- Returns the revision number of the Interrupt Controller.
      Architecture_version : Bits_4;  -- Identifies the architecture version
      Part_number          : Bits_12; -- Identifies the peripheral
   end record
      with Bit_Order => Low_Order_First,
           Size      => 32;
   for ICCIDR_Type use record
      Implementer          at 0 range  0 .. 11;
      Revision_number      at 0 range 12 .. 15;
      Architecture_version at 0 range 16 .. 19;
      Part_number          at 0 range 20 .. 31;
   end record;

   -- Register (mpcore) ICDDCR

   type ICDDCR_Type is record
      Enable_secure     : Boolean := False; -- 0 = disables all Secure interrupt control bits in the distributor from changing state because of any external stimulus change that occurs on the corresponding SPI or PPI signals. 1 = enables the distributor to update register locations for Secure interrupts.
      Enable_Non_secure : Boolean := False; -- 0 = disables all Non-secure interrupts control bits in the distributor from changing state because of any external stimulus change that occurs on the corresponding SPI or PPI signals 1 = enables the distributor to update register locations for Non-secure interrupts
      Reserved          : Bits_30 := 0;
   end record
      with Bit_Order => Low_Order_First,
           Size      => 32;
   for ICDDCR_Type use record
      Enable_secure     at 0 range 0 ..  0;
      Enable_Non_secure at 0 range 1 ..  1;
      Reserved          at 0 range 2 .. 31;
   end record;

   -- Register (mpcore) ICDICTR

   IT_Lines_Number_32_0    : constant := 2#00000#; -- the distributor provides 32 interrupts, no external interrupt lines.
   IT_Lines_Number_64_32   : constant := 2#00001#; -- the distributor provides 64 interrupts, 32 external interrupt lines.
   IT_Lines_Number_96_64   : constant := 2#00010#; -- the distributor provides 96 interrupts, 64 external interrupt lines.
   IT_Lines_Number_128_96  : constant := 2#00011#; -- the distributor provide 128 interrupts, 96 external interrupt lines.
   IT_Lines_Number_160_128 : constant := 2#00100#; -- the distributor provides 160 interrupts, 128 external interrupt lines.
   IT_Lines_Number_192_160 : constant := 2#00101#; -- the distributor provides 192 interrupts, 160 external interrupt lines.
   IT_Lines_Number_224_192 : constant := 2#00110#; -- the distributor provides 224 interrupts, 192 external interrupt lines.
   IT_Lines_Number_256_224 : constant := 2#00111#; -- the distributor provides 256 interrupts, 224 external interrupt lines.

   CPU_Number_1 : constant := 2#000#; -- the Cortex-A9 MPCore configuration contains one Cortex-A9 processor.
   CPU_Number_2 : constant := 2#001#; -- the Cortex-A9 MPCore configuration contains two Cortex-A9 processors.
   CPU_Number_3 : constant := 2#010#; -- the Cortex-A9 MPCore configuration contains three Cortex-A9 processors.
   CPU_Number_4 : constant := 2#011#; -- the Cortex-A9 MPCore configuration contains four Cortex-A9 processors.

   LSPI_31 : constant := 2#11111#; -- 31 LSPIs, which are the interrupts of IDs 32-62.

   type ICDICTR_Type is record
      IT_Lines_Number : Bits_5;  -- IT_Lines_Number
      CPU_Number      : Bits_3;  -- CPU_Number
      SBZ             : Bits_2;  -- Reserved
      SecurityExtn    : Boolean; -- Returns the number of security domains that the controller contains: 1 = the controller contains two security domains. This bit always returns the value one.
      LSPI            : Bits_5;  -- Returns the number of Lockable Shared Peripheral Interrupts (LSPIs) that the controller contains.
      Reserved        : Bits_16;
   end record
      with Bit_Order => Low_Order_First,
           Size      => 32;
   for ICDICTR_Type use record
      IT_Lines_Number at 0 range  0 ..  4;
      CPU_Number      at 0 range  5 ..  7;
      SBZ             at 0 range  8 ..  9;
      SecurityExtn    at 0 range 10 .. 10;
      LSPI            at 0 range 11 .. 15;
      Reserved        at 0 range 16 .. 31;
   end record;

   -- Register (mpcore) ICDIIDR

   type ICDIIDR_Type is record
      Implementer            : Bits_12; -- Implementer Number
      Revision_Number        : Bits_12; -- Return the revision number of the controller
      Implementation_Version : Bits_8;  -- Gives implementation version number
   end record
      with Bit_Order => Low_Order_First,
           Size      => 32;
   for ICDIIDR_Type use record
      Implementer            at 0 range  0 .. 11;
      Revision_Number        at 0 range 12 .. 23;
      Implementation_Version at 0 range 24 .. 31;
   end record;

   -- Register (mpcore) ICDIPTR0
   -- Register (mpcore) ICDIPTR1
   -- Register (mpcore) ICDIPTR2
   -- Register (mpcore) ICDIPTR3
   -- Register (mpcore) ICDIPTR4
   -- Register (mpcore) ICDIPTR5
   -- Register (mpcore) ICDIPTR6
   -- Register (mpcore) ICDIPTR7
   -- Register (mpcore) ICDIPTR8
   -- Register (mpcore) ICDIPTR9
   -- Register (mpcore) ICDIPTR10
   -- Register (mpcore) ICDIPTR11
   -- Register (mpcore) ICDIPTR12
   -- Register (mpcore) ICDIPTR13
   -- Register (mpcore) ICDIPTR14
   -- Register (mpcore) ICDIPTR15
   -- Register (mpcore) ICDIPTR16
   -- Register (mpcore) ICDIPTR17
   -- Register (mpcore) ICDIPTR18
   -- Register (mpcore) ICDIPTR19
   -- Register (mpcore) ICDIPTR20
   -- Register (mpcore) ICDIPTR21
   -- Register (mpcore) ICDIPTR22
   -- Register (mpcore) ICDIPTR23

   ICDIPTR_NOCPU : constant := 2#00#; -- no CPU targeted
   ICDIPTR_CPU0  : constant := 2#01#; -- CPU 0 targeted
   ICDIPTR_CPU1  : constant := 2#10#; -- CPU 1 targeted
   ICDIPTR_CPU01 : constant := 2#11#; -- CPU 0 and CPU 1 are both targeted

   type ICDIPTR_Array_Type is array (0 .. 3) of Bits_8
      with Size                 => 32,
           Volatile_Full_Access => True,
           Pack                 => True;

   type ICDIPTR_Type is array (Natural range <>) of ICDIPTR_Array_Type
      with Pack => True;

   -- mpcore layout

   type mpcore_Type is record
      ICCICR   : ICCICR_Type            with Volatile_Full_Access => True;
      ICCPMR   : ICCPMR_Type            with Volatile_Full_Access => True;
      ICCBPR   : ICCBPR_Type            with Volatile_Full_Access => True;
      ICCIAR   : ICCIAR_Type            with Volatile_Full_Access => True;
      ICCEOIR  : ICCEOIR_Type           with Volatile_Full_Access => True;
      ICCRPR   : ICCRPR_Type            with Volatile_Full_Access => True;
      ICCHPIR  : ICCHPIR_Type           with Volatile_Full_Access => True;
      ICCABPR  : ICCABPR_Type           with Volatile_Full_Access => True;
      ICCIDR   : ICCIDR_Type            with Volatile_Full_Access => True;
      ICDDCR   : ICDDCR_Type            with Volatile_Full_Access => True;
      ICDICTR  : ICDICTR_Type           with Volatile_Full_Access => True;
      ICDIIDR  : ICDIIDR_Type           with Volatile_Full_Access => True;
      ICDISR0  : Bitmap_32              with Volatile_Full_Access => True;
      ICDISR1  : Bitmap_32              with Volatile_Full_Access => True;
      ICDISR2  : Bitmap_32              with Volatile_Full_Access => True;
      ICDISER0 : Bitmap_32              with Volatile_Full_Access => True;
      ICDISER1 : Bitmap_32              with Volatile_Full_Access => True;
      ICDISER2 : Bitmap_32              with Volatile_Full_Access => True;
      ICDICER0 : Bitmap_32              with Volatile_Full_Access => True;
      ICDICER1 : Bitmap_32              with Volatile_Full_Access => True;
      ICDICER2 : Bitmap_32              with Volatile_Full_Access => True;
      ICDISPR0 : Bitmap_32              with Volatile_Full_Access => True;
      ICDISPR1 : Bitmap_32              with Volatile_Full_Access => True;
      ICDISPR2 : Bitmap_32              with Volatile_Full_Access => True;
      ICDIPTR  : ICDIPTR_Type (0 .. 23);
   end record
      with Size  => 16#1860# * 8;
   for mpcore_Type use record
      ICCICR   at 16#0100# range 0 .. 31;
      ICCPMR   at 16#0104# range 0 .. 31;
      ICCBPR   at 16#0108# range 0 .. 31;
      ICCIAR   at 16#010C# range 0 .. 31;
      ICCEOIR  at 16#0110# range 0 .. 31;
      ICCRPR   at 16#0114# range 0 .. 31;
      ICCHPIR  at 16#0118# range 0 .. 31;
      ICCABPR  at 16#011C# range 0 .. 31;
      ICCIDR   at 16#01FC# range 0 .. 31;
      ICDDCR   at 16#1000# range 0 .. 31;
      ICDICTR  at 16#1004# range 0 .. 31;
      ICDIIDR  at 16#1008# range 0 .. 31;
      ICDISR0  at 16#1080# range 0 .. 31;
      ICDISR1  at 16#1084# range 0 .. 31;
      ICDISR2  at 16#1088# range 0 .. 31;
      ICDISER0 at 16#1100# range 0 .. 31;
      ICDISER1 at 16#1104# range 0 .. 31;
      ICDISER2 at 16#1108# range 0 .. 31;
      ICDICER0 at 16#1180# range 0 .. 31;
      ICDICER1 at 16#1184# range 0 .. 31;
      ICDICER2 at 16#1188# range 0 .. 31;
      ICDISPR0 at 16#1200# range 0 .. 31;
      ICDISPR1 at 16#1204# range 0 .. 31;
      ICDISPR2 at 16#1208# range 0 .. 31;
      ICDIPTR  at 16#1800# range 0 .. 32 * 24 - 1;
   end record;

   mpcore : aliased mpcore_Type
      with Address    => System'To_Address (mpcore_BASEADDRESS),
           Volatile   => True,
           Import     => True,
           Convention => Ada;

   ----------------------------------------------------------------------------
   -- B.28 System Level Control Registers (slcr)
   ----------------------------------------------------------------------------

   -- Register (slcr) SCL

   type SCL_Type is record
      LOCK     : Boolean := False; -- Secure configuration lock for these slcr registers: SCL, PSS_RST_CTRL, APU_CTRL, and WDT_CLK_SEL.
      Reserved : Bits_31 := 0;
   end record
      with Bit_Order => Low_Order_First,
           Size      => 32;
   for SCL_Type use record
      LOCK     at 0 range 0 ..  0;
      Reserved at 0 range 1 .. 31;
   end record;

   -- Register (slcr) SLCR_LOCK

   LOCK_KEY_VALUE : constant := 16#767B#;

   type SLCR_LOCK_Type is record
      LOCK_KEY : Unsigned_16 := 0; -- Write the lock key, 0x767B, to write protect the slcr registers
      Reserved : Bits_16     := 0;
   end record
      with Bit_Order => Low_Order_First,
           Size      => 32;
   for SLCR_LOCK_Type use record
      LOCK_KEY at 0 range  0 .. 15;
      Reserved at 0 range 16 .. 31;
   end record;

   -- Register (slcr) SLCR_UNLOCK

   UNLOCK_KEY_VALUE : constant := 16#DF0D#;

   type SLCR_UNLOCK_Type is record
      UNLOCK_KEY : Unsigned_16 := 0; -- Write the unlock key, 0xDF0D, to enable writes to the slcr registers.
      Reserved   : Bits_16     := 0;
   end record
      with Bit_Order => Low_Order_First,
           Size      => 32;
   for SLCR_UNLOCK_Type use record
      UNLOCK_KEY at 0 range  0 .. 15;
      Reserved   at 0 range 16 .. 31;
   end record;

   -- slcr layout

   type slcr_Type is record
      SCL         : SCL_Type         with Volatile_Full_Access => True;
      SLCR_LOCK   : SLCR_LOCK_Type   with Volatile_Full_Access => True;
      SLCR_UNLOCK : SLCR_UNLOCK_Type with Volatile_Full_Access => True;
   end record
      with Size => 32 * 3;
   for slcr_Type use record
      SCL         at 0 range 0 .. 31;
      SLCR_LOCK   at 4 range 0 .. 31;
      SLCR_UNLOCK at 8 range 0 .. 31;
   end record;

   slcr : aliased slcr_Type
      with Address    => System'To_Address (slcr_BASEADDRESS),
           Volatile   => True,
           Import     => True,
           Convention => Ada;

   ----------------------------------------------------------------------------
   -- B.32 Triple Timer Counter (ttc)
   ----------------------------------------------------------------------------

   -- Register (ttc) XTTCPS_CLK_CNTRL_OFFSET

   SRC_PCLK : constant := 0;
   SRC_EXT  : constant := 1;

   type XTTCPS_CLK_CNTRL_Type is record
      PS_EN    : Boolean;
      PS_VAL   : Bits_4;
      SRC      : Bits_1;
      EXT_EDGE : Boolean;
      Unused   : Bits_25 := 0;
   end record
      with Bit_Order            => Low_Order_First,
           Size                 => 32,
           Volatile_Full_Access => True;
   for XTTCPS_CLK_CNTRL_Type use record
      PS_EN    at 0 range 0 ..  0;
      PS_VAL   at 0 range 1 ..  4;
      SRC      at 0 range 5 ..  5;
      EXT_EDGE at 0 range 6 ..  6;
      Unused   at 0 range 7 .. 31;
   end record;

   -- Register (ttc) XTTCPS_CNT_CNTRL_OFFSET

   INT_OVERFLOW : constant := 0;
   INT_INTERVAL : constant := 1;

   POL_WAVE_L2H : constant := 0;
   POL_WAVE_H2L : constant := 1;

   type XTTCPS_CNT_CNTRL_Type is record
      DIS      : Boolean;
      INT      : Bits_1;
      DECR     : Boolean;
      MATCH    : Boolean;
      RST      : Boolean;
      EN_WAVE  : Boolean;
      POL_WAVE : Bits_1;
      Unused   : Bits_25 := 0;
   end record
      with Bit_Order            => Low_Order_First,
           Size                 => 32,
           Volatile_Full_Access => True;
   for XTTCPS_CNT_CNTRL_Type use record
      DIS      at 0 range 0 ..  0;
      INT      at 0 range 1 ..  1;
      DECR     at 0 range 2 ..  2;
      MATCH    at 0 range 3 ..  3;
      RST      at 0 range 4 ..  4;
      EN_WAVE  at 0 range 5 ..  5;
      POL_WAVE at 0 range 6 ..  6;
      Unused   at 0 range 7 .. 31;
   end record;

   -- Register (ttc) XTTCPS_COUNT_VALUE_OFFSET

   type XTTCPS_COUNT_VALUE_Type is record
      MASK   : Unsigned_16;
      Unused : Bits_16;
   end record
      with Bit_Order            => Low_Order_First,
           Size                 => 32,
           Volatile_Full_Access => True;
   for XTTCPS_COUNT_VALUE_Type use record
      MASK   at 0 range  0 .. 15;
      Unused at 0 range 16 .. 31;
   end record;

   -- Register (ttc) XTTCPS_INTERVAL_VAL_OFFSET

   type XTTCPS_INTERVAL_VAL_Type is record
      COUNT_VALUE : Unsigned_16;
      Unused      : Bits_16     := 0;
   end record
      with Bit_Order            => Low_Order_First,
           Size                 => 32,
           Volatile_Full_Access => True;
   for XTTCPS_INTERVAL_VAL_Type use record
      COUNT_VALUE at 0 range  0 .. 15;
      Unused      at 0 range 16 .. 31;
   end record;

   -- Register (ttc) XTTCPS_MATCH_0_OFFSET
   -- Register (ttc) XTTCPS_MATCH_1_OFFSET
   -- Register (ttc) XTTCPS_MATCH_2_OFFSET

   type XTTCPS_MATCH_Type is record
      MATCH  : Unsigned_16;
      Unused : Bits_16     := 0;
   end record
      with Bit_Order            => Low_Order_First,
           Size                 => 32,
           Volatile_Full_Access => True;
   for XTTCPS_MATCH_Type use record
      MATCH  at 0 range  0 .. 15;
      Unused at 0 range 16 .. 31;
   end record;

   -- Register (ttc) XTTCPS_ISR_OFFSET

   type XTTCPS_ISR_Type is record
      IXR_INTERVAL : Boolean;
      IXR_MATCH_0  : Boolean;
      IXR_MATCH_1  : Boolean;
      IXR_MATCH_2  : Boolean;
      IXR_CNT_OVR  : Boolean;
      Ev           : Boolean;
      Unused       : Bits_26;
   end record
      with Bit_Order            => Low_Order_First,
           Size                 => 32,
           Volatile_Full_Access => True;
   for XTTCPS_ISR_Type use record
      IXR_INTERVAL at 0 range 0 ..  0;
      IXR_MATCH_0  at 0 range 1 ..  1;
      IXR_MATCH_1  at 0 range 2 ..  2;
      IXR_MATCH_2  at 0 range 3 ..  3;
      IXR_CNT_OVR  at 0 range 4 ..  4;
      Ev           at 0 range 5 ..  5;
      Unused       at 0 range 6 .. 31;
   end record;

   -- Register (ttc) XTTCPS_IER_OFFSET

   type XTTCPS_IER_Type is record
      IXR_INTERVAL_IEN : Boolean;
      IXR_MATCH_0_IEN  : Boolean;
      IXR_MATCH_1_IEN  : Boolean;
      IXR_MATCH_2_IEN  : Boolean;
      IXR_CNT_OVR_IEN  : Boolean;
      Ev_IEN           : Boolean;
      Unused           : Bits_26 := 0;
   end record
      with Bit_Order            => Low_Order_First,
           Size                 => 32,
           Volatile_Full_Access => True;
   for XTTCPS_IER_Type use record
      IXR_INTERVAL_IEN at 0 range 0 ..  0;
      IXR_MATCH_0_IEN  at 0 range 1 ..  1;
      IXR_MATCH_1_IEN  at 0 range 2 ..  2;
      IXR_MATCH_2_IEN  at 0 range 3 ..  3;
      IXR_CNT_OVR_IEN  at 0 range 4 ..  4;
      Ev_IEN           at 0 range 5 ..  5;
      Unused           at 0 range 6 .. 31;
   end record;

   -- Register (ttc) Event_Control_Timer_1
   -- Register (ttc) Event_Control_Timer_2
   -- Register (ttc) Event_Control_Timer_3

   type Event_Control_Timer_Type is record
      E_En   : Boolean;
      E_Lo   : Boolean;
      E_Ov   : Boolean;
      Unused : Bits_29 := 0;
   end record
      with Bit_Order            => Low_Order_First,
           Size                 => 32,
           Volatile_Full_Access => True;
   for Event_Control_Timer_Type use record
      E_En   at 0 range 0 ..  0;
      E_Lo   at 0 range 1 ..  1;
      E_Ov   at 0 range 2 ..  2;
      Unused at 0 range 3 .. 31;
   end record;

   -- Register (ttc) Event_Register_1
   -- Register (ttc) Event_Register_2
   -- Register (ttc) Event_Register_3

   type Event_Register_Type is record
      Event  : Unsigned_16;
      Unused : Bits_16;
   end record
      with Bit_Order            => Low_Order_First,
           Size                 => 32,
           Volatile_Full_Access => True;
   for Event_Register_Type use record
      Event  at 0 range  0 .. 15;
      Unused at 0 range 16 .. 31;
   end record;

   -- ttc layout

   type CLK_CNTRL_Array_Type           is array (0 .. 2) of XTTCPS_CLK_CNTRL_Type    with Pack => True;
   type CNT_CNTRL_Array_Type           is array (0 .. 2) of XTTCPS_CNT_CNTRL_Type    with Pack => True;
   type COUNT_VALUE_Array_Type         is array (0 .. 2) of XTTCPS_COUNT_VALUE_Type  with Pack => True;
   type INTERVAL_VAL_Array_Type        is array (0 .. 2) of XTTCPS_INTERVAL_VAL_Type with Pack => True;
   type MATCH_1_Array_Type             is array (0 .. 2) of XTTCPS_MATCH_Type        with Pack => True;
   type MATCH_2_Array_Type             is array (0 .. 2) of XTTCPS_MATCH_Type        with Pack => True;
   type MATCH_3_Array_Type             is array (0 .. 2) of XTTCPS_MATCH_Type        with Pack => True;
   type ISR_Array_Type                 is array (0 .. 2) of XTTCPS_ISR_Type          with Pack => True;
   type IER_Array_Type                 is array (0 .. 2) of XTTCPS_IER_Type          with Pack => True;
   type Event_Control_Timer_Array_Type is array (0 .. 2) of Event_Control_Timer_Type with Pack => True;
   type Event_Register_Array_Type      is array (0 .. 2) of Event_Register_Type      with Pack => True;

   type ttc_Type is record
      CLK_CNTRL           : CLK_CNTRL_Array_Type;
      CNT_CNTRL           : CNT_CNTRL_Array_Type;
      COUNT_VALUE         : COUNT_VALUE_Array_Type;
      INTERVAL_VAL        : INTERVAL_VAL_Array_Type;
      MATCH_1             : MATCH_1_Array_Type;
      MATCH_2             : MATCH_2_Array_Type;
      MATCH_3             : MATCH_3_Array_Type;
      ISR                 : ISR_Array_Type;
      IER                 : IER_Array_Type;
      Event_Control_Timer : Event_Control_Timer_Array_Type;
      Event_Register      : Event_Register_Array_Type;
   end record
      with Size => 16#84# * 8;
   for ttc_Type use record
      CLK_CNTRL           at 16#00# range 0 .. 32 * 3 - 1;
      CNT_CNTRL           at 16#0C# range 0 .. 32 * 3 - 1;
      COUNT_VALUE         at 16#18# range 0 .. 32 * 3 - 1;
      INTERVAL_VAL        at 16#24# range 0 .. 32 * 3 - 1;
      MATCH_1             at 16#30# range 0 .. 32 * 3 - 1;
      MATCH_2             at 16#3C# range 0 .. 32 * 3 - 1;
      MATCH_3             at 16#48# range 0 .. 32 * 3 - 1;
      ISR                 at 16#54# range 0 .. 32 * 3 - 1;
      IER                 at 16#60# range 0 .. 32 * 3 - 1;
      Event_Control_Timer at 16#6C# range 0 .. 32 * 3 - 1;
      Event_Register      at 16#78# range 0 .. 32 * 3 - 1;
   end record;

   ttc0 : aliased ttc_Type
      with Address    => System'To_Address (ttc0_BASEADDRESS),
           Volatile   => True,
           Import     => True,
           Convention => Ada;

   ttc1 : aliased ttc_Type
      with Address    => System'To_Address (ttc1_BASEADDRESS),
           Volatile   => True,
           Import     => True,
           Convention => Ada;

   ----------------------------------------------------------------------------
   -- B.33 UART Controller (UART)
   ----------------------------------------------------------------------------

   -- Register (UART) XUARTPS_CR_OFFSET

   type XUARTPS_CR_Type is record
      RXRST    : Boolean := False; -- Software reset for Rx data path: 0: no affect 1: receiver logic is reset and all pending receiver data is discarded.
      TXRST    : Boolean := False; -- Software reset for Tx data path: 0: no affect 1: transmitter logic is reset and all pending transmitter data is discarded
      RX_EN    : Boolean := False; -- Receive enable: 0: disable 1: enable
      RX_DIS   : Boolean := True;  -- Receive disable: 0: enable 1: disable, regardless of the value of RXEN
      TX_EN    : Boolean := False; -- Transmit enable: 0: disable transmitter 1: enable transmitter, provided the TXDIS field is set to 0.
      TX_DIS   : Boolean := True;  -- Transmit disable: 0: enable transmitter 1: disable transmitter
      TORST    : Boolean := False; -- Restart receiver timeout counter: 1: receiver timeout counter is restarted.
      STARTBRK : Boolean := False; -- Start transmitter break: 0: no affect 1: start to transmit a break after the characters currently present in the FIFO and the transmit shift register have been transmitted.
      STOPBRK  : Boolean := True;  -- Stop transmitter break: 0: no affect 1: stop transmission of the break after a minimum of one character length and transmit a high level during 12 bit periods.
      Reserved : Bits_23 := 0;
   end record
      with Bit_Order => Low_Order_First,
           Size      => 32;
   for XUARTPS_CR_Type use record
      RXRST    at 0 range 0 ..  0;
      TXRST    at 0 range 1 ..  1;
      RX_EN    at 0 range 2 ..  2;
      RX_DIS   at 0 range 3 ..  3;
      TX_EN    at 0 range 4 ..  4;
      TX_DIS   at 0 range 5 ..  5;
      TORST    at 0 range 6 ..  6;
      STARTBRK at 0 range 7 ..  7;
      STOPBRK  at 0 range 8 ..  8;
      Reserved at 0 range 9 .. 31;
   end record;

   -- Register (UART) XUARTPS_MR_OFFSET

   CLKSEL_REFCLK     : constant := 0; -- clock source is uart_ref_clk
   CLKSEL_REFCLKDIV8 : constant := 1; -- clock source is uart_ref_clk/8

   CHRL_8   : constant := 2#00#; -- 8 bits
   CHRL_7   : constant := 2#10#; -- 7 bits
   CHRL_6   : constant := 2#11#; -- 6 bits

   PAR_EVEN     : constant := 2#000#; -- even parity
   PAR_ODD      : constant := 2#001#; -- odd parity
   PAR_SPACE    : constant := 2#010#; -- forced to 0 parity (space)
   PAR_MARK     : constant := 2#011#; -- forced to 1 parity (mark)
   PAR_NOPARITY : constant := 2#100#; -- no parity

   NBSTOP_1  : constant := 2#00#; -- 1 stop bit
   NBSTOP_15 : constant := 2#01#; -- 1.5 stop bits
   NBSTOP_2  : constant := 2#10#; -- 2 stop bits

   CHMODE_NORMAL          : constant := 2#00#; -- normal
   CHMODE_AUTOECHO        : constant := 2#01#; -- automatic echo
   CHMODE_LOOPBACK_LOCAL  : constant := 2#10#; -- local loopback
   CHMODE_LOOPBACK_REMOTE : constant := 2#11#; -- remote loopback

   type XUARTPS_MR_Type is record
      CLKSEL    : Bits_1  := CLKSEL_REFCLK; -- Clock source select: This field defines whether a pre-scalar of 8 is applied to the baud rate generator input clock.
      CHRL      : Bits_2  := CHRL_8;        -- Character length select: Defines the number of bits in each character.
      PAR       : Bits_3  := PAR_EVEN;      -- Parity type select: Defines the expected parity to check on receive and the parity to generate on transmit.
      NBSTOP    : Bits_2  := NBSTOP_1;      -- Number of stop bits: Defines the number of stop bits to detect on receive and to generate on transmit.
      CHMODE    : Bits_2  := CHMODE_NORMAL; -- Channel mode: Defines the mode of operation of the UART.
      Reserved1 : Bits_1  := 0;
      Reserved2 : Bits_1  := 0;
      Reserved3 : Bits_20 := 0;
   end record
      with Bit_Order => Low_Order_First,
           Size      => 32;
   for XUARTPS_MR_Type use record
      CLKSEL    at 0 range  0 ..  0;
      CHRL      at 0 range  1 ..  2;
      PAR       at 0 range  3 ..  5;
      NBSTOP    at 0 range  6 ..  7;
      CHMODE    at 0 range  8 ..  9;
      Reserved1 at 0 range 10 .. 10;
      Reserved2 at 0 range 11 .. 11;
      Reserved3 at 0 range 12 .. 31;
   end record;

   -- Register (UART) XUARTPS_IER_OFFSET
   -- Register (UART) XUARTPS_IDR_OFFSET
   -- Register (UART) XUARTPS_IMR_OFFSET
   -- Register (UART) XUARTPS_ISR_OFFSET

   type XUARTPS_IEDMSR_Type is record
      IXR_RXOVR   : Boolean := False; -- Receiver FIFO Trigger interrupt
      IXR_RXEMPTY : Boolean := False; -- Receiver FIFO Empty interrupt
      IXR_RXFULL  : Boolean := False; -- Receiver FIFO Full interrupt
      IXR_TXEMPTY : Boolean := False; -- Transmitter FIFO Empty interrupt
      IXR_TXFULL  : Boolean := False; -- Transmitter FIFO Full interrupt
      IXR_OVER    : Boolean := False; -- Receiver Overflow Error interrupt
      IXR_FRAMING : Boolean := False; -- Receiver Framing Error interrupt
      IXR_PARITY  : Boolean := False; -- Receiver Parity Error interrupt
      IXR_TOUT    : Boolean := False; -- Receiver Timeout Error interrupt
      IXR_DMS     : Boolean := False; -- Delta Modem Status Indicator interrupt
      TTRIG       : Boolean := False; -- Transmitter FIFO Trigger interrupt
      TNFUL       : Boolean := False; -- Transmitter FIFO Nearly Full interrupt
      TOVR        : Boolean := False; -- Transmitter FIFO Overflow interrupt
      Reserved    : Bits_19 := 0;
   end record
      with Bit_Order => Low_Order_First,
           Size      => 32;
   for XUARTPS_IEDMSR_Type use record
      IXR_RXOVR   at 0 range  0 ..  0;
      IXR_RXEMPTY at 0 range  1 ..  1;
      IXR_RXFULL  at 0 range  2 ..  2;
      IXR_TXEMPTY at 0 range  3 ..  3;
      IXR_TXFULL  at 0 range  4 ..  4;
      IXR_OVER    at 0 range  5 ..  5;
      IXR_FRAMING at 0 range  6 ..  6;
      IXR_PARITY  at 0 range  7 ..  7;
      IXR_TOUT    at 0 range  8 ..  8;
      IXR_DMS     at 0 range  9 ..  9;
      TTRIG       at 0 range 10 .. 10;
      TNFUL       at 0 range 11 .. 11;
      TOVR        at 0 range 12 .. 12;
      Reserved    at 0 range 13 .. 31;
   end record;

   -- Register (UART) XUARTPS_BAUDGEN_OFFSET

   CD_DISABLE : constant := 0; -- Disables baud_sample
   CD_BYPASS  : constant := 1; -- Clock divisor bypass (baud_sample = sel_clk)

   type XUARTPS_BAUDGEN_Type is record
      CD       : Unsigned_16 := 16#28B#; -- Baud Rate Clock Divisor Value
      Reserved : Bits_16     := 0;
   end record
      with Bit_Order => Low_Order_First,
           Size      => 32;
   for XUARTPS_BAUDGEN_Type use record
      CD       at 0 range  0 .. 15;
      Reserved at 0 range 16 .. 31;
   end record;

   -- Register (UART) XUARTPS_RXTOUT_OFFSET

   RTO_DISABLE : constant := 0; -- Disables receiver timeout counter

   type XUARTPS_RXTOUT_Type is record
      RTO      : Unsigned_8 := RTO_DISABLE; -- Receiver timeout value
      Reserved : Bits_24    := 0;
   end record
      with Bit_Order => Low_Order_First,
           Size      => 32;
   for XUARTPS_RXTOUT_Type use record
      RTO      at 0 range 0 ..  7;
      Reserved at 0 range 8 .. 31;
   end record;

   -- Register (UART) XUARTPS_RXWM_OFFSET

   RTRIG_DISABLE : constant := 0; -- Disables receiver FIFO trigger level function

   type XUARTPS_RXWM_Type is record
      RTRIG    : Bits_6  := 16#20#; -- Receiver FIFO trigger level value
      Reserved : Bits_26 := 0;
   end record
      with Bit_Order => Low_Order_First,
           Size      => 32;
   for XUARTPS_RXWM_Type use record
      RTRIG    at 0 range 0 ..  5;
      Reserved at 0 range 6 .. 31;
   end record;

   -- Register (UART) XUARTPS_MODEMCR_OFFSET

   type XUARTPS_MODEMCR_Type is record
      DTR       : Boolean := False; -- Data Terminal Ready
      RTS       : Boolean := False; -- Request to send output control
      Reserved1 : Bits_3  := 0;
      FCM       : Boolean := False; -- Automatic flow control mode
      Reserved2 : Bits_26 := 0;
   end record
      with Bit_Order => Low_Order_First,
           Size      => 32;
   for XUARTPS_MODEMCR_Type use record
      DTR       at 0 range 0 ..  0;
      RTS       at 0 range 1 ..  1;
      Reserved1 at 0 range 2 ..  4;
      FCM       at 0 range 5 ..  5;
      Reserved2 at 0 range 6 .. 31;
   end record;

   -- Register (UART) XUARTPS_MODEMSR_OFFSET

   type XUARTPS_MODEMSR_Type is record
      MEDEMSR_CTSX : Boolean := False; -- Delta Clear To Send status
      MEDEMSR_DSRX : Boolean := False; -- Delta Data Set Ready status
      MEDEMSR_RIX  : Boolean := False; -- Trailing Edge Ring Indicator status
      MEDEMSR_DCDX : Boolean := False; -- Delta Data Carrier Detect status
      CTS          : Boolean := False; -- Clear to Send (CTS) input signal from PL (EMIOUARTxCTSN) status
      DSR          : Boolean := False; -- Data Set Ready (DSR) input signal from PL (EMIOUARTxDSRN) status
      RI           : Boolean := False; -- Ring Indicator (RI) input signal from PL (EMIOUARTxRIN) status
      DCD          : Boolean := False; -- Data Carrier Detect (DCD) input signal from PL(EMIOUARTxDCDN) status
      FCMS         : Boolean := False; -- Flow Control Mode
      Reserved     : Bits_23 := 0;
   end record
      with Bit_Order => Low_Order_First,
           Size      => 32;
   for XUARTPS_MODEMSR_Type use record
      MEDEMSR_CTSX at 0 range 0 ..  0;
      MEDEMSR_DSRX at 0 range 1 ..  1;
      MEDEMSR_RIX  at 0 range 2 ..  2;
      MEDEMSR_DCDX at 0 range 3 ..  3;
      CTS          at 0 range 4 ..  4;
      DSR          at 0 range 5 ..  5;
      RI           at 0 range 6 ..  6;
      DCD          at 0 range 7 ..  7;
      FCMS         at 0 range 8 ..  8;
      Reserved     at 0 range 9 .. 31;
   end record;

   -- Register (UART) XUARTPS_SR_OFFSET

   type XUARTPS_SR_Type is record
      RXOVR     : Boolean; -- Receiver FIFO Trigger continuous status
      RXEMPTY   : Boolean; -- Receiver FIFO Full continuous status
      RXFULL    : Boolean; -- Receiver FIFO Full continuous status
      TXEMPTY   : Boolean; -- Transmitter FIFO Empty continuous status
      TXFULL    : Boolean; -- Transmitter FIFO Full continuous status
      Reserved1 : Bits_1;
      Reserved2 : Bits_1;
      Reserved3 : Bits_1;
      Reserved4 : Bits_1;
      Reserved5 : Bits_1;
      RACTIVE   : Boolean; -- Receiver state machine active status
      TACTIVE   : Boolean; -- Transmitter state machine active status
      FLOWDEL   : Boolean; -- Receiver flow delay trigger continuous status
      TTRIG     : Boolean; -- Transmitter FIFO Trigger continuous status
      TNFUL     : Boolean; -- Transmitter FIFO Nearly Full continuous status
      Reserved6 : Bits_17;
   end record
      with Bit_Order => Low_Order_First,
           Size      => 32;
   for XUARTPS_SR_Type use record
      RXOVR     at 0 range  0 ..  0;
      RXEMPTY   at 0 range  1 ..  1;
      RXFULL    at 0 range  2 ..  2;
      TXEMPTY   at 0 range  3 ..  3;
      TXFULL    at 0 range  4 ..  4;
      Reserved1 at 0 range  5 ..  5;
      Reserved2 at 0 range  6 ..  6;
      Reserved3 at 0 range  7 ..  7;
      Reserved4 at 0 range  8 ..  8;
      Reserved5 at 0 range  9 ..  9;
      RACTIVE   at 0 range 10 .. 10;
      TACTIVE   at 0 range 11 .. 11;
      FLOWDEL   at 0 range 12 .. 12;
      TTRIG     at 0 range 13 .. 13;
      TNFUL     at 0 range 14 .. 14;
      Reserved6 at 0 range 15 .. 31;
   end record;

   -- Register (UART) XUARTPS_FIFO_OFFSET

   type XUARTPS_FIFO_Type is record
      FIFO     : Unsigned_8;
      Reserved : Bits_24    := 0;
   end record
      with Bit_Order => Low_Order_First,
           Size      => 32;
   for XUARTPS_FIFO_Type use record
      FIFO     at 0 range 0 ..  7;
      Reserved at 0 range 8 .. 31;
   end record;

   -- Register (UART) Baud_rate_divider_reg0

   BDIV_IGNORED   : constant := 0;
   BDIV_IGNORED_1 : constant := 1;
   BDIV_IGNORED_2 : constant := 2;
   BDIV_IGNORED_3 : constant := 3;

   type Baud_rate_divider_reg0_Type is record
      BDIV     : Unsigned_8 := 16#F#; -- Baud rate divider value
      Reserved : Bits_24    := 0;
   end record
      with Bit_Order => Low_Order_First,
           Size      => 32;
   for Baud_rate_divider_reg0_Type use record
      BDIV     at 0 range 0 ..  7;
      Reserved at 0 range 8 .. 31;
   end record;

   -- Register (UART) Flow_delay_reg0

   FDEL_DISABLE   : constant := 0;
   FDEL_DISABLE_1 : constant := 1;
   FDEL_DISABLE_2 : constant := 2;
   FDEL_DISABLE_3 : constant := 3;

   type Flow_delay_reg0_Type is record
      FDEL     : Bits_6  := 0; -- RxFIFO trigger level for Ready To Send (RTS) output signal (EMIOUARTxRTSN) de-assertion
      Reserved : Bits_26 := 0;
   end record
      with Bit_Order => Low_Order_First,
           Size      => 32;
   for Flow_delay_reg0_Type use record
      FDEL     at 0 range 0 ..  5;
      Reserved at 0 range 6 .. 31;
   end record;

   -- Register (UART) Tx_FIFO_trigger_level0

   TTRIG_DISABLE : constant := 0; -- Disables transmitter FIFO trigger level function

   type Tx_FIFO_trigger_level0_Type is record
      TTRIG    : Bits_6  := 16#20#; -- Transmitter FIFO trigger level
      Reserved : Bits_26 := 0;
   end record
      with Bit_Order => Low_Order_First,
           Size      => 32;
   for Tx_FIFO_trigger_level0_Type use record
      TTRIG    at 0 range 0 ..  5;
      Reserved at 0 range 6 .. 31;
   end record;

   -- UART layout

   type UART_Type is record
      CR      : XUARTPS_CR_Type             with Volatile_Full_Access => True;
      MR      : XUARTPS_MR_Type             with Volatile_Full_Access => True;
      IER     : XUARTPS_IEDMSR_Type         with Volatile_Full_Access => True;
      IDR     : XUARTPS_IEDMSR_Type         with Volatile_Full_Access => True;
      IMR     : XUARTPS_IEDMSR_Type         with Volatile_Full_Access => True;
      ISR     : XUARTPS_IEDMSR_Type         with Volatile_Full_Access => True;
      BAUDGEN : XUARTPS_BAUDGEN_Type        with Volatile_Full_Access => True;
      RXTOUT  : XUARTPS_RXTOUT_Type         with Volatile_Full_Access => True;
      RXWM    : XUARTPS_RXWM_Type           with Volatile_Full_Access => True;
      MODEMCR : XUARTPS_MODEMCR_Type        with Volatile_Full_Access => True;
      MODEMSR : XUARTPS_MODEMSR_Type        with Volatile_Full_Access => True;
      SR      : XUARTPS_SR_Type             with Volatile_Full_Access => True;
      FIFO    : XUARTPS_FIFO_Type           with Volatile_Full_Access => True;
      BRDR0   : Baud_rate_divider_reg0_Type with Volatile_Full_Access => True;
      FDR0    : Flow_delay_reg0_Type        with Volatile_Full_Access => True;
      TXFTL0  : Tx_FIFO_trigger_level0_Type with Volatile_Full_Access => True;
   end record
      with Alignment => 4;
   for UART_Type use record
      CR      at 16#00# range 0 .. 31;
      MR      at 16#04# range 0 .. 31;
      IER     at 16#08# range 0 .. 31;
      IDR     at 16#0C# range 0 .. 31;
      IMR     at 16#10# range 0 .. 31;
      ISR     at 16#14# range 0 .. 31;
      BAUDGEN at 16#18# range 0 .. 31;
      RXTOUT  at 16#1C# range 0 .. 31;
      RXWM    at 16#20# range 0 .. 31;
      MODEMCR at 16#24# range 0 .. 31;
      MODEMSR at 16#28# range 0 .. 31;
      SR      at 16#2C# range 0 .. 31;
      FIFO    at 16#30# range 0 .. 31;
      BRDR0   at 16#34# range 0 .. 31;
      FDR0    at 16#38# range 0 .. 31;
      TXFTL0  at 16#44# range 0 .. 31;
   end record;

   uart0 : aliased UART_Type
      with Address    => System'To_Address (uart0_BASEADDRESS),
           Volatile   => True,
           Import     => True,
           Convention => Ada;

   uart1 : aliased UART_Type
      with Address    => System'To_Address (uart1_BASEADDRESS),
           Volatile   => True,
           Import     => True,
           Convention => Ada;

   procedure UART_TX
      (Data : in Unsigned_8);
   procedure UART_RX
      (Data : out Unsigned_8);
   procedure UART_Init;

pragma Style_Checks (On);

end ZynqA9;

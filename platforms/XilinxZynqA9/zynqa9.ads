-----------------------------------------------------------------------------------------------------------------------
--                                                     SweetAda                                                      --
-----------------------------------------------------------------------------------------------------------------------
-- __HDS__                                                                                                           --
-- __FLN__ zynqa9.ads                                                                                                --
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
with System.Storage_Elements;
with Interfaces;
with Bits;

package ZynqA9 is

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
   -- Interrupt Controller CPU (ICC)
   ----------------------------------------------------------------------------

   -- ICCICR

   type ICCICR_Type is
   record
      EnableS  : Boolean;      -- Global enable for the signaling of Secure interrupts by the CPU interfaces to the ...
      EnableNS : Boolean;      -- An alias of the Enable bit in the Non-secure ICCICR.
      AckCtl   : Boolean;      -- Controls whether a Secure read of the ICCIAR, when the highest priority pending ...
      FIQEn    : Boolean;      -- Controls whether the GIC signals Secure interrupts to a target processor using the FIQ or ...
      SBPR     : Boolean;      -- Controls whether the CPU interface uses the Secure or Non-secure Binary Point Register ...
      Reserved : Bits_27 := 0;
   end record with
      Bit_Order => Low_Order_First,
      Size      => 32;
   for ICCICR_Type use
   record
      EnableS  at 0 range 0 .. 0;
      EnableNS at 0 range 1 .. 1;
      AckCtl   at 0 range 2 .. 2;
      FIQEn    at 0 range 3 .. 3;
      SBPR     at 0 range 4 .. 4;
      Reserved at 0 range 5 .. 31;
   end record;

   -- ICCPMR

   type ICCPMR_Type is
   record
      Priority : Unsigned_8;   -- The priority mask level for the CPU interface.
      Reserved : Bits_24 := 0;
   end record with
      Bit_Order => Low_Order_First,
      Size      => 32;
   for ICCPMR_Type use
   record
      Priority at 0 range 0 .. 7;
      Reserved at 0 range 8 .. 31;
   end record;

   -- ICCBPR

   type ICCBPR_Type is
   record
      Binary_point : Bits_3;       -- The value of this field controls the 8-bit interrupt priority field ...
      Reserved     : Bits_29 := 0;
   end record with
      Bit_Order => Low_Order_First,
      Size      => 32;
   for ICCBPR_Type use
   record
      Binary_point at 0 range 0 .. 2;
      Reserved     at 0 range 3 .. 31;
   end record;

   -- ICCAR

   type ICCAR_Type is
   record
      ACKINTID : Bits_10;      -- Identifies the processor that requested the interrupt.
      CPUID    : Bits_3;       -- The interrupt ID.
      Reserved : Bits_19 := 0;
   end record with
      Bit_Order => Low_Order_First,
      Size      => 32;
   for ICCAR_Type use
   record
      ACKINTID at 0 range 0 .. 9;
      CPUID    at 0 range 10 .. 12;
      Reserved at 0 range 13 .. 31;
   end record;

   -- ICCEOIR

   type ICCEOIR_Type is
   record
      EOIINTID : Bits_10;      -- The ACKINTID value from the corresponding ICCIAR access.
      CPUID    : Bits_3;       -- On completion of the processing of an SGI, this field contains the CPUID value from ...
      Reserved : Bits_19 := 0;
   end record with
      Bit_Order => Low_Order_First,
      Size      => 32;
   for ICCEOIR_Type use
   record
      EOIINTID at 0 range 0 .. 9;
      CPUID    at 0 range 10 .. 12;
      Reserved at 0 range 13 .. 31;
   end record;

   -- ICCRPR

   type ICCRPR_Type is
   record
      Priority : Unsigned_8;   -- The priority value of the highest priority interrupt that is active on the CPU interface.
      Reserved : Bits_24 := 0;
   end record with
      Bit_Order => Low_Order_First,
      Size      => 32;
   for ICCRPR_Type use
   record
      Priority at 0 range 0 .. 7;
      Reserved at 0 range 8 .. 31;
   end record;

   -- ICCHPIR

   type ICCHPIR_Type is
   record
      PENDINTID : Bits_10;      -- The interrupt ID of the highest priority pending interrupt.
      CPUID     : Bits_3;       -- If the PENDINTID field returns the ID of an SGI, this field contains the CPUID value ...
      Reserved  : Bits_19 := 0;
   end record with
      Bit_Order => Low_Order_First,
      Size      => 32;
   for ICCHPIR_Type use
   record
      PENDINTID at 0 range 0 .. 9;
      CPUID     at 0 range 10 .. 12;
      Reserved  at 0 range 13 .. 31;
   end record;

   -- ICCABPR

   type ICCABPR_Type is
   record
      Binary_point : Bits_3;       -- Provides an alias of the Non-secure ICCBPR.
      Reserved     : Bits_29 := 0;
   end record with
      Bit_Order => Low_Order_First,
      Size      => 32;
   for ICCABPR_Type use
   record
      Binary_point at 0 range 0 .. 2;
      Reserved     at 0 range 3 .. 31;
   end record;

   -- ICCIDR

   type ICCIDR_Type is
   record
      Implementer          : Bits_12; -- Returns the JEP106 code of the company that implemented the Cortex-A9 processor ...
      Revision_number      : Bits_4;  -- Returns the revision number of the Interrupt Controller.
      Architecture_version : Bits_4;  -- Identifies the architecture version
      Part_number          : Bits_12; -- Identifies the peripheral
   end record with
      Bit_Order => Low_Order_First,
      Size      => 32;
   for ICCIDR_Type use
   record
      Implementer          at 0 range 0 .. 11;
      Revision_number      at 0 range 12 .. 15;
      Architecture_version at 0 range 16 .. 19;
      Part_number          at 0 range 20 .. 31;
   end record;

   ----------------------------------------------------------------------------
   -- Interrupt Controller Distributor (ICD)
   ----------------------------------------------------------------------------

   -- ICDDCR

   type ICDDCR_Type is
   record
      Enable_secure     : Boolean;
      Enable_Non_secure : Boolean;
      Reserved          : Bits_30 := 0;
   end record with
      Bit_Order => Low_Order_First,
      Size      => 32;
   for ICDDCR_Type use
   record
      Enable_secure     at 0 range 0 .. 0;
      Enable_Non_secure at 0 range 1 .. 1;
      Reserved          at 0 range 2 .. 31;
   end record;

   -- ICDICTR

   type ICDICTR_Type is
   record
      IT_Lines_Number : Bits_5;  -- the distributor provides ...
      CPU_Number      : Bits_3;  -- the Cortex-A9 MPCore configuration contains ...
      SBZ             : Bits_2;  -- Reserved
      SecurityExtn    : Boolean; -- Returns the number of security domains that the controller contains
      LSPI            : Bits_5;  -- Returns the number of Lockable Shared Peripheral Interrupts (LSPIs) that ...
      Reserved        : Bits_16;
   end record with
      Bit_Order => Low_Order_First,
      Size      => 32;
   for ICDICTR_Type use
   record
      IT_Lines_Number at 0 range 0 .. 4;
      CPU_Number      at 0 range 5 .. 7;
      SBZ             at 0 range 8 .. 9;
      SecurityExtn    at 0 range 10 .. 10;
      LSPI            at 0 range 11 .. 15;
      Reserved        at 0 range 16 .. 31;
   end record;

   -- ICDIIDR

   type ICDIIDR_Type is
   record
      Implementer            : Bits_12; -- Implementer Number
      Revision_Number        : Bits_12; -- Return the revision number of the controller
      Implementation_Version : Bits_8;  -- Gives implementation version number
   end record with
      Bit_Order => Low_Order_First,
      Size      => 32;
   for ICDIIDR_Type use
   record
      Implementer            at 0 range 0 .. 11;
      Revision_Number        at 0 range 12 .. 23;
      Implementation_Version at 0 range 24 .. 31;
   end record;

   -- Interrupt Processor Targets Register

   ICDIPTR_NOCPU : constant := 2#00#; -- no CPU targeted
   ICDIPTR_CPU0  : constant := 2#01#; -- CPU 0 targeted
   ICDIPTR_CPU1  : constant := 2#10#; -- CPU 1 targeted
   ICDIPTR_CPU01 : constant := 2#11#; -- CPU 0 and CPU 1 are both targeted

   type ICDIPTR_Array_Type is array (0 .. 3) of Bits_8 with
      Size                 => 32,
      Volatile_Full_Access => True,
      Pack                 => True;

   type ICDIPTR_Type is array (Natural range <>) of ICDIPTR_Array_Type with
      Pack => True;

   -- APU layout

   type APU_Type is
   record
      ICCICR   : ICCICR_Type            with Volatile_Full_Access => True;
      ICCPMR   : ICCPMR_Type            with Volatile_Full_Access => True;
      ICCBPR   : ICCBPR_Type            with Volatile_Full_Access => True;
      ICCAR    : ICCAR_Type             with Volatile_Full_Access => True;
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
   end record with
      Size  => 16#1860# * 8;
   for APU_Type use
   record
      ICCICR   at 16#0100# range 0 .. 31;
      ICCPMR   at 16#0104# range 0 .. 31;
      ICCBPR   at 16#0108# range 0 .. 31;
      ICCAR    at 16#010C# range 0 .. 31;
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

   APU_BASEADDRESS : constant := 16#F8F0_0000#;

   APU : aliased APU_Type with
      Address    => To_Address (APU_BASEADDRESS),
      Volatile   => True,
      Import     => True,
      Convention => Ada;

   ----------------------------------------------------------------------------
   -- B.28 System Level Control Registers (slcr)
   ----------------------------------------------------------------------------

   ----------------------------------------------------------------------------
   -- B.32 Triple Timer Counter (ttc)
   ----------------------------------------------------------------------------

   -- XTTCPS_CLK_CNTRL_OFFSET

   SRC_PCLK : constant := 0;
   SRC_EXT  : constant := 1;

   type XTTCPS_CLK_CNTRL_Type is
   record
      PS_EN    : Boolean;
      PS_VAL   : Bits_4;
      SRC      : Bits_1;
      EXT_EDGE : Boolean;
      Unused   : Bits_25 := 0;
   end record with
      Bit_Order            => Low_Order_First,
      Size                 => 32,
      Volatile_Full_Access => True;
   for XTTCPS_CLK_CNTRL_Type use
   record
      PS_EN    at 0 range 0 .. 0;
      PS_VAL   at 0 range 1 .. 4;
      SRC      at 0 range 5 .. 5;
      EXT_EDGE at 0 range 6 .. 6;
      Unused   at 0 range 7 .. 31;
   end record;

   -- XTTCPS_CNT_CNTRL_OFFSET

   INT_OVERFLOW : constant := 0;
   INT_INTERVAL : constant := 1;

   POL_WAVE_L2H : constant := 0;
   POL_WAVE_H2L : constant := 1;

   type XTTCPS_CNT_CNTRL_Type is
   record
      DIS      : Boolean;
      INT      : Bits_1;
      DECR     : Boolean;
      MATCH    : Boolean;
      RST      : Boolean;
      EN_WAVE  : Boolean;
      POL_WAVE : Bits_1;
      Unused   : Bits_25 := 0;
   end record with
      Bit_Order            => Low_Order_First,
      Size                 => 32,
      Volatile_Full_Access => True;
   for XTTCPS_CNT_CNTRL_Type use
   record
      DIS      at 0 range 0 .. 0;
      INT      at 0 range 1 .. 1;
      DECR     at 0 range 2 .. 2;
      MATCH    at 0 range 3 .. 3;
      RST      at 0 range 4 .. 4;
      EN_WAVE  at 0 range 5 .. 5;
      POL_WAVE at 0 range 6 .. 6;
      Unused   at 0 range 7 .. 31;
   end record;

   -- XTTCPS_COUNT_VALUE_OFFSET

   type XTTCPS_COUNT_VALUE_Type is
   record
      MASK   : Unsigned_16;
      Unused : Bits_16;
   end record with
      Bit_Order            => Low_Order_First,
      Size                 => 32,
      Volatile_Full_Access => True;
   for XTTCPS_COUNT_VALUE_Type use
   record
      MASK   at 0 range 0 .. 15;
      Unused at 0 range 16 .. 31;
   end record;

   -- XTTCPS_INTERVAL_VAL_OFFSET

   type XTTCPS_INTERVAL_VAL_Type is
   record
      COUNT_VALUE : Unsigned_16;
      Unused      : Bits_16 := 0;
   end record with
      Bit_Order            => Low_Order_First,
      Size                 => 32,
      Volatile_Full_Access => True;
   for XTTCPS_INTERVAL_VAL_Type use
   record
      COUNT_VALUE at 0 range 0 .. 15;
      Unused      at 0 range 16 .. 31;
   end record;

   -- XTTCPS_MATCH_[012]_OFFSET

   type XTTCPS_MATCH_Type is
   record
      MATCH  : Unsigned_16;
      Unused : Bits_16 := 0;
   end record with
      Bit_Order            => Low_Order_First,
      Size                 => 32,
      Volatile_Full_Access => True;
   for XTTCPS_MATCH_Type use
   record
      MATCH  at 0 range 0 .. 15;
      Unused at 0 range 16 .. 31;
   end record;

   -- XTTCPS_ISR_OFFSET

   type XTTCPS_ISR_Type is
   record
      IXR_INTERVAL : Boolean;
      IXR_MATCH_0  : Boolean;
      IXR_MATCH_1  : Boolean;
      IXR_MATCH_2  : Boolean;
      IXR_CNT_OVR  : Boolean;
      Ev           : Boolean;
      Unused       : Bits_26;
   end record with
      Bit_Order            => Low_Order_First,
      Size                 => 32,
      Volatile_Full_Access => True;
   for XTTCPS_ISR_Type use
   record
      IXR_INTERVAL at 0 range 0 .. 0;
      IXR_MATCH_0  at 0 range 1 .. 1;
      IXR_MATCH_1  at 0 range 2 .. 2;
      IXR_MATCH_2  at 0 range 3 .. 3;
      IXR_CNT_OVR  at 0 range 4 .. 4;
      Ev           at 0 range 5 .. 5;
      Unused       at 0 range 6 .. 31;
   end record;

   -- XTTCPS_IER_OFFSET

   type XTTCPS_IER_Type is
   record
      IXR_INTERVAL_IEN : Boolean;
      IXR_MATCH_0_IEN  : Boolean;
      IXR_MATCH_1_IEN  : Boolean;
      IXR_MATCH_2_IEN  : Boolean;
      IXR_CNT_OVR_IEN  : Boolean;
      Ev_IEN           : Boolean;
      Unused           : Bits_26 := 0;
   end record with
      Bit_Order            => Low_Order_First,
      Size                 => 32,
      Volatile_Full_Access => True;
   for XTTCPS_IER_Type use
   record
      IXR_INTERVAL_IEN at 0 range 0 .. 0;
      IXR_MATCH_0_IEN  at 0 range 1 .. 1;
      IXR_MATCH_1_IEN  at 0 range 2 .. 2;
      IXR_MATCH_2_IEN  at 0 range 3 .. 3;
      IXR_CNT_OVR_IEN  at 0 range 4 .. 4;
      Ev_IEN           at 0 range 5 .. 5;
      Unused           at 0 range 6 .. 31;
   end record;

   -- Event_Control_Timer_X

   type Event_Control_Timer_Type is
   record
      E_En   : Boolean;
      E_Lo   : Boolean;
      E_Ov   : Boolean;
      Unused : Bits_29 := 0;
   end record with
      Bit_Order            => Low_Order_First,
      Size                 => 32,
      Volatile_Full_Access => True;
   for Event_Control_Timer_Type use
   record
      E_En   at 0 range 0 .. 0;
      E_Lo   at 0 range 1 .. 1;
      E_Ov   at 0 range 2 .. 2;
      Unused at 0 range 3 .. 31;
   end record;

   -- Event_Register_X

   type Event_Register_Type is
   record
      Event  : Unsigned_16;
      Unused : Bits_16;
   end record with
      Bit_Order            => Low_Order_First,
      Size                 => 32,
      Volatile_Full_Access => True;
   for Event_Register_Type use
   record
      Event  at 0 range 0 .. 15;
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

   type TTC_Type is
   record
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
   end record with
      Size => 16#84# * 8;
   for TTC_Type use
   record
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

   TTC0_BASEADDRESS : constant := 16#F800_1000#;

   TTC0 : aliased TTC_Type with
      Address    => To_Address (TTC0_BASEADDRESS),
      Volatile   => True,
      Import     => True,
      Convention => Ada;

   TTC1_BASEADDRESS : constant := 16#F800_2000#;

   TTC1 : aliased TTC_Type with
      Address    => To_Address (TTC1_BASEADDRESS),
      Volatile   => True,
      Import     => True,
      Convention => Ada;

   ----------------------------------------------------------------------------
   -- B.33 UART Controller (UART)
   ----------------------------------------------------------------------------

   -- XUARTPS_CR

   type XUARTPS_CR_Type is
   record
      RXRST    : Boolean;
      TXRST    : Boolean;
      RX_EN    : Boolean;
      RX_DIS   : Boolean;
      TX_EN    : Boolean;
      TX_DIS   : Boolean;
      TORST    : Boolean;
      STARTBRK : Boolean;
      STOPBRK  : Boolean;
      Reserved : Bits_23 := 0;
   end record with
      Bit_Order => Low_Order_First,
      Size      => 32;
   for XUARTPS_CR_Type use
   record
      RXRST    at 0 range 0 .. 0;
      TXRST    at 0 range 1 .. 1;
      RX_EN    at 0 range 2 .. 2;
      RX_DIS   at 0 range 3 .. 3;
      TX_EN    at 0 range 4 .. 4;
      TX_DIS   at 0 range 5 .. 5;
      TORST    at 0 range 6 .. 6;
      STARTBRK at 0 range 7 .. 7;
      STOPBRK  at 0 range 8 .. 8;
      Reserved at 0 range 9 .. 31;
   end record;

   -- XUARTPS_MR

   CLKSEL_REFCLK     : constant := 0;
   CLKSEL_REFCLKDIV8 : constant := 1;

   CHRL_8 : constant := 2#00#;
   CHRL_7 : constant := 2#10#;
   CHRL_6 : constant := 2#11#;

   PAR_EVEN     : constant := 2#000#;
   PAR_ODD      : constant := 2#001#;
   PAR_SPACE    : constant := 2#010#;
   PAR_MARK     : constant := 2#011#;
   PAR_NOPARITY : constant := 2#100#;

   NBSTOP_1  : constant := 2#00#;
   NBSTOP_15 : constant := 2#01#;
   NBSTOP_2  : constant := 2#10#;

   CHMODE_NORMAL          : constant := 2#00#;
   CHMODE_AUTOECHO        : constant := 2#01#;
   CHMODE_LOOPBACK_LOCAL  : constant := 2#10#;
   CHMODE_LOOPBACK_REMOTE : constant := 2#11#;

   type XUARTPS_MR_Type is
   record
      CLKSEL   : Bits_1;
      CHRL     : Bits_2;
      PAR      : Bits_3;
      NBSTOP   : Bits_2;
      CHMODE   : Bits_2;
      Reserved : Bits_22 := 0;
   end record with
      Bit_Order => Low_Order_First,
      Size      => 32;
   for XUARTPS_MR_Type use
   record
      CLKSEL   at 0 range 0 .. 0;
      CHRL     at 0 range 1 .. 2;
      PAR      at 0 range 3 .. 5;
      NBSTOP   at 0 range 6 .. 7;
      CHMODE   at 0 range 8 .. 9;
      Reserved at 0 range 10 .. 31;
   end record;

   -- XUARTPS_I[EDMS]R

   type XUARTPS_IEDMSR_Type is
   record
      IXR_RXOVR   : Boolean;
      IXR_RXEMPTY : Boolean;
      IXR_RXFULL  : Boolean;
      IXR_TXEMPTY : Boolean;
      IXR_TXFULL  : Boolean;
      IXR_OVER    : Boolean;
      IXR_FRAMING : Boolean;
      IXR_PARITY  : Boolean;
      IXR_TOUT    : Boolean;
      IXR_DMS     : Boolean;
      TTRIG       : Boolean;
      TNFUL       : Boolean;
      TOVR        : Boolean;
      Reserved    : Bits_19 := 0;
   end record with
      Bit_Order => Low_Order_First,
      Size      => 32;
   for XUARTPS_IEDMSR_Type use
   record
      IXR_RXOVR   at 0 range 0 .. 0;
      IXR_RXEMPTY at 0 range 1 .. 1;
      IXR_RXFULL  at 0 range 2 .. 2;
      IXR_TXEMPTY at 0 range 3 .. 3;
      IXR_TXFULL  at 0 range 4 .. 4;
      IXR_OVER    at 0 range 5 .. 5;
      IXR_FRAMING at 0 range 6 .. 6;
      IXR_PARITY  at 0 range 7 .. 7;
      IXR_TOUT    at 0 range 8 .. 8;
      IXR_DMS     at 0 range 9 .. 9;
      TTRIG       at 0 range 10 .. 10;
      TNFUL       at 0 range 11 .. 11;
      TOVR        at 0 range 12 .. 12;
      Reserved    at 0 range 13 .. 31;
   end record;

   -- XUARTPS_BAUDGEN

   type XUARTPS_BAUDGEN_Type is
   record
      CD       : Unsigned_16;  -- Baud Rate Clock Divisor Value
      Reserved : Bits_16 := 0;
   end record with
      Bit_Order => Low_Order_First,
      Size      => 32;
   for XUARTPS_BAUDGEN_Type use
   record
      CD       at 0 range 0 .. 15;
      Reserved at 0 range 16 .. 31;
   end record;

   -- XUARTPS_RXTOUT

   type XUARTPS_RXTOUT_Type is
   record
      RTO      : Unsigned_8;   -- Receiver timeout value
      Reserved : Bits_24 := 0;
   end record with
      Bit_Order => Low_Order_First,
      Size      => 32;
   for XUARTPS_RXTOUT_Type use
   record
      RTO      at 0 range 0 .. 7;
      Reserved at 0 range 8 .. 31;
   end record;

   -- XUARTPS_RXWM

   type XUARTPS_RXWM_Type is
   record
      RTRIG    : Bits_6;
      Reserved : Bits_26 := 0;
   end record with
      Bit_Order => Low_Order_First,
      Size      => 32;
   for XUARTPS_RXWM_Type use
   record
      RTRIG    at 0 range 0 .. 5;
      Reserved at 0 range 6 .. 31;
   end record;

   -- XUARTPS_MODEMCR

   type XUARTPS_MODEMCR_Type is
   record
      DTR       : Boolean;
      RTS       : Boolean;
      Reserved1 : Bits_3 := 0;
      FCM       : Boolean;
      Reserved2 : Bits_26 := 0;
   end record with
      Bit_Order => Low_Order_First,
      Size      => 32;
   for XUARTPS_MODEMCR_Type use
   record
      DTR       at 0 range 0 .. 0;
      RTS       at 0 range 1 .. 1;
      Reserved1 at 0 range 2 .. 4;
      FCM       at 0 range 5 .. 5;
      Reserved2 at 0 range 6 .. 31;
   end record;

   -- XUARTPS_MODEMSR

   type XUARTPS_MODEMSR_Type is
   record
      MEDEMSR_CTSX : Boolean;
      MEDEMSR_DSRX : Boolean;
      MEDEMSR_RIX  : Boolean;
      MEDEMSR_DCDX : Boolean;
      CTS          : Boolean;
      DSR          : Boolean;
      RI           : Boolean;
      DCD          : Boolean;
      FCMS         : Boolean;
      Reserved     : Bits_23 := 0;
   end record with
      Bit_Order => Low_Order_First,
      Size      => 32;
   for XUARTPS_MODEMSR_Type use
   record
      MEDEMSR_CTSX at 0 range 0 .. 0;
      MEDEMSR_DSRX at 0 range 1 .. 1;
      MEDEMSR_RIX  at 0 range 2 .. 2;
      MEDEMSR_DCDX at 0 range 3 .. 3;
      CTS          at 0 range 4 .. 4;
      DSR          at 0 range 5 .. 5;
      RI           at 0 range 6 .. 6;
      DCD          at 0 range 7 .. 7;
      FCMS         at 0 range 8 .. 8;
      Reserved     at 0 range 9 .. 31;
   end record;

   -- XUARTPS_SR

   type XUARTPS_SR_Type is
   record
      RXOVR     : Boolean;
      RXEMPTY   : Boolean;
      RXFULL    : Boolean;
      TXEMPTY   : Boolean;
      TXFULL    : Boolean;
      Reserved1 : Bits_5 := 0;
      RACTIVE   : Boolean;
      TACTIVE   : Boolean;
      FLOWDEL   : Boolean;
      TTRIG     : Boolean;
      TNFUL     : Boolean;
      Reserved2 : Bits_17 := 0;
   end record with
      Bit_Order => Low_Order_First,
      Size      => 32;
   for XUARTPS_SR_Type use
   record
      RXOVR     at 0 range 0 .. 0;
      RXEMPTY   at 0 range 1 .. 1;
      RXFULL    at 0 range 2 .. 2;
      TXEMPTY   at 0 range 3 .. 3;
      TXFULL    at 0 range 4 .. 4;
      Reserved1 at 0 range 5 .. 9;
      RACTIVE   at 0 range 10 .. 10;
      TACTIVE   at 0 range 11 .. 11;
      FLOWDEL   at 0 range 12 .. 12;
      TTRIG     at 0 range 13 .. 13;
      TNFUL     at 0 range 14 .. 14;
      Reserved2 at 0 range 15 .. 31;
   end record;

   -- XUARTPS_FIFO

   type XUARTPS_FIFO_Type is
   record
      FIFO     : Unsigned_8;
      Reserved : Bits_24 := 0;
   end record with
      Bit_Order => Low_Order_First,
      Size      => 32;
   for XUARTPS_FIFO_Type use
   record
      FIFO     at 0 range 0 .. 7;
      Reserved at 0 range 8 .. 31;
   end record;

   -- UART layout

   type UART_Type is
   record
      CR      : XUARTPS_CR_Type      with Volatile_Full_Access => True;
      MR      : XUARTPS_MR_Type      with Volatile_Full_Access => True;
      IER     : XUARTPS_IEDMSR_Type  with Volatile_Full_Access => True;
      IDR     : XUARTPS_IEDMSR_Type  with Volatile_Full_Access => True;
      IMR     : XUARTPS_IEDMSR_Type  with Volatile_Full_Access => True;
      ISR     : XUARTPS_IEDMSR_Type  with Volatile_Full_Access => True;
      BAUDGEN : XUARTPS_BAUDGEN_Type with Volatile_Full_Access => True;
      RXTOUT  : XUARTPS_RXTOUT_Type  with Volatile_Full_Access => True;
      RXWM    : XUARTPS_RXWM_Type    with Volatile_Full_Access => True;
      MODEMCR : XUARTPS_MODEMCR_Type with Volatile_Full_Access => True;
      MODEMSR : XUARTPS_MODEMSR_Type with Volatile_Full_Access => True;
      SR      : XUARTPS_SR_Type      with Volatile_Full_Access => True;
      FIFO    : XUARTPS_FIFO_Type    with Volatile_Full_Access => True;
   end record with
      Alignment => 4;
   for UART_Type use
   record
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
   end record;

   UART0_BASEADDRESS : constant := 16#E000_0000#;

   UART0 : aliased UART_Type with
      Address    => To_Address (UART0_BASEADDRESS),
      Volatile   => True,
      Import     => True,
      Convention => Ada;

   procedure UART_TX (Data : in Unsigned_8);
   procedure UART_RX (Data : out Unsigned_8);
   procedure UART_Init;

end ZynqA9;

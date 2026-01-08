-----------------------------------------------------------------------------------------------------------------------
--                                                     SweetAda                                                      --
-----------------------------------------------------------------------------------------------------------------------
-- __HDS__                                                                                                           --
-- __FLN__ sh7032.ads                                                                                                --
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

package SH7032
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
   -- SH7032, SH7034 Hardware Manual
   -- Rev.7.00 2006.01
   ----------------------------------------------------------------------------

   ----------------------------------------------------------------------------
   -- Section 5 Interrupt Controller (INTC)
   ----------------------------------------------------------------------------

   -- 5.3.1 Interrupt Priority Registers A–E (IPRA–IPRE)

   type IPRA_Type is record
      IRQ3 : Bits_4 := 0; -- IRQ3 priority level
      IRQ2 : Bits_4 := 0; -- IRQ2 priority level
      IRQ1 : Bits_4 := 0; -- IRQ1 priority level
      IRQ0 : Bits_4 := 0; -- IRQ0 priority level
   end record
      with Bit_Order   => Low_Order_First,
           Object_Size => 16;
   for IPRA_Type use record
      IRQ3 at 0 range  0 ..  3;
      IRQ2 at 0 range  4 ..  7;
      IRQ1 at 0 range  8 .. 11;
      IRQ0 at 0 range 12 .. 15;
   end record;

   IPRA_ADDRESS : constant := 16#05FF_FF84#;

   IPRA : aliased IPRA_Type
      with Address              => System'To_Address (IPRA_ADDRESS),
           Volatile_Full_Access => True,
           Import               => True,
           Convention           => Ada;

   type IPRB_Type is record
      IRQ7 : Bits_4 := 0; -- IRQ7 priority level
      IRQ6 : Bits_4 := 0; -- IRQ6 priority level
      IRQ5 : Bits_4 := 0; -- IRQ5 priority level
      IRQ4 : Bits_4 := 0; -- IRQ4 priority level
   end record
      with Bit_Order   => Low_Order_First,
           Object_Size => 16;
   for IPRB_Type use record
      IRQ7 at 0 range  0 ..  3;
      IRQ6 at 0 range  4 ..  7;
      IRQ5 at 0 range  8 .. 11;
      IRQ4 at 0 range 12 .. 15;
   end record;

   IPRB_ADDRESS : constant := 16#05FF_FF86#;

   IPRB : aliased IPRB_Type
      with Address              => System'To_Address (IPRB_ADDRESS),
           Volatile_Full_Access => True,
           Import               => True,
           Convention           => Ada;

   type IPRC_Type is record
      ITU1   : Bits_4 := 0; -- ITU1 priority level
      ITU0   : Bits_4 := 0; -- ITU0 priority level
      DMAC23 : Bits_4 := 0; -- DMAC2, DMAC3 priority level
      DMAC01 : Bits_4 := 0; -- DMAC0, DMAC1 priority level
   end record
      with Bit_Order   => Low_Order_First,
           Object_Size => 16;
   for IPRC_Type use record
      ITU1   at 0 range  0 ..  3;
      ITU0   at 0 range  4 ..  7;
      DMAC23 at 0 range  8 .. 11;
      DMAC01 at 0 range 12 .. 15;
   end record;

   IPRC_ADDRESS : constant := 16#05FF_FF88#;

   IPRC : aliased IPRC_Type
      with Address              => System'To_Address (IPRC_ADDRESS),
           Volatile_Full_Access => True,
           Import               => True,
           Convention           => Ada;

   type IPRD_Type is record
      SCI0 : Bits_4 := 0; -- SCI0 priority level
      ITU4 : Bits_4 := 0; -- ITU4 priority level
      ITU3 : Bits_4 := 0; -- ITU3 priority level
      ITU2 : Bits_4 := 0; -- ITU2 priority level
   end record
      with Bit_Order   => Low_Order_First,
           Object_Size => 16;
   for IPRD_Type use record
      SCI0 at 0 range  0 ..  3;
      ITU4 at 0 range  4 ..  7;
      ITU3 at 0 range  8 .. 11;
      ITU2 at 0 range 12 .. 15;
   end record;

   IPRD_ADDRESS : constant := 16#05FF_FF8A#;

   IPRD : aliased IPRD_Type
      with Address              => System'To_Address (IPRD_ADDRESS),
           Volatile_Full_Access => True,
           Import               => True,
           Convention           => Ada;

   type IPRE_Type is record
      Reserved : Bits_4 := 0;
      WDT_REF  : Bits_4 := 0; -- WDT, REF priority level
      PRT_AD   : Bits_4 := 0; -- PRT, A/D priority level
      SCI1     : Bits_4 := 0; -- SCI1 priority level
   end record
      with Bit_Order   => Low_Order_First,
           Object_Size => 16;
   for IPRE_Type use record
      Reserved at 0 range  0 ..  3;
      WDT_REF  at 0 range  4 ..  7;
      PRT_AD   at 0 range  8 .. 11;
      SCI1     at 0 range 12 .. 15;
   end record;

   IPRE_ADDRESS : constant := 16#05FF_FF8C#;

   IPRE : aliased IPRE_Type
      with Address              => System'To_Address (IPRE_ADDRESS),
           Volatile_Full_Access => True,
           Import               => True,
           Convention           => Ada;

   -- 5.3.2 Interrupt Control Register (ICR)

   IRQxS_LOW   : constant := 0; -- Interrupt is requested when IRQ input is low
   IRQxS_FEDGE : constant := 1; -- Interrupt is requested on falling edge of IRQ input

   NMIE_FEDGE : constant := 0; -- Interrupt is requested on falling edge of NMI input
   NMIE_REDGE : constant := 1; -- Interrupt is requested on rising edge of NMI input

   NMIL_LOW  : constant := 0; -- NMI input level is low
   NMIL_HIGH : constant := 1; -- NMI input level is high

   type ICR_Type is record
      IRQ7S    : Bits_1 := IRQxS_LOW;  -- IRQ7 Sense Select
      IRQ6S    : Bits_1 := IRQxS_LOW;  -- IRQ6 Sense Select
      IRQ5S    : Bits_1 := IRQxS_LOW;  -- IRQ5 Sense Select
      IRQ4S    : Bits_1 := IRQxS_LOW;  -- IRQ4 Sense Select
      IRQ3S    : Bits_1 := IRQxS_LOW;  -- IRQ3 Sense Select
      IRQ2S    : Bits_1 := IRQxS_LOW;  -- IRQ2 Sense Select
      IRQ1S    : Bits_1 := IRQxS_LOW;  -- IRQ1 Sense Select
      IRQ0S    : Bits_1 := IRQxS_LOW;  -- IRQ0 Sense Select
      NMIE     : Bits_1 := NMIE_FEDGE; -- NMI Edge Select
      Reserved : Bits_6 := 0;
      NMIL     : Bits_1 := NMIL_LOW;   -- NMI input level
   end record
      with Bit_Order   => Low_Order_First,
           Object_Size => 16;
   for ICR_Type use record
      IRQ7S    at 0 range  0 ..  0;
      IRQ6S    at 0 range  1 ..  1;
      IRQ5S    at 0 range  2 ..  2;
      IRQ4S    at 0 range  3 ..  3;
      IRQ3S    at 0 range  4 ..  4;
      IRQ2S    at 0 range  5 ..  5;
      IRQ1S    at 0 range  6 ..  6;
      IRQ0S    at 0 range  7 ..  7;
      NMIE     at 0 range  8 ..  8;
      Reserved at 0 range  9 .. 14;
      NMIL     at 0 range 15 .. 15;
   end record;

   ICR_ADDRESS : constant := 16#05FF_FF8E#;

   ICR : aliased ICR_Type
      with Address              => System'To_Address (ICR_ADDRESS),
           Volatile_Full_Access => True,
           Import               => True,
           Convention           => Ada;

   ----------------------------------------------------------------------------
   -- Section 6 (UBC) User Break Controller (UBC)
   ----------------------------------------------------------------------------

   -- 6.2.1 Break Address Registers (BAR)

   BARH_ADDRESS : constant := 16#05FF_FF90#;
   BARL_ADDRESS : constant := 16#05FF_FF92#;

   BARH : aliased Unsigned_16
      with Address              => System'To_Address (BARH_ADDRESS),
           Volatile_Full_Access => True,
           Import               => True,
           Convention           => Ada;

   BARL : aliased Unsigned_16
      with Address              => System'To_Address (BARL_ADDRESS),
           Volatile_Full_Access => True,
           Import               => True,
           Convention           => Ada;

   -- 6.2.2 Break Address Mask Register (BAMR)

   BAMRH_ADDRESS : constant := 16#05FF_FF94#;
   BAMRL_ADDRESS : constant := 16#05FF_FF96#;

   BAMRH : aliased Unsigned_16
      with Address              => System'To_Address (BAMRH_ADDRESS),
           Volatile_Full_Access => True,
           Import               => True,
           Convention           => Ada;

   BAMRL : aliased Unsigned_16
      with Address              => System'To_Address (BAMRL_ADDRESS),
           Volatile_Full_Access => True,
           Import               => True,
           Convention           => Ada;

   -- 6.2.3 Break Bus Cycle Register (BBR)

   SZ_NONE : constant := 2#00#; -- Operand size is not a break condition
   SZ_BYTE : constant := 2#01#; -- Break on byte access
   SZ_WORD : constant := 2#10#; -- Break on word access
   SZ_LONG : constant := 2#11#; -- Break on longword access

   RW_NONE  : constant := 2#00#; -- No break interrupt occurs
   RW_READ  : constant := 2#01#; -- Break only on read cycles
   RW_WRITE : constant := 2#10#; -- Break only on write cycles
   RW_ALL   : constant := 2#11#; -- Break on both read and write cycles

   ID_NONE  : constant := 2#00#; -- No break interrupt occurs
   ID_INSTR : constant := 2#01#; -- Break only on instruction fetch cycles
   ID_DATA  : constant := 2#10#; -- Break only on data access cycles
   ID_ALL   : constant := 2#11#; -- Break on both instruction fetch and data access cycles

   CD_NONE : constant := 2#00#; -- No break interrupt occurs
   CD_CPU  : constant := 2#01#; -- Break only on CPU cycles
   CD_DMA  : constant := 2#10#; -- Break only on DMA cycles
   CD_ALL  : constant := 2#11#; -- Break on both CPU and DMA cycles

   type BBR_Type is record
      SZ       : Bits_2 := SZ_NONE; -- Operand Size Select
      RW       : Bits_2 := RW_NONE; -- Read/Write Select
      ID       : Bits_2 := ID_NONE; -- Instruction Fetch/Data Access Select
      CD       : Bits_2 := CD_NONE; -- CPU Cycle/DMA Cycle Select
      Reserved : Bits_8 := 0;
   end record
      with Bit_Order   => Low_Order_First,
           Object_Size => 16;
   for BBR_Type use record
      SZ       at 0 range 0 ..  1;
      RW       at 0 range 2 ..  3;
      ID       at 0 range 4 ..  5;
      CD       at 0 range 6 ..  7;
      Reserved at 0 range 8 .. 15;
   end record;

   BBR_ADDRESS : constant := 16#05FF_FF98#;

   BBR : aliased BBR_Type
      with Address              => System'To_Address (BBR_ADDRESS),
           Volatile_Full_Access => True,
           Import               => True,
           Convention           => Ada;

   ----------------------------------------------------------------------------
   -- Section 8 Bus State Controller (BSC)
   ----------------------------------------------------------------------------

   -- 8.2.1 Bus Control Register (BCR)

   BAS_WRHLA0 : constant := 0; -- WRH, WRL, and A0 enabled
   BAS_LHBSWR : constant := 1; -- LBS, WR, and HBS enabled

   RDDTY_50 : constant := 0; -- RD signal high-level duty cycle is 50% of T1 state
   RDDTY_35 : constant := 1; -- RD signal high-level duty cycle is 35% of T1 state

   type BCR_Type is record
      Reserved : Bits_11 := 0;
      BAS      : Bits_1  := BAS_WRHLA0; -- Byte Access Select
      RDDTY    : Bits_1  := RDDTY_50;   -- RD Duty
      WARP     : Boolean := False;      -- Warp Mode Bit
      IOE      : Boolean := False;      -- Multiplexed I/O Enable Bit
      DRAME    : Boolean := False;      -- DRAM Enable Bit
   end record
      with Bit_Order   => Low_Order_First,
           Object_Size => 16;
   for BCR_Type use record
      Reserved at 0 range  0 .. 10;
      BAS      at 0 range 11 .. 11;
      RDDTY    at 0 range 12 .. 12;
      WARP     at 0 range 13 .. 13;
      IOE      at 0 range 14 .. 14;
      DRAME    at 0 range 15 .. 15;
   end record;

   BCR_ADDRESS : constant := 16#05FF_FFA0#;

   BCR : aliased BCR_Type
      with Address              => System'To_Address (BCR_ADDRESS),
           Volatile_Full_Access => True,
           Import               => True,
           Convention           => Ada;

   ----------------------------------------------------------------------------
   -- Section 9 Direct Memory Access Controller (DMAC)
   ----------------------------------------------------------------------------

   -- 9.2.1 DMA Source Address Registers 0–3 (SAR0–SAR3)
   -- 9.2.2 DMA Destination Address Registers 0–3 (DAR0–DAR3)
   -- 9.2.3 DMA Transfer Count Registers 0–3 (TCR0–TCR3)

   -- 9.2.4 DMA Channel Control Registers 0–3 (CHCR0–CHCR3)

   TS_BYTE : constant := 0; -- Byte (8 bits)
   TS_WORD : constant := 1; -- Word (16 bits)

   TM_CYCSTEAL : constant := 0; -- Cycle-steal mode
   TM_BURST    : constant := 1; -- Burst mode

   DS_LOWLEVEL : constant := 0; -- /DREQ detected by low level
   DS_FALLEDGE : constant := 1; -- /DREQ detected by falling edge

   AL_DACKHIGH : constant := 0; -- DACK is active-high
   AL_DACKLOW  : constant := 1; -- DACK is active-low

   AM_DACKREAD  : constant := 0; -- DACK is output in read cycle
   AM_DACKWRITE : constant := 1; -- DACK is output in write cycle

   RS_DREQEXTDA        : constant := 2#0000#; -- /DREQ (External request, dual address mode)
   RS_RSVD1            : constant := 2#0001#; -- Reserved (illegal setting)
   RS_DREQTOEXTDEVSA   : constant := 2#0010#; -- /DREQ (External request, single address mode)
   RS_DREQFROMEXTDEVSA : constant := 2#0011#; -- /DREQ (External request, single address mode)
   RS_RXI0             : constant := 2#0100#; -- RXI0 (On-chip serial communication interface 0 receive data full interrupt transfer request)
   RS_TXI0             : constant := 2#0101#; -- TXI0 (On-chip serial communication interface 0 transmit data empty interrupt transfer request)
   RS_RXI1             : constant := 2#0110#; -- RXI1 (On-chip serial communication interface 1 receive data full interrupt transfer request)
   RS_TXI1             : constant := 2#0111#; -- TXI1 (On-chip serial communication interface 1 transmit data empty interrupt transfer request)
   RS_IMIA0            : constant := 2#1000#; -- IMIA0 (On-chip ITU0 input capture/compare match A interrupt transfer request)
   RS_IMIA1            : constant := 2#1001#; -- IMIA1 (On-chip ITU1 input capture/compare match A interrupt transfer request)
   RS_IMIA2            : constant := 2#1010#; -- IMIA2 (On-chip ITU2 input capture/compare match A interrupt transfer request)
   RS_IMIA3            : constant := 2#1011#; -- IMIA3 (On-chip ITU3 input capture/compare match A interrupt transfer request)
   RS_AUTOREQ          : constant := 2#1100#; -- Auto-request (Transfer requests automatically generated within DMAC)
   RS_ADI              : constant := 2#1101#; -- ADI (A/D conversion end interrupt request of on-chip A/D converter)
   RS_RSVD2            : constant := 2#1110#; -- Reserved (illegal setting)
   RS_RSVD3            : constant := 2#1111#; -- Reserved (illegal setting)

   SM_FIXED : constant := 2#00#; -- Fixed source address
   SM_INCR  : constant := 2#01#; -- Source address is incremented (+1 or +2 depending on if the transfer size is word or byte)
   SM_DECR  : constant := 2#10#; -- Source address is decremented (–1 or –2 depending on if the transfer size is word or byte)
   SM_RSVD  : constant := 2#11#; -- Reserved (illegal setting)

   DM_FIXED : constant := 2#00#; -- Fixed destination address
   DM_INCR  : constant := 2#01#; -- Destination address is incremented (+1 or +2 depending on whether the transfer size is word or byte)
   DM_DECR  : constant := 2#10#; -- Destination address is decremented (–1 or –2 depending on whether the transfer size is word or byte)
   DM_RSVD  : constant := 2#11#; -- Reserved (illegal setting)

   type CHCR_Type is record
      DE : Boolean := False;        -- DMA Enable Bit
      TE : Boolean := False;        -- Transfer End Flag Bit
      IE : Boolean := False;        -- Interrupt Enable Bit
      TS : Bits_1  := TS_BYTE;      -- Transfer Size Bit
      TM : Bits_1  := TM_CYCSTEAL;  -- Transfer Bus Mode Bit
      DS : Bits_1  := DS_LOWLEVEL;  -- /DREQ Select Bit
      AL : Bits_1  := AL_DACKHIGH;  -- Acknowledge Level Bit
      AM : Bits_1  := AM_DACKREAD;  -- Acknowledge Mode Bit
      RS : Bits_4  := RS_DREQEXTDA; -- Resource Select Bits
      SM : Bits_2  := SM_FIXED;     -- source address mode bits 1, 0
      DM : Bits_2  := DM_FIXED;     -- Destination Address Mode Bits 1 and 0
   end record
      with Bit_Order   => Low_Order_First,
           Object_Size => 16;
   for CHCR_Type use record
      DE at 0 range  0 ..  0;
      TE at 0 range  1 ..  1;
      IE at 0 range  2 ..  2;
      TS at 0 range  3 ..  3;
      TM at 0 range  4 ..  4;
      DS at 0 range  5 ..  5;
      AL at 0 range  6 ..  6;
      AM at 0 range  7 ..  7;
      RS at 0 range  8 .. 11;
      SM at 0 range 12 .. 13;
      DM at 0 range 14 .. 15;
   end record;

   -- 9.1.4 Register Configuration

   type DMA_Type is record
      SAR  : Unsigned_32 with Volatile_Full_Access => True;
      DAR  : Unsigned_32 with Volatile_Full_Access => True;
      TCR  : Unsigned_16 with Volatile_Full_Access => True;
      CHCR : CHCR_Type   with Volatile_Full_Access => True;
   end record
      with Object_Size => 16#10# * 8;
   for DMA_Type use record
      SAR  at 16#0# range 0 .. 31;
      DAR  at 16#4# range 0 .. 31;
      TCR  at 16#A# range 0 .. 15;
      CHCR at 16#E# range 0 .. 15;
   end record;

   DMA0_BASEADDRESS : constant := 16#05FF_FF40#;

   DMA0 : aliased DMA_Type
      with Address    => System'To_Address (DMA0_BASEADDRESS),
           Volatile   => True,
           Import     => True,
           Convention => Ada;

   DMA1_BASEADDRESS : constant := 16#05FF_FF50#;

   DMA1 : aliased DMA_Type
      with Address    => System'To_Address (DMA1_BASEADDRESS),
           Volatile   => True,
           Import     => True,
           Convention => Ada;

   DMA2_BASEADDRESS : constant := 16#05FF_FF60#;

   DMA2 : aliased DMA_Type
      with Address    => System'To_Address (DMA2_BASEADDRESS),
           Volatile   => True,
           Import     => True,
           Convention => Ada;

   DMA3_BASEADDRESS : constant := 16#05FF_FF70#;

   DMA3 : aliased DMA_Type
      with Address    => System'To_Address (DMA3_BASEADDRESS),
           Volatile   => True,
           Import     => True,
           Convention => Ada;

   -- 9.2.5 DMA Operation Register (DMAOR)

   PR_FIXED0321 : constant := 2#00#; -- Fixed priority order (Ch. 0 > Ch. 3 > Ch. 2 > Ch. 1)
   PR_FIXED1320 : constant := 2#01#; -- Fixed priority order (Ch. 1 > Ch. 3 > Ch. 2 > Ch. 0)
   PR_RNDROB    : constant := 2#10#; -- Round-robin mode priority order (the priority order immediately after a reset is Ch. 0 > Ch. 3 > Ch. 2 > Ch. 1)
   PR_EXTRNDROB : constant := 2#11#; -- External-pin round-robin mode priority order (the priority order immediately after a reset is Ch. 3 > Ch. 2 > Ch. 1 > Ch. 0)

   type DMAOR_Type is record
      DME       : Boolean := False;        -- DMA Master Enable Bit
      NMIF      : Boolean := True;         -- NMI Flag Bit
      AE        : Boolean := True;         -- Address Error Flag Bit
      Reserved1 : Bits_5  := 0;
      PR        : Bits_2  := PR_FIXED0321; -- Priority Mode Bits 1 and 0
      Reserved2 : Bits_6  := 0;
   end record
      with Bit_Order   => Low_Order_First,
           Object_Size => 16;
   for DMAOR_Type use record
      DME       at 0 range  0 ..  0;
      NMIF      at 0 range  1 ..  1;
      AE        at 0 range  2 ..  2;
      Reserved1 at 0 range  3 ..  7;
      PR        at 0 range  8 ..  9;
      Reserved2 at 0 range 10 .. 15;
   end record;

   DMAOR_ADDRESS : constant := 16#05FF_FF48#;

   DMAOR : aliased DMAOR_Type
      with Address              => System'To_Address (DMAOR_ADDRESS),
           Volatile_Full_Access => True,
           Import               => True,
           Convention           => Ada;

   ----------------------------------------------------------------------------
   -- Section 10 16-Bit Integrated Timer Pulse Unit (ITU)
   ----------------------------------------------------------------------------

   -- 10.2.1 Timer Start Register (TSTR)

   type TSTR_Type is record
      STR0      : Boolean := False; -- Count Start 0
      STR1      : Boolean := False; -- Count Start 1
      STR2      : Boolean := False; -- Count Start 2
      STR3      : Boolean := False; -- Count Start 3
      STR4      : Boolean := False; -- Count Start 4
      Reserved1 : Bits_2  := 2#11#;
      Reserved2 : Bits_1  := 0;
   end record
      with Bit_Order   => Low_Order_First,
           Object_Size => 8;
   for TSTR_Type use record
      STR0      at 0 range 0 .. 0;
      STR1      at 0 range 1 .. 1;
      STR2      at 0 range 2 .. 2;
      STR3      at 0 range 3 .. 3;
      STR4      at 0 range 4 .. 4;
      Reserved1 at 0 range 5 .. 6;
      Reserved2 at 0 range 7 .. 7;
   end record;

   TSTR_ADDRESS : constant := 16#05FF_FF00#;

   TSTR : aliased TSTR_Type
      with Address              => System'To_Address (TSTR_ADDRESS),
           Volatile_Full_Access => True,
           Import               => True,
           Convention           => Ada;

   -- 10.2.2 Timer Synchro Register (TSNC)

   type TSNC_Type is record
      SYNC0     : Boolean := False; -- Timer Synchro 0
      SYNC1     : Boolean := False; -- Timer Synchro 1
      SYNC2     : Boolean := False; -- Timer Synchro 2
      SYNC3     : Boolean := False; -- Timer Synchro 3
      SYNC4     : Boolean := False; -- Timer Synchro 4
      Reserved1 : Bits_2  := 2#11#;
      Reserved2 : Bits_1  := 0;
   end record
      with Bit_Order   => Low_Order_First,
           Object_Size => 8;
   for TSNC_Type use record
      SYNC0     at 0 range 0 .. 0;
      SYNC1     at 0 range 1 .. 1;
      SYNC2     at 0 range 2 .. 2;
      SYNC3     at 0 range 3 .. 3;
      SYNC4     at 0 range 4 .. 4;
      Reserved1 at 0 range 5 .. 6;
      Reserved2 at 0 range 7 .. 7;
   end record;

   TSNC_ADDRESS : constant := 16#05FF_FF01#;

   TSNC : aliased TSNC_Type
      with Address              => System'To_Address (TSNC_ADDRESS),
           Volatile_Full_Access => True,
           Import               => True,
           Convention           => Ada;

   -- 10.2.3 Timer Mode Register (TMDR)

   FDIR_ALL : constant := 0; -- OVF of TSR2 is set to 1 when TCNT2 overflows or underflows
   FDIR_OVF : constant := 1; -- OVF of TSR2 is set to 1 when TCNT2 overflows

   type TMDR_Type is record
      PWM0     : Boolean := False;    -- PWM Mode 0
      PWM1     : Boolean := False;    -- PWM Mode 1
      PWM2     : Boolean := False;    -- PWM Mode 2
      PWM3     : Boolean := False;    -- PWM Mode 3
      PWM4     : Boolean := False;    -- PWM Mode 4
      FDIR     : Bits_1  := FDIR_ALL; -- Flag Direction
      MDF      : Boolean := False;    -- Phase Counting Mode
      Reserved : Bits_1  := 0;
   end record
      with Bit_Order   => Low_Order_First,
           Object_Size => 8;
   for TMDR_Type use record
      PWM0     at 0 range 0 .. 0;
      PWM1     at 0 range 1 .. 1;
      PWM2     at 0 range 2 .. 2;
      PWM3     at 0 range 3 .. 3;
      PWM4     at 0 range 4 .. 4;
      FDIR     at 0 range 5 .. 5;
      MDF      at 0 range 6 .. 6;
      Reserved at 0 range 7 .. 7;
   end record;

   TMDR_ADDRESS : constant := 16#05FF_FF02#;

   TMDR : aliased TMDR_Type
      with Address              => System'To_Address (TMDR_ADDRESS),
           Volatile_Full_Access => True,
           Import               => True,
           Convention           => Ada;

   -- 10.2.4 Timer Function Control Register (TFCR)

   CMD_NORMAL   : constant := 2#00#; -- Channels 3 and 4 operate normally
   CMD_NORMAL_2 : constant := 2#01#; -- Channels 3 and 4 operate normally
   CMD_PWM      : constant := 2#10#; -- Channels 3 and 4 operate together in complementary PWM mode
   CMD_PWMSYNC  : constant := 2#11#; -- Channels 3 and 4 operate together in reset-synchronized PWM mode

   type TFCR_Type is record
      BFA3      : Boolean := False;      -- Buffer Mode A3
      BFB3      : Boolean := False;      -- Buffer Mode B3
      BFA4      : Boolean := False;      -- Buffer Mode A4
      BFB4      : Boolean := False;      -- Buffer Mode B4
      CMD       : Bits_2  := CMD_NORMAL; -- Combination Mode 1 and 0
      Reserved1 : Bits_1  := 1;
      Reserved2 : Bits_1  := 0;
   end record
      with Bit_Order   => Low_Order_First,
           Object_Size => 8;
   for TFCR_Type use record
      BFA3      at 0 range 0 .. 0;
      BFB3      at 0 range 1 .. 1;
      BFA4      at 0 range 2 .. 2;
      BFB4      at 0 range 3 .. 3;
      CMD       at 0 range 4 .. 5;
      Reserved1 at 0 range 6 .. 6;
      Reserved2 at 0 range 7 .. 7;
   end record;

   TFCR_ADDRESS : constant := 16#05FF_FF03#;

   TFCR : aliased TFCR_Type
      with Address              => System'To_Address (TFCR_ADDRESS),
           Volatile_Full_Access => True,
           Import               => True,
           Convention           => Ada;

   -- 10.2.5 Timer Output Control Register (TOCR)

   OLS3_INVERT : constant := 0; -- TIOCB3, TOCXA4, and TOCXB4 are inverted and output
   OLS3_DIRECT : constant := 1; -- TIOCB3, TOCXA4, and TOCXB4 are output directly

   OLS4_INVERT : constant := 0; -- TIOCA3, TIOCA4, and TIOCB4 are inverted and output
   OLS4_DIRECT : constant := 1; -- TIOCA3, TIOCA4, and TIOCB4 are output directly

   type TOCR_Type is record
      OLS3      : Bits_1 := OLS3_DIRECT; -- Output Level Select 3
      OLS4      : Bits_1 := OLS4_DIRECT; -- Output Level Select 4
      Reserved1 : Bits_5 := 2#11111#;
      Reserved2 : Bits_1 := 0;
   end record
      with Bit_Order   => Low_Order_First,
           Object_Size => 8;
   for TOCR_Type use record
      OLS3      at 0 range 0 .. 0;
      OLS4      at 0 range 1 .. 1;
      Reserved1 at 0 range 2 .. 6;
      Reserved2 at 0 range 7 .. 7;
   end record;

   TOCR_ADDRESS : constant := 16#05FF_FF31#;

   TOCR : aliased TOCR_Type
      with Address              => System'To_Address (TOCR_ADDRESS),
           Volatile_Full_Access => True,
           Import               => True,
           Convention           => Ada;

   -- 10.2.6 Timer Counters (TCNT)

   TCNT0_ADDRESS : constant := 16#05FF_FF08#;
   TCNT1_ADDRESS : constant := 16#05FF_FF12#;
   TCNT2_ADDRESS : constant := 16#05FF_FF1C#;
   TCNT3_ADDRESS : constant := 16#05FF_FF26#;
   TCNT4_ADDRESS : constant := 16#05FF_FF36#;

   TCNT0 : aliased Unsigned_16
      with Address              => System'To_Address (TCNT0_ADDRESS),
           Volatile_Full_Access => True,
           Import               => True,
           Convention           => Ada;

   TCNT1 : aliased Unsigned_16
      with Address              => System'To_Address (TCNT1_ADDRESS),
           Volatile_Full_Access => True,
           Import               => True,
           Convention           => Ada;

   TCNT2 : aliased Unsigned_16
      with Address              => System'To_Address (TCNT2_ADDRESS),
           Volatile_Full_Access => True,
           Import               => True,
           Convention           => Ada;

   TCNT3 : aliased Unsigned_16
      with Address              => System'To_Address (TCNT3_ADDRESS),
           Volatile_Full_Access => True,
           Import               => True,
           Convention           => Ada;

   TCNT4 : aliased Unsigned_16
      with Address              => System'To_Address (TCNT4_ADDRESS),
           Volatile_Full_Access => True,
           Import               => True,
           Convention           => Ada;

   -- 10.2.7 General Registers A and B (GRA and GRB)

   TGRA0_ADDRESS : constant := 16#05FF_FF0A#;
   TGRA1_ADDRESS : constant := 16#05FF_FF14#;
   TGRA2_ADDRESS : constant := 16#05FF_FF1E#;
   TGRA3_ADDRESS : constant := 16#05FF_FF28#;
   TGRA4_ADDRESS : constant := 16#05FF_FF38#;

   TGRA0 : aliased Unsigned_16
      with Address              => System'To_Address (TGRA0_ADDRESS),
           Volatile_Full_Access => True,
           Import               => True,
           Convention           => Ada;

   TGRA1 : aliased Unsigned_16
      with Address              => System'To_Address (TGRA1_ADDRESS),
           Volatile_Full_Access => True,
           Import               => True,
           Convention           => Ada;

   TGRA2 : aliased Unsigned_16
      with Address              => System'To_Address (TGRA2_ADDRESS),
           Volatile_Full_Access => True,
           Import               => True,
           Convention           => Ada;

   TGRA3 : aliased Unsigned_16
      with Address              => System'To_Address (TGRA3_ADDRESS),
           Volatile_Full_Access => True,
           Import               => True,
           Convention           => Ada;

   TGRA4 : aliased Unsigned_16
      with Address              => System'To_Address (TGRA4_ADDRESS),
           Volatile_Full_Access => True,
           Import               => True,
           Convention           => Ada;

   TGRB0_ADDRESS : constant := 16#05FF_FF0C#;
   TGRB1_ADDRESS : constant := 16#05FF_FF16#;
   TGRB2_ADDRESS : constant := 16#05FF_FF20#;
   TGRB3_ADDRESS : constant := 16#05FF_FF2E#;
   TGRB4_ADDRESS : constant := 16#05FF_FF3E#;

   TGRB0 : aliased Unsigned_16
      with Address              => System'To_Address (TGRB0_ADDRESS),
           Volatile_Full_Access => True,
           Import               => True,
           Convention           => Ada;

   TGRB1 : aliased Unsigned_16
      with Address              => System'To_Address (TGRB1_ADDRESS),
           Volatile_Full_Access => True,
           Import               => True,
           Convention           => Ada;

   TGRB2 : aliased Unsigned_16
      with Address              => System'To_Address (TGRB2_ADDRESS),
           Volatile_Full_Access => True,
           Import               => True,
           Convention           => Ada;

   TGRB3 : aliased Unsigned_16
      with Address              => System'To_Address (TGRB3_ADDRESS),
           Volatile_Full_Access => True,
           Import               => True,
           Convention           => Ada;

   TGRB4 : aliased Unsigned_16
      with Address              => System'To_Address (TGRB4_ADDRESS),
           Volatile_Full_Access => True,
           Import               => True,
           Convention           => Ada;

   -- 10.2.8 Buffer Registers A and B (BRA, BRB)

   TBRA3_ADDRESS : constant := 16#05FF_FF2C#;
   TBRA4_ADDRESS : constant := 16#05FF_FF3C#;

   TBRA3 : aliased Unsigned_16
      with Address              => System'To_Address (TBRA3_ADDRESS),
           Volatile_Full_Access => True,
           Import               => True,
           Convention           => Ada;

   TBRA4 : aliased Unsigned_16
      with Address              => System'To_Address (TBRA4_ADDRESS),
           Volatile_Full_Access => True,
           Import               => True,
           Convention           => Ada;

   TBRB3_ADDRESS : constant := 16#05FF_FF2E#;
   TBRB4_ADDRESS : constant := 16#05FF_FF3E#;

   TBRB3 : aliased Unsigned_16
      with Address              => System'To_Address (TBRB3_ADDRESS),
           Volatile_Full_Access => True,
           Import               => True,
           Convention           => Ada;

   TBRB4 : aliased Unsigned_16
      with Address              => System'To_Address (TBRB4_ADDRESS),
           Volatile_Full_Access => True,
           Import               => True,
           Convention           => Ada;

   -- 10.2.9 Timer Control Register (TCR)

   TPSC_ICLK      : constant := 2#000#; -- Internal clock φ
   TPSC_ICLK_DIV2 : constant := 2#001#; -- Internal clock φ/2
   TPSC_ICLK_DIV4 : constant := 2#010#; -- Internal clock φ/4
   TPSC_ICLK_DIV8 : constant := 2#011#; -- Internal clock φ/8
   TPSC_TCLKA     : constant := 2#100#; -- External clock A (TCLKA)
   TPSC_TCLKB     : constant := 2#101#; -- External clock B (TCLKB)
   TPSC_TCLKC     : constant := 2#110#; -- External clock C (TCLKC)
   TPSC_TCLKD     : constant := 2#111#; -- External clock D (TCLKD)

   CKEG_REDGE   : constant := 2#00#; -- Count rising edges
   CKEG_FEDGE   : constant := 2#01#; -- Count falling edges
   CKEG_EDGES   : constant := 2#10#; -- Count both rising and falling edges
   CKEG_EDGES_2 : constant := 2#11#; -- Count both rising and falling edges

   CCLR_NONE : constant := 2#00#; -- TCNT is not cleared
   CCLR_GRA  : constant := 2#01#; -- TCNT is cleared by general register A (GRA) compare match or input capture
   CCLR_GRB  : constant := 2#10#; -- TCNT is cleared by general register B (GRB) compare match or input capture
   CCLR_SYNC : constant := 2#11#; -- Synchronizing clear: TCNT is cleared in synchronization with clear of other timer counters operating in sync

   type TCR_Type is record
      TPSC     : Bits_3 := TPSC_ICLK;  -- Timer Prescaler 2–0
      CKEG     : Bits_2 := CKEG_REDGE; -- External Clock Edge 1/0
      CCLR     : Bits_2 := CCLR_NONE;  -- Counter Clear 1 and 0
      Reserved : Bits_1 := 0;
   end record
      with Bit_Order   => Low_Order_First,
           Object_Size => 8;
   for TCR_Type use record
      TPSC     at 0 range 0 .. 2;
      CKEG     at 0 range 3 .. 4;
      CCLR     at 0 range 5 .. 6;
      Reserved at 0 range 7 .. 7;
   end record;

   TCR0_ADDRESS : constant := 16#05FF_FF04#;
   TCR1_ADDRESS : constant := 16#05FF_FF0E#;
   TCR2_ADDRESS : constant := 16#05FF_FF18#;
   TCR3_ADDRESS : constant := 16#05FF_FF22#;
   TCR4_ADDRESS : constant := 16#05FF_FF32#;

   TCR0 : aliased TCR_Type
      with Address              => System'To_Address (TCR0_ADDRESS),
           Volatile_Full_Access => True,
           Import               => True,
           Convention           => Ada;

   TCR1 : aliased TCR_Type
      with Address              => System'To_Address (TCR1_ADDRESS),
           Volatile_Full_Access => True,
           Import               => True,
           Convention           => Ada;

   TCR2 : aliased TCR_Type
      with Address              => System'To_Address (TCR2_ADDRESS),
           Volatile_Full_Access => True,
           Import               => True,
           Convention           => Ada;

   TCR3 : aliased TCR_Type
      with Address              => System'To_Address (TCR3_ADDRESS),
           Volatile_Full_Access => True,
           Import               => True,
           Convention           => Ada;

   TCR4 : aliased TCR_Type
      with Address              => System'To_Address (TCR4_ADDRESS),
           Volatile_Full_Access => True,
           Import               => True,
           Convention           => Ada;

   -- 10.2.10 Timer I/O Control Register (TIOR)

   -- GRA is an output compare register
   IOA_OUTDISABLE : constant := 2#000#; -- Compare match with pin output disabled
   IOA_OUT0       : constant := 2#001#; -- 0 output at GRA compare match
   IOA_OUT1       : constant := 2#010#; -- 1 output at GRA compare match
   IOA_OUTTOGGLE  : constant := 2#011#; -- Output toggles at GRA compare match (1 output for channel 2 only)
   -- GRA is an input capture register
   IOA_INREDGE   : constant := 2#100#; -- GRA captures rising edge of input input capture
   IOA_INFEDGE   : constant := 2#101#; -- GRA captures falling edge of input
   IOA_INEDGES   : constant := 2#110#; -- GRA captures both edges of input
   IOA_INEDGES_2 : constant := 2#111#; -- GRA captures both edges of input

   -- GRB is an output compare register
   IOB_OUTDISABLE : constant := 2#000#; -- Compare match with pin output disabled
   IOB_OUT0       : constant := 2#001#; -- 0 output at GRB compare match
   IOB_OUT1       : constant := 2#010#; -- 1 output at GRB compare match
   IOB_OUTTOGGLE  : constant := 2#111#; -- Output toggles at GRB compare match (1 output for channel 2 only)
   -- GRB is an input capture register
   IOB_INREDGE   : constant := 2#100#; -- GRB captures rising edge of input
   IOB_INFEDGE   : constant := 2#101#; -- GRB captures falling edge of input
   IOB_INEDGES   : constant := 2#110#; -- GRB captures both edges of input
   IOB_INEDGES_2 : constant := 2#111#; -- GRB captures both edges of input

   type TIOR_Type is record
      IOA       : Bits_3 := IOA_OUTDISABLE; -- I/O Control A2–A0
      Reserved1 : Bits_1 := 1;
      IOB       : Bits_3 := IOB_OUTDISABLE; -- I/O Control B2–B0
      Reserved2 : Bits_1 := 0;
   end record
      with Bit_Order   => Low_Order_First,
           Object_Size => 8;
   for TIOR_Type use record
      IOA       at 0 range 0 .. 2;
      Reserved1 at 0 range 3 .. 3;
      IOB       at 0 range 4 .. 6;
      Reserved2 at 0 range 7 .. 7;
   end record;

   TIOR0_ADDRESS : constant := 16#05FF_FF05#;
   TIOR1_ADDRESS : constant := 16#05FF_FF0F#;
   TIOR2_ADDRESS : constant := 16#05FF_FF19#;
   TIOR3_ADDRESS : constant := 16#05FF_FF23#;
   TIOR4_ADDRESS : constant := 16#05FF_FF33#;

   TIOR0 : aliased TIOR_Type
      with Address              => System'To_Address (TIOR0_ADDRESS),
           Volatile_Full_Access => True,
           Import               => True,
           Convention           => Ada;

   TIOR1 : aliased TIOR_Type
      with Address              => System'To_Address (TIOR1_ADDRESS),
           Volatile_Full_Access => True,
           Import               => True,
           Convention           => Ada;

   TIOR2 : aliased TIOR_Type
      with Address              => System'To_Address (TIOR2_ADDRESS),
           Volatile_Full_Access => True,
           Import               => True,
           Convention           => Ada;

   TIOR3 : aliased TIOR_Type
      with Address              => System'To_Address (TIOR3_ADDRESS),
           Volatile_Full_Access => True,
           Import               => True,
           Convention           => Ada;

   TIOR4 : aliased TIOR_Type
      with Address              => System'To_Address (TIOR4_ADDRESS),
           Volatile_Full_Access => True,
           Import               => True,
           Convention           => Ada;

   -- 10.2.11 Timer Status Register (TSR)

   IMFA_CLEAR : constant Boolean := False;
   IMFB_CLEAR : constant Boolean := False;
   OVF_CLEAR  : constant Boolean := False;

   type TSR_Type is record
      IMFA      : Boolean := True;    -- Input Capture/Compare Match A
      IMFB      : Boolean := True;    -- Input Capture/Compare Match B
      OVF       : Boolean := True;    -- Overflow Flag
      Reserved1 : Bits_4  := 2#1111#;
      Reserved2 : Bits_1  := 0;
   end record
      with Bit_Order   => Low_Order_First,
           Object_Size => 8;
   for TSR_Type use record
      IMFA      at 0 range 0 .. 0;
      IMFB      at 0 range 1 .. 1;
      OVF       at 0 range 2 .. 2;
      Reserved1 at 0 range 3 .. 6;
      Reserved2 at 0 range 7 .. 7;
   end record;

   TSR0_ADDRESS : constant := 16#05FF_FF07#;
   TSR1_ADDRESS : constant := 16#05FF_FF11#;
   TSR2_ADDRESS : constant := 16#05FF_FF1B#;
   TSR3_ADDRESS : constant := 16#05FF_FF25#;
   TSR4_ADDRESS : constant := 16#05FF_FF35#;

   TSR0 : aliased TSR_Type
      with Address              => System'To_Address (TSR0_ADDRESS),
           Volatile_Full_Access => True,
           Import               => True,
           Convention           => Ada;

   TSR1 : aliased TSR_Type
      with Address              => System'To_Address (TSR1_ADDRESS),
           Volatile_Full_Access => True,
           Import               => True,
           Convention           => Ada;

   TSR2 : aliased TSR_Type
      with Address              => System'To_Address (TSR2_ADDRESS),
           Volatile_Full_Access => True,
           Import               => True,
           Convention           => Ada;

   TSR3 : aliased TSR_Type
      with Address              => System'To_Address (TSR3_ADDRESS),
           Volatile_Full_Access => True,
           Import               => True,
           Convention           => Ada;

   TSR4 : aliased TSR_Type
      with Address              => System'To_Address (TSR4_ADDRESS),
           Volatile_Full_Access => True,
           Import               => True,
           Convention           => Ada;

   -- 10.2.12 Timer Interrupt Enable Register (TIER)

   type TIER_Type is record
      IMIEA     : Boolean := False;   -- Input Capture/Compare Match Interrupt Enable A
      IMIEB     : Boolean := False;   -- Input Capture/Compare Match Interrupt Enable B
      OVIE      : Boolean := False;   -- Overflow Interrupt Enable
      Reserved1 : Bits_4  := 2#1111#;
      Reserved2 : Bits_1  := 0;
   end record
      with Bit_Order   => Low_Order_First,
           Object_Size => 8;
   for TIER_Type use record
      IMIEA     at 0 range 0 .. 0;
      IMIEB     at 0 range 1 .. 1;
      OVIE      at 0 range 2 .. 2;
      Reserved1 at 0 range 3 .. 6;
      Reserved2 at 0 range 7 .. 7;
   end record;

   TIER0_ADDRESS : constant := 16#05FF_FF06#;
   TIER1_ADDRESS : constant := 16#05FF_FF10#;
   TIER2_ADDRESS : constant := 16#05FF_FF1A#;
   TIER3_ADDRESS : constant := 16#05FF_FF24#;
   TIER4_ADDRESS : constant := 16#05FF_FF34#;

   TIER0 : aliased TIER_Type
      with Address              => System'To_Address (TIER0_ADDRESS),
           Volatile_Full_Access => True,
           Import               => True,
           Convention           => Ada;

   TIER1 : aliased TIER_Type
      with Address              => System'To_Address (TIER1_ADDRESS),
           Volatile_Full_Access => True,
           Import               => True,
           Convention           => Ada;

   TIER2 : aliased TIER_Type
      with Address              => System'To_Address (TIER2_ADDRESS),
           Volatile_Full_Access => True,
           Import               => True,
           Convention           => Ada;

   TIER3 : aliased TIER_Type
      with Address              => System'To_Address (TIER3_ADDRESS),
           Volatile_Full_Access => True,
           Import               => True,
           Convention           => Ada;

   TIER4 : aliased TIER_Type
      with Address              => System'To_Address (TIER4_ADDRESS),
           Volatile_Full_Access => True,
           Import               => True,
           Convention           => Ada;

   ----------------------------------------------------------------------------
   -- Section 12 Watchdog Timer (WDT)
   ----------------------------------------------------------------------------

   -- 12.2.1 Timer Counter (TCNT)

   -- TCNT register requires special handling

   TCNT_READ_ADDRESS  : constant := 16#05FF_FFB9#;
   TCNT_WRITE_ADDRESS : constant := 16#05FF_FFB8#;

   function TCNT_Read
      return Unsigned_8
      with Inline => True;
   procedure TCNT_Write
      (Value : in Unsigned_8)
      with Inline => True;

   -- 12.2.2 Timer Control/Status Register (TCSR)

   CKS_DIV2    : constant := 2#000#; -- φ/2 25.6 μs
   CKS_DIV64   : constant := 2#001#; -- φ/64 819.2 μs
   CKS_DIV128  : constant := 2#010#; -- φ/128 1.6 ms
   CKS_DIV256  : constant := 2#011#; -- φ/256 3.3 ms
   CKS_DIV512  : constant := 2#100#; -- φ/512 6.6 ms
   CKS_DIV1024 : constant := 2#101#; -- φ/1024 13.1 ms
   CKS_DIV4096 : constant := 2#110#; -- φ/4096 52.4 ms
   CKS_DIV8192 : constant := 2#111#; -- φ/8192 104.9 ms

   WTnIT_INTERVAL : constant := 0; -- Interval timer mode
   WTnIT_WATCHDOG : constant := 1; -- Watchdog timer mode

   -- OVF_CLEAR already defined at 10.2.11
   -- OVF_CLEAR : constant Boolean := False;

   type TCSR_Type is record
      CKS      : Bits_3  := CKS_DIV2;       -- Clock Select 2–0
      Reserved : Bits_2  := 2#11#;
      TME      : Boolean := False;          -- Timer Enable
      WTnIT    : Bits_1  := WTnIT_INTERVAL; -- Timer Mode Select
      OVF      : Boolean := True;           -- Overflow Flag
   end record
      with Bit_Order   => Low_Order_First,
           Object_Size => 8;
   for TCSR_Type use record
      CKS      at 0 range 0 .. 2;
      Reserved at 0 range 3 .. 4;
      TME      at 0 range 5 .. 5;
      WTnIT    at 0 range 6 .. 6;
      OVF      at 0 range 7 .. 7;
   end record;

   -- TCSR register requires special handling

   TCSR_READ_ADDRESS  : constant := 16#05FF_FFB8#;
   TCSR_WRITE_ADDRESS : constant := 16#05FF_FFB8#;

   function TCSR_Read
      return TCSR_Type
      with Inline => True;
   procedure TCSR_Write
      (Value : in TCSR_Type)
      with Inline => True;

   -- 12.2.3 Reset Control/Status Register (RSTCSR)

   RSTS_POWERON : constant := 0; -- Power-on reset
   RSTS_MANUAL  : constant := 1; -- Manual reset

   WOVF_CLEAR : constant Boolean := False;

   type RSTCSR_Type is record
      Reserved : Bits_5  := 2#11111#;
      RSTS     : Bits_1  := RSTS_POWERON; -- Reset Select
      RSTE     : Boolean := False;        -- Reset Enable
      WOVF     : Boolean := True;         -- Watchdog Timer Overflow
   end record
      with Bit_Order   => Low_Order_First,
           Object_Size => 8;
   for RSTCSR_Type use record
      Reserved at 0 range 0 .. 4;
      RSTS     at 0 range 5 .. 5;
      RSTE     at 0 range 6 .. 6;
      WOVF     at 0 range 7 .. 7;
   end record;

   -- RSTCSR register requires special handling

   RSTCSR_READ_ADDRESS  : constant := 16#05FF_FFBB#;
   RSTCSR_WRITE_ADDRESS : constant := 16#05FF_FFBA#;

   function RSTCSR_Read
      return RSTCSR_Type
      with Inline => True;
   procedure RSTCSR_WOVF_Clear
      with Inline => True;
   procedure RSTCSR_Write
      (RSTS : in Bits_1;
       RSTE : in Boolean)
      with Inline => True;

   ----------------------------------------------------------------------------
   -- Section 13 Serial Communication Interface (SCI)
   ----------------------------------------------------------------------------

   -- 13.2.1 Receive Shift Register
   -- 13.2.2 Receive Data Register
   -- 13.2.3 Transmit Shift Register
   -- 13.2.4 Transmit Data Register

   -- 13.2.5 Serial Mode Register

   CKS_SYSCLOCK       : constant := 2#00#; -- System clock (φ)
   CKS_SYSCLOCK_DIV4  : constant := 2#01#; -- φ/4
   CKS_SYSCLOCK_DIV16 : constant := 2#10#; -- φ/16
   CKS_SYSCLOCK_DIV64 : constant := 2#11#; -- φ/64

   STOP_1 : constant := 0; -- One stop bit
   STOP_2 : constant := 1; -- Two stop bits.

   OE_EVEN : constant := 0; -- Even parity
   OE_ODD  : constant := 1; -- Odd parity

   CHR_8 : constant := 0; -- Eight-bit data
   CHR_7 : constant := 1; -- Seven-bit data.

   CA_ASYNC : constant := 0; -- Asynchronous mode
   CA_SYNC  : constant := 1; -- Synchronous mode

   type SMR_Type is record
      CKS  : Bits_2   := CKS_SYSCLOCK; -- Clock Select 1 and 0
      MP   : Boolean  := False;        -- Multiprocessor Mode
      STOP : Bits_1   := STOP_1;       -- Stop Bit Length
      OE   : Bits_1   := OE_EVEN;      -- Parity Mode
      PE   : Boolean  := False;        -- Parity Enable
      CHR  : Bits_1   := CHR_8;        -- Character Length
      CA   : Bits_1   := CA_ASYNC;     -- Communication Mode
   end record
      with Bit_Order   => Low_Order_First,
           Object_Size => 8;
   for SMR_Type use record
      CKS  at 0 range 0 .. 1;
      MP   at 0 range 2 .. 2;
      STOP at 0 range 3 .. 3;
      OE   at 0 range 4 .. 4;
      PE   at 0 range 5 .. 5;
      CHR  at 0 range 6 .. 6;
      CA   at 0 range 7 .. 7;
   end record;

   -- 13.2.6 Serial Control Register

   CKE_ASYNC_INTCLK_SCKIO   : constant := 2#00#; -- Asynchronous mode Internal clock, SCK pin used for input pin (input signal is ignored) or output pin (output level is undefined)
   CKE_SYNC_INTCLK_SCKOUT   : constant := 2#00#; -- Synchronous mode Internal clock, SCK pin used for serial clock output
   CKE_ASYNC_INTCLK_SCKOUT  : constant := 2#01#; -- Asynchronous mode Internal clock, SCK pin used for clock output
   CKE_SYNC_INTCLK_SCKOUT_2 : constant := 2#01#; -- Synchronous mode Internal clock, SCK pin used for serial clock output
   CKE_ASYNC_EXTCLK_SCKIN   : constant := 2#10#; -- Asynchronous mode External clock, SCK pin used for clock input
   CKE_SYNC_EXTCLK_SCKOUT   : constant := 2#10#; -- Synchronous mode External clock, SCK pin used for serial clock input
   CKE_ASYNC_EXTCLK_SCKIN_2 : constant := 2#11#; -- Asynchronous mode External clock, SCK pin used for clock input
   CKE_SYNC_EXTCLK_SCKIN    : constant := 2#11#; -- Synchronous mode External clock, SCK pin used for serial clock input

   type SCR_Type is record
      CKE  : Bits_2  := CKE_ASYNC_INTCLK_SCKIO; -- Clock Enable 1 and 0 (CKE1 and CKE0)
      TEIE : Boolean := False;                  -- Transmit-End Interrupt Enable (TEIE)
      MPIE : Boolean := False;                  -- Multiprocessor Interrupt Enable (MPIE)
      RE   : Boolean := False;                  -- Receive Enable (RE)
      TE   : Boolean := False;                  -- Transmit Enable (TE)
      RIE  : Boolean := False;                  -- Receive Interrupt Enable (RIE)
      TIE  : Boolean := False;                  -- Transmit Interrupt Enable (TIE)
   end record
      with Bit_Order   => Low_Order_First,
           Object_Size => 8;
   for SCR_Type use record
      CKE  at 0 range 0 .. 1;
      TEIE at 0 range 2 .. 2;
      MPIE at 0 range 3 .. 3;
      RE   at 0 range 4 .. 4;
      TE   at 0 range 5 .. 5;
      RIE  at 0 range 6 .. 6;
      TIE  at 0 range 7 .. 7;
   end record;

   -- 13.2.7 Serial Status Register

   type SSR_Type is record
      MPBT : Bits_1  := 0;     -- Multiprocessor Bit Transfer (MPBT)
      MPB  : Bits_1  := 0;     -- Multiprocessor Bit (MPB)
      TEND : Boolean := False; -- Transmit End (TEND)
      PER  : Boolean := True;  -- Parity Error (PER)
      FER  : Boolean := True;  -- Framing Error (FER)
      ORER : Boolean := True;  -- Overrun Error (ORER)
      RDRF : Boolean := True;  -- Receive Data Register Full (RDRF)
      TDRE : Boolean := True;  -- Transmit Data Register Empty (TDRE)
   end record
      with Bit_Order   => Low_Order_First,
           Object_Size => 8;
   for SSR_Type use record
      MPBT at 0 range 0 .. 0;
      MPB  at 0 range 1 .. 1;
      TEND at 0 range 2 .. 2;
      PER  at 0 range 3 .. 3;
      FER  at 0 range 4 .. 4;
      ORER at 0 range 5 .. 5;
      RDRF at 0 range 6 .. 6;
      TDRE at 0 range 7 .. 7;
   end record;

   -- 13.2.8 Bit Rate Register (BRR)

   -- 13.1.4 Register Configuration

   type SCI_Type is record
      SMR : SMR_Type   with Volatile_Full_Access => True;
      BRR : Unsigned_8 with Volatile_Full_Access => True;
      SCR : SCR_Type   with Volatile_Full_Access => True;
      TDR : Unsigned_8 with Volatile_Full_Access => True;
      SSR : SSR_Type   with Volatile_Full_Access => True;
      RDR : Unsigned_8 with Volatile_Full_Access => True;
   end record
      with Object_Size => 6 * 8;
   for SCI_Type use record
      SMR at 0 range 0 .. 7;
      BRR at 1 range 0 .. 7;
      SCR at 2 range 0 .. 7;
      TDR at 3 range 0 .. 7;
      SSR at 4 range 0 .. 7;
      RDR at 5 range 0 .. 7;
   end record;

   SCI0_BASEADDRESS : constant := 16#05FF_FEC0#;

   SCI0 : aliased SCI_Type
      with Address    => System'To_Address (SCI0_BASEADDRESS),
           Volatile   => True,
           Import     => True,
           Convention => Ada;

   SCI1_BASEADDRESS : constant := 16#05FF_FEC8#;

   SCI1 : aliased SCI_Type
      with Address    => System'To_Address (SCI1_BASEADDRESS),
           Volatile   => True,
           Import     => True,
           Convention => Ada;

   ----------------------------------------------------------------------------
   -- Section 14 A/D Converter
   ----------------------------------------------------------------------------

   -- 14.2.1 A/D Data Registers A–D (ADDRA–ADDRD)

   ADDRA_ADDRESS : constant := 16#05FF_FEE0#;

   ADDRAH : aliased Unsigned_8
      with Address              => System'To_Address (ADDRA_ADDRESS),
           Volatile_Full_Access => True,
           Import               => True,
           Convention           => Ada;

   ADDRAL : aliased Unsigned_8
      with Address              => System'To_Address (ADDRA_ADDRESS + 1),
           Volatile_Full_Access => True,
           Import               => True,
           Convention           => Ada;

   ADDRA : aliased Unsigned_16
      with Address              => System'To_Address (ADDRA_ADDRESS),
           Volatile_Full_Access => True,
           Import               => True,
           Convention           => Ada;

   ADDRB_ADDRESS : constant := 16#05FF_FEE2#;

   ADDRBH : aliased Unsigned_8
      with Address              => System'To_Address (ADDRB_ADDRESS),
           Volatile_Full_Access => True,
           Import               => True,
           Convention           => Ada;

   ADDRBL : aliased Unsigned_8
      with Address              => System'To_Address (ADDRB_ADDRESS + 1),
           Volatile_Full_Access => True,
           Import               => True,
           Convention           => Ada;

   ADDRB : aliased Unsigned_16
      with Address              => System'To_Address (ADDRB_ADDRESS),
           Volatile_Full_Access => True,
           Import               => True,
           Convention           => Ada;

   ADDRC_ADDRESS : constant := 16#05FF_FEE4#;

   ADDRCH : aliased Unsigned_8
      with Address              => System'To_Address (ADDRC_ADDRESS),
           Volatile_Full_Access => True,
           Import               => True,
           Convention           => Ada;

   ADDRCL : aliased Unsigned_8
      with Address              => System'To_Address (ADDRC_ADDRESS + 1),
           Volatile_Full_Access => True,
           Import               => True,
           Convention           => Ada;

   ADDRC : aliased Unsigned_16
      with Address              => System'To_Address (ADDRC_ADDRESS),
           Volatile_Full_Access => True,
           Import               => True,
           Convention           => Ada;

   ADDRD_ADDRESS : constant := 16#05FF_FEE6#;

   ADDRDH : aliased Unsigned_8
      with Address              => System'To_Address (ADDRD_ADDRESS),
           Volatile_Full_Access => True,
           Import               => True,
           Convention           => Ada;

   ADDRDL : aliased Unsigned_8
      with Address              => System'To_Address (ADDRD_ADDRESS + 1),
           Volatile_Full_Access => True,
           Import               => True,
           Convention           => Ada;

   ADDRD : aliased Unsigned_16
      with Address              => System'To_Address (ADDRD_ADDRESS),
           Volatile_Full_Access => True,
           Import               => True,
           Convention           => Ada;

   -- 14.2.2 A/D Control/Status Register (ADCSR)

   -- Single Mode
   CH_SINGLE_AN0  : constant := 2#000#; -- AN0
   CH_SINGLE_AN1  : constant := 2#001#; -- AN1
   CH_SINGLE_AN2  : constant := 2#010#; -- AN2
   CH_SINGLE_AN3  : constant := 2#011#; -- AN3
   CH_SINGLE_AN4  : constant := 2#100#; -- AN4
   CH_SINGLE_AN5  : constant := 2#101#; -- AN5
   CH_SINGLE_AN6  : constant := 2#110#; -- AN6
   CH_SINGLE_AN7  : constant := 2#111#; -- AN7
   -- Scan Mode
   CH_SCAN_AN0    : constant := 2#000#; -- AN0
   CH_SCAN_AN01   : constant := 2#001#; -- AN0 and AN1
   CH_SCAN_AN012  : constant := 2#010#; -- AN0–AN2
   CH_SCAN_AN0123 : constant := 2#011#; -- AN0–AN3
   CH_SCAN_AN4    : constant := 2#100#; -- AN4
   CH_SCAN_AN45   : constant := 2#101#; -- AN4 and AN5
   CH_SCAN_AN456  : constant := 2#110#; -- AN4–AN6
   CH_SCAN_AN4567 : constant := 2#111#; -- AN4–AN7

   CKS_266 : constant := 0; -- Conversion time = 266 states (maximum)
   CKS_134 : constant := 1; -- Conversion time = 134 states (maximum)

   SCAN_SINGLE : constant := 0; -- Single mode
   SCAN_SCAN   : constant := 1; -- Scan mode

   type ADCSR_Type is record
      CH   : Bits_3  := CH_SINGLE_AN0; -- Channel Select
      CKS  : Bits_1  := CKS_266;       -- Clock Select
      SCAN : Bits_1  := SCAN_SINGLE;   -- Scan Mode
      ADST : Boolean := False;         -- A/D Start
      ADIE : Boolean := False;         -- A/D Interrupt Enable
      ADF  : Boolean := True;          -- A/D End Flag
   end record
      with Object_Size => 8;
   for ADCSR_Type use record
      CH   at 0 range 0 .. 2;
      CKS  at 0 range 3 .. 3;
      SCAN at 0 range 4 .. 4;
      ADST at 0 range 5 .. 5;
      ADIE at 0 range 6 .. 6;
      ADF  at 0 range 7 .. 7;
   end record;

   ADCSR_ADDRESS : constant := 16#05FF_FEE8#;

   ADCSR : aliased Unsigned_8
      with Address              => System'To_Address (ADCSR_ADDRESS),
           Volatile_Full_Access => True,
           Import               => True,
           Convention           => Ada;

   -- 14.2.3 A/D Control Register (ADCR)

   type ADCR_Type is record
      TRGE     : Boolean := False;      -- Trigger Enable
      Reserved : Bits_7  := 2#1111111#;
   end record
      with Object_Size => 8;
   for ADCR_Type use record
      TRGE     at 0 range 0 .. 0;
      Reserved at 0 range 1 .. 7;
   end record;

   ADCR_ADDRESS : constant := 16#05FF_FEE9#;

   ADCR : aliased Unsigned_8
      with Address              => System'To_Address (ADCR_ADDRESS),
           Volatile_Full_Access => True,
           Import               => True,
           Convention           => Ada;

   ----------------------------------------------------------------------------
   -- Section 15 Pin Function Controller (PFC)
   ----------------------------------------------------------------------------

   type LEBitmap_8_IDX_Type  is (bi7, bi6, bi5, bi4, bi3, bi2, bi1, bi0);
   type LEBitmap_16_IDX_Type is (bi15, bi14, bi13, bi12, bi11, bi10, bi9, bi8,
                                 bi7,  bi6,  bi5,  bi4,  bi3,  bi2,  bi1, bi0);

   type LEBitmap_8  is array (LEBitmap_8_IDX_Type) of Boolean
      with Component_Size => 1,
           Object_Size    => 8;
   type LEBitmap_16 is array (LEBitmap_16_IDX_Type) of Boolean
      with Component_Size => 1,
           Object_Size    => 16;

   -- 15.3.1 Port A I/O Register (PAIOR)

   type PAIOR_Type is record
      PA : LEBitmap_16 := [others => False];
   end record
      with Bit_Order   => Low_Order_First,
           Object_Size => 16;
   for PAIOR_Type use record
      PA at 0 range 0 .. 15;
   end record;

   -- 15.3.2 Port A Control Registers (PACR1 and PACR2)

   PA8_PA8  : constant := 0; -- Input/output (PA8)
   PA8_BREQ : constant := 1; -- Bus request input (/BREQ)

   PA9_PA9    : constant := 2#00#; -- Input/output (PA9)
   PA9_AH     : constant := 2#01#; -- Address hold output (AH)
   PA9_ADTRG  : constant := 2#10#; -- A/D conversion trigger input (/ADTRG)
   PA9_IRQOUT : constant := 2#11#; -- Interrupt request output (/IRQOUT)

   PA10_PA10   : constant := 2#00#; -- Input/output (PA10)
   PA10_DPL    : constant := 2#01#; -- Lower data bus parity input/output (DPL)
   PA10_TIOCA1 : constant := 2#10#; -- ITU input capture/output compare (TIOCA1)
   PA10_RSVD   : constant := 2#11#; -- Reserved

   PA11_PA11   : constant := 2#00#; -- Input/output (PA11)
   PA11_DPH    : constant := 2#01#; -- Upper data bus parity input/output (DPH)
   PA11_TIOCB1 : constant := 2#10#; -- ITU input capture/output compare (TIOCB1)
   PA11_RSVD   : constant := 2#11#; -- Reserved

   PA12_PA12  : constant := 2#00#; -- Input/output (PA12)
   PA12_IRQ0  : constant := 2#01#; -- Interrupt request input (/IRQ0)
   PA12_TCLKA : constant := 2#10#; -- ITU timer clock input (TCLKA)
   PA12_DACK0 : constant := 2#11#; -- DMA transfer acknowledge output (DACK0)

   PA13_PA13  : constant := 2#00#; -- Input/output (PA13)
   PA13_IRQ1  : constant := 2#01#; -- Interrupt request input (/IRQ1)
   PA13_TCLKB : constant := 2#10#; -- ITU timer clock input (TCLKB)
   PA13_DREQ0 : constant := 2#11#; -- DMA transfer request input (/DREQ0)

   PA14_PA14  : constant := 2#00#; -- Input/output (PA14)
   PA14_IRQ2  : constant := 2#01#; -- Interrupt request input (/IRQ2)
   PA14_RSVD  : constant := 2#10#; -- Reserved
   PA14_DACK1 : constant := 2#11#; -- DMA transfer acknowledge output (DACK1)

   PA15_PA15  : constant := 2#00#; -- Input/output (PA15)
   PA15_IRQ3  : constant := 2#01#; -- Interrupt request input (/IRQ3)
   PA15_RSVD  : constant := 2#10#; -- Reserved
   PA15_DREQ1 : constant := 2#11#; -- DMA transfer request input (DREQ1)

   type PACR1_Type is record
      PA8    : Bits_1 := PA8_PA8;    -- PA8 Mode (PA8MD): PA8MD selects the function of the PA8//BREQ pin.
      Unused : Bits_1 := 1;
      PA9    : Bits_2 := PA9_PA9;    -- PA9 Mode (PA9MD1 and PA9MD0): PA9MD1 and PA9MD0 select the function of the PA9/AH//IRQOUT//ADTRG pin.
      PA10   : Bits_2 := PA10_PA10;  -- PA10 Mode (PA10MD1 and PA10MD0): PA10MD1 and MA10MD0 select the function of the PA10/DPL/TIOCA1 pin.
      PA11   : Bits_2 := PA11_PA11;  -- PA11 Mode (PA11MD1 and PA11MD0): PA11MD1 and PA11MD0 select the function of the PA11/DPH/TIOCB1 pin.
      PA12   : Bits_2 := PA12_DACK0; -- PA12 Mode (PA12MD1 and PA12MD0): PA12MD1 and PA12MD0 select the function of the PA12//IRQ0/DACK0/TCLKA pin.
      PA13   : Bits_2 := PA13_PA13;  -- PA13 Mode (PA13MD1 and PA13MD0): PA13MD1 and PA13MD0 select the function of the PA13//IRQ1//DREQ0/TCLKB pin.
      PA14   : Bits_2 := PA14_DACK1; -- PA14 Mode (PA14MD1 and PA14MD0): PA14MD1 and PA14MD0 select the function of the PA14//IRQ2/DACK1 pin.
      PA15   : Bits_2 := PA15_PA15;  -- PA15 Mode (PA15MD1 and PA15MD0): PA15MD1 and PA15MD0 select the function of the PA15//IRQ3//DREQ1 pin.
   end record
      with Bit_Order   => Low_Order_First,
           Object_Size => 16;
   for PACR1_Type use record
      PA8    at 0 range  0 ..  0;
      Unused at 0 range  1 ..  1;
      PA9    at 0 range  2 ..  3;
      PA10   at 0 range  4 ..  5;
      PA11   at 0 range  6 ..  7;
      PA12   at 0 range  8 ..  9;
      PA13   at 0 range 10 .. 11;
      PA14   at 0 range 12 .. 13;
      PA15   at 0 range 14 .. 15;
   end record;

   PACR1 : aliased PACR1_Type
      with Address              => System'To_Address (16#05FF_FFC8#),
           Volatile_Full_Access => True,
           Import               => True,
           Convention           => Ada;

   PA0_PA0    : constant := 2#00#; -- Input/output (PA0)
   PA0_CS4    : constant := 2#01#; -- Chip select output (CS4)
   PA0_TIOCA0 : constant := 2#10#; -- ITU input capture/output compare (TIOCA0)
   PA0_RSVD   : constant := 2#11#; -- Reserved

   PA1_PA1  : constant := 2#00#; -- Input/output (PA1)
   PA1_CS5  : constant := 2#01#; -- Chip select output (/CS5)
   PA1_RAS  : constant := 2#10#; -- Row address strobe output (/RAS)
   PA1_RSVD : constant := 2#11#; -- Reserved

   PA2_PA2    : constant := 2#00#; -- Input/output (PA2)
   PA2_CS6    : constant := 2#01#; -- Chip select output (/CS6)
   PA2_TIOCB0 : constant := 2#10#; -- ITU input capture/output compare (TIOCB0)
   PA2_RSVD   : constant := 2#11#; -- Reserved

   PA3_PA3  : constant := 2#00#; -- Input/output (PA3)
   PA3_CS7  : constant := 2#01#; -- Chip select output (/CS7)
   PA3_WAIT : constant := 2#10#; -- Wait state input (/WAIT)
   PA3_RSVD : constant := 2#11#; -- Reserved

   PA4_PA4 : constant := 0; -- Input/output (PA4)
   PA4_WRL : constant := 1; -- Lower write output (/WRL) or write output (/WR)

   PA5_PA5 : constant := 0; -- Input/output (PA5)
   PA5_WRH : constant := 1; -- Upper write output (/WRH) or lower byte strobe output (/LBS)

   PA6_PA6 : constant := 0; -- Input/output (PA6)
   PA6_RD  : constant := 1; -- Read output (/RD)

   PA7_PA7  : constant := 0; -- Input/output (PA7)
   PA7_BACK : constant := 1; -- Bus request acknowledge output (/BACK)

   type PACR2_Type is record
      PA0     : Bits_2 := PA0_CS4;  -- PA0 Mode (PA0MD1 and PA0MD0): PA0MD1 and PA0MD0 select the function of the PA0//CS4/TIOCA0 pin.
      PA1     : Bits_2 := PA1_CS5;  -- PA1 Mode (PA1MD1 and PA1MD0): PA1MD1 and PA1MD0 select the function of the PA1//CS5//RAS pin.
      PA2     : Bits_2 := PA2_CS6;  -- PA2 Mode (PA2MD1 and PA2MD0): PA2MD1 and PA2MD0 select the function of the PA2//CS6/TIOCB0 pin.
      PA3     : Bits_2 := PA3_WAIT; -- PA3 Mode (PA3MD1 and PA3MD0): PA3MD1 and PA3MD0 select the function of the PA3//CS7//WAIT pin.
      PA4     : Bits_1 := PA4_WRL;  -- PA4 Mode (PA4MD): PA4MD selects the function of the PA4//WRL (/WR) pin.
      Unused1 : Bits_1 := 1;
      PA5     : Bits_1 := PA5_WRH;  -- PA5 Mode (PA5MD): PA5MD selects the function of the PA5//WRH (/LBS) pin.
      Unused2 : Bits_1 := 1;
      PA6     : Bits_1 := PA6_RD;   -- PA6 Mode (PA6MD): PA6MD selects the function of the PA6//RD pin.
      Unused3 : Bits_1 := 1;
      PA7     : Bits_1 := PA7_BACK; -- PA7 Mode (PA7MD): PA7MD selects the function of the PA7//BACK pin.
      Unused4 : Bits_1 := 1;
   end record
      with Bit_Order   => Low_Order_First,
           Object_Size => 16;
   for PACR2_Type use record
      PA0     at 0 range  0 ..  1;
      PA1     at 0 range  2 ..  3;
      PA2     at 0 range  4 ..  5;
      PA3     at 0 range  6 ..  7;
      PA4     at 0 range  8 ..  8;
      Unused1 at 0 range  9 ..  9;
      PA5     at 0 range 10 .. 10;
      Unused2 at 0 range 11 .. 11;
      PA6     at 0 range 12 .. 12;
      Unused3 at 0 range 13 .. 13;
      PA7     at 0 range 14 .. 14;
      Unused4 at 0 range 15 .. 15;
   end record;

   PACR2 : aliased PACR2_Type
      with Address              => System'To_Address (16#05FF_FFCA#),
           Volatile_Full_Access => True,
           Import               => True,
           Convention           => Ada;

   -- 15.3.3 Port B I/O Register (PBIOR)

   type PBIOR_Type is record
      PB : LEBitmap_16 := [others => False];
   end record
      with Bit_Order   => Low_Order_First,
           Object_Size => 16;
   for PBIOR_Type use record
      PB at 0 range 0 .. 15;
   end record;

   PBIOR : aliased PBIOR_Type
      with Address              => System'To_Address (16#05FF_FFC6#),
           Volatile_Full_Access => True,
           Import               => True,
           Convention           => Ada;

   -- 15.3.4 Port B Control Registers (PBCR1 and PBCR2)

   PB8_PB8  : constant := 2#00#; -- Input/output (PB8)
   PB8_RSVD : constant := 2#01#; -- Reserved
   PB8_RxD0 : constant := 2#10#; -- Receive data input (RxD0)
   PB8_TP8  : constant := 2#11#; -- Timing pattern output (TP8)

   PB9_PB9  : constant := 2#00#; -- Input/output (PB9)
   PB9_RSVD : constant := 2#01#; -- Reserved
   PB9_TxD0 : constant := 2#10#; -- Transmit data output (TxD0)
   PB9_TP9  : constant := 2#11#; -- Timing pattern output (TP9)

   PB10_PB10 : constant := 2#00#; -- Input/output (PB10)
   PB10_RSVD : constant := 2#01#; -- Reserved
   PB10_RxD1 : constant := 2#10#; -- Receive data input (RxD1)
   PB10_TP10 : constant := 2#11#; -- Timing pattern output (TP10)

   PB11_PB11 : constant := 2#00#; -- Input/output (PB11)
   PB11_RSVD : constant := 2#01#; -- Reserved
   PB11_TxD1 : constant := 2#10#; -- Transmit data output (TxD1)
   PB11_TP11 : constant := 2#11#; -- Timing pattern output (TP11)

   PB12_PB12 : constant := 2#00#; -- Input/output (PB12)
   PB12_IRQ4 : constant := 2#01#; -- Interrupt request input (/IRQ4)
   PB12_SCK0 : constant := 2#10#; -- Serial clock input/output (SCK0)
   PB12_TP12 : constant := 2#11#; -- Timing pattern output (TP12)

   PB13_PB13 : constant := 2#00#; -- Input/output (PB13)
   PB13_IRQ5 : constant := 2#01#; -- Interrupt request input (/IRQ5)
   PB13_SCK1 : constant := 2#10#; -- Serial clock input/output (SCK1)
   PB13_TP13 : constant := 2#11#; -- Timing pattern output (TP13)

   PB14_PB14 : constant := 2#00#; -- Input/output (PB14)
   PB14_IRQ6 : constant := 2#01#; -- Interrupt request input (/IRQ6)
   PB14_RSVD : constant := 2#10#; -- Reserved
   PB14_TP14 : constant := 2#11#; -- Timing pattern output (TP14)

   PB15_PB15 : constant := 2#00#; -- Input/output (PB15)
   PB15_IRQ7 : constant := 2#01#; -- Interrupt request input (/IRQ7)
   PB15_RSVD : constant := 2#10#; -- Reserved
   PB15_TP15 : constant := 2#11#; -- Timing pattern output (TP15)

   type PBCR1_Type is record
      PB8  : Bits_2 := PB8_PB8;   -- PB8 Mode (PB8MD1 and PB8MD0): PB8MD1 and PB8MD0 select the function of the PB8/TP8/RxD0 pin.
      PB9  : Bits_2 := PB9_PB9;   -- PB9 Mode (PB9MD1 and PB9MD0): PB9MD1 and PB9MD0 select the function of the PB9/TP9/TxD0 pin.
      PB10 : Bits_2 := PB10_PB10; -- PB10 Mode (PB10MD1 and PB10MD0): PB10MD1 and PB10MD0 select the function of the PB10/TP10/RxD1 pin.
      PB11 : Bits_2 := PB11_PB11; -- PB11 Mode—PB11MD1 and PB11MD0): PB11MD1 and PB11MD0 select the function of the PB11/TP11/TxD1 pin.
      PB12 : Bits_2 := PB12_PB12; -- PB12 Mode (PB12MD1 and PB12MD0): PB12MD1 and PB12MD0 select the function of the PB12/TP12//IRQ4/SCK0 pin.
      PB13 : Bits_2 := PB13_PB13; -- PB13 Mode (PB13MD1 and PB13MD0): PB13MD1 and PB13MD0 select the function of the PB13/TP13//IRQ5/SCK1 pin.
      PB14 : Bits_2 := PB14_PB14; -- PB14 Mode (PB14MD1 and PB14MD0): PB14MD1 and PB14MD0 select the function of the PB14/TP14//IRQ6 pin.
      PB15 : Bits_2 := PB15_PB15; -- PB15 Mode (PB15MD1 and PB15MD0): PB15MD1 and PB15MD0 select the function of the PB15/TP15//IRQ7 pin.
   end record
      with Bit_Order   => Low_Order_First,
           Object_Size => 16;
   for PBCR1_Type use record
      PB8  at 0 range  0 ..  1;
      PB9  at 0 range  2 ..  3;
      PB10 at 0 range  4 ..  5;
      PB11 at 0 range  6 ..  7;
      PB12 at 0 range  8 ..  9;
      PB13 at 0 range 10 .. 11;
      PB14 at 0 range 12 .. 13;
      PB15 at 0 range 14 .. 15;
   end record;

   PBCR1 : aliased PBCR1_Type
      with Address              => System'To_Address (16#05FF_FFCC#),
           Volatile_Full_Access => True,
           Import               => True,
           Convention           => Ada;

   PB0_PB0    : constant := 2#00#; -- Input/output (PB0)
   PB0_RSVD   : constant := 2#01#; -- Reserved
   PB0_TIOCA2 : constant := 2#10#; -- ITU input capture/output compare (TIOCA2)
   PB0_TP0    : constant := 2#11#; -- Timing pattern output (TP0)

   PB1_PB1    : constant := 2#00#; -- Input/output (PB1)
   PB1_RSVD   : constant := 2#01#; -- Reserved
   PB1_TIOCB2 : constant := 2#10#; -- ITU input capture/output compare (TIOCB2)
   PB1_TP1    : constant := 2#11#; -- Timing pattern output (TP1)

   PB2_PB2    : constant := 2#00#; -- Input/output (PB2)
   PB2_RSVD   : constant := 2#01#; -- Reserved
   PB2_TIOCA3 : constant := 2#10#; -- ITU input capture/output compare (TIOCA3)
   PB2_TP2    : constant := 2#11#; -- Timing pattern output (TP2)

   PB3_PB3    : constant := 2#00#; -- Input/output (PB3)
   PB3_RSVD   : constant := 2#01#; -- Reserved
   PB3_TIOCB3 : constant := 2#10#; -- ITU input capture/output compare (TIOCB3)
   PB3_TP3    : constant := 2#11#; -- Timing pattern output (TP3)

   PB4_PB4    : constant := 2#00#; -- Input/output (PB4)
   PB4_RSVD   : constant := 2#01#; -- Reserved
   PB4_TIOCA4 : constant := 2#10#; -- ITU input capture/output compare (TIOCA4)
   PB4_TP4    : constant := 2#11#; -- Timing pattern output (TP4)

   PB5_PB5    : constant := 2#00#; -- Input/output (PB5)
   PB5_RSVD   : constant := 2#01#; -- Reserved
   PB5_TIOCB4 : constant := 2#10#; -- ITU input capture/output compare (TIOCB4)
   PB5_TP5    : constant := 2#11#; -- Timing pattern output (TP5)

   PB6_PB6    : constant := 2#00#; -- Input/output (PB6)
   PB6_TCLKC  : constant := 2#01#; -- ITU timer clock input (TCLKC)
   PB6_TOCXA4 : constant := 2#10#; -- ITU output compare (TOCXA4)
   PB6_TP6    : constant := 2#11#; -- Timing pattern output (TP6)

   PB7_PB7    : constant := 2#00#; -- Input/output (PB7)
   PB7_TCLKD  : constant := 2#01#; -- ITU timer clock input (TCLKD)
   PB7_TOCXB4 : constant := 2#10#; -- ITU output compare (TOCXB4)
   PB7_TP7    : constant := 2#11#; -- Timing pattern output (TP7)

   type PBCR2_Type is record
      PB0 : Bits_2 := PB0_PB0; -- PB0 Mode (PB0MD1 and PB0MD0): PB0MD1 and PB0MD0 select the function of the PB0/TP0/TIOCA2 pin.
      PB1 : Bits_2 := PB1_PB1; -- PB1 Mode (PB1MD1 and PB1MD0): PB1MD1 and PB1MD0 select the function of the PB1/TP1/TIOCB2 pin.
      PB2 : Bits_2 := PB2_PB2; -- PB2 Mode (PB2MD1 and PB2MD0): PB2MD1 and PB2MD0 select the function of the PB2/TP2/TIOCA3 pin.
      PB3 : Bits_2 := PB3_PB3; -- PB3 Mode (PB3MD1 and PB3MD0): PB3MD1 and PB3MD0 select the function of the PB3/TP3/TIOCB3 pin.
      PB4 : Bits_2 := PB4_PB4; -- PB4 Mode (PB4MD1 and PB4MD0): PB4MD1 and PB4MD0 select the function of the PB4/TP4/TIOCA4 pin.
      PB5 : Bits_2 := PB5_PB5; -- PB5 Mode (PB5MD1 and PB5MD0): PB5MD1 and PB5MD0 select the function of the PB5/TP5/TIOCB4 pin.
      PB6 : Bits_2 := PB6_PB6; -- PB6 Mode (PB6MD1 and PB6MD0): PB6MD1 and PB6MD0 select the function of the PB6/TP6/TOCXA4/TCLKC pin.
      PB7 : Bits_2 := PB7_PB7; -- PB7 Mode (PB7MD1 and PB7MD0): PB7MD1 and PB7MD0 select the function of the PB7/TP7/TOCXB4/TCLKD pin.
   end record
      with Bit_Order   => Low_Order_First,
           Object_Size => 16;
   for PBCR2_Type use record
      PB0 at 0 range  0 ..  1;
      PB1 at 0 range  2 ..  3;
      PB2 at 0 range  4 ..  5;
      PB3 at 0 range  6 ..  7;
      PB4 at 0 range  8 ..  9;
      PB5 at 0 range 10 .. 11;
      PB6 at 0 range 12 .. 13;
      PB7 at 0 range 14 .. 15;
   end record;

   PBCR2 : aliased PBCR2_Type
      with Address              => System'To_Address (16#05FF_FFCE#),
           Volatile_Full_Access => True,
           Import               => True,
           Convention           => Ada;

   -- 15.3.5 Column Address Strobe Pin Control Register (CASCR)

   CASL_RSVD1 : constant := 2#00#; -- Reserved
   CASL_CS3   : constant := 2#01#; -- Chip select output (/CS3)
   CASL_CASL  : constant := 2#10#; -- Column address strobe output (/CASL)
   CASL_RSVD2 : constant := 2#11#; -- Reserved

   CASH_RSVD1 : constant := 2#00#; -- Reserved
   CASH_CS1   : constant := 2#01#; -- Chip select output (/CS1)
   CASH_CASH  : constant := 2#10#; -- Column address strobe output (/CASH)
   CASH_RSVD2 : constant := 2#11#; -- Reserved

   type CASCR_Type is record
      Unused : Bits_12 := 16#FFF#;
      CASL   : Bits_2  := CASL_CS3; -- CASL Mode (CASLMD1 and CASLMD0): CASLMD1 and CASLMD0 select the function of the /CS3//CASL pin.
      CASH   : Bits_2  := CASH_CS1; -- CASH Mode (CASHMD1 and CASHMD0): CASHMD1 and CASHMD0 select the function of the /CS1//CASH pin.
   end record
      with Bit_Order   => Low_Order_First,
           Object_Size => 16;
   for CASCR_Type use record
      Unused at 0 range  0 .. 11;
      CASL   at 0 range 12 .. 13;
      CASH   at 0 range 14 .. 15;
   end record;

   CASCR : aliased CASCR_Type
      with Address              => System'To_Address (16#05FF_FFEE#),
           Volatile_Full_Access => True,
           Import               => True,
           Convention           => Ada;

   ----------------------------------------------------------------------------
   -- Section 19 Power-Down State
   ----------------------------------------------------------------------------

   -- 19.2 Standby Control Register (SBYCR)

   type SBYCR_Type is record
      Reserved : Bits_6  := 2#011111#;
      HIZ      : Boolean := False;     -- Port High-Impedance
      SBY      : Boolean := False;     -- Standby
   end record
      with Bit_Order   => Low_Order_First,
           Object_Size => 8;
   for SBYCR_Type use record
      Reserved at 0 range 0 .. 5;
      HIZ      at 0 range 6 .. 6;
      SBY      at 0 range 7 .. 7;
   end record;

   SBYCR : aliased SBYCR_Type
      with Address              => System'To_Address (16#05FF_FFBC#),
           Volatile_Full_Access => True,
           Import               => True,
           Convention           => Ada;

pragma Style_Checks (On);

end SH7032;

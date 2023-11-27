-----------------------------------------------------------------------------------------------------------------------
--                                                     SweetAda                                                      --
-----------------------------------------------------------------------------------------------------------------------
-- __HDS__                                                                                                           --
-- __FLN__ sh7750.ads                                                                                                --
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

package SH7750 is

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
   -- Generic definitions
   ----------------------------------------------------------------------------

   Opcode_BREAKPOINT      : constant := 16#C3C3#; -- TRAPA #C3
   Opcode_BREAKPOINT_Size : constant := 2;

   BREAKPOINT_Asm_String : constant String := ".word   0xC3C3";

   procedure NOP
      with Inline => True;
   procedure BREAKPOINT
      with Inline => True;
   procedure Asm_Call
      (Target_Address : in Address)
      with Inline => True;

   ----------------------------------------------------------------------------
   -- SH4 registers
   ----------------------------------------------------------------------------

   R0       : constant := 0;
   R1       : constant := 1;
   R2       : constant := 2;
   R3       : constant := 3;
   R4       : constant := 4;
   R5       : constant := 5;
   R6       : constant := 6;
   R7       : constant := 7;
   R8       : constant := 8;
   R9       : constant := 9;
   R10      : constant := 10;
   R11      : constant := 11;
   R12      : constant := 12;
   R13      : constant := 13;
   R14      : constant := 14;
   R15      : constant := 15;
   R0_BANK0 : constant := R0;
   R1_BANK0 : constant := R1;
   R2_BANK0 : constant := R2;
   R3_BANK0 : constant := R3;
   R4_BANK0 : constant := R4;
   R5_BANK0 : constant := R5;
   R6_BANK0 : constant := R6;
   R7_BANK0 : constant := R7;
   R0_BANK1 : constant := R0;
   R1_BANK1 : constant := R1;
   R2_BANK1 : constant := R2;
   R3_BANK1 : constant := R3;
   R4_BANK1 : constant := R4;
   R5_BANK1 : constant := R5;
   R6_BANK1 : constant := R6;
   R7_BANK1 : constant := R7;

   subtype Register_Number_Type is Natural range R0 .. R15;

   ----------------------------------------------------------------------------
   -- 2.2.4 Control Registers
   ----------------------------------------------------------------------------

   -- Status register, SR

   MD_User : constant := 0; -- User mode
   MD_Priv : constant := 1; -- Privileged mode

   RB_BANK0 : constant := 0; -- R0_BANK0–R7_BANK0 are accessed as general registers R0–R7.
   RB_BANK1 : constant := 1; -- R0_BANK1–R7_BANK1 are accessed as general registers R0–R7.

   type SR_Type is
   record
      T         : Boolean;      -- True/false condition or carry/borrow bit
      S         : Boolean;      -- Specifies a saturation operation for a MAC instruction.
      Reserved1 : Bits_2 := 0;
      IMASK     : Bits_4;       -- Interrupt mask level
      Q         : Bits_1;       -- Used by the DIV0S, DIV0U, and DIV1 instructions.
      M         : Bits_1;       -- Used by the DIV0S, DIV0U, and DIV1 instructions.
      Reserved2 : Bits_5 := 0;
      FD        : Boolean;      -- FPU disable bit
      Reserved3 : Bits_12 := 0;
      BL        : Boolean;      -- Exception/interrupt block bit
      RB        : Bits_1;       -- General register bank specifier in privileged mode
      MD        : Bits_1;       -- Processor mode
      Reserved4 : Bits_1 := 0;
   end record with
      Bit_Order => Low_Order_First,
      Size      => 32;
   for SR_Type use
   record
      T         at 0 range 0 .. 0;
      S         at 0 range 1 .. 1;
      Reserved1 at 0 range 2 .. 3;
      IMASK     at 0 range 4 .. 7;
      Q         at 0 range 8 .. 8;
      M         at 0 range 9 .. 9;
      Reserved2 at 0 range 10 .. 14;
      FD        at 0 range 15 .. 15;
      Reserved3 at 0 range 16 .. 27;
      BL        at 0 range 28 .. 28;
      RB        at 0 range 29 .. 29;
      MD        at 0 range 30 .. 30;
      Reserved4 at 0 range 31 .. 31;
   end record;

   function SR_Read
      return SR_Type
      with Inline => True;
   procedure SR_Write
      (Value : in SR_Type)
      with Inline => True;

   -- Floating-point status/control register, FPSCR

   RM_NEAREST   : constant := 2#00#; -- Round to Nearest
   RM_ZERO      : constant := 2#01#; -- Round to Zero
   -- RM_Reserved1 : constant := 2#10#; -- Reserved
   -- RM_Reserved2 : constant := 2#11#; -- Reserved

   DN_DENORM : constant := 0; -- A denormalized number is treated as such.
   DN_ZERO   : constant := 1; -- A denormalized number is treated as zero.

   PR_SINGLE : constant := 0; -- Floating-point instructions are executed as single-precision operations.
   PR_DOUBLE : constant := 1; -- Floating-point instructions are executed as double-precision operations

   SZ_32 : constant := 0; -- The data size of the FMOV instruction is 32 bits.
   SZ_64 : constant := 1; -- The data size of the FMOV instruction is a 32-bit register pair (64 bits).

   FR_BANK0 : constant := 0; -- FPR0..15_BANK0 are assigned to FR0–FR15; FPR0..15_BANK1 are assigned to XF0–XF15.
   FR_BANK1 : constant := 1; -- FPR0..15_BANK0 are assigned to XF0–XF15; FPR0..15_BANK1 are assigned to FR0–FR15.

   type FPSCR_Type is
   record
      RM           : Bits_2;  -- Rounding mode
      FL_Inexact   : Boolean; -- FPU exception flag fields
      FL_Underflow : Boolean; --
      FL_Overflow  : Boolean; --
      FL_DivZero   : Boolean; --
      FL_Invalid   : Boolean; --
      EN_Inexact   : Boolean; -- FPU exception enable fields
      EN_Underflow : Boolean; --
      EN_Overflow  : Boolean; --
      EN_DivZero   : Boolean; --
      EN_Invalid   : Boolean; --
      CA_Inexact   : Boolean; -- FPU exception cause fields
      CA_Underflow : Boolean; --
      CA_Overflow  : Boolean; --
      CA_DivZero   : Boolean; --
      CA_Invalid   : Boolean; --
      CA_FPUErr    : Boolean; --
      DN           : Bits_1;  -- Denormalization mode
      PR           : Bits_1;  -- Precision mode
      SZ           : Bits_1;  -- Transfer size mode
      FR           : Bits_1;  -- Floating-point register bank
      Reserved     : Bits_10;
   end record with
      Bit_Order => Low_Order_First,
      Size      => 32;
   for FPSCR_Type use
   record
      RM           at 0 range 0 .. 1;
      FL_Inexact   at 0 range 2 .. 2;
      FL_Underflow at 0 range 3 .. 3;
      FL_Overflow  at 0 range 4 .. 4;
      FL_DivZero   at 0 range 5 .. 5;
      FL_Invalid   at 0 range 6 .. 6;
      EN_Inexact   at 0 range 7 .. 7;
      EN_Underflow at 0 range 8 .. 8;
      EN_Overflow  at 0 range 9 .. 9;
      EN_DivZero   at 0 range 10 .. 10;
      EN_Invalid   at 0 range 11 .. 11;
      CA_Inexact   at 0 range 12 .. 12;
      CA_Underflow at 0 range 13 .. 13;
      CA_Overflow  at 0 range 14 .. 14;
      CA_DivZero   at 0 range 15 .. 15;
      CA_Invalid   at 0 range 16 .. 16;
      CA_FPUErr    at 0 range 17 .. 17;
      DN           at 0 range 18 .. 18;
      PR           at 0 range 19 .. 19;
      SZ           at 0 range 20 .. 20;
      FR           at 0 range 21 .. 21;
      Reserved     at 0 range 22 .. 31;
   end record;

   ----------------------------------------------------------------------------
   -- Section 12 Timer Unit (TMU)
   ----------------------------------------------------------------------------

   -- 12.2.1 Timer Output Control Register (TOCR)

   TCOE_External : constant := 0; -- Timer clock pin (TCLK) is used as ext clock in or in capture control in pin
   TCOE_RTCOUT   : constant := 1; -- Timer clock pin (TCLK) is used as on-chip RTC output clock output pin

   type TOCR_Type is
   record
      TCOE     : Bits_1; -- Timer Clock Pin Control
      Reserved : Bits_7;
   end record with
      Bit_Order => Low_Order_First,
      Size      => 8;
   for TOCR_Type use
   record
      TCOE     at 0 range 0 .. 0;
      Reserved at 0 range 1 .. 7;
   end record;

   -- 12.2.2 Timer Start Register (TSTR)

   type TSTR_Type is
   record
      STR0     : Boolean; -- Counter Start 0
      STR1     : Boolean; -- Counter Start 1
      STR2     : Boolean; -- Counter Start 2
      Reserved : Bits_5;
   end record with
      Bit_Order => Low_Order_First,
      Size      => 8;
   for TSTR_Type use
   record
      STR0     at 0 range 0 .. 0;
      STR1     at 0 range 1 .. 1;
      STR2     at 0 range 2 .. 2;
      Reserved at 0 range 3 .. 7;
   end record;

   -- 12.2.5 Timer Control Registers (TCR)

   type TMU_Kind is (CHANNEL_01, CHANNEL_2);

   TPSC_PDIV4    : constant := 2#000#; -- Counts on Pφ/4
   TPSC_PDIV16   : constant := 2#001#; -- Counts on Pφ/16
   TPSC_PDIV64   : constant := 2#010#; -- Counts on Pφ/64
   TPSC_PDIV256  : constant := 2#011#; -- Counts on Pφ/256
   TPSC_PDIV1024 : constant := 2#100#; -- Counts on Pφ/1024
   -- TPSC_Reserved : constant := 2#101#; -- Reserved (Do not set)
   TPSC_RTC      : constant := 2#110#; -- Counts on on-chip RTC output clock
   TPSC_External : constant := 2#111#; -- Counts on external clock

   CKEG_Rising  : constant := 2#00#; -- Count/input capture register set on rising edge
   CKEG_Falling : constant := 2#01#; -- Count/input capture register set on falling edge
   CKEG_Both    : constant := 2#10#; -- Count/input capture register set on both rising and falling edges

   ICPE_Unused    : constant := 2#00#; -- Input capture function is not used
   -- ICPE_Reserved  : constant := 2#01#; -- Reserved (Do not set)
   ICPE_CAPTINTNE : constant := 2#10#; -- Input capture function is used, but interrupt due to input capture (TICPI2) is not enabled
   ICPE_CAPTINTEN : constant := 2#11#; -- Input capture function is used, and interrupt due to input capture (TICPI2) is enabled

   type TCR_Type (T : TMU_Kind := CHANNEL_01) is
   record
      TPSC : Bits_3;  -- Timer Prescaler 2 to 0
      CKEG : Bits_2;  -- Clock Edge 1 and 0
      UNIE : Boolean; -- Underflow Interrupt Control
      UNF  : Boolean; -- Underflow Flag
      case T is
         when CHANNEL_01 =>
            Reserved1 : Bits_2;
            Reserved2 : Bits_7;
         when CHANNEL_2 =>
            ICPE      : Bits_2;  -- Input Capture Control
            ICPF      : Boolean; -- Input Capture Interrupt Flag
            Reserved  : Bits_6;
      end case;
   end record with
      Bit_Order       => Low_Order_First,
      Size            => 16,
      Unchecked_Union => True;
   for TCR_Type use
   record
      TPSC      at 0 range 0 .. 2;
      CKEG      at 0 range 3 .. 4;
      UNIE      at 0 range 5 .. 5;
      UNF       at 0 range 8 .. 8;
      Reserved1 at 0 range 6 .. 7;
      Reserved2 at 0 range 9 .. 15;
      ICPE      at 0 range 6 .. 7;
      ICPF      at 0 range 9 .. 9;
      Reserved  at 0 range 10 .. 15;
   end record;

   -- 12.1.4 Register Configuration

pragma Warnings (Off, "* bits of ""TMU_Type"" unused");
   type TMU_Type is
   record
      TOCR  : TOCR_Type   with Volatile_Full_Access => True;
      TSTR  : TSTR_Type   with Volatile_Full_Access => True;
      TCOR0 : Unsigned_32 with Volatile_Full_Access => True;
      TCNT0 : Unsigned_32 with Volatile_Full_Access => True;
      TCR0  : TCR_Type    with Volatile_Full_Access => True;
      TCOR1 : Unsigned_32 with Volatile_Full_Access => True;
      TCNT1 : Unsigned_32 with Volatile_Full_Access => True;
      TCR1  : TCR_Type    with Volatile_Full_Access => True;
      TCOR2 : Unsigned_32 with Volatile_Full_Access => True;
      TCNT2 : Unsigned_32 with Volatile_Full_Access => True;
      TCR2  : TCR_Type    with Volatile_Full_Access => True;
      TCPR2 : Unsigned_32 with Volatile_Full_Access => True;
   end record with
      Alignment => 4,
      Size      => 16#30# * 8;
   for TMU_Type use
   record
      TOCR  at 16#00# range 0 .. 7;
      TSTR  at 16#04# range 0 .. 7;
      TCOR0 at 16#08# range 0 .. 31;
      TCNT0 at 16#0C# range 0 .. 31;
      TCR0  at 16#10# range 0 .. 15;
      TCOR1 at 16#14# range 0 .. 31;
      TCNT1 at 16#18# range 0 .. 31;
      TCR1  at 16#1C# range 0 .. 15;
      TCOR2 at 16#20# range 0 .. 31;
      TCNT2 at 16#24# range 0 .. 31;
      TCR2  at 16#28# range 0 .. 15;
      TCPR2 at 16#2C# range 0 .. 31;
   end record;
pragma Warnings (On, "* bits of ""TMU_Type"" unused");

   TMU_BASEADDRESS : constant := 16#FFD8_0000#; -- P4 area

   TMU : aliased TMU_Type
      with Address    => To_Address (TMU_BASEADDRESS),
           Volatile   => True,
           Import     => True,
           Convention => Ada;

   ----------------------------------------------------------------------------
   -- Section 16 Serial Communication Interface with FIFO (SCIF)
   ----------------------------------------------------------------------------

   -- 16.2.5 Serial Mode Register (SCSMR2)

   CKS_DIV1  : constant := 2#00#; -- Pφ clock
   CKS_DIV4  : constant := 2#01#; -- Pφ/4 clock
   CKS_DIV16 : constant := 2#10#; -- Pφ/16 clock
   CKS_DIV64 : constant := 2#11#; -- Pφ/64 clock

   STOP_1 : constant := 0; -- 1 stop bit
   STOP_2 : constant := 1; -- 2 stop bits

   OnE_EVEN : constant := 0; -- Even parity
   OnE_ODD  : constant := 1; -- Odd parity

   CHR_8 : constant := 0; -- 8-bit data
   CHR_7 : constant := 1; -- 7-bit data

   type SCSMR2_Type is
   record
      CKS       : Bits_2;  -- Clock Select 1 and 0
      Reserved1 : Bits_1;
      STOP      : Bits_1;  -- Stop Bit Length
      OnE       : Bits_1;  -- Parity Mode
      PE        : Boolean; -- Parity Enable
      CHR       : Bits_1;  -- Character Length
      Reserved2 : Bits_1;
   end record with
      Bit_Order => Low_Order_First,
      Size      => 8;
   for SCSMR2_Type use
   record
      CKS       at 0 range 0 .. 1;
      Reserved1 at 0 range 2 .. 2;
      STOP      at 0 range 3 .. 3;
      OnE       at 0 range 4 .. 4;
      PE        at 0 range 5 .. 5;
      CHR       at 0 range 6 .. 6;
      Reserved2 at 0 range 7 .. 7;
   end record;

   -- 16.2.6 Serial Control Register (SCSCR2)

   CKE1_Internal : constant := 0; -- Internal clock/SCK2 pin functions as input pin
   CKE1_External : constant := 1; -- External clock/SCK2 pin functions as clock input

   type SCSCR2_Type is
   record
      Reserved1 : Bits_1 := 0;
      CKE1      : Bits_1;      -- Clock Enable 1
      Reserved2 : Bits_1 := 0;
      REIE      : Boolean;     -- Receive Error Interrupt Enable
      RE        : Boolean;     -- Receive Enable
      TE        : Boolean;     -- Transmit Enable
      RIE       : Boolean;     -- Receive Interrupt Enable
      TIE       : Boolean;     -- Transmit Interrupt Enable
      Reserved3 : Bits_8 := 0;
   end record with
      Bit_Order => Low_Order_First,
      Size      => 16;
   for SCSCR2_Type use
   record
      Reserved1 at 0 range 0 .. 0;
      CKE1      at 0 range 1 .. 1;
      Reserved2 at 0 range 2 .. 2;
      REIE      at 0 range 3 .. 3;
      RE        at 0 range 4 .. 4;
      TE        at 0 range 5 .. 5;
      RIE       at 0 range 6 .. 6;
      TIE       at 0 range 7 .. 7;
      Reserved3 at 0 range 8 .. 15;
   end record;

   -- 16.2.7 Serial Status Register (SCFSR2)

   type SCFSR2_Type is
   record
      DR    : Boolean; -- Receive Data Ready
      RDF   : Boolean; -- Receive FIFO Data Full
      PER   : Boolean; -- Parity Error
      FER   : Boolean; -- Framing Error
      BRK   : Boolean; -- Break Detect
      TDFE  : Boolean; -- Transmit FIFO Data Empty
      TEND  : Boolean; -- Transmit End
      ER    : Boolean; -- Receive Error
      FER03 : Bits_4;  -- Number of Framing Errors
      PER03 : Bits_4;  -- Number of Parity Errors
   end record with
      Bit_Order => Low_Order_First,
      Size      => 16;
   for SCFSR2_Type use
   record
      DR    at 0 range 0 .. 0;
      RDF   at 0 range 1 .. 1;
      PER   at 0 range 2 .. 2;
      FER   at 0 range 3 .. 3;
      BRK   at 0 range 4 .. 4;
      TDFE  at 0 range 5 .. 5;
      TEND  at 0 range 6 .. 6;
      ER    at 0 range 7 .. 7;
      FER03 at 0 range 8 .. 11;
      PER03 at 0 range 12 .. 15;
   end record;

   -- 16.2.9 FIFO Control Register (SCFCR2)

   TTRG_7 : constant := 2#00#; -- Transmit Trigger Number = 7
   TTRG_3 : constant := 2#01#; -- Transmit Trigger Number = 3
   TTRG_1 : constant := 2#10#; -- Transmit Trigger Number = 1
   TTRG_0 : constant := 2#11#; -- Transmit Trigger Number = 0

   RTRG_1  : constant := 2#00#; -- Receive Trigger Number = 1
   RTRG_4  : constant := 2#01#; -- Receive Trigger Number = 4
   RTRG_8  : constant := 2#10#; -- Receive Trigger Number = 8
   RTRG_14 : constant := 2#11#; -- Receive Trigger Number = 14

   RSTRG_15 : constant := 2#00#; -- RTS2 Output Active Trigger = 15
   RSTRG_1  : constant := 2#01#; -- RTS2 Output Active Trigger = 1
   RSTRG_4  : constant := 2#10#; -- RTS2 Output Active Trigger = 4
   RSTRG_6  : constant := 2#11#; -- RTS2 Output Active Trigger = 6
   RSTRG_8  : constant := 2#00#; -- RTS2 Output Active Trigger = 8
   RSTRG_10 : constant := 2#01#; -- RTS2 Output Active Trigger = 10
   RSTRG_12 : constant := 2#10#; -- RTS2 Output Active Trigger = 12
   RSTRG_14 : constant := 2#11#; -- RTS2 Output Active Trigger = 14

   type SCFCR2_Type is
   record
      LOOPBACK : Boolean; -- Loopback Test
      RFRST    : Boolean; -- Receive FIFO Data Register Reset
      TFRST    : Boolean; -- Transmit FIFO Data Register Reset
      MCE      : Boolean; -- Modem Control Enable
      TTRG     : Bits_2;  -- Transmit FIFO Data Number Trigger
      RTRG     : Bits_2;  -- Receive FIFO Data Number Trigger
      RSTRG    : Bits_3;  -- nRTS2 Output Active Trigger
      Reserved : Bits_5;
   end record with
      Bit_Order => Low_Order_First,
      Size      => 16;
   for SCFCR2_Type use
   record
      LOOPBACK at 0 range 0 .. 0;
      RFRST    at 0 range 1 .. 1;
      TFRST    at 0 range 2 .. 2;
      MCE      at 0 range 3 .. 3;
      TTRG     at 0 range 4 .. 5;
      RTRG     at 0 range 6 .. 7;
      RSTRG    at 0 range 8 .. 10;
      Reserved at 0 range 11 .. 15;
   end record;

   -- 16.2.10 FIFO Data Count Register (SCFDR2)

   type SCFDR2_Type is
   record
      R         : Bits_5; -- number of receive data bytes in SCFRDR2
      Reserved1 : Bits_3;
      T         : Bits_5; -- number of transmit data bytes in SCFTDR2
      Reserved2 : Bits_3;
   end record with
      Bit_Order => Low_Order_First,
      Size      => 16;
   for SCFDR2_Type use
   record
      R         at 0 range 0 .. 4;
      Reserved1 at 0 range 5 .. 7;
      T         at 0 range 8 .. 12;
      Reserved2 at 0 range 13 .. 15;
   end record;

   -- 16.2.11 Serial Port Register (SCSPTR2)

   SPB2IO_N    : constant := 0; -- SPB2DT bit value is not output to the TxD2 pin
   SPB2IO_TxD2 : constant := 1; -- SPB2DT bit value is output to the TxD2 pin

   CTSIO_N     : constant := 0; -- CTSDT bit value is not output to nCTS2pin
   CTSIO_nCTS2 : constant := 1; -- CTSDT bit value is output to nCTS2pin

   RTSDT_N     : constant := 0; -- RTSDT bit value is not output to nRTS2pin
   RTSDT_nRTS2 : constant := 1; -- RTSDT bit value is output to nRTS2pin

   type SCSPTR2_Type is
   record
      SPB2DT    : Bits_1; -- Serial Port Break Data
      SPB2IO    : Bits_1; -- Serial Port Break I/O
      Reserved1 : Bits_2;
      CTSDT     : Bits_1; -- Serial Port CTS Port Data
      CTSIO     : Bits_1; -- Serial Port CTS Port I/O
      RTSDT     : Bits_1; -- Serial Port RTS Port Data
      RTSIO     : Bits_1; -- Serial Port RTS Port I/O
      Reserved2 : Bits_8;
   end record with
      Bit_Order => Low_Order_First,
      Size      => 16;
   for SCSPTR2_Type use
   record
      SPB2DT    at 0 range 0 .. 0;
      SPB2IO    at 0 range 1 .. 1;
      Reserved1 at 0 range 2 .. 3;
      CTSDT     at 0 range 4 .. 4;
      CTSIO     at 0 range 5 .. 5;
      RTSDT     at 0 range 6 .. 6;
      RTSIO     at 0 range 7 .. 7;
      Reserved2 at 0 range 8 .. 15;
   end record;

   -- 16.2.12 Line Status Register (SCLSR2)

   type SCLSR2_Type is
   record
      ORER     : Boolean; -- Overrun Error
      Reserved : Bits_15;
   end record with
      Bit_Order => Low_Order_First,
      Size      => 16;
   for SCLSR2_Type use
   record
      ORER     at 0 range 0 .. 0;
      Reserved at 0 range 1 .. 15;
   end record;

   -- 16.1.4 Register Configuration

pragma Warnings (Off, "* bits of ""SCIF_Type"" unused");
   type SCIF_Type is
   record
      SCSMR2  : SCSMR2_Type  with Volatile_Full_Access => True;
      SCBRR2  : Unsigned_8   with Volatile_Full_Access => True;
      SCSCR2  : SCSCR2_Type  with Volatile_Full_Access => True;
      SCFTDR2 : Unsigned_8   with Volatile_Full_Access => True;
      SCFSR2  : SCFSR2_Type  with Volatile_Full_Access => True;
      SCFRDR2 : Unsigned_8   with Volatile_Full_Access => True;
      SCFCR2  : SCFCR2_Type  with Volatile_Full_Access => True;
      SCFDR2  : SCFDR2_Type  with Volatile_Full_Access => True;
      SCSPTR2 : SCSPTR2_Type with Volatile_Full_Access => True;
      SCLSR2  : SCLSR2_Type  with Volatile_Full_Access => True;
   end record with
      Alignment => 4,
      Size      => 16#28# * 8;
   for SCIF_Type use
   record
      SCSMR2  at 16#00# range 0 .. 7;
      SCBRR2  at 16#04# range 0 .. 7;
      SCSCR2  at 16#08# range 0 .. 15;
      SCFTDR2 at 16#0C# range 0 .. 7;
      SCFSR2  at 16#10# range 0 .. 15;
      SCFRDR2 at 16#14# range 0 .. 7;
      SCFCR2  at 16#18# range 0 .. 15;
      SCFDR2  at 16#1C# range 0 .. 15;
      SCSPTR2 at 16#20# range 0 .. 15;
      SCLSR2  at 16#24# range 0 .. 15;
   end record;
pragma Warnings (On, "* bits of ""SCIF_Type"" unused");

   SCIF_BASEADDRESS : constant := 16#FFE8_0000#; -- P4 area

   SCIF : aliased SCIF_Type
      with Address    => To_Address (SCIF_BASEADDRESS),
           Volatile   => True,
           Import     => True,
           Convention => Ada;

end SH7750;

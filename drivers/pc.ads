-----------------------------------------------------------------------------------------------------------------------
--                                                     SweetAda                                                      --
-----------------------------------------------------------------------------------------------------------------------
-- __HDS__                                                                                                           --
-- __FLN__ pc.ads                                                                                                    --
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
with Ada.Unchecked_Conversion;
with Interfaces;
with Definitions;
with Bits;
with CPU;
with Time;

package PC is

   --========================================================================--
   --                                                                        --
   --                                                                        --
   --                               Public part                              --
   --                                                                        --
   --                                                                        --
   --========================================================================--

   use System;
   use Interfaces;

   ----------------------------------------------------------------------------
   -- I/O peripheral base addresses
   ----------------------------------------------------------------------------

   PIC1_BASEADDRESS  : constant := 16#0020#;
   PIT_BASEADDRESS   : constant := 16#0040#;
   RTC_BASEADDRESS   : constant := 16#0070#;
   PIC2_BASEADDRESS  : constant := 16#00A0#;
   UART1_BASEADDRESS : constant := 16#03F8#;
   UART2_BASEADDRESS : constant := 16#02F8#;
   PPI_BASEADDRESS   : constant := 16#0378#;
   IDE1_BASEADDRESS  : constant := 16#01F0#;
   IDE2_BASEADDRESS  : constant := 16#0170#;

   ----------------------------------------------------------------------------
   -- i8042 and i8255 ports
   ----------------------------------------------------------------------------

   PORTB_ADDRESS : constant := 16#0061#;

   ----------------------------------------------------------------------------
   -- i8259 PIC
   ----------------------------------------------------------------------------

   PIC1_IRR  : constant := PIC1_BASEADDRESS + 16#00#;
   PIC1_ISR  : constant := PIC1_BASEADDRESS + 16#00#;
   PIC1_IVEC : constant := PIC1_BASEADDRESS + 16#00#;
   PIC1_ICW1 : constant := PIC1_BASEADDRESS + 16#00#;
   PIC1_OCW2 : constant := PIC1_BASEADDRESS + 16#00#;
   PIC1_OCW3 : constant := PIC1_BASEADDRESS + 16#00#;
   PIC1_IMR  : constant := PIC1_BASEADDRESS + 16#01#;
   PIC1_ICW2 : constant := PIC1_BASEADDRESS + 16#01#;
   PIC1_ICW3 : constant := PIC1_BASEADDRESS + 16#01#;
   PIC1_ICW4 : constant := PIC1_BASEADDRESS + 16#01#;
   PIC1_OCW1 : constant := PIC1_BASEADDRESS + 16#01#;

   PIC2_IRR  : constant := PIC2_BASEADDRESS + 16#00#;
   PIC2_ISR  : constant := PIC2_BASEADDRESS + 16#00#;
   PIC2_IVEC : constant := PIC2_BASEADDRESS + 16#00#;
   PIC2_ICW1 : constant := PIC2_BASEADDRESS + 16#00#;
   PIC2_OCW2 : constant := PIC2_BASEADDRESS + 16#00#;
   PIC2_OCW3 : constant := PIC2_BASEADDRESS + 16#00#;
   PIC2_IMR  : constant := PIC2_BASEADDRESS + 16#01#;
   PIC2_ICW2 : constant := PIC2_BASEADDRESS + 16#01#;
   PIC2_ICW3 : constant := PIC2_BASEADDRESS + 16#01#;
   PIC2_ICW4 : constant := PIC2_BASEADDRESS + 16#01#;
   PIC2_OCW1 : constant := PIC2_BASEADDRESS + 16#01#;

   PIC_Irq0  : constant CPU.Irq_Id_Type := 16#20#;
   PIC_Irq1  : constant CPU.Irq_Id_Type := 16#21#;
   PIC_Irq2  : constant CPU.Irq_Id_Type := 16#22#;
   PIC_Irq3  : constant CPU.Irq_Id_Type := 16#23#;
   PIC_Irq4  : constant CPU.Irq_Id_Type := 16#24#;
   PIC_Irq5  : constant CPU.Irq_Id_Type := 16#25#;
   PIC_Irq6  : constant CPU.Irq_Id_Type := 16#26#;
   PIC_Irq7  : constant CPU.Irq_Id_Type := 16#27#;
   PIC_Irq8  : constant CPU.Irq_Id_Type := 16#28#;
   PIC_Irq9  : constant CPU.Irq_Id_Type := 16#29#;
   PIC_Irq10 : constant CPU.Irq_Id_Type := 16#2A#;
   PIC_Irq11 : constant CPU.Irq_Id_Type := 16#2B#;
   PIC_Irq12 : constant CPU.Irq_Id_Type := 16#2C#;
   PIC_Irq13 : constant CPU.Irq_Id_Type := 16#2D#;
   PIC_Irq14 : constant CPU.Irq_Id_Type := 16#2E#;
   PIC_Irq15 : constant CPU.Irq_Id_Type := 16#2F#;

   procedure PIC_Init (Vector_Offset_Master : in Unsigned_8; Vector_Offset_Slave : in Unsigned_8);
   procedure PIC_Irq_Enable (Irq : in CPU.Irq_Id_Type);
   procedure PIC_Irq_Disable (Irq : in CPU.Irq_Id_Type);
   procedure PIC1_EOI with
      Inline => True;
   procedure PIC2_EOI with
      Inline => True;

   ----------------------------------------------------------------------------
   -- i8254 PIT
   ----------------------------------------------------------------------------

   -- MASTER_CLK is four times the NTSC color burst frequency:
   -- 4 * (315 / 88) = 4 * 3.579(54) = 14.318182 MHz, T = 69.84 ns
   MASTER_CLK : constant := Definitions.CLK_NTSC4;
   -- PIT clock is derived from MASTER clock; initially it is divided by 3,
   -- then is divided further by 4.
   PIT_CLK    : constant := (MASTER_CLK + (12 / 2)) / 12; -- 1.193182 MHz, T = 0.838 us

   -- Control Word Format
   -- D1 .. D3 MODE or counter # in LATCH
   MODE0                 : constant := 2#000#; -- interrupt on terminal count
   MODE1                 : constant := 2#001#; -- programmable monoflop
   MODE2                 : constant := 2#010#; -- rate generator
   MODE3                 : constant := 2#011#; -- square-wave generator
   MODE4                 : constant := 2#100#; -- software triggered pulse
   MODE5                 : constant := 2#101#; -- hardware triggered pulse
   READBACK_COUNTER0     : constant := 2#001#;
   READBACK_COUNTER1     : constant := 2#010#;
   READBACK_COUNTER2     : constant := 2#100#;
   -- D4 .. D5 LATCH, Read/Write or Read-Back
   LATCH                 : constant := 2#00#;
   RW_LOW_BYTE           : constant := 2#01#;
   RW_HIGH_BYTE          : constant := 2#10#;
   RW_BOTH_BYTE          : constant := 2#11#;
   READBACK_LATCH_BOTH   : constant := 2#00#;
   READBACK_LATCH_COUNT  : constant := 2#01#;
   READBACK_LATCH_STATUS : constant := 2#10#;
   -- D6 .. D7 SC select counter or Read-Back
   SELECT_COUNTER0       : constant := 2#00#;
   SELECT_COUNTER1       : constant := 2#01#;
   SELECT_COUNTER2       : constant := 2#10#;
   READBACK              : constant := 2#11#;

   type PIT_Control_Word_Type is
   record
      BCD  : Boolean;
      MODE : Bits.Bits_3;
      RW   : Bits.Bits_2;
      SC   : Bits.Bits_2;
   end record with
      Bit_Order => Low_Order_First,
      Size      => 8;
   for PIT_Control_Word_Type use
   record
      BCD  at 0 range 0 .. 0;
      MODE at 0 range 1 .. 3;
      RW   at 0 range 4 .. 5;
      SC   at 0 range 6 .. 7;
   end record;

   function To_U8 is new Ada.Unchecked_Conversion (PIT_Control_Word_Type, Unsigned_8);

   type PIT_Status_Type is
   record
      BCD        : Boolean;
      MODE       : Bits.Bits_3;
      RW         : Bits.Bits_2;
      Null_Count : Boolean;
      OUT_Pin    : Boolean;
   end record with
      Bit_Order => Low_Order_First,
      Size      => 8;
   for PIT_Status_Type use
   record
      BCD        at 0 range 0 .. 0;
      MODE       at 0 range 1 .. 3;
      RW         at 0 range 4 .. 5;
      Null_Count at 0 range 6 .. 6;
      OUT_Pin    at 0 range 7 .. 7;
   end record;

   function To_PIT_Status is new Ada.Unchecked_Conversion (Unsigned_8, PIT_Status_Type);

   COUNTER0     : constant := PIT_BASEADDRESS + 16#00#;
   COUNTER1     : constant := PIT_BASEADDRESS + 16#01#;
   COUNTER2     : constant := PIT_BASEADDRESS + 16#02#;
   CONTROL_WORD : constant := PIT_BASEADDRESS + 16#03#;

   procedure PIT_Counter0_Init (Count : in Unsigned_16);
   procedure PIT_Counter1_Delay (Delay100us_Units : in Positive);

   PIT_Interrupt : constant CPU.Irq_Id_Type := PIC_Irq0;

   ----------------------------------------------------------------------------
   -- MC146818A RTC
   ----------------------------------------------------------------------------

   RTC_INDEX : constant := RTC_BASEADDRESS + 0;
   RTC_DATA  : constant := RTC_BASEADDRESS + 1;

   RTC_REGISTER_Seconds       : constant := 16#00#;
   RTC_REGISTER_Seconds_Alarm : constant := 16#01#;
   RTC_REGISTER_Minutes       : constant := 16#02#;
   RTC_REGISTER_Minutes_Alarm : constant := 16#03#;
   RTC_REGISTER_Hours         : constant := 16#04#;
   RTC_REGISTER_Hours_Alarm   : constant := 16#05#;
   RTC_REGISTER_DayOfWeek     : constant := 16#06#;
   RTC_REGISTER_Mday          : constant := 16#07#;
   RTC_REGISTER_Month         : constant := 16#08#;
   RTC_REGISTER_Year          : constant := 16#09#;
   RTC_REGISTER_A             : constant := 16#0A#;
   RTC_REGISTER_B             : constant := 16#0B#;
   RTC_REGISTER_C             : constant := 16#0C#;
   RTC_REGISTER_D             : constant := 16#0D#;

   RTC_CLK : constant := Definitions.CLK_RTC32k; -- 32.768 kHz

   RS_None  : constant := 2#0000#; -- N/A
   RS_256   : constant := 2#0001#; -- PIR = 3.90625 ms, SQW f = 256 Hz
   RS_128   : constant := 2#0010#; -- PIR = 7.8125 ms, SQW f = 128 Hz
   RS_8k192 : constant := 2#0011#; -- PIR = 122.070 us, SQW f = 8.192 kHz
   RS_4k096 : constant := 2#0100#; -- PIR = 244.141 us, SQW f = 4.096 kHz
   RS_2k048 : constant := 2#0101#; -- PIR = 488.281 us, SQW f = 2.048 kHz
   RS_1k024 : constant := 2#0110#; -- PIR = 976.562 us, SQW f = 1.024 kHz
   RS_512   : constant := 2#0111#; -- PIR = 1.953125 ms, SQW f = 512 Hz
   RS_256_2 : constant := 2#1000#; -- PIR = 3.90625 ms, SQW f = 256 Hz
   RS_128_2 : constant := 2#1001#; -- PIR = 7.8125 ms, SQW f = 128 Hz
   RS_64    : constant := 2#1010#; -- PIR = 15.625 ms, SQW f = 64 Hz
   RS_32    : constant := 2#1011#; -- PIR = 31.25 ms, SQW f = 32 Hz
   RS_16    : constant := 2#1100#; -- PIR = 62.5 ms, SQW f = 16 Hz
   RS_8     : constant := 2#1101#; -- PIR = 125 ms, SQW f = 8 Hz
   RS_4     : constant := 2#1110#; -- PIR = 250 ms, SQW f = 4 Hz
   RS_2     : constant := 2#1111#; -- PIR = 500 ms, SQW f = 2 Hz

   DIV_4M   : constant := 2#000#; -- Time Base Frequency = 4.194304 MHz, Operation Mode = Yes, N = 0
   DIV_1M   : constant := 2#001#; -- Time Base Frequency = 1.048576 MHz, Operation Mode = Yes, N = 2
   DIV_32k  : constant := 2#010#; -- Time Base Frequency = 32.768 kHz, Operation Mode = Yes, N = 7
   DIV_Any1 : constant := 2#110#; -- Time Base Frequency = Any, Operation Mode = No
   DIV_Any2 : constant := 2#111#; -- Time Base Frequency = Any, Operation Mode = No

   type RTC_RegisterA_Type is
   record
      RS  : Bits.Bits_4;
      DIV : Bits.Bits_3;
      UIP : Boolean;
   end record with
      Bit_Order => Low_Order_First,
      Size      => 8;
   for RTC_RegisterA_Type use
   record
      RS  at 0 range 0 .. 3;
      DIV at 0 range 4 .. 6;
      UIP at 0 range 7 .. 7;
   end record;

   function To_RTC_RegisterA is new Ada.Unchecked_Conversion (Unsigned_8, RTC_RegisterA_Type);

   type RTC_RegisterB_Type is
   record
      DSE    : Boolean;
      Hour24 : Boolean;
      DM     : Boolean;
      SQWE   : Boolean;
      UIE    : Boolean;
      AIE    : Boolean;
      PIE    : Boolean;
      SET    : Boolean;
   end record with
      Bit_Order => Low_Order_First,
      Size      => 8;
   for RTC_RegisterB_Type use
   record
      DSE    at 0 range 0 .. 0;
      Hour24 at 0 range 1 .. 1;
      DM     at 0 range 2 .. 2;
      SQWE   at 0 range 3 .. 3;
      UIE    at 0 range 4 .. 4;
      AIE    at 0 range 5 .. 5;
      PIE    at 0 range 6 .. 6;
      SET    at 0 range 7 .. 7;
   end record;

   function To_RTC_RegisterB is new Ada.Unchecked_Conversion (Unsigned_8, RTC_RegisterB_Type);

   type RTC_RegisterC_Type is
   record
      Unused : Bits.Bits_4;
      UF     : Boolean;
      AF     : Boolean;
      PF     : Boolean;
      IRQF   : Boolean;
   end record with
      Bit_Order => Low_Order_First,
      Size      => 8;
   for RTC_RegisterC_Type use
   record
      Unused at 0 range 0 .. 3;
      UF     at 0 range 4 .. 4;
      AF     at 0 range 5 .. 5;
      PF     at 0 range 6 .. 6;
      IRQF   at 0 range 7 .. 7;
   end record;

   function To_RTC_RegisterC is new Ada.Unchecked_Conversion (Unsigned_8, RTC_RegisterC_Type);

   type RTC_RegisterD_Type is
   record
      Unused : Bits.Bits_7;
      VRT    : Boolean;
   end record with
      Bit_Order => Low_Order_First,
      Size      => 8;
   for RTC_RegisterD_Type use
   record
      Unused at 0 range 0 .. 6;
      VRT    at 0 range 7 .. 7;
   end record;

   function To_RTC_RegisterD is new Ada.Unchecked_Conversion (Unsigned_8, RTC_RegisterD_Type);

   RTC_NMI_DISABLE : constant := 16#80#;
   RTC_Interrupt   : constant CPU.Irq_Id_Type := PIC_Irq8;

   procedure RTC_Init;
   procedure RTC_Handle (Data_Address : in System.Address);
   procedure RTC_Read_Clock (T : in out Time.TM_Time);

   ----------------------------------------------------------------------------
   -- Parallel Port Interface PPI
   ----------------------------------------------------------------------------

   type PPI_Status_Type is
   record
      Unused   : Bits.Bits_2;
      IRQ      : Boolean;
      Error    : Boolean;
      SelectIn : Boolean;
      PaperOut : Boolean;
      ACK      : Boolean;
      Busy     : Boolean;     -- negated
   end record with
      Bit_Order => Low_Order_First,
      Size      => 8;
   for PPI_Status_Type use
   record
      Unused   at 0 range 0 .. 1;
      IRQ      at 0 range 2 .. 2;
      Error    at 0 range 3 .. 3;
      SelectIn at 0 range 4 .. 4;
      PaperOut at 0 range 5 .. 5;
      ACK      at 0 range 6 .. 6;
      Busy     at 0 range 7 .. 7;
   end record;

   function To_PPI_Status is new Ada.Unchecked_Conversion (Unsigned_8, PPI_Status_Type);

   type PPI_Control_Type is
   record
      Strobe    : Boolean;     -- negated
      AUTOLF    : Boolean;     -- negated
      INIT      : Boolean;
      SelectOut : Boolean;     -- negated
      IRQEN     : Boolean;
      BIDIR     : Boolean;
      Unused    : Bits.Bits_2;
   end record with
      Bit_Order => Low_Order_First,
      Size      => 8;
   for PPI_Control_Type use
   record
      Strobe    at 0 range 0 .. 0;
      AUTOLF    at 0 range 1 .. 1;
      INIT      at 0 range 2 .. 2;
      SelectOut at 0 range 3 .. 3;
      IRQEN     at 0 range 4 .. 4;
      BIDIR     at 0 range 5 .. 5;
      Unused    at 0 range 6 .. 7;
   end record;

   function To_U8 is new Ada.Unchecked_Conversion (PPI_Control_Type, Unsigned_8);
   function To_PPI_Control is new Ada.Unchecked_Conversion (Unsigned_8, PPI_Control_Type);

   PPI_DATA    : constant := PPI_BASEADDRESS + 16#00#;
   PPI_STATUS  : constant := PPI_BASEADDRESS + 16#01#;
   PPI_CONTROL : constant := PPI_BASEADDRESS + 16#02#;

   procedure PPI_DataIn (Value : out Unsigned_8);
   procedure PPI_DataOut (Value : in Unsigned_8);
   procedure PPI_StatusIn (Value : out PPI_Status_Type);
   procedure PPI_ControlIn (Value : out PPI_Control_Type);
   procedure PPI_ControlOut (Value : in PPI_Control_Type);
   procedure PPI_Init;

end PC;

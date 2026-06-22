-----------------------------------------------------------------------------------------------------------------------
--                                                     SweetAda                                                      --
-----------------------------------------------------------------------------------------------------------------------
-- __HDS__                                                                                                           --
-- __FLN__ pc.ads                                                                                                    --
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
with Definitions;
with Bits;
with CPU;

package PC
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
   -- I/O peripheral addresses
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

   --                                     -- R                          W
   PORT60_ADDRESS : constant := 16#0060#; -- i8042 output port          i8042 data register
   PORT64_ADDRESS : constant := 16#0064#; -- i8042 status register      i8042 command register
   PORTB_ADDRESS  : constant := 16#0061#; -- port B register            port B register

   ----------------------------------------------------------------------------
   -- i8042 and i8255 ports
   ----------------------------------------------------------------------------

   -- i8042 command register commands
   i8042_OUTPORT_RD_CMD : constant := 16#D0#; -- data is read from i8042 output port and placed in data register
   i8042_OUTPORT_WR_CMD : constant := 16#D1#; -- next byte written to port 60h is placed in i8042 output port

   type i8042_OUTPORT_Type is record
      SYSRES    : Boolean;     -- system reset line
      GATEA20   : Boolean;     -- gate A20
      Unused    : Bits_2 := 0;
      OBUFFULL  : Boolean;     -- output buffer full
      IBUFEMPTY : Boolean;     -- input buffer empty
      KBDCLK    : Boolean;     -- keyboard clock (output)
      KDBDATA   : Boolean;     -- keyboard data (output)
   end record
      with Bit_Order => Low_Order_First,
           Size      => 8;
   for i8042_OUTPORT_Type use record
      SYSRES    at 0 range 0 .. 0;
      GATEA20   at 0 range 1 .. 1;
      Unused    at 0 range 2 .. 3;
      OBUFFULL  at 0 range 4 .. 4;
      IBUFEMPTY at 0 range 5 .. 5;
      KBDCLK    at 0 range 6 .. 6;
      KDBDATA   at 0 range 7 .. 7;
   end record;

   type PORTB_Type is record
      TIM2GATESPK : Boolean; -- RW
      SPKRDATA    : Boolean; -- RW
      ENBRAMPCK   : Boolean; -- RW
      ENAIOCK     : Boolean; -- RW
      REFDET      : Boolean; -- RO
      OUT2        : Boolean; -- RO
      IOCHCK      : Boolean; -- RO
      PCK         : Boolean; -- RO
   end record
      with Bit_Order => Low_Order_First,
           Size      => 8;
   for PORTB_Type use record
      TIM2GATESPK at 0 range 0 .. 0;
      SPKRDATA    at 0 range 1 .. 1;
      ENBRAMPCK   at 0 range 2 .. 2;
      ENAIOCK     at 0 range 3 .. 3;
      REFDET      at 0 range 4 .. 4;
      OUT2        at 0 range 5 .. 5;
      IOCHCK      at 0 range 6 .. 6;
      PCK         at 0 range 7 .. 7;
   end record;

   ----------------------------------------------------------------------------
   -- 8259A
   -- PROGRAMMABLE INTERRUPT CONTROLLER
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

   procedure PIC_Init
      (Vector_Offset_Master : in Unsigned_8;
       Vector_Offset_Slave  : in Unsigned_8);
   procedure PIC_Irq_Enable
      (Irq : in CPU.Irq_Id_Type);
   procedure PIC_Irq_Disable
      (Irq : in CPU.Irq_Id_Type);
   procedure PIC1_EOI
      with Inline => True;
   procedure PIC2_EOI
      with Inline => True;

   ----------------------------------------------------------------------------
   -- 8254 PROGRAMMABLE INTERVAL TIMER
   ----------------------------------------------------------------------------

   COUNTER0     : constant := PIT_BASEADDRESS + 16#00#;
   COUNTER1     : constant := PIT_BASEADDRESS + 16#01#;
   COUNTER2     : constant := PIT_BASEADDRESS + 16#02#;
   CONTROL_WORD : constant := PIT_BASEADDRESS + 16#03#;

   -- MASTER_CLK is four times the NTSC color burst frequency:
   -- 4 * (315 / 88) = 4 * 3.579(54) = 14.318182 MHz, T = 69.84 ns
   MASTER_CLK : constant := Definitions.CLK_NTSCx4;
   -- PIT clock is derived from MASTER clock; initially it is divided by 3,
   -- then is divided further by 4.
   PIT_CLK    : constant := (MASTER_CLK + (12 / 2)) / 12; -- 1.193182 MHz, T = 0.838 us

   PIT_Interrupt : constant CPU.Irq_Id_Type := PIC_Irq0;

   -- M: MODE or counter # in LATCH
   M_MODE0                  : constant := 2#000#; -- interrupt on terminal count
   M_MODE1                  : constant := 2#001#; -- programmable monoflop
   M_MODE2                  : constant := 2#010#; -- rate generator
   M_MODE3                  : constant := 2#011#; -- square-wave generator
   M_MODE4                  : constant := 2#100#; -- software triggered pulse
   M_MODE5                  : constant := 2#101#; -- hardware triggered pulse
   M_READBACK_COUNTER0      : constant := 2#001#;
   M_READBACK_COUNTER1      : constant := 2#010#;
   M_READBACK_COUNTER2      : constant := 2#100#;
   -- RW: Counter Latch, Read/Write or Read-Back
   RW_COUNTER_LATCH         : constant := 2#00#;
   RW_LOW_BYTE              : constant := 2#01#;
   RW_HIGH_BYTE             : constant := 2#10#;
   RW_BOTH_BYTE             : constant := 2#11#;
   RW_READBACK_LATCH_BOTH   : constant := 2#00#;
   RW_READBACK_LATCH_COUNT  : constant := 2#01#;
   RW_READBACK_LATCH_STATUS : constant := 2#10#;
   -- SC: select counter or Read-Back
   SC_COUNTER0              : constant := 2#00#;
   SC_COUNTER1              : constant := 2#01#;
   SC_COUNTER2              : constant := 2#10#;
   SC_READBACK              : constant := 2#11#;

   -- Control Word Format

   type PIT_Control_Word_Type is record
      BCD : Boolean; -- Binary Coded Decimal (BCD) Counter (4 Decades)
      M   : Bits_3;  -- Mode
      RW  : Bits_2;  -- Read/Write
      SC  : Bits_2;  -- Select Counter
   end record
      with Bit_Order => Low_Order_First,
           Size      => 8;
   for PIT_Control_Word_Type use record
      BCD at 0 range 0 .. 0;
      M   at 0 range 1 .. 3;
      RW  at 0 range 4 .. 5;
      SC  at 0 range 6 .. 7;
   end record;

   -- Counter Latching Command Format

   type PIT_Counter_Latching_Command_Type is record
      DontCare : Bits_4 := 0;
      RW       : Bits_2 := RW_COUNTER_LATCH;
      SC       : Bits_2;                     -- Select Counter
   end record
      with Bit_Order => Low_Order_First,
           Size      => 8;
   for PIT_Counter_Latching_Command_Type use record
      DontCare at 0 range 0 .. 3;
      RW       at 0 range 4 .. 5;
      SC       at 0 range 6 .. 7;
   end record;

   -- Read-Back Command Format

   type PIT_ReadBack_Command_Type is record
      Reserved : Bits_1   := 0;
      CNT0     : Boolean;       -- Select Counter 0
      CNT1     : Boolean;       -- Select Counter 1
      CNT2     : Boolean;       -- Select Counter 2
      nSTATUS  : NBoolean;      -- Latch status of selected counters(s)
      nCOUNT   : NBoolean;      -- Latch count of selected counter(s)
      D6       : Bits_1   := 1;
      D7       : Bits_1   := 1;
   end record
      with Bit_Order => Low_Order_First,
           Size      => 8;
   for PIT_ReadBack_Command_Type use record
      Reserved at 0 range 0 .. 0;
      CNT0     at 0 range 1 .. 1;
      CNT1     at 0 range 2 .. 2;
      CNT2     at 0 range 3 .. 3;
      nSTATUS  at 0 range 4 .. 4;
      nCOUNT   at 0 range 5 .. 5;
      D6       at 0 range 6 .. 6;
      D7       at 0 range 7 .. 7;
   end record;

   -- Status Byte Format

   type PIT_Status_Byte_Type is record
      BCD        : Boolean; -- Binary Coded Decimal (BCD) Counter (4 Decades)
      M          : Bits_3;  -- Mode
      RW         : Bits_2;  -- Read/Write
      Null_Count : Boolean; -- 1 = Null Count, 0 = Count available for reading
      Output     : Boolean; -- 1 = OUT Pin is 1, 0 = OUT Pin is 0
   end record
      with Bit_Order => Low_Order_First,
           Size      => 8;
   for PIT_Status_Byte_Type use record
      BCD        at 0 range 0 .. 0;
      M          at 0 range 1 .. 3;
      RW         at 0 range 4 .. 5;
      Null_Count at 0 range 6 .. 6;
      Output     at 0 range 7 .. 7;
   end record;

   procedure PIT_Counter0_Init
      (Count : in Unsigned_16);
   procedure PIT_Counter1_Delay
      (Delay100us_Units : in Positive);

   ----------------------------------------------------------------------------
   -- MC146818A RTC
   ----------------------------------------------------------------------------

   RTC_INDEX       : constant := 0;
   RTC_DATA        : constant := 1;
   RTC_NMI_DISABLE : constant := 16#80#;

   RTC_Interrupt : constant CPU.Irq_Id_Type := PIC_Irq8;

   function RTC_Register_Read
      (Port_Address : System.Address)
      return Unsigned_8;
   procedure RTC_Register_Write
      (Port_Address : in System.Address;
       Value        : in Unsigned_8);

   ----------------------------------------------------------------------------
   -- PPI Parallel Port Interface
   ----------------------------------------------------------------------------

   PPI_DATA    : constant := PPI_BASEADDRESS + 16#00#;
   PPI_STATUS  : constant := PPI_BASEADDRESS + 16#01#;
   PPI_CONTROL : constant := PPI_BASEADDRESS + 16#02#;

   type PPI_Status_Type is record
      Unused   : Bits_2;
      IRQ      : Boolean;
      Error    : Boolean;
      SelectIn : Boolean;
      PaperOut : Boolean;
      ACK      : Boolean;
      Busy     : NBoolean; -- negated
   end record
      with Bit_Order => Low_Order_First,
           Size      => 8;
   for PPI_Status_Type use record
      Unused   at 0 range 0 .. 1;
      IRQ      at 0 range 2 .. 2;
      Error    at 0 range 3 .. 3;
      SelectIn at 0 range 4 .. 4;
      PaperOut at 0 range 5 .. 5;
      ACK      at 0 range 6 .. 6;
      Busy     at 0 range 7 .. 7;
   end record;

   type PPI_Control_Type is record
      Strobe    : NBoolean := NFalse; -- negated
      AUTOLF    : NBoolean := NFalse; -- negated
      INIT      : Boolean  := False;
      SelectOut : NBoolean := NFalse; -- negated
      IRQEN     : Boolean  := False;
      BIDIR     : Boolean  := False;
      Unused    : Bits_2   := 0;
   end record
      with Bit_Order => Low_Order_First,
           Size      => 8;
   for PPI_Control_Type use record
      Strobe    at 0 range 0 .. 0;
      AUTOLF    at 0 range 1 .. 1;
      INIT      at 0 range 2 .. 2;
      SelectOut at 0 range 3 .. 3;
      IRQEN     at 0 range 4 .. 4;
      BIDIR     at 0 range 5 .. 5;
      Unused    at 0 range 6 .. 7;
   end record;

   procedure PPI_DataIn
      (Value : out Unsigned_8);
   procedure PPI_DataOut
      (Value : in Unsigned_8);
   procedure PPI_StatusIn
      (Value : out PPI_Status_Type);
   procedure PPI_ControlIn
      (Value : out PPI_Control_Type);
   procedure PPI_ControlOut
      (Value : in PPI_Control_Type);
   procedure PPI_Init;

end PC;

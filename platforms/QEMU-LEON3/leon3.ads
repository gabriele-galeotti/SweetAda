-----------------------------------------------------------------------------------------------------------------------
--                                                     SweetAda                                                      --
-----------------------------------------------------------------------------------------------------------------------
-- __HDS__                                                                                                           --
-- __FLN__ leon3.ads                                                                                                 --
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

package LEON3
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

   type Bitmap_15 is array (1 .. 15) of Boolean
      with Component_Size => 1,
           Size           => 15;

   ----------------------------------------------------------------------------
   -- 8 Multiprocessor Interrupt Controller
   ----------------------------------------------------------------------------

   -- 8.3.1 Interrupt level register

   type INTC_LEVEL_Type is record
      Reserved1 : Bits_1;
      IL        : Bitmap_15; -- Interrupt Level n (IL[n]): Interrupt level for interrupt n.
      Reserved2 : Bits_16;
   end record
      with Bit_Order => Low_Order_First,
           Size      => 32;
   for INTC_LEVEL_Type use record
      Reserved1 at 0 range  0 ..  0;
      IL        at 0 range  1 .. 15;
      Reserved2 at 0 range 16 .. 31;
   end record;

   INTC_LEVEL_ADDRESS : constant := 16#8000_0200#;

   INTC_LEVEL : aliased INTC_LEVEL_Type
      with Address              => System'To_Address (INTC_LEVEL_ADDRESS),
           Volatile_Full_Access => True,
           Import               => True,
           Convention           => Ada;

   -- 8.3.2 Interrupt pending register

   type INTC_PENDING_Type is record
      Reserved : Bits_1;
      IP       : Bitmap_15; -- Interrupt Pending n (IP[n]): Interrupt pending for interrupt n.
      EIP      : Bitmap_16; -- Extended Interrupt Pending n (EIP[n]).
   end record
      with Bit_Order => Low_Order_First,
           Size      => 32;
   for INTC_PENDING_Type use record
      Reserved at 0 range  0 ..  0;
      IP       at 0 range  1 .. 15;
      EIP      at 0 range 16 .. 31;
   end record;

   INTC_PENDING_ADDRESS : constant := 16#8000_0204#;

   INTC_PENDING : aliased INTC_PENDING_Type
      with Address              => System'To_Address (INTC_PENDING_ADDRESS),
           Volatile_Full_Access => True,
           Import               => True,
           Convention           => Ada;

   -- 8.3.3 Interrupt force register, processor 0

   type INTC_P0FORCE_Type is record
      Reserved1 : Bits_1;
      IForce    : Bitmap_15; -- Interrupt Force n (IF[n]): Force interrupt no. n.
      Reserved2 : Bits_16;
   end record
      with Bit_Order => Low_Order_First,
           Size      => 32;
   for INTC_P0FORCE_Type use record
      Reserved1 at 0 range  0 ..  0;
      IForce    at 0 range  1 .. 15;
      Reserved2 at 0 range 16 .. 31;
   end record;

   INTC_P0FORCE_ADDRESS : constant := 16#8000_0208#;

   INTC_P0FORCE : aliased INTC_P0FORCE_Type
      with Address              => System'To_Address (INTC_P0FORCE_ADDRESS),
           Volatile_Full_Access => True,
           Import               => True,
           Convention           => Ada;

   -- 8.3.4 Interrupt clear register

   type INTC_CLEAR_Type is record
      Reserved1 : Bits_1;
      IC        : Bitmap_15; -- Interrupt Clear n (IC[n])
      Reserved2 : Bits_16;
   end record
      with Bit_Order => Low_Order_First,
           Size      => 32;
   for INTC_CLEAR_Type use record
      Reserved1 at 0 range  0 ..  0;
      IC        at 0 range  1 .. 15;
      Reserved2 at 0 range 16 .. 31;
   end record;

   INTC_CLEAR_ADDRESS : constant := 16#8000_020C#;

   INTC_CLEAR : aliased INTC_CLEAR_Type
      with Address              => System'To_Address (INTC_CLEAR_ADDRESS),
           Volatile_Full_Access => True,
           Import               => True,
           Convention           => Ada;

   -- 8.3.5 Multiprocessor status register

   type MULTIPROC_STATUS_Type is record
      PowerDown : Bitmap_16;             -- Power-down status of CPU [n]
      EIRQ      : Natural range 1 .. 15; -- EIRQ. Interrupt number (1 - 15) used for extended interrupts.
      Reserved  : Bits_7;
      BA        : Boolean;               -- Broadcast Available (BA).
      NCPU      : Natural range 0 .. 15; -- NCPU. Number of CPU’s in the system -1.
   end record
      with Bit_Order => Low_Order_First,
           Size      => 32;
   for MULTIPROC_STATUS_Type use record
      PowerDown at 0 range  0 .. 15;
      EIRQ      at 0 range 16 .. 19;
      Reserved  at 0 range 20 .. 26;
      BA        at 0 range 27 .. 27;
      NCPU      at 0 range 28 .. 31;
   end record;

   MULTIPROC_STATUS_ADDRESS : constant := 16#8000_0210#;

   MULTIPROC_STATUS : aliased MULTIPROC_STATUS_Type
      with Address              => System'To_Address (MULTIPROC_STATUS_ADDRESS),
           Volatile_Full_Access => True,
           Import               => True,
           Convention           => Ada;

   -- 8.3.6 Processor interrupt mask register

   type INTC_PROCMASK_Type is record
      Reserved : Bits_1;
      IM       : Bitmap_15; -- Interrupt Mask n (IM[n])
      EIM      : Bitmap_16; -- Interrupt mask for extended interrupts
   end record
      with Bit_Order => Low_Order_First,
           Size      => 32;
   for INTC_PROCMASK_Type use record
      Reserved at 0 range  0 ..  0;
      IM       at 0 range  1 .. 15;
      EIM      at 0 range 16 .. 31;
   end record;

   INTC_PROCMASK0_ADDRESS : constant := 16#8000_0240#;

   INTC_PROCMASK0 : aliased INTC_PROCMASK_Type
      with Address              => System'To_Address (INTC_PROCMASK0_ADDRESS),
           Volatile_Full_Access => True,
           Import               => True,
           Convention           => Ada;

   INTC_PROCMASK1_ADDRESS : constant := 16#8000_0244#;

   INTC_PROCMASK1 : aliased INTC_PROCMASK_Type
      with Address              => System'To_Address (INTC_PROCMASK1_ADDRESS),
           Volatile_Full_Access => True,
           Import               => True,
           Convention           => Ada;

   -- 8.3.7 Broadcast register

   type INTC_BROADCAST_Type is record
      Reserved1 : Bits_1;
      IM        : Bitmap_15; -- Broadcast Mask n (BM[n])
      Reserved2 : Bits_16;
   end record
      with Bit_Order => Low_Order_First,
           Size      => 32;
   for INTC_BROADCAST_Type use record
      Reserved1 at 0 range  0 ..  0;
      IM        at 0 range  1 .. 15;
      Reserved2 at 0 range 16 .. 31;
   end record;

   INTC_BROADCAST_ADDRESS : constant := 16#8000_0214#;

   INTC_BROADCAST : aliased INTC_BROADCAST_Type
      with Address              => System'To_Address (INTC_BROADCAST_ADDRESS),
           Volatile_Full_Access => True,
           Import               => True,
           Convention           => Ada;

   -- 8.3.8 Processor interrupt force register

   type INTC_FORCE_Type is record
      Reserved1   : Bits_1;
      IForce      : Bitmap_15; -- Interrupt Force n (IF[n])
      Reserved2   : Bits_1;
      IForceClear : Bitmap_15; -- Interrupt Force Clear n (IFC[n])
   end record
      with Bit_Order => Low_Order_First,
           Size      => 32;
   for INTC_FORCE_Type use record
      Reserved1   at 0 range  0 ..  0;
      IForce      at 0 range  1 .. 15;
      Reserved2   at 0 range 16 .. 16;
      IForceClear at 0 range 17 .. 31;
   end record;

   INTC_FORCE0_ADDRESS : constant := 16#8000_0280#;

   INTC_FORCE0 : aliased INTC_FORCE_Type
      with Address              => System'To_Address (INTC_FORCE0_ADDRESS),
           Volatile_Full_Access => True,
           Import               => True,
           Convention           => Ada;

   INTC_FORCE1_ADDRESS : constant := 16#8000_0284#;

   INTC_FORCE1 : aliased INTC_FORCE_Type
      with Address              => System'To_Address (INTC_FORCE1_ADDRESS),
           Volatile_Full_Access => True,
           Import               => True,
           Convention           => Ada;

   -- 8.3.9 Extended interrupt identification register

   type INTC_EXTINTID_Type is record
      EID      : Natural range 16 .. 31; -- ID (16 - 31) of the acknowledged extended interrupt.
      Reserved : Bits_27;
   end record
      with Bit_Order => Low_Order_First,
           Size      => 32;
   for INTC_EXTINTID_Type use record
      EID      at 0 range 0 ..  4;
      Reserved at 0 range 5 .. 31;
   end record;

   INTC_EXTINTID0_ADDRESS : constant := 16#8000_02C0#;

   INTC_EXTINTID0 : aliased INTC_EXTINTID_Type
      with Address              => System'To_Address (INTC_EXTINTID0_ADDRESS),
           Volatile_Full_Access => True,
           Import               => True,
           Convention           => Ada;

   INTC_EXTINTID1_ADDRESS : constant := 16#8000_02C4#;

   INTC_EXTINTID1 : aliased INTC_EXTINTID_Type
      with Address              => System'To_Address (INTC_EXTINTID1_ADDRESS),
           Volatile_Full_Access => True,
           Import               => True,
           Convention           => Ada;

   ----------------------------------------------------------------------------
   -- 11 General Purpose Timer Unit
   ----------------------------------------------------------------------------

   -- 11.3 Registers

   type GPTimer_Configuration_Type is record
      Timers   : Natural range 0 .. 7;  -- Number of implemented timers.
      IRQ      : Natural range 0 .. 31; -- Interrupt ID of first timer.
      SI       : Boolean;               -- Separate interrupts
      DF       : Boolean;               -- Disable timer freeze
      Reserved : Bits_22;
   end record
      with Bit_Order => Low_Order_First,
           Size      => 32;
   for GPTimer_Configuration_Type use record
      Timers   at 0 range  0 ..  2;
      IRQ      at 0 range  3 ..  7;
      SI       at 0 range  8 ..  8;
      DF       at 0 range  9 ..  9;
      Reserved at 0 range 10 .. 31;
   end record;

   type GPTimer_Control_Register_Type is record
      EN       : Boolean; -- Enable
      RS       : Boolean; -- Restart
      LD       : Boolean; -- Load
      IE       : Boolean; -- Interrupt Enable
      IP       : Boolean; -- Interrupt Pending
      CH       : Boolean; -- Chain
      DH       : Boolean; -- Debug Halt
      Reserved : Bits_25;
   end record
      with Bit_Order => Low_Order_First,
           Size      => 32;
   for GPTimer_Control_Register_Type use record
      EN       at 0 range 0 ..  0;
      RS       at 0 range 1 ..  1;
      LD       at 0 range 2 ..  2;
      IE       at 0 range 3 ..  3;
      IP       at 0 range 4 ..  4;
      CH       at 0 range 5 ..  5;
      DH       at 0 range 6 ..  6;
      Reserved at 0 range 7 .. 31;
   end record;

   type GPTimer_Type is record
      Scaler_Value        : Unsigned_32 range 0 .. 2**16 - 1 with Volatile_Full_Access => True;
      Scaler_Reload_Value : Unsigned_32 range 0 .. 2**16 - 1 with Volatile_Full_Access => True;
      Configuration       : Unsigned_32                      with Volatile_Full_Access => True;
      Unused1             : Unsigned_32;
      Counter_1           : Unsigned_32                      with Volatile_Full_Access => True;
      Reload_1            : Unsigned_32                      with Volatile_Full_Access => True;
      Control_Register_1  : GPTimer_Control_Register_Type    with Volatile_Full_Access => True;
      Unused2             : Unsigned_32;
      Counter_2           : Unsigned_32                      with Volatile_Full_Access => True;
      Reload_2            : Unsigned_32                      with Volatile_Full_Access => True;
      Control_Register_2  : GPTimer_Control_Register_Type    with Volatile_Full_Access => True;
      Unused3             : Unsigned_32;
      Counter_3           : Unsigned_32                      with Volatile_Full_Access => True;
      Reload_3            : Unsigned_32                      with Volatile_Full_Access => True;
      Control_Register_3  : GPTimer_Control_Register_Type    with Volatile_Full_Access => True;
      Unused4             : Unsigned_32;
      Counter_4           : Unsigned_32                      with Volatile_Full_Access => True;
      Reload_4            : Unsigned_32                      with Volatile_Full_Access => True;
      Control_Register_4  : GPTimer_Control_Register_Type    with Volatile_Full_Access => True;
   end record
      with Alignment => 4,
           Size      => 19 * 32;
   for GPTimer_Type use record
      Scaler_Value        at 16#00# range 0 .. 31;
      Scaler_Reload_Value at 16#04# range 0 .. 31;
      Configuration       at 16#08# range 0 .. 31;
      Unused1             at 16#0C# range 0 .. 31;
      Counter_1           at 16#10# range 0 .. 31;
      Reload_1            at 16#14# range 0 .. 31;
      Control_Register_1  at 16#18# range 0 .. 31;
      Unused2             at 16#1C# range 0 .. 31;
      Counter_2           at 16#20# range 0 .. 31;
      Reload_2            at 16#24# range 0 .. 31;
      Control_Register_2  at 16#28# range 0 .. 31;
      Unused3             at 16#2C# range 0 .. 31;
      Counter_3           at 16#30# range 0 .. 31;
      Reload_3            at 16#34# range 0 .. 31;
      Control_Register_3  at 16#38# range 0 .. 31;
      Unused4             at 16#3C# range 0 .. 31;
      Counter_4           at 16#40# range 0 .. 31;
      Reload_4            at 16#44# range 0 .. 31;
      Control_Register_4  at 16#48# range 0 .. 31;
   end record;

   GPTIMER_BASEADDRESS : constant := 16#8000_0300#;

   GPTIMER : aliased GPTimer_Type
      with Address    => System'To_Address (GPTIMER_BASEADDRESS),
           Volatile   => True,
           Import     => True,
           Convention => Ada;

   -- subprograms

   procedure Tclk_Init;

   ----------------------------------------------------------------------------
   -- 15 UART Serial Interface
   ----------------------------------------------------------------------------

   -- 15.7.2 UART Status Register

   type UART_Status_Register_Type is record
      DR       : Boolean; -- Data ready
      TS       : Boolean; -- Transmitter shift register empty
      TE       : Boolean; -- Transmitter FIFO empty
      BR       : Boolean; -- Break received
      OV       : Boolean; -- Overrun
      PE       : Boolean; -- Parity error
      FE       : Boolean; -- Framing error
      TH       : Boolean; -- Transmitter FIFO half-full
      RH       : Boolean; -- Receiver FIFO half-full
      TF       : Boolean; -- Transmitter FIFO full
      RF       : Boolean; -- Receiver FIFO full
      Reserved : Bits_9;
      TCNT     : Bits_6;  -- Transmitter FIFO count
      RCNT     : Bits_6;  -- Receiver FIFO count
   end record
      with Bit_Order => Low_Order_First,
           Size      => 32;
   for UART_Status_Register_Type use record
      DR       at 0 range  0 ..  0;
      TS       at 0 range  1 ..  1;
      TE       at 0 range  2 ..  2;
      BR       at 0 range  3 ..  3;
      OV       at 0 range  4 ..  4;
      PE       at 0 range  5 ..  5;
      FE       at 0 range  6 ..  6;
      TH       at 0 range  7 ..  7;
      RH       at 0 range  8 ..  8;
      TF       at 0 range  9 ..  9;
      RF       at 0 range 10 .. 10;
      Reserved at 0 range 11 .. 19;
      TCNT     at 0 range 20 .. 25;
      RCNT     at 0 range 26 .. 31;
   end record;

   -- 15.7.3 UART Control Register

   PS_EVEN : constant := 0;
   PS_ODD  : constant := 1;

   type UART_Control_Register_Type is record
      RE       : Boolean; -- Receiver enable
      TE       : Boolean; -- Transmitter enable
      RI       : Boolean; -- Receiver interrupt enable
      TI       : Boolean; -- Transmitter interrupt enable
      PS       : Bits_1;  -- Parity select
      PE       : Boolean; -- Parity enable
      Unused1  : Bits_1;
      LB       : Boolean; -- Loop back
      Unused2  : Bits_1;
      TF       : Boolean; -- Transmitter FIFO interrupt enable
      RF       : Boolean; -- Receiver FIFO interrupt enable
      DB       : Boolean; -- FIFO debug mode enable
      Unused3  : Bits_1;
      Reserved : Bits_18;
      FA       : Boolean; -- FIFOs available
   end record
      with Bit_Order => Low_Order_First,
           Size      => 32;
   for UART_Control_Register_Type use record
      RE       at 0 range  0 ..  0;
      TE       at 0 range  1 ..  1;
      RI       at 0 range  2 ..  2;
      TI       at 0 range  3 ..  3;
      PS       at 0 range  4 ..  4;
      PE       at 0 range  5 ..  5;
      Unused1  at 0 range  6 ..  6;
      LB       at 0 range  7 ..  7;
      Unused2  at 0 range  8 ..  8;
      TF       at 0 range  9 ..  9;
      RF       at 0 range 10 .. 10;
      DB       at 0 range 11 .. 11;
      Unused3  at 0 range 12 .. 12;
      Reserved at 0 range 13 .. 30;
      FA       at 0 range 31 .. 31;
   end record;

   type APB_UART_Type is record
      Data_Register       : Unsigned_32                with Volatile_Full_Access => True;
      Status_Register     : UART_Status_Register_Type  with Volatile_Full_Access => True;
      Control_Register    : UART_Control_Register_Type with Volatile_Full_Access => True;
      Scaler_Register     : Unsigned_32                with Volatile_Full_Access => True;
      FIFO_Debug_Register : Unsigned_32                with Volatile_Full_Access => True;
   end record
      with Alignment => 4,
           Size      => 5 * 32;
   for APB_UART_Type use record
      Data_Register       at 16#00# range 0 .. 31;
      Status_Register     at 16#04# range 0 .. 31;
      Control_Register    at 16#08# range 0 .. 31;
      Scaler_Register     at 16#0C# range 0 .. 31;
      FIFO_Debug_Register at 16#10# range 0 .. 31;
   end record;

   APB_UART1_BASEADDRESS : constant := 16#8000_0100#;

   UART1 : aliased APB_UART_Type
      with Address    => System'To_Address (APB_UART1_BASEADDRESS),
           Volatile   => True,
           Import     => True,
           Convention => Ada;

   -- subprograms

   procedure UART1_Init;
   procedure UART1_TX
      (Data : in Unsigned_8);
   procedure UART1_RX
      (Data : out Unsigned_8);

end LEON3;

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
   -- B.32 Triple Timer Counter (ttc)
   ----------------------------------------------------------------------------

   -- XTTCPS_CLK_CNTRL_OFFSET

   type XTTCPS_CLK_CNTRL_Type is
   record
      PS_EN    : Boolean;
      PS_VAL   : Bits_4;
      SRC      : Bits_1;
      EXT_EDGE : Bits_1;
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

   POL_WAVE_L2H : constant := 0;
   POL_WAVE_H2L : constant := 1;

   INT_OVERFLOW : constant := 0;
   INT_INTERVAL : constant := 1;

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
      Unused : Bits_16 := 0;
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

   -- XTTCPS_MATCH_0_OFFSET

   -- XTTCPS_MATCH_1_OFFSET

   -- XTTCPS_MATCH_2_OFFSET

   -- XTTCPS_ISR_OFFSET

   -- XTTCPS_IER_OFFSET

   -- Event_Control_Timer_X

   -- Event_Register_X

   -- ttc layout

   type CLK_CNTRL_Array_Type           is array (0 .. 2) of XTTCPS_CLK_CNTRL_Type    with Pack => True;
   type CNT_CNTRL_Array_Type           is array (0 .. 2) of XTTCPS_CNT_CNTRL_Type    with Pack => True;
   type COUNT_VALUE_Array_Type         is array (0 .. 2) of XTTCPS_COUNT_VALUE_Type  with Pack => True;
   type INTERVAL_VAL_Array_Type        is array (0 .. 2) of XTTCPS_INTERVAL_VAL_Type with Pack => True;
   type MATCH_1_Array_Type             is array (0 .. 2) of Unsigned_32              with Pack => True;
   type MATCH_2_Array_Type             is array (0 .. 2) of Unsigned_32              with Pack => True;
   type MATCH_3_Array_Type             is array (0 .. 2) of Unsigned_32              with Pack => True;
   type ISR_Array_Type                 is array (0 .. 2) of Unsigned_32              with Pack => True;
   type IER_Array_Type                 is array (0 .. 2) of Unsigned_32              with Pack => True;
   type Event_Control_Timer_Array_Type is array (0 .. 2) of Unsigned_32              with Pack => True;
   type Event_Register_Array_Type      is array (0 .. 2) of Unsigned_32              with Pack => True;

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

   -- XUARTPS_CR_OFFSET

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
      Unused   : Bits_23 := 0;
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
      Unused   at 0 range 9 .. 31;
   end record;

   -- XUARTPS_MR_OFFSET

   type XUARTPS_MR_Type is
   record
      Unused : Bits_32 := 0;
   end record with
      Bit_Order => Low_Order_First,
      Size      => 32;
   for XUARTPS_MR_Type use
   record
      Unused at 0 range 0 .. 31;
   end record;

   -- XUARTPS_SR_OFFSET

   type XUARTPS_SR_Type is
   record
      RXOVR   : Boolean;
      RXEMPTY : Boolean;
      RXFULL  : Boolean;
      TXEMPTY : Boolean;
      Unused  : Bits_28 := 0;
   end record with
      Bit_Order => Low_Order_First,
      Size      => 32;
   for XUARTPS_SR_Type use
   record
      RXOVR   at 0 range 0 .. 0;
      RXEMPTY at 0 range 1 .. 1;
      RXFULL  at 0 range 2 .. 2;
      TXEMPTY at 0 range 3 .. 3;
      Unused  at 0 range 4 .. 31;
   end record;

   -- UART layout

   type UART_Type is
   record
      CR   : XUARTPS_CR_Type with Volatile_Full_Access => True;
      MR   : XUARTPS_MR_Type with Volatile_Full_Access => True;
      SR   : XUARTPS_SR_Type with Volatile_Full_Access => True;
      FIFO : Unsigned_32     with Volatile_Full_Access => True;
   end record with
      Alignment => 4;
   for UART_Type use
   record
      CR   at 16#00# range 0 .. 31;
      MR   at 16#04# range 0 .. 31;
      SR   at 16#2C# range 0 .. 31;
      FIFO at 16#30# range 0 .. 31;
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

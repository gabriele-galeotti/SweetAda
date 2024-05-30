-----------------------------------------------------------------------------------------------------------------------
--                                                     SweetAda                                                      --
-----------------------------------------------------------------------------------------------------------------------
-- __HDS__                                                                                                           --
-- __FLN__ neorv32.ads                                                                                               --
-- __DSC__                                                                                                           --
-- __HSH__ e69de29bb2d1d6434b8b29ae775ad8c2e48c5391                                                                  --
-- __HDE__                                                                                                           --
-----------------------------------------------------------------------------------------------------------------------
-- Copyright (C) 2020-2024 Gabriele Galeotti                                                                         --
--                                                                                                                   --
-- SweetAda web page: http://sweetada.org                                                                            --
-- contact address: gabriele.galeotti@sweetada.org                                                                   --
-- This work is licensed under the terms of the MIT License.                                                         --
-- Please consult the LICENSE.txt file located in the top-level directory.                                           --
-----------------------------------------------------------------------------------------------------------------------

with System;
with Interfaces;
with Bits;

package NEORV32
  with Preelaborate => True,
  Elaborate_Body => True
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

   -- NEORV32 Litex registers

   -- CTRL Periferal

   type RESET_Type is record
      SOC_RST : Boolean; -- Write `1` to this register to reset the full SoC (Pulse Reset)
      CPU_RST : Boolean; -- Write `1` to this register to reset the CPU(s) of the SoC (Hold Reset)
   end record
     with Size => 32;
   for RESET_Type use record
      SOC_RST at 0 range 0 .. 0;
      CPU_RST at 0 range 1 .. 1;
   end record;

   type CTRL_Type is record
      RESET : RESET_Type;
      SCRATCH : Unsigned_32; -- Use this register as a scratch space to verify that software read/write accesses to the Wishbone/CSR bus are working correctly. The initial reset value of 0x1234578 can be used to verify endianness.
      BUS_ERRORS : Unsigned_32; -- Total number of Wishbone bus errors (timeouts) since start.
   end record
     with Size => 3 * 32;
   for CTRL_Type use record
      RESET      at 16#0# range 0 .. 31;
      SCRATCH    at 16#4# range 0 .. 31;
      BUS_ERRORS at 16#8# range 0 .. 31;
   end record;

   CTRL_ADDRESS : constant := 16#F000_0000#;

   CTRL : aliased CTRL_Type
     with Address   => System'To_Address (CTRL_ADDRESS),
     Volatile  => True,
     Import => True,
     Convention => Ada;

   -- LEDS (and a GPIO Mockup)

   type LEDS_Type is record
      LEDS : Bitmap_8;
   end record
     with Size => 32;
   for LEDS_Type use record
      LEDS at 0 range 0 .. 7;
   end record;

   LEDS_ADDRESS : constant := 16#F000_1000#;

   LEDS : aliased LEDS_Type
     with Address => System'To_Address (LEDS_ADDRESS),
     Volatile => False,
     Import => True,
     Convention => Ada;
   
   -- GPIO added for compatibility reasons. Litex/NEORV32 does not support it
   type GPIO_Type is record
      OUTPUT_LO : Bitmap_32 with Volatile_Full_Access => True;
   end record
      with Size => 32;
   for GPIO_Type use record
      OUTPUT_LO at 0 range 0 .. 31;
   end record;

   GPIO_ADDRESS : constant := 16#F000_1000#;

   GPIO : aliased GPIO_Type
      with Address    => System'To_Address (GPIO_ADDRESS),
           Volatile   => True,
           Import     => True,
           Convention => Ada;

   -- SDRAM (NOT IMPLEMENTED)

   -- SPI-SDCARD (NOT IMPLEMENTED)

   -- TIMER

   type TIMER_0_Type is record
      LOAD : Unsigned_32; -- Load value when Timer is (re-)enabled. In One-Shot mode, the value written to this register specifies the Timer's duration in clock cycles.
      RELOAD : Unsigned_32; -- Reload value when Timer reaches ``0``. In Periodic mode, the value written to this register specify the Timer's period in clock cycles.
      EN : Boolean := False; -- Enable flag of the Timer. Set this flag to ``1`` to enable/start the Timer.  Set ``0`` to disable the Timer.
      UPDATE_VALUE : Boolean; -- Update trigger for the current countdown value. A write to this register latches the current countdown value to ``value`` register.
      VALUE : Unsigned_32; -- Latched countdown value. This value is updated by writing to ``update_value``.
      EV_STATUS : Boolean; -- This register contains the current raw level of the zero event trigger.  Writes to this register have no effect.
      EV_PENDING : Boolean; -- When a  zero event occurs, the corresponding bit will be set in this register. To clear the Event, set the corresponding bit in this register. `1` if a `zero` event occurred. This Event is triggered on a **falling** edge.
      EV_ENABLE : Boolean; -- This register enables the corresponding zero events.  Write a ``0`` to this register to disable individual events. Write a ``1`` to enable the ``zero`` Event
   end record
     with Size => 8 * 32;
   for TIMER_0_Type use record
      LOAD at 16#00# range 0 .. 31;
      RELOAD at 16#04# range 0 .. 31;
      EN at 16#08# range 0 .. 0;
      UPDATE_VALUE at 16#0C# range 0 .. 0;
      VALUE at 16#10# range 0 .. 31;
      EV_STATUS at 16#14# range 0 .. 0;
      EV_PENDING at 16#18# range 0 .. 0;
      EV_ENABLE at 16#1C# range 0 .. 0;
   end record;

   TIMER_0_Address : constant := 16#F000_2800#;

   TIMER_0 : aliased TIMER_0_Type
     with Address => System'To_Address (TIMER_0_Address),
     Volatile => True,
     Import => True,
     Convention => Ada;

   -- UART

   type EV_STATUS_Type is record
      -- This register contains the current raw level of the rx event trigger.  Writes to this register have no effect.
      TX : Boolean; -- Level of the ``tx`` event
      RX : Boolean; -- Level of the ``rx`` event
   end record
     with Size => 32,
     Volatile_Full_Access => True;

   for EV_STATUS_Type use record
      TX at 0 range 0 .. 0;
      RX at 0 range 1 .. 1;
   end record;

   type EV_PENDING_Type is record
      -- When a  rx event occurs, the corresponding bit will be set in this register.  To clear the Event, set the corresponding bit in this register.
      TX : Boolean; -- `1` if a `tx` event occurred. This Event is triggered on a **falling** edge.
      RX : Boolean; -- `1` if a `rx` event occurred. This Event is triggered on a **falling** edge.
   end record
     with Size => 32,
     Volatile => True,
     Volatile_Full_Access => True;

   for EV_PENDING_Type use record
      TX at 0 range 0 .. 0;
      RX at 0 range 1 .. 1;
   end record;

   type EV_ENABLE_Type is record
      -- This register enables the corresponding rx events.  Write a ``0`` to this register to disable individual events.
      TX : Boolean; -- Write a ``1`` to enable the ``tx`` Event
      RX : Boolean; -- Write a ``1`` to enable the ``rx`` Event
   end record
     with Size => 32,
     Volatile_Full_Access => True;

   for EV_ENABLE_Type use record
      TX at 0 range 0 .. 0;
      RX at 0 range 1 .. 1;
   end record;

   type UART_Type is record
      RXTX : Unsigned_8;
      TXFULL : Boolean;
      RXEMPTY : Boolean;
      EV_STATUS : EV_STATUS_Type;
      EV_PENDING : EV_PENDING_Type;
      EV_ENABLE : EV_ENABLE_Type;
      TXEMPTY : Boolean;
      RXFULL : Boolean;
   end record
     with Size => 8 * 32;

   for UART_Type use record
      RXTX at 16#00# range 0 .. 7;
      TXFULL at 16#04# range 0 .. 0;
      RXEMPTY at 16#08# range 0 .. 0;
      EV_STATUS at 16#0C# range 0 .. 31;
      EV_PENDING at 16#10# range 0 .. 31;
      EV_ENABLE at 16#14# range 0 .. 31;
      TXEMPTY at 16#18# range 0 .. 0;
      RXFULL at 16#1C# range 0 .. 0;
   end record;

   UART_Address : constant := 16#F000_3000#;

   UART : aliased UART_Type
     with Address => System'To_Address (UART_Address),
     Volatile => True,
     Import => True,
     Convention => Ada;

end NEORV32;

-----------------------------------------------------------------------------------------------------------------------
--                                                     SweetAda                                                      --
-----------------------------------------------------------------------------------------------------------------------
-- __HDS__                                                                                                           --
-- __FLN__ mcf5373.ads                                                                                               --
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
with System.Storage_Elements;
with Interfaces;
with Bits;

package MCF5373
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
   use System.Storage_Elements;
   use Interfaces;
   use Bits;

   ----------------------------------------------------------------------------
   -- MCF5373 definitions
   ----------------------------------------------------------------------------

   -- 5.2.1 Cache Control Register (CACR)

   DCM_WT      : constant := 2#00#; -- Cacheable, write-through
   DCM_CB      : constant := 2#01#; -- Cacheable, copy-back
   DCM_INH_PEM : constant := 2#10#; -- Cache-inhibited, precise exception model
   DCM_INH_IEM : constant := 2#11#; -- Cache-inhibited, imprecise exception model.

   DNFB_N : constant := 0; -- Fill buffer not used to store noncacheable instruction accesses (16 or 32 bits).
   DNFB_Y : constant := 1; -- Fill buffer used to store noncacheable accesses.

   HLCK_NORMAL : constant := 0; -- Normal operation.
   HLCK_HALF   : constant := 1; -- Half cache operation.

   type CACR_Type is record
      Reserved1 : Bits_4;
      EUSP      : Boolean; -- Enable user stack pointer.
      DW        : Boolean; -- Default write protect.
      Reserved2 : Bits_2;
      DCM       : Bits_2;  -- Default cache mode.
      DNFB      : Bits_1;  -- Default noncacheable fill buffer
      Reserved3 : Bits_13;
      CINVA     : Boolean; -- Cache invalidate all.
      Reserved4 : Bits_2;
      HLCK      : Bits_1;  -- Half cache lock mode
      DPI       : Boolean; -- Disable CPUSHL invalidation.
      ESB       : Boolean; -- Enable store buffer.
      Reserved5 : Bits_1;
      EC        : Boolean; -- Enable cache.
   end record
      with Bit_Order => Low_Order_First,
           Size      => 32;
   for CACR_Type use record
      Reserved1 at 0 range  0 ..  3;
      EUSP      at 0 range  4 ..  4;
      DW        at 0 range  5 ..  5;
      Reserved2 at 0 range  6 ..  7;
      DCM       at 0 range  8 ..  9;
      DNFB      at 0 range 10 .. 10;
      Reserved3 at 0 range 11 .. 23;
      CINVA     at 0 range 24 .. 24;
      Reserved4 at 0 range 25 .. 26;
      HLCK      at 0 range 27 .. 27;
      DPI       at 0 range 28 .. 28;
      ESB       at 0 range 29 .. 29;
      Reserved5 at 0 range 30 .. 30;
      EC        at 0 range 31 .. 31;
   end record;

   -- 5.2.2 Access Control Registers (ACR0–ACR1)

   CM_WT      : constant := 2#00#; -- Cacheable, write-through
   CM_CB      : constant := 2#01#; -- Cacheable, copyback
   CM_INH_PEM : constant := 2#10#; -- Cache-inhibited, precise
   CM_INH_IEM : constant := 2#11#; -- Cache-inhibited, imprecise

   S_USER : constant := 2#00#; -- Match addresses only in user mode
   S_SV   : constant := 2#01#; -- Match addresses only in supervisor mode
   S_ALL  : constant := 2#10#; -- Execute cache matching on all accesses

   type ACR_Type is record
      Reserved1    : Bits_2;
      W            : Boolean; -- Write protect.
      Reserved2    : Bits_2;
      CM           : Bits_2;  -- Cache mode.
      Reserved3    : Bits_6;
      S            : Bits_2;  -- Supervisor mode.
      E            : Boolean; -- Enable.
      Address_Mask : Bits_8;  -- Address mask.
      Address_Base : Bits_8;  -- Address base.
   end record
      with Bit_Order => Low_Order_First,
           Size      => 32;
   for ACR_Type use record
      Reserved1    at 0 range  0 ..  1;
      W            at 0 range  2 ..  2;
      Reserved2    at 0 range  3 ..  4;
      CM           at 0 range  5 ..  6;
      Reserved3    at 0 range  7 .. 12;
      S            at 0 range 13 .. 14;
      E            at 0 range 15 .. 15;
      Address_Mask at 0 range 16 .. 23;
      Address_Base at 0 range 24 .. 31;
   end record;

   -- 9.3.3 Chip Identification Register (CIR)

   type CIR_Type is record
      PRN : Bits_6;  -- Part revision number
      PIN : Bits_10; -- Part identification number
   end record
      with Bit_Order => Low_Order_First,
           Size      => 16;
   for CIR_Type use record
      PRN at 0 range 0 ..  5;
      PIN at 0 range 6 .. 15;
   end record;

   CIR : aliased CIR_Type
      with Address              => To_Address (16#FC0A_000A#),
           Volatile_Full_Access => True,
           Import               => True,
           Convention           => Ada;

   -- 13.3.1 Port Output Data Registers (PODR_x)

   type PODR_TIMER_Type is record
      PODR_0   : Boolean;
      PODR_1   : Boolean;
      PODR_2   : Boolean;
      PODR_3   : Boolean;
      Reserved : Bits_4;
   end record
      with Bit_Order => Low_Order_First,
           Size      => 8;
   for PODR_TIMER_Type use record
      PODR_0   at 0 range 0 .. 0;
      PODR_1   at 0 range 1 .. 1;
      PODR_2   at 0 range 2 .. 2;
      PODR_3   at 0 range 3 .. 3;
      Reserved at 0 range 4 .. 7;
   end record;

   PODR_TIMER : aliased PODR_TIMER_Type
      with Address              => To_Address (16#FC0A_400B#),
           Volatile_Full_Access => True,
           Import               => True,
           Convention           => Ada;

   -- 13.3.2 Port Data Direction Registers (PDDR_x)

   type PDDR_TIMER_Type is record
      PDDR_0   : Boolean;
      PDDR_1   : Boolean;
      PDDR_2   : Boolean;
      PDDR_3   : Boolean;
      Reserved : Bits_4;
   end record
      with Bit_Order => Low_Order_First,
           Size      => 8;
   for PDDR_TIMER_Type use record
      PDDR_0   at 0 range 0 .. 0;
      PDDR_1   at 0 range 1 .. 1;
      PDDR_2   at 0 range 2 .. 2;
      PDDR_3   at 0 range 3 .. 3;
      Reserved at 0 range 4 .. 7;
   end record;

   PDDR_TIMER : aliased PDDR_TIMER_Type
      with Address              => To_Address (16#FC0A_401F#),
           Volatile_Full_Access => True,
           Import               => True,
           Convention           => Ada;

   -- 13.3.3 Port Pin Data/Set Data Registers (PPDSDR_x)

   type PPDSDR_TIMER_Type is record
      PPDSDR_0 : Boolean;
      PPDSDR_1 : Boolean;
      PPDSDR_2 : Boolean;
      PPDSDR_3 : Boolean;
      Reserved : Bits_4;
   end record
      with Bit_Order => Low_Order_First,
           Size      => 8;
   for PPDSDR_TIMER_Type use record
      PPDSDR_0 at 0 range 0 .. 0;
      PPDSDR_1 at 0 range 1 .. 1;
      PPDSDR_2 at 0 range 2 .. 2;
      PPDSDR_3 at 0 range 3 .. 3;
      Reserved at 0 range 4 .. 7;
   end record;

   PPDSDR_TIMER : aliased PPDSDR_TIMER_Type
      with Address              => To_Address (16#FC0A_4033#),
           Volatile_Full_Access => True,
           Import               => True,
           Convention           => Ada;

   -- 13.3.5.6 Timer Pin Assignment Registers (PAR_TIMER)

   PAR_T0IN_GPIO   : constant := 2#00#;
   PAR_T0IN_nDREQ0 : constant := 2#01#;
   PAR_T0IN_T0OUT  : constant := 2#10#;
   PAR_T0IN_T0IN   : constant := 2#11#;

   PAR_T1IN_GPIO   : constant := 2#00#;
   PAR_T1IN_nDACK1 : constant := 2#01#;
   PAR_T1IN_T1OUT  : constant := 2#10#;
   PAR_T1IN_T1IN   : constant := 2#11#;

   PAR_T2IN_GPIO   : constant := 2#00#;
   PAR_T2IN_U2TXD  : constant := 2#01#;
   PAR_T2IN_T2OUT  : constant := 2#10#;
   PAR_T2IN_T2IN   : constant := 2#11#;

   PAR_T3IN_GPIO   : constant := 2#00#;
   PAR_T3IN_U2RXD  : constant := 2#01#;
   PAR_T3IN_T3OUT  : constant := 2#10#;
   PAR_T3IN_T3IN   : constant := 2#11#;

   type PAR_TIMER_Type is record
      PAR_T0IN : Bits_2; -- DMA Timer 0 pin assignment
      PAR_T1IN : Bits_2; -- DMA Timer 1 pin assignment
      PAR_T2IN : Bits_2; -- DMA Timer 2 pin assignment
      PAR_T3IN : Bits_2; -- DMA Timer 3 pin assignment
   end record
      with Bit_Order => Low_Order_First,
           Size      => 8;
   for PAR_TIMER_Type use record
      PAR_T0IN at 0 range 0 .. 1;
      PAR_T1IN at 0 range 2 .. 3;
      PAR_T2IN at 0 range 4 .. 5;
      PAR_T3IN at 0 range 6 .. 7;
   end record;

   PAR_TIMER : aliased PAR_TIMER_Type
      with Address              => To_Address (16#FC0A_405C#),
           Volatile_Full_Access => True,
           Import               => True,
           Convention           => Ada;

   -- 26.2.1 Watchdog Control Register (WCR)

   type WCR_Type is record
      EN       : Boolean; -- Watchdog enable bit.
      HALTED   : Boolean; -- Halted mode bit.
      DOZE     : Boolean; -- Doze mode bit.
      WAIT     : Boolean; -- Wait mode bit.
      Reserved : Bits_12;
   end record
      with Bit_Order => Low_Order_First,
           Size      => 16;
   for WCR_Type use record
      EN       at 0 range 0 ..  0;
      HALTED   at 0 range 1 ..  1;
      DOZE     at 0 range 2 ..  2;
      WAIT     at 0 range 3 ..  3;
      Reserved at 0 range 4 .. 15;
   end record;

   WCR : aliased WCR_Type
      with Address              => To_Address (16#FC09_8000#),
           Volatile_Full_Access => True,
           Import               => True,
           Convention           => Ada;

   -- 30.3.3 UART Status Registers (USRn)

   type USR_Type is record
      RXRDY : Boolean; -- Receiver ready
      FFULL : Boolean; -- FIFO full
      TXRDY : Boolean; -- Transmitter ready
      TXEMP : Boolean; -- Transmitter empty
      OE    : Boolean; -- Overrun error
      PE    : Boolean; -- Parity error
      FE    : Boolean; -- Framing error
      RB    : Boolean; -- Received break
   end record
      with Bit_Order => Low_Order_First,
           Size      => 8;
   for USR_Type use record
      RXRDY at 0 range 0 .. 0;
      FFULL at 0 range 1 .. 1;
      TXRDY at 0 range 2 .. 2;
      TXEMP at 0 range 3 .. 3;
      OE    at 0 range 4 .. 4;
      PE    at 0 range 5 .. 5;
      FE    at 0 range 6 .. 6;
      RB    at 0 range 7 .. 7;
   end record;

   USR0 : aliased USR_Type
      with Address              => To_Address (16#FC06_0004#),
           Volatile_Full_Access => True,
           Import               => True,
           Convention           => Ada;

   -- 30.3.6 UART Receive Buffers (URBn)

   URB0 : aliased Unsigned_8
      with Address              => To_Address (16#FC06_000C#),
           Volatile_Full_Access => True,
           Import               => True,
           Convention           => Ada;

   -- 30.3.7 UART Transmit Buffers (UTBn)

   UTB0 : aliased Unsigned_8
      with Address              => To_Address (16#FC06_000C#),
           Volatile_Full_Access => True,
           Import               => True,
           Convention           => Ada;

end MCF5373;

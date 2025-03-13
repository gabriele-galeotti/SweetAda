-----------------------------------------------------------------------------------------------------------------------
--                                                     SweetAda                                                      --
-----------------------------------------------------------------------------------------------------------------------
-- __HDS__                                                                                                           --
-- __FLN__ mcf5373.ads                                                                                               --
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
   use Interfaces;
   use Bits;

pragma Style_Checks (Off);

   ----------------------------------------------------------------------------
   -- MCF5373 Reference Manual
   -- Document Number: MCF5373RM Rev. 3 12/2008
   ----------------------------------------------------------------------------

   ----------------------------------------------------------------------------
   -- Chapter 5 Cache
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
      Reserved1 : Bits_4  := 0;
      EUSP      : Boolean := False;       -- Enable user stack pointer.
      DW        : Boolean := False;       -- Default write protect.
      Reserved2 : Bits_2  := 0;
      DCM       : Bits_2  := DCM_WT;      -- Default cache mode.
      DNFB      : Bits_1  := DNFB_N;      -- Default noncacheable fill buffer
      Reserved3 : Bits_13 := 0;
      CINVA     : Boolean := False;       -- Cache invalidate all.
      Reserved4 : Bits_2  := 0;
      HLCK      : Bits_1  := HLCK_NORMAL; -- Half cache lock mode
      DPI       : Boolean := False;       -- Disable CPUSHL invalidation.
      ESB       : Boolean := False;       -- Enable store buffer.
      Reserved5 : Bits_1  := 0;
      EC        : Boolean := False;       -- Enable cache.
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
      Reserved1    : Bits_2  := 0;
      W            : Boolean := False;  -- Write protect.
      Reserved2    : Bits_2  := 0;
      CM           : Bits_2  := CM_WT;  -- Cache mode.
      Reserved3    : Bits_6  := 0;
      S            : Bits_2  := S_USER; -- Supervisor mode.
      E            : Boolean := False;  -- Enable.
      Address_Mask : Bits_8  := 0;      -- Address mask.
      Address_Base : Bits_8  := 0;      -- Address base.
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

   ----------------------------------------------------------------------------
   -- Chapter 9 Chip Configuration Module (CCM)
   ----------------------------------------------------------------------------

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
      with Address              => System'To_Address (16#FC0A_000A#),
           Volatile_Full_Access => True,
           Import               => True,
           Convention           => Ada;

   ----------------------------------------------------------------------------
   -- Chapter 13 General Purpose I/O Module
   ----------------------------------------------------------------------------

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
      with Address              => System'To_Address (16#FC0A_400B#),
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
      with Address              => System'To_Address (16#FC0A_401F#),
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
      with Address              => System'To_Address (16#FC0A_4033#),
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
      with Address              => System'To_Address (16#FC0A_405C#),
           Volatile_Full_Access => True,
           Import               => True,
           Convention           => Ada;

   ----------------------------------------------------------------------------
   -- Chapter 26 Watchdog Timer Module
   ----------------------------------------------------------------------------

   -- 26.2.1 Watchdog Control Register (WCR)

   type WCR_Type is record
      EN       : Boolean := True; -- Watchdog enable bit.
      HALTED   : Boolean := True; -- Halted mode bit.
      DOZE     : Boolean := True; -- Doze mode bit.
      WAIT     : Boolean := True; -- Wait mode bit.
      Reserved : Bits_12 := 0;
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
      with Address              => System'To_Address (16#FC09_8000#),
           Volatile_Full_Access => True,
           Import               => True,
           Convention           => Ada;

   ----------------------------------------------------------------------------
   -- Chapter 30 UART Modules
   ----------------------------------------------------------------------------

   -- 30.3.1 UART Mode Registers 1 (UMR1n)

   B_C_5 : constant := 2#00#; -- 5 bits
   B_C_6 : constant := 2#01#; -- 6 bits
   B_C_7 : constant := 2#10#; -- 7 bits
   B_C_8 : constant := 2#11#; -- 8 bits

   -- With parity
   PT_EVEN    : constant := 0; -- Even parity
   PT_ODD     : constant := 1; -- Odd parity
   -- Force parity
   PT_LOW     : constant := 0; -- Low parity
   PT_HIGH    : constant := 1; -- High parity
   -- Multidrop mode
   PT_DATA    : constant := 0; -- Low parity
   PT_ADDRESS : constant := 1; -- High parity

   PM_WITHPARITY    : constant := 2#00#; -- With parity
   PM_FORCEPARITY   : constant := 2#01#; -- Force parity
   PM_NOPARITY      : constant := 2#10#;
   PM_MULTIDROPMODE : constant := 2#11#; -- Multidrop mode

   ERR_CHARACTER : constant := 0; -- Character mode.
   ERR_BLOCK     : constant := 1; -- Block mode.

   RXIRQ_FFULL_RXRDY : constant := 0; -- RXRDY is the source generating interrupt or DMA requests.
   RXIRQ_FFULL_FFULL : constant := 1; -- FFULL is the source generating interrupt or DMA requests.

   type UMR1_Type is record
      B_C         : Bits_2  := B_C_5;             -- Bits per character.
      PT          : Bits_1  := PT_EVEN;           -- Parity type.
      PM          : Bits_2  := PM_WITHPARITY;     -- Parity mode.
      ERR         : Bits_1  := ERR_CHARACTER;     -- Error mode.
      RXIRQ_FFULL : Bits_1  := RXIRQ_FFULL_RXRDY; -- Receiver interrupt select.
      RXRTS       : Boolean := False;             -- Receiver request-to-send.
   end record
      with Bit_Order => Low_Order_First,
           Size      => 8;
   for UMR1_Type use record
      B_C         at 0 range 0 .. 1;
      PT          at 0 range 2 .. 2;
      PM          at 0 range 3 .. 4;
      ERR         at 0 range 5 .. 5;
      RXIRQ_FFULL at 0 range 6 .. 6;
      RXRTS       at 0 range 7 .. 7;
   end record;

   -- 30.3.2 UART Mode Register 2 (UMR2n)

   -- Stop-bit length control (5 bits)
   SB_5_17DIV16 : constant := 2#0000#; -- 1.063
   SB_5_18DIV16 : constant := 2#0001#; -- 1.125
   SB_5_19DIV16 : constant := 2#0010#; -- 1.188
   SB_5_20DIV16 : constant := 2#0011#; -- 1.250
   SB_5_21DIV16 : constant := 2#0100#; -- 1.313
   SB_5_22DIV16 : constant := 2#0101#; -- 1.375
   SB_5_23DIV16 : constant := 2#0110#; -- 1.438
   SB_5_1DOT5   : constant := 2#0111#; -- 1.500
   -- Stop-bit length control (6-8 bits)
   SB_9DIV16    : constant := 2#0000#; -- 0.563
   SB_10DIV16   : constant := 2#0001#; -- 0.625
   SB_11DIV16   : constant := 2#0010#; -- 0.688
   SB_12DIV16   : constant := 2#0011#; -- 0.750
   SB_13DIV16   : constant := 2#0100#; -- 0.813
   SB_14DIV16   : constant := 2#0101#; -- 0.875
   SB_15DIV16   : constant := 2#0110#; -- 0.938
   SB_1         : constant := 2#0111#; -- 1.000
   -- Stop-bit length control
   SB_25DIV16   : constant := 2#1000#; -- 1.563
   SB_26DIV16   : constant := 2#1001#; -- 1.625
   SB_27DIV16   : constant := 2#1010#; -- 1.688
   SB_28DIV16   : constant := 2#1011#; -- 1.750
   SB_29DIV16   : constant := 2#1100#; -- 1.813
   SB_30DIV16   : constant := 2#1101#; -- 1.875
   SB_31DIV16   : constant := 2#1110#; -- 1.938
   SB_2         : constant := 2#1111#; -- 2.000

   CM_NORMAL   : constant := 2#00#; -- Normal
   CM_AUTECHO  : constant := 2#01#; -- Automatic echo
   CM_LOCALLB  : constant := 2#10#; -- Local loopback
   CM_REMOTELB : constant := 2#11#; -- Remote loopback

   type UMR2_Type is record
      SB    : Bits_4  := SB_9DIV16; -- Stop-bit length control.
      TXCTS : Boolean := False;     -- Transmitter clear-to-send.
      TXRTS : Boolean := False;     -- Transmitter ready-to-send.
      CM    : Bits_2  := CM_NORMAL; -- Channel mode.
   end record
      with Bit_Order => Low_Order_First,
           Size      => 8;
   for UMR2_Type use record
      SB    at 0 range 0 .. 3;
      TXCTS at 0 range 4 .. 4;
      TXRTS at 0 range 5 .. 5;
      CM    at 0 range 6 .. 7;
   end record;

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
      with Address              => System'To_Address (16#FC06_0004#),
           Volatile_Full_Access => True,
           Import               => True,
           Convention           => Ada;

   -- 30.3.6 UART Receive Buffers (URBn)

   URB0 : aliased Unsigned_8
      with Address              => System'To_Address (16#FC06_000C#),
           Volatile_Full_Access => True,
           Import               => True,
           Convention           => Ada;

   -- 30.3.7 UART Transmit Buffers (UTBn)

   UTB0 : aliased Unsigned_8
      with Address              => System'To_Address (16#FC06_000C#),
           Volatile_Full_Access => True,
           Import               => True,
           Convention           => Ada;

pragma Style_Checks (On);

end MCF5373;

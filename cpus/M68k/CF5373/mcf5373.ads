-----------------------------------------------------------------------------------------------------------------------
--                                                     SweetAda                                                      --
-----------------------------------------------------------------------------------------------------------------------
-- __HDS__                                                                                                           --
-- __FLN__ mcf5373.ads                                                                                               --
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
with System.Storage_Elements;
with Interfaces;
with Bits;

package MCF5373 is

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

   type CACR_Type is
   record
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
   end record with
      Bit_Order => Low_Order_First,
      Size      => 32;
   for CACR_Type use
   record
      Reserved1 at 0 range 0 .. 3;
      EUSP      at 0 range 4 .. 4;
      DW        at 0 range 5 .. 5;
      Reserved2 at 0 range 6 .. 7;
      DCM       at 0 range 8 .. 9;
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

   type ACR_Type is
   record
      Reserved1    : Bits_2;
      W            : Boolean; -- Write protect.
      Reserved2    : Bits_2;
      CM           : Bits_2;  -- Cache mode.
      Reserved3    : Bits_6;
      S            : Bits_2;  -- Supervisor mode.
      E            : Boolean; -- Enable.
      Address_Mask : Bits_8;  -- Address mask.
      Address_Base : Bits_8;  -- Address base.
   end record with
      Bit_Order => Low_Order_First,
      Size      => 32;
   for ACR_Type use
   record
      Reserved1    at 0 range 0 .. 1;
      W            at 0 range 2 .. 2;
      Reserved2    at 0 range 3 .. 4;
      CM           at 0 range 5 .. 6;
      Reserved3    at 0 range 7 .. 12;
      S            at 0 range 13 .. 14;
      E            at 0 range 15 .. 15;
      Address_Mask at 0 range 16 .. 23;
      Address_Base at 0 range 24 .. 31;
   end record;

   -- 9.3.3 Chip Identification Register (CIR)

   type CIR_Type is
   record
      PRN : Bits_6;  -- Part revision number
      PIN : Bits_10; -- Part identification number
   end record with
      Bit_Order => Low_Order_First,
      Size      => 16;
   for CIR_Type use
   record
      PRN at 0 range 0 .. 5;
      PIN at 0 range 6 .. 15;
   end record;

   CIR : aliased CIR_Type with
      Address    => To_Address (16#FC0A_000A#),
      Volatile   => True,
      Import     => True,
      Convention => Ada;

   -- 26.2.1 Watchdog Control Register (WCR)

   type WCR_Type is
   record
      EN       : Boolean; -- Watchdog enable bit.
      HALTED   : Boolean; -- Halted mode bit.
      DOZE     : Boolean; -- Doze mode bit.
      WAIT     : Boolean; -- Wait mode bit.
      Reserved : Bits_12;
   end record with
      Bit_Order => Low_Order_First,
      Size      => 16;
   for WCR_Type use
   record
      EN       at 0 range 0 .. 0;
      HALTED   at 0 range 1 .. 1;
      DOZE     at 0 range 2 .. 2;
      WAIT     at 0 range 3 .. 3;
      Reserved at 0 range 4 .. 15;
   end record;

   WCR : aliased WCR_Type with
      Address    => To_Address (16#FC09_8000#),
      Volatile   => True,
      Import     => True,
      Convention => Ada;

   -- 30.3.3 UART Status Registers (USRn)

   type USR_Type is
   record
      RXRDY : Boolean; -- Receiver ready
      FFULL : Boolean; -- FIFO full
      TXRDY : Boolean; -- Transmitter ready
      TXEMP : Boolean; -- Transmitter empty
      OE    : Boolean; -- Overrun error
      PE    : Boolean; -- Parity error
      FE    : Boolean; -- Framing error
      RB    : Boolean; -- Received break
   end record with
      Bit_Order => Low_Order_First,
      Size      => 8;
   for USR_Type use
   record
      RXRDY at 0 range 0 .. 0;
      FFULL at 0 range 1 .. 1;
      TXRDY at 0 range 2 .. 2;
      TXEMP at 0 range 3 .. 3;
      OE    at 0 range 4 .. 4;
      PE    at 0 range 5 .. 5;
      FE    at 0 range 6 .. 6;
      RB    at 0 range 7 .. 7;
   end record;

   USR0 : aliased USR_Type with
      Address    => To_Address (16#FC06_0004#),
      Volatile   => True,
      Import     => True,
      Convention => Ada;

   -- 30.3.6 UART Receive Buffers (URBn)

   URB0 : aliased Unsigned_8 with
      Address    => To_Address (16#FC06_000C#),
      Volatile   => True,
      Import     => True,
      Convention => Ada;

   -- 30.3.7 UART Transmit Buffers (UTBn)

   UTB0 : aliased Unsigned_8 with
      Address    => To_Address (16#FC06_000C#),
      Volatile   => True,
      Import     => True,
      Convention => Ada;

end MCF5373;

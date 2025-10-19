-----------------------------------------------------------------------------------------------------------------------
--                                                     SweetAda                                                      --
-----------------------------------------------------------------------------------------------------------------------
-- __HDS__                                                                                                           --
-- __FLN__ sja1000.ads                                                                                               --
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

package SJA1000
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
   -- SJA1000 Stand-alone CAN controller
   -- Date of release: 2000 Jan 04 Document order number: 9397 750 06634
   ----------------------------------------------------------------------------

   -- 6.3.3 CONTROL REGISTER (CR)

   type CR_Type is record
      RR        : Boolean := False; -- Reset Request
      RIE       : Boolean := False; -- Receive Interrupt Enable
      TIE       : Boolean := False; -- Transmit Interrupt Enable
      EIE       : Boolean := False; -- Error Interrupt Enable
      OIE       : Boolean := False; -- Overrun Interrupt Enable
      Reserved1 : Bits_1  := 1;
      Reserved2 : Bits_1  := 0;
      Reserved3 : Bits_1  := 0;
   end record
      with Bit_Order => Low_Order_First,
           Size      => 8;
   for CR_Type use record
      RR        at 0 range 0 .. 0;
      RIE       at 0 range 1 .. 1;
      TIE       at 0 range 2 .. 2;
      EIE       at 0 range 3 .. 3;
      OIE       at 0 range 4 .. 4;
      Reserved1 at 0 range 5 .. 5;
      Reserved2 at 0 range 6 .. 6;
      Reserved3 at 0 range 7 .. 7;
   end record;

   -- 6.3.4 COMMAND REGISTER (CMR)

   -- __INF__ use "A7" instead of "AT"
   type CMR_Type is record
      TR        : Boolean := False; -- Transmission Request
      A7        : Boolean := False; -- Abort Transmission
      RRB       : Boolean := False; -- Release Receive Buffer
      CDO       : Boolean := False; -- Clear Data Overrun
      GTS       : Boolean := False; -- Go To Sleep
      Reserved1 : Bits_1  := 1;
      Reserved2 : Bits_1  := 1;
      Reserved3 : Bits_1  := 1;
   end record
      with Bit_Order => Low_Order_First,
           Size      => 8;
   for CMR_Type use record
      TR        at 0 range 0 .. 0;
      A7        at 0 range 1 .. 1;
      RRB       at 0 range 2 .. 2;
      CDO       at 0 range 3 .. 3;
      GTS       at 0 range 4 .. 4;
      Reserved1 at 0 range 5 .. 5;
      Reserved2 at 0 range 6 .. 6;
      Reserved3 at 0 range 7 .. 7;
   end record;

   -- 6.3.5 STATUS REGISTER (SR)

   type SR_Type is record
      RBS : Boolean; -- Receive Buffer Status
      DOS : Boolean; -- Data Overrun Status
      TBS : Boolean; -- Transmit Buffer Status
      TCS : Boolean; -- Transmission Complete
      RS  : Boolean; -- Receive Status
      TS  : Boolean; -- Transmit Status
      ES  : Boolean; -- Error Status
      BS  : Boolean; -- Bus Status
   end record
      with Bit_Order => Low_Order_First,
           Size      => 8;
   for SR_Type use record
      RBS at 0 range 0 .. 0;
      DOS at 0 range 1 .. 1;
      TBS at 0 range 2 .. 2;
      TCS at 0 range 3 .. 3;
      RS  at 0 range 4 .. 4;
      TS  at 0 range 5 .. 5;
      ES  at 0 range 6 .. 6;
      BS  at 0 range 7 .. 7;
   end record;

   -- 6.3.6 INTERRUPT REGISTER (IR)

   type IR_Type is record
      RI        : Boolean; -- Receive Interrupt
      TI        : Boolean; -- Transmit Interrupt
      EI        : Boolean; -- Error Interrupt
      DOI       : Boolean; -- Data Overrun Interrupt
      WUI       : Boolean; -- Wake-Up Interrupt
      Reserved1 : Bits_1;
      Reserved2 : Bits_1;
      Reserved3 : Bits_1;
   end record
      with Bit_Order => Low_Order_First,
           Size      => 8;
   for IR_Type use record
      RI        at 0 range 0 .. 0;
      TI        at 0 range 1 .. 1;
      EI        at 0 range 2 .. 2;
      DOI       at 0 range 3 .. 3;
      WUI       at 0 range 4 .. 4;
      Reserved1 at 0 range 5 .. 5;
      Reserved2 at 0 range 6 .. 6;
      Reserved3 at 0 range 7 .. 7;
   end record;

   -- 6.3.9.1 Acceptance Code Register (ACR)

   -- 6.3.9.2 Acceptance Mask Register (AMR)

   -- 6.5.1 BUS TIMING REGISTER 0 (BTR0)

   type BTR0_Type is record
      BRP : Bits_6 := 0; -- Baud Rate Prescaler (BRP)
      SJW : Bits_2 := 0; -- Synchronization Jump Width (SJW)
   end record
      with Bit_Order => Low_Order_First,
           Size      => 8;
   for BTR0_Type use record
      BRP at 0 range 0 .. 5;
      SJW at 0 range 6 .. 7;
   end record;

   -- 6.5.2 BUS TIMING REGISTER 1 (BTR1)

   SAM_SINGLE : constant := 0; -- single; the bus is sampled once;
   SAM_TRIPLE : constant := 1; -- triple; the bus is sampled three times;

   type BTR1_Type is record
      TSEG1 : Bits_4 := 0;          -- Time Segment 1 (TSEG1)
      TSEG2 : Bits_3 := 0;          -- Time Segment 2 (TSEG2)
      SAM   : Bits_1 := SAM_SINGLE; -- Sampling (SAM)
   end record
      with Bit_Order => Low_Order_First,
           Size      => 8;
   for BTR1_Type use record
      TSEG1 at 0 range 0 .. 3;
      TSEG2 at 0 range 4 .. 6;
      SAM   at 0 range 7 .. 7;
   end record;

   -- 6.5.3 OUTPUT CONTROL REGISTER (OCR)

   OCMODE_BIPHASE : constant := 2#00#; -- bi-phase output mode
   OCMODE_TEST    : constant := 2#01#; -- test output mode
   OCMODE_NORMAL  : constant := 2#10#; -- normal output mode
   OCMODE_CLOCK   : constant := 2#11#; -- clock output mode

   type OCR_Type is record
      OCMODE : Bits_2  := OCMODE_NORMAL; -- OCMODE
      OCPOL0 : Boolean := False;         -- Output pin configuration OCPOL0
      OCTN0  : Boolean := False;         -- Output pin configuration OCTN0
      OCTP0  : Boolean := False;         -- Output pin configuration OCTP0
      OCPOL1 : Boolean := False;         -- Output pin configuration OCPOL1
      OCTN1  : Boolean := False;         -- Output pin configuration OCTN1
      OCTP1  : Boolean := False;         -- Output pin configuration OCTP1
   end record
      with Bit_Order => Low_Order_First,
           Size      => 8;
   for OCR_Type use record
      OCMODE at 0 range 0 .. 1;
      OCPOL0 at 0 range 2 .. 2;
      OCTN0  at 0 range 3 .. 3;
      OCTP0  at 0 range 4 .. 4;
      OCPOL1 at 0 range 5 .. 5;
      OCTN1  at 0 range 6 .. 6;
      OCTP1  at 0 range 7 .. 7;
   end record;

   -- 6.3.7.1 Identifier (ID)
   -- 6.3.7.2 Remote Transmission Request (RTR)
   -- 6.3.7.3 Data Length Code (DLC)

   type ID1_Type is record
      ID310 : Bits_8 := 0; -- ID.3 to ID.10
   end record
      with Bit_Order => Low_Order_First,
           Size      => 8;
   for ID1_Type use record
      ID310 at 0 range 0 .. 7;
   end record;

   type ID2_Type is record
      DLC  : Bits_4  := 0;     -- Data Length Code
      RTR  : Boolean := False; -- Remote Transmission Request
      ID02 : Bits_3  := 0;     -- ID.0 to ID.2
   end record
      with Bit_Order => Low_Order_First,
           Size      => 8;
   for ID2_Type use record
      DLC  at 0 range 0 .. 3;
      RTR  at 0 range 4 .. 4;
      ID02 at 0 range 5 .. 7;
   end record;

   -- 6.5.4 CLOCK DIVIDER REGISTER (CDR)

   CD_FOSCDIV2  : constant := 2#000#; -- fosc/2
   CD_FOSCDIV4  : constant := 2#001#; -- fosc/4
   CD_FOSCDIV6  : constant := 2#010#; -- fosc/6
   CD_FOSCDIV8  : constant := 2#011#; -- fosc/8
   CD_FOSCDIV10 : constant := 2#100#; -- fosc/10
   CD_FOSCDIV12 : constant := 2#101#; -- fosc/12
   CD_FOSCDIV14 : constant := 2#110#; -- fosc/14
   CD_FOSC      : constant := 2#111#; -- fosc

   CAN_mode_BasicCAN : constant := 0; -- If CDR.7 is at logic 0 the CAN controller operates in BasicCAN mode.
   CAN_mode_PeliCAN  : constant := 1; -- If set to logic 1 the CAN controller operates in PeliCAN mode.

   type CDR_Type is record
      CD        : Bits_3  := CD_FOSCDIV2;       -- CLKOUT frequency selection
      clock_off : Boolean := False;             -- Clock off
      Reserved  : Bits_1  := 0;
      RXINTEN   : Boolean := False;             -- This bit allows the TX1 output to be used as a dedicated receive interrupt output.
      CBP       : Boolean := False;             -- Setting of CDR.6 allows to bypass the CAN input comparator and is only possible in reset mode.
      CAN_mode  : Bits_1  := CAN_mode_BasicCAN; -- CDR.7 defines the CAN mode.
   end record
      with Bit_Order => Low_Order_First,
           Size      => 8;
   for CDR_Type use record
      CD        at 0 range 0 .. 2;
      clock_off at 0 range 3 .. 3;
      Reserved  at 0 range 4 .. 4;
      RXINTEN   at 0 range 5 .. 5;
      CBP       at 0 range 6 .. 6;
      CAN_mode  at 0 range 7 .. 7;
   end record;

   -- Table 1 BasicCAN address allocation

   type Buffer_Type is array (1 .. 8) of Unsigned_8;

   type SJA1000_Type is record
      CR      : CR_Type     with Volatile_Full_Access => True;
      CMR     : CMR_Type    with Volatile_Full_Access => True;
      SR      : SR_Type     with Volatile_Full_Access => True;
      IR      : IR_Type     with Volatile_Full_Access => True;
      ACR     : Unsigned_8  with Volatile_Full_Access => True;
      AMR     : Unsigned_8  with Volatile_Full_Access => True;
      BTR0    : BTR0_Type   with Volatile_Full_Access => True;
      BTR1    : BTR1_Type   with Volatile_Full_Access => True;
      OCR     : OCR_Type    with Volatile_Full_Access => True;
      TEST    : Unsigned_8  with Volatile_Full_Access => True;
      TX_ID1  : ID1_Type    with Volatile_Full_Access => True;
      TX_ID2  : ID2_Type    with Volatile_Full_Access => True;
      TX_DATA : Buffer_Type with Volatile => True;
      RX_ID1  : ID1_Type    with Volatile_Full_Access => True;
      RX_ID2  : ID2_Type    with Volatile_Full_Access => True;
      RX_DATA : Buffer_Type with Volatile => True;
      Unused  : Bits_8;
      CDR     : CDR_Type    with Volatile_Full_Access => True;
   end record
      with Size => 32 * 8;
   for SJA1000_Type use record
      CR      at 00 range 0 .. 7;
      CMR     at 01 range 0 .. 7;
      SR      at 02 range 0 .. 7;
      IR      at 03 range 0 .. 7;
      ACR     at 04 range 0 .. 7;
      AMR     at 05 range 0 .. 7;
      BTR0    at 06 range 0 .. 7;
      BTR1    at 07 range 0 .. 7;
      OCR     at 08 range 0 .. 7;
      TEST    at 09 range 0 .. 7;
      TX_ID1  at 10 range 0 .. 7;
      TX_ID2  at 11 range 0 .. 7;
      TX_DATA at 12 range 0 .. 8 * 8 - 1;
      RX_ID1  at 20 range 0 .. 7;
      RX_ID2  at 21 range 0 .. 7;
      RX_DATA at 22 range 0 .. 8 * 8 - 1;
      Unused  at 30 range 0 .. 7;
      CDR     at 31 range 0 .. 7;
   end record;

pragma Style_Checks (On);

end SJA1000;

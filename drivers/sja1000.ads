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

package SJA1000
   is

   --========================================================================--
   --                                                                        --
   --                                                                        --
   --                               Public part                              --
   --                                                                        --
   --                                                                        --
   --========================================================================--

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

   type CMR_Type is record
      TR        : Boolean := False; -- Transmission Request
      A_T       : Boolean := False; -- Abort Transmission
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
      A_T       at 0 range 1 .. 1;
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

pragma Style_Checks (On);

end SJA1000;

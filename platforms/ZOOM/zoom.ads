-----------------------------------------------------------------------------------------------------------------------
--                                                     SweetAda                                                      --
-----------------------------------------------------------------------------------------------------------------------
-- __HDS__                                                                                                           --
-- __FLN__ zoom.ads                                                                                                  --
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

package ZOOM is

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

   ----------------------------------------------------------------------------
   -- The MCF5373-10 CARD ENGINE has a latch (U7) connected to CS1 @
   -- 0x1000_0000, activated by addressing the offset 0x0008_0000.
   -- In order to use the LEDs on the ZOOM, it must be enabled (/2OE active
   -- low) by lowering the MFP9 - TIN3/TOUT3 pin on the GPIO module, which is
   -- normally assigned to the DMA timers.
   ----------------------------------------------------------------------------

   type LATCH_U7_ACCESS_Type is (READ, WRITE);

   type LATCH_U7_READ_Type is
   record
      MODE2       : Boolean;
      nIRQD       : Boolean; -- negated
      WRLAN_nINT  : Boolean; -- negated
      LATCH_GPO_2 : Boolean;
      LCD_VEEEN   : Boolean;
      LATCH_GPO_1 : Boolean;
      nSUSPEND    : Boolean; -- negated
      nSTANDBY    : Boolean; -- negated
   end record with
      Bit_Order => Low_Order_First,
      Size      => 8;
   for LATCH_U7_READ_Type use
   record
      MODE2       at 0 range 0 .. 0;
      nIRQD       at 0 range 1 .. 1;
      WRLAN_nINT  at 0 range 2 .. 2;
      LATCH_GPO_2 at 0 range 3 .. 3;
      LCD_VEEEN   at 0 range 4 .. 4;
      LATCH_GPO_1 at 0 range 5 .. 5;
      nSUSPEND    at 0 range 6 .. 6;
      nSTANDBY    at 0 range 7 .. 7;
   end record;

   type LATCH_U7_WRITE_Type is
   record
      USB1_PWR_EN : Boolean;
      USB2_PWR_EN : Boolean;
      NAND_nGPIO  : Boolean; -- negated
      LATCH_GPO_2 : Boolean;
      LCD_VEEEN   : Boolean;
      LATCH_GPO_1 : Boolean;
      STATUS_2    : Boolean;
      STATUS_1    : Boolean;
   end record with
      Bit_Order => Low_Order_First,
      Size      => 8;
   for LATCH_U7_WRITE_Type use
   record
      USB1_PWR_EN at 0 range 0 .. 0;
      USB2_PWR_EN at 0 range 1 .. 1;
      NAND_nGPIO  at 0 range 2 .. 2;
      LATCH_GPO_2 at 0 range 3 .. 3;
      LCD_VEEEN   at 0 range 4 .. 4;
      LATCH_GPO_1 at 0 range 5 .. 5;
      STATUS_2    at 0 range 6 .. 6;
      STATUS_1    at 0 range 7 .. 7;
   end record;

   type LATCH_U7_Type (RW : LATCH_U7_ACCESS_Type := READ) is
   record
      case RW is
         when READ  => READ  : LATCH_U7_READ_Type;
         when WRITE => WRITE : LATCH_U7_WRITE_Type;
      end case;
   end record with
      Pack            => True,
      Unchecked_Union => True;

   LATCH_U7 : aliased LATCH_U7_Type with
      Address    => To_Address (16#1008_0000#),
      Volatile   => True,
      Import     => True,
      Convention => Ada;

end ZOOM;

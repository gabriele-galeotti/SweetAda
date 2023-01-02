-----------------------------------------------------------------------------------------------------------------------
--                                                     SweetAda                                                      --
-----------------------------------------------------------------------------------------------------------------------
-- __HDS__                                                                                                           --
-- __FLN__ e300.ads                                                                                                  --
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

with Interfaces;
with PowerPC;

package e300 is

   --========================================================================--
   --                                                                        --
   --                                                                        --
   --                               Public part                              --
   --                                                                        --
   --                                                                        --
   --========================================================================--

   use Interfaces;
   use PowerPC;

   ----------------------------------------------------------------------------
   -- SPRs
   ----------------------------------------------------------------------------

   CSRR0  : constant SPR_Type := 58;
   CSRR1  : constant SPR_Type := 59;
   SPRG0  : constant SPR_Type := 272;
   SPRG1  : constant SPR_Type := 273;
   SPRG2  : constant SPR_Type := 274;
   SPRG3  : constant SPR_Type := 275;
   SPRG4  : constant SPR_Type := 276;
   SPRG5  : constant SPR_Type := 277;
   SPRG6  : constant SPR_Type := 278;
   SPRG7  : constant SPR_Type := 279;
   SVR    : constant SPR_Type := 286;  -- 0x11E System Version Register 603e/e300 core
   IBCR   : constant SPR_Type := 309;
   DBCR   : constant SPR_Type := 310;
   MBAR   : constant SPR_Type := 311;
   DABR2  : constant SPR_Type := 317;
   IBAT4U : constant SPR_Type := 560;
   IBAT4L : constant SPR_Type := 561;
   IBAT5U : constant SPR_Type := 562;
   IBAT5L : constant SPR_Type := 563;
   IBAT6U : constant SPR_Type := 564;
   IBAT6L : constant SPR_Type := 565;
   IBAT7U : constant SPR_Type := 566;
   IBAT7L : constant SPR_Type := 567;
   DBAT4U : constant SPR_Type := 568;
   DBAT4L : constant SPR_Type := 569;
   DBAT5U : constant SPR_Type := 570;
   DBAT5L : constant SPR_Type := 571;
   DBAT6U : constant SPR_Type := 572;
   DBAT6L : constant SPR_Type := 573;
   DBAT7U : constant SPR_Type := 574;
   DBAT7L : constant SPR_Type := 575;
   DMISS  : constant SPR_Type := 976;
   DCMP   : constant SPR_Type := 977;
   HASH1  : constant SPR_Type := 978;
   HASH2  : constant SPR_Type := 979;
   IMISS  : constant SPR_Type := 980;
   ICMP   : constant SPR_Type := 981;
   RPA    : constant SPR_Type := 982;
   HID0   : constant SPR_Type := 1008;
   HID1   : constant SPR_Type := 1009;
   IABR   : constant SPR_Type := 1010;
   HID2   : constant SPR_Type := 1011;
   IABR2  : constant SPR_Type := 1018;

   ----------------------------------------------------------------------------
   -- SPRs access subprograms
   ----------------------------------------------------------------------------

   function SVR_Read return Unsigned_32 with
      Inline => True;

end e300;

-----------------------------------------------------------------------------------------------------------------------
--                                                     SweetAda                                                      --
-----------------------------------------------------------------------------------------------------------------------
-- __HDS__                                                                                                           --
-- __FLN__ gt64120.ads                                                                                               --
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
with Interfaces;

package GT64120 is

   --========================================================================--
   --                                                                        --
   --                                                                        --
   --                               Public part                              --
   --                                                                        --
   --                                                                        --
   --========================================================================--

   use System;
   use Interfaces;

   GT64120_DEFAULT_ISD_ADDRESS : constant := 16#1400_0000#;

   type GT64120_Type is
   record
      CPUIC    : Unsigned_32;
      PCI0IOLD : Unsigned_32;
      PCI0IOHD : Unsigned_32;
      PCI0M0LD : Unsigned_32;
      PCI0M0HD : Unsigned_32;
      ISD      : Unsigned_32;
      PCI0M1LD : Unsigned_32;
      PCI0M1HD : Unsigned_32;
      PCI1IOLD : Unsigned_32;
      PCI1IOHD : Unsigned_32;
      MULTIGT  : Unsigned_32;
      SDRAMC   : Unsigned_32;
      SDRAMOM  : Unsigned_32;
      SDRAMBM  : Unsigned_32;
      SDRAMAD  : Unsigned_32;
   end record with
      Alignment => 4,
      Bit_Order => Low_Order_First;
   for GT64120_Type use
   record
      CPUIC    at 16#000# range 0 .. 31;
      PCI0IOLD at 16#048# range 0 .. 31;
      PCI0IOHD at 16#050# range 0 .. 31;
      PCI0M0LD at 16#058# range 0 .. 31;
      PCI0M0HD at 16#060# range 0 .. 31;
      ISD      at 16#068# range 0 .. 31;
      PCI0M1LD at 16#080# range 0 .. 31;
      PCI0M1HD at 16#088# range 0 .. 31;
      PCI1IOLD at 16#090# range 0 .. 31;
      PCI1IOHD at 16#098# range 0 .. 31;
      MULTIGT  at 16#120# range 0 .. 31;
      SDRAMC   at 16#448# range 0 .. 31;
      SDRAMOM  at 16#474# range 0 .. 31;
      SDRAMBM  at 16#478# range 0 .. 31;
      SDRAMAD  at 16#47C# range 0 .. 31;
   end record;

   function Make_LD (Start_Address : Unsigned_64) return Unsigned_32;
   function Make_HD (Start_Address : Unsigned_64; Size : Unsigned_64) return Unsigned_32;

end GT64120;

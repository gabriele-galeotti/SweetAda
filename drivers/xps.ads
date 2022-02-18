-----------------------------------------------------------------------------------------------------------------------
--                                                     SweetAda                                                      --
-----------------------------------------------------------------------------------------------------------------------
-- __HDS__                                                                                                           --
-- __FLN__ xps.ads                                                                                                   --
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
with Bits;

package XPS is

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

   ----------------------------------------------------------------------------
   -- XPS Timer
   ----------------------------------------------------------------------------

   type XPS_Timer_CSR_Type is
   record
      Reserved : Bits_21;
      ENALL    : Bits_1;
      PWMA0    : Bits_1;
      T0INT    : Bits_1;
      ENT0     : Bits_1;
      ENIT0    : Bits_1;
      LOAD0    : Bits_1;
      ARHT0    : Bits_1;
      CAPT0    : Bits_1;
      GENT0    : Bits_1;
      UDT0     : Bits_1;
      MDT0     : Bits_1;
   end record with
      Bit_Order => High_Order_First,
      Size      => 32;
   for XPS_Timer_CSR_Type use
   record
      Reserved at 0 range 0 .. 20;
      ENALL    at 0 range 21 .. 21;
      PWMA0    at 0 range 22 .. 22;
      T0INT    at 0 range 23 .. 23;
      ENT0     at 0 range 24 .. 24;
      ENIT0    at 0 range 25 .. 25;
      LOAD0    at 0 range 26 .. 26;
      ARHT0    at 0 range 27 .. 27;
      CAPT0    at 0 range 28 .. 28;
      GENT0    at 0 range 29 .. 29;
      UDT0     at 0 range 30 .. 30;
      MDT0     at 0 range 31 .. 31;
   end record;

   type XPS_Timer_Type is
   record
      TCSR0 : XPS_Timer_CSR_Type;
      TLR0  : Unsigned_32;
      TCR0  : Unsigned_32;
   end record with
      Size => 3 * 32;
   for XPS_Timer_Type use
   record
      TCSR0 at 0 range 0 .. 31;
      TLR0  at 4 range 0 .. 31;
      TCR0  at 8 range 0 .. 31;
   end record;

   ----------------------------------------------------------------------------
   -- XPS Interrupt Controller
   ----------------------------------------------------------------------------

   type XPS_INTC_MER_Type is
   record
      Reserved : Bits_30;
      HIE      : Bits_1;
      ME       : Bits_1;
   end record with
      Bit_Order => High_Order_First,
      Size      => 32;
   for XPS_INTC_MER_Type use
   record
      Reserved at 0 range 0 .. 29;
      HIE      at 0 range 30 .. 30;
      ME       at 0 range 31 .. 31;
   end record;

   type XPS_INTC_Type is
   record
      ISR : Unsigned_32;
      IPR : Unsigned_32;
      IER : Unsigned_32;
      IAR : Unsigned_32;
      SIE : Unsigned_32;
      CIE : Unsigned_32;
      IVR : Unsigned_32;
      MER : XPS_INTC_MER_Type;
   end record with
      Size => 8 * 32;
   for XPS_INTC_Type use
   record
      ISR at 16#00# range 0 .. 31;
      IPR at 16#04# range 0 .. 31;
      IER at 16#08# range 0 .. 31;
      IAR at 16#0C# range 0 .. 31;
      SIE at 16#10# range 0 .. 31;
      CIE at 16#14# range 0 .. 31;
      IVR at 16#18# range 0 .. 31;
      MER at 16#1C# range 0 .. 31;
   end record;

end XPS;

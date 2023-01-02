-----------------------------------------------------------------------------------------------------------------------
--                                                     SweetAda                                                      --
-----------------------------------------------------------------------------------------------------------------------
-- __HDS__                                                                                                           --
-- __FLN__ zynqa9.ads                                                                                                --
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

pragma Warnings (Off, "no component clause given for");
pragma Warnings (Off, "*-bit gap before component");
pragma Warnings (Off, "* bits of * unused");

with System;
with System.Storage_Elements;
with Interfaces;
with Bits;

package ZynqA9 is

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
   -- Cadence UART
   ----------------------------------------------------------------------------

   type Control_Register_Type is
   record
      Unused1 : Bits.Bits_2;
      RX_EN   : Boolean;
      RX_DIS  : Boolean;
      TX_EN   : Boolean;
      TX_DIS  : Boolean;
      Unused2 : Bits.Bits_26;
   end record with
      Bit_Order => Low_Order_First,
      Size      => 32;
   for Control_Register_Type use
   record
      Unused1 at 0 range 0 .. 1;
      RX_EN   at 0 range 2 .. 2;
      RX_DIS  at 0 range 3 .. 3;
      TX_EN   at 0 range 4 .. 4;
      TX_DIS  at 0 range 5 .. 5;
      Unused2 at 0 range 6 .. 31;
   end record;

   -- __TBD__ placeholder
   type Mode_Register_Type is
   record
      Unused : Bits.Bits_32;
   end record with
      Bit_Order => Low_Order_First,
      Size      => 32;
   for Mode_Register_Type use
   record
      Unused at 0 range 0 .. 31;
   end record;

   type Status_Register_Type is
   record
      INTR_RTRIG  : Boolean;
      INTR_REMPTY : Boolean;
      INTR_RFUL   : Boolean;
      INTR_TEMPTY : Boolean;
      Unused      : Bits.Bits_28;
   end record with
      Bit_Order => Low_Order_First,
      Size      => 32;
   for Status_Register_Type use
   record
      INTR_RTRIG  at 0 range 0 .. 0;
      INTR_REMPTY at 0 range 1 .. 1;
      INTR_RFUL   at 0 range 2 .. 2;
      INTR_TEMPTY at 0 range 3 .. 3;
      Unused      at 0 range 4 .. 31;
   end record;

   type UART_Type is
   record
      R_CR    : Control_Register_Type with Volatile_Full_Access => True;
      R_MR    : Mode_Register_Type    with Volatile_Full_Access => True;
      R_SR    : Status_Register_Type  with Volatile_Full_Access => True;
      R_TX_RX : Unsigned_32           with Volatile_Full_Access => True;
   end record with
      Alignment => 4;
   for UART_Type use
   record
      R_CR    at 16#00# range 0 .. 31;
      R_MR    at 16#04# range 0 .. 31;
      R_SR    at 16#2C# range 0 .. 31;
      R_TX_RX at 16#30# range 0 .. 31;
   end record;

   UART0_BASEADDRESS : constant := 16#E000_0000#;

   Uart0 : aliased UART_Type with
      Address    => To_Address (UART0_BASEADDRESS),
      Volatile   => True,
      Import     => True,
      Convention => Ada;

   procedure UART_Init;
   procedure UART_TX (Data : in Unsigned_8);
   procedure UART_RX (Data : out Unsigned_8);

end ZynqA9;

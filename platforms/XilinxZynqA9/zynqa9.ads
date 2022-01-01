-----------------------------------------------------------------------------------------------------------------------
--                                                     SweetAda                                                      --
-----------------------------------------------------------------------------------------------------------------------
-- __HDS__                                                                                                           --
-- __FLN__ zynqa9.ads                                                                                                --
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

pragma Warnings (Off, "no component clause given for");
pragma Warnings (Off, "*-bit gap before component");
pragma Warnings (Off, "* bits of * unused");

with System;
with System.Storage_Elements; use System.Storage_Elements;
with Interfaces; use Interfaces;

package ZynqA9 is

   --========================================================================--
   --                                                                        --
   --                                                                        --
   --                               Public part                              --
   --                                                                        --
   --                                                                        --
   --========================================================================--

   UART0_BASEADDRESS : constant := 16#E000_0000#;

   ----------------------------------------------------------------------------
   -- UART
   ----------------------------------------------------------------------------

   type UART_Type is
   record
      R_CR    : Unsigned_32 with Volatile_Full_Access => True;
      R_MR    : Unsigned_32 with Volatile_Full_Access => True;
      R_TX_RX : Unsigned_32 with Volatile_Full_Access => True;
   end record with
      Alignment => 4;
   for UART_Type use
   record
      R_CR    at 16#00# range 0 .. 31;
      R_MR    at 16#04# range 0 .. 31;
      R_TX_RX at 16#30# range 0 .. 31;
   end record;

   Uart0 : aliased UART_Type with
      Address    => To_Address (UART0_BASEADDRESS),
      Volatile   => True,
      Import     => True,
      Convention => Ada;

   NORMAL_MODE    : constant := 0;
   UART_CR_TX_EN  : constant := 16#0000_0010#;
   UART_CR_TX_DIS : constant := 16#0000_0020#;

   procedure UART_Init;

end ZynqA9;

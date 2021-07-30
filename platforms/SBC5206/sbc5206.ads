-----------------------------------------------------------------------------------------------------------------------
--                                                     SweetAda                                                      --
-----------------------------------------------------------------------------------------------------------------------
-- __HDS__                                                                                                           --
-- __FLN__ sbc5206.ads                                                                                               --
-- __DSC__                                                                                                           --
-- __HSH__ e69de29bb2d1d6434b8b29ae775ad8c2e48c5391                                                                  --
-- __HDE__                                                                                                           --
-----------------------------------------------------------------------------------------------------------------------
-- Copyright (C) 2020, 2021 Gabriele Galeotti                                                                        --
--                                                                                                                   --
-- SweetAda web page: http://sweetada.org                                                                            --
-- contact address: gabriele.galeotti@sweetada.org                                                                   --
-- This work is licensed under the terms of the MIT License.                                                         --
-- Please consult the LICENSE.txt file located in the top-level directory.                                           --
-----------------------------------------------------------------------------------------------------------------------

with System;
with System.Storage_Elements;
with Bits;
with Interfaces;

package SBC5206 is

   --========================================================================--
   --                                                                        --
   --                                                                        --
   --                               Public part                              --
   --                                                                        --
   --                                                                        --
   --========================================================================--

   use System.Storage_Elements;
   use Bits;
   use Interfaces;

   VBR        : constant := 16#0801#;
   MBAR       : constant := 16#0C0F#;
   MBAR_VALUE : constant := 16#1000_0000#; -- QEMU Arnewsh M5206AN board default

   ----------------------------------------------------------------------------
   -- UART
   ----------------------------------------------------------------------------

   type Uart_Register_Type is (
                               URB_Register,
                               UTB_Register
                              );

   Uart_Register_Offset : constant array (Uart_Register_Type) of Storage_Offset :=
      (
       URB_Register => 16#014C#,
       UTB_Register => 16#014C#
      );

   -- Uart0 : aliased Uart_Type;
   -- for Uart0'Address use To_Address (MBAR_VALUE);
   -- pragma Volatile (Uart0);
   -- pragma Import (Ada, Uart0);

   procedure UART_Init;

   Uart0cr : aliased Unsigned_8 with
      Address    => To_Address (16#1000_0148#),
      Volatile   => True,
      Import     => True,
      Convention => Ada;

   Uart0tx : aliased Unsigned_8 with
      Address    => To_Address (16#1000_014C#),
      Volatile   => True,
      Import     => True,
      Convention => Ada;

end SBC5206;

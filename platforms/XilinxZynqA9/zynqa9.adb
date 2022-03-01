-----------------------------------------------------------------------------------------------------------------------
--                                                     SweetAda                                                      --
-----------------------------------------------------------------------------------------------------------------------
-- __HDS__                                                                                                           --
-- __FLN__ zynqa9.adb                                                                                                --
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

package body ZynqA9 is

   --========================================================================--
   --                                                                        --
   --                                                                        --
   --                           Package subprograms                          --
   --                                                                        --
   --                                                                        --
   --========================================================================--

   ----------------------------------------------------------------------------
   -- UART
   ----------------------------------------------------------------------------

   procedure UART_Init is
   begin
      Uart0.R_CR := (
                     Unused1 => 0,
                     RX_EN   => True,
                     RX_DIS  => False,
                     TX_EN   => True,
                     TX_DIS  => False,
                     Unused2 => 0
                    );
   end UART_Init;

   ----------------------------------------------------------------------------
   -- UART_TX
   ----------------------------------------------------------------------------
   procedure UART_TX (Data : in Unsigned_8) is
   begin
      -- wait for transmitter available
      loop
         exit when Uart0.R_SR.INTR_TEMPTY;
      end loop;
      Uart0.R_TX_RX := Unsigned_32 (Data);
   end UART_TX;

   ----------------------------------------------------------------------------
   -- UART_RX
   ----------------------------------------------------------------------------
   procedure UART_RX (Data : out Unsigned_8) is
   begin
      -- wait for receiver available
      loop
         exit when not Uart0.R_SR.INTR_REMPTY;
      end loop;
      Data := Unsigned_8 (Uart0.R_TX_RX);
   end UART_RX;

end ZynqA9;

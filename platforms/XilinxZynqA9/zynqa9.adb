-----------------------------------------------------------------------------------------------------------------------
--                                                     SweetAda                                                      --
-----------------------------------------------------------------------------------------------------------------------
-- __HDS__                                                                                                           --
-- __FLN__ zynqa9.adb                                                                                                --
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

package body ZynqA9
   is

   --========================================================================--
   --                                                                        --
   --                                                                        --
   --                           Package subprograms                          --
   --                                                                        --
   --                                                                        --
   --========================================================================--

   ----------------------------------------------------------------------------
   -- UART_TX
   ----------------------------------------------------------------------------
   procedure UART_TX
      (Data : in Unsigned_8)
      is
   begin
      -- wait for transmitter available
      loop
         exit when UART0.SR.TXEMPTY;
      end loop;
      UART0.FIFO.FIFO := Data;
   end UART_TX;

   ----------------------------------------------------------------------------
   -- UART_RX
   ----------------------------------------------------------------------------
   procedure UART_RX
      (Data : out Unsigned_8)
      is
   begin
      -- wait for receiver available
      loop
         exit when not UART0.SR.RXEMPTY;
      end loop;
      Data := UART0.FIFO.FIFO;
   end UART_RX;

   ----------------------------------------------------------------------------
   -- UART_Init
   ----------------------------------------------------------------------------
   procedure UART_Init
      is
   begin
      UART0.CR :=
         (RXRST    => False,
          TXRST    => False,
          RX_EN    => True,
          RX_DIS   => False,
          TX_EN    => True,
          TX_DIS   => False,
          TORST    => False,
          STARTBRK => False,
          STOPBRK  => False,
          others   => <>);
   end UART_Init;

end ZynqA9;

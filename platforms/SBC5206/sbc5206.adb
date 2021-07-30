-----------------------------------------------------------------------------------------------------------------------
--                                                     SweetAda                                                      --
-----------------------------------------------------------------------------------------------------------------------
-- __HDS__                                                                                                           --
-- __FLN__ sbc5206.adb                                                                                               --
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

package body SBC5206 is

   --========================================================================--
   --                                                                        --
   --                                                                        --
   --                           Package subprograms                          --
   --                                                                        --
   --                                                                        --
   --========================================================================--

   procedure UART_Init is
   begin
      -- Uart0 := (Mode => READ, UMR_Selector => UMR1);
      -- Uart0.UCR   := 16#10#; -- reset mode register pointer
      -- Uart0.UCR   := 16#20#; -- reset receiver
      -- Uart0.UCR   := 16#30#; -- reset transmitter
      -- Uart0.UCR   := 16#05#; -- enable tx&rx
      -- Uart0.UCSR  := 16#DD#; -- TIMER
      -- Uart0.UMRW1 := 16#13#;
      -- Uart0.UMRW2 := 16#00#;
      Uart0cr := 16#10#; -- reset mode register pointer
      Uart0cr := 16#20#; -- reset receiver
      Uart0cr := 16#30#; -- reset transmitter
      Uart0cr := 16#05#; -- enable tx&rx
      null;
   end UART_Init;

end SBC5206;

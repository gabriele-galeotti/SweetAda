-----------------------------------------------------------------------------------------------------------------------
--                                                     SweetAda                                                      --
-----------------------------------------------------------------------------------------------------------------------
-- __HDS__                                                                                                           --
-- __FLN__ lpc2148.adb                                                                                               --
-- __DSC__                                                                                                           --
-- __HSH__ e69de29bb2d1d6434b8b29ae775ad8c2e48c5391                                                                  --
-- __HDE__                                                                                                           --
-----------------------------------------------------------------------------------------------------------------------
-- Copyright (C) 2020-2026 Gabriele Galeotti                                                                         --
--                                                                                                                   --
-- SweetAda web page: http://sweetada.org                                                                            --
-- contact address: gabriele.galeotti@sweetada.org                                                                   --
-- This work is licensed under the terms of the MIT License.                                                         --
-- Please consult the LICENSE.txt file located in the top-level directory.                                           --
-----------------------------------------------------------------------------------------------------------------------

with MMIO;
with UART16x50;

package body LPC2148
   is

   --========================================================================--
   --                                                                        --
   --                                                                        --
   --                           Local declarations                           --
   --                                                                        --
   --                                                                        --
   --========================================================================--

   UART0_Descriptor : aliased UART16x50.Descriptor_Type :=
                         UART16x50.DESCRIPTOR_INVALID;

   --========================================================================--
   --                                                                        --
   --                                                                        --
   --                           Package subprograms                          --
   --                                                                        --
   --                                                                        --
   --========================================================================--

   ----------------------------------------------------------------------------
   -- UART0_Init
   ----------------------------------------------------------------------------
   procedure UART0_Init
      (Clock_Peripherals : in Positive)
      is
   begin
      UART0_Descriptor := (
         Uart_Model    => UART16x50.UART16450,
         Base_Address  => System'To_Address (UART0_BASEADDRESS),
         Scale_Address => 2,
         Baud_Clock    => Clock_Peripherals,
         Flags         => (PC_UART => False),
         Read_8        => MMIO.Read'Access,
         Write_8       => MMIO.Write'Access,
         Data_Queue    => ([others => 0], 0, 0, 0)
         );
      UART16x50.Init (UART0_Descriptor);
   end UART0_Init;

   ----------------------------------------------------------------------------
   -- UART0_TX
   ----------------------------------------------------------------------------
   procedure UART0_TX
      (Data : in Unsigned_8)
      is
   begin
      UART16x50.TX (UART0_Descriptor, Data);
   end UART0_TX;

   ----------------------------------------------------------------------------
   -- UART0_RX
   ----------------------------------------------------------------------------
   procedure UART0_RX
      (Data : out Unsigned_8)
      is
   begin
      UART16x50.RX (UART0_Descriptor, Data);
   end UART0_RX;

end LPC2148;

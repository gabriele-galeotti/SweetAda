-----------------------------------------------------------------------------------------------------------------------
--                                                     SweetAda                                                      --
-----------------------------------------------------------------------------------------------------------------------
-- __HDS__                                                                                                           --
-- __FLN__ leon3.adb                                                                                                 --
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

package body LEON3 is

   --========================================================================--
   --                                                                        --
   --                                                                        --
   --                           Package subprograms                          --
   --                                                                        --
   --                                                                        --
   --========================================================================--

   ----------------------------------------------------------------------------
   -- Tclk_Init
   ----------------------------------------------------------------------------
   procedure Tclk_Init is null;

   ----------------------------------------------------------------------------
   -- UART1_Init
   ----------------------------------------------------------------------------
   procedure UART1_Init is
   begin
      UART1.Control_Register.RE := True;
      UART1.Control_Register.TE := True;
   end UART1_Init;

   ----------------------------------------------------------------------------
   -- UART1_TX
   ----------------------------------------------------------------------------
   procedure UART1_TX (Data : in Unsigned_8) is
   begin
      -- wait for transmitter available
      loop
         exit when UART1.Status_Register.TS;
      end loop;
      UART1.Data_Register := Unsigned_32 (Data);
   end UART1_TX;

   ----------------------------------------------------------------------------
   -- UART1_RX
   ----------------------------------------------------------------------------
   procedure UART1_RX (Data : out Unsigned_8) is
   begin
      -- wait for receiver available
      loop
         exit when UART1.Status_Register.DR;
      end loop;
      Data := Unsigned_8 (UART1.Data_Register);
   end UART1_RX;

end LEON3;

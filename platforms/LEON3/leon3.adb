-----------------------------------------------------------------------------------------------------------------------
--                                                     SweetAda                                                      --
-----------------------------------------------------------------------------------------------------------------------
-- __HDS__                                                                                                           --
-- __FLN__ leon3.adb                                                                                                 --
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

with Configure;

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
   -- interrupt_level_6 26 0x16
   ----------------------------------------------------------------------------
   procedure Tclk_Init is
   begin
      -- Timer prescaler input frequency = 40 MHz, output = 1 MHz
      GPTIMER.Scaler_Reload_Value := 40;
      -- Timers underflow @ 1 kHz
      GPTIMER.Reload_1           := 1_000;
      GPTIMER.Reload_2           := 1_000;
      GPTIMER.Reload_3           := 1_000;
      GPTIMER.Reload_4           := 1_000;
      GPTIMER.Control_Register_1 := (
                                     EN     => False,
                                     RS     => True,
                                     LD     => False,
                                     IE     => True,
                                     IP     => False,
                                     CH     => False,
                                     DH     => False,
                                     others => 0
                                    );
      GPTIMER.Control_Register_1.EN := True;
      GPTIMER.Control_Register_1.LD := True;
   end Tclk_Init;

   ----------------------------------------------------------------------------
   -- UART1_Init
   ----------------------------------------------------------------------------
   procedure UART1_Init is
   begin
      UART1.Control_Register := (
                                 RE       => True,
                                 TE       => True,
                                 RI       => False,
                                 TI       => False,
                                 PS       => PS_EVEN,
                                 PE       => False,
                                 LB       => False,
                                 TF       => False,
                                 RF       => False,
                                 DB       => False,
                                 FA       => False,
                                 Unused1  => 0,
                                 Unused2  => 0,
                                 Unused3  => 0,
                                 Reserved => 0
                                );
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

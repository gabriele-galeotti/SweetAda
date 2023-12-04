-----------------------------------------------------------------------------------------------------------------------
--                                                     SweetAda                                                      --
-----------------------------------------------------------------------------------------------------------------------
-- __HDS__                                                                                                           --
-- __FLN__ bsp.adb                                                                                                   --
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

with System;
with System.Parameters;
with System.Secondary_Stack;
with Interfaces.C;
with Definitions;
with Bits;
with ARMv8A;
with RPI3;
with Exceptions;
with Console;

package body BSP is

   --========================================================================--
   --                                                                        --
   --                                                                        --
   --                           Local declarations                           --
   --                                                                        --
   --                                                                        --
   --========================================================================--

   use Interfaces;
   use Definitions;
   use Bits;

   BSP_SS_Stack : System.Secondary_Stack.SS_Stack_Ptr;

   function Number_Of_CPUs return Interfaces.C.int
      with Export        => True,
           Convention    => C,
           External_Name => "__gnat_number_of_cpus";

   function Get_Sec_Stack return System.Secondary_Stack.SS_Stack_Ptr
      with Export        => True,
           Convention    => C,
           External_Name => "__gnat_get_secondary_stack";

   --========================================================================--
   --                                                                        --
   --                                                                        --
   --                           Package subprograms                          --
   --                                                                        --
   --                                                                        --
   --========================================================================--

   ----------------------------------------------------------------------------
   -- Number_Of_CPUs
   ----------------------------------------------------------------------------
   function Number_Of_CPUs return Interfaces.C.int
      is
   begin
      return 4;
   end Number_Of_CPUs;

   ----------------------------------------------------------------------------
   -- Get_Sec_Stack
   ----------------------------------------------------------------------------
   function Get_Sec_Stack
      return System.Secondary_Stack.SS_Stack_Ptr
      is
   begin
      return BSP_SS_Stack;
   end Get_Sec_Stack;

   ----------------------------------------------------------------------------
   -- Console wrappers
   ----------------------------------------------------------------------------

   procedure Console_Putchar
      (C : in Character)
      is
   begin
      -- wait for transmitter available
      loop
         exit when RPI3.AUX_MU_LSR_REG.Transmitter_Empty;
      end loop;
      RPI3.AUX_MU_IO_REG.DATA := To_U8 (C);
   end Console_Putchar;

   procedure Console_Getchar
      (C : out Character)
      is
   begin
      -- wait for receiver available
      loop
         exit when RPI3.AUX_MU_LSR_REG.Data_Ready;
      end loop;
      C := To_Ch (RPI3.AUX_MU_IO_REG.DATA);
   end Console_Getchar;

   ----------------------------------------------------------------------------
   -- Setup
   ----------------------------------------------------------------------------
   procedure Setup
      is
      System_Clock : constant := 250 * MHz1;
      Baud_Rate    : constant := Baud_Rate_Type'Enum_Rep (BR_115200);
   begin
      -------------------------------------------------------------------------
      System.Secondary_Stack.SS_Init (BSP_SS_Stack, System.Parameters.Unspecified_Size);
      -------------------------------------------------------------------------
      Exceptions.Init;
      -- GPIO pins 14/15 (8/10) take alternate function 5 ---------------------
      RPI3.GPFSEL1.FSEL14 := RPI3.GPIO_ALT5;
      RPI3.GPFSEL1.FSEL15 := RPI3.GPIO_ALT5;
      -- mini-UART (UART1) ----------------------------------------------------
      RPI3.AUXENB.MiniUART_Enable := True;
      -- baud_rate_reg = SYSTEM_CLK / 8 * baud_rate - 1
      RPI3.AUX_MU_BAUD.Baudrate   := Unsigned_16 ((System_Clock + (Baud_Rate * 8 / 2)) / (Baud_Rate * 8) - 1);
      RPI3.AUX_MU_LCR_REG         := (
                                      Data_Size   => RPI3.UART_8BIT,
                                      Break       => False,
                                      DLAB_Access => False,
                                      others      => <>
                                     );
      RPI3.AUX_MU_CNTL_REG        := (
                                      Receiver_Enable    => True,
                                      Transmitter_Enable => True,
                                      RTS_RX_Autoflow    => False,
                                      CTS_TX_Autoflow    => False,
                                      RTS_Autoflow_Level => RPI3.RTS_Autoflow1,
                                      RTS_Assert_Level   => RPI3.RTS_AutoflowP,
                                      CTS_Assert_Level   => RPI3.CTS_AutoflowP,
                                      others             => <>
                                     );
      -- Console --------------------------------------------------------------
      Console.Console_Descriptor.Write := Console_Putchar'Access;
      Console.Console_Descriptor.Read  := Console_Getchar'Access;
      Console.Print (ANSI_CLS & ANSI_CUPHOME & VT100_LINEWRAP);
      Console.Print ("Raspberry Pi 3", NL => True);
      Console.Print (Natural (ARMv8A.CurrentEL_Read.EL), Prefix => "Current EL:   ", NL => True);
      Console.Print (RPI3.ARMTIMER_IRQ_ClrAck,           Prefix => "ARM Timer ID: ", NL => True); -- "TMRA"
      -- GPIOs 5/6 (header pins 29/31) are output -----------------------------
      RPI3.GPFSEL0.FSEL5 := RPI3.GPIO_OUTPUT;
      RPI3.GPFSEL0.FSEL6 := RPI3.GPIO_OUTPUT;
      -- Timer IRQ ------------------------------------------------------------
      RPI3.Enable_IRQs_1 (RPI3.system_timer_match_1) := True;
      -- handle IRQs at EL2
      if ARMv8A.CurrentEL_Read.EL = 2 then
         declare
            HCR_EL2 : ARMv8A.HCR_EL2_Type;
         begin
            HCR_EL2 := ARMv8A.HCR_EL2_Read;
            HCR_EL2.IMO := True;
            ARMv8A.HCR_EL2_Write (HCR_EL2);
         end;
      end if;
      ARMv8A.Irq_Enable;
      RPI3.Timer_Reload;
      -------------------------------------------------------------------------
   end Setup;

end BSP;

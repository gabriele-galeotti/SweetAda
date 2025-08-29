-----------------------------------------------------------------------------------------------------------------------
--                                                     SweetAda                                                      --
-----------------------------------------------------------------------------------------------------------------------
-- __HDS__                                                                                                           --
-- __FLN__ bsp.adb                                                                                                   --
-- __DSC__                                                                                                           --
-- __HSH__ e69de29bb2d1d6434b8b29ae775ad8c2e48c5391                                                                  --
-- __HDE__                                                                                                           --
-----------------------------------------------------------------------------------------------------------------------
-- Copyright (C) 2020-2025 Gabriele Galeotti                                                                         --
--                                                                                                                   --
-- SweetAda web page: http://sweetada.org                                                                            --
-- contact address: gabriele.galeotti@sweetada.org                                                                   --
-- This work is licensed under the terms of the MIT License.                                                         --
-- Please consult the LICENSE.txt file located in the top-level directory.                                           --
-----------------------------------------------------------------------------------------------------------------------

with System;
with Configure;
with Definitions;
with Bits;
with MMIO;
with SH;
with SH7032;
with GEMI;
with Console;

package body BSP
   is

   --========================================================================--
   --                                                                        --
   --                                                                        --
   --                           Local declarations                           --
   --                                                                        --
   --                                                                        --
   --========================================================================--

   use System;
   use Interfaces;
   use Definitions;
   use Bits;
   use SH7032;

   procedure GEMI_Last_Chance_Handler
      (Source_Location : in Address;
       Line            : in Integer)
      with Export        => True,
           Convention    => C,
           External_Name => "__gemi_last_chance_handler",
           No_Return     => True;

   --========================================================================--
   --                                                                        --
   --                                                                        --
   --                           Package subprograms                          --
   --                                                                        --
   --                                                                        --
   --========================================================================--

   ----------------------------------------------------------------------------
   -- GEMI_Last_Chance_Handler
   ----------------------------------------------------------------------------
   procedure GEMI_Last_Chance_Handler
      (Source_Location : in Address;
       Line            : in Integer)
      is
      pragma Unreferenced (Source_Location);
      pragma Unreferenced (Line);
      Delay_Count : constant := 30_000;
      Value       : Unsigned_8;
   begin
      Value := 16#F0#;
      loop
         GEMI.LEDPORT := Value;
         for Delay_Loop_Count in 1 .. Delay_Count loop SH.NOP; end loop;
         Value := Value xor 16#10#;
      end loop;
   end GEMI_Last_Chance_Handler;

   ----------------------------------------------------------------------------
   -- Console wrappers
   ----------------------------------------------------------------------------

   procedure Console_Putchar
      (C : in Character)
      is
   begin
      loop exit when SCI1.SSR.TDRE; end loop;
      SCI1.TDR := To_U8 (C);
      SCI1.SSR.TDRE := False;
   end Console_Putchar;

   procedure Console_Getchar
      (C : out Character)
      is
      Data : Unsigned_8;
   begin
      SCI1.SSR := (PER => False, FER => False, ORER => False, others => <>);
      loop exit when SCI1.SSR.RDRF; end loop;
      C := To_Ch (SCI1.RDR);
      SCI1.SSR.RDRF := False;
   end Console_Getchar;

   ----------------------------------------------------------------------------
   -- Setup
   ----------------------------------------------------------------------------
   procedure Setup
      is
      SCI1_BaudRate : constant := Baud_Rate_Type'Enum_Rep (BR_9600);
   begin
      -- PFC ------------------------------------------------------------------
      PBCR1 := (
         PB10   => PB10_RxD1, -- select SCI1
         PB11   => PB11_TxD1, -- ''
         others => <>
         );
      -- SCI1 -----------------------------------------------------------------
      SCI1.SCR := (@ with delta RE => False, TE => False);
      -- async 8N1, clock prescaler = 1
      SCI1.SMR := (
         CKS  => CKS_SYSCLOCK,
         MP   => False,
         STOP => STOP_1,
         OE   => OE_EVEN,
         PE   => False,
         CHR  => CHR_8,
         CA   => CA_ASYNC
         );
      -- Table 13.3 Bit Rates and BRR Settings in Asynchronous Mode
      -- CKS = CKS_SYSCLOCK => n = 0
      SCI1.BRR := Unsigned_8 (CLK_16M / ((64 / 2) * SCI1_BaudRate) - 1);
      SCI1.SCR.CKE := CKE_ASYNC_INTCLK_SCKIO;
      SCI1.SCR := (@ with delta RE => True, TE => True);
      -- UART 16x50 -----------------------------------------------------------
      UART_Descriptor := (
         Uart_Model    => UART16x50.UART16450,
         Base_Address  => System'To_Address (GEMI.UART_BASEADDRESS),
         Scale_Address => 4,
         Baud_Clock    => Configure.CLK_FREQUENCY,
         Flags         => (PC_UART => False),
         Read_8        => MMIO.Read'Access,
         Write_8       => MMIO.Write'Access,
         Data_Queue    => ([others => 0], 0, 0, 0)
         );
      UART16x50.Init (UART_Descriptor);
      -- RTC uPD4991A ---------------------------------------------------------
      RTC_Descriptor := (
         Base_Address  => System'To_Address (GEMI.RTC_BASEADDRESS),
         Scale_Address => 0,
         Read_8        => MMIO.Read'Access,
         Write_8       => MMIO.Write'Access
         );
      uPD4991A.Init (RTC_Descriptor);
      -- Console --------------------------------------------------------------
      Console.Console_Descriptor := (
         Write => Console_Putchar'Access,
         Read  => Console_Getchar'Access
         );
      Console.Print (ANSI_CLS & ANSI_CUPHOME & VT100_LINEWRAP);
      -------------------------------------------------------------------------
      Console.Print ("GEMI SH7032", NL => True);
      -------------------------------------------------------------------------
   end Setup;

end BSP;

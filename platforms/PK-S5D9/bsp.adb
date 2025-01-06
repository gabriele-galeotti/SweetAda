-----------------------------------------------------------------------------------------------------------------------
--                                                     SweetAda                                                      --
-----------------------------------------------------------------------------------------------------------------------
-- __HDS__                                                                                                           --
-- __FLN__ bsp.adb                                                                                                   --
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

with Definitions;
with Bits;
with ARMv7M;
with ARMv7M.FPU;
with CortexM4;
with S5D9;
with Exceptions;
with Console;
with Clocks;
with W25Q64FV;
with LCD;

package body BSP
   is

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
   use S5D9;

   procedure SysTick_Init;
   procedure LED_Init;
   procedure Serial_Console_Init;

   --========================================================================--
   --                                                                        --
   --                                                                        --
   --                           Package subprograms                          --
   --                                                                        --
   --                                                                        --
   --========================================================================--

   ----------------------------------------------------------------------------
   -- SysTick_Init
   ----------------------------------------------------------------------------
   procedure SysTick_Init
      is
   begin
      ARMv7M.SYST_RVR.RELOAD := Bits_24 (120_000_000 / 2_000);
      ARMv7M.SHPR3.PRI_15 := 16#FF#;
      ARMv7M.SYST_CVR.CURRENT := 0;
      ARMv7M.SYST_CSR := (
         ENABLE    => True,
         TICKINT   => True,
         CLKSOURCE => ARMv7M.CLKSOURCE_CPU,
         COUNTFLAG => False,
         others    => <>
         );
   end SysTick_Init;

   ----------------------------------------------------------------------------
   -- LED_Init
   ----------------------------------------------------------------------------
   procedure LED_Init
      is
   begin
      -- P600 output LED1 (green) OFF
      PFSR (P600).PMR := False;
      PORT (6).PDR (0) := True;
      PORT (6).PODR (0) := True;
      -- P601 output LED2 (red) OFF
      PFSR (P601).PMR := False;
      PORT (6).PDR (1) := True;
      PORT (6).PODR (1) := True;
      -- P602 output LED3 (yellow) OFF
      PFSR (P602).PMR := False;
      PORT (6).PDR (2) := True;
      PORT (6).PODR (2) := True;
   end LED_Init;

   ----------------------------------------------------------------------------
   -- Serial_Console_Init
   ----------------------------------------------------------------------------
   -- UART on J7: UART_RXD3 port P706, UART_TXD3 port P707
   ----------------------------------------------------------------------------
   procedure Serial_Console_Init
      is
   begin
      -- 34.3.7 SCI Initialization in Asynchronous Mode
      SCI (3).SCR := (
         CKE    => CKE_Async_On_Chip_BRG_SCK_IO,
         TEIE   => False,
         RE     => False,
         TE     => False,
         RIE    => False,
         TIE    => False,
         others => <>
         );
      SCI (3).FCR.FM := False;
      SCI (3).SIMR1.IICM := False;
      SCI (3).SPMR := (
         SSE    => False,
         CTSE   => False,
         MSS    => SPMR_MSS_Master,
         MFF    => False,
         CKPOL  => SPMR_CKPOL_NORMAL,
         CKPH   => SPMR_CKPH_NORMAL,
         others => <>
         );
      SCI (3).SCMR := (
         SMIF   => False,
         SINV   => SCMR_SINV_NO,
         SDIR   => SCMR_SDIR_LSB,
         CHR1   => CHR_8.CHR1,
         others => <>
         );
      SCI (3).SEMR := (
         BRME    => False,
         ABCSE   => False,
         ABCS    => False,
         NFEN    => False,
         BGDM    => False,
         RXDESEL => False,
         others  => <>
         );
      SCI (3).SMR.NORMAL := (
         CKS  => SMR_CKS_PCLKA,
         MP   => False,
         STOP => SMR_STOP_1,
         PM   => SMR_PM_EVEN,
         PE   => False,
         CHR  => CHR_8.CHR,
         CM   => SMR_CM_ASYNC
         );
      -- Table 34.10 Examples of BRR settings for different bit rates in asynchronous mode (2)
      SCI (3).BRR := 97; -- 9600 bps @ 30 MHz (n = 0)
      -- pin 706 function = SCI2, RxD
      PFSR (P706) := (PMR => True, PSEL => PSEL_SCI2, others => <>);
      -- pin 707 function = SCI2, TxD
      PFSR (P707) := (PMR => True, PSEL => PSEL_SCI2, others => <>);
      -- enable TE/RE
      SCI (3).SCR := (
         CKE    => CKE_Async_On_Chip_BRG_SCK_IO,
         RE     => True,
         TE     => True,
         others => False
         );
      SCI (3).SSR.NORMAL.PER  := False;
      SCI (3).SSR.NORMAL.FER  := False;
      SCI (3).SSR.NORMAL.ORER := False;
   end Serial_Console_Init;

   ----------------------------------------------------------------------------
   -- Console wrappers
   ----------------------------------------------------------------------------

   procedure Console_Putchar
      (C : in Character)
      is
   begin
      -- wait for transmitter available
      loop exit when SCI (3).SSR.NORMAL.TDRE; end loop;
      SCI (3).TDR := To_U8 (C);
   end Console_Putchar;

   procedure Console_Getchar
      (C : out Character)
      is
      Data : Unsigned_8;
   begin
      -- wait for receiver available
      loop exit when SCI (3).SSR.NORMAL.RDRF; end loop;
      Data := SCI (3).RDR;
      C := To_Ch (Data);
   end Console_Getchar;

   ----------------------------------------------------------------------------
   -- Setup
   ----------------------------------------------------------------------------
   procedure Setup
      is
   begin
      -- unlock registers -----------------------------------------------------
      PRCR := (
         PRC0   => True,          -- Protect Bit 0
         PRC1   => True,          -- Protect Bit 1
         PRC3   => True,          -- Protect Bit 3
         PRKEY  => PRCR_KEY_CODE, -- PRC Key Code
         others => <>
         );
      -- MCU clock: 120 MHz ---------------------------------------------------
      Clocks.Init;
      -- power-on peripherals -------------------------------------------------
      -- MSTPCRB.MSTPB31 := False; -- SCI0 on
      MSTPCRB.MSTPB19 := False; -- SPI0 on
      MSTPCRB.MSTPB28 := False; -- SCI3 on
      MSTPCRD.MSTPD3  := False; -- AGT0 on
      MSTPCRB.MSTPB6  := False; -- QSPI on
      -- enable writing to the PmnPFS register --------------------------------
      PWPR.B0WI  := False;
      PWPR.PFSWE := True;
      -------------------------------------------------------------------------
      Exceptions.Init;
      -------------------------------------------------------------------------
      Serial_Console_Init;
      -- Console --------------------------------------------------------------
      Console.Console_Descriptor := (
         Write => Console_Putchar'Access,
         Read  => Console_Getchar'Access
         );
      Console.Print (ANSI_CLS & ANSI_CUPHOME & VT100_LINEWRAP);
      -------------------------------------------------------------------------
      Console.Print ("Synergy PK-S5D9", NL => True);
      -------------------------------------------------------------------------
      pragma Warnings (Off);
      Console.Print (Prefix => "CPUID: ", Value => ARMv7M.To_U32 (ARMv7M.CPUID), NL => True);
      pragma Warnings (On);
      Console.Print (Prefix => "ACTLR: DISMCYCINT: ", Value => CortexM4.ACTLR.DISMCYCINT, NL => True);
      Console.Print (Prefix => "ACTLR: DISDEFWBUF: ", Value => CortexM4.ACTLR.DISDEFWBUF, NL => True);
      Console.Print (Prefix => "ACTLR: DISFOLD:    ", Value => CortexM4.ACTLR.DISFOLD, NL => True);
      Console.Print (Prefix => "ACTLR: DISFPCA:    ", Value => CortexM4.ACTLR.DISFPCA, NL => True);
      Console.Print (Prefix => "ACTLR: DISOOFP:    ", Value => CortexM4.ACTLR.DISOOFP, NL => True);
      -------------------------------------------------------------------------
      LED_Init;
      W25Q64FV.Init;
      W25Q64FV.Device_Detect;
      LCD.Init;
      -------------------------------------------------------------------------
      ARMv7M.Irq_Enable;
      ARMv7M.Fault_Irq_Enable;
      SysTick_Init;
      -------------------------------------------------------------------------
   end Setup;

end BSP;

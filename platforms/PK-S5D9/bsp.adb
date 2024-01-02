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
   use S5D9;

   procedure CLK_Init;
   procedure Serial_Console_Init;
   procedure QSPI_Init;
   procedure QSPI_Test;

   --========================================================================--
   --                                                                        --
   --                                                                        --
   --                           Package subprograms                          --
   --                                                                        --
   --                                                                        --
   --========================================================================--

   ----------------------------------------------------------------------------
   -- CLK_Init
   ----------------------------------------------------------------------------
   procedure CLK_Init is
   begin
      -- select MOCO
      SCKSCR.CKSEL := CLK_MOCO;
      -- stop MOSC clock
      MOSCCR.MOSTP := True;
      -- confirm MOSC clock stopped
      loop
         exit when not OSCSF.MOSCSF;
      end loop;
      -- stop PLL
      PLLCR.PLLSTP := True;
      -- confirm PLL stopped
      loop
         exit when not OSCSF.PLLSF;
      end loop;
      -- setup MODRV = 24 MHz MOSEL = Resonator AUTODRVEN = Disable
      MOMCR := (
         MODRV     => MODRV_20_24,
         MOSEL     => MOSEL_RES,
         AUTODRVEN => False,
         others    => <>
         );
      -- setup MOSCWTCR, conservative
      MOSCWTCR.MSTS := MSTS_9;
      -- start MOSC clock
      MOSCCR.MOSTP := False;
      -- wait for stabilization
      loop
         exit when OSCSF.MOSCSF;
      end loop;
      -- select MOSC clock
      SCKSCR.CKSEL := CLK_MOSC;
      -- use MOSC clock
      PLLCCR := (
         PLIDIV   => PLIDIV_2,      -- PLL Input Frequency Division Ratio Select (24 MHz / 2 = 12 MHz)
         PLSRCSEL => PLSRCSEL_MOSC, -- PLL Clock Source Select
         PLLMUL   => PLLMUL_x_10_0, -- PLL Frequency Multiplication Factor Select (12 MHz x 10 = 120 MHz)
         others   => <>
         );
      -- start PLL
      PLLCR.PLLSTP := False;
      -- wait for stabilization
      loop
         exit when OSCSF.PLLSF;
      end loop;
      -- select PLL
      SCKSCR.CKSEL := CLK_PLL;
      -- select module frequencies
      SCKDIVCR := (
         ICK    => CLOCK_NODIV,  -- System Clock              -> 120     MHz
         BCK    => CLOCK_DIV_4,  -- External Bus Clock        ->  30     MHz
         FCK    => CLOCK_DIV_4,  -- Flash Interface Clock     ->  30     MHz
         PCKA   => CLOCK_NODIV,  -- Peripheral Module Clock A -> 120     MHz
         PCKB   => CLOCK_DIV_64, -- Peripheral Module Clock B ->   1.875 MHz
         PCKC   => CLOCK_DIV_4,  -- Peripheral Module Clock C ->  30     MHz
         PCKD   => CLOCK_DIV_4,  -- Peripheral Module Clock D ->  30     MHz
         others => <>
         );
   end CLK_Init;

   ----------------------------------------------------------------------------
   -- SysTick_Init
   ----------------------------------------------------------------------------
   procedure SysTick_Init is
   begin
      ARMv7M.SYST_RVR.RELOAD := 16#8000#;
      ARMv7M.SHPR3.PRI_15 := 16#FF#;
      ARMv7M.SYST_CVR.CURRENT := 0;
      ARMv7M.SYST_CSR :=
         (ENABLE    => True,
          TICKINT   => True,
          CLKSOURCE => ARMv7M.CLKSOURCE_EXT,
          COUNTFLAG => False,
          others    => <>);
   end SysTick_Init;

   ----------------------------------------------------------------------------
   -- Serial_Console_Init
   ----------------------------------------------------------------------------
   -- UART on J7: UART_RXD3 port P706, UART_TXD3 port P707
   ----------------------------------------------------------------------------
   procedure Serial_Console_Init is
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
         CKS  => SMR_CKS_PCLKA4, -- n=1 -> CKS=1
         MP   => False,
         STOP => SMR_STOP_1,
         PM   => SMR_PM_EVEN,
         PE   => False,
         CHR  => CHR_8.CHR,
         CM   => SMR_CM_ASYNC
         );
      -- Table 34.10 Examples of BRR settings for different bit rates in asynchronous mode (2)
      SCI (3).BRR := 97; -- 9600 bps @ 120 MHz
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
   -- QSPI_Init
   ----------------------------------------------------------------------------
   procedure QSPI_Init is
   begin
      -- pins 500..505 function = QSPI
      for P5x in P500 .. P505 loop
         PFSR (P5x) := (PMR => True, PSEL => PSEL_QSPI, others => <>);
      end loop;
   end QSPI_Init;

   ----------------------------------------------------------------------------
   -- QSPI_Test
   ----------------------------------------------------------------------------
   procedure QSPI_Test is
      RDID  : constant := 16#9F#;
      mfid  : Unsigned_8; -- “Manufacturer Identification”
      mtype : Unsigned_8; -- “Memory Type”
      mcap  : Unsigned_8; -- “Memory Capacity”
   begin
      -- QSPI Read Identification
      QSPI.SFMCMD := (DCOM => DCOM_DIRECT, others => <>);
      QSPI.SFMCOM := (SFMD => RDID, others => <>);
      mfid  := QSPI.SFMCOM.SFMD;
      mtype := QSPI.SFMCOM.SFMD;
      mcap  := QSPI.SFMCOM.SFMD;
      QSPI.SFMCMD := (DCOM => DCOM_DIRECT, others => <>);
      Console.Print (mfid,  Prefix => "MFID  = 0x", NL => True);
      Console.Print (mtype, Prefix => "MTYPE = 0x", NL => True);
      Console.Print (mcap,  Prefix => "MCAP  = 0x", NL => True);
   end QSPI_Test;

   ----------------------------------------------------------------------------
   -- Console wrappers
   ----------------------------------------------------------------------------

   procedure Console_Putchar (C : in Character) is
   begin
      -- wait for transmitter available
      loop
         exit when SCI (3).SSR.NORMAL.TDRE;
      end loop;
      SCI (3).TDR := To_U8 (C);
   end Console_Putchar;

   procedure Console_Getchar (C : out Character) is
      Data : Unsigned_8;
   begin
      -- wait for receiver available
      loop
         exit when SCI (3).SSR.NORMAL.RDRF;
      end loop;
      Data := SCI (3).RDR;
      C := To_Ch (Data);
   end Console_Getchar;

   ----------------------------------------------------------------------------
   -- Setup
   ----------------------------------------------------------------------------
   procedure Setup is
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
      CLK_Init;
      -- power-on peripherals -------------------------------------------------
      MSTPCRB.MSTPB31 := False; -- SCI0 on
      MSTPCRB.MSTPB28 := False; -- SCI3 on
      MSTPCRD.MSTPD3  := False; -- AGT0
      MSTPCRB.MSTPB6  := False; -- QSPI
      -- enable writing to the PmnPFS register --------------------------------
      PWPR.B0WI  := False;
      PWPR.PFSWE := True;
      -------------------------------------------------------------------------
      Serial_Console_Init;
      QSPI_Init;
      -- Console --------------------------------------------------------------
      Console.Console_Descriptor.Write := Console_Putchar'Access;
      Console.Console_Descriptor.Read  := Console_Getchar'Access;
      Console.Print (ANSI_CLS & ANSI_CUPHOME & VT100_LINEWRAP);
      -------------------------------------------------------------------------
      Console.Print ("Synergy PK-S5D9", NL => True);
      -------------------------------------------------------------------------
      pragma Warnings (Off, "volatile actual passed by copy");
      Console.Print (ARMv7M.To_U32 (ARMv7M.CPUID), Prefix => "CPUID: ", NL => True);
      pragma Warnings (On, "volatile actual passed by copy");
      Console.Print (CortexM4.ACTLR.DISMCYCINT, Prefix => "ACTLR: DISMCYCINT: ", NL => True);
      Console.Print (CortexM4.ACTLR.DISDEFWBUF, Prefix => "ACTLR: DISDEFWBUF: ", NL => True);
      Console.Print (CortexM4.ACTLR.DISFOLD,    Prefix => "ACTLR: DISFOLD:    ", NL => True);
      Console.Print (CortexM4.ACTLR.DISFPCA,    Prefix => "ACTLR: DISFPCA:    ", NL => True);
      Console.Print (CortexM4.ACTLR.DISOOFP,    Prefix => "ACTLR: DISOOFP:    ", NL => True);
      QSPI_Test;
      -------------------------------------------------------------------------
   end Setup;

end BSP;

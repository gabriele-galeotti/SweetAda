-----------------------------------------------------------------------------------------------------------------------
--                                                     SweetAda                                                      --
-----------------------------------------------------------------------------------------------------------------------
-- __HDS__                                                                                                           --
-- __FLN__ bsp.adb                                                                                                   --
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

with Interfaces;
with Bits;
with ARMv7M;
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
   use Bits;
   use S5D9;

   procedure Serial_Console_Init;

   --========================================================================--
   --                                                                        --
   --                                                                        --
   --                           Package subprograms                          --
   --                                                                        --
   --                                                                        --
   --========================================================================--

   ----------------------------------------------------------------------------
   -- Serial_Console_Init
   ----------------------------------------------------------------------------
   -- UART on J7: UART_RXD3 port P706, UART_TXD3 port P707
   ----------------------------------------------------------------------------
   procedure Serial_Console_Init is
   begin
      -- 34.3.7 SCI Initialization in Asynchronous Mode
      SCI (3).SCR := (CKE10 => CKE_Async_On_Chip_BRG_SCK_IO, others => False); -- disable TE/RE
      SCI (3).FCR.FM := False;
      -- Table 34.10 Examples of BRR settings for different bit rates in asynchronous mode (2)
      SCI (3).BRR := 97; -- 9600 bps @ 120 MHz
      SCI (3).SEMR := (0, others => False);
      SCI (3).SMR.NORMAL := (
                             CKS10 => SMR_CKS_PCLKA4, -- n=1 -> CKS = 1
                             MP    => False,
                             STOP  => SMR_STOP_1,
                             PM    => SMR_PM_EVEN,
                             PE    => False,
                             CHR   => CHR_8.CHR,
                             CM    => SMR_CM_ASYNC
                            );
      SCI (3).SCMR := (
                       SMIF   => False,
                       SINV   => SCMR_SINV_NO,
                       SDIR   => SCMR_SDIR_LSB,
                       CHR1   => CHR_8.CHR1,
                       others => <>
                      );
      -- pin 706 function = SCI2
      PFSR (P706).PSEL := PSEL_SCI2;
      PFSR (P706).PMR  := True;
      -- pin 707 function = SCI2
      PFSR (P707).PSEL := PSEL_SCI2;
      PFSR (P707).PMR  := True;
      -- enable TE/RE
      SCI (3).SCR := (CKE10 => CKE_Async_On_Chip_BRG_SCK_IO, RE => True, TE => True, others => False);
   end Serial_Console_Init;

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
   -- BSP_Setup
   ----------------------------------------------------------------------------
   procedure BSP_Setup is
   begin
      -------------------------------------------------------------------------
      -- unlock registers
      PRCR := (True, True, 0, True, 0, PRCR_KEY_CODE);
      -- MCU clock: 120 MHz
      PLLCCR := (PLIDIV_2, 0, PLSRCSEL_Main, 0, PLLMUL_x_20_0, 0);
      -- enable writing to the PmnPFS register
      PWPR.B0WI  := False;
      PWPR.PFSWE := True;
      -- power-on peripherals
      MSTPCRB.MSTPB31 := False; -- SCI0 on
      MSTPCRB.MSTPB28 := False; -- SCI3 on
      -------------------------------------------------------------------------
      Serial_Console_Init;
      -- Console --------------------------------------------------------------
      Console.Console_Descriptor.Write := Console_Putchar'Access;
      Console.Console_Descriptor.Read  := Console_Getchar'Access;
      Console.TTY_Setup;
      -------------------------------------------------------------------------
      Console.Print ("Synergy S5D9", NL => True);
      -------------------------------------------------------------------------
      pragma Warnings (Off, "volatile actual passed by copy");
      Console.Print (ARMv7M.To_U32 (ARMv7M.CPUID), Prefix => "CPUID: ", NL => True);
      pragma Warnings (On, "volatile actual passed by copy");
      Console.Print (CortexM4.ACTLR.DISMCYCINT, Prefix => "ACTLR: DISMCYCINT: ", NL => True);
      Console.Print (CortexM4.ACTLR.DISDEFWBUF, Prefix => "ACTLR: DISDEFWBUF: ", NL => True);
      Console.Print (CortexM4.ACTLR.DISFOLD,    Prefix => "ACTLR: DISFOLD:    ", NL => True);
      Console.Print (CortexM4.ACTLR.DISFPCA,    Prefix => "ACTLR: DISFPCA:    ", NL => True);
      Console.Print (CortexM4.ACTLR.DISOOFP,    Prefix => "ACTLR: DISOOFP:    ", NL => True);
      -------------------------------------------------------------------------
   end BSP_Setup;

end BSP;

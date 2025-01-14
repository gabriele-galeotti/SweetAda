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
with Core;
with Bits;
with Secondary_Stack;
with MMIO;
with ARMv8A;
with Virt;
with Exceptions;
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
   use Virt;

   Timer_Constant : Unsigned_32;

   procedure Features_Dump;

   --========================================================================--
   --                                                                        --
   --                                                                        --
   --                           Package subprograms                          --
   --                                                                        --
   --                                                                        --
   --========================================================================--

   ----------------------------------------------------------------------------
   -- Timer_Reload
   ----------------------------------------------------------------------------
   procedure Timer_Reload
      is
   begin
      ARMv8A.CNTP_TVAL_EL0_Write ((TimerValue => Timer_Constant, others => <>));
   end Timer_Reload;

   ----------------------------------------------------------------------------
   -- Features_Dump
   ----------------------------------------------------------------------------
   procedure Features_Dump
      is
      ID_AA64PFR0_EL1 : ARMv8A.ID_AA64PFR0_EL1_Type;
      ID_AA64PFR1_EL1 : ARMv8A.ID_AA64PFR1_EL1_Type;
      MsgPtr          : access constant String;
      String_UNKNOWN  : aliased String := "UNKNOWN";
      MsgPtr_UNKNOWN  : constant access constant String := String_UNKNOWN'Access;
      procedure Print_Feature_Align
         (S : in String);
      procedure Print_Feature_Align
         (S : in String)
         is
      begin
         declare
            Padding_Length : constant Natural :=
               ARMv8A.ID_AA64PFRx_EL1_Max_String_Length - S'Length;
            Padding        : constant String (1 .. 1 + Padding_Length) :=
               [others => ' '];
         begin
            Console.Print (S & ":" & Padding);
         end;
      end Print_Feature_Align;
   begin
      -------------------------------------------------------------------------
      -- ID_AA64PFR0_EL1
      -------------------------------------------------------------------------
      ID_AA64PFR0_EL1 := ARMv8A.ID_AA64PFR0_EL1_Read;
      Console.Print ("ID_AA64PFR0_EL1:", NL => True);
      -- EL0
      Print_Feature_Align (ARMv8A.MsgPtr_EL0.all);
      case ID_AA64PFR0_EL1.EL0 is
         when ARMv8A.EL0_64   => MsgPtr := ARMv8A.MsgPtr_EL0_64;
         when ARMv8A.EL0_3264 => MsgPtr := ARMv8A.MsgPtr_EL0_3264;
         when others          => MsgPtr := MsgPtr_UNKNOWN;
      end case;
      Console.Print (MsgPtr.all, NL => True);
      -- EL1
      Print_Feature_Align (ARMv8A.MsgPtr_EL1.all);
      case ID_AA64PFR0_EL1.EL1 is
         when ARMv8A.EL1_64   => MsgPtr := ARMv8A.MsgPtr_EL1_64;
         when ARMv8A.EL1_3264 => MsgPtr := ARMv8A.MsgPtr_EL1_3264;
         when others          => MsgPtr := MsgPtr_UNKNOWN;
      end case;
      Console.Print (MsgPtr.all, NL => True);
      -- EL2
      Print_Feature_Align (ARMv8A.MsgPtr_EL2.all);
      case ID_AA64PFR0_EL1.EL2 is
         when ARMv8A.EL2_NONE => MsgPtr := ARMv8A.MsgPtr_EL2_NONE;
         when ARMv8A.EL2_64   => MsgPtr := ARMv8A.MsgPtr_EL2_64;
         when ARMv8A.EL2_3264 => MsgPtr := ARMv8A.MsgPtr_EL2_3264;
         when others          => MsgPtr := MsgPtr_UNKNOWN;
      end case;
      Console.Print (MsgPtr.all, NL => True);
      -- EL3
      Print_Feature_Align (ARMv8A.MsgPtr_EL3.all);
      case ID_AA64PFR0_EL1.EL3 is
         when ARMv8A.EL3_NONE => MsgPtr := ARMv8A.MsgPtr_EL3_NONE;
         when ARMv8A.EL3_64   => MsgPtr := ARMv8A.MsgPtr_EL3_64;
         when ARMv8A.EL3_3264 => MsgPtr := ARMv8A.MsgPtr_EL3_3264;
         when others          => MsgPtr := MsgPtr_UNKNOWN;
      end case;
      Console.Print (MsgPtr.all, NL => True);
      -- FP
      Print_Feature_Align (ARMv8A.MsgPtr_FP.all);
      case ID_AA64PFR0_EL1.FP is
         when ARMv8A.FP_YES           => MsgPtr := ARMv8A.MsgPtr_FP_YES;
         when ARMv8A.FP_HALFPRECISION => MsgPtr := ARMv8A.MsgPtr_FP_HALFPRECISION;
         when ARMv8A.FP_NONE          => MsgPtr := ARMv8A.MsgPtr_FP_NONE;
         when others                  => MsgPtr := MsgPtr_UNKNOWN;
      end case;
      Console.Print (MsgPtr.all, NL => True);
      -- AdvSIMD
      Print_Feature_Align (ARMv8A.MsgPtr_AdvSIMD.all);
      case ID_AA64PFR0_EL1.AdvSIMD is
         when ARMv8A.AdvSIMD_YES           => MsgPtr := ARMv8A.MsgPtr_AdvSIMD_YES;
         when ARMv8A.AdvSIMD_HALFPRECISION => MsgPtr := ARMv8A.MsgPtr_AdvSIMD_HALFPRECISION;
         when ARMv8A.AdvSIMD_NONE          => MsgPtr := ARMv8A.MsgPtr_AdvSIMD_NONE;
         when others                       => MsgPtr := MsgPtr_UNKNOWN;
      end case;
      Console.Print (MsgPtr.all, NL => True);
      -- GIC
      Print_Feature_Align (ARMv8A.MsgPtr_GIC.all);
      case ID_AA64PFR0_EL1.GIC is
         when ARMv8A.GIC_NONE  => MsgPtr := ARMv8A.MsgPtr_GIC_NONE;
         when ARMv8A.GIC_30_40 => MsgPtr := ARMv8A.MsgPtr_GIC_30_40;
         when ARMv8A.GIC_41    => MsgPtr := ARMv8A.MsgPtr_GIC_41;
         when others           => MsgPtr := MsgPtr_UNKNOWN;
      end case;
      Console.Print (MsgPtr.all, NL => True);
      -- RAS
      Print_Feature_Align (ARMv8A.MsgPtr_RAS.all);
      case ID_AA64PFR0_EL1.RAS is
         when ARMv8A.RAS_NONE => MsgPtr := ARMv8A.MsgPtr_RAS_NONE;
         when ARMv8A.RAS_YES  => MsgPtr := ARMv8A.MsgPtr_RAS_YES;
         when ARMv8A.RAS_v1p1 => MsgPtr := ARMv8A.MsgPtr_RAS_v1p1;
         when others          => MsgPtr := MsgPtr_UNKNOWN;
      end case;
      Console.Print (MsgPtr.all, NL => True);
      -- SVE
      Print_Feature_Align (ARMv8A.MsgPtr_SVE.all);
      case ID_AA64PFR0_EL1.SVE is
         when ARMv8A.SVE_NONE => MsgPtr := ARMv8A.MsgPtr_SVE_NONE;
         when ARMv8A.SVE_YES  => MsgPtr := ARMv8A.MsgPtr_SVE_YES;
         when others          => MsgPtr := MsgPtr_UNKNOWN;
      end case;
      Console.Print (MsgPtr.all, NL => True);
      -- SEL2
      Print_Feature_Align (ARMv8A.MsgPtr_SEL2.all);
      case ID_AA64PFR0_EL1.SEL2 is
         when ARMv8A.SEL2_NONE => MsgPtr := ARMv8A.MsgPtr_SEL2_NONE;
         when ARMv8A.SEL2_YES  => MsgPtr := ARMv8A.MsgPtr_SEL2_YES;
         when others           => MsgPtr := MsgPtr_UNKNOWN;
      end case;
      Console.Print (MsgPtr.all, NL => True);
      -- MPAM
      Print_Feature_Align (ARMv8A.MsgPtr_MPAM.all);
      case ID_AA64PFR0_EL1.MPAM is
         when ARMv8A.MPAM_0 => MsgPtr := ARMv8A.MsgPtr_MPAM_0;
         when ARMv8A.MPAM_1 => MsgPtr := ARMv8A.MsgPtr_MPAM_1;
         when others        => MsgPtr := MsgPtr_UNKNOWN;
      end case;
      Console.Print (MsgPtr.all, NL => True);
      -- AMU
      Print_Feature_Align (ARMv8A.MsgPtr_AMU.all);
      case ID_AA64PFR0_EL1.AMU is
         when ARMv8A.AMU_NONE => MsgPtr := ARMv8A.MsgPtr_AMU_NONE;
         when ARMv8A.AMU_v1   => MsgPtr := ARMv8A.MsgPtr_AMU_v1;
         when ARMv8A.AMU_v1p1 => MsgPtr := ARMv8A.MsgPtr_AMU_v1p1;
         when others          => MsgPtr := MsgPtr_UNKNOWN;
      end case;
      Console.Print (MsgPtr.all, NL => True);
      -- DIT
      Print_Feature_Align (ARMv8A.MsgPtr_DIT.all);
      case ID_AA64PFR0_EL1.DIT is
         when ARMv8A.DIT_NONE => MsgPtr := ARMv8A.MsgPtr_DIT_NONE;
         when ARMv8A.DIT_YES  => MsgPtr := ARMv8A.MsgPtr_DIT_YES;
         when others          => MsgPtr := MsgPtr_UNKNOWN;
      end case;
      Console.Print (MsgPtr.all, NL => True);
      -- RME
      Print_Feature_Align (ARMv8A.MsgPtr_RME.all);
      case ID_AA64PFR0_EL1.RME is
         when ARMv8A.RME_NONE => MsgPtr := ARMv8A.MsgPtr_RME_NONE;
         when ARMv8A.RME_v1   => MsgPtr := ARMv8A.MsgPtr_RME_v1;
         when others          => MsgPtr := MsgPtr_UNKNOWN;
      end case;
      Console.Print (MsgPtr.all, NL => True);
      -- CSV2
      Print_Feature_Align (ARMv8A.MsgPtr_CSV2.all);
      case ID_AA64PFR0_EL1.CSV2 is
         when ARMv8A.CSV2_NONE   => MsgPtr := ARMv8A.MsgPtr_CSV2_NONE;
         when ARMv8A.CSV2_YES    => MsgPtr := ARMv8A.MsgPtr_CSV2_YES;
         when ARMv8A.CSV2_CSV2_2 => MsgPtr := ARMv8A.MsgPtr_CSV2_CSV2_2;
         when ARMv8A.CSV2_CSV2_3 => MsgPtr := ARMv8A.MsgPtr_CSV2_CSV2_3;
         when others             => MsgPtr := MsgPtr_UNKNOWN;
      end case;
      Console.Print (MsgPtr.all, NL => True);
      -- CSV3
      Print_Feature_Align (ARMv8A.MsgPtr_CSV3.all);
      case ID_AA64PFR0_EL1.CSV3 is
         when ARMv8A.CSV3_NONE      => MsgPtr := ARMv8A.MsgPtr_CSV3_NONE;
         when ARMv8A.CSV3_DATAnADDR => MsgPtr := ARMv8A.MsgPtr_CSV3_DATAnADDR;
         when others                => MsgPtr := MsgPtr_UNKNOWN;
      end case;
      Console.Print (MsgPtr.all, NL => True);
      -------------------------------------------------------------------------
      -- ID_AA64PFR1_EL1
      -------------------------------------------------------------------------
      ID_AA64PFR1_EL1 := ARMv8A.ID_AA64PFR1_EL1_Read;
      Console.Print ("ID_AA64PFR1_EL1:", NL => True);
      -- BT
      Print_Feature_Align (ARMv8A.MsgPtr_BT.all);
      case ID_AA64PFR1_EL1.BT is
         when ARMv8A.BT_NONE => MsgPtr := ARMv8A.MsgPtr_BT_NONE;
         when ARMv8A.BT_YES  => MsgPtr := ARMv8A.MsgPtr_BT_YES;
         when others         => MsgPtr := MsgPtr_UNKNOWN;
      end case;
      Console.Print (MsgPtr.all, NL => True);
      -- SSBS
      Print_Feature_Align (ARMv8A.MsgPtr_SSBS.all);
      case ID_AA64PFR1_EL1.SSBS is
         when ARMv8A.SSBS_NONE   => MsgPtr := ARMv8A.MsgPtr_SSBS_NONE;
         when ARMv8A.SSBS_YES    => MsgPtr := ARMv8A.MsgPtr_SSBS_YES;
         when ARMv8A.SSBS_MSRMRS => MsgPtr := ARMv8A.MsgPtr_SSBS_MSRMRS;
         when others             => MsgPtr := MsgPtr_UNKNOWN;
      end case;
      Console.Print (MsgPtr.all, NL => True);
      -- MTE
      Print_Feature_Align (ARMv8A.MsgPtr_MTE.all);
      case ID_AA64PFR1_EL1.MTE is
         when ARMv8A.MTE_NONE      => MsgPtr := ARMv8A.MsgPtr_MTE_NONE;
         when ARMv8A.MTE_INSTR     => MsgPtr := ARMv8A.MsgPtr_MTE_INSTR;
         when ARMv8A.MTE_MEM       => MsgPtr := ARMv8A.MsgPtr_MTE_MEM;
         when ARMv8A.MTE_ASYMTAGCF => MsgPtr := ARMv8A.MsgPtr_MTE_ASYMTAGCF;
         when others               => MsgPtr := MsgPtr_UNKNOWN;
      end case;
      Console.Print (MsgPtr.all, NL => True);
      -- RAS_frac
      Print_Feature_Align (ARMv8A.MsgPtr_RAS_frac.all);
      case ID_AA64PFR1_EL1.RAS_frac is
         when ARMv8A.RAS_frac_RAS      => MsgPtr := ARMv8A.MsgPtr_RAS_frac_RAS;
         when ARMv8A.RAS_frac_EXTENDED => MsgPtr := ARMv8A.MsgPtr_RAS_frac_EXTENDED;
         when others                   => MsgPtr := MsgPtr_UNKNOWN;
      end case;
      Console.Print (MsgPtr.all, NL => True);
      -- MPAM_frac
      Print_Feature_Align (ARMv8A.MsgPtr_MPAM_frac.all);
      case ID_AA64PFR1_EL1.MPAM_frac is
         when ARMv8A.MPAM_frac_0 => MsgPtr := ARMv8A.MsgPtr_MPAM_frac_0;
         when ARMv8A.MPAM_frac_1 => MsgPtr := ARMv8A.MsgPtr_MPAM_frac_1;
         when others             => MsgPtr := MsgPtr_UNKNOWN;
      end case;
      Console.Print (MsgPtr.all, NL => True);
      -- SME
      Print_Feature_Align (ARMv8A.MsgPtr_SME.all);
      case ID_AA64PFR1_EL1.SME is
         when ARMv8A.SME_NONE    => MsgPtr := ARMv8A.MsgPtr_SME_NONE;
         when ARMv8A.SME_YES     => MsgPtr := ARMv8A.MsgPtr_SME_YES;
         when ARMv8A.SME_SME2ZT0 => MsgPtr := ARMv8A.MsgPtr_SME_SME2ZT0;
         when others             => MsgPtr := MsgPtr_UNKNOWN;
      end case;
      Console.Print (MsgPtr.all, NL => True);
      -- RNDR_trap
      Print_Feature_Align (ARMv8A.MsgPtr_RNDR_trap.all);
      case ID_AA64PFR1_EL1.RNDR_trap is
         when ARMv8A.RNDR_trap_NONE => MsgPtr := ARMv8A.MsgPtr_RNDR_trap_NONE;
         when ARMv8A.RNDR_trap_YES  => MsgPtr := ARMv8A.MsgPtr_RNDR_trap_YES;
         when others                => MsgPtr := MsgPtr_UNKNOWN;
      end case;
      Console.Print (MsgPtr.all, NL => True);
      -- CSV2_frac
      Print_Feature_Align (ARMv8A.MsgPtr_CSV2_frac.all);
      case ID_AA64PFR1_EL1.CSV2_frac is
         when ARMv8A.CSV2_frac_NONE => MsgPtr := ARMv8A.MsgPtr_CSV2_frac_NONE;
         when ARMv8A.CSV2_frac_1p1  => MsgPtr := ARMv8A.MsgPtr_CSV2_frac_1p1;
         when ARMv8A.CSV2_frac_1p2  => MsgPtr := ARMv8A.MsgPtr_CSV2_frac_1p2;
         when others                => MsgPtr := MsgPtr_UNKNOWN;
      end case;
      Console.Print (MsgPtr.all, NL => True);
      -- NMI
      Print_Feature_Align (ARMv8A.MsgPtr_NMI.all);
      case ID_AA64PFR1_EL1.NMI is
         when ARMv8A.NMI_NONE => MsgPtr := ARMv8A.MsgPtr_NMI_NONE;
         when ARMv8A.NMI_YES  => MsgPtr := ARMv8A.MsgPtr_NMI_YES;
         when others                => MsgPtr := MsgPtr_UNKNOWN;
      end case;
      Console.Print (MsgPtr.all, NL => True);
   end Features_Dump;

   ----------------------------------------------------------------------------
   -- Console wrappers
   ----------------------------------------------------------------------------

   procedure Console_Putchar
      (C : in Character)
      is
   begin
      PL011.TX (PL011_Descriptor, To_U8 (C));
   end Console_Putchar;

   procedure Console_Getchar
      (C : out Character)
      is
      Data : Unsigned_8;
   begin
      PL011.RX (PL011_Descriptor, Data);
      C := To_Ch (Data);
   end Console_Getchar;

   ----------------------------------------------------------------------------
   -- Setup
   ----------------------------------------------------------------------------
   procedure Setup
      is
      EL : Bits_2;
   begin
      -------------------------------------------------------------------------
      Secondary_Stack.Init;
      -------------------------------------------------------------------------
      Exceptions.Init;
      -- PL011 hardware initialization ----------------------------------------
      PL011_Descriptor := (
         Base_Address => System'To_Address (PL011_UART0_BASEADDRESS),
         Baud_Clock   => CLK_UART14M,
         Read_8       => MMIO.Read'Access,
         Write_8      => MMIO.Write'Access,
         Read_16      => MMIO.Read'Access,
         Write_16     => MMIO.Write'Access
         );
      PL011.Init (PL011_Descriptor);
      -- Console --------------------------------------------------------------
      Console.Console_Descriptor := (
         Write => Console_Putchar'Access,
         Read  => Console_Getchar'Access
         );
      Console.Print (ANSI_CLS & ANSI_CUPHOME & VT100_LINEWRAP);
      -------------------------------------------------------------------------
      Console.Print ("AArch64 Cortex-A53 (QEMU emulator)", NL => True);
      EL := ARMv8A.CurrentEL_Read.EL;
      Console.Print (Prefix => "Current EL: ", Value => Natural (EL), NL => True);
      Console.Print (Prefix => "CNTFRQ_EL0: ", Value => ARMv8A.CNTFRQ_EL0_Read.Clock_frequency, NL => True);
      -------------------------------------------------------------------------
      Features_Dump;
      -------------------------------------------------------------------------
      if Core.Debug_Flag then
         Console.Print ("Debug_Flag: ENABLED", NL => True);
      end if;
      -------------------------------------------------------------------------
      -- GIC minimal setup
      GICD.GICD_CTLR.EnableGrp0   := True;
      GICD.GICD_ISENABLER (0)(30) := True;
      GICC.GICC_CTLR.EnableGrp0   := True;
      GICC.GICC_PMR.Priority      := 16#FF#;
      Timer_Constant :=
         (ARMv8A.CNTFRQ_EL0_Read.Clock_frequency + Configure.TICK_FREQUENCY / 2) /
         Configure.TICK_FREQUENCY;
      Timer_Reload;
      ARMv8A.CNTP_CTL_EL0_Write ((
         ENABLE  => True,
         IMASK   => False,
         ISTATUS => False,
         others  => <>
         ));
      -- handle IRQs at EL3
      if EL = ARMv8A.EL3 then
         declare
            SCR_EL3 : ARMv8A.SCR_EL3_Type;
         begin
            SCR_EL3 := ARMv8A.SCR_EL3_Read;
            SCR_EL3.IRQ := True;
            ARMv8A.SCR_EL3_Write (SCR_EL3);
         end;
      end if;
      -- handle IRQs at EL2
      if EL = ARMv8A.EL2 then
         declare
            HCR_EL2 : ARMv8A.HCR_EL2_Type;
         begin
            HCR_EL2 := ARMv8A.HCR_EL2_Read;
            HCR_EL2.IMO := True;
            ARMv8A.HCR_EL2_Write (HCR_EL2);
         end;
      end if;
      ARMv8A.Irq_Enable;
      -------------------------------------------------------------------------
   end Setup;

end BSP;

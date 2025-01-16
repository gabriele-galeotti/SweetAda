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
   use ARMv8A;
   use Virt;

   Timer_Constant : Unsigned_32;

   procedure CPU_Detect;

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
      CNTP_TVAL_EL0_Write ((TimerValue => Timer_Constant, others => <>));
   end Timer_Reload;

   ----------------------------------------------------------------------------
   -- CPU_Detect
   ----------------------------------------------------------------------------
   procedure CPU_Detect
      is
      MIDR            : MIDR_EL1_Type;
      ID_AA64PFR0_EL1 : ID_AA64PFR0_EL1_Type;
      ID_AA64PFR1_EL1 : ID_AA64PFR1_EL1_Type;
      MsgPtr          : access constant String;
      Max_StrLen      : constant := ID_AA64PFRx_EL1_Max_String_Length;
      Pad_Spaces      : constant String (1 .. 1 + Max_StrLen) := [others => ' '];
      String_UNKNOWN  : aliased constant String := "UNKNOWN";
      MsgPtr_UNKNOWN  : constant access constant String := String_UNKNOWN'Access;
      function Architecture
         return access constant String;
      function Architecture
         return access constant String
         is
      begin
         for Index in Architectures'Range loop
            if MIDR.Architecture = Architectures (Index).CODE then
               return Architectures (Index).DESCRIPTION;
            end if;
         end loop;
         return MsgPtr_UNKNOWN;
      end Architecture;
      function Implementer
         return access constant String;
      function Implementer
         return access constant String
         is
      begin
         for Index in Implementers'Range loop
            if MIDR.Implementer = Implementers (Index).CODE then
               return Implementers (Index).DESCRIPTION;
            end if;
         end loop;
         return MsgPtr_UNKNOWN;
      end Implementer;
   begin
      -------------------------------------------------------------------------
      -- MIDR_EL1
      -------------------------------------------------------------------------
      MIDR := MIDR_EL1_Read;
      Console.Print (Prefix => "Revision:     ", Value => Natural (MIDR.Revision), NL => True);
      Console.Print (Prefix => "Part Number:  ", Value => Unsigned_16 (MIDR.PartNum), NL => True);
      Console.Print (Prefix => "Architecture: ", Value => Architecture.all, NL => True);
      Console.Print (Prefix => "Variant:      ", Value => Natural (MIDR.Variant), NL => True);
      Console.Print (Prefix => "Implementer:  ", Value => Implementer.all, NL => True);
      -------------------------------------------------------------------------
      -- ID_AA64PFR0_EL1
      -------------------------------------------------------------------------
      ID_AA64PFR0_EL1 := ID_AA64PFR0_EL1_Read;
      Console.Print ("ID_AA64PFR0_EL1:", NL => True);
      -- EL0
      Console.Print (MsgPtr_EL0.all & ":" &
                     Pad_Spaces (1 .. 1 + Max_StrLen - MsgPtr_EL0.all'Length));
      case ID_AA64PFR0_EL1.EL0 is
         when EL0_64   => MsgPtr := MsgPtr_EL0_64;
         when EL0_3264 => MsgPtr := MsgPtr_EL0_3264;
         when others   => MsgPtr := MsgPtr_UNKNOWN;
      end case;
      Console.Print (MsgPtr.all, NL => True);
      -- EL1
      Console.Print (MsgPtr_EL1.all & ":" &
                     Pad_Spaces (1 .. 1 + Max_StrLen - MsgPtr_EL1.all'Length));
      case ID_AA64PFR0_EL1.EL1 is
         when EL1_64   => MsgPtr := MsgPtr_EL1_64;
         when EL1_3264 => MsgPtr := MsgPtr_EL1_3264;
         when others   => MsgPtr := MsgPtr_UNKNOWN;
      end case;
      Console.Print (MsgPtr.all, NL => True);
      -- EL2
      Console.Print (MsgPtr_EL2.all & ":" &
                     Pad_Spaces (1 .. 1 + Max_StrLen - MsgPtr_EL2.all'Length));
      case ID_AA64PFR0_EL1.EL2 is
         when EL2_NONE => MsgPtr := MsgPtr_EL2_NONE;
         when EL2_64   => MsgPtr := MsgPtr_EL2_64;
         when EL2_3264 => MsgPtr := MsgPtr_EL2_3264;
         when others   => MsgPtr := MsgPtr_UNKNOWN;
      end case;
      Console.Print (MsgPtr.all, NL => True);
      -- EL3
      Console.Print (MsgPtr_EL3.all & ":" &
                     Pad_Spaces (1 .. 1 + Max_StrLen - MsgPtr_EL3.all'Length));
      case ID_AA64PFR0_EL1.EL3 is
         when EL3_NONE => MsgPtr := MsgPtr_EL3_NONE;
         when EL3_64   => MsgPtr := MsgPtr_EL3_64;
         when EL3_3264 => MsgPtr := MsgPtr_EL3_3264;
         when others   => MsgPtr := MsgPtr_UNKNOWN;
      end case;
      Console.Print (MsgPtr.all, NL => True);
      -- FP
      Console.Print (MsgPtr_FP.all & ":" &
                     Pad_Spaces (1 .. 1 + Max_StrLen - MsgPtr_FP.all'Length));
      case ID_AA64PFR0_EL1.FP is
         when FP_YES           => MsgPtr := MsgPtr_FP_YES;
         when FP_HALFPRECISION => MsgPtr := MsgPtr_FP_HALFPRECISION;
         when FP_NONE          => MsgPtr := MsgPtr_FP_NONE;
         when others           => MsgPtr := MsgPtr_UNKNOWN;
      end case;
      Console.Print (MsgPtr.all, NL => True);
      -- AdvSIMD
      Console.Print (MsgPtr_AdvSIMD.all & ":" &
                     Pad_Spaces (1 .. 1 + Max_StrLen - MsgPtr_AdvSIMD.all'Length));
      case ID_AA64PFR0_EL1.AdvSIMD is
         when AdvSIMD_YES           => MsgPtr := MsgPtr_AdvSIMD_YES;
         when AdvSIMD_HALFPRECISION => MsgPtr := MsgPtr_AdvSIMD_HALFPRECISION;
         when AdvSIMD_NONE          => MsgPtr := MsgPtr_AdvSIMD_NONE;
         when others                => MsgPtr := MsgPtr_UNKNOWN;
      end case;
      Console.Print (MsgPtr.all, NL => True);
      -- GIC
      Console.Print (MsgPtr_GIC.all & ":" &
                     Pad_Spaces (1 .. 1 + Max_StrLen - MsgPtr_GIC.all'Length));
      case ID_AA64PFR0_EL1.GIC is
         when GIC_NONE  => MsgPtr := MsgPtr_GIC_NONE;
         when GIC_30_40 => MsgPtr := MsgPtr_GIC_30_40;
         when GIC_41    => MsgPtr := MsgPtr_GIC_41;
         when others    => MsgPtr := MsgPtr_UNKNOWN;
      end case;
      Console.Print (MsgPtr.all, NL => True);
      -- RAS
      Console.Print (MsgPtr_RAS.all & ":" &
                     Pad_Spaces (1 .. 1 + Max_StrLen - MsgPtr_RAS.all'Length));
      case ID_AA64PFR0_EL1.RAS is
         when RAS_NONE => MsgPtr := MsgPtr_RAS_NONE;
         when RAS_YES  => MsgPtr := MsgPtr_RAS_YES;
         when RAS_v1p1 => MsgPtr := MsgPtr_RAS_v1p1;
         when others   => MsgPtr := MsgPtr_UNKNOWN;
      end case;
      Console.Print (MsgPtr.all, NL => True);
      -- SVE
      Console.Print (MsgPtr_SVE.all & ":" &
                     Pad_Spaces (1 .. 1 + Max_StrLen - MsgPtr_SVE.all'Length));
      case ID_AA64PFR0_EL1.SVE is
         when SVE_NONE => MsgPtr := MsgPtr_SVE_NONE;
         when SVE_YES  => MsgPtr := MsgPtr_SVE_YES;
         when others   => MsgPtr := MsgPtr_UNKNOWN;
      end case;
      Console.Print (MsgPtr.all, NL => True);
      -- SEL2
      Console.Print (MsgPtr_SEL2.all & ":" &
                     Pad_Spaces (1 .. 1 + Max_StrLen - MsgPtr_SEL2.all'Length));
      case ID_AA64PFR0_EL1.SEL2 is
         when SEL2_NONE => MsgPtr := MsgPtr_SEL2_NONE;
         when SEL2_YES  => MsgPtr := MsgPtr_SEL2_YES;
         when others    => MsgPtr := MsgPtr_UNKNOWN;
      end case;
      Console.Print (MsgPtr.all, NL => True);
      -- MPAM
      Console.Print (MsgPtr_MPAM.all & ":" &
                     Pad_Spaces (1 .. 1 + Max_StrLen - MsgPtr_MPAM.all'Length));
      case ID_AA64PFR0_EL1.MPAM is
         when MPAM_0 => MsgPtr := MsgPtr_MPAM_0;
         when MPAM_1 => MsgPtr := MsgPtr_MPAM_1;
         when others => MsgPtr := MsgPtr_UNKNOWN;
      end case;
      Console.Print (MsgPtr.all, NL => True);
      -- AMU
      Console.Print (MsgPtr_AMU.all & ":" &
                     Pad_Spaces (1 .. 1 + Max_StrLen - MsgPtr_AMU.all'Length));
      case ID_AA64PFR0_EL1.AMU is
         when AMU_NONE => MsgPtr := MsgPtr_AMU_NONE;
         when AMU_v1   => MsgPtr := MsgPtr_AMU_v1;
         when AMU_v1p1 => MsgPtr := MsgPtr_AMU_v1p1;
         when others   => MsgPtr := MsgPtr_UNKNOWN;
      end case;
      Console.Print (MsgPtr.all, NL => True);
      -- DIT
      Console.Print (MsgPtr_DIT.all & ":" &
                     Pad_Spaces (1 .. 1 + Max_StrLen - MsgPtr_DIT.all'Length));
      case ID_AA64PFR0_EL1.DIT is
         when DIT_NONE => MsgPtr := MsgPtr_DIT_NONE;
         when DIT_YES  => MsgPtr := MsgPtr_DIT_YES;
         when others   => MsgPtr := MsgPtr_UNKNOWN;
      end case;
      Console.Print (MsgPtr.all, NL => True);
      -- RME
      Console.Print (MsgPtr_RME.all & ":" &
                     Pad_Spaces (1 .. 1 + Max_StrLen - MsgPtr_RME.all'Length));
      case ID_AA64PFR0_EL1.RME is
         when RME_NONE => MsgPtr := MsgPtr_RME_NONE;
         when RME_v1   => MsgPtr := MsgPtr_RME_v1;
         when others   => MsgPtr := MsgPtr_UNKNOWN;
      end case;
      Console.Print (MsgPtr.all, NL => True);
      -- CSV2
      Console.Print (MsgPtr_CSV2.all & ":" &
                     Pad_Spaces (1 .. 1 + Max_StrLen - MsgPtr_CSV2.all'Length));
      case ID_AA64PFR0_EL1.CSV2 is
         when CSV2_NONE   => MsgPtr := MsgPtr_CSV2_NONE;
         when CSV2_YES    => MsgPtr := MsgPtr_CSV2_YES;
         when CSV2_CSV2_2 => MsgPtr := MsgPtr_CSV2_CSV2_2;
         when CSV2_CSV2_3 => MsgPtr := MsgPtr_CSV2_CSV2_3;
         when others      => MsgPtr := MsgPtr_UNKNOWN;
      end case;
      Console.Print (MsgPtr.all, NL => True);
      -- CSV3
      Console.Print (MsgPtr_CSV3.all & ":" &
                     Pad_Spaces (1 .. 1 + Max_StrLen - MsgPtr_CSV3.all'Length));
      case ID_AA64PFR0_EL1.CSV3 is
         when CSV3_NONE      => MsgPtr := MsgPtr_CSV3_NONE;
         when CSV3_DATAnADDR => MsgPtr := MsgPtr_CSV3_DATAnADDR;
         when others         => MsgPtr := MsgPtr_UNKNOWN;
      end case;
      Console.Print (MsgPtr.all, NL => True);
      -------------------------------------------------------------------------
      -- ID_AA64PFR1_EL1
      -------------------------------------------------------------------------
      ID_AA64PFR1_EL1 := ID_AA64PFR1_EL1_Read;
      Console.Print ("ID_AA64PFR1_EL1:", NL => True);
      -- BT
      Console.Print (MsgPtr_BT.all & ":" &
                     Pad_Spaces (1 .. 1 + Max_StrLen - MsgPtr_BT.all'Length));
      case ID_AA64PFR1_EL1.BT is
         when BT_NONE => MsgPtr := MsgPtr_BT_NONE;
         when BT_YES  => MsgPtr := MsgPtr_BT_YES;
         when others  => MsgPtr := MsgPtr_UNKNOWN;
      end case;
      Console.Print (MsgPtr.all, NL => True);
      -- SSBS
      Console.Print (MsgPtr_SSBS.all & ":" &
                     Pad_Spaces (1 .. 1 + Max_StrLen - MsgPtr_SSBS.all'Length));
      case ID_AA64PFR1_EL1.SSBS is
         when SSBS_NONE   => MsgPtr := MsgPtr_SSBS_NONE;
         when SSBS_YES    => MsgPtr := MsgPtr_SSBS_YES;
         when SSBS_MSRMRS => MsgPtr := MsgPtr_SSBS_MSRMRS;
         when others      => MsgPtr := MsgPtr_UNKNOWN;
      end case;
      Console.Print (MsgPtr.all, NL => True);
      -- MTE
      Console.Print (MsgPtr_MTE.all & ":" &
                     Pad_Spaces (1 .. 1 + Max_StrLen - MsgPtr_MTE.all'Length));
      case ID_AA64PFR1_EL1.MTE is
         when MTE_NONE      => MsgPtr := MsgPtr_MTE_NONE;
         when MTE_INSTR     => MsgPtr := MsgPtr_MTE_INSTR;
         when MTE_MEM       => MsgPtr := MsgPtr_MTE_MEM;
         when MTE_ASYMTAGCF => MsgPtr := MsgPtr_MTE_ASYMTAGCF;
         when others        => MsgPtr := MsgPtr_UNKNOWN;
      end case;
      Console.Print (MsgPtr.all, NL => True);
      -- RAS_frac
      Console.Print (MsgPtr_RAS_frac.all & ":" &
                     Pad_Spaces (1 .. 1 + Max_StrLen - MsgPtr_RAS_frac.all'Length));
      case ID_AA64PFR1_EL1.RAS_frac is
         when RAS_frac_RAS      => MsgPtr := MsgPtr_RAS_frac_RAS;
         when RAS_frac_EXTENDED => MsgPtr := MsgPtr_RAS_frac_EXTENDED;
         when others            => MsgPtr := MsgPtr_UNKNOWN;
      end case;
      Console.Print (MsgPtr.all, NL => True);
      -- MPAM_frac
      Console.Print (MsgPtr_MPAM_frac.all & ":" &
                     Pad_Spaces (1 .. 1 + Max_StrLen - MsgPtr_MPAM_frac.all'Length));
      case ID_AA64PFR1_EL1.MPAM_frac is
         when MPAM_frac_0 => MsgPtr := MsgPtr_MPAM_frac_0;
         when MPAM_frac_1 => MsgPtr := MsgPtr_MPAM_frac_1;
         when others      => MsgPtr := MsgPtr_UNKNOWN;
      end case;
      Console.Print (MsgPtr.all, NL => True);
      -- SME
      Console.Print (MsgPtr_SME.all & ":" &
                     Pad_Spaces (1 .. 1 + Max_StrLen - MsgPtr_SME.all'Length));
      case ID_AA64PFR1_EL1.SME is
         when SME_NONE    => MsgPtr := MsgPtr_SME_NONE;
         when SME_YES     => MsgPtr := MsgPtr_SME_YES;
         when SME_SME2ZT0 => MsgPtr := MsgPtr_SME_SME2ZT0;
         when others      => MsgPtr := MsgPtr_UNKNOWN;
      end case;
      Console.Print (MsgPtr.all, NL => True);
      -- RNDR_trap
      Console.Print (MsgPtr_RNDR_trap.all & ":" &
                     Pad_Spaces (1 .. 1 + Max_StrLen - MsgPtr_RNDR_trap.all'Length));
      case ID_AA64PFR1_EL1.RNDR_trap is
         when RNDR_trap_NONE => MsgPtr := MsgPtr_RNDR_trap_NONE;
         when RNDR_trap_YES  => MsgPtr := MsgPtr_RNDR_trap_YES;
         when others         => MsgPtr := MsgPtr_UNKNOWN;
      end case;
      Console.Print (MsgPtr.all, NL => True);
      -- CSV2_frac
      Console.Print (MsgPtr_CSV2_frac.all & ":" &
                     Pad_Spaces (1 .. 1 + Max_StrLen - MsgPtr_CSV2_frac.all'Length));
      case ID_AA64PFR1_EL1.CSV2_frac is
         when CSV2_frac_NONE => MsgPtr := MsgPtr_CSV2_frac_NONE;
         when CSV2_frac_1p1  => MsgPtr := MsgPtr_CSV2_frac_1p1;
         when CSV2_frac_1p2  => MsgPtr := MsgPtr_CSV2_frac_1p2;
         when others         => MsgPtr := MsgPtr_UNKNOWN;
      end case;
      Console.Print (MsgPtr.all, NL => True);
      -- NMI
      Console.Print (MsgPtr_NMI.all & ":" &
                     Pad_Spaces (1 .. 1 + Max_StrLen - MsgPtr_NMI.all'Length));
      case ID_AA64PFR1_EL1.NMI is
         when NMI_NONE => MsgPtr := MsgPtr_NMI_NONE;
         when NMI_YES  => MsgPtr := MsgPtr_NMI_YES;
         when others   => MsgPtr := MsgPtr_UNKNOWN;
      end case;
      Console.Print (MsgPtr.all, NL => True);
   end CPU_Detect;

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
      -------------------------------------------------------------------------
      CPU_Detect;
      EL := CurrentEL_Read.EL;
      Console.Print (Prefix => "Current EL: ", Value => Natural (EL), NL => True);
      Console.Print (Prefix => "CNTFRQ_EL0: ", Value => CNTFRQ_EL0_Read.Clock_frequency, NL => True);
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
         (CNTFRQ_EL0_Read.Clock_frequency + Configure.TICK_FREQUENCY / 2) /
         Configure.TICK_FREQUENCY;
      Timer_Reload;
      CNTP_CTL_EL0_Write ((
         ENABLE  => True,
         IMASK   => False,
         ISTATUS => False,
         others  => <>
         ));
      -- handle IRQs at EL3
      if EL = EL3 then
         declare
            SCR_EL3 : SCR_EL3_Type;
         begin
            SCR_EL3 := SCR_EL3_Read;
            SCR_EL3.IRQ := True;
            SCR_EL3_Write (SCR_EL3);
         end;
      end if;
      -- handle IRQs at EL2
      if EL = EL2 then
         declare
            HCR_EL2 : HCR_EL2_Type;
         begin
            HCR_EL2 := HCR_EL2_Read;
            HCR_EL2.IMO := True;
            HCR_EL2_Write (HCR_EL2);
         end;
      end if;
      Irq_Enable;
      -------------------------------------------------------------------------
   end Setup;

end BSP;

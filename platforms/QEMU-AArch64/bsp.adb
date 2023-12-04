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
with System.Storage_Elements;
with Configure;
with Definitions;
with Core;
with Bits;
with MMIO;
with ARMv8A;
with Virt;
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

   use System;
   use System.Storage_Elements;
   use Interfaces;
   use Definitions;
   use Bits;
   use Virt;

   BSP_SS_Stack : System.Secondary_Stack.SS_Stack_Ptr;

   Timer_Constant : Unsigned_32;

   function Get_Sec_Stack return System.Secondary_Stack.SS_Stack_Ptr with
      Export        => True,
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
   -- Get_Sec_Stack
   ----------------------------------------------------------------------------
   function Get_Sec_Stack return System.Secondary_Stack.SS_Stack_Ptr is
   begin
      return BSP_SS_Stack;
   end Get_Sec_Stack;

   ----------------------------------------------------------------------------
   -- Timer_Reload
   ----------------------------------------------------------------------------
   procedure Timer_Reload is
   begin
      ARMv8A.CNTP_TVAL_EL0_Write ((TimerValue => Timer_Constant, others => <>));
   end Timer_Reload;

   ----------------------------------------------------------------------------
   -- Console wrappers
   ----------------------------------------------------------------------------

   procedure Console_Putchar (C : in Character) is
   begin
      PL011.TX (PL011_Descriptor, To_U8 (C));
   end Console_Putchar;

   procedure Console_Getchar (C : out Character) is
      Data : Unsigned_8;
   begin
      PL011.RX (PL011_Descriptor, Data);
      C := To_Ch (Data);
   end Console_Getchar;

   ----------------------------------------------------------------------------
   -- Setup
   ----------------------------------------------------------------------------
   procedure Setup is
   begin
      -------------------------------------------------------------------------
      Exceptions.Init;
      -------------------------------------------------------------------------
      System.Secondary_Stack.SS_Init (BSP_SS_Stack, System.Parameters.Unspecified_Size);
      -- PL011 hardware initialization ----------------------------------------
      PL011_Descriptor.Read_8       := MMIO.Read'Access;
      PL011_Descriptor.Write_8      := MMIO.Write'Access;
      PL011_Descriptor.Read_16      := MMIO.Read'Access;
      PL011_Descriptor.Write_16     := MMIO.Write'Access;
      PL011_Descriptor.Base_Address := To_Address (PL011_UART0_BASEADDRESS);
      PL011_Descriptor.Baud_Clock   := CLK_UART14M;
      PL011.Init (PL011_Descriptor);
      -- Console --------------------------------------------------------------
      Console.Console_Descriptor.Write := Console_Putchar'Access;
      Console.Console_Descriptor.Read  := Console_Getchar'Access;
      Console.Print (ANSI_CLS & ANSI_CUPHOME & VT100_LINEWRAP);
      -------------------------------------------------------------------------
      Console.Print ("AArch64 Cortex-A53 (QEMU emulator)", NL => True);
      Console.Print (Natural (ARMv8A.CurrentEL_Read.EL),     Prefix => "Current EL: ", NL => True);
      Console.Print (ARMv8A.CNTFRQ_EL0_Read.Clock_frequency, Prefix => "CNTFRQ_EL0: ", NL => True);
      -------------------------------------------------------------------------
      if Core.Debug_Flag then
         Console.Print ("Debug_Flag: ENABLED", NL => True);
      end if;
      -------------------------------------------------------------------------
      Timer_Constant :=
         (ARMv8A.CNTFRQ_EL0_Read.Clock_frequency + Configure.TICK_FREQUENCY / 2) /
         Configure.TICK_FREQUENCY;
      Virt.GICD_CTLR.EnableGrp1 := True;
      Virt.GICD_ISENABLER (30)  := True;
      Virt.GICC_CTLR.EnableGrp1 := True;
      Virt.GICC_PMR.Priority    := 16#FF#;
      Timer_Reload;
      ARMv8A.CNTP_CTL_EL0_Write ((
                                  ENABLE  => True,
                                  IMASK   => False,
                                  ISTATUS => False,
                                  others  => <>
                                 ));
      -- handle IRQs at EL3
      if ARMv8A.CurrentEL_Read.EL = 3 then
         declare
            SCR_EL3 : ARMv8A.SCR_EL3_Type;
         begin
            SCR_EL3 := ARMv8A.SCR_EL3_Read;
            SCR_EL3.IRQ := True;
            ARMv8A.SCR_EL3_Write (SCR_EL3);
         end;
      end if;
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
      -------------------------------------------------------------------------
   end Setup;

end BSP;

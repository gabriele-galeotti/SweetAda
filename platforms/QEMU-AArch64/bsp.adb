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
with System.Storage_Elements;
with Interfaces;
with Definitions;
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

   --========================================================================--
   --                                                                        --
   --                                                                        --
   --                           Package subprograms                          --
   --                                                                        --
   --                                                                        --
   --========================================================================--

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
   -- BSP_Setup
   ----------------------------------------------------------------------------
   procedure BSP_Setup is
   begin
      -------------------------------------------------------------------------
      Exceptions.Init;
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
      Console.TTY_Setup;
      -------------------------------------------------------------------------
      Console.Print ("AArch64 Cortex-A53 (QEMU emulator)", NL => True);
      Console.Print (Natural (ARMv8A.CurrentEL_Read.EL),     Prefix => "Current EL: ", NL => True);
      Console.Print (ARMv8A.CNTFRQ_EL0_Read.Clock_frequency, Prefix => "CNTFRQ_EL0: ", NL => True);
      -------------------------------------------------------------------------
      Virt.GICD_CTLR.EnableGrp1 := True;
      Virt.GICD_ISENABLER (30)  := True;
      Virt.GICC_CTLR.EnableGrp1 := True;
      Virt.GICC_PMR.Priority    := 16#FF#;
      Virt.Timer_Reload;
      ARMv8A.CNTP_CTL_EL0_Write ((
                                  ENABLE  => True,
                                  IMASK   => False,
                                  ISTATUS => False,
                                  others  => <>
                                 ));
      ARMv8A.Irq_Enable;
      -------------------------------------------------------------------------
   end BSP_Setup;

end BSP;

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

with System.Storage_Elements;
with Interfaces;
with Bits;
with RISCV;
with CPU;
with HiFive1;
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

   use System.Storage_Elements;
   use Interfaces;
   use Bits;

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
      HiFive1.UART0.txdata.txdata := To_U8 (C);
      for Delay_Loop_Count in 1 .. 10_000 loop CPU.NOP; end loop;
   end Console_Putchar;

   procedure Console_Getchar (C : out Character) is
   begin
      C := Character'Val (0);
   end Console_Getchar;

   ----------------------------------------------------------------------------
   -- BSP_Setup
   ----------------------------------------------------------------------------
   procedure BSP_Setup is
   begin
      -- Clock ----------------------------------------------------------------
      HiFive1.PRCI.pllcfg    := 16#0007_0000#;
      HiFive1.PRCI.hfrosccfg := 16#0010_0004#;
      -- UARTs ----------------------------------------------------------------
      HiFive1.GPIO_IOFSEL := @ and 16#FF78_FFFF#;
      HiFive1.GPIO_IOFEN  := @ or 16#0087_0000#;
      HiFive1.GPIO_OEN    := @ or 16#0087_0000#;
      HiFive1.UART0.div          := 16#89#; -- 115200 bps @ 16 MHz
      HiFive1.UART0.txctrl.txen  := True;
      HiFive1.UART0.txctrl.nstop := 0;
      HiFive1.UART0.txctrl.txcnt := 1;
      HiFive1.UART1.div          := 16#89#; -- 115200 bps @ 16 MHz
      HiFive1.UART1.txctrl.txen  := True;
      HiFive1.UART1.txctrl.nstop := 0;
      HiFive1.UART1.txctrl.txcnt := 1;
      -- Console --------------------------------------------------------------
      Console.Console_Descriptor.Write := Console_Putchar'Access;
      Console.Console_Descriptor.Read  := Console_Getchar'Access;
      Console.TTY_Setup;
      -------------------------------------------------------------------------
      Console.Print ("SiFive HiFive 1", NL => True);
      -------------------------------------------------------------------------
      Exceptions.Init;
      -------------------------------------------------------------------------
      declare
         Vectors      : aliased Asm_Entry_Point with
            Import        => True,
            Convention    => Asm,
            External_Name => "vectors";
         Base_Address : Bits_26;
      begin
         Base_Address := Bits_26 (Shift_Right (Unsigned_32 (To_Integer (Vectors'Address)) and 16#FFFF_FFFC#, 6));
         RISCV.MTVEC_Write ((MODE => RISCV.MODE_Direct, Reserved => 0, BASE => Base_Address));
      end;
      RISCV.Irq_Enable;
      RISCV.MTimeCmp := RISCV.MTime + 16#3200#;
      -------------------------------------------------------------------------
   end BSP_Setup;

end BSP;

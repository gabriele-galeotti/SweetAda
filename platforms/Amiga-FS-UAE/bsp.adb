-----------------------------------------------------------------------------------------------------------------------
--                                                     SweetAda                                                      --
-----------------------------------------------------------------------------------------------------------------------
-- __HDS__                                                                                                           --
-- __FLN__ bsp.adb                                                                                                   --
-- __DSC__                                                                                                           --
-- __HSH__ e69de29bb2d1d6434b8b29ae775ad8c2e48c5391                                                                  --
-- __HDE__                                                                                                           --
-----------------------------------------------------------------------------------------------------------------------
-- Copyright (C) 2020, 2021 Gabriele Galeotti                                                                        --
--                                                                                                                   --
-- SweetAda web page: http://sweetada.org                                                                            --
-- contact address: gabriele.galeotti@sweetada.org                                                                   --
-- This work is licensed under the terms of the MIT License.                                                         --
-- Please consult the LICENSE.txt file located in the top-level directory.                                           --
-----------------------------------------------------------------------------------------------------------------------

with System;
with System.Storage_Elements;
with Interfaces;
with Configure;
with Core;
with Bits;
with MMIO;
with M68k;
with Amiga;
with A2091;
with A2065;
with Gayle;
with Exceptions;
with Linker;
with Gdbstub;
with Gdbstub.SerialComm;
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
   use Core;
   use Bits;
   use M68k;
   use Amiga;

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
      UARTIOEMU.TX (UART1_Descriptor, To_U8 (C));
   end Console_Putchar;

   procedure Console_Getchar (C : out Character) is
      Data : Unsigned_8;
   begin
      UARTIOEMU.RX (UART1_Descriptor, Data);
      if Data = 0 then
         C := Character'Val (0);
      else
         -- pulse RX LED
         IOEMU_CIA_IO3 := 1;
         IOEMU_CIA_IO3 := 0;
         C := To_Ch (Data);
      end if;
   end Console_Getchar;

   ----------------------------------------------------------------------------
   -- BSP_Setup
   ----------------------------------------------------------------------------
   procedure BSP_Setup is
   begin
      -- exceptions initialization --------------------------------------------
      Exceptions.Init;
      -- basic hardware initialization ----------------------------------------
      OCS_Setup;
      OCS_Clear_Screen;
      OCS_Print (0, 0, KERNEL_NAME & ": initializing");
      OCS_Print (0, 1, "Press mouse-MB to un-grab the pointer.");
      OCS_Print (0, 3, "F12+D to activate the debugger.");
      OCS_Print (0, 2, "Close this window to shutdown the emulator.");
      -- serial port ----------------------------------------------------------
      -- bit    description
      -- 15     defines serial receive as 9 bit word
      -- 14..00 defines baud rate: 1 bit every (N+1)*.2794 us
      -- N+1 = 10E6/(baud_rate*.2794)
      CUSTOM.SERPER := (RATE => 16#0174#, LONG => False);
      -- UARTs ----------------------------------------------------------------
      UART1_Descriptor.Base_Address  := To_Address (IOEMU_CIA_BASEADDRESS + 16#40#);
      UART1_Descriptor.Scale_Address := 2;
      UART1_Descriptor.Irq           := 1; -- enabled if /= 0
      UART1_Descriptor.Read          := MMIO.Read'Access;
      UART1_Descriptor.Write         := MMIO.Write'Access;
      UARTIOEMU.Init (UART1_Descriptor);
      UART2_Descriptor.Base_Address  := To_Address (IOEMU_CIA_BASEADDRESS + 16#60#);
      UART2_Descriptor.Scale_Address := 2;
      UART2_Descriptor.Irq           := 1; -- enabled if /= 0
      UART2_Descriptor.Read          := MMIO.Read'Access;
      UART2_Descriptor.Write         := MMIO.Write'Access;
      UARTIOEMU.Init (UART2_Descriptor);
      -- Console --------------------------------------------------------------
      Console.Console_Descriptor.Write := Console_Putchar'Access;
      Console.Console_Descriptor.Read  := Console_Getchar'Access;
      Console.TTY_Setup;
      -- A2091 ----------------------------------------------------------------
      declare
         Success : Boolean;
      begin
         A2091.Probe (Success);
      end;
      -- Gayle IDE ------------------------------------------------------------
      if False then
         IDE_Descriptor.Base_Address  := To_Address (Gayle.GAYLE_IDE_BASEADDRESS);
         IDE_Descriptor.Scale_Address := 2;
         IDE_Descriptor.Read_8        := MMIO.Read'Access;
         IDE_Descriptor.Write_8       := MMIO.Write'Access;
         IDE_Descriptor.Read_16       := MMIO.ReadA'Access;
         IDE_Descriptor.Write_16      := MMIO.WriteA'Access;
         IDE.Init (IDE_Descriptor);
         -- disable IDE interrupts
         Gayle.IDE_Devcon.IRQDISABLE := True;
      end if;
      -------------------------------------------------------------------------
      Console.Print ("Amiga FS-UAE emulator", NL => True);
      Console.Print (Linker.SText'Address, Prefix => "SText: ", NL => True);
      Console.Print (Linker.SData'Address, Prefix => "SData: ", NL => True);
      Console.Print (Linker.SBss'Address, Prefix => "SBss:  ", NL => True);
      -- system timer initialization ------------------------------------------
      Tclk_Init;
      -- GDB stub -------------------------------------------------------------
      if False then
         Gdbstub.Init (
                       Gdbstub.SerialComm.Getchar'Access,
                       Gdbstub.SerialComm.Putchar'Access,
                       Gdbstub.DEBUG_ERROR
                       -- Gdbstub.DEBUG_COMMAND
                       -- Gdbstub.DEBUG_COMMUNICATION
                       -- Gdbstub.DEBUG_BYPASS
                      );
      end if;
      -------------------------------------------------------------------------
      -- preliminary interrupt setup
      INTENA_ClearAll;
      INTREQ_ClearAll;
      INTENA_SetBitMask (INTEN);
      -- enable CIAA TimerA interrupt
      CIAA_ICR_SetBitMask (1);
      INTENA_SetBitMask (PORTS);
      -- enable IOEMU serial port interrupts
      INTENA_SetBitMask (EXTER);
      -- enable CPU interrupts
      Irq_Enable;
      -------------------------------------------------------------------------
   end BSP_Setup;

end BSP;

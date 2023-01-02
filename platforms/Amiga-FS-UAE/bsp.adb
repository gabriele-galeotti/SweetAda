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
with Configure;
with Core;
with Bits;
with MMIO;
with M68k;
with Amiga;
with ZorroII;
with A2065;
with Gayle;
with IOEMU;
with Exceptions;
with Linker;
with Gdbstub;
with Gdbstub.SerialComm;
with Console;

with MMU;

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
         -- RX LED blinking
         IOEMU.IOEMU_CIA_IO3 := 1;
         IOEMU.IOEMU_CIA_IO3 := 0;
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
      -- Serialport -----------------------------------------------------------
      Serialport_Init;
      -- IOEMU UARTs ----------------------------------------------------------
      if True then
         UART1_Descriptor.Base_Address  := To_Address (IOEMU.IOEMU_CIA_BASEADDRESS + 16#40#);
         UART1_Descriptor.Scale_Address := 2;
         UART1_Descriptor.Irq           := 1; -- enabled if /= 0
         UART1_Descriptor.Read          := MMIO.Read'Access;
         UART1_Descriptor.Write         := MMIO.Write'Access;
         UARTIOEMU.Init (UART1_Descriptor);
         UART2_Descriptor.Base_Address  := To_Address (IOEMU.IOEMU_CIA_BASEADDRESS + 16#60#);
         UART2_Descriptor.Scale_Address := 2;
         UART2_Descriptor.Irq           := 1; -- enabled if /= 0
         UART2_Descriptor.Read          := MMIO.Read'Access;
         UART2_Descriptor.Write         := MMIO.Write'Access;
         UARTIOEMU.Init (UART2_Descriptor);
      end if;
      -- Console --------------------------------------------------------------
      Console.Console_Descriptor.Write := Console_Putchar'Access;
      Console.Console_Descriptor.Read  := Console_Getchar'Access;
      Console.TTY_Setup;
      -------------------------------------------------------------------------
      -- Console.Print ("Amiga", NL => True);
      -- Console.Print (Linker.SText'Address, Prefix => "SText: ", NL => True);
      -- Console.Print (Linker.SData'Address, Prefix => "SData: ", NL => True);
      -- Console.Print (Linker.SBss'Address, Prefix => "SBss:  ", NL => True);
      -------------------------------------------------------------------------
      if True then
         declare
            Success : Boolean;
            PIC     : ZorroII.PIC_Type;
         begin
            loop
               PIC := ZorroII.Read;
               if PIC.Board /= 0 then
                  Console.Print (PIC.Board,           Prefix => "Board: ", NL => True);
                  Console.Print (PIC.ID_Product,      Prefix => "ID:    ", NL => True);
                  Console.Print (PIC.ID_Manufacturer, Prefix => "Manu:  ", NL => True);
                  if (PIC.Board and 16#F8#) = 16#E0# then
                     -- A2630 "FS-UAE hackers_id" E7 51 07DB
                     ZorroII.Setup (16#0020_0000#);
                  end if;
                  if PIC.Board = 16#C1# then
                     -- A2065 C1 70 0202
                     ZorroII.Setup (16#00EA_0000#);
                     A2065.Probe (PIC, Success);
                     exit;
                  end if;
               else
                  exit;
               end if;
            end loop;
         end;
      end if;
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
      MMU.Init;
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

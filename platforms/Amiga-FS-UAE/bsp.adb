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
with Definitions;
with Core;
with Bits;
with MMIO;
with M68k;
with Amiga;
with ZorroII;
with A2065;
with Gayle;
with MMU;
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
      Serialport_TX (C);
   end Console_Putchar;

   procedure Console_Getchar (C : out Character) is
   begin
      Serialport_RX (C);
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
      OCS_Print (KERNEL_NAME & ": initializing" & CRLF);
      OCS_Print ("Press mouse-MB to un-grab the pointer." & CRLF);
      OCS_Print ("F12+D to activate the debugger." & CRLF);
      OCS_Print ("Close this window to shutdown the emulator." & CRLF);
      -- Serialport -----------------------------------------------------------
      Serialport_Init;
      -- Console --------------------------------------------------------------
      Console.Console_Descriptor.Write := Console_Putchar'Access;
      Console.Console_Descriptor.Read  := Console_Getchar'Access;
      Console.TTY_Setup;
      -------------------------------------------------------------------------
      Console.Print ("Amiga/FS-UAE", NL => True);
      -------------------------------------------------------------------------
      if True then
         declare
            Success : Boolean;
            PIC     : ZorroII.PIC_Type;
         begin
            Console.Print ("Zorro II scan:", NL => True);
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
      MMU.Init;
      -- preliminary interrupt setup
      INTENA_ClearAll;
      INTREQ_ClearAll;
      INTENA_SetBitMask (INTEN);
      -- enable CIAA TimerA interrupt
      CIAA_ICR_SetBitMask (1);
      INTENA_SetBitMask (PORTS);
      -- enable CPU interrupts
      Irq_Enable;
      -------------------------------------------------------------------------
   end BSP_Setup;

end BSP;

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
with M68k;
with Amiga;
with ZorroII;
with A2065;
with Gayle;
with MMU.Amiga;
with Exceptions;
with Console;
with Malloc;

package body BSP is

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

   procedure Console_Putchar
      (C : in Character)
      is
   begin
      Serialport_TX (C);
   end Console_Putchar;

   procedure Console_Getchar
      (C : out Character)
      is
   begin
      Serialport_RX (C);
   end Console_Getchar;

   ----------------------------------------------------------------------------
   -- Setup
   ----------------------------------------------------------------------------
   procedure Setup
      is
   begin
      -------------------------------------------------------------------------
      Secondary_Stack.Init;
      -- exceptions initialization --------------------------------------------
      Exceptions.Init;
      -- basic hardware initialization ----------------------------------------
      OCS_Setup;
      OCS_Print (Core.KERNEL_NAME & ": initializing" & CRLF);
      OCS_Print ("Press mouse-MB to un-grab the pointer." & CRLF);
      OCS_Print ("F12+D to activate the debugger." & CRLF);
      OCS_Print ("Close this window to shutdown the emulator." & CRLF);
      MMU.Amiga.Setup;
      -- Serialport -----------------------------------------------------------
      Serialport_Init;
      -- Console --------------------------------------------------------------
      Console.Console_Descriptor := (
         Write => Console_Putchar'Access,
         Read  => Console_Getchar'Access
         );
      Console.Print (ANSI_CLS & ANSI_CUPHOME & VT100_LINEWRAP);
      -------------------------------------------------------------------------
      Console.Print ("Amiga/FS-UAE", NL => True);
      -- A2065 ----------------------------------------------------------------
      if False then
         declare
            Success : Boolean;
            PIC     : ZorroII.PIC_Type;
         begin
            loop
               PIC := ZorroII.Read;
               exit when PIC.Board = 0;
               Console.Print (Prefix => "Board:   ", Value => PIC.Board, NL => True);
               Console.Print (Prefix => "ID_Prod: ", Value => PIC.ID_Product, NL => True);
               Console.Print (Prefix => "ID_Manu: ", Value => PIC.ID_Manufacturer, NL => True);
               Console.Print (Prefix => "S/N:     ", Value => PIC.Serial_Number, NL => True);
               Console.Print (Prefix => "CTRL:    ", Value => PIC.Control_Status, NL => True);
               ZorroII.Setup (16#00E9_0000#);
               ZorroII.Shutup;
            end loop;
         end;
      end if;
      -- if False then
      --    declare
      --       Success : Boolean;
      --       PIC     : ZorroII.PIC_Type;
      --    begin
      --       ZorroII.Setup (A2065.A2065_BASEADDRESS);
      --       A2065.Probe (PIC, Success);
      --    end;
      -- end if;
      -- Gayle IDE ------------------------------------------------------------
      if False then
         IDE_Descriptor := (
            Base_Address  => System'To_Address (Gayle.IDE_BASEADDRESS),
            Scale_Address => 2,
            Read_8        => MMIO.Read'Access,
            Write_8       => MMIO.Write'Access,
            Read_16       => MMIO.ReadA'Access,
            Write_16      => MMIO.WriteA'Access
            );
         IDE.Init (IDE_Descriptor);
         -- disable IDE interrupts
         Gayle.IDE_Devcon.IRQDISABLE := True;
      end if;
      -- system timer initialization ------------------------------------------
      Tclk_Init;
      -- interrupt setup ------------------------------------------------------
      INTENA_ClearAll;
      INTREQ_ClearAll;
      INTENA_SetBitMask (INTEN);
      -- enable CIAA TimerA interrupt
      CIAA_ICR_SetBitMask (1);
      INTENA_SetBitMask (PORTS);
      -- enable CPU interrupts
      Irq_Enable;
      -------------------------------------------------------------------------
      Malloc.Init (
         Memory_Address => System'To_Address (16#000C_0000#),
         Size           => KiB64,
         Debug_Flag     => True
         );
      -------------------------------------------------------------------------
   end Setup;

end BSP;

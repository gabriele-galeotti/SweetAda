-----------------------------------------------------------------------------------------------------------------------
--                                                     SweetAda                                                      --
-----------------------------------------------------------------------------------------------------------------------
-- __HDS__                                                                                                           --
-- __FLN__ bsp.adb                                                                                                   --
-- __DSC__                                                                                                           --
-- __HSH__ e69de29bb2d1d6434b8b29ae775ad8c2e48c5391                                                                  --
-- __HDE__                                                                                                           --
-----------------------------------------------------------------------------------------------------------------------
-- Copyright (C) 2020-2024 Gabriele Galeotti                                                                         --
--                                                                                                                   --
-- SweetAda web page: http://sweetada.org                                                                            --
-- contact address: gabriele.galeotti@sweetada.org                                                                   --
-- This work is licensed under the terms of the MIT License.                                                         --
-- Please consult the LICENSE.txt file located in the top-level directory.                                           --
-----------------------------------------------------------------------------------------------------------------------

with System;
with System.Machine_Code;
with System.Parameters;
with System.Secondary_Stack;
with System.Storage_Elements;
with Ada.Unchecked_Conversion;
with Definitions;
with Configure;
with Core;
with MMIO;
with SPARC;
with Sun4m;
with Exceptions;
with Console;
with CPU;

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
   use System.Machine_Code;
   use System.Storage_Elements;
   use Interfaces;
   use Definitions;
   use Bits;
   use Sun4m;

   BSP_SS_Stack : System.Secondary_Stack.SS_Stack_Ptr;

   function Get_Sec_Stack
      return System.Secondary_Stack.SS_Stack_Ptr
      with Export        => True,
           Convention    => C,
           External_Name => "__gnat_get_secondary_stack";

   function QEMU_Detect
      return Boolean;

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
   function Get_Sec_Stack
      return System.Secondary_Stack.SS_Stack_Ptr
      is
   begin
      return BSP_SS_Stack;
   end Get_Sec_Stack;

   ----------------------------------------------------------------------------
   -- Check if we are running under QEMU.
   -- QEMU creates a configuration signature @ 0x2D00000510.
   ----------------------------------------------------------------------------
   function QEMU_Detect
      return Boolean
      is
      Result : Unsigned_32;
   begin
      Asm (
           Template => ""                                        & CRLF &
                       "        .equ    CFG_ADDR,0x00000510    " & CRLF &
                       "        .equ    CFG_ASI,0x2D           " & CRLF &
                       "        .equ    FW_CFG_SIGNATURE,0x0000" & CRLF &
                       "        clr     %0                     " & CRLF &
                       "        mov     FW_CFG_SIGNATURE,%%g1  " & CRLF &
                       "        set     CFG_ADDR,%%g2          " & CRLF &
                       "        stha    %%g1,[%%g2]CFG_ASI     " & CRLF &
                       "        add     %%g2,2,%%g2            " & CRLF &
                       "        lduba   [%%g2]CFG_ASI,%%g1     " & CRLF &
                       "        cmp     %%g1,'Q'               " & CRLF &
                       "        bne     1f                     " & CRLF &
                       "        nop                            " & CRLF &
                       "        lduba   [%%g2]CFG_ASI,%%g1     " & CRLF &
                       "        cmp     %%g1,'E'               " & CRLF &
                       "        bne     1f                     " & CRLF &
                       "        nop                            " & CRLF &
                       "        lduba   [%%g2]CFG_ASI,%%g1     " & CRLF &
                       "        cmp     %%g1,'M'               " & CRLF &
                       "        bne     1f                     " & CRLF &
                       "        nop                            " & CRLF &
                       "        lduba   [%%g2]CFG_ASI,%%g1     " & CRLF &
                       "        cmp     %%g1,'U'               " & CRLF &
                       "        bne     1f                     " & CRLF &
                       "        nop                            " & CRLF &
                       "        or      %0,1,%0                " & CRLF &
                       "1:                                     " & CRLF &
                       "",
           Outputs  => Unsigned_32'Asm_Output ("=r", Result),
           Inputs   => No_Input_Operands,
           Clobber  => "g1,g2,icc",
           Volatile => True
          );
      return Result /= 0;
   end QEMU_Detect;

   ----------------------------------------------------------------------------
   -- Console wrappers
   ----------------------------------------------------------------------------

   -- serial port "A"

   procedure Console_Putchar
      (C : in Character)
      is
   begin
      Z8530.TX (SCC_Descriptor, Z8530.CHANNELA, To_U8 (C));
   end Console_Putchar;

   procedure Console_Getchar
      (C : out Character)
      is
      Data : Unsigned_8;
   begin
      Z8530.RX (SCC_Descriptor, Z8530.CHANNELA, Data);
      C := To_Ch (Data);
   end Console_Getchar;

   ----------------------------------------------------------------------------
   -- Setup
   ----------------------------------------------------------------------------
   procedure Setup
      is
   begin
      -------------------------------------------------------------------------
      System.Secondary_Stack.SS_Init (BSP_SS_Stack, System.Parameters.Unspecified_Size);
      -------------------------------------------------------------------------
      -- Exceptions.Init;
      -- SPARC.TBR_Set (To_Address (0));
      -- SCC ------------------------------------------------------------------
      SCC_Descriptor.Base_Address   := To_Address (SCC_BASEADDRESS);
      SCC_Descriptor.AB_Address_Bit := 2;
      SCC_Descriptor.CD_Address_Bit := 1;
      SCC_Descriptor.Baud_Clock     := 4_915_200;
      SCC_Descriptor.Read_8         := MMIO.Read'Access;
      SCC_Descriptor.Write_8        := MMIO.Write'Access;
      Z8530.Init (SCC_Descriptor, Z8530.CHANNELA);
      Z8530.Init (SCC_Descriptor, Z8530.CHANNELB);
      Z8530.Baud_Rate_Set (SCC_Descriptor, Z8530.CHANNELA, BR_9600);
      Z8530.Baud_Rate_Set (SCC_Descriptor, Z8530.CHANNELB, BR_9600);
      -- Console --------------------------------------------------------------
      Console.Console_Descriptor.Write := Console_Putchar'Access;
      Console.Console_Descriptor.Read := Console_Getchar'Access;
      Console.Print (ANSI_CLS & ANSI_CUPHOME & VT100_LINEWRAP);
      -------------------------------------------------------------------------
      Console.Print ("SPARCstation 5", NL => True);
      -------------------------------------------------------------------------
      if Core.Debug_Flag then
         Console.Print ("Debug_Flag: ENABLED", NL => True);
      end if;
      -------------------------------------------------------------------------
      Console.Print (Natural (Nwindows),       Prefix => "Nwindows:         ", NL => True);
      Console.Print (DMA2_INTERNAL_IDREGISTER, Prefix => "DMA2 ID Register: ", NL => True);
      if Configure.USE_QEMU then
         QEMU := QEMU_Detect;
         Console.Print (QEMU,                     Prefix => "QEMU:             ", NL => True);
      end if;
      -- Am7990 ---------------------------------------------------------------
      Am7990_Descriptor.Base_Address  := To_Address (ETHERNET_CONTROLLER_REGISTERS_BASEADDRESS);
      Am7990_Descriptor.Scale_Address := 0;
      Am7990_Descriptor.Read_16       := MMIO.ReadA'Access;
      Am7990_Descriptor.Write_16      := MMIO.WriteA'Access;
      -------------------------------------------------------------------------
      SITMS := (
         SBusIrq => 0,
         K       => False,
         S       => True,  -- serial port
         E       => False,
         SC      => False,
         T       => True,  -- timer
         V       => False,
         F       => False,
         M       => False,
         I       => False,
         ME      => False,
         MA      => True,
         others  => <>
         );
      SPARC.Irq_Enable;
      Tclk_Init;
      -------------------------------------------------------------------------
   end Setup;

end BSP;

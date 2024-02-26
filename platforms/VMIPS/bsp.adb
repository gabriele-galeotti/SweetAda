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

with System.Parameters;
with System.Secondary_Stack;
with System.Storage_Elements;
with Ada.Unchecked_Conversion;
with Definitions;
with Bits;
with MIPS;
with R3000;
with VMIPS;
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

   use System.Storage_Elements;
   use Interfaces;
   use Definitions;
   use Bits;

   BSP_SS_Stack : System.Secondary_Stack.SS_Stack_Ptr;

   function Get_Sec_Stack
      return System.Secondary_Stack.SS_Stack_Ptr
      with Export        => True,
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
   function Get_Sec_Stack
      return System.Secondary_Stack.SS_Stack_Ptr
      is
   begin
      return BSP_SS_Stack;
   end Get_Sec_Stack;

   ----------------------------------------------------------------------------
   -- Console wrappers
   ----------------------------------------------------------------------------

   procedure Console_Putchar
      (C : in Character)
      is
   begin
      -- wait for transmitter available
      loop
         exit when VMIPS.SPIMCONSOLE.DISPLAY1_CONTROL.CTL_RDY;
      end loop;
      VMIPS.SPIMCONSOLE.DISPLAY1_DATA.DATA := To_U8 (C);
   end Console_Putchar;

   procedure Console_Getchar
      (C : out Character)
      is
      Data : Unsigned_8;
   begin
      -- wait for receiver available
      loop
         exit when VMIPS.SPIMCONSOLE.KEYBOARD1_CONTROL.CTL_RDY;
      end loop;
      Data := VMIPS.SPIMCONSOLE.KEYBOARD1_DATA.DATA;
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
      Exceptions.Init;
      -- Console --------------------------------------------------------------
      Console.Console_Descriptor.Write := Console_Putchar'Access;
      Console.Console_Descriptor.Read := Console_Getchar'Access;
      -- Console.Print (ANSI_CLS & ANSI_CUPHOME & VT100_LINEWRAP);
      -------------------------------------------------------------------------
      Console.Print ("VMIPS", NL => True);
      -------------------------------------------------------------------------
      declare
         PRId : R3000.PRId_Type;
      begin
         PRId := R3000.CP0_PRId_Read;
         Console.Print ("PRId: ", NL => False);
         Console.Print (PRId.Imp, NL => False);
         Console.Print (".", NL => False);
         Console.Print (PRId.Rev, NL => False);
         Console.Print_NewLine;
         case PRId.Imp is
            -- some datasheets indicate "3" as the value for an R3000A
            when 2      => Console.Print ("R3000A", NL => True);
            when 3      => Console.Print ("R3000A/R3051/R3052/R3071/R3081", NL => True);
            when 7      => Console.Print ("R3041", NL => True);
            when others => Console.Print ("CPU unknown", NL => True);
         end case;
      end;
      -------------------------------------------------------------------------
      declare
         S : R3000.Status_Type;
      begin
         S := R3000.CP0_SR_Read;
         S.IM2 := True; -- SPIM Clock
         R3000.CP0_SR_Write (S);
      end;
      VMIPS.SPIMCLOCK.CTL_IE := True;
      R3000.Irq_Enable;
      -------------------------------------------------------------------------
   end Setup;

end BSP;

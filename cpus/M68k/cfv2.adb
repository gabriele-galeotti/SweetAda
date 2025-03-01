-----------------------------------------------------------------------------------------------------------------------
--                                                     SweetAda                                                      --
-----------------------------------------------------------------------------------------------------------------------
-- __HDS__                                                                                                           --
-- __FLN__ cfv2.adb                                                                                                  --
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

with System.Machine_Code;
with Definitions;

package body CFv2
   is

   --========================================================================--
   --                                                                        --
   --                                                                        --
   --                           Local declarations                           --
   --                                                                        --
   --                                                                        --
   --========================================================================--

   use System.Machine_Code;

   CRLF : String renames Definitions.CRLF;

   --========================================================================--
   --                                                                        --
   --                                                                        --
   --                           Package subprograms                          --
   --                                                                        --
   --                                                                        --
   --========================================================================--

   ----------------------------------------------------------------------------
   -- NOP
   ----------------------------------------------------------------------------
   procedure NOP
      is
   begin
      Asm (
           Template => ""            & CRLF &
                       "        nop" & CRLF &
                       "",
           Outputs  => No_Output_Operands,
           Inputs   => No_Input_Operands,
           Clobber  => "",
           Volatile => True
          );
   end NOP;

   ----------------------------------------------------------------------------
   -- PAUSE
   ----------------------------------------------------------------------------
   procedure PAUSE
      is
   begin
      Asm (
           Template => ""                        & CRLF &
                       "        stop    #0x2000" & CRLF &
                       "",
           Outputs  => No_Output_Operands,
           Inputs   => No_Input_Operands,
           Clobber  => "",
           Volatile => True
          );
   end PAUSE;

   ----------------------------------------------------------------------------
   -- BREAKPOINT
   ----------------------------------------------------------------------------
   procedure BREAKPOINT
      is
   begin
      Asm (
           Template => ""                   & CRLF &
                       "        trap    #1" & CRLF &
                       "",
           Outputs  => No_Output_Operands,
           Inputs   => No_Input_Operands,
           Clobber  => "",
           Volatile => True
          );
   end BREAKPOINT;

   ----------------------------------------------------------------------------
   -- VBR_Set
   ----------------------------------------------------------------------------
   procedure VBR_Set
      (VBR_Address : in Address)
      is
   begin
      Asm (
           Template => ""                         & CRLF &
                       "        movec   %0,%%vbr" & CRLF &
                       "",
           Outputs  => No_Output_Operands,
           Inputs   => System.Address'Asm_Input ("d", VBR_Address),
           Clobber  => "",
           Volatile => True
          );
   end VBR_Set;

   ----------------------------------------------------------------------------
   -- Irq_Enable
   ----------------------------------------------------------------------------
   procedure Irq_Enable
      is
   begin
      Asm (
           Template => ""                          & CRLF &
                       "        move    %%sr,%%d0" & CRLF &
                       "        andi.l  %0,%%d0  " & CRLF &
                       "        move    %%d0,%%sr" & CRLF &
                       "",
           Outputs  => No_Output_Operands,
           Inputs   => Integer'Asm_Input ("i", 16#F8FF#),
           Clobber  => "cc,d0,memory",
           Volatile => True
          );
   end Irq_Enable;

   ----------------------------------------------------------------------------
   -- Irq_Disable
   ----------------------------------------------------------------------------
   procedure Irq_Disable
      is
   begin
      Asm (
           Template => ""                          & CRLF &
                       "        move    %%sr,%%d0" & CRLF &
                       "        ori.l   %0,%%d0  " & CRLF &
                       "        move    %%d0,%%sr" & CRLF &
                       "",
           Outputs  => No_Output_Operands,
           Inputs   => Integer'Asm_Input ("i", 16#0700#),
           Clobber  => "cc,d0,memory",
           Volatile => True
          );
   end Irq_Disable;

end CFv2;

-----------------------------------------------------------------------------------------------------------------------
--                                                     SweetAda                                                      --
-----------------------------------------------------------------------------------------------------------------------
-- __HDS__                                                                                                           --
-- __FLN__ exceptions.adb                                                                                            --
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

with Interfaces;
with Abort_Library;
with Bits;
with LLutils;
with RISCV;
with MTIME;
with BSP;
with Console;

package body Exceptions
   is

   --========================================================================--
   --                                                                        --
   --                                                                        --
   --                           Local declarations                           --
   --                                                                        --
   --                                                                        --
   --========================================================================--

   use Interfaces;
   use Bits;
   use RISCV;

   --========================================================================--
   --                                                                        --
   --                                                                        --
   --                           Package subprograms                          --
   --                                                                        --
   --                                                                        --
   --========================================================================--

   ----------------------------------------------------------------------------
   -- Exception_Process
   ----------------------------------------------------------------------------
   procedure Exception_Process
      is
      mcause : mcause_Type;
   begin
      mcause := mcause_Read;
      if mcause.Interrupt then
         case mcause.Exception_Code is
            when EXC_TIMERINT =>
               -- Machine timer interrupt
               BSP.Tick_Count := @ + 1;
               BSP.Timer_Value := @ + BSP.Timer_Constant;
               MTIME.mtimecmp_Write (BSP.Timer_Value);
            when EXC_SWINT    =>
               -- Machine software interrupt
               null;
            when EXC_EXTINT   =>
               -- Machine external interrupt
               null;
            when others       =>
               Console.Print (MXLEN_Type (mcause.Exception_Code), Prefix => "*** EXCEPTION #", NL => True);
               Abort_Library.System_Abort;
         end case;
      else
         declare
            MsgPtr : access constant String;
         begin
            case mcause.Exception_Code is
               when EXC_INSTRADDRMIS  => MsgPtr := MsgPtr_EXC_INSTRADDRMIS;
               when EXC_INSTRACCFAULT => MsgPtr := MsgPtr_EXC_INSTRACCFAULT;
               when EXC_INSTRILL      => MsgPtr := MsgPtr_EXC_INSTRILL;
               when EXC_BREAKPT       => MsgPtr := MsgPtr_EXC_BREAKPT;
               when EXC_LOADADDRMIS   => MsgPtr := MsgPtr_EXC_LOADADDRMIS;
               when EXC_LOADACCFAULT  => MsgPtr := MsgPtr_EXC_LOADACCFAULT;
               when EXC_STAMOADDRMIS  => MsgPtr := MsgPtr_EXC_STAMOADDRMIS;
               when EXC_STAMOACCFAULT => MsgPtr := MsgPtr_EXC_STAMOACCFAULT;
               when EXC_ENVCALLUMODE  => MsgPtr := MsgPtr_EXC_ENVCALLUMODE;
               when EXC_ENVCALLMMODE  => MsgPtr := MsgPtr_EXC_ENVCALLMMODE;
               when others            => MsgPtr := MsgPtr_EXC_UNKNOWN;
            end case;
            Console.Print (MXLEN_Type (mcause.Exception_Code), Prefix => "*** EXCEPTION #", NL => True);
            Console.Print (MsgPtr.all, NL => True);
            Console.Print (mepc_Read, Prefix => "MEPC: ", NL => True);
            Abort_Library.System_Abort;
         end;
      end if;
   end Exception_Process;

   ----------------------------------------------------------------------------
   -- Init
   ----------------------------------------------------------------------------
   procedure Init
      is
      Vectors : aliased Asm_Entry_Point
         with Import        => True,
              External_Name => "vectors";
   begin
      mtvec_Write ((
         MODE => MODE_Vectored,
         BASE => mtvec_BASE_Type (LLutils.Select_Address_Bits (
                    Vectors'Address,
                    mtvec_BASE_ADDRESS_LSB,
                    mtvec_BASE_ADDRESS_MSB
                    ))
         ));
   end Init;

end Exceptions;

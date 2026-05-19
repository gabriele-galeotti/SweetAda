-----------------------------------------------------------------------------------------------------------------------
--                                                     SweetAda                                                      --
-----------------------------------------------------------------------------------------------------------------------
-- __HDS__                                                                                                           --
-- __FLN__ exceptions.adb                                                                                            --
-- __DSC__                                                                                                           --
-- __HSH__ e69de29bb2d1d6434b8b29ae775ad8c2e48c5391                                                                  --
-- __HDE__                                                                                                           --
-----------------------------------------------------------------------------------------------------------------------
-- Copyright (C) 2020-2026 Gabriele Galeotti                                                                         --
--                                                                                                                   --
-- SweetAda web page: http://sweetada.org                                                                            --
-- contact address: gabriele.galeotti@sweetada.org                                                                   --
-- This work is licensed under the terms of the MIT License.                                                         --
-- Please consult the LICENSE.txt file located in the top-level directory.                                           --
-----------------------------------------------------------------------------------------------------------------------

with System.Machine_Code;
with System.Storage_Elements;
with Interfaces;
with Definitions;
with Linker;
with ML605;
with BSP;

package body Exceptions
   is

   --========================================================================--
   --                                                                        --
   --                                                                        --
   --                           Local declarations                           --
   --                                                                        --
   --                                                                        --
   --========================================================================--

   use System.Machine_Code;
   use Interfaces;
   use ML605;

   package SSE renames System.Storage_Elements;

   CRLF : String renames Definitions.CRLF;

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
   begin
      BSP.Tick_Count := @ + 1;
      Timer.TCSR0.T0INT := False; -- clear Timer flag
      INTC.IAR (TIMER_IRQ) := True; -- clear INTC flag
   end Exception_Process;

   ----------------------------------------------------------------------------
   -- Init
   ----------------------------------------------------------------------------
   procedure Init
      is
   begin
      -- Memory_Functions.Cpymem (
      --   SSE.To_Address (Linker.Vectors_EText), -- .vectors section
      --   SSE.To_Address (0),                    -- LMB RAM @ 0
      --   256
      --   );
      Asm (
           Template => ""                         & CRLF &
                       "        beqid   %2,$L2  " & CRLF &
                       "        addk    r4,r0,r0" & CRLF &
                       "$L1:                    " & CRLF &
                       "        lbu     r5,r4,%0" & CRLF &
                       "        sb      r5,r4,%1" & CRLF &
                       "        addik   r4,r4,1 " & CRLF &
                       "        xor     r8,r4,%2" & CRLF &
                       "        bnei    r8,$L1  " & CRLF &
                       "$L2:                    " & CRLF &
                       "        nop             " & CRLF &
                       "",
           Outputs  => No_Output_Operands,
           Inputs   => [
                        System.Address'Asm_Input ("r", SSE.To_Address (Linker.Vectors_EText)),
                        System.Address'Asm_Input ("r", SSE.To_Address (0)),
                        Unsigned_32'Asm_Input ("r", 256)
                       ],
           Clobber  => "r4,r5,r8",
           Volatile => True
          );
   end Init;

end Exceptions;

-----------------------------------------------------------------------------------------------------------------------
--                                                     SweetAda                                                      --
-----------------------------------------------------------------------------------------------------------------------
-- __HDS__                                                                                                           --
-- __FLN__ exceptions.ads                                                                                            --
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

with Interfaces;
with Bits;

package Exceptions
   is

   --========================================================================--
   --                                                                        --
   --                                                                        --
   --                               Public part                              --
   --                                                                        --
   --                                                                        --
   --========================================================================--

   use Interfaces;
   use Bits;

   SP_Main      : aliased Asm_Entry_Point with Import => True, External_Name => "SP_Main";
   Reset        : aliased Asm_Entry_Point with Import => True, External_Name => "Reset";
   NMI          : aliased Asm_Entry_Point with Import => True, External_Name => "NMI";
   HardFault    : aliased Asm_Entry_Point with Import => True, External_Name => "HardFault";
   MemManage    : aliased Asm_Entry_Point with Import => True, External_Name => "MemManage";
   BusFault     : aliased Asm_Entry_Point with Import => True, External_Name => "BusFault";
   UsageFault   : aliased Asm_Entry_Point with Import => True, External_Name => "UsageFault";
   ReservedExc7 : aliased Asm_Entry_Point with Import => True, External_Name => "ReservedExc7";
   ReservedExc8 : aliased Asm_Entry_Point with Import => True, External_Name => "ReservedExc8";
   ReservedExc9 : aliased Asm_Entry_Point with Import => True, External_Name => "ReservedExc9";
   ReservedExcA : aliased Asm_Entry_Point with Import => True, External_Name => "ReservedExcA";
   SVCall       : aliased Asm_Entry_Point with Import => True, External_Name => "SVCall";
   DebugMonitor : aliased Asm_Entry_Point with Import => True, External_Name => "DebugMonitor";
   ReservedExcD : aliased Asm_Entry_Point with Import => True, External_Name => "ReservedExcD";
   PendSV       : aliased Asm_Entry_Point with Import => True, External_Name => "PendSV";
   SysTick      : aliased Asm_Entry_Point with Import => True, External_Name => "SysTick";

   procedure Exception_Process
      (VectorN : in Unsigned_32;
       LR      : in Unsigned_32)
      with Export        => True,
           Convention    => Asm,
           External_Name => "exception_process";

   procedure SysTick_Process
      with Export        => True,
           Convention    => Asm,
           External_Name => "systick_process";

   procedure Irq_Process
      with Export        => True,
           Convention    => Asm,
           External_Name => "irq_process";

   procedure Init;

end Exceptions;

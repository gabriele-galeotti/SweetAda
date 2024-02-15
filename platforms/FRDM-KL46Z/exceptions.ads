-----------------------------------------------------------------------------------------------------------------------
--                                                     SweetAda                                                      --
-----------------------------------------------------------------------------------------------------------------------
-- __HDS__                                                                                                           --
-- __FLN__ exceptions.ads                                                                                            --
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

   use Bits;

   SP_Main      : aliased Asm_Entry_Point
      with Import        => True,
           External_Name => "SP_Main";
   Reset        : aliased Asm_Entry_Point
      with Import        => True,
           External_Name => "Reset";
   NMI          : aliased Asm_Entry_Point
      with Import        => True,
           External_Name => "NMI";
   HardFault    : aliased Asm_Entry_Point
      with Import        => True,
           External_Name => "HardFault";
   ReservedExc4 : aliased Asm_Entry_Point
      with Import        => True,
           External_Name => "ReservedExc4";
   ReservedExc5 : aliased Asm_Entry_Point
      with Import        => True,
           External_Name => "ReservedExc5";
   ReservedExc6 : aliased Asm_Entry_Point
      with Import        => True,
           External_Name => "ReservedExc6";
   ReservedExc7 : aliased Asm_Entry_Point
      with Import        => True,
           External_Name => "ReservedExc7";
   ReservedExc8 : aliased Asm_Entry_Point
      with Import        => True,
           External_Name => "ReservedExc8";
   ReservedExc9 : aliased Asm_Entry_Point
      with Import        => True,
           External_Name => "ReservedExc9";
   ReservedExcA : aliased Asm_Entry_Point
      with Import        => True,
           External_Name => "ReservedExcA";
   SVCall       : aliased Asm_Entry_Point
      with Import        => True,
           External_Name => "SVCall";
   ReservedExcC : aliased Asm_Entry_Point
      with Import        => True,
           External_Name => "ReservedExcC";
   ReservedExcD : aliased Asm_Entry_Point
      with Import        => True,
           External_Name => "ReservedExcD";
   PendSV       : aliased Asm_Entry_Point
      with Import        => True,
           External_Name => "PendSV";
   SysTick      : aliased Asm_Entry_Point
      with Import        => True,
           External_Name => "SysTick";

   procedure Exception_Process
      with Export        => True,
           Convention    => Asm,
           External_Name => "exception_process";

   procedure Irq_Process
      with Export        => True,
           Convention    => Asm,
           External_Name => "irq_process";

   procedure Init;

end Exceptions;

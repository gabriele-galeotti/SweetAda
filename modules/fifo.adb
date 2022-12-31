-----------------------------------------------------------------------------------------------------------------------
--                                                     SweetAda                                                      --
-----------------------------------------------------------------------------------------------------------------------
-- __HDS__                                                                                                           --
-- __FLN__ fifo.adb                                                                                                  --
-- __DSC__                                                                                                           --
-- __HSH__ e69de29bb2d1d6434b8b29ae775ad8c2e48c5391                                                                  --
-- __HDE__                                                                                                           --
-----------------------------------------------------------------------------------------------------------------------
-- Copyright (C) 2020, 2021, 2022 Gabriele Galeotti                                                                  --
--                                                                                                                   --
-- SweetAda web page: http://sweetada.org                                                                            --
-- contact address: gabriele.galeotti@sweetada.org                                                                   --
-- This work is licensed under the terms of the MIT License.                                                         --
-- Please consult the LICENSE.txt file located in the top-level directory.                                           --
-----------------------------------------------------------------------------------------------------------------------

with CPU;

package body FIFO is

   --========================================================================--
   --                                                                        --
   --                                                                        --
   --                           Package subprograms                          --
   --                                                                        --
   --                                                                        --
   --========================================================================--

   ----------------------------------------------------------------------------
   -- Put
   ----------------------------------------------------------------------------
   procedure Put (
                  Q       : access Queue_Type;
                  Data    : in     Interfaces.Unsigned_8;
                  Success : out    Boolean
                 ) is
      Irq_State : CPU.Irq_State_Type;
   begin
      Irq_State := CPU.Irq_State_Get;
      CPU.Irq_Disable;
      if Q.all.Count >= QUEUE_SIZE then
         Success := False;
      else
         Q.all.Queue (Natural (Q.all.Head)) := Data;
         Q.all.Head := Q.all.Head + 1;
         Q.all.Count := Q.all.Count + 1;
         Success := True;
      end if;
      CPU.Irq_State_Set (Irq_State);
   end Put;

   ----------------------------------------------------------------------------
   -- Get
   ----------------------------------------------------------------------------
   procedure Get (
                  Q       : access Queue_Type;
                  Data    : out    Interfaces.Unsigned_8;
                  Success : out    Boolean
                 ) is
      Irq_State : CPU.Irq_State_Type;
   begin
      Irq_State := CPU.Irq_State_Get;
      CPU.Irq_Disable;
      if Q.all.Count = 0 then
         Data := 0;
         Success := False;
      else
         Data := Q.all.Queue (Natural (Q.all.Tail));
         Q.all.Tail := Q.all.Tail + 1;
         Q.all.Count := Q.all.Count - 1;
         Success := True;
      end if;
      CPU.Irq_State_Set (Irq_State);
   end Get;

end FIFO;

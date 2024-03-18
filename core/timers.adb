-----------------------------------------------------------------------------------------------------------------------
--                                                     SweetAda                                                      --
-----------------------------------------------------------------------------------------------------------------------
-- __HDS__                                                                                                           --
-- __FLN__ timers.adb                                                                                                --
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

with CPU;

package body Timers
   is

   --========================================================================--
   --                                                                        --
   --                                                                        --
   --                           Local declarations                           --
   --                                                                        --
   --                                                                        --
   --========================================================================--

   type Timer_PPtr is access all Timer_Ptr;

   Timer_List : aliased Timer_Ptr;

   --========================================================================--
   --                                                                        --
   --                                                                        --
   --                           Package subprograms                          --
   --                                                                        --
   --                                                                        --
   --========================================================================--

   ----------------------------------------------------------------------------
   -- Add
   ----------------------------------------------------------------------------
   procedure Add
      (T : in Timer_Ptr)
      is
      PTPtr      : Timer_PPtr := Timer_List'Access;
      P          : Timer_Ptr renames PTPtr.all;
      Intcontext : CPU.Intcontext_Type;
   begin
      CPU.Intcontext_Get (Intcontext);
      CPU.Irq_Disable;
      while P /= null loop
         if P.all.Expire > T.all.Expire then
            P.all.Expire := @ - T.all.Expire;
            T.all.Next := P;
            exit;
         end if;
         T.all.Expire := @ - P.all.Expire;
         PTPtr := P.all.Next'Access;
      end loop;
      P := T;
      CPU.Intcontext_Set (Intcontext);
   end Add;

   ----------------------------------------------------------------------------
   -- Delete
   ----------------------------------------------------------------------------
   function Delete
      (T : in Timer_Ptr)
      return Boolean
      is
      Intcontext : CPU.Intcontext_Type;
      PTPtr      : Timer_PPtr := Timer_List'Access;
      P          : Timer_Ptr renames PTPtr.all;
      E          : Unsigned_32 := 0;
      Result     : Boolean := False;
   begin
      CPU.Intcontext_Get (Intcontext);
      CPU.Irq_Disable;
      while P /= null loop
         if P = T then
            P := P.all.Next;
            if P /= null then
               P.all.Expire := @ + T.all.Expire;
            end if;
            T.all.Expire := @ + E;
            Result := True;
            exit;
         end if;
         E := @ + P.all.Expire;
         PTPtr := P.all.Next'Access;
      end loop;
      CPU.Intcontext_Set (Intcontext);
      return Result;
   end Delete;

   ----------------------------------------------------------------------------
   -- Process
   ----------------------------------------------------------------------------
   procedure Process
      is
   begin
      if Timer_List /= null then
         if Timer_List.all.Expire /= 0 then
            Timer_List.all.Expire := @ - 1;
         end if;
         if Timer_List.all.Expire = 0 then
            CPU.Irq_Enable;
            Timer_List.all.Proc (Timer_List.all.Data);
            CPU.Irq_Disable;
            Timer_List := Timer_List.all.Next;
         end if;
      end if;
   end Process;

end Timers;

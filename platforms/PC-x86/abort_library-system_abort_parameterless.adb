-----------------------------------------------------------------------------------------------------------------------
--                                                     SweetAda                                                      --
-----------------------------------------------------------------------------------------------------------------------
-- __HDS__                                                                                                           --
-- __FLN__ abort_library-system_abort_parameterless.adb                                                              --
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

with x86;
with GDBstub;
with GDBstub.SerialComm;
-- pragma Unreferenced (GDBstub);
-- pragma Unreferenced (GDBstub.SerialComm);

separate (Abort_Library)
procedure System_Abort_Parameterless
is
begin
   x86.Irq_Disable;
   if True then
      GDBstub.Init (
         Getchar => GDBstub.SerialComm.Getchar'Access,
         Putchar => GDBstub.SerialComm.Putchar'Access,
         Mode    => GDBstub.DEBUG_NONE
         );
      -- GDBstub.Enter_Stub (GDBstub.TARGET_STOPPED, 1);
   end if;
   x86.BREAKPOINT;
   loop null; end loop;
end System_Abort_Parameterless;

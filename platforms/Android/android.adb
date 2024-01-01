-----------------------------------------------------------------------------------------------------------------------
--                                                     SweetAda                                                      --
-----------------------------------------------------------------------------------------------------------------------
-- __HDS__                                                                                                           --
-- __FLN__ android.adb                                                                                               --
-- __DSC__                                                                                                           --
-- __HSH__ e69de29bb2d1d6434b8b29ae775ad8c2e48c5391                                                                  --
-- __HDE__                                                                                                           --
-----------------------------------------------------------------------------------------------------------------------
-- Copyright (C) 2020-2023 Gabriele Galeotti                                                                         --
--                                                                                                                   --
-- SweetAda web page: http://sweetada.org                                                                            --
-- contact address: gabriele.galeotti@sweetada.org                                                                   --
-- This work is licensed under the terms of the MIT License.                                                         --
-- Please consult the LICENSE.txt file located in the top-level directory.                                           --
-----------------------------------------------------------------------------------------------------------------------

with System;
with System.Machine_Code;
with Definitions;

package body Android
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
   use Definitions;

   --========================================================================--
   --                                                                        --
   --                                                                        --
   --                           Package subprograms                          --
   --                                                                        --
   --                                                                        --
   --========================================================================--

   SYSCALL_EXIT  : constant := 1;
   SYSCALL_WRITE : constant := 4;

   ----------------------------------------------------------------------------
   -- System_Exit
   ----------------------------------------------------------------------------
   procedure System_Exit
      (Exit_Status : in Integer)
      is
   begin
      Asm (
           Template => ""                      & CRLF &
                       "        mov     r0,%0" & CRLF &
                       "        mov     r7,%1" & CRLF &
                       "        swi     #0   " & CRLF &
                       "",
           Outputs  => No_Output_Operands,
           Inputs   => [
                        Integer'Asm_Input ("r", Exit_Status),
                        Integer'Asm_Input ("r", SYSCALL_EXIT)
                       ],
           Clobber  => "r0,r7",
           Volatile => True
          );
   end System_Exit;

   ----------------------------------------------------------------------------
   -- Print_Message
   ----------------------------------------------------------------------------
   procedure Print_Message
      (Message : in String)
      is
   begin
      Asm (
           Template => ""                      & CRLF &
                       "        mov     r0,#1" & CRLF &
                       "        mov     r1,%0" & CRLF &
                       "        mov     r2,%1" & CRLF &
                       "        mov     r7,%2" & CRLF &
                       "        swi     #0   " & CRLF &
                       "",
           Outputs  => No_Output_Operands,
           Inputs   => [
                        Address'Asm_Input ("r", Message'Address),
                        Integer'Asm_Input ("r", Message'Length),
                        Integer'Asm_Input ("r", SYSCALL_WRITE)
                       ],
           Clobber  => "r0,r1,r2,r7",
           Volatile => True
          );
   end Print_Message;

end Android;

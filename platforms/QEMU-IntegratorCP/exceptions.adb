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

with Abort_Library;
with Console;
with ARMv4;
with IntegratorCP;
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

   use ARMv4;
   use IntegratorCP;
   use BSP;

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
      (Reason    : in Unsigned_32;
       E_Address : in Integer_Address)
      is
      Message : access constant String;
   begin
      Console.Print ("*** EXCEPTION", NL => True);
      case Reason is
         when UNDEFINED_INSTRUCTION => Message := MsgPtr_UNDEFINED_INSTRUCTION;
         when SWI_EXCEPTION         => Message := MsgPtr_SWI_EXCEPTION;
         when ABORT_PREFETCH        => Message := MsgPtr_ABORT_PREFETCH;
         when ABORT_DATA            => Message := MsgPtr_ABORT_DATA;
         when ADDRESS_EXCEPTION     => Message := MsgPtr_ADDRESS_EXCEPTION;
         when others                => Message := MsgPtr_UNKNOWN_EXCEPTION;
      end case;
      Console.Print (Message.all, NL => True);
      Console.Print (Prefix => "ADDRESS: ", Value => E_Address, NL => True);
      Abort_Library.System_Abort;
   end Exception_Process;

   ----------------------------------------------------------------------------
   -- Irq_Process
   ----------------------------------------------------------------------------
   procedure Irq_Process
      is
   begin
      Timer (0).IntClr := 0;
      Tick_Count := @ + 1;
   end Irq_Process;

   ----------------------------------------------------------------------------
   -- Init
   ----------------------------------------------------------------------------
   procedure Init is null;

end Exceptions;

-----------------------------------------------------------------------------------------------------------------------
--                                                     SweetAda                                                      --
-----------------------------------------------------------------------------------------------------------------------
-- __HDS__                                                                                                           --
-- __FLN__ armv7a.ads                                                                                                --
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

with System;
with System.Storage_Elements;
with Interfaces;
with Bits;

package ARMv7A
   with Preelaborate => True
   is

   --========================================================================--
   --                                                                        --
   --                                                                        --
   --                               Public part                              --
   --                                                                        --
   --                                                                        --
   --========================================================================--

pragma Style_Checks (Off);

   ----------------------------------------------------------------------------
   -- ARM® Architecture Reference Manual
   -- ARMv7-A and ARMv7-R edition
   -- ARM DDI 0406C.d (ID040418)
   ----------------------------------------------------------------------------

   ----------------------------------------------------------------------------
   -- CPU helper subprograms
   ----------------------------------------------------------------------------

   procedure NOP
      with Inline => True;
   procedure BREAKPOINT
      with Inline => True;

   ----------------------------------------------------------------------------
   -- Exceptions and interrupts
   ----------------------------------------------------------------------------

   -- these definitions are both codes for exception and vector offsets
   Reset                 : constant := 16#00#;
   Undefined_Instruction : constant := 16#04#;
   Supervisor_Call       : constant := 16#08#;
   Prefetch_Abort        : constant := 16#0C#;
   Data_Abort            : constant := 16#10#;
   Notused               : constant := 16#14#;
   IRQ                   : constant := 16#18#;
   FIQ                   : constant := 16#1C#;

   String_Reset                 : aliased constant String := "Reset";
   String_Undefined_Instruction : aliased constant String := "Undefined Instruction";
   String_Supervisor_Call       : aliased constant String := "Supervisor Call";
   String_Prefetch_Abort        : aliased constant String := "Prefetch Abort";
   String_Data_Abort            : aliased constant String := "Data Abort";
   String_Notused               : aliased constant String := "Not used";
   String_IRQ                   : aliased constant String := "IRQ";
   String_FIQ                   : aliased constant String := "FIQ";
   String_UNKNOWN               : aliased constant String := "UNKNOWN";

   MsgPtr_Reset                 : constant access constant String := String_Reset'Access;
   MsgPtr_Undefined_Instruction : constant access constant String := String_Undefined_Instruction'Access;
   MsgPtr_Supervisor_Call       : constant access constant String := String_Supervisor_Call'Access;
   MsgPtr_Prefetch_Abort        : constant access constant String := String_Prefetch_Abort'Access;
   MsgPtr_Data_Abort            : constant access constant String := String_Data_Abort'Access;
   MsgPtr_Notused               : constant access constant String := String_Notused'Access;
   MsgPtr_IRQ                   : constant access constant String := String_IRQ'Access;
   MsgPtr_FIQ                   : constant access constant String := String_FIQ'Access;
   MsgPtr_UNKNOWN               : constant access constant String := String_UNKNOWN'Access;

   procedure Irq_Enable
      with Inline => True;
   procedure Irq_Disable
      with Inline => True;
   procedure Fiq_Enable
      with Inline => True;
   procedure Fiq_Disable
      with Inline => True;

pragma Style_Checks (On);

end ARMv7A;

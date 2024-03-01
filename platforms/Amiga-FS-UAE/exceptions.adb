-----------------------------------------------------------------------------------------------------------------------
--                                                     SweetAda                                                      --
-----------------------------------------------------------------------------------------------------------------------
-- __HDS__                                                                                                           --
-- __FLN__ exceptions.adb                                                                                            --
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

with System.Storage_Elements;
with Abort_Library;
with Configure;
with Core;
with MMIO;
with Amiga;
with BSP;
with Gdbstub;
with IOEMU;
with A2065;
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

   use System.Storage_Elements;
   use Abort_Library;
   use Amiga;
   -- use BSP;

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
      (Exception_Number : in Unsigned_32;
       Frame_Address    : in Address)
      is
   begin
      case Exception_Number is
         when Illegal_Instruction =>
            Irq_Disable;
            Console.Print_NewLine;
            Console.Print ("Illegal instruction", NL => True);
            Console.Print (Unsigned_16'(MMIO.Read (Frame_Address + 16 + 0)), Prefix => "1: ", NL => True);
            Console.Print (Unsigned_16'(MMIO.Read (Frame_Address + 16 + 2)), Prefix => "2: ", NL => True);
            Console.Print (Unsigned_16'(MMIO.Read (Frame_Address + 16 + 4)), Prefix => "3: ", NL => True);
            Console.Print (Unsigned_16'(MMIO.Read (Frame_Address + 16 + 6)), Prefix => "4: ", NL => True);
            System_Abort;
         when Trace | Trap_15 =>
            Gdbstub.Enter_Stub (Gdbstub.TARGET_BREAKPOINT, Core.KERNEL_THREAD_ID);
         when Format_Error =>
            Irq_Disable;
            Console.Print_NewLine;
            Console.Print ("Format error", NL => True);
            System_Abort;
         when others =>
            Irq_Disable;
            Console.Print_NewLine;
            Console.Print (Exception_Number, Prefix => "Exception: 0x", NL => True);
            System_Abort;
      end case;
   end Exception_Process;

   ----------------------------------------------------------------------------
   -- Irq_Process
   ----------------------------------------------------------------------------
   procedure Irq_Process
      (Irq_Identifier : in Exception_Vector_Id_Type)
      is
      Unused : Unsigned_8 with Unreferenced => True;
   begin
      if Irq_Identifier = Level_1_Interrupt_Autovector then
         Console.Print ("Level 1 IRQ", NL => True);
      end if;
      if Irq_Identifier = Level_2_Interrupt_Autovector then
         -- Console.Print ("Level 2 IRQ", NL => True);
         -- check if A2065 interrupt
         if not A2065.Receive then
            BSP.Tick_Count := @ + 1;
            if Configure.USE_FS_UAE_IOEMU then
               -- IRQ pulsemeter
               IOEMU.CIA_IO0 := 1;
            end if;
            -- use power LED as tick IRQ monitoring
            if BSP.Tick_Count mod 500 = 0 then
               CIAA.PRA.PA1 := not @;
            end if;
            -- clear pending interrupt
            Unused := CIAA.ICR;
         end if;
         -- acknowledge interrupt
         INTREQ_ClearBitMask (PORTS);
      end if;
      if Irq_Identifier = Level_3_Interrupt_Autovector then
         Console.Print ("Level 3 IRQ", NL => True);
      end if;
      if Irq_Identifier = Level_4_Interrupt_Autovector then
         Console.Print ("Level 4 IRQ", NL => True);
      end if;
      if Irq_Identifier = Level_5_Interrupt_Autovector then
         Console.Print ("Level 5 IRQ", NL => True);
      end if;
      if Irq_Identifier = Level_6_Interrupt_Autovector then
         Console.Print ("Level 6 IRQ", NL => True);
      end if;
      if Irq_Identifier = Level_7_Interrupt_Autovector then
         Console.Print ("Level 7 IRQ", NL => True);
      end if;
   end Irq_Process;

   ----------------------------------------------------------------------------
   -- Init
   ----------------------------------------------------------------------------
   procedure Init
      is
   begin
      for Index in IVT'Range loop
         IVT (Index) := Null_Address;
      end loop;
      -- IVT (Reset_Initial_Int_Stack_Pointer)
      -- IVT (Reset_Initial_Program_Counter)
      IVT (Bus_Error)                          := Buserr_Handler'Address;
      IVT (Address_Error)                      := Addrerr_Handler'Address;
      IVT (Illegal_Instruction)                := Illinstr_Handler'Address;
      IVT (Zero_Divide)                        := Div0_Handler'Address;
      IVT (CHK_CHK2_Instruction)               := Chkinstr_Handler'Address;
      IVT (CPTRAPcc_TRAPcc_TRAPV_Instructions) := Trapc_Handler'Address;
      IVT (Privilege_Violation)                := PrivilegeV_Handler'Address;
      IVT (Trace)                              := Trace_Handler'Address;
      IVT (Line_1010_Emulator)                 := Line1010_Handler'Address;
      IVT (Line_1111_Emulator)                 := Line1111_Handler'Address;
      -- IVT (Unassigned_Reserved_1)              := Null_Address;
      IVT (Coprocessor_Protocol_Violation)     := CProtocolV_Handler'Address;
      IVT (Format_Error)                       := Formaterr_Handler'Address;
      IVT (Uninitialized_Interrupt)            := Uninitint_Handler'Address;
      -- IVT (Unassigned_Reserved_2)              := Null_Address;
      -- IVT (Unassigned_Reserved_3)              := Null_Address;
      -- IVT (Unassigned_Reserved_4)              := Null_Address;
      -- IVT (Unassigned_Reserved_5)              := Null_Address;
      -- IVT (Unassigned_Reserved_6)              := Null_Address;
      -- IVT (Unassigned_Reserved_7)              := Null_Address;
      -- IVT (Unassigned_Reserved_8)              := Null_Address;
      -- IVT (Unassigned_Reserved_9)              := Null_Address;
      IVT (Spurious_Interrupt)                 := Spurious_Interrupt_Handler'Address;
      IVT (Level_1_Interrupt_Autovector)       := Level_1_Interrupt_Autovector_Handler'Address;
      IVT (Level_2_Interrupt_Autovector)       := Level_2_Interrupt_Autovector_Handler'Address;
      IVT (Level_3_Interrupt_Autovector)       := Level_3_Interrupt_Autovector_Handler'Address;
      IVT (Level_4_Interrupt_Autovector)       := Level_4_Interrupt_Autovector_Handler'Address;
      IVT (Level_5_Interrupt_Autovector)       := Level_5_Interrupt_Autovector_Handler'Address;
      IVT (Level_6_Interrupt_Autovector)       := Level_6_Interrupt_Autovector_Handler'Address;
      IVT (Level_7_Interrupt_Autovector)       := Level_7_Interrupt_Autovector_Handler'Address;
      -- IVT (Trap_1)                             := Trap_1_Handler'Address;
      -- IVT (Trap_2)                             := Trap_2_Handler'Address;
      -- IVT (Trap_3)                             := Trap_3_Handler'Address;
      -- IVT (Trap_4)                             := Trap_4_Handler'Address;
      -- IVT (Trap_5)                             := Trap_5_Handler'Address;
      -- IVT (Trap_6)                             := Trap_6_Handler'Address;
      -- IVT (Trap_7)                             := Trap_7_Handler'Address;
      -- IVT (Trap_8)                             := Trap_8_Handler'Address;
      -- IVT (Trap_9)                             := Trap_9_Handler'Address;
      -- IVT (Trap_10)                            := Trap_10_Handler'Address;
      -- IVT (Trap_11)                            := Trap_11_Handler'Address;
      -- IVT (Trap_12)                            := Trap_12_Handler'Address;
      -- IVT (Trap_13)                            := Trap_13_Handler'Address;
      -- IVT (Trap_14)                            := Trap_14_Handler'Address;
      IVT (Trap_15)                            := Trap_15_Handler'Address;
      VBR_Set (IVT'Address);
   end Init;

end Exceptions;

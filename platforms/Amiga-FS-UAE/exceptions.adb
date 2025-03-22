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

with System.Storage_Elements;
with Abort_Library;
with Core;
with MMIO;
with Amiga;
with BSP;
with Gdbstub;
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
            Console.Print (Prefix => "1: ", Value => Unsigned_16'(MMIO.Read (Frame_Address + 16 + 0)), NL => True);
            Console.Print (Prefix => "2: ", Value => Unsigned_16'(MMIO.Read (Frame_Address + 16 + 2)), NL => True);
            Console.Print (Prefix => "3: ", Value => Unsigned_16'(MMIO.Read (Frame_Address + 16 + 4)), NL => True);
            Console.Print (Prefix => "4: ", Value => Unsigned_16'(MMIO.Read (Frame_Address + 16 + 6)), NL => True);
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
            Console.Print (Prefix => "Exception: 0x", Value => Exception_Number, NL => True);
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
      if Irq_Identifier = Level1_Autovector then
         Console.Print ("Level 1 IRQ", NL => True);
      end if;
      if Irq_Identifier = Level2_Autovector then
         -- Console.Print ("Level 2 IRQ", NL => True);
         -- check if A2065 interrupt
         -- if not A2065.Receive then
         if True then
            BSP.Tick_Count := @ + 1;
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
      if Irq_Identifier = Level3_Autovector then
         Console.Print ("Level 3 IRQ", NL => True);
      end if;
      if Irq_Identifier = Level4_Autovector then
         Console.Print ("Level 4 IRQ", NL => True);
      end if;
      if Irq_Identifier = Level5_Autovector then
         Console.Print ("Level 5 IRQ", NL => True);
      end if;
      if Irq_Identifier = Level6_Autovector then
         Console.Print ("Level 6 IRQ", NL => True);
      end if;
      if Irq_Identifier = Level7_Autovector then
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
      IVT (Access_Fault)                       := Accessfault_Handler'Address;
      IVT (Address_Error)                      := Addresserr_Handler'Address;
      IVT (Illegal_Instruction)                := Illinstr_Handler'Address;
      IVT (Integer_Divide_by_Zero)             := Div0_Handler'Address;
      IVT (CHK_CHK2_Instruction)               := Chkinstr_Handler'Address;
      IVT (FTRAPcc_TRAPcc_TRAPV_Instructions)  := FTRAPcc_Handler'Address;
      IVT (Privilege_Violation)                := PrivilegeV_Handler'Address;
      IVT (Trace)                              := Trace_Handler'Address;
      IVT (Line_1010_Emulator)                 := Line1010_Handler'Address;
      IVT (Line_1111_Emulator)                 := Line1111_Handler'Address;
      -- IVT (Unassigned_Reserved_1)              := Null_Address;
      IVT (Coprocessor_Protocol_Violation)     := CPProtocolV_Handler'Address;
      IVT (Format_Error)                       := Formaterr_Handler'Address;
      IVT (Uninitialized_Interrupt)            := UninitInt_Handler'Address;
      -- IVT (Unassigned_Reserved_2)              := Null_Address;
      -- IVT (Unassigned_Reserved_3)              := Null_Address;
      -- IVT (Unassigned_Reserved_4)              := Null_Address;
      -- IVT (Unassigned_Reserved_5)              := Null_Address;
      -- IVT (Unassigned_Reserved_6)              := Null_Address;
      -- IVT (Unassigned_Reserved_7)              := Null_Address;
      -- IVT (Unassigned_Reserved_8)              := Null_Address;
      -- IVT (Unassigned_Reserved_9)              := Null_Address;
      IVT (Spurious_Interrupt)      := SpuriousInt_Handler'Address;
      IVT (Level1_Autovector)       := Level1_Autovector_Handler'Address;
      IVT (Level2_Autovector)       := Level2_Autovector_Handler'Address;
      IVT (Level3_Autovector)       := Level3_Autovector_Handler'Address;
      IVT (Level4_Autovector)       := Level4_Autovector_Handler'Address;
      IVT (Level5_Autovector)       := Level5_Autovector_Handler'Address;
      IVT (Level6_Autovector)       := Level6_Autovector_Handler'Address;
      IVT (Level7_Autovector)       := Level7_Autovector_Handler'Address;
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

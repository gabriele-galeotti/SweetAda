-----------------------------------------------------------------------------------------------------------------------
--                                                     SweetAda                                                      --
-----------------------------------------------------------------------------------------------------------------------
-- __HDS__                                                                                                           --
-- __FLN__ exceptions.adb                                                                                            --
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

with System;
with Interfaces;
with Abort_Library;
with GDT_Simple;
with BSP;
with PC;
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

   use System;
   use Interfaces;
   use GDT_Simple;
   use BSP;

   IDT_Descriptor : aliased IDT_Descriptor_Type := IDT_DESCRIPTOR_INVALID;
   IDT            : aliased IDT_Type (Exception_DE .. PC.PIC_Irq15) := [others => EXCEPTION_DESCRIPTOR_INVALID];

   type Exception_Vector_Type is record
      Handler_Address : Address;
      Selector        : Selector_Type;
      Gate            : Segment_Gate_Type;
   end record;

   Exception_Vectors : constant array (Exception_DE .. PC.PIC_Irq15) of Exception_Vector_Type :=
      [
      (Div_By_0_Handler'Address,        SELECTOR_KCODE64, SYSGATE_TRAP), -- 0x00 Exception_DE
      (Debug_Exception_Handler'Address, SELECTOR_KCODE64, SYSGATE_TRAP), -- 0x01 Exception_DB
      (Nmi_Interrupt_Handler'Address,   SELECTOR_KCODE64, SYSGATE_TRAP), -- 0x02 Exception_NN
      (One_Byte_Int_Handler'Address,    SELECTOR_KCODE64, SYSGATE_TRAP), -- 0x03 Exception_BP
      (Int_On_Overflow_Handler'Address, SELECTOR_KCODE64, SYSGATE_TRAP), -- 0x04 Exception_OF
      (Array_Bounds_Handler'Address,    SELECTOR_KCODE64, SYSGATE_TRAP), -- 0x05 Exception_BR
      (Invalid_Opcode_Handler'Address,  SELECTOR_KCODE64, SYSGATE_TRAP), -- 0x06 Exception_UD
      (Device_Not_Avl_Handler'Address,  SELECTOR_KCODE64, SYSGATE_TRAP), -- 0x07 Exception_NM
      (Double_Fault_Handler'Address,    SELECTOR_KCODE64, SYSGATE_TRAP), -- 0x08 Exception_DF
      (Cp_Seg_Ovr_Handler'Address,      SELECTOR_KCODE64, SYSGATE_TRAP), -- 0x09 Exception_CS
      (Invalid_Tss_Handler'Address,     SELECTOR_KCODE64, SYSGATE_TRAP), -- 0x0A Exception_TS
      (Seg_Not_Prsnt_Handler'Address,   SELECTOR_KCODE64, SYSGATE_TRAP), -- 0x0B Exception_NP
      (Stack_Fault_Handler'Address,     SELECTOR_KCODE64, SYSGATE_TRAP), -- 0x0C Exception_SS
      (Gen_Prot_Fault_Handler'Address,  SELECTOR_KCODE64, SYSGATE_TRAP), -- 0x0D Exception_GP
      (Page_Fault_Handler'Address,      SELECTOR_KCODE64, SYSGATE_TRAP), -- 0x0E Exception_PF
      (Null_Address,                    SELECTOR_KCODE64, SYSGATE_TRAP), -- 0x0F Reserved0F
      (Coproc_Error_Handler'Address,    SELECTOR_KCODE64, SYSGATE_TRAP), -- 0x10 Exception_MF
      (Null_Address,                    SELECTOR_KCODE64, SYSGATE_TRAP), -- 0x11 Exception_AC
      (Null_Address,                    SELECTOR_KCODE64, SYSGATE_TRAP), -- 0x12 Exception_MC
      (Null_Address,                    SELECTOR_KCODE64, SYSGATE_TRAP), -- 0x13 Exception_XM
      (Null_Address,                    SELECTOR_KCODE64, SYSGATE_TRAP), -- 0x14 Exception_VE
      (Null_Address,                    SELECTOR_KCODE64, SYSGATE_TRAP), -- 0x15 Reserved15
      (Null_Address,                    SELECTOR_KCODE64, SYSGATE_TRAP), -- 0x16 Reserved16
      (Null_Address,                    SELECTOR_KCODE64, SYSGATE_TRAP), -- 0x17 Reserved17
      (Null_Address,                    SELECTOR_KCODE64, SYSGATE_TRAP), -- 0x18 Reserved18
      (Null_Address,                    SELECTOR_KCODE64, SYSGATE_TRAP), -- 0x19 Reserved19
      (Null_Address,                    SELECTOR_KCODE64, SYSGATE_TRAP), -- 0x1A Reserved1A
      (Null_Address,                    SELECTOR_KCODE64, SYSGATE_TRAP), -- 0x1B Reserved1B
      (Null_Address,                    SELECTOR_KCODE64, SYSGATE_TRAP), -- 0x1C Reserved1C
      (Null_Address,                    SELECTOR_KCODE64, SYSGATE_TRAP), -- 0x1D Reserved1D
      (Null_Address,                    SELECTOR_KCODE64, SYSGATE_TRAP), -- 0x1E Reserved1E
      (Null_Address,                    SELECTOR_KCODE64, SYSGATE_TRAP), -- 0x1F Reserved1F
      (Irq0_Handler'Address,            SELECTOR_KCODE64, SYSGATE_INT),  -- 0x20 Irq0
      (Null_Address,                    SELECTOR_KCODE64, SYSGATE_INT),  -- 0x21 Irq1
      (Null_Address,                    SELECTOR_KCODE64, SYSGATE_INT),  -- 0x22 Irq2
      (Null_Address,                    SELECTOR_KCODE64, SYSGATE_INT),  -- 0x23 Irq3
      (Null_Address,                    SELECTOR_KCODE64, SYSGATE_INT),  -- 0x24 Irq4
      (Null_Address,                    SELECTOR_KCODE64, SYSGATE_INT),  -- 0x25 Irq5
      (Null_Address,                    SELECTOR_KCODE64, SYSGATE_INT),  -- 0x26 Irq6
      (Null_Address,                    SELECTOR_KCODE64, SYSGATE_INT),  -- 0x27 Irq7
      (Irq8_Handler'Address,            SELECTOR_KCODE64, SYSGATE_INT),  -- 0x28 Irq8
      (Null_Address,                    SELECTOR_KCODE64, SYSGATE_INT),  -- 0x29 Irq9
      (Null_Address,                    SELECTOR_KCODE64, SYSGATE_INT),  -- 0x2A Irq10
      (Null_Address,                    SELECTOR_KCODE64, SYSGATE_INT),  -- 0x2B Irq11
      (Null_Address,                    SELECTOR_KCODE64, SYSGATE_INT),  -- 0x2C Irq12
      (Null_Address,                    SELECTOR_KCODE64, SYSGATE_INT),  -- 0x2D Irq13
      (Null_Address,                    SELECTOR_KCODE64, SYSGATE_INT),  -- 0x2E Irq14
      (Null_Address,                    SELECTOR_KCODE64, SYSGATE_INT)   -- 0x2F Irq15
      ];

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
      (Exception_Identifier : in Exception_Id_Type)
   is
      MsgPtr : access constant String;
   begin
      Console.Print_NewLine;
      Console.Print ("*** EXCEPTION: ");
      case Exception_Identifier is
         when Exception_DE => MsgPtr := MsgPtr_DIVISION_BY_0;
         when Exception_DB => MsgPtr := MsgPtr_DEBUG;
         when Exception_NN => MsgPtr := MsgPtr_NMI_INTERRUPT;
         when Exception_BP => MsgPtr := MsgPtr_BREAKPOINT;
         when Exception_OF => MsgPtr := MsgPtr_OVERFLOW;
         when Exception_BR => MsgPtr := MsgPtr_ARRAY_BOUNDS;
         when Exception_UD => MsgPtr := MsgPtr_INVALID_OPCODE;
         when Exception_NM => MsgPtr := MsgPtr_DEVICE_NOT_AVAILABLE;
         when Exception_DF => MsgPtr := MsgPtr_DOUBLE_FAULT;
         when Exception_CS => MsgPtr := MsgPtr_CP_SEGMENT_OVERRUN;
         when Exception_TS => MsgPtr := MsgPtr_INVALID_TSS;
         when Exception_NP => MsgPtr := MsgPtr_SEGMENT_NOT_PRESENT;
         when Exception_SS => MsgPtr := MsgPtr_STACK_FAULT;
         when Exception_GP => MsgPtr := MsgPtr_GENERAL_PROTECTION;
         when Exception_PF => MsgPtr := MsgPtr_PAGE_FAULT;
         when Exception_MF => MsgPtr := MsgPtr_CP_ERROR;
         when others       => MsgPtr := MsgPtr_UNKNOWN;
      end case;
      Console.Print (MsgPtr.all);
      Console.Print_NewLine;
      Abort_Library.System_Abort;
   end Exception_Process;

   ----------------------------------------------------------------------------
   -- Irq_Process
   ----------------------------------------------------------------------------
   procedure Irq_Process
   is
   begin
      -- increment system tick counter
      BSP.Tick_Count := @ + 1;
      -- LED ignition on a physical machine
      -- turn on/off the PPI INIT signal at a "human" rate
      if not QEMU then
         if BSP.Tick_Count mod 1_000 = 0 then
            PC.PPI_ControlOut (PC.PPI_Control_Type'(
               INIT   => True,
               others => <>
               ));
         end if;
         if (BSP.Tick_Count + 500) mod 1_000 = 0 then
            PC.PPI_ControlOut (PC.PPI_Control_Type'(
               INIT   => False,
               others => <>
               ));
         end if;
      end if;
      PC.PIC1_EOI;
   end Irq_Process;

   ----------------------------------------------------------------------------
   -- Init
   ----------------------------------------------------------------------------
   procedure Init
   is
   begin
      for Exception_Id in Exception_Vectors'Range loop
         IDT_Set_Handler (
            IDT (Exception_Id),
            Exception_Vectors (Exception_Id).Handler_Address,
            Exception_Vectors (Exception_Id).Selector,
            Exception_Vectors (Exception_Id).Gate
            );
      end loop;
      IDT_Set (IDT_Descriptor, IDT'Address, IDT'Length);
   end Init;

end Exceptions;

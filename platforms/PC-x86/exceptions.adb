-----------------------------------------------------------------------------------------------------------------------
--                                                     SweetAda                                                      --
-----------------------------------------------------------------------------------------------------------------------
-- __HDS__                                                                                                           --
-- __FLN__ exceptions.adb                                                                                            --
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

with System.Storage_Elements;
with Ada.Unchecked_Conversion;
with Interfaces;
with Core;
with Abort_Library;
with Interrupts;
with CPU.IO;
with BSP;
with GDT_Simple;
with PC;
with Ethernet;
with PBUF;
with NE2000;
with Console;

package body Exceptions is

   --========================================================================--
   --                                                                        --
   --                                                                        --
   --                           Local declarations                           --
   --                                                                        --
   --                                                                        --
   --========================================================================--

   use Interfaces;
   use Core;
   use CPU.IO;
   use GDT_Simple;
   use BSP;

   IDT_Descriptor : aliased IDT_Descriptor_Type := IDT_DESCRIPTOR_INVALID;
   IDT            : aliased IDT_Type (Exception_DE .. PC.PIC_Irq15) := (others => EXCEPTION_DESCRIPTOR_INVALID);

   type Exception_Vector_Type is
   record
      Handler_Address : Address;
      Selector        : Selector_Type;
      Gate            : Segment_Gate_Type;
   end record;

   Exception_Vectors : constant array (Exception_DE .. PC.PIC_Irq15) of Exception_Vector_Type :=
      (
       (Div_By_0_Handler'Address,        SELECTOR_KCODE, SYSGATE_TRAP), -- Exception_DE
       (Debug_Exception_Handler'Address, SELECTOR_KCODE, SYSGATE_INT),  -- Exception_DB
       (Nmi_Interrupt_Handler'Address,   SELECTOR_KCODE, SYSGATE_TRAP), -- Exception_NN
       (One_Byte_Int_Handler'Address,    SELECTOR_KCODE, SYSGATE_INT),  -- Exception_BP
       (Int_On_Overflow_Handler'Address, SELECTOR_KCODE, SYSGATE_TRAP), -- Exception_OF
       (Array_Bounds_Handler'Address,    SELECTOR_KCODE, SYSGATE_TRAP), -- Exception_BR
       (Invalid_Opcode_Handler'Address,  SELECTOR_KCODE, SYSGATE_TRAP), -- Exception_UD
       (Device_Not_Avl_Handler'Address,  SELECTOR_KCODE, SYSGATE_TRAP), -- Exception_NM
       (Double_Fault_Handler'Address,    SELECTOR_KCODE, SYSGATE_TRAP), -- Exception_DF
       (Cp_Seg_Ovr_Handler'Address,      SELECTOR_KCODE, SYSGATE_TRAP), -- Exception_CS
       (Invalid_Tss_Handler'Address,     SELECTOR_KCODE, SYSGATE_TRAP), -- Exception_TS
       (Seg_Not_Prsnt_Handler'Address,   SELECTOR_KCODE, SYSGATE_TRAP), -- Exception_NP
       (Stack_Fault_Handler'Address,     SELECTOR_KCODE, SYSGATE_TRAP), -- Exception_SS
       (Gen_Prot_Fault_Handler'Address,  SELECTOR_KCODE, SYSGATE_TRAP), -- Exception_GP
       (Page_Fault_Handler'Address,      SELECTOR_KCODE, SYSGATE_TRAP), -- Exception_PF
       (Null_Address,                    SELECTOR_KCODE, SYSGATE_TRAP), -- Reserved0F
       (Coproc_Error_Handler'Address,    SELECTOR_KCODE, SYSGATE_TRAP), -- Exception_MF
       (Null_Address,                    SELECTOR_KCODE, SYSGATE_TRAP), -- Exception_AC
       (Null_Address,                    SELECTOR_KCODE, SYSGATE_TRAP), -- Exception_MC
       (Null_Address,                    SELECTOR_KCODE, SYSGATE_TRAP), -- Exception_XM
       (Null_Address,                    SELECTOR_KCODE, SYSGATE_TRAP), -- Exception_VE
       (Null_Address,                    SELECTOR_KCODE, SYSGATE_TRAP), -- Reserved15
       (Null_Address,                    SELECTOR_KCODE, SYSGATE_TRAP), -- Reserved16
       (Null_Address,                    SELECTOR_KCODE, SYSGATE_TRAP), -- Reserved17
       (Null_Address,                    SELECTOR_KCODE, SYSGATE_TRAP), -- Reserved18
       (Null_Address,                    SELECTOR_KCODE, SYSGATE_TRAP), -- Reserved19
       (Null_Address,                    SELECTOR_KCODE, SYSGATE_TRAP), -- Reserved1A
       (Null_Address,                    SELECTOR_KCODE, SYSGATE_TRAP), -- Reserved1B
       (Null_Address,                    SELECTOR_KCODE, SYSGATE_TRAP), -- Reserved1C
       (Null_Address,                    SELECTOR_KCODE, SYSGATE_TRAP), -- Reserved1D
       (Null_Address,                    SELECTOR_KCODE, SYSGATE_TRAP), -- Reserved1E
       (Null_Address,                    SELECTOR_KCODE, SYSGATE_TRAP), -- Reserved1F
       (Irq0_Handler'Address,            SELECTOR_KCODE, SYSGATE_INT),  -- Irq0
       (Irq1_Handler'Address,            SELECTOR_KCODE, SYSGATE_INT),  -- Irq1
       (Null_Address,                    SELECTOR_KCODE, SYSGATE_INT),  -- Irq2
       (Irq3_Handler'Address,            SELECTOR_KCODE, SYSGATE_INT),  -- Irq3
       (Irq4_Handler'Address,            SELECTOR_KCODE, SYSGATE_INT),  -- Irq4
       (Irq5_Handler'Address,            SELECTOR_KCODE, SYSGATE_INT),  -- Irq5
       (Irq6_Handler'Address,            SELECTOR_KCODE, SYSGATE_INT),  -- Irq6
       (Irq7_Handler'Address,            SELECTOR_KCODE, SYSGATE_INT),  -- Irq7
       (Irq8_Handler'Address,            SELECTOR_KCODE, SYSGATE_INT),  -- Irq8
       (Irq9_Handler'Address,            SELECTOR_KCODE, SYSGATE_INT),  -- Irq9
       (Irq10_Handler'Address,           SELECTOR_KCODE, SYSGATE_INT),  -- Irq10
       (Irq11_Handler'Address,           SELECTOR_KCODE, SYSGATE_INT),  -- Irq11
       (Irq12_Handler'Address,           SELECTOR_KCODE, SYSGATE_INT),  -- Irq12
       (Irq13_Handler'Address,           SELECTOR_KCODE, SYSGATE_INT),  -- Irq13
       (Irq14_Handler'Address,           SELECTOR_KCODE, SYSGATE_INT),  -- Irq14
       (Irq15_Handler'Address,           SELECTOR_KCODE, SYSGATE_INT)   -- Irq15
      );

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
   procedure Exception_Process (
                                Exception_Identifier          : in Exception_Id_Type;
                                Exception_Stack_Frame_Address : in Address
                               ) is
      Exception_Frame : aliased Exception_Stack_Frame_Type with
         Address    => Exception_Stack_Frame_Address,
         Import     => True,
         Convention => Ada;
      MsgPtr          : access constant String;
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
      Console.Print (To_U16 (Exception_Frame.CS), Prefix => "CS:  ", NL => True);
      Console.Print (Exception_Frame.EIP,         Prefix => "EIP: ", NL => True);
      Abort_Library.System_Abort;
   end Exception_Process;

   ----------------------------------------------------------------------------
   -- Irq_Process
   ----------------------------------------------------------------------------
   procedure Irq_Process (Irq_Identifier : in Irq_Id_Type) is
   begin
      case Irq_Identifier is
         when PC.PIT_Interrupt =>
            -- increment system tick counter
            Tick_Count := Tick_Count + 1;
            -- LED ignition QEMU/IOEMU or physical PC
            if QEMU then
               -- IOEMU "TIMER" LED blinking
               if Tick_Count mod 1_000 = 0 then
                  PC.PPI_ControlOut (PC.To_PPI_Control (16#FF#));
                  PC.PPI_ControlOut (PC.To_PPI_Control (16#00#));
               end if;
            else
               -- with a physical machine, we have to turn on/off the LED at a
               -- "human" rate
               if Tick_Count mod 1_000 = 0 then
                  PC.PPI_ControlOut (PC.To_PPI_Control (16#04#)); -- PPI INIT signal
               end if;
               if (Tick_Count + 500) mod 1_000 = 0 then
                  PC.PPI_ControlOut (PC.To_PPI_Control (0));
               end if;
            end if;
            PC.PIC1_EOI;
         when PC.PIC_Irq3 =>
            Interrupts.Handler (PC.PIC_Irq3);
            PC.PIC1_EOI;
         when PC.PIC_Irq4 =>
            Interrupts.Handler (PC.PIC_Irq4);
            PC.PIC1_EOI;
         when PC.PIC_Irq5 =>
            Interrupts.Handler (PC.PIC_Irq5);
            PC.PIC1_EOI;
         when PC.PIC_Irq1 | PC.PIC_Irq2 | PC.PIC_Irq6 | PC.PIC_Irq7 =>
            Console.Print ("Irq1..Irq7", NL => True);
            PC.PIC1_EOI;
         when PC.RTC_Interrupt =>
            Interrupts.Handler (PC.RTC_Interrupt);
            PC.PIC2_EOI;
         when PC.PIC_Irq9 | PC.PIC_Irq10 | PC.PIC_Irq11 | PC.PIC_Irq12 | PC.PIC_Irq13 | PC.PIC_Irq14 | PC.PIC_Irq15 =>
            Console.Print ("not-enabled IRQ detected", NL => True);
            PC.PIC2_EOI;
         when others =>
            null;
      end case;
   end Irq_Process;

   ----------------------------------------------------------------------------
   -- Init
   ----------------------------------------------------------------------------
   procedure Init is
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

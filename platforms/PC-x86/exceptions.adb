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
with Gdbstub;
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
   use Abort_Library;
   use Core;
   use CPU.IO;
   use GDT_Simple;
   use BSP;

   IDT_DESCRIPTOR_INVALID : constant IDT_Descriptor_Type := (0, 0, 0);

   IDT_DESCRIPTOR_EXCEPTION_INVALID : constant IDT_Exception_Descriptor_Type :=
      (
       0, SELECTOR_DEFAULT, 0, GATE_RESERVED_1, DESCRIPTOR_SYSTEM, PL0, False, 0
      );

   IDT_Descriptor : aliased IDT_Descriptor_Type := IDT_DESCRIPTOR_INVALID;
   IDT            : aliased IDT_Type (Exception_DE .. PC.PIC_Irq15) := (others => IDT_DESCRIPTOR_EXCEPTION_INVALID);

   type Exception_Vector_Type is
   record
      Handler_Address : Address;
      Selector        : Selector_Type;
      Gate            : Segment_Gate_Type;
   end record;

   Exception_Vectors : constant array (Exception_DE .. PC.PIC_Irq15) of Exception_Vector_Type :=
      (
       (Div_By_0_Handler'Address,        SELECTOR_KCODE, GATE_32_Trap),      -- Exception_DE
       (Debug_Exception_Handler'Address, SELECTOR_KCODE, GATE_32_Interrupt), -- Exception_DB
       (Nmi_Interrupt_Handler'Address,   SELECTOR_KCODE, GATE_32_Trap),      -- Exception_NN
       (One_Byte_Int_Handler'Address,    SELECTOR_KCODE, GATE_32_Interrupt), -- Exception_BP
       (Int_On_Overflow_Handler'Address, SELECTOR_KCODE, GATE_32_Trap),      -- Exception_OF
       (Array_Bounds_Handler'Address,    SELECTOR_KCODE, GATE_32_Trap),      -- Exception_BR
       (Invalid_Opcode_Handler'Address,  SELECTOR_KCODE, GATE_32_Trap),      -- Exception_UD
       (Device_Not_Avl_Handler'Address,  SELECTOR_KCODE, GATE_32_Trap),      -- Exception_NM
       (Double_Fault_Handler'Address,    SELECTOR_KCODE, GATE_32_Trap),      -- Exception_DF
       (Cp_Seg_Ovr_Handler'Address,      SELECTOR_KCODE, GATE_32_Trap),      -- Exception_CS
       (Invalid_Tss_Handler'Address,     SELECTOR_KCODE, GATE_32_Trap),      -- Exception_TS
       (Seg_Not_Prsnt_Handler'Address,   SELECTOR_KCODE, GATE_32_Trap),      -- Exception_NP
       (Stack_Fault_Handler'Address,     SELECTOR_KCODE, GATE_32_Trap),      -- Exception_SS
       (Gen_Prot_Fault_Handler'Address,  SELECTOR_KCODE, GATE_32_Trap),      -- Exception_GP
       (Page_Fault_Handler'Address,      SELECTOR_KCODE, GATE_32_Trap),      -- Exception_PF
       (Null_Address,                    SELECTOR_KCODE, GATE_32_Trap),      -- Reserved0f
       (Coproc_Error_Handler'Address,    SELECTOR_KCODE, GATE_32_Trap),      -- Exception_MF
       (Null_Address,                    SELECTOR_KCODE, GATE_32_Trap),      -- Exception_AC
       (Null_Address,                    SELECTOR_KCODE, GATE_32_Trap),      -- Exception_MC
       (Null_Address,                    SELECTOR_KCODE, GATE_32_Trap),      -- Exception_XM
       (Null_Address,                    SELECTOR_KCODE, GATE_32_Trap),      -- Exception_VE
       (Null_Address,                    SELECTOR_KCODE, GATE_32_Trap),      -- Reserved15
       (Null_Address,                    SELECTOR_KCODE, GATE_32_Trap),      -- Reserved16
       (Null_Address,                    SELECTOR_KCODE, GATE_32_Trap),      -- Reserved17
       (Null_Address,                    SELECTOR_KCODE, GATE_32_Trap),      -- Reserved18
       (Null_Address,                    SELECTOR_KCODE, GATE_32_Trap),      -- Reserved19
       (Null_Address,                    SELECTOR_KCODE, GATE_32_Trap),      -- Reserved1a
       (Null_Address,                    SELECTOR_KCODE, GATE_32_Trap),      -- Reserved1b
       (Null_Address,                    SELECTOR_KCODE, GATE_32_Trap),      -- Reserved1c
       (Null_Address,                    SELECTOR_KCODE, GATE_32_Trap),      -- Reserved1d
       (Null_Address,                    SELECTOR_KCODE, GATE_32_Trap),      -- Reserved1e
       (Null_Address,                    SELECTOR_KCODE, GATE_32_Trap),      -- Reserved1f
       (Irq0_Handler'Address,            SELECTOR_KCODE, GATE_32_Interrupt), -- Irq0
       (Irq1_Handler'Address,            SELECTOR_KCODE, GATE_32_Interrupt), -- Irq1
       (Null_Address,                    SELECTOR_KCODE, GATE_32_Interrupt), -- Irq2
       (Irq3_Handler'Address,            SELECTOR_KCODE, GATE_32_Interrupt), -- Irq3
       (Irq4_Handler'Address,            SELECTOR_KCODE, GATE_32_Interrupt), -- Irq4
       (Irq5_Handler'Address,            SELECTOR_KCODE, GATE_32_Interrupt), -- Irq5
       (Irq6_Handler'Address,            SELECTOR_KCODE, GATE_32_Interrupt), -- Irq6
       (Irq7_Handler'Address,            SELECTOR_KCODE, GATE_32_Interrupt), -- Irq7
       (Irq8_Handler'Address,            SELECTOR_KCODE, GATE_32_Interrupt), -- Irq8
       (Irq9_Handler'Address,            SELECTOR_KCODE, GATE_32_Interrupt), -- Irq9
       (Irq10_Handler'Address,           SELECTOR_KCODE, GATE_32_Interrupt), -- Irq10
       (Irq11_Handler'Address,           SELECTOR_KCODE, GATE_32_Interrupt), -- Irq11
       (Irq12_Handler'Address,           SELECTOR_KCODE, GATE_32_Interrupt), -- Irq12
       (Irq13_Handler'Address,           SELECTOR_KCODE, GATE_32_Interrupt), -- Irq13
       (Irq14_Handler'Address,           SELECTOR_KCODE, GATE_32_Interrupt), -- Irq14
       (Irq15_Handler'Address,           SELECTOR_KCODE, GATE_32_Interrupt)  -- Irq15
      );

   String_DIVISION_BY_0        : aliased constant String := "division by 0";
   String_NMI_INTERRUPT        : aliased constant String := "NMI interrupt";
   String_OVERFLOW             : aliased constant String := "overflow";
   String_ARRAY_BOUNDS         : aliased constant String := "array bounds";
   String_INVALID_OPCODE       : aliased constant String := "invalid opcode";
   String_DEVICE_NOT_AVAILABLE : aliased constant String := "device not available";
   String_DOUBLE_FAULT         : aliased constant String := "double fault";
   String_CP_SEGMENT_OVERRUN   : aliased constant String := "coprocessor segment overrun";
   String_INVALID_TSS          : aliased constant String := "invalid TSS";
   String_SEGMENT_NOT_PRESENT  : aliased constant String := "segment not present";
   String_STACK_FAULT          : aliased constant String := "stack fault";
   String_GENERAL_PROTECTION   : aliased constant String := "general protection";
   String_PAGE_FAULT           : aliased constant String := "page fault";
   String_CP_ERROR             : aliased constant String := "coprocessor error";
   String_UNKNOWN              : aliased constant String := "UNKNOWN";

   Message_DIVISION_BY_0        : constant access constant String := String_DIVISION_BY_0'Access;
   Message_NMI_INTERRUPT        : constant access constant String := String_NMI_INTERRUPT'Access;
   Message_OVERFLOW             : constant access constant String := String_OVERFLOW'Access;
   Message_ARRAY_BOUNDS         : constant access constant String := String_ARRAY_BOUNDS'Access;
   Message_INVALID_OPCODE       : constant access constant String := String_INVALID_OPCODE'Access;
   Message_DEVICE_NOT_AVAILABLE : constant access constant String := String_DEVICE_NOT_AVAILABLE'Access;
   Message_DOUBLE_FAULT         : constant access constant String := String_DOUBLE_FAULT'Access;
   Message_CP_SEGMENT_OVERRUN   : constant access constant String := String_CP_SEGMENT_OVERRUN'Access;
   Message_INVALID_TSS          : constant access constant String := String_INVALID_TSS'Access;
   Message_SEGMENT_NOT_PRESENT  : constant access constant String := String_SEGMENT_NOT_PRESENT'Access;
   Message_STACK_FAULT          : constant access constant String := String_STACK_FAULT'Access;
   Message_GENERAL_PROTECTION   : constant access constant String := String_GENERAL_PROTECTION'Access;
   Message_PAGE_FAULT           : constant access constant String := String_PAGE_FAULT'Access;
   Message_CP_ERROR             : constant access constant String := String_CP_ERROR'Access;
   Message_UNKNOWN              : constant access constant String := String_UNKNOWN'Access;

   --========================================================================--
   --                                                                        --
   --                                                                        --
   --                           Package subprograms                          --
   --                                                                        --
   --                                                                        --
   --========================================================================--

   ----------------------------------------------------------------------------
   -- Process
   ----------------------------------------------------------------------------
   procedure Process (
                      Exception_Identifier          : in Exception_Id_Type;
                      Exception_Stack_Frame_Address : in Address
                     ) is
      Exception_Frame : aliased Exception_Stack_Frame_Type with
         Address    => Exception_Stack_Frame_Address,
         Import     => True,
         Convention => Ada;
      Message : access constant String;
   begin
      if Exception_Identifier = Exception_BP then
         -- Console.Print ("BREAKPOINT", NL => True);
         Gdbstub.Enter_Stub (Gdbstub.TARGET_BREAKPOINT, KERNEL_THREAD_ID);
      else
         Console.Print_NewLine;
         Console.Print ("*** EXCEPTION: ");
         case Exception_Identifier is
            when Exception_DE => Message := Message_DIVISION_BY_0;
            when Exception_NN => Message := Message_NMI_INTERRUPT;
            when Exception_OF => Message := Message_OVERFLOW;
            when Exception_BR => Message := Message_ARRAY_BOUNDS;
            when Exception_UD => Message := Message_INVALID_OPCODE;
            when Exception_NM => Message := Message_DEVICE_NOT_AVAILABLE;
            when Exception_DF => Message := Message_DOUBLE_FAULT;
            when Exception_CS => Message := Message_CP_SEGMENT_OVERRUN;
            when Exception_TS => Message := Message_INVALID_TSS;
            when Exception_NP => Message := Message_SEGMENT_NOT_PRESENT;
            when Exception_SS => Message := Message_STACK_FAULT;
            when Exception_GP => Message := Message_GENERAL_PROTECTION;
            when Exception_PF => Message := Message_PAGE_FAULT;
            when Exception_MF => Message := Message_CP_ERROR;
            when others       => Message := Message_UNKNOWN;
         end case;
         Console.Print (Message.all);
         Console.Print_NewLine;
         Console.Print (To_U16 (Exception_Frame.CS), Prefix => "CS:  ", NL => True);
         Console.Print (Exception_Frame.EIP, Prefix => "EIP: ", NL => True);
         System_Abort;
      end if;
   end Process;

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
               -- with IOEMU, you can see the LED blinking
               if Tick_Count mod 1000 = 0 then
                  PC.PPI_ControlOut (16#FF#);
                  PC.PPI_ControlOut (16#00#);
               end if;
            else
               -- with a physical machine, we have to turn on/off the LED at a
               -- "human" rate
               if Tick_Count mod 1000 = 0 then
                  PC.PPI_ControlOut (16#04#);
               end if;
               if (Tick_Count + 500) mod 1000 = 0 then
                  PC.PPI_ControlOut (0);
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

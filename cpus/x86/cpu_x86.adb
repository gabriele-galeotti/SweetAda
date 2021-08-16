-----------------------------------------------------------------------------------------------------------------------
--                                                     SweetAda                                                      --
-----------------------------------------------------------------------------------------------------------------------
-- __HDS__                                                                                                           --
-- __FLN__ cpu_x86.adb                                                                                               --
-- __DSC__                                                                                                           --
-- __HSH__ e69de29bb2d1d6434b8b29ae775ad8c2e48c5391                                                                  --
-- __HDE__                                                                                                           --
-----------------------------------------------------------------------------------------------------------------------
-- Copyright (C) 2020, 2021 Gabriele Galeotti                                                                        --
--                                                                                                                   --
-- SweetAda web page: http://sweetada.org                                                                            --
-- contact address: gabriele.galeotti@sweetada.org                                                                   --
-- This work is licensed under the terms of the MIT License.                                                         --
-- Please consult the LICENSE.txt file located in the top-level directory.                                           --
-----------------------------------------------------------------------------------------------------------------------

with System.Machine_Code;
with LLutils;

package body CPU_x86 is

   --========================================================================--
   --                                                                        --
   --                                                                        --
   --                           Local declarations                           --
   --                                                                        --
   --                                                                        --
   --========================================================================--

   use System.Machine_Code;
   use LLutils;

   CRLF : String renames Definitions.CRLF;

   --========================================================================--
   --                                                                        --
   --                                                                        --
   --                           Package subprograms                          --
   --                                                                        --
   --                                                                        --
   --========================================================================--

   ----------------------------------------------------------------------------
   -- NOP
   ----------------------------------------------------------------------------
   procedure NOP is
   begin
      Asm (
           Template => " nop",
           Outputs  => No_Output_Operands,
           Inputs   => No_Input_Operands,
           Clobber  => "",
           Volatile => True
          );
   end NOP;

   ----------------------------------------------------------------------------
   -- BREAKPOINT
   ----------------------------------------------------------------------------
   procedure BREAKPOINT is
   begin
      Asm (
           Template => " " & BREAKPOINT_Asm_String,
           Outputs  => No_Output_Operands,
           Inputs   => No_Input_Operands,
           Clobber  => "",
           Volatile => True
          );
   end BREAKPOINT;

   ----------------------------------------------------------------------------
   -- ESP_Read
   ----------------------------------------------------------------------------

   function ESP_Read return Address is
      Result : Address;
   begin
      Asm (
           Template => " movl %%esp,%0",
           Outputs  => Address'Asm_Output ("=a", Result),
           Inputs   => No_Input_Operands,
           Clobber  => "",
           Volatile => True
          );
      return Result;
   end ESP_Read;

   ----------------------------------------------------------------------------
   -- CRX registers
   ----------------------------------------------------------------------------

   function CR0_Read return CR0_Register_Type is
      Result : CR0_Register_Type;
   begin
      Asm (
           Template => " movl %%cr0,%0",
           Outputs  => CR0_Register_Type'Asm_Output ("=a", Result),
           Inputs   => No_Input_Operands,
           Clobber  => "",
           Volatile => True
          );
      return Result;
   end CR0_Read;

   procedure CR0_Write (Value : in CR0_Register_Type) is
   begin
      Asm (
           Template => " movl %0,%%cr0",
           Outputs  => No_Output_Operands,
           Inputs   => CR0_Register_Type'Asm_Input ("a", Value),
           Clobber  => "",
           Volatile => True
          );
   end CR0_Write;

   function CR2_Read return Address is
      Result : Address;
   begin
      Asm (
           Template => " movl %%cr2,%0",
           Outputs  => Address'Asm_Output ("=a", Result),
           Inputs   => No_Input_Operands,
           Clobber  => "",
           Volatile => True
          );
      return Result;
   end CR2_Read;

   function CR3_Read return CR3_Register_Type is
      Result : CR3_Register_Type;
   begin
      Asm (
           Template => " movl %%cr3,%0",
           Outputs  => CR3_Register_Type'Asm_Output ("=a", Result),
           Inputs   => No_Input_Operands,
           Clobber  => "",
           Volatile => True
          );
      return Result;
   end CR3_Read;

   procedure CR3_Write (Value : in CR3_Register_Type) is
   begin
      Asm (
           Template => " movl %0,%%cr3",
           Outputs  => No_Output_Operands,
           Inputs   => CR3_Register_Type'Asm_Input ("a", Value),
           Clobber  => "",
           Volatile => True
          );
   end CR3_Write;

   -- 386s do not have CR4

   ----------------------------------------------------------------------------
   -- LGDTR
   ----------------------------------------------------------------------------
   procedure LGDTR (GDT_Descriptor : in GDT_Descriptor_Type; GDT_Code_Selector_Index : in GDT_Index_Type) is
      Selector_Address_Target : aliased Selector_Address_Target_Type;
   begin
      Selector_Address_Target.Selector := (
                                           RPL   => PL0,
                                           TI    => TI_GDT,
                                           Index => Selector_Index_Type (GDT_Code_Selector_Index)
                                          );
      Asm (
           Template => "  lgdtl %0"    & CRLF &
                       "  movl $1f,%2" & CRLF &
                       "  jmpl *%1"    & CRLF &
                       "1:",
           Outputs  => No_Output_Operands,
           Inputs   => (
                        GDT_Descriptor_Type'Asm_Input ("m", GDT_Descriptor),
                        Selector_Address_Target_Type'Asm_Input ("m", Selector_Address_Target),
                        Address'Asm_Input ("m", Selector_Address_Target.Offset)
                       ),
           Clobber  => "",
           Volatile => True
          );
   end LGDTR;

   ----------------------------------------------------------------------------
   -- LIDTR
   ----------------------------------------------------------------------------
   procedure LIDTR (IDT_Descriptor : in IDT_Descriptor_Type) is
   begin
      Asm (
           Template => " lidt %0",
           Outputs  => No_Output_Operands,
           Inputs   => IDT_Descriptor_Type'Asm_Input ("m", IDT_Descriptor),
           Clobber  => "",
           Volatile => True
          );
   end LIDTR;

   ----------------------------------------------------------------------------
   -- GDT_Set
   ----------------------------------------------------------------------------
   -- GDT_Descriptor:          the GDT descriptor to be filled
   -- GDT_Address              address of GDT
   -- GDT_Length               length of GDT (# of entries)
   -- GDT_Code_Selector_Index: target selector of the LGDTR jmp
   ----------------------------------------------------------------------------
   procedure GDT_Set (
                      GDT_Descriptor          : in out GDT_Descriptor_Type;
                      GDT_Address             : in     Address;
                      GDT_Length              : in     GDT_Index_Type;
                      GDT_Code_Selector_Index : in     GDT_Index_Type
                     ) is
      Irq_State : Irq_State_Type;
   begin
      GDT_Descriptor.Base_Low  := Unsigned_16 (Select_Address_Bits (GDT_Address, 0, 15));
      GDT_Descriptor.Base_High := Unsigned_16 (Select_Address_Bits (GDT_Address, 16, 31));
      GDT_Descriptor.Limit     := Unsigned_16 (GDT_Length * (GDT_Descriptor'Size / Storage_Unit) - 1);
      Irq_State := Irq_State_Get;
      LGDTR (GDT_Descriptor, GDT_Code_Selector_Index);
      Irq_State_Set (Irq_State);
   end GDT_Set;

   ----------------------------------------------------------------------------
   -- GDT_Set_Entry
   ----------------------------------------------------------------------------
   procedure GDT_Set_Entry (
                            GDT_Entry   : in out GDT_Entry_Descriptor_Type;
                            Base        : in     Address;
                            Limit       : in     Storage_Offset;
                            Segment     : in     Segment_Gate_Type;
                            Descriptor  : in     Descriptor_Type;
                            DPL         : in     PL_Type;
                            Present     : in     Boolean;
                            D_B         : in     Default_Operand_Size_Type;
                            Granularity : in     Descriptor_Granularity_Type
                           ) is
   begin
      GDT_Entry.Base_Low    := Unsigned_16 (Select_Address_Bits (Base, 0, 15));
      GDT_Entry.Base_Mid    := Unsigned_8 (Select_Address_Bits (Base, 16, 23));
      GDT_Entry.Base_High   := Unsigned_8 (Select_Address_Bits (Base, 24, 31));
      GDT_Entry.Limit_Low   := Unsigned_16 (Unsigned_32 (Limit) and Unsigned_16_Mask);
      GDT_Entry.Limit_High  := Bits_4 (Shift_Right (Unsigned_32 (Limit), 16) and Bits_4_Mask);
      GDT_Entry.Segment     := Segment;
      GDT_Entry.Descriptor  := Descriptor;
      GDT_Entry.DPL         := DPL;
      GDT_Entry.Present     := Present;
      GDT_Entry.AVL         := 0; -- available for use by system software
      GDT_Entry.L           := 0; -- no 64-bit
      GDT_Entry.D_B         := D_B;
      GDT_Entry.Granularity := Granularity;
   end GDT_Set_Entry;

   ----------------------------------------------------------------------------
   -- IDT_Set
   ----------------------------------------------------------------------------
   -- IDT_Descriptor: IDT descriptor to be filled
   -- IDT_Address:    address of IDT
   -- IDT_Length:     length of IDT (# of entries)
   ----------------------------------------------------------------------------
   procedure IDT_Set (
                      IDT_Descriptor : in out IDT_Descriptor_Type;
                      IDT_Address    : in     Address;
                      IDT_Length     : in     IDT_Length_Type
                     ) is
      Irq_State : Irq_State_Type;
   begin
      IDT_Descriptor.Base_Low  := Unsigned_16 (Select_Address_Bits (IDT_Address, 0, 15));
      IDT_Descriptor.Base_High := Unsigned_16 (Select_Address_Bits (IDT_Address, 16, 31));
      IDT_Descriptor.Limit     := Unsigned_16 (IDT_Length * (IDT_Descriptor'Size / Storage_Unit) - 1);
      Irq_State := Irq_State_Get;
      LIDTR (IDT_Descriptor);
      Irq_State_Set (Irq_State);
   end IDT_Set;

   ----------------------------------------------------------------------------
   -- IDT_Set_Handler
   ----------------------------------------------------------------------------
   procedure IDT_Set_Handler (
                              IDT_Entry         : in out IDT_Exception_Descriptor_Type;
                              Exception_Handler : in     Address;
                              Selector          : in     Selector_Type;
                              Gate              : in     Segment_Gate_Type
                             ) is
   begin
      IDT_Entry.Offset_Low  := Unsigned_16 (Select_Address_Bits (Exception_Handler, 0, 15));
      IDT_Entry.Offset_High := Unsigned_16 (Select_Address_Bits (Exception_Handler, 16, 31));
      IDT_Entry.Selector    := Selector;
      IDT_Entry.Reserved    := 0;
      IDT_Entry.Gate        := Gate;
      IDT_Entry.Descriptor  := DESCRIPTOR_SYSTEM;
      IDT_Entry.DPL         := PL0;
      IDT_Entry.Present     := True;
   end IDT_Set_Handler;

   ----------------------------------------------------------------------------
   -- Select Address Bits
   ----------------------------------------------------------------------------

   -- Offset
   function Select_Address_Bits_OFS (CPU_Address : Address) return Bits_12 is
   begin
      return Bits_12 (Select_Address_Bits (CPU_Address, 0, 11));
   end Select_Address_Bits_OFS;

   -- Page Frame Address
   function Select_Address_Bits_PFA (CPU_Address : Address) return Bits_20 is
   begin
      return Bits_20 (Select_Address_Bits (CPU_Address, 12, 31));
   end Select_Address_Bits_PFA;

   -- Page Table Entry
   function Select_Address_Bits_PTE (CPU_Address : Address) return Bits_10 is
   begin
      return Bits_10 (Select_Address_Bits (CPU_Address, 12, 21));
   end Select_Address_Bits_PTE;

   -- Page Directory Entry
   function Select_Address_Bits_PDE (CPU_Address : Address) return Bits_10 is
   begin
      return Bits_10 (Select_Address_Bits (CPU_Address, 22, 31));
   end Select_Address_Bits_PDE;

   ----------------------------------------------------------------------------
   -- Asm_Call
   ----------------------------------------------------------------------------
   procedure Asm_Call (Target_Address : in Address) is
   begin
      Asm (
           Template => " call *%0",
           Outputs  => No_Output_Operands,
           Inputs   => Address'Asm_Input ("r", Target_Address),
           Clobber  => "",
           Volatile => True
          );
   end Asm_Call;

   ----------------------------------------------------------------------------
   -- Irq_Enable/Disable
   ----------------------------------------------------------------------------

   procedure Irq_Enable is
   begin
      Asm (
           Template => " sti",
           Outputs  => No_Output_Operands,
           Inputs   => No_Input_Operands,
           Clobber  => "memory",
           Volatile => True
          );
   end Irq_Enable;

   procedure Irq_Disable is
   begin
      Asm (
           Template => " cli",
           Outputs  => No_Output_Operands,
           Inputs   => No_Input_Operands,
           Clobber  => "memory",
           Volatile => True
          );
   end Irq_Disable;

   function Irq_State_Get return Irq_State_Type is
      Irq_State : Irq_State_Type;
   begin
      Asm (
           Template => " pushfl"  & CRLF &
                       " popl %0",
           Outputs  => Irq_State_Type'Asm_Output ("=a", Irq_State),
           Inputs   => No_Input_Operands,
           Clobber  => "memory",
           Volatile => True
          );
      return Irq_State;
   end Irq_State_Get;

   procedure Irq_State_Set (Irq_State : in Irq_State_Type) is
   begin
      Asm (
           Template => " pushl %0" & CRLF &
                       " popfl",
           Outputs  => No_Output_Operands,
           Inputs   => Irq_State_Type'Asm_Input ("a", Irq_State),
           Clobber  => "memory",
           Volatile => True
          );
   end Irq_State_Set;

   ----------------------------------------------------------------------------
   -- Locking subprograms
   ----------------------------------------------------------------------------

   procedure Lock_Try (Lock_Object : in out Lock_Type; Success : out Boolean) is
      Locked_Item : Lock_Type := (Lock => LOCK_LOCK);
   begin
      Asm (
           Template => " xchgl %0,%1",
           Outputs  => (
                        CPU_Unsigned'Asm_Output ("+r", Locked_Item.Lock),
                        CPU_Unsigned'Asm_Output ("+m", Lock_Object.Lock)
                       ),
           Inputs   => No_Input_Operands,
           Clobber  => "",
           Volatile => True
          );
      Success := Locked_Item.Lock = LOCK_UNLOCK;
   end Lock_Try;

   procedure Lock (Lock_Object : in out Lock_Type) is
      Success : Boolean;
   begin
      loop
         Lock_Try (Lock_Object, Success);
         exit when Success;
      end loop;
   end Lock;

   procedure Unlock (Lock_Object : out Lock_Type) is
   begin
      Lock_Object.Lock := LOCK_UNLOCK;
   end Unlock;

end CPU_x86;

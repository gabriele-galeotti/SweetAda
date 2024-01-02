-----------------------------------------------------------------------------------------------------------------------
--                                                     SweetAda                                                      --
-----------------------------------------------------------------------------------------------------------------------
-- __HDS__                                                                                                           --
-- __FLN__ x86.adb                                                                                                   --
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

with System.Machine_Code;
with LLutils;

package body x86
   is

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
   procedure NOP
      is
   begin
      Asm (
           Template => ""            & CRLF &
                       "        nop" & CRLF &
                       "",
           Outputs  => No_Output_Operands,
           Inputs   => No_Input_Operands,
           Clobber  => "",
           Volatile => True
          );
   end NOP;

   ----------------------------------------------------------------------------
   -- BREAKPOINT
   ----------------------------------------------------------------------------
   procedure BREAKPOINT
      is
   begin
      Asm (
           Template => ""                                 & CRLF &
                       "        " & BREAKPOINT_Asm_String & CRLF &
                       "",
           Outputs  => No_Output_Operands,
           Inputs   => No_Input_Operands,
           Clobber  => "",
           Volatile => True
          );
   end BREAKPOINT;

   ----------------------------------------------------------------------------
   -- ESP_Read
   ----------------------------------------------------------------------------
   function ESP_Read
      return Address
      is
      Result : Address;
   begin
      Asm (
           Template => ""                         & CRLF &
                       "        movl    %%esp,%0" & CRLF &
                       "",
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

   function CR0_Read
      return CR0_Type
      is
      Result : CR0_Type;
   begin
      Asm (
           Template => ""                         & CRLF &
                       "        movl    %%cr0,%0" & CRLF &
                       "",
           Outputs  => CR0_Type'Asm_Output ("=a", Result),
           Inputs   => No_Input_Operands,
           Clobber  => "",
           Volatile => True
          );
      return Result;
   end CR0_Read;

   procedure CR0_Write
      (Value : in CR0_Type)
      is
   begin
      Asm (
           Template => ""                         & CRLF &
                       "        movl    %0,%%cr0" & CRLF &
                       "",
           Outputs  => No_Output_Operands,
           Inputs   => CR0_Type'Asm_Input ("a", Value),
           Clobber  => "",
           Volatile => True
          );
   end CR0_Write;

   function CR2_Read
      return Address
      is
      Result : Address;
   begin
      Asm (
           Template => ""                         & CRLF &
                       "        movl    %%cr2,%0" & CRLF &
                       "",
           Outputs  => Address'Asm_Output ("=a", Result),
           Inputs   => No_Input_Operands,
           Clobber  => "",
           Volatile => True
          );
      return Result;
   end CR2_Read;

   function CR3_Read
      return CR3_Type
      is
      Result : CR3_Type;
   begin
      Asm (
           Template => ""                         & CRLF &
                       "        movl    %%cr3,%0" & CRLF &
                       "",
           Outputs  => CR3_Type'Asm_Output ("=a", Result),
           Inputs   => No_Input_Operands,
           Clobber  => "",
           Volatile => True
          );
      return Result;
   end CR3_Read;

   procedure CR3_Write
      (Value : in CR3_Type)
      is
   begin
      Asm (
           Template => ""                         & CRLF &
                       "        movl    %0,%%cr3" & CRLF &
                       "",
           Outputs  => No_Output_Operands,
           Inputs   => CR3_Type'Asm_Input ("a", Value),
           Clobber  => "",
           Volatile => True
          );
   end CR3_Write;

   -- 386s do not have CR4

   ----------------------------------------------------------------------------
   -- LGDTR
   ----------------------------------------------------------------------------
   procedure LGDTR
      (GDT_Descriptor          : in GDT_Descriptor_Type;
       GDT_Code_Selector_Index : in GDT_Index_Type)
      is
      Selector_Address_Target : aliased Selector_Address_Target_Type;
   begin
      Selector_Address_Target.Selector := (
         RPL   => PL0,
         TI    => TI_GDT,
         Index => Selector_Index_Type (GDT_Code_Selector_Index)
         );
      Asm (
           Template => ""                       & CRLF &
                       "        lgdtl   %0    " & CRLF &
                       "        movl    $1f,%2" & CRLF &
                       "        jmpl    *%1   " & CRLF &
                       "1:                    " & CRLF &
                       "",
           Outputs  => No_Output_Operands,
           Inputs   => [
                        GDT_Descriptor_Type'Asm_Input ("m", GDT_Descriptor),
                        Selector_Address_Target_Type'Asm_Input ("m", Selector_Address_Target),
                        Address'Asm_Input ("m", Selector_Address_Target.Offset)
                       ],
           Clobber  => "",
           Volatile => True
          );
   end LGDTR;

   ----------------------------------------------------------------------------
   -- LIDTR
   ----------------------------------------------------------------------------
   procedure LIDTR
      (IDT_Descriptor : in IDT_Descriptor_Type)
      is
   begin
      Asm (
           Template => ""                   & CRLF &
                       "        lidt    %0" & CRLF &
                       "",
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
   procedure GDT_Set
      (GDT_Descriptor          : in out GDT_Descriptor_Type;
       GDT_Address             : in     Address;
       GDT_Length              : in     GDT_Index_Type;
       GDT_Code_Selector_Index : in     GDT_Index_Type)
      is
      Irq_State : Irq_State_Type;
   begin
      GDT_Descriptor.Base_LO := Unsigned_16 (Select_Address_Bits (GDT_Address, 0, 15));
      GDT_Descriptor.Base_HI := Unsigned_16 (Select_Address_Bits (GDT_Address, 16, 31));
      GDT_Descriptor.Limit   := Unsigned_16 (GDT_Length * (GDT_Descriptor'Size / Storage_Unit) - 1);
      Irq_State := Irq_State_Get;
      LGDTR (GDT_Descriptor, GDT_Code_Selector_Index);
      Irq_State_Set (Irq_State);
   end GDT_Set;

   ----------------------------------------------------------------------------
   -- GDT_Set_Entry
   ----------------------------------------------------------------------------
   procedure GDT_Set_Entry
      (GDT_Entry : in out Segment_Descriptor_Type;
       Base      : in     Address;
       Limit     : in     Storage_Offset;
       SegType   : in     Segment_Gate_Type;
       S         : in     Descriptor_Type;
       DPL       : in     PL_Type;
       P         : in     Boolean;
       D_B       : in     Default_OpSize_Type;
       G         : in     Granularity_Type)
      is
   begin
      GDT_Entry.Limit_LO := Unsigned_16 (Unsigned_32 (Limit) and Unsigned_16_Mask);
      GDT_Entry.Base_LO  := Unsigned_16 (Select_Address_Bits (Base, 0, 15));
      GDT_Entry.Base_MI  := Unsigned_8 (Select_Address_Bits (Base, 16, 23));
      GDT_Entry.SegType  := SegType;
      GDT_Entry.S        := S;
      GDT_Entry.DPL      := DPL;
      GDT_Entry.P        := P;
      GDT_Entry.Limit_HI := Bits_4 (Shift_Right (Unsigned_32 (Limit), 16) and Bits_4_Mask);
      GDT_Entry.AVL      := 0;
      GDT_Entry.L        := False;
      GDT_Entry.D_B      := D_B;
      GDT_Entry.G        := G;
      GDT_Entry.Base_HI  := Unsigned_8 (Select_Address_Bits (Base, 24, 31));
   end GDT_Set_Entry;

   ----------------------------------------------------------------------------
   -- IDT_Set
   ----------------------------------------------------------------------------
   -- IDT_Descriptor: IDT descriptor to be filled
   -- IDT_Address:    address of IDT
   -- IDT_Length:     length of IDT (# of entries)
   ----------------------------------------------------------------------------
   procedure IDT_Set
      (IDT_Descriptor : in out IDT_Descriptor_Type;
       IDT_Address    : in     Address;
       IDT_Length     : in     IDT_Length_Type)
      is
      Irq_State : Irq_State_Type;
   begin
      IDT_Descriptor.Base_LO := Unsigned_16 (Select_Address_Bits (IDT_Address, 0, 15));
      IDT_Descriptor.Base_HI := Unsigned_16 (Select_Address_Bits (IDT_Address, 16, 31));
      IDT_Descriptor.Limit   := Unsigned_16 (IDT_Length * (Exception_Descriptor_Type'Size / Storage_Unit) - 1);
      Irq_State := Irq_State_Get;
      LIDTR (IDT_Descriptor);
      Irq_State_Set (Irq_State);
   end IDT_Set;

   ----------------------------------------------------------------------------
   -- IDT_Set_Handler
   ----------------------------------------------------------------------------
   procedure IDT_Set_Handler
      (IDT_Entry         : in out Exception_Descriptor_Type;
       Exception_Handler : in     Address;
       Selector          : in     Selector_Type;
       SegType           : in     Segment_Gate_Type)
      is
   begin
      IDT_Entry.Offset_LO := Unsigned_16 (Select_Address_Bits (Exception_Handler, 0, 15));
      IDT_Entry.Selector  := Selector;
      IDT_Entry.SegType   := SegType;
      IDT_Entry.DPL       := PL0;
      IDT_Entry.P         := True;
      IDT_Entry.Offset_HI := Unsigned_16 (Select_Address_Bits (Exception_Handler, 16, 31));
   end IDT_Set_Handler;

   ----------------------------------------------------------------------------
   -- Select Address Bits
   ----------------------------------------------------------------------------

   -- Offset
   function Select_Address_Bits_OFS
      (CPU_Address : Address)
      return Bits_12
      is
   begin
      return Bits_12 (Select_Address_Bits (CPU_Address, 0, 11));
   end Select_Address_Bits_OFS;

   -- Page Frame Address
   function Select_Address_Bits_PFA
      (CPU_Address : Address)
      return Bits_20
      is
   begin
      return Bits_20 (Select_Address_Bits (CPU_Address, 12, 31));
   end Select_Address_Bits_PFA;

   -- Page Table Entry
   function Select_Address_Bits_PTE
      (CPU_Address : Address)
      return Bits_10
      is
   begin
      return Bits_10 (Select_Address_Bits (CPU_Address, 12, 21));
   end Select_Address_Bits_PTE;

   -- Page Directory Entry
   function Select_Address_Bits_PDE
      (CPU_Address : Address)
      return Bits_10
      is
   begin
      return Bits_10 (Select_Address_Bits (CPU_Address, 22, 31));
   end Select_Address_Bits_PDE;

   ----------------------------------------------------------------------------
   -- Asm_Call
   ----------------------------------------------------------------------------
   procedure Asm_Call
      (Target_Address : in Address)
      is
   begin
      Asm (
           Template => ""                    & CRLF &
                       "        call    *%0" & CRLF &
                       "",
           Outputs  => No_Output_Operands,
           Inputs   => Address'Asm_Input ("r", Target_Address),
           Clobber  => "",
           Volatile => True
          );
   end Asm_Call;

   ----------------------------------------------------------------------------
   -- Irq_Enable/Disable
   ----------------------------------------------------------------------------

   procedure Irq_Enable
      is
   begin
      Asm (
           Template => ""            & CRLF &
                       "        sti" & CRLF &
                       "",
           Outputs  => No_Output_Operands,
           Inputs   => No_Input_Operands,
           Clobber  => "memory",
           Volatile => True
          );
   end Irq_Enable;

   procedure Irq_Disable
      is
   begin
      Asm (
           Template => ""            & CRLF &
                       "        cli" & CRLF &
                       "",
           Outputs  => No_Output_Operands,
           Inputs   => No_Input_Operands,
           Clobber  => "memory",
           Volatile => True
          );
   end Irq_Disable;

   function Irq_State_Get
      return Irq_State_Type
      is
      Irq_State : Irq_State_Type;
   begin
      Asm (
           Template => ""                   & CRLF &
                       "        pushfl    " & CRLF &
                       "        popl    %0" & CRLF &
                       "",
           Outputs  => Irq_State_Type'Asm_Output ("=rm", Irq_State),
           Inputs   => No_Input_Operands,
           Clobber  => "memory",
           Volatile => True
          );
      return Irq_State;
   end Irq_State_Get;

   procedure Irq_State_Set
      (Irq_State : in Irq_State_Type)
      is
   begin
      Asm (
           Template => ""                   & CRLF &
                       "        pushl   %0" & CRLF &
                       "        popfl     " & CRLF &
                       "",
           Outputs  => No_Output_Operands,
           Inputs   => Irq_State_Type'Asm_Input ("g", Irq_State),
           Clobber  => "memory,cc",
           Volatile => True
          );
   end Irq_State_Set;

end x86;

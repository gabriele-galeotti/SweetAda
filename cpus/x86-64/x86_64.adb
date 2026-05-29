-----------------------------------------------------------------------------------------------------------------------
--                                                     SweetAda                                                      --
-----------------------------------------------------------------------------------------------------------------------
-- __HDS__                                                                                                           --
-- __FLN__ x86_64.adb                                                                                                --
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

pragma Restrictions (No_Elaboration_Code);

with System.Machine_Code;
with Ada.Unchecked_Conversion;
with Definitions;
with LLutils;

package body x86_64
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
   -- CRx registers
   ----------------------------------------------------------------------------

   function CR0_Read
      return CR0_Type
      is
      Result : CR0_Type;
   begin
      Asm (
           Template => ""                         & CRLF &
                       "        movq    %%cr0,%0" & CRLF &
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
                       "        movq    %0,%%cr0" & CRLF &
                       "",
           Outputs  => No_Output_Operands,
           Inputs   => CR0_Type'Asm_Input ("a", Value),
           Clobber  => "",
           Volatile => True
          );
   end CR0_Write;

   function CR1_Read
      return CR1_Type
      is
      Result : CR1_Type;
   begin
      Asm (
           Template => ""                         & CRLF &
                       "        movq    %%cr1,%0" & CRLF &
                       "",
           Outputs  => CR1_Type'Asm_Output ("=a", Result),
           Inputs   => No_Input_Operands,
           Clobber  => "",
           Volatile => True
          );
      return Result;
   end CR1_Read;

   procedure CR1_Write
      (Value : in CR1_Type)
      is
   begin
      Asm (
           Template => ""                         & CRLF &
                       "        movq    %0,%%cr1" & CRLF &
                       "",
           Outputs  => No_Output_Operands,
           Inputs   => CR1_Type'Asm_Input ("a", Value),
           Clobber  => "",
           Volatile => True
          );
   end CR1_Write;

   function CR2_Read
      return CR2_Type
      is
      Result : CR2_Type;
   begin
      Asm (
           Template => ""                         & CRLF &
                       "        movq    %%cr2,%0" & CRLF &
                       "",
           Outputs  => CR2_Type'Asm_Output ("=a", Result),
           Inputs   => No_Input_Operands,
           Clobber  => "",
           Volatile => True
          );
      return Result;
   end CR2_Read;

   procedure CR2_Write
      (Value : in CR2_Type)
      is
   begin
      Asm (
           Template => ""                         & CRLF &
                       "        movq    %0,%%cr2" & CRLF &
                       "",
           Outputs  => No_Output_Operands,
           Inputs   => CR2_Type'Asm_Input ("a", Value),
           Clobber  => "",
           Volatile => True
          );
   end CR2_Write;

   function CR3_Read
      return CR3_Type
      is
      Result : CR3_Type;
   begin
      Asm (
           Template => ""                         & CRLF &
                       "        movq    %%cr3,%0" & CRLF &
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
                       "        movq    %0,%%cr3" & CRLF &
                       "",
           Outputs  => No_Output_Operands,
           Inputs   => CR3_Type'Asm_Input ("a", Value),
           Clobber  => "",
           Volatile => True
          );
   end CR3_Write;

   function CR4_Read
      return CR4_Type
      is
      Result : CR4_Type;
   begin
      Asm (
           Template => ""                         & CRLF &
                       "        movq    %%cr4,%0" & CRLF &
                       "",
           Outputs  => CR4_Type'Asm_Output ("=a", Result),
           Inputs   => No_Input_Operands,
           Clobber  => "",
           Volatile => True
          );
      return Result;
   end CR4_Read;

   procedure CR4_Write
      (Value : in CR4_Type)
      is
   begin
      Asm (
           Template => ""                         & CRLF &
                       "        movq    %0,%%cr4" & CRLF &
                       "",
           Outputs  => No_Output_Operands,
           Inputs   => CR4_Type'Asm_Input ("a", Value),
           Clobber  => "",
           Volatile => True
          );
   end CR4_Write;

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
      Intcontext : Intcontext_Type;
   begin
      IDT_Descriptor.Base_LO := Unsigned_16 (Select_Address_Bits (IDT_Address, 0, 15));
      IDT_Descriptor.Base_MI := Unsigned_16 (Select_Address_Bits (IDT_Address, 16, 31));
      IDT_Descriptor.Base_HI := Unsigned_32 (Select_Address_Bits (IDT_Address, 32, 63));
      IDT_Descriptor.Limit   := Unsigned_16 (IDT_Length * IDT_Descriptor'Size - 1);
      Intcontext_Get (Intcontext);
      LIDTR (IDT_Descriptor);
      Intcontext_Set (Intcontext);
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
      IDT_Entry.Offset_MI := Unsigned_16 (Select_Address_Bits (Exception_Handler, 16, 31));
      IDT_Entry.Offset_HI := Unsigned_32 (Select_Address_Bits (Exception_Handler, 32, 63));
   end IDT_Set_Handler;

   ----------------------------------------------------------------------------
   -- LTR
   ----------------------------------------------------------------------------
   procedure LTR
      (Selector : in Selector_Type)
      is
   begin
      Asm (
           Template => ""                   & CRLF &
                       "        ltr     %0" & CRLF &
                       "",
           Outputs  => No_Output_Operands,
           Inputs   => Selector_Type'Asm_Input ("r", Selector),
           Clobber  => "",
           Volatile => True
          );
   end LTR;

   ---------------------------------------------------------------------------
   -- RDTSC
   ---------------------------------------------------------------------------
   function RDTSC
      return Unsigned_64
      is
      EAX : Unsigned_32;
      EDX : Unsigned_32;
   begin
      Asm (
           Template => ""              & CRLF &
                       "        rdtsc" & CRLF &
                       "",
           Outputs  => [
                        Unsigned_32'Asm_Output ("=a", EAX),
                        Unsigned_32'Asm_Output ("=d", EDX)
                       ],
           Inputs   => No_Input_Operands,
           Clobber  => "",
           Volatile => True
          );
      return Make_Word (EDX, EAX);
   end RDTSC;

   ----------------------------------------------------------------------------
   -- RDMSR/WRMSR
   ----------------------------------------------------------------------------

   function RDMSR
      (MSR : MSR_Type)
      return Unsigned_64
      is
      Result : Unsigned_64;
   begin
      Asm (
           Template => ""              & CRLF &
                       "        rdmsr" & CRLF &
                       "",
           Outputs  => Unsigned_64'Asm_Output ("=A", Result),
           Inputs   => MSR_Type'Asm_Input ("c", MSR),
           Clobber  => "",
           Volatile => True
          );
      return Result;
   end RDMSR;

   procedure WRMSR
      (MSR   : in MSR_Type;
       Value : in Unsigned_64)
      is
   begin
      Asm (
           Template => ""              & CRLF &
                       "        wrmsr" & CRLF &
                       "",
           Outputs  => No_Output_Operands,
           Inputs   => [
                        Unsigned_64'Asm_Input ("A", Value),
                        MSR_Type'Asm_Input ("c", MSR)
                       ],
           Clobber  => "",
           Volatile => True
          );
   end WRMSR;

   ----------------------------------------------------------------------------
   -- IA32_APIC_BASE
   ----------------------------------------------------------------------------

   function IA32_APIC_BASE_Read
      return IA32_APIC_BASE_Type
      is
      function Convert is new Ada.Unchecked_Conversion (Unsigned_64, IA32_APIC_BASE_Type);
   begin
      return Convert (RDMSR (IA32_APIC_BASE));
   end IA32_APIC_BASE_Read;

   procedure IA32_APIC_BASE_Write
      (Value : in IA32_APIC_BASE_Type)
      is
      function Convert is new Ada.Unchecked_Conversion (IA32_APIC_BASE_Type, Unsigned_64);
   begin
      WRMSR (IA32_APIC_BASE, Convert (Value));
   end IA32_APIC_BASE_Write;

   ----------------------------------------------------------------------------
   -- IA32_EFER
   ----------------------------------------------------------------------------

   function IA32_EFER_Read
      return IA32_EFER_Type
      is
      function Convert is new Ada.Unchecked_Conversion (Unsigned_64, IA32_EFER_Type);
   begin
      return Convert (RDMSR (IA32_EFER));
   end IA32_EFER_Read;

   procedure IA32_EFER_Write
      (Value : in IA32_EFER_Type)
      is
      function Convert is new Ada.Unchecked_Conversion (IA32_EFER_Type, Unsigned_64);
   begin
      WRMSR (IA32_EFER, Convert (Value));
   end IA32_EFER_Write;

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
   -- HLT
   ----------------------------------------------------------------------------
   procedure HLT
      is
   begin
      Asm (
           Template => ""            & CRLF &
                       "        hlt" & CRLF &
                       "",
           Outputs  => No_Output_Operands,
           Inputs   => No_Input_Operands,
           Clobber  => "memory",
           Volatile => True
          );
   end HLT;

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
   -- Intcontext_Get
   ----------------------------------------------------------------------------
   procedure Intcontext_Get
      (Intcontext : out Intcontext_Type)
      is
   begin
      Asm (
           Template => ""                   & CRLF &
                       "        pushfq    " & CRLF &
                       "        popq    %0" & CRLF &
                       "",
           Outputs  => Intcontext_Type'Asm_Output ("=a", Intcontext),
           Inputs   => No_Input_Operands,
           Clobber  => "memory",
           Volatile => True
          );
   end Intcontext_Get;

   ----------------------------------------------------------------------------
   -- Intcontext_Set
   ----------------------------------------------------------------------------
   procedure Intcontext_Set
      (Intcontext : in Intcontext_Type)
      is
   begin
      Asm (
           Template => ""                   & CRLF &
                       "        pushq   %0" & CRLF &
                       "        popfq     " & CRLF &
                       "",
           Outputs  => No_Output_Operands,
           Inputs   => Intcontext_Type'Asm_Input ("a", Intcontext),
           Clobber  => "memory,cc",
           Volatile => True
          );
   end Intcontext_Set;

   ----------------------------------------------------------------------------
   -- Irq_Enable
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

   ----------------------------------------------------------------------------
   -- Irq_Disable
   ----------------------------------------------------------------------------
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

end x86_64;

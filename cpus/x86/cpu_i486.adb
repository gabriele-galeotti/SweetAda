-----------------------------------------------------------------------------------------------------------------------
--                                                     SweetAda                                                      --
-----------------------------------------------------------------------------------------------------------------------
-- __HDS__                                                                                                           --
-- __FLN__ cpu_i486.adb                                                                                              --
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

with System.Machine_Code;
with Definitions;

package body CPU_i486 is

   --========================================================================--
   --                                                                        --
   --                                                                        --
   --                           Local declarations                           --
   --                                                                        --
   --                                                                        --
   --========================================================================--

   use System.Machine_Code;

   CRLF : String renames Definitions.CRLF;

   --========================================================================--
   --                                                                        --
   --                                                                        --
   --                           Package subprograms                          --
   --                                                                        --
   --                                                                        --
   --========================================================================--

   ----------------------------------------------------------------------------
   -- CR4 register handling
   ----------------------------------------------------------------------------

   function CR4_Read return CR4_Register_Type is
      Result : CR4_Register_Type;
   begin
      Asm (
           Template => ""                         & CRLF &
                       "        movl    %%cr4,%0" & CRLF &
                       "",
           Outputs  => CR4_Register_Type'Asm_Output ("=a", Result),
           Inputs   => No_Input_Operands,
           Clobber  => "",
           Volatile => True
          );
      return Result;
   end CR4_Read;

   procedure CR4_Write (Value : in CR4_Register_Type) is
   begin
      Asm (
           Template => ""                         & CRLF &
                       "        movl    %0,%%cr4" & CRLF &
                       "",
           Outputs  => No_Output_Operands,
           Inputs   => CR4_Register_Type'Asm_Input ("a", Value),
           Clobber  => "",
           Volatile => True
          );
   end CR4_Write;

   ----------------------------------------------------------------------------
   -- CPUID_Enabled
   ----------------------------------------------------------------------------
   function CPUID_Enabled return Boolean is
      Result : Unsigned_32;
   begin
      Asm (
           Template => ""                                    & CRLF &
                       "        pushfl                     " & CRLF & -- save EFLAGS
                       "        pushfl                     " & CRLF & -- store EFLAGS
                       "        xorl    $0x00200000,(%%esp)" & CRLF & -- invert ID in stored EFLAGS
                       "        popfl                      " & CRLF & -- load stored EFLAGS (with ID inverted)
                       "        pushfl                     " & CRLF & -- store EFLAGS again (ID may or may not be inverted)
                       "        popl    %%eax              " & CRLF & -- EAX = changed EFLAGS (ID may or may not be inverted)
                       "        xorl    (%%esp),%%eax      " & CRLF & -- EAX = whichever bits were changed
                       "        popfl                      " & CRLF & -- restore original EFLAGS
                       "        andl    $0x00200000,%%eax  " & CRLF & -- EAX = zero if ID cannot be changed, else non-zero
                       "",
           Outputs  => Unsigned_32'Asm_Output ("=a", Result),
           Inputs   => No_Input_Operands,
           Clobber  => "",
           Volatile => True
          );
      if Result = 0 then
         return False;
      else
         return True;
      end if;
   end CPUID_Enabled;

   ----------------------------------------------------------------------------
   -- CPU_VendorID_Read
   ----------------------------------------------------------------------------
   function CPU_VendorID_Read return CPUID_VendorID_String_Type is
      Result       : aliased CPUID_VendorID_String_Type;
      EBX_Register : aliased Unsigned_32;
      for EBX_Register'Address use Result (1)'Address;
      EDX_Register : aliased Unsigned_32;
      for EDX_Register'Address use Result (5)'Address;
      ECX_Register : aliased Unsigned_32;
      for ECX_Register'Address use Result (9)'Address;
   begin
      Asm (
           Template => ""              & CRLF &
                       "        cpuid" & CRLF &
                       "",
           Outputs  => (
                        Unsigned_32'Asm_Output ("=b", EBX_Register),
                        Unsigned_32'Asm_Output ("=d", EDX_Register),
                        Unsigned_32'Asm_Output ("=c", ECX_Register)
                       ),
           Inputs   => Unsigned_32'Asm_Input ("a", 0), -- CPUID request #0
           Clobber  => "",
           Volatile => True
          );
      return Result;
   end CPU_VendorID_Read;

   ----------------------------------------------------------------------------
   -- CPU_Features_Read
   ----------------------------------------------------------------------------
   -- EAX=1 returns CPUs stepping, model, and family information in EAX,
   -- feature flags in EDX and ECX, and additional feature info in EBX.
   ----------------------------------------------------------------------------
   function CPU_Features_Read return CPU_Features_Type is
      Result : CPU_Features_Type;
   begin
      Asm (
           Template => ""              & CRLF &
                       "        cpuid" & CRLF &
                       "",
           Outputs  => CPU_Features_Type'Asm_Output ("=d", Result),
           Inputs   => Unsigned_32'Asm_Input ("a", 1), -- CPUID request #1
           Clobber  => "ebx,ecx",
           Volatile => True
          );
      return Result;
   end CPU_Features_Read;

end CPU_i486;

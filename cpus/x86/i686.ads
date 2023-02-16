-----------------------------------------------------------------------------------------------------------------------
--                                                     SweetAda                                                      --
-----------------------------------------------------------------------------------------------------------------------
-- __HDS__                                                                                                           --
-- __FLN__ i686.ads                                                                                                  --
-- __DSC__                                                                                                           --
-- __HSH__ e69de29bb2d1d6434b8b29ae775ad8c2e48c5391                                                                  --
-- __HDE__                                                                                                           --
-----------------------------------------------------------------------------------------------------------------------
-- Copyright (C) 2020-2023 Gabriele Galeotti                                                                         --
--                                                                                                                   --
-- SweetAda web page: http://sweetada.org                                                                            --
-- contact address: gabriele.galeotti@sweetada.org                                                                   --
-- This work is licensed under the terms of the MIT License.                                                         --
-- Please consult the LICENSE.txt file located in the top-level directory.                                           --
-----------------------------------------------------------------------------------------------------------------------

with Interfaces;
with Bits;
with x86;
with i586;

package i686 is

   --========================================================================--
   --                                                                        --
   --                                                                        --
   --                               Public part                              --
   --                                                                        --
   --                                                                        --
   --========================================================================--

   use Interfaces;
   use Bits;
   use x86;

   ----------------------------------------------------------------------------
   -- import i586 items
   ----------------------------------------------------------------------------

   subtype CR4_Type is i586.CR4_Type;

   function CR4_Read return CR4_Type         renames i586.CR4_Read;
   procedure CR4_Write (Value : in CR4_Type) renames i586.CR4_Write;

   function CPUID_Enabled return Boolean renames i586.CPUID_Enabled;

   subtype CPUID_VendorID_String_Type is i586.CPUID_VendorID_String_Type;

   function CPU_VendorID_Read return CPUID_VendorID_String_Type renames i586.CPU_VendorID_Read;

   subtype CPU_Features_Type is i586.CPU_Features_Type;

   function CPU_Features_Read return CPU_Features_Type renames i586.CPU_Features_Read;

   subtype PD4M_Type is i586.PD4M_Type;

   subtype MSR_Type is i586.MSR_Type;

   IA32_TIME_STAMP_COUNTER : MSR_Type renames i586.IA32_TIME_STAMP_COUNTER;
   IA32_APIC_BASE          : MSR_Type renames i586.IA32_APIC_BASE;

   function RDMSR (MSR_Register_Number : MSR_Type) return Unsigned_64          renames i586.RDMSR;
   procedure WRMSR (MSR_Register_Number : in MSR_Type; Value : in Unsigned_64) renames i586.WRMSR;

   function RDTSC return Unsigned_64 renames i586.RDTSC;

end i686;

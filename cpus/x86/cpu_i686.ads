-----------------------------------------------------------------------------------------------------------------------
--                                                     SweetAda                                                      --
-----------------------------------------------------------------------------------------------------------------------
-- __HDS__                                                                                                           --
-- __FLN__ cpu_i686.ads                                                                                              --
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

with Interfaces;
with Bits;
with CPU_x86;
with CPU_i586;

package CPU_i686 is

   --========================================================================--
   --                                                                        --
   --                                                                        --
   --                               Public part                              --
   --                                                                        --
   --                                                                        --
   --========================================================================--

   use Interfaces;
   use Bits;
   use CPU_x86;

   ----------------------------------------------------------------------------
   -- import i586 items
   ----------------------------------------------------------------------------

   subtype CR4_Register_Type is CPU_i586.CR4_Register_Type;

   function CR4_Read return CR4_Register_Type         renames CPU_i586.CR4_Read;
   procedure CR4_Write (Value : in CR4_Register_Type) renames CPU_i586.CR4_Write;

   function CPUID_Enabled return Boolean renames CPU_i586.CPUID_Enabled;

   subtype CPUID_VendorID_String_Type is CPU_i586.CPUID_VendorID_String_Type;

   function CPU_VendorID_Read return CPUID_VendorID_String_Type renames CPU_i586.CPU_VendorID_Read;

   subtype CPU_Features_Type is CPU_i586.CPU_Features_Type;

   function CPU_Features_Read return CPU_Features_Type renames CPU_i586.CPU_Features_Read;

   subtype PD4M_Type is CPU_i586.PD4M_Type;

   subtype MSR_Type is CPU_i586.MSR_Type;

   MSR_TSC      : constant MSR_Type := CPU_i586.MSR_TSC;
   MSR_APICBASE : constant MSR_Type := CPU_i586.MSR_APICBASE;

   subtype APICBASE_Type is CPU_i586.APICBASE_Type;

   function RDMSR (MSR_Register_Number : MSR_Type) return Unsigned_64          renames CPU_i586.RDMSR;
   procedure WRMSR (MSR_Register_Number : in MSR_Type; Value : in Unsigned_64) renames CPU_i586.WRMSR;

   function RDTSC return Unsigned_64 renames CPU_i586.RDTSC;

   procedure Dummy;

private

   --========================================================================--
   --                                                                        --
   --                                                                        --
   --                              Private part                              --
   --                                                                        --
   --                                                                        --
   --========================================================================--

   pragma Inline (CR4_Read);
   pragma Inline (CR4_Write);

   pragma Inline (CPUID_Enabled);
   pragma Inline (CPU_Features_Read);
   pragma Inline (CPU_VendorID_Read);

   pragma Inline (RDMSR);
   pragma Inline (WRMSR);
   pragma Inline (RDTSC);

end CPU_i686;

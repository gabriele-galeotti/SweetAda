-----------------------------------------------------------------------------------------------------------------------
--                                                     SweetAda                                                      --
-----------------------------------------------------------------------------------------------------------------------
-- __HDS__                                                                                                           --
-- __FLN__ i586.ads                                                                                                  --
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

with System;
with Interfaces;
with Bits;
with x86;
with i486;

package i586
   with Preelaborate => True
   is

   --========================================================================--
   --                                                                        --
   --                                                                        --
   --                               Public part                              --
   --                                                                        --
   --                                                                        --
   --========================================================================--

   use System;
   use Interfaces;
   use Bits;
   use x86;

   ----------------------------------------------------------------------------
   -- import i486 items
   ----------------------------------------------------------------------------

   subtype CR4_Type is i486.CR4_Type;

   function CR4_Read return CR4_Type         renames i486.CR4_Read;
   procedure CR4_Write (Value : in CR4_Type) renames i486.CR4_Write;

   function CPUID_Enabled return Boolean renames i486.CPUID_Enabled;

   subtype CPUID_VendorID_String_Type is i486.CPUID_VendorID_String_Type;

   function CPU_VendorID_Read return CPUID_VendorID_String_Type renames i486.CPU_VendorID_Read;

   subtype CPU_Features_Type is i486.CPU_Features_Type;

   function CPU_Features_Read return CPU_Features_Type renames i486.CPU_Features_Read;

   ----------------------------------------------------------------------------
   -- Page directory (4M)
   ----------------------------------------------------------------------------

   type PD4M_Type is array (0 .. 2**10 - 1) of PDEntry_Type (PAGESELECT4M)
      with Pack                    => True,
           Alignment               => PAGESIZE4k,
           Suppress_Initialization => True;

   ----------------------------------------------------------------------------
   -- MSRs
   ----------------------------------------------------------------------------

   type MSR_Type is new Unsigned_32;

   IA32_TIME_STAMP_COUNTER : constant MSR_Type := 16#0000_0010#;
   IA32_APIC_BASE          : constant MSR_Type := 16#0000_001B#;

   -- IA32_APIC_BASE

   type IA32_APIC_BASE_Type is record
      Reserved1          : Bits_8;
      BSP                : Boolean; -- Indicates if the processor is the bootstrap processor (BSP).
      Reserved2          : Bits_1;
      Enable_x2APIC_mode : Boolean;
      APIC_Global_Enable : Boolean; -- Enables or disables the local APIC
      APIC_Base          : Bits_24; -- Specifies the base address of the APIC registers.
      Reserved3          : Bits_28;
   end record
      with Bit_Order => Low_Order_First,
           Size      => 64;
   for IA32_APIC_BASE_Type use record
      Reserved1          at 0 range  0 ..  7;
      BSP                at 0 range  8 ..  8;
      Reserved2          at 0 range  9 ..  9;
      Enable_x2APIC_mode at 0 range 10 .. 10;
      APIC_Global_Enable at 0 range 11 .. 11;
      APIC_Base          at 0 range 12 .. 35;
      Reserved3          at 0 range 36 .. 63;
   end record;

   function To_U64
      (APIC_Base : IA32_APIC_BASE_Type)
      return Unsigned_64
      with Inline => True;
   function To_IA32_APIC_BASE
      (Value : Unsigned_64)
      return IA32_APIC_BASE_Type
      with Inline => True;

   -- subprograms

   function RDMSR
      (MSR_Register_Number : MSR_Type)
      return Unsigned_64
      with Inline => True;
   procedure WRMSR
      (MSR_Register_Number : in MSR_Type;
       Value               : in Unsigned_64)
      with Inline => True;
   function RDTSC
      return Unsigned_64
      with Inline => True;

end i586;

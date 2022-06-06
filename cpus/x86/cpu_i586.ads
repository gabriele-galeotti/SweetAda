-----------------------------------------------------------------------------------------------------------------------
--                                                     SweetAda                                                      --
-----------------------------------------------------------------------------------------------------------------------
-- __HDS__                                                                                                           --
-- __FLN__ cpu_i586.ads                                                                                              --
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

with System;
with Interfaces;
with Bits;
with CPU_x86;
with CPU_i486;

package CPU_i586 is

   --========================================================================--
   --                                                                        --
   --                                                                        --
   --                               Public part                              --
   --                                                                        --
   --                                                                        --
   --========================================================================--

   pragma Preelaborate;

   use System;
   use Interfaces;
   use Bits;
   use CPU_x86;

   ----------------------------------------------------------------------------
   -- import i486 items
   ----------------------------------------------------------------------------

   subtype CR4_Type is CPU_i486.CR4_Type;

   function CR4_Read return CR4_Type         renames CPU_i486.CR4_Read;
   procedure CR4_Write (Value : in CR4_Type) renames CPU_i486.CR4_Write;

   function CPUID_Enabled return Boolean renames CPU_i486.CPUID_Enabled;

   subtype CPUID_VendorID_String_Type is CPU_i486.CPUID_VendorID_String_Type;

   function CPU_VendorID_Read return CPUID_VendorID_String_Type renames CPU_i486.CPU_VendorID_Read;

   subtype CPU_Features_Type is CPU_i486.CPU_Features_Type;

   function CPU_Features_Read return CPU_Features_Type renames CPU_i486.CPU_Features_Read;

   ----------------------------------------------------------------------------
   -- Page directory (4M)
   ----------------------------------------------------------------------------

   type PD4M_Type is array (0 .. 2**10 - 1) of PDEntry_Type (PAGESELECT4M) with
      Pack                    => True,
      Alignment               => PAGESIZE4k,
      Suppress_Initialization => True;

   ----------------------------------------------------------------------------
   -- RDMSR/WRMSR/RDTSC
   ----------------------------------------------------------------------------
   -- http://www.cs.inf.ethz.ch/stricker/lab/doc/intel-part4.pdf
   ----------------------------------------------------------------------------

   type MSR_Type is new Unsigned_32;

   MSR_TSC      : constant MSR_Type := 16#0000_0010#;
   MSR_APICBASE : constant MSR_Type := 16#0000_001B#;

   type APICBASE_Type is
   record
      Reserved1 : Bits_8_Zeroes;
      BSP       : Boolean;
      Reserved2 : Bits_1_Zeroes;
      ENABLE    : Boolean;
      Unused1   : Bits_48;
      Unused2   : Bits_4;
   end record with
      Bit_Order => Low_Order_First,
      Size      => 64;
   for APICBASE_Type use
   record
      Reserved1 at 0 range 0 .. 7;
      BSP       at 0 range 8 .. 8;
      Reserved2 at 0 range 9 .. 10;
      ENABLE    at 0 range 11 .. 11;
      Unused1   at 0 range 12 .. 59;
      Unused2   at 0 range 60 .. 63;
   end record;

   generic
      MSR_Register_Number : in MSR_Type;
      type Register_Type is private;
   function MSR_Read return Register_Type;

   generic
      MSR_Register_Number : in MSR_Type;
      type Register_Type is private;
   procedure MSR_Write (Value : in Register_Type);

   function RDMSR (MSR_Register_Number : MSR_Type) return Unsigned_64 with
      Inline => True;
   procedure WRMSR (MSR_Register_Number : in MSR_Type; Value : in Unsigned_64) with
      Inline => True;

   function RDTSC return Unsigned_64 with
      Inline => True;

end CPU_i586;

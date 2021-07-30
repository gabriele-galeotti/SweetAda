-----------------------------------------------------------------------------------------------------------------------
--                                                     SweetAda                                                      --
-----------------------------------------------------------------------------------------------------------------------
-- __HDS__                                                                                                           --
-- __FLN__ cpu_i486.ads                                                                                              --
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

with System;
with Interfaces;
with Bits;

package CPU_i486 is

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

   ----------------------------------------------------------------------------
   -- CR4 register
   ----------------------------------------------------------------------------

   type CR4_Register_Type is
   record
      VME        : Boolean;
      PVI        : Boolean;
      TSD        : Boolean;
      DE         : Boolean;
      PSE        : Boolean; -- Page Size Extension
      PAE        : Boolean; -- Physical Address Extension
      MCE        : Boolean;
      PGE        : Boolean;
      PCE        : Boolean;
      OSFXSR     : Boolean;
      OSXMMEXCPT : Boolean;
      Reserved1  : Bits_2_Zeroes := Bits_2_0;
      VMXE       : Boolean;
      SMXE       : Boolean;
      Reserved2  : Bits_1_Zeroes := Bits_1_0;
      FSGSBASE   : Boolean;
      PCIDE      : Boolean;
      OSXSAVE    : Boolean;
      Reserved3  : Bits_1_Zeroes := Bits_1_0;
      SMEP       : Boolean;
      SMAP       : Boolean;
      PKE        : Boolean;
      Reserved4  : Bits_9_Zeroes := Bits_9_0;
   end record with
      Bit_Order => Low_Order_First,
      Size      => 32;
   for CR4_Register_Type use
   record
      VME        at 0 range 0 .. 0;
      PVI        at 0 range 1 .. 1;
      TSD        at 0 range 2 .. 2;
      DE         at 0 range 3 .. 3;
      PSE        at 0 range 4 .. 4;
      PAE        at 0 range 5 .. 5;
      MCE        at 0 range 6 .. 6;
      PGE        at 0 range 7 .. 7;
      PCE        at 0 range 8 .. 8;
      OSFXSR     at 0 range 9 .. 9;
      OSXMMEXCPT at 0 range 10 .. 10;
      Reserved1  at 0 range 11 .. 12;
      VMXE       at 0 range 13 .. 13;
      SMXE       at 0 range 14 .. 14;
      Reserved2  at 0 range 15 .. 15;
      FSGSBASE   at 0 range 16 .. 16;
      PCIDE      at 0 range 17 .. 17;
      OSXSAVE    at 0 range 18 .. 18;
      Reserved3  at 0 range 19 .. 19;
      SMEP       at 0 range 20 .. 20;
      SMAP       at 0 range 21 .. 21;
      PKE        at 0 range 22 .. 22;
      Reserved4  at 0 range 23 .. 31;
   end record;

   function CR4_Read return CR4_Register_Type;
   procedure CR4_Write (Value : in CR4_Register_Type);

   ----------------------------------------------------------------------------
   -- CPUID
   ----------------------------------------------------------------------------

   function CPUID_Enabled return Boolean;

   type CPUID_VendorID_String_Type is new String (1 .. 12) with
      Alignment => Unsigned_32'Alignment,
      Size      => Unsigned_32'Size * 3;

   function CPU_VendorID_Read return CPUID_VendorID_String_Type;

   type CPU_Features_Type is
   record
      FPU     : Boolean;
      VME     : Boolean;
      DE      : Boolean;
      PSE     : Boolean;
      TSC     : Boolean;
      MSR     : Boolean;
      PAE     : Boolean;
      MCE     : Boolean;
      CX8     : Boolean;
      APIC    : Boolean;
      Unused1 : Bits_1_Zeroes := Bits_1_0; -- bit #10 not assigned
      SEP     : Boolean;
      MTRR    : Boolean;
      PGE     : Boolean;
      MCA     : Boolean;
      CMOV    : Boolean;
      PAT     : Boolean;
      PSE36   : Boolean;
      PSN     : Boolean;
      CLF     : Boolean;
      Unused2 : Bits_1_Zeroes := Bits_1_0; -- bit #20 not assigned
      DTES    : Boolean;
      ACPI    : Boolean;
      MMX     : Boolean;
      FXSR    : Boolean;
      SSE     : Boolean;
      SSE2    : Boolean;
      SS      : Boolean;
      HTT     : Boolean;
      TM1     : Boolean;
      IA64    : Boolean;
      PBE     : Boolean;
   end record with
      Bit_Order => Low_Order_First,
      Size      => 32;
   for CPU_Features_Type use
   record
      FPU     at 0 range 0 .. 0;
      VME     at 0 range 1 .. 1;
      DE      at 0 range 2 .. 2;
      PSE     at 0 range 3 .. 3;
      TSC     at 0 range 4 .. 4;
      MSR     at 0 range 5 .. 5;
      PAE     at 0 range 6 .. 6;
      MCE     at 0 range 7 .. 7;
      CX8     at 0 range 8 .. 8;
      APIC    at 0 range 9 .. 9;
      Unused1 at 0 range 10 .. 10;
      SEP     at 0 range 11 .. 11;
      MTRR    at 0 range 12 .. 12;
      PGE     at 0 range 13 .. 13;
      MCA     at 0 range 14 .. 14;
      CMOV    at 0 range 15 .. 15;
      PAT     at 0 range 16 .. 16;
      PSE36   at 0 range 17 .. 17;
      PSN     at 0 range 18 .. 18;
      CLF     at 0 range 19 .. 19;
      Unused2 at 0 range 20 .. 20;
      DTES    at 0 range 21 .. 21;
      ACPI    at 0 range 22 .. 22;
      MMX     at 0 range 23 .. 23;
      FXSR    at 0 range 24 .. 24;
      SSE     at 0 range 25 .. 25;
      SSE2    at 0 range 26 .. 26;
      SS      at 0 range 27 .. 27;
      HTT     at 0 range 28 .. 28;
      TM1     at 0 range 29 .. 29;
      IA64    at 0 range 30 .. 30;
      PBE     at 0 range 31 .. 31;
   end record;

   function CPU_Features_Read return CPU_Features_Type;

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

end CPU_i486;

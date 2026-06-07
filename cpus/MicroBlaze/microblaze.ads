-----------------------------------------------------------------------------------------------------------------------
--                                                     SweetAda                                                      --
-----------------------------------------------------------------------------------------------------------------------
-- __HDS__                                                                                                           --
-- __FLN__ microblaze.ads                                                                                            --
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

with System;
-- with Interfaces;
with Bits;

package MicroBlaze
   is

   --========================================================================--
   --                                                                        --
   --                                                                        --
   --                               Public part                              --
   --                                                                        --
   --                                                                        --
   --========================================================================--

   use System;
   -- use Interfaces;
   use Bits;

pragma Style_Checks (Off);

   ----------------------------------------------------------------------------
   -- MicroBlaze Processor Reference Guide
   -- UG081 (v9.0)
   ----------------------------------------------------------------------------

   R0  : constant := 0;
   R1  : constant := 1;
   R2  : constant := 2;
   R3  : constant := 3;
   R4  : constant := 4;
   R5  : constant := 5;
   R6  : constant := 6;
   R7  : constant := 7;
   R8  : constant := 8;
   R9  : constant := 9;
   R10 : constant := 10;
   R11 : constant := 11;
   R12 : constant := 12;
   R13 : constant := 13;
   R14 : constant := 14;
   R15 : constant := 15;
   R16 : constant := 16;
   R17 : constant := 17;
   R18 : constant := 18;
   R19 : constant := 19;
   R20 : constant := 20;
   R21 : constant := 21;
   R22 : constant := 22;
   R23 : constant := 23;
   R24 : constant := 24;
   R25 : constant := 25;
   R26 : constant := 26;
   R27 : constant := 27;
   R28 : constant := 28;
   R29 : constant := 29;
   R30 : constant := 30;
   R31 : constant := 31;
   PC  : constant := 32;
   MSR : constant := 33;
   EAR : constant := 34;

   subtype Register_Number_Type is Natural range R0 .. PC;

   Register_Size : constant array (R0 .. PC) of Positive :=
      [R0  => 4, R1  => 4, R2  => 4, R3  => 4, R4  => 4, R5  => 4, R6  => 4, R7  => 4,
       R8  => 4, R9  => 4, R10 => 4, R11 => 4, R12 => 4, R13 => 4, R14 => 4, R15 => 4,
       R16 => 4, R17 => 4, R18 => 4, R19 => 4, R20 => 4, R21 => 4, R22 => 4, R23 => 4,
       R24 => 4, R25 => 4, R26 => 4, R27 => 4, R28 => 4, R29 => 4, R30 => 4, R31 => 4,
       PC  => 4];

   Maximum_Register_Size : constant := 4;

   -- Machine Status Register (MSR)

   type MSR_Type is record
      CC        : Boolean; -- Arithmetic Carry Copy
      Reserved1 : Bits_16;
      VMS       : Boolean; -- Virtual Protected Mode Save
      VM        : Boolean; -- Virtual Protected Mode
      UMS       : Boolean; -- User Mode Save
      UM        : Boolean; -- User Mode
      PVR       : Boolean; -- Processor Version Register exists
      EIP       : Boolean; -- Exception In Progress
      EE        : Boolean; -- Exception Enable
      DCE       : Boolean; -- Data Cache Enable
      DZO       : Boolean; -- Division by Zero or Division Overflow
      ICE       : Boolean; -- Instruction Cache Enable
      FSL       : Boolean; -- AXI4-Stream Error
      BIP       : Boolean; -- Break in Progress
      C         : Boolean; -- Arithmetic Carry
      IE        : Boolean; -- Interrupt Enable
      Reserved2 : Bits_1;
   end record
      with Bit_Order => High_Order_First,
           Size      => 32;
   for MSR_Type use record
      CC        at 0 range  0 ..  0;
      Reserved1 at 0 range  1 .. 16;
      VMS       at 0 range 17 .. 17;
      VM        at 0 range 18 .. 18;
      UMS       at 0 range 19 .. 19;
      UM        at 0 range 20 .. 20;
      PVR       at 0 range 21 .. 21;
      EIP       at 0 range 22 .. 22;
      EE        at 0 range 23 .. 23;
      DCE       at 0 range 24 .. 24;
      DZO       at 0 range 25 .. 25;
      ICE       at 0 range 26 .. 26;
      FSL       at 0 range 27 .. 27;
      BIP       at 0 range 28 .. 28;
      C         at 0 range 29 .. 29;
      IE        at 0 range 30 .. 30;
      Reserved2 at 0 range 31 .. 31;
   end record;

   function MSR_IE   return MSR_Type with Inline => True;
   function MSR_nIE  return MSR_Type with Inline => True;
   function MSR_ICE  return MSR_Type with Inline => True;
   function MSR_nICE return MSR_Type with Inline => True;
   function MSR_DCE  return MSR_Type with Inline => True;
   function MSR_nDCE return MSR_Type with Inline => True;

   function MSR_Read
      return MSR_Type
      with Inline => True;

   ----------------------------------------------------------------------------
   -- Cache management
   ----------------------------------------------------------------------------

   procedure ICache_Invalidate
      with Export        => True,
           Convention    => Asm,
           External_Name => "icache_invalidate";
   procedure ICache_Enable
      with Export        => True,
           Convention    => Asm,
           External_Name => "icache_enable";
   procedure DCache_Invalidate
      with Export        => True,
           Convention    => Asm,
           External_Name => "dcache_invalidate";
   procedure DCache_Enable
      with Export        => True,
           Convention    => Asm,
           External_Name => "dcache_enable";

   ----------------------------------------------------------------------------
   -- Generic definitions
   ----------------------------------------------------------------------------

   Opcode_BREAKPOINT      : constant := 16#B9CC_0060#; -- BRKI R14,0x60
   Opcode_BREAKPOINT_Size : constant := 4;

   BREAKPOINT_Asm_String : constant String := ".word   0xB9CC0060";

   procedure NOP
      with Inline => True;
   procedure BREAKPOINT
      with Inline => True;

   ----------------------------------------------------------------------------
   -- Exceptions and interrupts
   ----------------------------------------------------------------------------

   subtype Intcontext_Type is MSR_Type;

   procedure Intcontext_Get
      (Intcontext : out Intcontext_Type)
      with Inline => True;
   procedure Intcontext_Set
      (Intcontext : in Intcontext_Type)
      with Inline => True;

   procedure Irq_Enable
      with Inline => True;
   procedure Irq_Disable
      with Inline => True;

pragma Style_Checks (On);

end MicroBlaze;

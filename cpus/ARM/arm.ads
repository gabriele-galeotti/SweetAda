-----------------------------------------------------------------------------------------------------------------------
--                                                     SweetAda                                                      --
-----------------------------------------------------------------------------------------------------------------------
-- __HDS__                                                                                                           --
-- __FLN__ arm.ads                                                                                                   --
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
with Ada.Unchecked_Conversion;
with Interfaces;
with Bits;

package ARM is

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
   -- Generic definitions
   ----------------------------------------------------------------------------

   Opcode_BREAKPOINT      : constant := 16#E7FF_DEFE#;
   Opcode_BREAKPOINT_Size : constant := 4;

   BREAKPOINT_Asm_String : constant String := ".word   0xE7FFDEFE";

   procedure NOP with
      Inline => True;
   procedure BREAKPOINT with
      Inline => True;

   ----------------------------------------------------------------------------
   -- ARM registers
   ----------------------------------------------------------------------------

   R0   : constant := 0;
   R1   : constant := 1;
   R2   : constant := 2;
   R3   : constant := 3;
   R4   : constant := 4;
   R5   : constant := 5;
   R6   : constant := 6;
   R7   : constant := 7;
   R8   : constant := 8;
   R9   : constant := 9;
   R10  : constant := 10;
   R11  : constant := 11;
   R12  : constant := 12;
   R13  : constant := 13;
   R14  : constant := 14;
   R15  : constant := 15;
   F0   : constant := 16; -- FPA model, size = 12 bytes
   F1   : constant := 17; -- FPA model, size = 12 bytes
   F2   : constant := 18; -- FPA model, size = 12 bytes
   F3   : constant := 19; -- FPA model, size = 12 bytes
   F4   : constant := 20; -- FPA model, size = 12 bytes
   F5   : constant := 21; -- FPA model, size = 12 bytes
   F6   : constant := 22; -- FPA model, size = 12 bytes
   F7   : constant := 23; -- FPA model, size = 12 bytes
   FPS  : constant := 24; -- FPA model, 32-bit
   CPSR : constant := 25;

   -- aliases
   A1   : constant := R0;
   A2   : constant := R1;
   A3   : constant := R2;
   A4   : constant := R3;
   V1   : constant := R4;
   V2   : constant := R5;
   V3   : constant := R6;
   V4   : constant := R7;
   V5   : constant := R8;
   V6   : constant := R9;
   RFP  : constant := R9;
   SL   : constant := R10;
   FP   : constant := R11;
   IP   : constant := R12;
   SP   : constant := R13;
   LR   : constant := R14;
   PC   : constant := R15;

   subtype Register_Number_Type is Natural range R0 .. CPSR;

   ----------------------------------------------------------------------------
   -- CPSR
   ----------------------------------------------------------------------------

   type CPU_Mode_Type is new Bits_5;

   MODE_USR : constant CPU_Mode_Type := 2#10000#;
   MODE_FIQ : constant CPU_Mode_Type := 2#10001#;
   MODE_IRQ : constant CPU_Mode_Type := 2#10010#;
   MODE_SVC : constant CPU_Mode_Type := 2#10011#;
   MODE_ABT : constant CPU_Mode_Type := 2#10111#;
   MODE_UND : constant CPU_Mode_Type := 2#11011#;
   MODE_SYS : constant CPU_Mode_Type := 2#11111#;

   type CPSR_Type is
   record
      M      : CPU_Mode_Type;
      T      : Boolean;
      F      : Boolean;
      I      : Boolean;
      Unused : Bits_20 := 0;
      V      : Boolean;
      C      : Boolean;
      Z      : Boolean;
      N      : Boolean;
   end record with
      Bit_Order => Low_Order_First,
      Size      => 32;
   for CPSR_Type use
   record
      M      at 0 range 0 .. 4;
      T      at 0 range 5 .. 5;
      F      at 0 range 6 .. 6;
      I      at 0 range 7 .. 7;
      Unused at 0 range 8 .. 27;
      V      at 0 range 28 .. 28;
      C      at 0 range 29 .. 29;
      Z      at 0 range 30 .. 30;
      N      at 0 range 31 .. 31;
   end record;

   ----------------------------------------------------------------------------
   -- Exceptions and interrupts
   ----------------------------------------------------------------------------

   UNDEFINED_INSTRUCTION : constant := 16#04#;
   SWI                   : constant := 16#08#;
   ABORT_PREFETCH        : constant := 16#0C#;
   ABORT_DATA            : constant := 16#10#;
   ADDRESS_EXCEPTION     : constant := 16#14#;
   IRQ                   : constant := 16#18#;
   FIQ                   : constant := 16#1C#;

   procedure Irq_Enable with
      Inline => True;
   procedure Irq_Disable with
      Inline => True;

   ----------------------------------------------------------------------------
   -- Locking
   ----------------------------------------------------------------------------

   procedure Memory_Synchronization with
      Inline        => True,
      Export        => True,
      Convention    => C,
      External_Name => "__sync_synchronize";

end ARM;

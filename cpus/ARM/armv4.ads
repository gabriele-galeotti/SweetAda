-----------------------------------------------------------------------------------------------------------------------
--                                                     SweetAda                                                      --
-----------------------------------------------------------------------------------------------------------------------
-- __HDS__                                                                                                           --
-- __FLN__ armv4.ads                                                                                                 --
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
with Bits;

package ARMv4
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
   use Bits;

pragma Style_Checks (Off);

   ----------------------------------------------------------------------------
   -- ARM Architecture Reference Manual
   -- ARM DDI 0100I
   ----------------------------------------------------------------------------

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
   -- A2.5 Program status registers
   ----------------------------------------------------------------------------

   type CPU_Mode_Type is new Bits_5;

   MODE_USR : constant CPU_Mode_Type := 2#10000#;
   MODE_FIQ : constant CPU_Mode_Type := 2#10001#;
   MODE_IRQ : constant CPU_Mode_Type := 2#10010#;
   MODE_SVC : constant CPU_Mode_Type := 2#10011#;
   MODE_ABT : constant CPU_Mode_Type := 2#10111#;
   MODE_UND : constant CPU_Mode_Type := 2#11011#;
   MODE_SYS : constant CPU_Mode_Type := 2#11111#;

   FIQ_Bit : constant := 16#40#;
   IRQ_Bit : constant := 16#80#;

   type CPSR_Type is record
      M      : CPU_Mode_Type;
      T      : Boolean;
      F      : Boolean;
      I      : Boolean;
      Unused : Bits_20       := 0;
      V      : Boolean;
      C      : Boolean;
      Z      : Boolean;
      N      : Boolean;
   end record
      with Bit_Order => Low_Order_First,
           Size      => 32;
   for CPSR_Type use record
      M      at 0 range  0 ..  4;
      T      at 0 range  5 ..  5;
      F      at 0 range  6 ..  6;
      I      at 0 range  7 ..  7;
      Unused at 0 range  8 .. 27;
      V      at 0 range 28 .. 28;
      C      at 0 range 29 .. 29;
      Z      at 0 range 30 .. 30;
      N      at 0 range 31 .. 31;
   end record;

   ----------------------------------------------------------------------------
   -- Generic definitions
   ----------------------------------------------------------------------------

   Opcode_BREAKPOINT      : constant := 16#E7FF_DEFE#;
   Opcode_BREAKPOINT_Size : constant := 4;

   BREAKPOINT_Asm_String : constant String := ".word   0xE7FFDEFE";

   procedure NOP
      with Inline => True;
   procedure BREAKPOINT
      with Inline => True;

   ----------------------------------------------------------------------------
   -- Exceptions and interrupts
   ----------------------------------------------------------------------------

   -- these definitions are both codes for exception and vector offsets
   RESET_EXCEPTION       : constant := 16#00#;
   UNDEFINED_INSTRUCTION : constant := 16#04#;
   SWI_EXCEPTION         : constant := 16#08#;
   ABORT_PREFETCH        : constant := 16#0C#;
   ABORT_DATA            : constant := 16#10#;
   ADDRESS_EXCEPTION     : constant := 16#14#;
   IRQ                   : constant := 16#18#;
   FIQ                   : constant := 16#1C#;

   String_RESET_EXCEPTION       : aliased constant String := "RESET EXCEPTION";
   String_UNDEFINED_INSTRUCTION : aliased constant String := "UNDEFINED INSTRUCTION";
   String_SWI_EXCEPTION         : aliased constant String := "SWI EXCEPTION";
   String_ABORT_PREFETCH        : aliased constant String := "ABORT PREFETCH";
   String_ABORT_DATA            : aliased constant String := "ABORT DATA";
   String_ADDRESS_EXCEPTION     : aliased constant String := "ADDRESS EXCEPTION";
   String_IRQ                   : aliased constant String := "IRQ";
   String_FIQ                   : aliased constant String := "FIQ";
   String_UNKNOWN_EXCEPTION     : aliased constant String := "UNKNOWN EXCEPTION";

   MsgPtr_RESET_EXCEPTION       : constant access constant String := String_RESET_EXCEPTION'Access;
   MsgPtr_UNDEFINED_INSTRUCTION : constant access constant String := String_UNDEFINED_INSTRUCTION'Access;
   MsgPtr_SWI_EXCEPTION         : constant access constant String := String_SWI_EXCEPTION'Access;
   MsgPtr_ABORT_PREFETCH        : constant access constant String := String_ABORT_PREFETCH'Access;
   MsgPtr_ABORT_DATA            : constant access constant String := String_ABORT_DATA'Access;
   MsgPtr_ADDRESS_EXCEPTION     : constant access constant String := String_ADDRESS_EXCEPTION'Access;
   MsgPtr_IRQ                   : constant access constant String := String_IRQ'Access;
   MsgPtr_FIQ                   : constant access constant String := String_FIQ'Access;
   MsgPtr_UNKNOWN_EXCEPTION     : constant access constant String := String_UNKNOWN_EXCEPTION'Access;

   type Intcontext_Type is new Bits_32;

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
   procedure Fiq_Enable
      with Inline => True;
   procedure Fiq_Disable
      with Inline => True;

pragma Style_Checks (On);

end ARMv4;

-----------------------------------------------------------------------------------------------------------------------
--                                                     SweetAda                                                      --
-----------------------------------------------------------------------------------------------------------------------
-- __HDS__                                                                                                           --
-- __FLN__ microblaze.ads                                                                                            --
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

package MicroBlaze
   is

   --========================================================================--
   --                                                                        --
   --                                                                        --
   --                               Public part                              --
   --                                                                        --
   --                                                                        --
   --========================================================================--

   use Interfaces;

   ----------------------------------------------------------------------------
   -- Generic definitions
   ----------------------------------------------------------------------------

   Opcode_BREAKPOINT      : constant := 16#B9CC_0060#; -- BRKI R14,0x60
   Opcode_BREAKPOINT_Size : constant := 4;

   BREAKPOINT_Asm_String : constant String := ".word   0xB9CC0060";

   MSR_IE : constant := 2#10#;

   procedure NOP
      with Inline => True;
   procedure BREAKPOINT
      with Inline => True;

   ----------------------------------------------------------------------------
   -- MicroBlaze registers
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
   -- Exceptions and interrupts
   ----------------------------------------------------------------------------

   subtype Irq_State_Type is Integer;

   procedure Irq_Enable
      with Inline => True;
   procedure Irq_Disable
      with Inline => True;
   function Irq_State_Get
      return Irq_State_Type
      with Inline => True;
   procedure Irq_State_Set
      (Irq_State : in Irq_State_Type)
      with Inline => True;

end MicroBlaze;

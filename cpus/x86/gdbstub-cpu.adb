-----------------------------------------------------------------------------------------------------------------------
--                                                     SweetAda                                                      --
-----------------------------------------------------------------------------------------------------------------------
-- __HDS__                                                                                                           --
-- __FLN__ gdbstub-cpu.adb                                                                                           --
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

with System.Storage_Elements;
with x86;

package body Gdbstub.CPU
   is

   --========================================================================--
   --                                                                        --
   --                                                                        --
   --                           Local declarations                           --
   --                                                                        --
   --                                                                        --
   --========================================================================--

   use System;
   use System.Storage_Elements;
   use Interfaces;
   use Bits;
   use x86;

   ----------------------------------------------------------------------------
   -- Register memory mapping
   ----------------------------------------------------------------------------

   type CPU_Context_Type is record
      EAX    : Unsigned_32;
      ECX    : Unsigned_32;
      EDX    : Unsigned_32;
      EBX    : Unsigned_32;
      ESP    : Unsigned_32;
      EBP    : Unsigned_32;
      ESI    : Unsigned_32;
      EDI    : Unsigned_32;
      EIP    : Unsigned_32;
      EFLAGS : EFLAGS_Type;
      CS     : Unsigned_32;
      SS     : Unsigned_32;
      DS     : Unsigned_32;
      ES     : Unsigned_32;
      FS     : Unsigned_32;
      GS     : Unsigned_32;
      ST0    : ST_Register_Type;
      ST1    : ST_Register_Type;
      ST2    : ST_Register_Type;
      ST3    : ST_Register_Type;
      ST4    : ST_Register_Type;
      ST5    : ST_Register_Type;
      ST6    : ST_Register_Type;
      ST7    : ST_Register_Type;
      FCTRL  : Unsigned_16;
      FSTAT  : Unsigned_16;
      FTAG   : Unsigned_16;
      FISEG  : Unsigned_32;
      FIOFF  : Unsigned_32;
      FOSEG  : Unsigned_32;
      FOOFF  : Unsigned_32;
      FOP    : Unsigned_32;
   end record;
   for CPU_Context_Type use record
      EAX    at 0   range 0 .. 31;
      ECX    at 4   range 0 .. 31;
      EDX    at 8   range 0 .. 31;
      EBX    at 12  range 0 .. 31;
      ESP    at 16  range 0 .. 31;
      EBP    at 20  range 0 .. 31;
      ESI    at 24  range 0 .. 31;
      EDI    at 28  range 0 .. 31;
      EIP    at 32  range 0 .. 31;
      EFLAGS at 36  range 0 .. 31;
      CS     at 40  range 0 .. 31;
      SS     at 44  range 0 .. 31;
      DS     at 48  range 0 .. 31;
      ES     at 52  range 0 .. 31;
      FS     at 56  range 0 .. 31;
      GS     at 60  range 0 .. 31;
      ST0    at 64  range 0 .. 79;
      ST1    at 74  range 0 .. 79;
      ST2    at 84  range 0 .. 79;
      ST3    at 94  range 0 .. 79;
      ST4    at 104 range 0 .. 79;
      ST5    at 114 range 0 .. 79;
      ST6    at 124 range 0 .. 79;
      ST7    at 134 range 0 .. 79;
      FCTRL  at 144 range 0 .. 15;
      FSTAT  at 146 range 0 .. 15;
      FTAG   at 148 range 0 .. 15;
      FISEG  at 150 range 0 .. 31;
      FIOFF  at 154 range 0 .. 31;
      FOSEG  at 158 range 0 .. 31;
      FOOFF  at 162 range 0 .. 31;
      FOP    at 166 range 0 .. 31;
   end record;

   Gdbstub_Data_Area : aliased CPU_Context_Type
      with Volatile                => True,
           Suppress_Initialization => True,
           Export                  => True,
           Convention              => Asm,
           External_Name           => "gdbstub_data_area";

   type Register_Descriptor is record
      Offset : Storage_Offset;
      Size   : Positive;
   end record;

   Registers_Layout : constant array (Register_Number_Type) of Register_Descriptor :=
      [
       EAX    => (Gdbstub_Data_Area.EAX'Position, Gdbstub_Data_Area.EAX'Size / Storage_Unit),
       ECX    => (Gdbstub_Data_Area.ECX'Position, Gdbstub_Data_Area.ECX'Size / Storage_Unit),
       EDX    => (Gdbstub_Data_Area.EDX'Position, Gdbstub_Data_Area.EDX'Size / Storage_Unit),
       EBX    => (Gdbstub_Data_Area.EBX'Position, Gdbstub_Data_Area.EBX'Size / Storage_Unit),
       ESP    => (Gdbstub_Data_Area.ESP'Position, Gdbstub_Data_Area.ESP'Size / Storage_Unit),
       EBP    => (Gdbstub_Data_Area.EBP'Position, Gdbstub_Data_Area.EBP'Size / Storage_Unit),
       ESI    => (Gdbstub_Data_Area.ESI'Position, Gdbstub_Data_Area.ESI'Size / Storage_Unit),
       EDI    => (Gdbstub_Data_Area.EDI'Position, Gdbstub_Data_Area.EDI'Size / Storage_Unit),
       EIP    => (Gdbstub_Data_Area.EIP'Position, Gdbstub_Data_Area.EIP'Size / Storage_Unit),
       EFLAGS => (Gdbstub_Data_Area.EFLAGS'Position, Gdbstub_Data_Area.EFLAGS'Size / Storage_Unit),
       CS     => (Gdbstub_Data_Area.CS'Position, Gdbstub_Data_Area.CS'Size / Storage_Unit),
       SS     => (Gdbstub_Data_Area.SS'Position, Gdbstub_Data_Area.SS'Size / Storage_Unit),
       DS     => (Gdbstub_Data_Area.DS'Position, Gdbstub_Data_Area.DS'Size / Storage_Unit),
       ES     => (Gdbstub_Data_Area.ES'Position, Gdbstub_Data_Area.ES'Size / Storage_Unit),
       FS     => (Gdbstub_Data_Area.FS'Position, Gdbstub_Data_Area.FS'Size / Storage_Unit),
       GS     => (Gdbstub_Data_Area.GS'Position, Gdbstub_Data_Area.GS'Size / Storage_Unit),
       ST0    => (Gdbstub_Data_Area.ST0'Position, Gdbstub_Data_Area.ST0'Size / Storage_Unit),
       ST1    => (Gdbstub_Data_Area.ST1'Position, Gdbstub_Data_Area.ST1'Size / Storage_Unit),
       ST2    => (Gdbstub_Data_Area.ST2'Position, Gdbstub_Data_Area.ST2'Size / Storage_Unit),
       ST3    => (Gdbstub_Data_Area.ST3'Position, Gdbstub_Data_Area.ST3'Size / Storage_Unit),
       ST4    => (Gdbstub_Data_Area.ST4'Position, Gdbstub_Data_Area.ST4'Size / Storage_Unit),
       ST5    => (Gdbstub_Data_Area.ST5'Position, Gdbstub_Data_Area.ST5'Size / Storage_Unit),
       ST6    => (Gdbstub_Data_Area.ST6'Position, Gdbstub_Data_Area.ST6'Size / Storage_Unit),
       ST7    => (Gdbstub_Data_Area.ST7'Position, Gdbstub_Data_Area.ST7'Size / Storage_Unit),
       FCTRL  => (Gdbstub_Data_Area.FCTRL'Position, Gdbstub_Data_Area.FCTRL'Size / Storage_Unit),
       FSTAT  => (Gdbstub_Data_Area.FSTAT'Position, Gdbstub_Data_Area.FSTAT'Size / Storage_Unit),
       FTAG   => (Gdbstub_Data_Area.FTAG'Position, Gdbstub_Data_Area.FTAG'Size / Storage_Unit),
       FISEG  => (Gdbstub_Data_Area.FISEG'Position, Gdbstub_Data_Area.FISEG'Size / Storage_Unit),
       FIOFF  => (Gdbstub_Data_Area.FIOFF'Position, Gdbstub_Data_Area.FIOFF'Size / Storage_Unit),
       FOSEG  => (Gdbstub_Data_Area.FOSEG'Position, Gdbstub_Data_Area.FOSEG'Size / Storage_Unit),
       FOOFF  => (Gdbstub_Data_Area.FOOFF'Position, Gdbstub_Data_Area.FOOFF'Size / Storage_Unit),
       FOP    => (Gdbstub_Data_Area.FOP'Position, Gdbstub_Data_Area.FOP'Size / Storage_Unit)
      ];

   --========================================================================--
   --                                                                        --
   --                                                                        --
   --                           Package subprograms                          --
   --                                                                        --
   --                                                                        --
   --========================================================================--

   ----------------------------------------------------------------------------
   -- Register_Read
   ----------------------------------------------------------------------------
   procedure Register_Read
      (Register_Number : in Natural)
      is
      procedure Register_Read_Helper
         (RAddress : in Address;
          Size     : in Positive)
         with Inline => True;
      procedure Register_Read_Helper
         (RAddress : in Address;
          Size     : in Positive)
         is
         RArray     : Byte_Array (1 .. Size)
            with Address    => RAddress,
                 Volatile   => True,
                 Import     => True,
                 Convention => Ada;
         Digit1_Idx : Integer;
         Digit2_Idx : Integer;
      begin
         for Index in RArray'Range loop
            Digit1_Idx := TX_Packet_Index + 1;
            Digit2_Idx := TX_Packet_Index + 2;
            Byte_Text (RArray (Index), TX_Packet_Buffer (Digit1_Idx .. Digit2_Idx));
            TX_Packet_Index := Digit2_Idx;
         end loop;
      end Register_Read_Helper;
   begin
      -- GDB will ask about non-existent registers (XMM0 ..), do not emit
      -- an error
      if Register_Number in Register_Number_Type'Range then
         Register_Read_Helper (
            Gdbstub_Data_Area'Address + Registers_Layout (Register_Number).Offset,
            Registers_Layout (Register_Number).Size
            );
      end if;
   end Register_Read;

   ----------------------------------------------------------------------------
   -- Registers_Read
   ----------------------------------------------------------------------------
   procedure Registers_Read
      is
   begin
      for Register_Number in EAX .. GS loop
         Register_Read (Register_Number);
      end loop;
   end Registers_Read;

   ----------------------------------------------------------------------------
   -- Register_Write
   ----------------------------------------------------------------------------
   procedure Register_Write
      (Register_Number : in Natural;
       Register_Value  : in Byte_Array;
       Byte_Count      : in Natural)
      is
   begin
      null; -- __TBD__
   end Register_Write;

   ----------------------------------------------------------------------------
   -- Registers_Write
   ----------------------------------------------------------------------------
   procedure Registers_Write
      is
   begin
      null; -- __TBD__
   end Registers_Write;

   ----------------------------------------------------------------------------
   -- PC_Read
   ----------------------------------------------------------------------------
   function PC_Read
      return Address
      is
   begin
      return To_Address (Integer_Address (Gdbstub_Data_Area.EIP));
   end PC_Read;

   ----------------------------------------------------------------------------
   -- PC_Write
   ----------------------------------------------------------------------------
   procedure PC_Write
      (Value : in Address)
      is
   begin
      Gdbstub_Data_Area.EIP := Unsigned_32 (To_Integer (Value));
   end PC_Write;

   ----------------------------------------------------------------------------
   -- Breakpoint_Adjust_PC_Backward
   ----------------------------------------------------------------------------
   -- x86 INT $3 instruction leaves PC pointing to the next instruction.
   ----------------------------------------------------------------------------
   procedure Breakpoint_Adjust_PC_Backward
      is
   begin
      PC_Write (PC_Read - Opcode_BREAKPOINT_Size);
   end Breakpoint_Adjust_PC_Backward;

   ----------------------------------------------------------------------------
   -- Breakpoint_Adjust_PC_Forward
   ----------------------------------------------------------------------------
   procedure Breakpoint_Adjust_PC_Forward
      is
   begin
      PC_Write (PC_Read + Opcode_BREAKPOINT_Size);
   end Breakpoint_Adjust_PC_Forward;

   ----------------------------------------------------------------------------
   -- Breakpoint_Adjust_PC
   ----------------------------------------------------------------------------
   procedure Breakpoint_Adjust_PC
      is
   begin
      Breakpoint_Adjust_PC_Backward;
   end Breakpoint_Adjust_PC;

   ----------------------------------------------------------------------------
   -- Breakpoint_Skip
   ----------------------------------------------------------------------------
   procedure Breakpoint_Skip
      is
   begin
      Breakpoint_Adjust_PC_Forward;
   end Breakpoint_Skip;

   ----------------------------------------------------------------------------
   -- Breakpoint_Set
   ----------------------------------------------------------------------------
   procedure Breakpoint_Set
      is
   begin
      BREAKPOINT;
   end Breakpoint_Set;

   ----------------------------------------------------------------------------
   -- Step_Execute
   ----------------------------------------------------------------------------
   function Step_Execute
      return Boolean
      is
   begin
      Gdbstub_Data_Area.EFLAGS.TF := True;
      return True;
   end Step_Execute;

   ----------------------------------------------------------------------------
   -- Step_Resume
   ----------------------------------------------------------------------------
   procedure Step_Resume
      is
   begin
      Gdbstub_Data_Area.EFLAGS.TF := False;
   end Step_Resume;

end Gdbstub.CPU;

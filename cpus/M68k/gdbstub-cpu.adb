-----------------------------------------------------------------------------------------------------------------------
--                                                     SweetAda                                                      --
-----------------------------------------------------------------------------------------------------------------------
-- __HDS__                                                                                                           --
-- __FLN__ gdbstub-cpu.adb                                                                                           --
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

with System.Storage_Elements;
with Interfaces;
with Memory_Functions;
with M68k;

package body Gdbstub.CPU is

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
   use M68k;

   ----------------------------------------------------------------------------
   -- Register memory mapping
   ----------------------------------------------------------------------------

   Register_Size : constant array (D0 .. FPIADDR) of Positive :=
      [
       D0        => 4,
       D1        => 4,
       D2        => 4,
       D3        => 4,
       D4        => 4,
       D5        => 4,
       D6        => 4,
       D7        => 4,
       A0        => 4,
       A1        => 4,
       A2        => 4,
       A3        => 4,
       A4        => 4,
       A5        => 4,
       A6        => 4,
       A7        => 4,
       SR        => 4,
       PC        => 4,
       FP0       => 12,
       FP1       => 12,
       FP2       => 12,
       FP3       => 12,
       FP4       => 12,
       FP5       => 12,
       FP6       => 12,
       FP7       => 12,
       FPCONTROL => 4,
       FPSTATUS  => 4,
       FPIADDR   => 4
      ];

   subtype FP_Register_Type is Byte_Array (0 .. Register_Size (FP0) - 1);

   type CPU_Context_Type is
   record
      D0        : Unsigned_32;
      D1        : Unsigned_32;
      D2        : Unsigned_32;
      D3        : Unsigned_32;
      D4        : Unsigned_32;
      D5        : Unsigned_32;
      D6        : Unsigned_32;
      D7        : Unsigned_32;
      A0        : Unsigned_32;
      A1        : Unsigned_32;
      A2        : Unsigned_32;
      A3        : Unsigned_32;
      A4        : Unsigned_32;
      A5        : Unsigned_32;
      A6        : Unsigned_32;
      A7        : Unsigned_32;
      SR0       : Unsigned_16;
      SR        : SR_Type;
      PC        : Unsigned_32;
      FP0       : FP_Register_Type;
      FP1       : FP_Register_Type;
      FP2       : FP_Register_Type;
      FP3       : FP_Register_Type;
      FP4       : FP_Register_Type;
      FP5       : FP_Register_Type;
      FP6       : FP_Register_Type;
      FP7       : FP_Register_Type;
      FPCONTROL : Unsigned_32;
      FPSTATUS  : Unsigned_32;
      FPIADDR   : Unsigned_32;
   end record;
   for CPU_Context_Type use
   record
      D0        at 0   range 0 .. 31;
      D1        at 4   range 0 .. 31;
      D2        at 8   range 0 .. 31;
      D3        at 12  range 0 .. 31;
      D4        at 16  range 0 .. 31;
      D5        at 20  range 0 .. 31;
      D6        at 24  range 0 .. 31;
      D7        at 28  range 0 .. 31;
      A0        at 32  range 0 .. 31;
      A1        at 36  range 0 .. 31;
      A2        at 40  range 0 .. 31;
      A3        at 44  range 0 .. 31;
      A4        at 48  range 0 .. 31;
      A5        at 52  range 0 .. 31;
      A6        at 56  range 0 .. 31;
      A7        at 60  range 0 .. 31;
      SR0       at 64  range 0 .. 15;
      SR        at 66  range 0 .. 15;
      PC        at 68  range 0 .. 31;
      FP0       at 72  range 0 .. 95;
      FP1       at 84  range 0 .. 95;
      FP2       at 96  range 0 .. 95;
      FP3       at 108 range 0 .. 95;
      FP4       at 120 range 0 .. 95;
      FP5       at 132 range 0 .. 95;
      FP6       at 144 range 0 .. 95;
      FP7       at 156 range 0 .. 95;
      FPCONTROL at 168 range 0 .. 31;
      FPSTATUS  at 172 range 0 .. 31;
      FPIADDR   at 176 range 0 .. 31;
   end record;

   Gdbstub_Data_Area : aliased CPU_Context_Type with
      Volatile                => True,
      Suppress_Initialization => True,
      Export                  => True,
      Convention              => Asm,
      External_Name           => "gdbstub_data_area";

   function Register_Address (Register_Number : Register_Number_Type) return Address;

   --========================================================================--
   --                                                                        --
   --                                                                        --
   --                           Package subprograms                          --
   --                                                                        --
   --                                                                        --
   --========================================================================--

   ----------------------------------------------------------------------------
   -- Register_Address
   ----------------------------------------------------------------------------
   function Register_Address (Register_Number : Register_Number_Type) return Address is
   begin
      case Register_Number is
         when D0        => return Gdbstub_Data_Area.D0'Address;
         when D1        => return Gdbstub_Data_Area.D1'Address;
         when D2        => return Gdbstub_Data_Area.D2'Address;
         when D3        => return Gdbstub_Data_Area.D3'Address;
         when D4        => return Gdbstub_Data_Area.D4'Address;
         when D5        => return Gdbstub_Data_Area.D5'Address;
         when D6        => return Gdbstub_Data_Area.D6'Address;
         when D7        => return Gdbstub_Data_Area.D7'Address;
         when A0        => return Gdbstub_Data_Area.A0'Address;
         when A1        => return Gdbstub_Data_Area.A1'Address;
         when A2        => return Gdbstub_Data_Area.A2'Address;
         when A3        => return Gdbstub_Data_Area.A3'Address;
         when A4        => return Gdbstub_Data_Area.A4'Address;
         when A5        => return Gdbstub_Data_Area.A5'Address;
         when A6        => return Gdbstub_Data_Area.A6'Address;
         when A7        => return Gdbstub_Data_Area.A7'Address;
         when SR        => return Gdbstub_Data_Area.SR0'Address;
         when PC        => return Gdbstub_Data_Area.PC'Address;
         when FP0       => return Gdbstub_Data_Area.FP0'Address;
         when FP1       => return Gdbstub_Data_Area.FP1'Address;
         when FP2       => return Gdbstub_Data_Area.FP2'Address;
         when FP3       => return Gdbstub_Data_Area.FP3'Address;
         when FP4       => return Gdbstub_Data_Area.FP4'Address;
         when FP5       => return Gdbstub_Data_Area.FP5'Address;
         when FP6       => return Gdbstub_Data_Area.FP6'Address;
         when FP7       => return Gdbstub_Data_Area.FP7'Address;
         when FPCONTROL => return Gdbstub_Data_Area.FPCONTROL'Address;
         when FPSTATUS  => return Gdbstub_Data_Area.FPSTATUS'Address;
         when FPIADDR   => return Gdbstub_Data_Area.FPIADDR'Address;
      end case;
   end Register_Address;

   ----------------------------------------------------------------------------
   -- Register_Read
   ----------------------------------------------------------------------------
   procedure Register_Read (Register_Number : in Natural) is
      -------------------------------------------------------------------------
      procedure Register_Read_Helper (RAddress : in Address; Size : in Positive);
      procedure Register_Read_Helper (RAddress : in Address; Size : in Positive) is
         RArray     : Byte_Array (0 .. Size - 1) with
            Address    => RAddress,
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
      -------------------------
   begin
      if Register_Number not in Register_Number_Type'Range then
         Notify_Packet_Error ("wrong register number");
      else
         Register_Read_Helper (
                               Register_Address (Register_Number),
                               Register_Size (Register_Number)
                              );
      end if;
   end Register_Read;

   ----------------------------------------------------------------------------
   -- Registers_Read
   ----------------------------------------------------------------------------
   procedure Registers_Read is
   begin
      for Register_Number in D0 .. FPIADDR loop
         Register_Read (Register_Number);
      end loop;
   end Registers_Read;

   ----------------------------------------------------------------------------
   -- Register_Write
   ----------------------------------------------------------------------------
   procedure Register_Write (
                             Register_Number : in Natural;
                             Register_Value  : in Byte_Array;
                             Byte_Count      : in Natural
                            ) is
      ---------------------------------
      procedure Register_Write_Helper (
                                       RAddress : in Address;
                                       VAddress : in Address;
                                       Size     : in Positive
                                      );
      procedure Register_Write_Helper (
                                       RAddress : in Address;
                                       VAddress : in Address;
                                       Size     : in Positive
                                      ) is
      begin
         Memory_Functions.Cpymem (VAddress, RAddress, Bytesize (Size));
      end Register_Write_Helper;
      --------------------------
   begin
      if Register_Number not in Register_Number_Type'Range then
         Notify_Packet_Error ("wrong register number");
      end if;
      Register_Write_Helper (
                             Register_Address (Register_Number),
                             Register_Value'Address,
                             Byte_Count
                            );
   end Register_Write;

   ----------------------------------------------------------------------------
   -- Registers_Write
   ----------------------------------------------------------------------------
   procedure Registers_Write is
   begin
      null; -- __TBD__
   end Registers_Write;

   ----------------------------------------------------------------------------
   -- PC_Read
   ----------------------------------------------------------------------------
   function PC_Read return Address is
   begin
      return To_Address (Integer_Address (Gdbstub_Data_Area.PC));
   end PC_Read;

   ----------------------------------------------------------------------------
   -- PC_Write
   ----------------------------------------------------------------------------
   procedure PC_Write (Value : in Address) is
   begin
      Gdbstub_Data_Area.PC := Unsigned_32 (To_Integer (Value));
   end PC_Write;

   ----------------------------------------------------------------------------
   -- Breakpoint_Adjust_PC_Backward
   ----------------------------------------------------------------------------
   procedure Breakpoint_Adjust_PC_Backward is
   begin
      PC_Write (PC_Read - Opcode_BREAKPOINT_Size);
   end Breakpoint_Adjust_PC_Backward;

   ----------------------------------------------------------------------------
   -- Breakpoint_Adjust_PC_Forward
   ----------------------------------------------------------------------------
   procedure Breakpoint_Adjust_PC_Forward is
   begin
      PC_Write (PC_Read + Opcode_BREAKPOINT_Size);
   end Breakpoint_Adjust_PC_Forward;

   ----------------------------------------------------------------------------
   -- Breakpoint_Adjust_PC
   ----------------------------------------------------------------------------
   procedure Breakpoint_Adjust_PC is
   begin
      Breakpoint_Adjust_PC_Backward;
   end Breakpoint_Adjust_PC;

   ----------------------------------------------------------------------------
   -- Breakpoint_Skip
   ----------------------------------------------------------------------------
   procedure Breakpoint_Skip is
   begin
      Breakpoint_Adjust_PC_Forward;
   end Breakpoint_Skip;

   ----------------------------------------------------------------------------
   -- Breakpoint_Set
   ----------------------------------------------------------------------------
   procedure Breakpoint_Set is
   begin
      BREAKPOINT;
   end Breakpoint_Set;

   ----------------------------------------------------------------------------
   -- Step_Execute
   ----------------------------------------------------------------------------
   function Step_Execute return Boolean is
   begin
      Gdbstub_Data_Area.SR.T1 := True;
      return True;
   end Step_Execute;

   ----------------------------------------------------------------------------
   -- Step_Resume
   ----------------------------------------------------------------------------
   procedure Step_Resume is
   begin
      Gdbstub_Data_Area.SR.T1 := False;
   end Step_Resume;

end Gdbstub.CPU;

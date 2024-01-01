-----------------------------------------------------------------------------------------------------------------------
--                                                     SweetAda                                                      --
-----------------------------------------------------------------------------------------------------------------------
-- __HDS__                                                                                                           --
-- __FLN__ gnat_exceptions.adb                                                                                       --
-- __DSC__                                                                                                           --
-- __HSH__ e69de29bb2d1d6434b8b29ae775ad8c2e48c5391                                                                  --
-- __HDE__                                                                                                           --
-----------------------------------------------------------------------------------------------------------------------
-- Copyright (C) 2020-2024 Gabriele Galeotti                                                                         --
--                                                                                                                   --
-- SweetAda web page: http://sweetada.org                                                                            --
-- contact address: gabriele.galeotti@sweetada.org                                                                   --
-- This work is licensed under the terms of the MIT License.                                                         --
-- Please consult the LICENSE.txt file located in the top-level directory.                                           --
-----------------------------------------------------------------------------------------------------------------------

with Ada.Characters.Latin_1;
with Abort_Library;

package body GNAT_Exceptions
   is

   --========================================================================--
   --                                                                        --
   --                                                                        --
   --                           Local declarations                           --
   --                                                                        --
   --                                                                        --
   --========================================================================--

   package ISO88591 renames Ada.Characters.Latin_1;

   CONSTRAINT_ERROR_PREFIX : constant String := "CONSTRAINT ERROR: ";
   PROGRAM_ERROR_PREFIX    : constant String := "PROGRAM ERROR: ";
   STORAGE_ERROR_PREFIX    : constant String := "STORAGE ERROR: ";

   --========================================================================--
   --                                                                        --
   --                                                                        --
   --                           Package subprograms                          --
   --                                                                        --
   --                                                                        --
   --========================================================================--

   -- 00
   procedure Rcheck_CE_Access_Check
      (File : in System.Address;
       Line : in Integer)
      is
      Message : aliased constant String := CONSTRAINT_ERROR_PREFIX & "access check" & ISO88591.NUL;
   begin
      Abort_Library.System_Abort (File, Line, 0, Message'Address);
   end Rcheck_CE_Access_Check;

   -- 01
   procedure Rcheck_CE_Null_Access_Parameter
      (File : in System.Address;
       Line : in Integer)
      is
      Message : aliased constant String := CONSTRAINT_ERROR_PREFIX & "null access parameter" & ISO88591.NUL;
   begin
      Abort_Library.System_Abort (File, Line, 0, Message'Address);
   end Rcheck_CE_Null_Access_Parameter;

   -- 02
   procedure Rcheck_CE_Discriminant_Check
      (File : in System.Address;
       Line : in Integer)
      is
      Message : aliased constant String := CONSTRAINT_ERROR_PREFIX & "discriminant check" & ISO88591.NUL;
   begin
      Abort_Library.System_Abort (File, Line, 0, Message'Address);
   end Rcheck_CE_Discriminant_Check;

   -- 03
   procedure Rcheck_CE_Divide_By_Zero
      (File : in System.Address;
       Line : in Integer)
      is
      Message : aliased constant String := CONSTRAINT_ERROR_PREFIX & "divide by 0" & ISO88591.NUL;
   begin
      Abort_Library.System_Abort (File, Line, 0, Message'Address);
   end Rcheck_CE_Divide_By_Zero;

   -- 04
   procedure Rcheck_CE_Explicit_Raise
      (File : in System.Address;
       Line : in Integer)
      is
      Message : aliased constant String := CONSTRAINT_ERROR_PREFIX & "explicit raise" & ISO88591.NUL;
   begin
      Abort_Library.System_Abort (File, Line, 0, Message'Address);
   end Rcheck_CE_Explicit_Raise;

   -- 05
   procedure Rcheck_CE_Index_Check
      (File : in System.Address;
      Line : in Integer)
      is
      Message : aliased constant String := CONSTRAINT_ERROR_PREFIX & "index check" & ISO88591.NUL;
   begin
      Abort_Library.System_Abort (File, Line, 0, Message'Address);
   end Rcheck_CE_Index_Check;

   -- 06
   procedure Rcheck_CE_Invalid_Data
      (File : in System.Address;
       Line : in Integer)
      is
      Message : aliased constant String := CONSTRAINT_ERROR_PREFIX & "invalid data" & ISO88591.NUL;
   begin
      Abort_Library.System_Abort (File, Line, 0, Message'Address);
   end Rcheck_CE_Invalid_Data;

   -- 07
   procedure Rcheck_CE_Length_Check
      (File : in System.Address;
       Line : in Integer)
      is
      Message : aliased constant String := CONSTRAINT_ERROR_PREFIX & "length check" & ISO88591.NUL;
   begin
      Abort_Library.System_Abort (File, Line, 0, Message'Address);
   end Rcheck_CE_Length_Check;

   -- 08
   procedure Rcheck_CE_Null_Exception_Id
      (File : in System.Address;
       Line : in Integer)
      is
      Message : aliased constant String := CONSTRAINT_ERROR_PREFIX & "null exception id" & ISO88591.NUL;
   begin
      Abort_Library.System_Abort (File, Line, 0, Message'Address);
   end Rcheck_CE_Null_Exception_Id;

   -- 09
   procedure Rcheck_CE_Null_Not_Allowed
      (File : in System.Address;
       Line : in Integer)
      is
      Message : aliased constant String := CONSTRAINT_ERROR_PREFIX & "null not allowed" & ISO88591.NUL;
   begin
      Abort_Library.System_Abort (File, Line, 0, Message'Address);
   end Rcheck_CE_Null_Not_Allowed;

   -- 10
   procedure Rcheck_CE_Overflow_Check
      (File : in System.Address;
       Line : in Integer)
      is
      Message : aliased constant String := CONSTRAINT_ERROR_PREFIX & "overflow check" & ISO88591.NUL;
   begin
      Abort_Library.System_Abort (File, Line, 0, Message'Address);
   end Rcheck_CE_Overflow_Check;

   -- 11
   procedure Rcheck_CE_Partition_Check
      (File : in System.Address;
       Line : in Integer)
      is
      Message : aliased constant String := CONSTRAINT_ERROR_PREFIX & "partition check" & ISO88591.NUL;
   begin
      Abort_Library.System_Abort (File, Line, 0, Message'Address);
   end Rcheck_CE_Partition_Check;

   -- 12
   procedure Rcheck_CE_Range_Check
      (File : in System.Address;
       Line : in Integer)
      is
      Message : aliased constant String := CONSTRAINT_ERROR_PREFIX & "range check" & ISO88591.NUL;
   begin
      Abort_Library.System_Abort (File, Line, 0, Message'Address);
   end Rcheck_CE_Range_Check;

   -- 13
   procedure Rcheck_CE_Tag_Check
      (File : in System.Address;
       Line : in Integer)
      is
      Message : aliased constant String := CONSTRAINT_ERROR_PREFIX & "tag check" & ISO88591.NUL;
   begin
      Abort_Library.System_Abort (File, Line, 0, Message'Address);
   end Rcheck_CE_Tag_Check;

   -- 14
   procedure Rcheck_PE_Access_Before_Elaboration
      (File : in System.Address;
       Line : in Integer)
      is
      Message : aliased constant String := PROGRAM_ERROR_PREFIX & "access before elaboration" & ISO88591.NUL;
   begin
      Abort_Library.System_Abort (File, Line, 0, Message'Address);
   end Rcheck_PE_Access_Before_Elaboration;

   -- 15
   procedure Rcheck_PE_Accessibility_Check
      (File : in System.Address;
       Line : in Integer)
      is
      Message : aliased constant String := PROGRAM_ERROR_PREFIX & "accessibility check" & ISO88591.NUL;
   begin
      Abort_Library.System_Abort (File, Line, 0, Message'Address);
   end Rcheck_PE_Accessibility_Check;

   -- 16
   procedure Rcheck_PE_Address_Of_Intrinsic
      (File : in System.Address;
       Line : in Integer)
      is
      Message : aliased constant String := PROGRAM_ERROR_PREFIX & "address of intrinsic" & ISO88591.NUL;
   begin
      Abort_Library.System_Abort (File, Line, 0, Message'Address);
   end Rcheck_PE_Address_Of_Intrinsic;

   -- 17
   procedure Rcheck_PE_Aliased_Parameters
      (File : in System.Address;
       Line : in Integer)
      is
      Message : aliased constant String := PROGRAM_ERROR_PREFIX & "aliased parameters" & ISO88591.NUL;
   begin
      Abort_Library.System_Abort (File, Line, 0, Message'Address);
   end Rcheck_PE_Aliased_Parameters;

   -- 18
   procedure Rcheck_PE_All_Guards_Closed
      (File : in System.Address;
       Line : in Integer)
      is
      Message : aliased constant String := PROGRAM_ERROR_PREFIX & "all guards closed" & ISO88591.NUL;
   begin
      Abort_Library.System_Abort (File, Line, 0, Message'Address);
   end Rcheck_PE_All_Guards_Closed;

   -- 19
   procedure Rcheck_PE_Bad_Predicated_Generic_Type
      (File : in System.Address;
       Line : in Integer)
      is
      Message : aliased constant String := PROGRAM_ERROR_PREFIX & "bad predicated generic type" & ISO88591.NUL;
   begin
      Abort_Library.System_Abort (File, Line, 0, Message'Address);
   end Rcheck_PE_Bad_Predicated_Generic_Type;

   -- 20
   procedure Rcheck_PE_Current_Task_In_Entry_Body
      (File : in System.Address;
       Line : in Integer)
      is
      Message : aliased constant String := PROGRAM_ERROR_PREFIX & "current task in entry body" & ISO88591.NUL;
   begin
      Abort_Library.System_Abort (File, Line, 0, Message'Address);
   end Rcheck_PE_Current_Task_In_Entry_Body;

   -- 21
   procedure Rcheck_PE_Duplicated_Entry_Address
      (File : in System.Address;
       Line : in Integer)
      is
      Message : aliased constant String := PROGRAM_ERROR_PREFIX & "duplicated entry address" & ISO88591.NUL;
   begin
      Abort_Library.System_Abort (File, Line, 0, Message'Address);
   end Rcheck_PE_Duplicated_Entry_Address;

   -- 22
   procedure Rcheck_PE_Explicit_Raise
      (File : in System.Address;
       Line : in Integer)
      is
      Message : aliased constant String := PROGRAM_ERROR_PREFIX & "explicit raise" & ISO88591.NUL;
   begin
      Abort_Library.System_Abort (File, Line, 0, Message'Address);
   end Rcheck_PE_Explicit_Raise;

   -- 23
   procedure Rcheck_PE_Finalize_Raised_Exception
      (File : in System.Address;
       Line : in Integer)
      is
      Message : aliased constant String := PROGRAM_ERROR_PREFIX & "finalize/adjust raised exception" & ISO88591.NUL;
   begin
      Abort_Library.System_Abort (File, Line, 0, Message'Address);
   end Rcheck_PE_Finalize_Raised_Exception;

   -- 24
   procedure Rcheck_PE_Implicit_Return
      (File : in System.Address;
       Line : in Integer)
      is
      Message : aliased constant String := PROGRAM_ERROR_PREFIX & "implicit return with No_Return" & ISO88591.NUL;
   begin
      Abort_Library.System_Abort (File, Line, 0, Message'Address);
   end Rcheck_PE_Implicit_Return;

   -- 25
   procedure Rcheck_PE_Misaligned_Address_Value
      (File : in System.Address;
       Line : in Integer)
      is
      Message : aliased constant String := PROGRAM_ERROR_PREFIX & "misaligned address value" & ISO88591.NUL;
   begin
      Abort_Library.System_Abort (File, Line, 0, Message'Address);
   end Rcheck_PE_Misaligned_Address_Value;

   -- 26
   procedure Rcheck_PE_Missing_Return
      (File : in System.Address;
       Line : in Integer)
      is
      Message : aliased constant String := PROGRAM_ERROR_PREFIX & "missing return" & ISO88591.NUL;
   begin
      Abort_Library.System_Abort (File, Line, 0, Message'Address);
   end Rcheck_PE_Missing_Return;

   -- 27
   procedure Rcheck_PE_Overlaid_Controlled_Object
      (File : in System.Address;
       Line : in Integer)
      is
      Message : aliased constant String := PROGRAM_ERROR_PREFIX & "overlaid controlled object" & ISO88591.NUL;
   begin
      Abort_Library.System_Abort (File, Line, 0, Message'Address);
   end Rcheck_PE_Overlaid_Controlled_Object;

   -- 28
   procedure Rcheck_PE_Potentially_Blocking_Operation
      (File : in System.Address;
       Line : in Integer)
      is
      Message : aliased constant String := PROGRAM_ERROR_PREFIX & "potentially blocking operation" & ISO88591.NUL;
   begin
      Abort_Library.System_Abort (File, Line, 0, Message'Address);
   end Rcheck_PE_Potentially_Blocking_Operation;

   -- 29
   procedure Rcheck_PE_Stubbed_Subprogram_Called
      (File : in System.Address;
       Line : in Integer)
      is
      Message : aliased constant String := PROGRAM_ERROR_PREFIX & "stubbed subprogram called" & ISO88591.NUL;
   begin
      Abort_Library.System_Abort (File, Line, 0, Message'Address);
   end Rcheck_PE_Stubbed_Subprogram_Called;

   -- 30
   procedure Rcheck_PE_Unchecked_Union_Restriction
      (File : in System.Address;
       Line : in Integer)
      is
      Message : aliased constant String := PROGRAM_ERROR_PREFIX & "unchecked union restriction" & ISO88591.NUL;
   begin
      Abort_Library.System_Abort (File, Line, 0, Message'Address);
   end Rcheck_PE_Unchecked_Union_Restriction;

   -- 31
   procedure Rcheck_PE_Non_Transportable_Actual
      (File : in System.Address;
       Line : in Integer)
      is
      Message : aliased constant String := PROGRAM_ERROR_PREFIX         &
                                           "actual/returned class-wide" &
                                           " value not transportable"   & ISO88591.NUL;
   begin
      Abort_Library.System_Abort (File, Line, 0, Message'Address);
   end Rcheck_PE_Non_Transportable_Actual;

   -- 32
   procedure Rcheck_SE_Empty_Storage_Pool
      (File : in System.Address;
       Line : in Integer)
      is
      Message : aliased constant String := STORAGE_ERROR_PREFIX & "empty storage pool" & ISO88591.NUL;
   begin
      Abort_Library.System_Abort (File, Line, 0, Message'Address);
   end Rcheck_SE_Empty_Storage_Pool;

   -- 33
   procedure Rcheck_SE_Explicit_Raise
      (File : in System.Address;
       Line : in Integer)
      is
      Message : aliased constant String := STORAGE_ERROR_PREFIX & "explicit raise" & ISO88591.NUL;
   begin
      Abort_Library.System_Abort (File, Line, 0, Message'Address);
   end Rcheck_SE_Explicit_Raise;

   -- 34
   procedure Rcheck_SE_Infinite_Recursion
      (File : in System.Address;
       Line : in Integer)
      is
      Message : aliased constant String := STORAGE_ERROR_PREFIX & "infinite recursion" & ISO88591.NUL;
   begin
      Abort_Library.System_Abort (File, Line, 0, Message'Address);
   end Rcheck_SE_Infinite_Recursion;

   -- 35
   procedure Rcheck_SE_Object_Too_Large
      (File : in System.Address;
       Line : in Integer)
      is
      Message : aliased constant String := STORAGE_ERROR_PREFIX & "object too large" & ISO88591.NUL;
   begin
      Abort_Library.System_Abort (File, Line, 0, Message'Address);
   end Rcheck_SE_Object_Too_Large;

   -- 36
   procedure Rcheck_PE_Stream_Operation_Not_Allowed
      (File : in System.Address;
       Line : in Integer)
      is
      Message : aliased constant String := PROGRAM_ERROR_PREFIX & "stream operation not allowed" & ISO88591.NUL;
   begin
      Abort_Library.System_Abort (File, Line, 0, Message'Address);
   end Rcheck_PE_Stream_Operation_Not_Allowed;

   -- activated by -gnateE compiler switch

   procedure Rcheck_CE_Access_Check_Ext
      (File   : in System.Address;
       Line   : in Integer;
       Column : in Integer)
      is
      pragma Unreferenced (Column);
      Message : aliased constant String := CONSTRAINT_ERROR_PREFIX & "access check" & ISO88591.NUL;
   begin
      Abort_Library.System_Abort (File, Line, 0, Message'Address);
   end Rcheck_CE_Access_Check_Ext;

   procedure Rcheck_CE_Index_Check_Ext
      (File   : in System.Address;
       Line   : in Integer;
       Column : in Integer;
       Index  : in Integer;
       First  : in Integer;
       Last   : in Integer)
      is
      pragma Unreferenced (Column);
      pragma Unreferenced (Index);
      pragma Unreferenced (First);
      pragma Unreferenced (Last);
      Message : aliased constant String := CONSTRAINT_ERROR_PREFIX & "index check" & ISO88591.NUL;
   begin
      Abort_Library.System_Abort (File, Line, 0, Message'Address);
   end Rcheck_CE_Index_Check_Ext;

   procedure Rcheck_CE_Invalid_Data_Ext
      (File   : in System.Address;
       Line   : in Integer;
       Column : in Integer;
       Index  : in Integer;
       First  : in Integer;
       Last   : in Integer)
      is
      pragma Unreferenced (Column);
      pragma Unreferenced (Index);
      pragma Unreferenced (First);
      pragma Unreferenced (Last);
      Message : aliased constant String := CONSTRAINT_ERROR_PREFIX & "invalid data" & ISO88591.NUL;
   begin
      Abort_Library.System_Abort (File, Line, 0, Message'Address);
   end Rcheck_CE_Invalid_Data_Ext;

   procedure Rcheck_CE_Range_Check_Ext
      (File   : in System.Address;
       Line   : in Integer;
       Column : in Integer;
       Index  : in Integer;
       First  : in Integer;
       Last   : in Integer)
      is
      pragma Unreferenced (Column);
      pragma Unreferenced (Index);
      pragma Unreferenced (First);
      pragma Unreferenced (Last);
      Message : aliased constant String := CONSTRAINT_ERROR_PREFIX & "range check" & ISO88591.NUL;
   begin
      Abort_Library.System_Abort (File, Line, 0, Message'Address);
   end Rcheck_CE_Range_Check_Ext;

end GNAT_Exceptions;

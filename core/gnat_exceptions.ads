-----------------------------------------------------------------------------------------------------------------------
--                                                     SweetAda                                                      --
-----------------------------------------------------------------------------------------------------------------------
-- __HDS__                                                                                                           --
-- __FLN__ gnat_exceptions.ads                                                                                       --
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

package GNAT_Exceptions is

   --========================================================================--
   --                                                                        --
   --                                                                        --
   --                               Public part                              --
   --                                                                        --
   --                                                                        --
   --========================================================================--

   pragma Preelaborate;

   -- "access check failed"
   procedure Rcheck_CE_Access_Check (File : in System.Address; Line : in Integer);
   -- "access parameter is null"
   procedure Rcheck_CE_Null_Access_Parameter (File : in System.Address; Line : in Integer);
   -- "discriminant check failed"
   procedure Rcheck_CE_Discriminant_Check (File : in System.Address; Line : in Integer);
   -- "divide by 0"
   procedure Rcheck_CE_Divide_By_Zero (File : in System.Address; Line : in Integer);
   -- "explicit raise"
   procedure Rcheck_CE_Explicit_Raise (File : in System.Address; Line : in Integer);
   -- "index check failed"
   procedure Rcheck_CE_Index_Check (File : in System.Address; Line : in Integer);
   -- "invalid data"
   procedure Rcheck_CE_Invalid_Data (File : in System.Address; Line : in Integer);
   -- "length check failed"
   procedure Rcheck_CE_Length_Check (File : in System.Address; Line : in Integer);
   -- "null Exception_Id"
   procedure Rcheck_CE_Null_Exception_Id (File : in System.Address; Line : in Integer);
   -- "null-exclusion check failed"
   procedure Rcheck_CE_Null_Not_Allowed (File : in System.Address; Line : in Integer);
   -- "overflow check failed"
   procedure Rcheck_CE_Overflow_Check (File : in System.Address; Line : in Integer);
   -- "partition check failed"
   procedure Rcheck_CE_Partition_Check (File : in System.Address; Line : in Integer);
   -- "range check failed"
   procedure Rcheck_CE_Range_Check (File : in System.Address; Line : in Integer);
   -- "tag check failed"
   procedure Rcheck_CE_Tag_Check (File : in System.Address; Line : in Integer);

   -- "access before elaboration"
   procedure Rcheck_PE_Access_Before_Elaboration (File : in System.Address; Line : in Integer);
   -- "accessibility check failed"
   procedure Rcheck_PE_Accessibility_Check (File : in System.Address; Line : in Integer);
   -- "attempt to take address of intrinsic subprogram"
   procedure Rcheck_PE_Address_Of_Intrinsic (File : in System.Address; Line : in Integer);
   -- "aliased parameters"
   procedure Rcheck_PE_Aliased_Parameters (File : in System.Address; Line : in Integer);
   -- "all guards closed"
   procedure Rcheck_PE_All_Guards_Closed (File : in System.Address; Line : in Integer);
   -- "improper use of generic subtype with predicate"
   procedure Rcheck_PE_Bad_Predicated_Generic_Type (File : in System.Address; Line : in Integer);
   -- "Current_Task referenced in entry body"
   procedure Rcheck_PE_Current_Task_In_Entry_Body (File : in System.Address; Line : in Integer);
   -- "duplicated entry address"
   procedure Rcheck_PE_Duplicated_Entry_Address (File : in System.Address; Line : in Integer);
   -- "explicit raise"
   procedure Rcheck_PE_Explicit_Raise (File : in System.Address; Line : in Integer);
   -- "finalize/adjust raised exception"
   procedure Rcheck_PE_Finalize_Raised_Exception (File : in System.Address; Line : in Integer);
   -- "implicit return with No_Return"
   procedure Rcheck_PE_Implicit_Return (File : in System.Address; Line : in Integer);
   -- "misaligned address value"
   procedure Rcheck_PE_Misaligned_Address_Value (File : in System.Address; Line : in Integer);
   -- "missing return"
   procedure Rcheck_PE_Missing_Return (File : in System.Address; Line : in Integer);
   -- "actual/returned class-wide value not transportable"
   procedure Rcheck_PE_Non_Transportable_Actual (File : in System.Address; Line : in Integer);
   -- "overlaid controlled object"
   procedure Rcheck_PE_Overlaid_Controlled_Object (File : in System.Address; Line : in Integer);
   -- "potentially blocking operation"
   procedure Rcheck_PE_Potentially_Blocking_Operation (File : in System.Address; Line : in Integer);
   -- "stream operation not allowed"
   procedure Rcheck_PE_Stream_Operation_Not_Allowed (File : in System.Address; Line : in Integer);
   -- "stubbed subprogram called"
   procedure Rcheck_PE_Stubbed_Subprogram_Called (File : in System.Address; Line : in Integer);
   -- "unchecked union restriction"
   procedure Rcheck_PE_Unchecked_Union_Restriction (File : in System.Address; Line : in Integer);

   -- "empty storage pool"
   procedure Rcheck_SE_Empty_Storage_Pool (File : in System.Address; Line : in Integer);
   -- "explicit raise"
   procedure Rcheck_SE_Explicit_Raise (File : in System.Address; Line : in Integer);
   -- "infinite recursion"
   procedure Rcheck_SE_Infinite_Recursion (File : in System.Address; Line : in Integer);
   -- "object too large"
   procedure Rcheck_SE_Object_Too_Large (File : in System.Address; Line : in Integer);

   -- procedure Rcheck_CE_Access_Check_Ext (File : in System.Address; Line, Column : in Integer);
   -- procedure Rcheck_CE_Index_Check_Ext (File : in System.Address; Line, Column, Index, First, Last : in Integer);
   -- procedure Rcheck_CE_Invalid_Data_Ext (File : in System.Address; Line, Column, Index, First, Last : in Integer);
   -- procedure Rcheck_CE_Range_Check_Ext (File : in System.Address; Line, Column, Index, First, Last : in Integer);

private

   --========================================================================--
   --                                                                        --
   --                                                                        --
   --                              Private part                              --
   --                                                                        --
   --                                                                        --
   --========================================================================--

   pragma Export (C, Rcheck_CE_Access_Check, "__gnat_rcheck_CE_Access_Check");
   pragma No_Return (Rcheck_CE_Access_Check);
   pragma Export (C, Rcheck_CE_Null_Access_Parameter, "__gnat_rcheck_CE_Null_Access_Parameter");
   pragma No_Return (Rcheck_CE_Null_Access_Parameter);
   pragma Export (C, Rcheck_CE_Discriminant_Check, "__gnat_rcheck_CE_Discriminant_Check");
   pragma No_Return (Rcheck_CE_Discriminant_Check);
   pragma Export (C, Rcheck_CE_Divide_By_Zero, "__gnat_rcheck_CE_Divide_By_Zero");
   pragma No_Return (Rcheck_CE_Divide_By_Zero);
   pragma Export (C, Rcheck_CE_Explicit_Raise, "__gnat_rcheck_CE_Explicit_Raise");
   pragma No_Return (Rcheck_CE_Explicit_Raise);
   pragma Export (C, Rcheck_CE_Index_Check, "__gnat_rcheck_CE_Index_Check");
   pragma No_Return (Rcheck_CE_Index_Check);
   pragma Export (C, Rcheck_CE_Invalid_Data, "__gnat_rcheck_CE_Invalid_Data");
   pragma No_Return (Rcheck_CE_Invalid_Data);
   pragma Export (C, Rcheck_CE_Length_Check, "__gnat_rcheck_CE_Length_Check");
   pragma No_Return (Rcheck_CE_Length_Check);
   pragma Export (C, Rcheck_CE_Null_Exception_Id, "__gnat_rcheck_CE_Null_Exception_Id");
   pragma No_Return (Rcheck_CE_Null_Exception_Id);
   pragma Export (C, Rcheck_CE_Null_Not_Allowed, "__gnat_rcheck_CE_Null_Not_Allowed");
   pragma No_Return (Rcheck_CE_Null_Not_Allowed);
   pragma Export (C, Rcheck_CE_Overflow_Check, "__gnat_rcheck_CE_Overflow_Check");
   pragma No_Return (Rcheck_CE_Overflow_Check);
   pragma Export (C, Rcheck_CE_Partition_Check, "__gnat_rcheck_CE_Partition_Check");
   pragma No_Return (Rcheck_CE_Partition_Check);
   pragma Export (C, Rcheck_CE_Range_Check, "__gnat_rcheck_CE_Range_Check");
   pragma No_Return (Rcheck_CE_Range_Check);
   pragma Export (C, Rcheck_CE_Tag_Check, "__gnat_rcheck_CE_Tag_Check");
   pragma No_Return (Rcheck_CE_Tag_Check);

   pragma Export (C, Rcheck_PE_Access_Before_Elaboration, "__gnat_rcheck_PE_Access_Before_Elaboration");
   pragma No_Return (Rcheck_PE_Access_Before_Elaboration);
   pragma Export (C, Rcheck_PE_Accessibility_Check, "__gnat_rcheck_PE_Accessibility_Check");
   pragma No_Return (Rcheck_PE_Accessibility_Check);
   pragma Export (C, Rcheck_PE_Address_Of_Intrinsic, "__gnat_rcheck_PE_Address_Of_Intrinsic");
   pragma No_Return (Rcheck_PE_Address_Of_Intrinsic);
   pragma Export (C, Rcheck_PE_Aliased_Parameters, "__gnat_rcheck_PE_Aliased_Parameters");
   pragma No_Return (Rcheck_PE_Aliased_Parameters);
   pragma Export (C, Rcheck_PE_All_Guards_Closed, "__gnat_rcheck_PE_All_Guards_Closed");
   pragma No_Return (Rcheck_PE_All_Guards_Closed);
   pragma Export (C, Rcheck_PE_Bad_Predicated_Generic_Type, "__gnat_rcheck_PE_Bad_Predicated_Generic_Type");
   pragma No_Return (Rcheck_PE_Bad_Predicated_Generic_Type);
   pragma Export (C, Rcheck_PE_Current_Task_In_Entry_Body, "__gnat_rcheck_PE_Current_Task_In_Entry_Body");
   pragma No_Return (Rcheck_PE_Current_Task_In_Entry_Body);
   pragma Export (C, Rcheck_PE_Duplicated_Entry_Address, "__gnat_rcheck_PE_Duplicated_Entry_Address");
   pragma No_Return (Rcheck_PE_Duplicated_Entry_Address);
   pragma Export (C, Rcheck_PE_Explicit_Raise, "__gnat_rcheck_PE_Explicit_Raise");
   pragma No_Return (Rcheck_PE_Explicit_Raise);
   pragma Export (C, Rcheck_PE_Finalize_Raised_Exception, "__gnat_rcheck_PE_Finalize_Raised_Exception");
   pragma No_Return (Rcheck_PE_Finalize_Raised_Exception);
   pragma Export (C, Rcheck_PE_Implicit_Return, "__gnat_rcheck_PE_Implicit_Return");
   pragma No_Return (Rcheck_PE_Implicit_Return);
   pragma Export (C, Rcheck_PE_Misaligned_Address_Value, "__gnat_rcheck_PE_Misaligned_Address_Value");
   pragma No_Return (Rcheck_PE_Misaligned_Address_Value);
   pragma Export (C, Rcheck_PE_Missing_Return, "__gnat_rcheck_PE_Missing_Return");
   pragma No_Return (Rcheck_PE_Missing_Return);
   pragma Export (C, Rcheck_PE_Non_Transportable_Actual, "__gnat_rcheck_PE_Non_Transportable_Actual");
   pragma No_Return (Rcheck_PE_Non_Transportable_Actual);
   pragma Export (C, Rcheck_PE_Overlaid_Controlled_Object, "__gnat_rcheck_PE_Overlaid_Controlled_Object");
   pragma No_Return (Rcheck_PE_Overlaid_Controlled_Object);
   pragma Export (C, Rcheck_PE_Potentially_Blocking_Operation, "__gnat_rcheck_PE_Potentially_Blocking_Operation");
   pragma No_Return (Rcheck_PE_Potentially_Blocking_Operation);
   pragma Export (C, Rcheck_PE_Stream_Operation_Not_Allowed, "__gnat_rcheck_PE_Stream_Operation_Not_Allowed");
   pragma No_Return (Rcheck_PE_Stream_Operation_Not_Allowed);
   pragma Export (C, Rcheck_PE_Stubbed_Subprogram_Called, "__gnat_rcheck_PE_Stubbed_Subprogram_Called");
   pragma No_Return (Rcheck_PE_Stubbed_Subprogram_Called);
   pragma Export (C, Rcheck_PE_Unchecked_Union_Restriction, "__gnat_rcheck_PE_Unchecked_Union_Restriction");
   pragma No_Return (Rcheck_PE_Unchecked_Union_Restriction);

   pragma Export (C, Rcheck_SE_Empty_Storage_Pool, "__gnat_rcheck_SE_Empty_Storage_Pool");
   pragma No_Return (Rcheck_SE_Empty_Storage_Pool);
   pragma Export (C, Rcheck_SE_Explicit_Raise, "__gnat_rcheck_SE_Explicit_Raise");
   pragma No_Return (Rcheck_SE_Explicit_Raise);
   pragma Export (C, Rcheck_SE_Infinite_Recursion, "__gnat_rcheck_SE_Infinite_Recursion");
   pragma No_Return (Rcheck_SE_Infinite_Recursion);
   pragma Export (C, Rcheck_SE_Object_Too_Large, "__gnat_rcheck_SE_Object_Too_Large");
   pragma No_Return (Rcheck_SE_Object_Too_Large);

   -- pragma Export (C, Rcheck_CE_Access_Check_Ext, "__gnat_rcheck_CE_Access_Check_ext");
   -- pragma No_Return (Rcheck_CE_Access_Check_Ext);
   -- pragma Export (C, Rcheck_CE_Index_Check_Ext, "__gnat_rcheck_CE_Index_Check_ext");
   -- pragma No_Return (Rcheck_CE_Index_Check_Ext);
   -- pragma Export (C, Rcheck_CE_Invalid_Data_Ext, "__gnat_rcheck_CE_Invalid_Data_ext");
   -- pragma No_Return (Rcheck_CE_Invalid_Data_Ext);
   -- pragma Export (C, Rcheck_CE_Range_Check_Ext, "__gnat_rcheck_CE_Range_Check_ext");
   -- pragma No_Return (Rcheck_CE_Range_Check_Ext);

end GNAT_Exceptions;

-----------------------------------------------------------------------------------------------------------------------
--                                                     SweetAda                                                      --
-----------------------------------------------------------------------------------------------------------------------
-- __HDS__                                                                                                           --
-- __FLN__ gnat_exceptions.ads                                                                                       --
-- __DSC__                                                                                                           --
-- __HSH__ e69de29bb2d1d6434b8b29ae775ad8c2e48c5391                                                                  --
-- __HDE__                                                                                                           --
-----------------------------------------------------------------------------------------------------------------------
-- Copyright (C) 2020-2025 Gabriele Galeotti                                                                         --
--                                                                                                                   --
-- SweetAda web page: http://sweetada.org                                                                            --
-- contact address: gabriele.galeotti@sweetada.org                                                                   --
-- This work is licensed under the terms of the MIT License.                                                         --
-- Please consult the LICENSE.txt file located in the top-level directory.                                           --
-----------------------------------------------------------------------------------------------------------------------

with System;

package GNAT_Exceptions
   with Preelaborate => True,
        SPARK_Mode   => On
   is

   --========================================================================--
   --                                                                        --
   --                                                                        --
   --                               Public part                              --
   --                                                                        --
   --                                                                        --
   --========================================================================--

   procedure Rcheck_CE_Access_Check
      (File : in System.Address;
       Line : in Integer)
      with No_Return     => True,
           Export        => True,
           Convention    => C,
           External_Name => "__gnat_rcheck_CE_Access_Check";

   procedure Rcheck_CE_Null_Access_Parameter
      (File : in System.Address;
       Line : in Integer)
      with No_Return     => True,
           Export        => True,
           Convention    => C,
           External_Name => "__gnat_rcheck_CE_Null_Access_Parameter";

   procedure Rcheck_CE_Discriminant_Check
      (File : in System.Address;
       Line : in Integer)
      with No_Return     => True,
           Export        => True,
           Convention    => C,
           External_Name => "__gnat_rcheck_CE_Discriminant_Check";

   procedure Rcheck_CE_Divide_By_Zero
      (File : in System.Address;
       Line : in Integer)
      with No_Return     => True,
           Export        => True,
           Convention    => C,
           External_Name => "__gnat_rcheck_CE_Divide_By_Zero";

   procedure Rcheck_CE_Explicit_Raise
      (File : in System.Address;
       Line : in Integer)
      with No_Return     => True,
           Export        => True,
           Convention    => C,
           External_Name => "__gnat_rcheck_CE_Explicit_Raise";

   procedure Rcheck_CE_Index_Check
      (File : in System.Address;
       Line : in Integer)
      with No_Return     => True,
           Export        => True,
           Convention    => C,
           External_Name => "__gnat_rcheck_CE_Index_Check";

   procedure Rcheck_CE_Invalid_Data
      (File : in System.Address;
       Line : in Integer)
      with No_Return     => True,
           Export        => True,
           Convention    => C,
           External_Name => "__gnat_rcheck_CE_Invalid_Data";

   procedure Rcheck_CE_Length_Check
      (File : in System.Address;
       Line : in Integer)
      with No_Return     => True,
           Export        => True,
           Convention    => C,
           External_Name => "__gnat_rcheck_CE_Length_Check";

   procedure Rcheck_CE_Null_Exception_Id
      (File : in System.Address;
       Line : in Integer)
      with No_Return     => True,
           Export        => True,
           Convention    => C,
           External_Name => "__gnat_rcheck_CE_Null_Exception_Id";

   procedure Rcheck_CE_Null_Not_Allowed
      (File : in System.Address;
       Line : in Integer)
      with No_Return     => True,
           Export        => True,
           Convention    => C,
           External_Name => "__gnat_rcheck_CE_Null_Not_Allowed";

   procedure Rcheck_CE_Overflow_Check
      (File : in System.Address;
       Line : in Integer)
      with No_Return     => True,
           Export        => True,
           Convention    => C,
           External_Name => "__gnat_rcheck_CE_Overflow_Check";

   procedure Rcheck_CE_Partition_Check
      (File : in System.Address;
       Line : in Integer)
      with No_Return     => True,
           Export        => True,
           Convention    => C,
           External_Name => "__gnat_rcheck_CE_Partition_Check";

   procedure Rcheck_CE_Range_Check
      (File : in System.Address;
       Line : in Integer)
      with No_Return     => True,
           Export        => True,
           Convention    => C,
           External_Name => "__gnat_rcheck_CE_Range_Check";

   procedure Rcheck_CE_Tag_Check
      (File : in System.Address;
       Line : in Integer)
      with No_Return     => True,
           Export        => True,
           Convention    => C,
           External_Name => "__gnat_rcheck_CE_Tag_Check";

   procedure Rcheck_PE_Access_Before_Elaboration
      (File : in System.Address;
       Line : in Integer)
      with No_Return     => True,
           Export        => True,
           Convention    => C,
           External_Name => "__gnat_rcheck_PE_Access_Before_Elaboration";

   procedure Rcheck_PE_Accessibility_Check
      (File : in System.Address;
       Line : in Integer)
      with No_Return     => True,
           Export        => True,
           Convention    => C,
           External_Name => "__gnat_rcheck_PE_Accessibility_Check";

   procedure Rcheck_PE_Address_Of_Intrinsic
      (File : in System.Address;
       Line : in Integer)
      with No_Return     => True,
           Export        => True,
           Convention    => C,
           External_Name => "__gnat_rcheck_PE_Address_Of_Intrinsic";

   procedure Rcheck_PE_Aliased_Parameters
      (File : in System.Address;
       Line : in Integer)
      with No_Return     => True,
           Export        => True,
           Convention    => C,
           External_Name => "__gnat_rcheck_PE_Aliased_Parameters";

   procedure Rcheck_PE_All_Guards_Closed
      (File : in System.Address;
       Line : in Integer)
      with No_Return     => True,
           Export        => True,
           Convention    => C,
           External_Name => "__gnat_rcheck_PE_All_Guards_Closed";

   procedure Rcheck_PE_Bad_Predicated_Generic_Type
      (File : in System.Address;
       Line : in Integer)
      with No_Return     => True,
           Export        => True,
           Convention    => C,
           External_Name => "__gnat_rcheck_PE_Bad_Predicated_Generic_Type";

   procedure Rcheck_PE_Current_Task_In_Entry_Body
      (File : in System.Address;
       Line : in Integer)
      with No_Return     => True,
           Export        => True,
           Convention    => C,
           External_Name => "__gnat_rcheck_PE_Current_Task_In_Entry_Body";

   procedure Rcheck_PE_Duplicated_Entry_Address
      (File : in System.Address;
       Line : in Integer)
      with No_Return     => True,
           Export        => True,
           Convention    => C,
           External_Name => "__gnat_rcheck_PE_Duplicated_Entry_Address";

   procedure Rcheck_PE_Explicit_Raise
      (File : in System.Address;
       Line : in Integer)
      with No_Return     => True,
           Export        => True,
           Convention    => C,
           External_Name => "__gnat_rcheck_PE_Explicit_Raise";

   procedure Rcheck_PE_Finalize_Raised_Exception
      (File : in System.Address;
       Line : in Integer)
      with No_Return     => True,
           Export        => True,
           Convention    => C,
           External_Name => "__gnat_rcheck_PE_Finalize_Raised_Exception";

   procedure Rcheck_PE_Implicit_Return
      (File : in System.Address;
       Line : in Integer)
      with No_Return     => True,
           Export        => True,
           Convention    => C,
           External_Name => "__gnat_rcheck_PE_Implicit_Return";

   procedure Rcheck_PE_Misaligned_Address_Value
      (File : in System.Address;
       Line : in Integer)
      with No_Return     => True,
           Export        => True,
           Convention    => C,
           External_Name => "__gnat_rcheck_PE_Misaligned_Address_Value";

   procedure Rcheck_PE_Missing_Return
      (File : in System.Address;
       Line : in Integer)
      with No_Return     => True,
           Export        => True,
           Convention    => C,
           External_Name => "__gnat_rcheck_PE_Missing_Return";

   procedure Rcheck_PE_Non_Transportable_Actual
      (File : in System.Address;
       Line : in Integer)
      with No_Return     => True,
           Export        => True,
           Convention    => C,
           External_Name => "__gnat_rcheck_PE_Non_Transportable_Actual";

   procedure Rcheck_PE_Overlaid_Controlled_Object
      (File : in System.Address;
       Line : in Integer)
      with No_Return     => True,
           Export        => True,
           Convention    => C,
           External_Name => "__gnat_rcheck_PE_Overlaid_Controlled_Object";

   procedure Rcheck_PE_Potentially_Blocking_Operation
      (File : in System.Address;
       Line : in Integer)
      with No_Return     => True,
           Export        => True,
           Convention    => C,
           External_Name => "__gnat_rcheck_PE_Potentially_Blocking_Operation";

   procedure Rcheck_PE_Stream_Operation_Not_Allowed
      (File : in System.Address;
       Line : in Integer)
      with No_Return     => True,
           Export        => True,
           Convention    => C,
           External_Name => "__gnat_rcheck_PE_Stream_Operation_Not_Allowed";

   procedure Rcheck_PE_Stubbed_Subprogram_Called
      (File : in System.Address;
       Line : in Integer)
      with No_Return     => True,
           Export        => True,
           Convention    => C,
           External_Name => "__gnat_rcheck_PE_Stubbed_Subprogram_Called";

   procedure Rcheck_PE_Unchecked_Union_Restriction
      (File : in System.Address;
       Line : in Integer)
      with No_Return     => True,
           Export        => True,
           Convention    => C,
           External_Name => "__gnat_rcheck_PE_Unchecked_Union_Restriction";

   procedure Rcheck_SE_Empty_Storage_Pool
      (File : in System.Address;
       Line : in Integer)
      with No_Return     => True,
           Export        => True,
           Convention    => C,
           External_Name => "__gnat_rcheck_SE_Empty_Storage_Pool";

   procedure Rcheck_SE_Explicit_Raise
      (File : in System.Address;
       Line : in Integer)
      with No_Return     => True,
           Export        => True,
           Convention    => C,
           External_Name => "__gnat_rcheck_SE_Explicit_Raise";

   procedure Rcheck_SE_Infinite_Recursion
      (File : in System.Address;
       Line : in Integer)
      with No_Return     => True,
           Export        => True,
           Convention    => C,
           External_Name => "__gnat_rcheck_SE_Infinite_Recursion";

   procedure Rcheck_SE_Object_Too_Large
      (File : in System.Address;
       Line : in Integer)
      with No_Return     => True,
           Export        => True,
           Convention    => C,
           External_Name => "__gnat_rcheck_SE_Object_Too_Large";

   procedure Rcheck_CE_Access_Check_Ext
      (File   : in System.Address;
       Line   : in Integer;
       Column : in Integer)
      with No_Return     => True,
           Export        => True,
           Convention    => C,
           External_Name => "__gnat_rcheck_CE_Access_Check_ext";

   procedure Rcheck_CE_Index_Check_Ext
      (File   : in System.Address;
       Line   : in Integer;
       Column : in Integer;
       Index  : in Integer;
       First  : in Integer;
       Last   : in Integer)
      with No_Return     => True,
           Export        => True,
           Convention    => C,
           External_Name => "__gnat_rcheck_CE_Index_Check_ext";

   procedure Rcheck_CE_Invalid_Data_Ext
      (File   : in System.Address;
       Line   : in Integer;
       Column : in Integer;
       Index  : in Integer;
       First  : in Integer;
       Last   : in Integer)
      with No_Return     => True,
           Export        => True,
           Convention    => C,
           External_Name => "__gnat_rcheck_CE_Invalid_Data_ext";

   procedure Rcheck_CE_Range_Check_Ext
      (File   : in System.Address;
       Line   : in Integer;
       Column : in Integer;
       Index  : in Integer;
       First  : in Integer;
       Last   : in Integer)
      with No_Return     => True,
           Export        => True,
           Convention    => C,
           External_Name => "__gnat_rcheck_CE_Range_Check_ext";

end GNAT_Exceptions;

-----------------------------------------------------------------------------------------------------------------------
--                                                     SweetAda                                                      --
-----------------------------------------------------------------------------------------------------------------------
-- __HDS__                                                                                                           --
-- __FLN__ unwind.ads                                                                                                --
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

package Unwind is

   --========================================================================--
   --                                                                        --
   --                                                                        --
   --                               Public part                              --
   --                                                                        --
   --                                                                        --
   --========================================================================--

   type Unwind_Reason_Code is range 0 .. 8;

   URC_NO_REASON                : constant Unwind_Reason_Code := 0;
   URC_FOREIGN_EXCEPTION_CAUGHT : constant Unwind_Reason_Code := 1;
   URC_FATAL_PHASE2_ERROR       : constant Unwind_Reason_Code := 2;
   URC_FATAL_PHASE1_ERROR       : constant Unwind_Reason_Code := 3;
   URC_NORMAL_STOP              : constant Unwind_Reason_Code := 4;
   URC_END_OF_STACK             : constant Unwind_Reason_Code := 5;
   URC_HANDLER_FOUND            : constant Unwind_Reason_Code := 6;
   URC_INSTALL_CONTEXT          : constant Unwind_Reason_Code := 7;
   URC_CONTINUE_UNWIND          : constant Unwind_Reason_Code := 8;

   -- unnecessary at -O1 or above
   -- procedure Unwind_Resume (Exception_Object_Address : in Address);

   function EABI_unwind_cpp_pr0
      return Unwind_Reason_Code
      with Export        => True,
           Convention    => C,
           External_Name => "__aeabi_unwind_cpp_pr0";
   function EABI_unwind_cpp_pr1
      return Unwind_Reason_Code
      with Export        => True,
           Convention    => C,
           External_Name => "__aeabi_unwind_cpp_pr1";
   function EABI_unwind_cpp_pr2
      return Unwind_Reason_Code
      with Export        => True,
           Convention    => C,
           External_Name => "__aeabi_unwind_cpp_pr2";

end Unwind;

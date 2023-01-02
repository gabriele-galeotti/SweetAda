-----------------------------------------------------------------------------------------------------------------------
--                                                     SweetAda                                                      --
-----------------------------------------------------------------------------------------------------------------------
-- __HDS__                                                                                                           --
-- __FLN__ unwind.adb                                                                                                --
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

package body Unwind is

   --========================================================================--
   --                                                                        --
   --                                                                        --
   --                           Local declarations                           --
   --                                                                        --
   --                                                                        --
   --========================================================================--

   --========================================================================--
   --                                                                        --
   --                                                                        --
   --                           Package subprograms                          --
   --                                                                        --
   --                                                                        --
   --========================================================================--

   ----------------------------------------------------------------------------
   -- Unwind_Resume
   ----------------------------------------------------------------------------
   -- procedure Unwind_Resume (Exception_Object_Address : in Address) is
   --    pragma Unreferenced (Exception_Object_Address);
   -- begin
   --    null;
   -- end Unwind_Resume;

   ----------------------------------------------------------------------------
   -- ABI defined personality routine entry points
   ----------------------------------------------------------------------------

   function EABI_unwind_cpp_pr0 return Unwind_Reason_Code is
   begin
      -- return __gnu_unwind_pr_common (state, ucbp, context, 0);
      return URC_NO_REASON;
   end EABI_unwind_cpp_pr0;

   function EABI_unwind_cpp_pr1 return Unwind_Reason_Code is
   begin
      -- return __gnu_unwind_pr_common (state, ucbp, context, 1);
      return URC_NO_REASON;
   end EABI_unwind_cpp_pr1;

   function EABI_unwind_cpp_pr2 return Unwind_Reason_Code is
   begin
      -- return __gnu_unwind_pr_common (state, ucbp, context, 2);
      return URC_NO_REASON;
   end EABI_unwind_cpp_pr2;

end Unwind;

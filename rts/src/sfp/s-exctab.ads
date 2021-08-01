------------------------------------------------------------------------------
--                                                                          --
--                         GNAT COMPILER COMPONENTS                         --
--                                                                          --
--                 S Y S T E M . E X C E P T I O N _ T A B L E              --
--                                                                          --
--                                 S p e c                                  --
--                                                                          --
--          Copyright (C) 1996-2020, Free Software Foundation, Inc.         --
--                                                                          --
-- GNAT is free software;  you can  redistribute it  and/or modify it under --
-- terms of the  GNU General Public License as published  by the Free Soft- --
-- ware  Foundation;  either version 3,  or (at your option) any later ver- --
-- sion.  GNAT is distributed in the hope that it will be useful, but WITH- --
-- OUT ANY WARRANTY;  without even the  implied warranty of MERCHANTABILITY --
-- or FITNESS FOR A PARTICULAR PURPOSE.                                     --
--                                                                          --
-- As a special exception under Section 7 of GPL version 3, you are granted --
-- additional permissions described in the GCC Runtime Library Exception,   --
-- version 3.1, as published by the Free Software Foundation.               --
--                                                                          --
-- You should have received a copy of the GNU General Public License and    --
-- a copy of the GCC Runtime Library Exception along with this program;     --
-- see the files COPYING3 and COPYING.RUNTIME respectively.  If not, see    --
-- <http://www.gnu.org/licenses/>.                                          --
--                                                                          --
-- GNAT was originally developed  by the GNAT team at  New York University. --
-- Extensive contributions were provided by Ada Core Technologies Inc.      --
--                                                                          --
------------------------------------------------------------------------------
-- SweetAda SFP cutted-down version                                         --
------------------------------------------------------------------------------

--  This package implements the interface used to maintain a table of
--  registered exception names, for the implementation of the mapping
--  of names to exceptions (used for exception streams and attributes)

pragma Compiler_Unit_Warning;

with System.Standard_Library;

package System.Exception_Table is
   pragma Elaborate_Body;

   package SSL renames System.Standard_Library;

   procedure Register_Exception (X : SSL.Exception_Data_Ptr);
   pragma Inline (Register_Exception);
   --  Register an exception in the hash table mapping. This function is
   --  called during elaboration of library packages. For exceptions that
   --  are declared within subprograms, the registration occurs the first
   --  time that an exception is elaborated during a call of the subprogram.
   --
   --  Note: all calls to Register_Exception other than those to register the
   --  predefined exceptions are suppressed if the application is compiled
   --  with pragma Restrictions (No_Exception_Registration).

end System.Exception_Table;

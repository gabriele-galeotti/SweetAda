------------------------------------------------------------------------------
--                                                                          --
--                         GNAT RUN-TIME COMPONENTS                         --
--                                                                          --
--                       A D A . E X C E P T I O N S                        --
--                                                                          --
--                                 S p e c                                  --
--                                                                          --
--          Copyright (C) 1992-2022, Free Software Foundation, Inc.         --
--                                                                          --
-- This specification is derived from the Ada Reference Manual for use with --
-- GNAT. The copyright notice above, and the license provisions that follow --
-- apply solely to the  contents of the part following the private keyword. --
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

--  This is the default version of this package. We also have cert and zfp
--  versions.

with System.Standard_Library;

package Ada.Exceptions is
   pragma Preelaborate;
   --  In accordance with Ada 2005 AI-362.

   type Exception_Id is private;
   pragma Preelaborable_Initialization (Exception_Id);

   Null_Id : constant Exception_Id;

   procedure Raise_Exception (E : Exception_Id; Message : String := "");
   pragma No_Return (Raise_Exception);
   --  Unconditionally call __gnat_last_chance_handler. Message should be a
   --  null terminated string. Note that the exception is still raised even
   --  if E is the null exception id. This is a deliberate simplification for
   --  this profile (the use of Raise_Exception with a null id is very rare in
   --  any case, and this way we avoid introducing Raise_Exception_Always and
   --  we also avoid the if test in Raise_Exception).

private
   package SSL renames System.Standard_Library;

   type Exception_Id is new SSL.Exception_Data_Ptr;

   Null_Id : constant Exception_Id := null;

end Ada.Exceptions;

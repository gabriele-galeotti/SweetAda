------------------------------------------------------------------------------
--                                                                          --
--                         GNAT RUN-TIME COMPONENTS                         --
--                                                                          --
--                             A D A . T A G S                              --
--                                                                          --
--                                 B o d y                                  --
--                                                                          --
--          Copyright (C) 1992-2020, Free Software Foundation, Inc.         --
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

--  This is the HI-E version of this file. Some functionality has been
--  removed in order to simplify this run-time unit.

with Ada.Unchecked_Conversion;
with System.Storage_Elements; use System.Storage_Elements;

package body Ada.Tags is

   -----------------------
   -- Local Subprograms --
   -----------------------

   function Length (Str : Cstring_Ptr) return Natural;
   --  Length of string represented by the given pointer (treating the string
   --  as a C-style string, which is Nul terminated).

   --  Unchecked Conversions

   function To_Addr_Ptr is
      new Ada.Unchecked_Conversion (System.Address, Addr_Ptr);

   function To_Address is
     new Ada.Unchecked_Conversion (Tag, System.Address);

   function To_Type_Specific_Data_Ptr is
     new Ada.Unchecked_Conversion (System.Address, Type_Specific_Data_Ptr);

   -------------------
   -- CW_Membership --
   -------------------

   --  Canonical implementation of Classwide Membership corresponding to:

   --     Obj in Typ'Class

   --  Each dispatch table contains a reference to a table of ancestors (stored
   --  in the first part of the Tags_Table) and a count of the level of
   --  inheritance "Idepth".

   --  Obj is in Typ'Class if Typ'Tag is in the table of ancestors that are
   --  contained in the dispatch table referenced by Obj'Tag . Knowing the
   --  level of inheritance of both types, this can be computed in constant
   --  time by the formula:

   --   TSD (Obj'tag).Tags_Table (TSD (Obj'tag).Idepth - TSD (Typ'tag).Idepth)
   --     = Typ'tag

   function CW_Membership (Obj_Tag : Tag; Typ_Tag : Tag) return Boolean is
      Obj_TSD_Ptr : constant Addr_Ptr :=
        To_Addr_Ptr (To_Address (Obj_Tag) - DT_Typeinfo_Ptr_Size);
      Typ_TSD_Ptr : constant Addr_Ptr :=
        To_Addr_Ptr (To_Address (Typ_Tag) - DT_Typeinfo_Ptr_Size);
      Obj_TSD     : constant Type_Specific_Data_Ptr :=
        To_Type_Specific_Data_Ptr (Obj_TSD_Ptr.all);
      Typ_TSD     : constant Type_Specific_Data_Ptr :=
        To_Type_Specific_Data_Ptr (Typ_TSD_Ptr.all);
      Pos         : constant Integer := Obj_TSD.Idepth - Typ_TSD.Idepth;
   begin
      return Pos >= 0 and then Obj_TSD.Tags_Table (Pos) = Typ_Tag;
   end CW_Membership;

   -------------------
   -- Expanded_Name --
   -------------------

   function Expanded_Name (T : Tag) return String is
      Result  : Cstring_Ptr;
      TSD_Ptr : Addr_Ptr;
      TSD     : Type_Specific_Data_Ptr;

   begin
      if T = No_Tag then
         raise Tag_Error;
      end if;

      TSD_Ptr := To_Addr_Ptr (To_Address (T) - DT_Typeinfo_Ptr_Size);
      TSD     := To_Type_Specific_Data_Ptr (TSD_Ptr.all);
      Result  := TSD.Expanded_Name;
      return Result (1 .. Length (Result));
   end Expanded_Name;

   ------------------
   -- External_Tag --
   ------------------

   function External_Tag (T : Tag) return String is
      Result  : Cstring_Ptr;
      TSD_Ptr : Addr_Ptr;
      TSD     : Type_Specific_Data_Ptr;

   begin
      if T = No_Tag then
         raise Tag_Error;
      end if;

      TSD_Ptr := To_Addr_Ptr (To_Address (T) - DT_Typeinfo_Ptr_Size);
      TSD     := To_Type_Specific_Data_Ptr (TSD_Ptr.all);
      Result  := TSD.External_Tag;
      return Result (1 .. Length (Result));
   end External_Tag;

   ------------
   -- Length --
   ------------

   function Length (Str : Cstring_Ptr) return Natural is
      Len : Integer;

   begin
      Len := 1;
      while Str (Len) /= ASCII.NUL loop
         Len := Len + 1;
      end loop;

      return Len - 1;
   end Length;

   ----------------
   -- Parent_Tag --
   ----------------

   function Parent_Tag (T : Tag) return Tag is
      TSD_Ptr : Addr_Ptr;
      TSD     : Type_Specific_Data_Ptr;

   begin
      if T = No_Tag then
         raise Tag_Error;
      end if;

      TSD_Ptr := To_Addr_Ptr (To_Address (T) - DT_Typeinfo_Ptr_Size);
      TSD     := To_Type_Specific_Data_Ptr (TSD_Ptr.all);

      --  The Parent_Tag of a root-level tagged type is defined to be No_Tag.
      --  The first entry in the Ancestors_Tags array will be null for such
      --  a type, but it's better to be explicit about returning No_Tag in
      --  this case.

      if TSD.Idepth = 0 then
         return No_Tag;
      else
         return TSD.Tags_Table (1);
      end if;
   end Parent_Tag;

end Ada.Tags;

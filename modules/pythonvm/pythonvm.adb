-----------------------------------------------------------------------------------------------------------------------
--                                                     SweetAda                                                      --
-----------------------------------------------------------------------------------------------------------------------
-- __HDS__                                                                                                           --
-- __FLN__ pythonvm.adb                                                                                              --
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
with System.Address_To_Access_Conversions;
with Ada.Unchecked_Conversion;
with Interfaces;
with PythonVM.Defs;
with Console;

package body PythonVM is

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
   use PythonVM.Defs;

   -- Include/pyport.h

   type Py_ssize_t is range -(2**(Standard'Address_Size - 1)) .. +(2**(Standard'Address_Size - 1)) - 1;

   -- Include/object.h

   type object;
   type object_Ptr is access all object;
   type object is
   record
      -- ob_next   : object_Ptr;
      -- ob_prev   : object_Ptr;
      ob_refcnt : Py_ssize_t;
      ob_type   : Address;
   end record;

   type PyObject_Head_Type is new object;
   type PyObject_Head_Ptr is access PyObject_Head_Type;

   type PyObject_VarHead_Type is
   record
      head    : PyObject_Head_Type;
      ob_size : Py_ssize_t;         -- number of items in variable part
   end record;

   -- Include/tupleobject.h

   type PyTupleObject_Type is array (Natural) of PyObject_Head_Ptr with
      Pack                    => True,
      Suppress_Initialization => True; -- pragma Restrictions (No_Implicit_Loops)
   type PyTupleObject_Ptr is access all PyTupleObject_Type;

   -- Include/code.h

   type PyCodeObject_Type is
   record
      ob_base        : PyObject_Head_Type;
      co_argcount    : Integer;
      co_nlocals     : Integer;
      co_stacksize   : Integer;
      co_flags       : Integer;
      co_code        : PyObject_Head_Ptr;
      co_consts      : PyObject_Head_Ptr;
      co_names       : PyObject_Head_Ptr;
      co_varnames    : PyObject_Head_Ptr;
      co_freevars    : PyObject_Head_Ptr;
      co_cellvars    : PyObject_Head_Ptr;
      co_filename    : PyObject_Head_Ptr;
      co_name        : PyObject_Head_Ptr;
      co_firstlineno : Integer;
      co_lnotab      : PyObject_Head_Ptr;
      co_zombieframe : Address;
      co_weakreflist : PyObject_Head_Ptr;
   end record;
   type PyCodeObject_Ptr is access all PyCodeObject_Type;

   -- Include/frameobject.h

   type PyFrameObject_Type is
   record
      ob_base    : PyObject_VarHead_Type;
      f_back     : Address;
      f_code     : PyCodeObject_Ptr;      -- code segment
      f_builtins : PyObject_Head_Ptr;
      f_globals  : PyObject_Head_Ptr;
      f_locals   : PyObject_Head_Ptr;
   end record;

   -- Stack
   type Stack_Type is array (Natural range <>) of PyObject_Head_Ptr with
      Pack                    => True,
      Suppress_Initialization => True; -- pragma Restrictions (No_Implicit_Loops)
   Stack : Stack_Type (0 .. 1023);

   function Create_Object return PyObject_Head_Ptr;
   function Read_U32 (Object_Address : Address) return Unsigned_32 with
      Inline => True;
   function Read_Int32 (Object_Address : Address) return Integer with
      Inline => True;
   procedure Parse_CODE (PYC_Object : in Storage_Array);
   procedure Parse_STRING (PYC_Object : in Storage_Array);
   procedure Parse_Object (PYC_Object : in Storage_Array);
   procedure Parse (PYC_Object : in Storage_Array; Success : out Boolean);
   procedure Push (pObject : in PyObject_Head_Ptr);

   --========================================================================--
   --                                                                        --
   --                                                                        --
   --                           Package subprograms                          --
   --                                                                        --
   --                                                                        --
   --========================================================================--

   function Create_Object return PyObject_Head_Ptr is
      Result : PyObject_Head_Ptr;
   begin
      Result               := new PyObject_Head_Type;
      Result.all.ob_refcnt := 0;
      Result.all.ob_type   := Null_Address;
      return Result;
   end Create_Object;

   -- function Create_Object_String return PyObject_Head_Ptr is
   --    pObject : PyObject_Head_Ptr;
   -- begin
   --    pObject := Create_Object;
   -- end Create_Object_String;

   ----------------------------------------------------------------------------
   -- Read_U32
   ----------------------------------------------------------------------------
   function Read_U32 (Object_Address : Address) return Unsigned_32 is
      Value_Array : aliased Byte_Array (0 .. 3) with
         Address    => Object_Address,
         Import     => True,
         Convention => Ada;
   begin
      -- LE-read byte-by-byte
      return Unsigned_32 (Value_Array (0))         +
             Unsigned_32 (Value_Array (1)) * 2**8  +
             Unsigned_32 (Value_Array (2)) * 2**16 +
             Unsigned_32 (Value_Array (3)) * 2**24;
   end Read_U32;

   ----------------------------------------------------------------------------
   -- Read_Int32
   ----------------------------------------------------------------------------
   function Read_Int32 (Object_Address : Address) return Integer is
      function To_Int32 is new Ada.Unchecked_Conversion (Unsigned_32, Integer_32);
   begin
      return Integer (To_Int32 (Read_U32 (Object_Address)));
   end Read_Int32;

   ----------------------------------------------------------------------------
   -- Parse_CODE
   ----------------------------------------------------------------------------
   procedure Parse_CODE (PYC_Object : in Storage_Array) is
      Offset        : Storage_Offset;
      PYC_argcount  : Integer;
      PYC_nlocals   : Integer;
      PYC_stacksize : Integer;
      PYC_flags     : Integer;
   begin
      Offset := PYC_Object'First;
      PYC_argcount := Read_Int32 (PYC_Object (Offset)'Address);
      Console.Print (PYC_argcount,  Prefix => "PYC argcount:  ", NL => True);
      Offset := Offset + 4;
      PYC_nlocals := Read_Int32 (PYC_Object (Offset)'Address);
      Console.Print (PYC_nlocals,   Prefix => "PYC nlocals:   ", NL => True);
      Offset := Offset + 4;
      PYC_stacksize := Read_Int32 (PYC_Object (Offset)'Address);
      Console.Print (PYC_stacksize, Prefix => "PYC stacksize: ", NL => True);
      Offset := Offset + 4;
      PYC_flags := Read_Int32 (PYC_Object (Offset)'Address);
      Console.Print (PYC_flags,     Prefix => "PYC flags:     ", NL => True);
      Offset := Offset + 4;
      Parse_Object (PYC_Object (Offset .. PYC_Object'Last));
   end Parse_CODE;

   ----------------------------------------------------------------------------
   -- Parse_STRING
   ----------------------------------------------------------------------------
   procedure Parse_STRING (PYC_Object : in Storage_Array) is
      Stringlength : Integer with Unreferenced => True;
   begin
      Stringlength := Read_Int32 (PYC_Object (PYC_Object'First)'Address);
   end Parse_STRING;

   ----------------------------------------------------------------------------
   -- Parse_Object
   ----------------------------------------------------------------------------
   procedure Parse_Object (PYC_Object : in Storage_Array) is
   begin
      case PYC_Object (PYC_Object'First) is
         when PYC_TYPE_NULL   => return;
         when PYC_TYPE_CODE   => Parse_CODE (PYC_Object (PYC_Object'First + 1 .. PYC_Object'Last));
         when PYC_TYPE_STRING => Parse_STRING (PYC_Object (PYC_Object'First + 1 .. PYC_Object'Last));
         when others          => null;
      end case;
   end Parse_Object;

   ----------------------------------------------------------------------------
   -- Parse
   ----------------------------------------------------------------------------
   procedure Parse (PYC_Object : in Storage_Array; Success : out Boolean) is
      Offset : Storage_Offset;
   begin
      Success := False;
      -- check "magic"
      declare
         Value : Unsigned_32;
      begin
         Offset := PYC_Object'First;
         Value := Read_U32 (PYC_Object (Offset)'Address);
         Console.Print (Value, Prefix => "Python MAGIC: ");
         if Value /= PYTHON_MAGIC then
            Console.Print (" KO", NL => True);
            return;
         else
            Console.Print (" OK", NL => True);
         end if;
      end;
      -- discard compilation date
      Offset := Offset + 4;
      -- marshal data
      Offset := Offset + 4;
      Parse_Object (PYC_Object (Offset .. PYC_Object'Last));
      Success := True;
   end Parse;

   ----------------------------------------------------------------------------
   -- Read_Marshal
   ----------------------------------------------------------------------------
   procedure Read_Marshal (Marshal_Code : Byte_Array) is
      Index : Natural;
   begin
      Index := Marshal_Code'First;
      Console.Print (Index, Prefix => "First index: ", NL => True);
      while True loop
         case Marshal_Code (Index) is
            when PYC_TYPE_TUPLE     => null; -- "("
            when PYC_TYPE_NULL      => null; -- "0"
            when PYC_TYPE_NONE      => null; -- "N"
            when PYC_TYPE_STRINGREF => null; -- "R"
            when PYC_TYPE_CODE      => null; -- "c"
            when PYC_TYPE_INT       => null; -- "i"
            when PYC_TYPE_LONG      => null; -- "l"
            when PYC_TYPE_STRING    => null; -- "s"
            when PYC_TYPE_INTERNED  => null; -- "t"
            when others             => null;
         end case;
         exit;
      end loop;
   end Read_Marshal;

   ----------------------------------------------------------------------------
   -- Push
   ----------------------------------------------------------------------------
   -- Push a Python object pointer onto the stack.
   ----------------------------------------------------------------------------
   procedure Push (pObject : in PyObject_Head_Ptr) is
   begin
      -- #define BASIC_PUSH(v)     (*stack_pointer++ = (v))
      null;
   end Push;

   ----------------------------------------------------------------------------
   -- Run
   ----------------------------------------------------------------------------
   -- __REF__ Python/ceval.c
   ----------------------------------------------------------------------------
   procedure Run is
      Success         : Boolean;
      IP              : Storage_Offset;
      Opcode          : Storage_Element;
      Opcode_Argument : Integer with Unreferenced => True;
      ----------------------
      procedure Next_Opcode;
      procedure Next_Opcode is
      begin
         Opcode := Python_Code (IP);
         IP := IP + 1;
      end Next_Opcode;
      ----------------
      -- __REF__ HAS_ARG()
      function Opcode_Has_Arguments (Opcode_Item : Storage_Element) return Boolean;
      function Opcode_Has_Arguments (Opcode_Item : Storage_Element) return Boolean is
      begin
         return Opcode_Item >= HAVE_ARGUMENT;
      end Opcode_Has_Arguments;
      --------------------------------------
      function Next_Argument return Integer;
      function Next_Argument return Integer is
         Result : Integer;
      begin
         -- LE Integer
         Result := Integer (LE_To_CPUE (Unsigned_16 (Python_Code (IP))));
         IP := IP + 2;
         return Result;
      end Next_Argument;
      ------------------
   begin
      Parse (Python_Code, Success);
      if not Success then
         return;
      end if;
      IP := 16#1E#; -- offset 0-based into file
      loop
         Next_Opcode;
         if Opcode_Has_Arguments (Opcode) then
            -- Console.Print ("* has argument", NL => True);
            Opcode_Argument := Next_Argument;
         end if;
         case Opcode is
            -----------------
            when POP_TOP =>
               Console.Print ("POP_TOP", NL => True);
            -----------------
            when ROT_TWO =>
               Console.Print ("ROT_TWO", NL => True);
            -----------------
            when ROT_THREE =>
               Console.Print ("ROT_THREE", NL => True);
            -----------------
            when DUP_TOP =>
               Console.Print ("DUP_TOP", NL => True);
            -----------------
            when DUP_TOP_TWO =>
               Console.Print ("DUP_TOP_TWO", NL => True);
            -----------------
            when NOP =>
               Console.Print ("NOP", NL => True);
            -----------------
            when LOAD_FAST =>
               Console.Print ("LOAD_FAST", NL => True);
            -----------------
            when LOAD_NAME =>
               Console.Print ("LOAD_NAME", NL => True);
            -------------------
            -- STORE_NAME namei
            -- implements name = TOS
            when STORE_NAME =>
               Console.Print ("STORE_NAME", NL => True);
            --------------------
            -- LOAD_CONST consti
            -- pushes "co_consts[consti] onto the stack
            when LOAD_CONST =>
               Console.Print ("LOAD_CONST", NL => True);
               declare
                  package To_PTOA is new System.Address_To_Access_Conversions (Object => PyTupleObject_Type);
                  use To_PTOA;
                  -- Tuple : Object_Pointer;
               begin
                  null;
                  -- Tuple := To_Pointer (Null_Address + Storage_Offset (3));
                  -- Tuple.all (Opcode_Argument) := null;
               end;
            -- #define PyTuple_GET_ITEM(op, i) (((PyTupleObject *)(op))->ob_item[i])
            -- #define GETITEM(v, i) PyTuple_GET_ITEM((PyTupleObject *)(v), (i))
            -- PyObject *value = GETITEM(consts, oparg);
            ---------------------
            -- MAKE_FUNCTION argc
            -- pushes a new function object onto the stack
            when MAKE_FUNCTION =>
               Console.Print ("MAKE_FUNCTION", NL => True);
            ---------------
            -- RETURN_VALUE
            -- returns with TOS to the caller of the function
            when RETURN_VALUE =>
               Console.Print ("RETURN_VALUE", NL => True);
            -----------------
            when UNPACK_SEQUENCE =>
               Console.Print ("UNPACK_SEQUENCE", NL => True);
            -----------------
            -- UNKNOWN OPCODE
            when others =>
               Console.Print ("*** UNKNOWN OPCODE", NL => True);
            -----------------
         end case;
         exit when IP > 16#2A#;
      end loop;
   end Run;

end PythonVM;

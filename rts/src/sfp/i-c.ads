------------------------------------------------------------------------------
--                                                                          --
--                         GNAT COMPILER COMPONENTS                         --
--                                                                          --
--                         I N T E R F A C E S . C                          --
--                                                                          --
--                                 S p e c                                  --
--                                                                          --
-- This specification is derived from the Ada Reference Manual for use with --
-- GNAT.  In accordance with the copyright of that document, you can freely --
-- copy and modify this specification,  provided that if you redistribute a --
-- modified version,  any changes that you have made are clearly indicated. --
--                                                                          --
------------------------------------------------------------------------------
-- SweetAda SFP cutted-down version                                         --
------------------------------------------------------------------------------

--  Preconditions in this unit are meant for analysis only, not for run-time
--  checking, so that the expected exceptions are raised. This is enforced by
--  setting the corresponding assertion policy to Ignore. Postconditions and
--  contract cases should not be executed at runtime as well, in order not to
--  slow down the execution of these functions.

pragma Assertion_Policy (Pre            => Ignore,
                         Post           => Ignore,
                         Contract_Cases => Ignore,
                         Ghost          => Ignore);

with System.Parameters;

package Interfaces.C
  with SPARK_Mode, Pure
is
   --  Each of the types declared in Interfaces.C is C-compatible.

   --  The types int, short, long, unsigned, ptrdiff_t, size_t, double,
   --  char, wchar_t, char16_t, and char32_t correspond respectively to the
   --  C types having the same names. The types signed_char, unsigned_short,
   --  unsigned_long, unsigned_char, C_bool, C_float, and long_double
   --  correspond respectively to the C types signed char, unsigned
   --  short, unsigned long, unsigned char, bool, float, and long double.

   --  Declaration's based on C's <limits.h>

   CHAR_BIT  : constant := 8;
   SCHAR_MIN : constant := -128;
   SCHAR_MAX : constant := 127;
   UCHAR_MAX : constant := 255;

   --  Signed and Unsigned Integers. Note that in GNAT, we have ensured that
   --  the standard predefined Ada types correspond to the standard C types

   --  Note: the Integer qualifications used in the declaration of type long
   --  avoid ambiguities when compiling in the presence of s-auxdec.ads and
   --  a non-private system.address type.

   type int   is new Integer;
   type short is new Short_Integer;
   type long  is range -(2 ** (System.Parameters.long_bits - Integer'(1)))
     .. +(2 ** (System.Parameters.long_bits - Integer'(1))) - 1;
   type long_long is new Long_Long_Integer;

   type signed_char is range SCHAR_MIN .. SCHAR_MAX;
   for signed_char'Size use CHAR_BIT;

   type unsigned           is mod 2 ** int'Size;
   type unsigned_short     is mod 2 ** short'Size;
   type unsigned_long      is mod 2 ** long'Size;
   type unsigned_long_long is mod 2 ** long_long'Size;

   type unsigned_char is mod (UCHAR_MAX + 1);
   for unsigned_char'Size use CHAR_BIT;

   --  Note: Ada RM states that the type of the subtype plain_char is either
   --  signed_char or unsigned_char, depending on the C implementation. GNAT
   --  instead choses unsigned_char always.

   subtype plain_char is unsigned_char;

   --  Note: the Integer qualifications used in the declaration of ptrdiff_t
   --  avoid ambiguities when compiling in the presence of s-auxdec.ads and
   --  a non-private system.address type.

   type ptrdiff_t is
     range -(2 ** (System.Parameters.ptr_bits - Integer'(1))) ..
           +(2 ** (System.Parameters.ptr_bits - Integer'(1)) - 1);

   type size_t is mod 2 ** System.Parameters.ptr_bits;

   --  Boolean type

   type C_bool is new Boolean;
   pragma Convention (C, C_bool);

   --  Floating-Point

   type C_float     is new Float;
   type double      is new Standard.Long_Float;
   type long_double is new Standard.Long_Long_Float;

   ----------------------------
   -- Characters and Strings --
   ----------------------------

   type char is new Character;

   nul : constant char := char'First;

   --  The functions To_C and To_Ada map between the Ada type Character and the
   --  C type char.

   function To_C (Item : Character) return char
   with
     Post => To_C'Result = char'Val (Character'Pos (Item));

   function To_Ada (Item : char) return Character
   with
     Post => To_Ada'Result = Character'Val (char'Pos (Item));

   type char_array is array (size_t range <>) of aliased char;
   for char_array'Component_Size use CHAR_BIT;

   function Is_Nul_Terminated (Item : char_array) return Boolean
   with
     Post => Is_Nul_Terminated'Result = (for some C of Item => C = nul);
   --  The result of Is_Nul_Terminated is True if Item contains nul, and is
   --  False otherwise.

   function C_Length_Ghost (Item : char_array) return size_t
   with
     Ghost,
     Pre  => Is_Nul_Terminated (Item),
     Post => C_Length_Ghost'Result <= Item'Last - Item'First
       and then Item (Item'First + C_Length_Ghost'Result) = nul
       and then (for all J in Item'First .. Item'First + C_Length_Ghost'Result
                   when J /= Item'First + C_Length_Ghost'Result =>
                     Item (J) /= nul);
   --  Ghost function to compute the length of a char_array up to the first nul
   --  character.

   -- __INF__ requires secondary stack
   function To_C
     (Item       : String;
      Append_Nul : Boolean := True) return char_array;

   -- __INF__ requires secondary stack
   function To_Ada
     (Item     : char_array;
      Trim_Nul : Boolean := True) return String;

   procedure To_C
     (Item       : String;
      Target     : out char_array;
      Count      : out size_t;
      Append_Nul : Boolean := True);

   procedure To_Ada
     (Item     : char_array;
      Target   : out String;
      Count    : out Natural;
      Trim_Nul : Boolean := True);

   ------------------------------------
   -- Wide Character and Wide String --
   ------------------------------------

   type wchar_t is new Wide_Character;
   for wchar_t'Size use Standard'Wchar_T_Size;

   wide_nul : constant wchar_t := wchar_t'First;

   function To_C   (Item : Wide_Character) return wchar_t;
   function To_Ada (Item : wchar_t)        return Wide_Character;

   type wchar_array is array (size_t range <>) of aliased wchar_t;

   function Is_Nul_Terminated (Item : wchar_array) return Boolean;

   -- __INF__ requires secondary stack
   function To_C
     (Item       : Wide_String;
      Append_Nul : Boolean := True) return wchar_array;

   -- __INF__ requires secondary stack
   function To_Ada
     (Item     : wchar_array;
      Trim_Nul : Boolean := True) return Wide_String;

   procedure To_C
     (Item       : Wide_String;
      Target     : out wchar_array;
      Count      : out size_t;
      Append_Nul : Boolean := True);

   procedure To_Ada
     (Item     : wchar_array;
      Target   : out Wide_String;
      Count    : out Natural;
      Trim_Nul : Boolean := True);

   Terminator_Error : exception;

   --  The remaining declarations are for Ada 2005 (AI-285)

   --  ISO/IEC 10646:2003 compatible types defined by SC22/WG14 document N1010

   type char16_t is new Wide_Character;
   pragma Ada_05 (char16_t);

   char16_nul : constant char16_t := char16_t'Val (0);
   pragma Ada_05 (char16_nul);

   function To_C (Item : Wide_Character) return char16_t;
   pragma Ada_05 (To_C);

   function To_Ada (Item : char16_t) return Wide_Character;
   pragma Ada_05 (To_Ada);

   type char16_array is array (size_t range <>) of aliased char16_t;
   pragma Ada_05 (char16_array);

   function Is_Nul_Terminated (Item : char16_array) return Boolean;
   pragma Ada_05 (Is_Nul_Terminated);
   --  The result of Is_Nul_Terminated is True if Item contains char16_nul, and
   --  is False otherwise.

   -- __INF__ requires secondary stack
   function To_C
     (Item       : Wide_String;
      Append_Nul : Boolean := True) return char16_array;
   pragma Ada_05 (To_C);

   -- __INF__ requires secondary stack
   function To_Ada
     (Item     : char16_array;
      Trim_Nul : Boolean := True) return Wide_String;
   pragma Ada_05 (To_Ada);

   procedure To_C
     (Item       : Wide_String;
      Target     : out char16_array;
      Count      : out size_t;
      Append_Nul : Boolean := True);
   pragma Ada_05 (To_C);

   procedure To_Ada
     (Item     : char16_array;
      Target   : out Wide_String;
      Count    : out Natural;
      Trim_Nul : Boolean := True);
   pragma Ada_05 (To_Ada);

   type char32_t is new Wide_Wide_Character;
   pragma Ada_05 (char32_t);

   char32_nul : constant char32_t := char32_t'Val (0);
   pragma Ada_05 (char32_nul);

   function To_C (Item : Wide_Wide_Character) return char32_t;
   pragma Ada_05 (To_C);

   function To_Ada (Item : char32_t) return Wide_Wide_Character;
   pragma Ada_05 (To_Ada);

   type char32_array is array (size_t range <>) of aliased char32_t;
   pragma Ada_05 (char32_array);

   function Is_Nul_Terminated (Item : char32_array) return Boolean;
   pragma Ada_05 (Is_Nul_Terminated);
   --  The result of Is_Nul_Terminated is True if Item contains char32_nul, and
   --  is False otherwise.

   -- __INF__ requires secondary stack
   function To_C
     (Item       : Wide_Wide_String;
      Append_Nul : Boolean := True) return char32_array;
   pragma Ada_05 (To_C);

   -- __INF__ requires secondary stack
   function To_Ada
     (Item     : char32_array;
      Trim_Nul : Boolean := True) return Wide_Wide_String;
   pragma Ada_05 (To_Ada);

   procedure To_C
     (Item       : Wide_Wide_String;
      Target     : out char32_array;
      Count      : out size_t;
      Append_Nul : Boolean := True);
   pragma Ada_05 (To_C);

   procedure To_Ada
     (Item     : char32_array;
      Target   : out Wide_Wide_String;
      Count    : out Natural;
      Trim_Nul : Boolean := True);
   pragma Ada_05 (To_Ada);

end Interfaces.C;

-----------------------------------------------------------------------------------------------------------------------
--                                                     SweetAda                                                      --
-----------------------------------------------------------------------------------------------------------------------
-- __HDS__                                                                                                           --
-- __FLN__ pythonvm-defs.ads                                                                                         --
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

package PythonVM.Defs is

   --========================================================================--
   --                                                                        --
   --                                                                        --
   --                               Public part                              --
   --                                                                        --
   --                                                                        --
   --========================================================================--

   -- Python/marshal.c

   PYC_TYPE_TUPLE     : constant := 16#28#; -- "("
   PYC_TYPE_NULL      : constant := 16#30#; -- "0"
   PYC_TYPE_NONE      : constant := 16#4E#; -- "N"
   PYC_TYPE_STRINGREF : constant := 16#52#; -- "R"
   PYC_TYPE_CODE      : constant := 16#63#; -- "c"
   PYC_TYPE_INT       : constant := 16#69#; -- "i"
   PYC_TYPE_LONG      : constant := 16#6C#; -- "l"
   PYC_TYPE_STRING    : constant := 16#73#; -- "s"
   PYC_TYPE_INTERNED  : constant := 16#74#; -- "t"

   -- Include/opcode.h

   -----------------------------------------------------
   POP_TOP                    : constant :=   1; -- 0x01
   ROT_TWO                    : constant :=   2; -- 0x02
   ROT_THREE                  : constant :=   3; -- 0x03
   DUP_TOP                    : constant :=   4; -- 0x04
   DUP_TOP_TWO                : constant :=   5; -- 0x05
   --                                            -- 0x06
   --                                            -- 0x07
   --                                            -- 0x08
   NOP                        : constant :=   9; -- 0x09
   UNARY_POSITIVE             : constant :=  10; -- 0x0A
   UNARY_NEGATIVE             : constant :=  11; -- 0x0B
   UNARY_NOT                  : constant :=  12; -- 0x0C
   --                                            -- 0x0D
   --                                            -- 0x0E
   UNARY_INVERT               : constant :=  15; -- 0x0F
   BINARY_MATRIX_MULTIPLY     : constant :=  16; -- 0x10
   INPLACE_MATRIX_MULTIPLY    : constant :=  17; -- 0x11
   --                                            -- 0x12
   BINARY_POWER               : constant :=  19; -- 0x13
   BINARY_MULTIPLY            : constant :=  20; -- 0x14
   --                                            -- 0x15
   BINARY_MODULO              : constant :=  22; -- 0x16
   BINARY_ADD                 : constant :=  23; -- 0x17
   BINARY_SUBTRACT            : constant :=  24; -- 0x18
   BINARY_SUBSCR              : constant :=  25; -- 0x19
   BINARY_FLOOR_DIVIDE        : constant :=  26; -- 0x1A
   BINARY_TRUE_DIVIDE         : constant :=  27; -- 0x1B
   INPLACE_FLOOR_DIVIDE       : constant :=  28; -- 0x1C
   INPLACE_TRUE_DIVIDE        : constant :=  29; -- 0x1D
   --                                            -- 0x1E
   --                                            -- 0x1F
   --                                            -- 0x20
   --                                            -- 0x21
   --                                            -- 0x22
   --                                            -- 0x23
   --                                            -- 0x24
   --                                            -- 0x25
   --                                            -- 0x26
   --                                            -- 0x27
   --                                            -- 0x28
   --                                            -- 0x29
   --                                            -- 0x2A
   --                                            -- 0x2B
   --                                            -- 0x2C
   --                                            -- 0x2D
   --                                            -- 0x2E
   --                                            -- 0x2F
   --                                            -- 0x30
   --                                            -- 0x31
   GET_AITER                  : constant :=  50; -- 0x32
   GET_ANEXT                  : constant :=  51; -- 0x33
   BEFORE_ASYNC_WITH          : constant :=  52; -- 0x34
   --                                            -- 0x35
   --                                            -- 0x36
   INPLACE_ADD                : constant :=  55; -- 0x37
   INPLACE_SUBTRACT           : constant :=  56; -- 0x38
   INPLACE_MULTIPLY           : constant :=  57; -- 0x39
   --                                            -- 0x3A
   INPLACE_MODULO             : constant :=  59; -- 0x3B
   STORE_SUBSCR               : constant :=  60; -- 0x3C
   DELETE_SUBSCR              : constant :=  61; -- 0x3D
   BINARY_LSHIFT              : constant :=  62; -- 0x3E
   BINARY_RSHIFT              : constant :=  63; -- 0x3F
   BINARY_AND                 : constant :=  64; -- 0x40
   BINARY_XOR                 : constant :=  65; -- 0x41
   BINARY_OR                  : constant :=  66; -- 0x42
   INPLACE_POWER              : constant :=  67; -- 0x43
   GET_ITER                   : constant :=  68; -- 0x44
   GET_YIELD_FROM_ITER        : constant :=  69; -- 0x45
   PRINT_EXPR                 : constant :=  70; -- 0x46
   LOAD_BUILD_CLASS           : constant :=  71; -- 0x47
   YIELD_FROM                 : constant :=  72; -- 0x48
   GET_AWAITABLE              : constant :=  73; -- 0x49
   --                                            -- 0x4A
   INPLACE_LSHIFT             : constant :=  75; -- 0x4B
   INPLACE_RSHIFT             : constant :=  76; -- 0x4C
   INPLACE_AND                : constant :=  77; -- 0x4D
   INPLACE_XOR                : constant :=  78; -- 0x4E
   INPLACE_OR                 : constant :=  79; -- 0x4F
   BREAK_LOOP                 : constant :=  80; -- 0x50
   WITH_CLEANUP_START         : constant :=  81; -- 0x51
   WITH_CLEANUP_FINISH        : constant :=  82; -- 0x52
   RETURN_VALUE               : constant :=  83; -- 0x53
   IMPORT_STAR                : constant :=  84; -- 0x54
   YIELD_VALUE                : constant :=  86; -- 0x55
   POP_BLOCK                  : constant :=  87; -- 0x56
   END_FINALLY                : constant :=  88; -- 0x57
   POP_EXCEPT                 : constant :=  89; -- 0x58
   -----------------------------------------------------
   HAVE_ARGUMENT              : constant :=  90; -- 0x59
   STORE_NAME                 : constant :=  90; -- 0x5A
   DELETE_NAME                : constant :=  91; -- 0x5B
   UNPACK_SEQUENCE            : constant :=  92; -- 0x5C
   FOR_ITER                   : constant :=  93; -- 0x5D
   UNPACK_EX                  : constant :=  94; -- 0x5E
   STORE_ATTR                 : constant :=  95; -- 0x5F
   DELETE_ATTR                : constant :=  96; -- 0x60
   STORE_GLOBAL               : constant :=  97; -- 0x61
   DELETE_GLOBAL              : constant :=  98; -- 0x62
   --                                            -- 0x63
   LOAD_CONST                 : constant := 100; -- 0x64
   LOAD_NAME                  : constant := 101; -- 0x65
   BUILD_TUPLE                : constant := 102; -- 0x66
   BUILD_LIST                 : constant := 103; -- 0x67
   BUILD_SET                  : constant := 104; -- 0x68
   BUILD_MAP                  : constant := 105; -- 0x69
   LOAD_ATTR                  : constant := 106; -- 0x6A
   COMPARE_OP                 : constant := 107; -- 0x6B
   IMPORT_NAME                : constant := 108; -- 0x6C
   IMPORT_FROM                : constant := 109; -- 0x6D
   JUMP_FORWARD               : constant := 110; -- 0x6E
   JUMP_IF_FALSE_OR_POP       : constant := 111; -- 0x6F
   JUMP_IF_TRUE_OR_POP        : constant := 112; -- 0x70
   JUMP_ABSOLUTE              : constant := 113; -- 0x71
   POP_JUMP_IF_FALSE          : constant := 114; -- 0x72
   POP_JUMP_IF_TRUE           : constant := 115; -- 0x73
   LOAD_GLOBAL                : constant := 116; -- 0x74
   --                                            -- 0x75
   --                                            -- 0x76
   CONTINUE_LOOP              : constant := 119; -- 0x77
   SETUP_LOOP                 : constant := 120; -- 0x78
   SETUP_EXCEPT               : constant := 121; -- 0x79
   SETUP_FINALLY              : constant := 122; -- 0x7A
   --                                               0x7B
   LOAD_FAST                  : constant := 124; -- 0x7C
   STORE_FAST                 : constant := 125; -- 0x7D
   DELETE_FAST                : constant := 126; -- 0x7E
   --                                            -- 0x7F
   --                                            -- 0x80
   --                                            -- 0x81
   RAISE_VARARGS              : constant := 130; -- 0x82
   CALL_FUNCTION              : constant := 131; -- 0x83
   MAKE_FUNCTION              : constant := 132; -- 0x84
   BUILD_SLICE                : constant := 133; -- 0x85
   MAKE_CLOSURE               : constant := 134; -- 0x86
   LOAD_CLOSURE               : constant := 135; -- 0x87
   LOAD_DEREF                 : constant := 136; -- 0x88
   STORE_DEREF                : constant := 137; -- 0x89
   DELETE_DEREF               : constant := 138; -- 0x8A
   --                                            -- 0x8B
   CALL_FUNCTION_VAR          : constant := 140; -- 0x8C
   CALL_FUNCTION_KW           : constant := 141; -- 0x8D
   CALL_FUNCTION_VAR_KW       : constant := 142; -- 0x8E
   SETUP_WITH                 : constant := 143; -- 0x8F
   EXTENDED_ARG               : constant := 144; -- 0x90
   LIST_APPEND                : constant := 145; -- 0x91
   SET_ADD                    : constant := 146; -- 0x92
   MAP_ADD                    : constant := 147; -- 0x93
   LOAD_CLASSDEREF            : constant := 148; -- 0x94
   BUILD_LIST_UNPACK          : constant := 149; -- 0x95
   BUILD_MAP_UNPACK           : constant := 150; -- 0x96
   BUILD_MAP_UNPACK_WITH_CALL : constant := 151; -- 0x97
   BUILD_TUPLE_UNPACK         : constant := 152; -- 0x98
   BUILD_SET_UNPACK           : constant := 153; -- 0x99
   SETUP_ASYNC_WITH           : constant := 154; -- 0x9A
   -----------------------------------------------------

   PYTHON_MAGIC : constant := 16#0A0DF303#; -- LE

end PythonVM.Defs;

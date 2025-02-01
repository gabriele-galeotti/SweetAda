-----------------------------------------------------------------------------------------------------------------------
--                                                     SweetAda                                                      --
-----------------------------------------------------------------------------------------------------------------------
-- __HDS__                                                                                                           --
-- __FLN__ m68k.ads                                                                                                  --
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
with Interfaces;
with Bits;

package M68k
   with Preelaborate => True
   is

   --========================================================================--
   --                                                                        --
   --                                                                        --
   --                               Public part                              --
   --                                                                        --
   --                                                                        --
   --========================================================================--

   use System;
   use Interfaces;
   use Bits;

pragma Style_Checks (Off);

   ----------------------------------------------------------------------------
   -- Generic definitions
   ----------------------------------------------------------------------------

   Opcode_BREAKPOINT      : constant := 16#4E4F#; -- TRAP #15
   Opcode_BREAKPOINT_Size : constant := 2;

   BREAKPOINT_Asm_String : constant String := ".word   0x4E4F";

   ----------------------------------------------------------------------------
   -- Basic types
   ----------------------------------------------------------------------------

   -- 1.3.2 Status Register

   type ILEVEL_Type is new Bits_3;
   ILEVEL0 : constant ILEVEL_Type := 2#000#;
   ILEVEL1 : constant ILEVEL_Type := 2#001#;
   ILEVEL2 : constant ILEVEL_Type := 2#010#;
   ILEVEL3 : constant ILEVEL_Type := 2#011#;
   ILEVEL4 : constant ILEVEL_Type := 2#100#;
   ILEVEL5 : constant ILEVEL_Type := 2#101#;
   ILEVEL6 : constant ILEVEL_Type := 2#110#;
   ILEVEL7 : constant ILEVEL_Type := 2#111#;

   type SR_Type is record
      -- CCR
      C         : Boolean;          -- CARRY
      V         : Boolean;          -- OVERFLOW
      Z         : Boolean;          -- ZERO
      N         : Boolean;          -- NEGATIVE
      X         : Boolean;          -- EXTEND
      Reserved1 : Bits_3      := 0;
      -- supervisor
      ILEVEL    : ILEVEL_Type;      -- INTERRUPT PRIORITY MASK
      Reserved2 : Bits_1      := 0;
      M         : Boolean;          -- MASTER/INTERRUPT STATE
      S         : Boolean;          -- SUPERVISOR/USER STATE
      T0        : Boolean;          -- TRACE ENABLE 0
      T1        : Boolean;          -- TRACE ENABLE 1
   end record
      with Bit_Order => Low_Order_First,
           Size      => 16;
   for SR_Type use record
      C         at 0 range  0 ..  0;
      V         at 0 range  1 ..  1;
      Z         at 0 range  2 ..  2;
      N         at 0 range  3 ..  3;
      X         at 0 range  4 ..  4;
      Reserved1 at 0 range  5 ..  7;
      ILEVEL    at 0 range  8 .. 10;
      Reserved2 at 0 range 11 .. 11;
      M         at 0 range 12 .. 12;
      S         at 0 range 13 .. 13;
      T0        at 0 range 14 .. 14;
      T1        at 0 range 15 .. 15;
   end record;

   -- 1.2.2 Floating-Point Control Register (FPCR)

   RND_RN : constant := 2#00#; -- To Nearest
   RND_RZ : constant := 2#01#; -- Toward Zero
   RND_RM : constant := 2#10#; -- Toward Minus Infinity
   RND_RP : constant := 2#11#; -- Toward Plus Infinity

   PREC_0 : constant := 2#00#;
   PREC_1 : constant := 2#01#;
   PREC_2 : constant := 2#10#;
   PREC_3 : constant := 2#11#;

   type FPCR_Type is record
      -- MODE CONTROL
      Reserved1 : Bits_4;
      RND       : Bits_2;  -- ROUNDING MODE
      PREC      : Bits_2;  -- ROUNDING PRECISION
      -- EXCEPTION ENABLE
      INEX1     : Boolean; -- INEXACT DECIMAL INPUT
      INEX2     : Boolean; -- INEXACT OPERATION
      DZ        : Boolean; -- DIVIDE BY ZERO
      UNFL      : Boolean; -- UNDERFLOW
      OVFL      : Boolean; -- OVERFLOW
      OPERR     : Boolean; -- OPERAND ERROR
      SNAN      : Boolean; -- SIGNALING NOT-A-NUMBER
      BSUN      : Boolean; -- BRANCH/SET ON UNORDERED
      Reserved2 : Bits_16;
   end record
      with Bit_Order => Low_Order_First,
           Size      => 32;
   for FPCR_Type use record
      Reserved1 at 0 range  0 ..  3;
      RND       at 0 range  4 ..  5;
      PREC      at 0 range  6 ..  7;
      INEX1     at 0 range  8 ..  8;
      INEX2     at 0 range  9 ..  9;
      DZ        at 0 range 10 .. 10;
      UNFL      at 0 range 11 .. 11;
      OVFL      at 0 range 12 .. 12;
      OPERR     at 0 range 13 .. 13;
      SNAN      at 0 range 14 .. 14;
      BSUN      at 0 range 15 .. 15;
      Reserved2 at 0 range 16 .. 31;
   end record;

   ----------------------------------------------------------------------------
   -- M680X0 registers
   ----------------------------------------------------------------------------

   D0        : constant := 16#00#; -- 0
   D1        : constant := 16#01#; -- 1
   D2        : constant := 16#02#; -- 2
   D3        : constant := 16#03#; -- 3
   D4        : constant := 16#04#; -- 4
   D5        : constant := 16#05#; -- 5
   D6        : constant := 16#06#; -- 6
   D7        : constant := 16#07#; -- 7
   A0        : constant := 16#08#; -- 8
   A1        : constant := 16#09#; -- 9
   A2        : constant := 16#0A#; -- 10
   A3        : constant := 16#0B#; -- 11
   A4        : constant := 16#0C#; -- 12
   A5        : constant := 16#0D#; -- 13
   A6        : constant := 16#0E#; -- 14
   A7        : constant := 16#0F#; -- 15
   SR        : constant := 16#10#; -- 16
   PC        : constant := 16#11#; -- 17
   FP0       : constant := 16#12#; -- 18
   FP1       : constant := 16#13#; -- 19
   FP2       : constant := 16#14#; -- 20
   FP3       : constant := 16#15#; -- 21
   FP4       : constant := 16#16#; -- 22
   FP5       : constant := 16#17#; -- 23
   FP6       : constant := 16#18#; -- 24
   FP7       : constant := 16#19#; -- 25
   FPCONTROL : constant := 16#1A#; -- 26
   FPSTATUS  : constant := 16#1B#; -- 27
   FPIADDR   : constant := 16#1C#; -- 28
   -- aliases
   FP        : constant := A6;
   SP        : constant := A7;
   PS        : constant := SR;

   subtype Register_Number_Type is Natural range D0 .. FPIADDR;

   ----------------------------------------------------------------------------
   -- CPU helper subprograms
   ----------------------------------------------------------------------------

   function SR_Read
      return SR_Type
      with Inline => True;

   procedure SR_Write
      (Value : in SR_Type)
      with Inline => True;

   procedure VBR_Set
      (VBR_Address : in Address)
      with Inline => True;

   function MoveSByte
      (A : in Address)
      return Unsigned_8
      with Inline => True;
   procedure MoveSByte
      (A : in Address;
       B : in Unsigned_8)
      with Inline => True;

   function MoveSWord
      (A : in Address)
      return Unsigned_16
      with Inline => True;
   procedure MoveSWord
      (A : in Address;
       W : in Unsigned_16)
      with Inline => True;

   function MoveSLong
      (A : in Address)
      return Unsigned_32
      with Inline => True;
   procedure MoveSLong
      (A : in Address;
       L : in Unsigned_32)
      with Inline => True;

   procedure NOP
      with Inline => True;

   procedure RESET
      with Inline => True;

   procedure BREAKPOINT
      with Inline => True;

   procedure Asm_Call
      (Target_Address : in Address)
      with Inline => True;

   ----------------------------------------------------------------------------
   -- Exceptions and interrupts
   ----------------------------------------------------------------------------

   subtype Exception_Vector_Id_Type is Unsigned_32 range 0 .. 255;

   Reset_Initial_Int_Stack_Pointer   : constant := 0;
   Reset_Initial_Program_Counter     : constant := 1;
   Access_Fault                      : constant := 2;
   Address_Error                     : constant := 3;
   Illegal_Instruction               : constant := 4;
   Integer_Divide_by_Zero            : constant := 5;
   CHK_CHK2_Instruction              : constant := 6;
   FTRAPcc_TRAPcc_TRAPV_Instructions : constant := 7;
   Privilege_Violation               : constant := 8;
   Trace                             : constant := 9;
   Line_1010_Emulator                : constant := 10;
   Line_1111_Emulator                : constant := 11;
   Unassigned_Reserved_1             : constant := 12;
   Coprocessor_Protocol_Violation    : constant := 13; -- defined for MC68020 and MC68030; not used by MC68040
   Format_Error                      : constant := 14;
   Uninitialized_Interrupt           : constant := 15;
   Unassigned_Reserved_2             : constant := 16;
   Unassigned_Reserved_3             : constant := 17;
   Unassigned_Reserved_4             : constant := 18;
   Unassigned_Reserved_5             : constant := 19;
   Unassigned_Reserved_6             : constant := 20;
   Unassigned_Reserved_7             : constant := 21;
   Unassigned_Reserved_8             : constant := 22;
   Unassigned_Reserved_9             : constant := 23;
   Spurious_Interrupt                : constant := 24;
   Level_1_Interrupt_Autovector      : constant := 25;
   Level_2_Interrupt_Autovector      : constant := 26;
   Level_3_Interrupt_Autovector      : constant := 27;
   Level_4_Interrupt_Autovector      : constant := 28;
   Level_5_Interrupt_Autovector      : constant := 29;
   Level_6_Interrupt_Autovector      : constant := 30;
   Level_7_Interrupt_Autovector      : constant := 31;
   Trap_0                            : constant := 32;
   Trap_1                            : constant := 33;
   Trap_2                            : constant := 34;
   Trap_3                            : constant := 35;
   Trap_4                            : constant := 36;
   Trap_5                            : constant := 37;
   Trap_6                            : constant := 38;
   Trap_7                            : constant := 39;
   Trap_8                            : constant := 40;
   Trap_9                            : constant := 41;
   Trap_10                           : constant := 42;
   Trap_11                           : constant := 43;
   Trap_12                           : constant := 44;
   Trap_13                           : constant := 45;
   Trap_14                           : constant := 46;
   Trap_15                           : constant := 47;
   FP_BrOrSet_on_Unordered_Condition : constant := 48;
   FP_Inexact_Result                 : constant := 49;
   FP_Divide_by_Zero                 : constant := 50;
   FP_Underflow                      : constant := 51;
   FP_Operand_Error                  : constant := 52;
   FP_Overflow                       : constant := 53;
   FP_Signaling_NAN                  : constant := 54;
   FP_Unimplemented_Data_Type        : constant := 55; -- unassigned, reserved for MC68020
   MMU_Configuration_Error           : constant := 56; -- defined for MC68030 and MC68851, not used by MC68040
   MMU_Illegal_Operation_Error       : constant := 57; -- defined for MC68851, not used by MC68040
   MMU_Access_Level_Violation_Error  : constant := 58; -- defined for MC68851, not used by MC68040
   Unassigned_Reserved_10            : constant := 59;
   Unassigned_Reserved_11            : constant := 60;
   Unassigned_Reserved_12            : constant := 61;
   Unassigned_Reserved_13            : constant := 62;
   Unassigned_Reserved_14            : constant := 63;
   User_Defined_Vector_0             : constant := 64;
   User_Defined_Vector_1             : constant := 65;
   User_Defined_Vector_2             : constant := 66;
   User_Defined_Vector_3             : constant := 67;
   User_Defined_Vector_4             : constant := 68;
   User_Defined_Vector_5             : constant := 69;
   User_Defined_Vector_6             : constant := 70;
   User_Defined_Vector_7             : constant := 71;
   User_Defined_Vector_8             : constant := 72;
   User_Defined_Vector_9             : constant := 73;
   User_Defined_Vector_10            : constant := 74;
   User_Defined_Vector_11            : constant := 75;
   User_Defined_Vector_12            : constant := 76;
   User_Defined_Vector_13            : constant := 77;
   User_Defined_Vector_14            : constant := 78;
   User_Defined_Vector_15            : constant := 79;
   User_Defined_Vector_16            : constant := 80;
   User_Defined_Vector_17            : constant := 81;
   User_Defined_Vector_18            : constant := 82;
   User_Defined_Vector_19            : constant := 83;
   User_Defined_Vector_20            : constant := 84;
   User_Defined_Vector_21            : constant := 85;
   User_Defined_Vector_22            : constant := 86;
   User_Defined_Vector_23            : constant := 87;
   User_Defined_Vector_24            : constant := 88;
   User_Defined_Vector_25            : constant := 89;
   User_Defined_Vector_26            : constant := 90;
   User_Defined_Vector_27            : constant := 91;
   User_Defined_Vector_28            : constant := 92;
   User_Defined_Vector_29            : constant := 93;
   User_Defined_Vector_30            : constant := 94;
   User_Defined_Vector_31            : constant := 95;
   User_Defined_Vector_32            : constant := 96;
   User_Defined_Vector_33            : constant := 97;
   User_Defined_Vector_34            : constant := 98;
   User_Defined_Vector_35            : constant := 99;
   User_Defined_Vector_36            : constant := 100;
   User_Defined_Vector_37            : constant := 101;
   User_Defined_Vector_38            : constant := 102;
   User_Defined_Vector_39            : constant := 103;
   User_Defined_Vector_40            : constant := 104;
   User_Defined_Vector_41            : constant := 105;
   User_Defined_Vector_42            : constant := 106;
   User_Defined_Vector_43            : constant := 107;
   User_Defined_Vector_44            : constant := 108;
   User_Defined_Vector_45            : constant := 109;
   User_Defined_Vector_46            : constant := 110;
   User_Defined_Vector_47            : constant := 111;
   User_Defined_Vector_48            : constant := 112;
   User_Defined_Vector_49            : constant := 113;
   User_Defined_Vector_50            : constant := 114;
   User_Defined_Vector_51            : constant := 115;
   User_Defined_Vector_52            : constant := 116;
   User_Defined_Vector_53            : constant := 117;
   User_Defined_Vector_54            : constant := 118;
   User_Defined_Vector_55            : constant := 119;
   User_Defined_Vector_56            : constant := 120;
   User_Defined_Vector_57            : constant := 121;
   User_Defined_Vector_58            : constant := 122;
   User_Defined_Vector_59            : constant := 123;
   User_Defined_Vector_60            : constant := 124;
   User_Defined_Vector_61            : constant := 125;
   User_Defined_Vector_62            : constant := 126;
   User_Defined_Vector_63            : constant := 127;
   User_Defined_Vector_64            : constant := 128;
   User_Defined_Vector_65            : constant := 129;
   User_Defined_Vector_66            : constant := 130;
   User_Defined_Vector_67            : constant := 131;
   User_Defined_Vector_68            : constant := 132;
   User_Defined_Vector_69            : constant := 133;
   User_Defined_Vector_70            : constant := 134;
   User_Defined_Vector_71            : constant := 135;
   User_Defined_Vector_72            : constant := 136;
   User_Defined_Vector_73            : constant := 137;
   User_Defined_Vector_74            : constant := 138;
   User_Defined_Vector_75            : constant := 139;
   User_Defined_Vector_76            : constant := 140;
   User_Defined_Vector_77            : constant := 141;
   User_Defined_Vector_78            : constant := 142;
   User_Defined_Vector_79            : constant := 143;
   User_Defined_Vector_80            : constant := 144;
   User_Defined_Vector_81            : constant := 145;
   User_Defined_Vector_82            : constant := 146;
   User_Defined_Vector_83            : constant := 147;
   User_Defined_Vector_84            : constant := 148;
   User_Defined_Vector_85            : constant := 149;
   User_Defined_Vector_86            : constant := 150;
   User_Defined_Vector_87            : constant := 151;
   User_Defined_Vector_88            : constant := 152;
   User_Defined_Vector_89            : constant := 153;
   User_Defined_Vector_90            : constant := 154;
   User_Defined_Vector_91            : constant := 155;
   User_Defined_Vector_92            : constant := 156;
   User_Defined_Vector_93            : constant := 157;
   User_Defined_Vector_94            : constant := 158;
   User_Defined_Vector_95            : constant := 159;
   User_Defined_Vector_96            : constant := 160;
   User_Defined_Vector_97            : constant := 161;
   User_Defined_Vector_98            : constant := 162;
   User_Defined_Vector_99            : constant := 163;
   User_Defined_Vector_100           : constant := 164;
   User_Defined_Vector_101           : constant := 165;
   User_Defined_Vector_102           : constant := 166;
   User_Defined_Vector_103           : constant := 167;
   User_Defined_Vector_104           : constant := 168;
   User_Defined_Vector_105           : constant := 169;
   User_Defined_Vector_106           : constant := 170;
   User_Defined_Vector_107           : constant := 171;
   User_Defined_Vector_108           : constant := 172;
   User_Defined_Vector_109           : constant := 173;
   User_Defined_Vector_110           : constant := 174;
   User_Defined_Vector_111           : constant := 175;
   User_Defined_Vector_112           : constant := 176;
   User_Defined_Vector_113           : constant := 177;
   User_Defined_Vector_114           : constant := 178;
   User_Defined_Vector_115           : constant := 179;
   User_Defined_Vector_116           : constant := 180;
   User_Defined_Vector_117           : constant := 181;
   User_Defined_Vector_118           : constant := 182;
   User_Defined_Vector_119           : constant := 183;
   User_Defined_Vector_120           : constant := 184;
   User_Defined_Vector_121           : constant := 185;
   User_Defined_Vector_122           : constant := 186;
   User_Defined_Vector_123           : constant := 187;
   User_Defined_Vector_124           : constant := 188;
   User_Defined_Vector_125           : constant := 189;
   User_Defined_Vector_126           : constant := 190;
   User_Defined_Vector_127           : constant := 191;
   User_Defined_Vector_128           : constant := 192;
   User_Defined_Vector_129           : constant := 193;
   User_Defined_Vector_130           : constant := 194;
   User_Defined_Vector_131           : constant := 195;
   User_Defined_Vector_132           : constant := 196;
   User_Defined_Vector_133           : constant := 197;
   User_Defined_Vector_134           : constant := 198;
   User_Defined_Vector_135           : constant := 199;
   User_Defined_Vector_136           : constant := 200;
   User_Defined_Vector_137           : constant := 201;
   User_Defined_Vector_138           : constant := 202;
   User_Defined_Vector_139           : constant := 203;
   User_Defined_Vector_140           : constant := 204;
   User_Defined_Vector_141           : constant := 205;
   User_Defined_Vector_142           : constant := 206;
   User_Defined_Vector_143           : constant := 207;
   User_Defined_Vector_144           : constant := 208;
   User_Defined_Vector_145           : constant := 209;
   User_Defined_Vector_146           : constant := 210;
   User_Defined_Vector_147           : constant := 211;
   User_Defined_Vector_148           : constant := 212;
   User_Defined_Vector_149           : constant := 213;
   User_Defined_Vector_150           : constant := 214;
   User_Defined_Vector_151           : constant := 215;
   User_Defined_Vector_152           : constant := 216;
   User_Defined_Vector_153           : constant := 217;
   User_Defined_Vector_154           : constant := 218;
   User_Defined_Vector_155           : constant := 219;
   User_Defined_Vector_156           : constant := 220;
   User_Defined_Vector_157           : constant := 221;
   User_Defined_Vector_158           : constant := 222;
   User_Defined_Vector_159           : constant := 223;
   User_Defined_Vector_160           : constant := 224;
   User_Defined_Vector_161           : constant := 225;
   User_Defined_Vector_162           : constant := 226;
   User_Defined_Vector_163           : constant := 227;
   User_Defined_Vector_164           : constant := 228;
   User_Defined_Vector_165           : constant := 229;
   User_Defined_Vector_166           : constant := 230;
   User_Defined_Vector_167           : constant := 231;
   User_Defined_Vector_168           : constant := 232;
   User_Defined_Vector_169           : constant := 233;
   User_Defined_Vector_170           : constant := 234;
   User_Defined_Vector_171           : constant := 235;
   User_Defined_Vector_172           : constant := 236;
   User_Defined_Vector_173           : constant := 237;
   User_Defined_Vector_174           : constant := 238;
   User_Defined_Vector_175           : constant := 239;
   User_Defined_Vector_176           : constant := 240;
   User_Defined_Vector_177           : constant := 241;
   User_Defined_Vector_178           : constant := 242;
   User_Defined_Vector_179           : constant := 243;
   User_Defined_Vector_180           : constant := 244;
   User_Defined_Vector_181           : constant := 245;
   User_Defined_Vector_182           : constant := 246;
   User_Defined_Vector_183           : constant := 247;
   User_Defined_Vector_184           : constant := 248;
   User_Defined_Vector_185           : constant := 249;
   User_Defined_Vector_186           : constant := 250;
   User_Defined_Vector_187           : constant := 251;
   User_Defined_Vector_188           : constant := 252;
   User_Defined_Vector_189           : constant := 253;
   User_Defined_Vector_190           : constant := 254;
   User_Defined_Vector_191           : constant := 255;

   type Exception_Vector_Table_Type is array (Exception_Vector_Id_Type) of Address
      with Alignment => 2**10,
           Size      => 256 * 32;

   String_Access_Fault                      : aliased constant String := "Access Fault";
   String_Address_Error                     : aliased constant String := "Address Error";
   String_Illegal_Instruction               : aliased constant String := "Illegal Instruction";
   String_Integer_Divide_by_Zero            : aliased constant String := "Integer Divide by Zero";
   String_CHK_CHK2_Instruction              : aliased constant String := "CHK, CHK2 Instruction";
   String_FTRAPcc_TRAPcc_TRAPV_Instructions : aliased constant String := "FTRAPcc, TRAPcc, TRAPV Instructions";
   String_Privilege_Violation               : aliased constant String := "Privilege Violation";
   String_Trace                             : aliased constant String := "Trace";
   String_Line_1010_Emulator                : aliased constant String := "Line 1010 Emulator";
   String_Line_1111_Emulator                : aliased constant String := "Line 1111 Emulator";
   String_Unassigned_Reserved_1             : aliased constant String := "Unassigned, Reserved";
   String_Coprocessor_Protocol_Violation    : aliased constant String := "Coprocessor Protocol Violation";
   String_Format_Error                      : aliased constant String := "Format Error";
   String_Uninitialized_Interrupt           : aliased constant String := "Uninitialized Interrupt";
   String_FP_BrOrSet_on_Unordered_Condition : aliased constant String := "FP Branch Or Set on Unordered Condition";
   String_FP_Inexact_Result                 : aliased constant String := "FP Inexact Result";
   String_FP_Divide_by_Zero                 : aliased constant String := "FP Divide by Zero";
   String_FP_Underflow                      : aliased constant String := "FP Underflow";
   String_FP_Operand_Error                  : aliased constant String := "FP Operand Error";
   String_FP_Overflow                       : aliased constant String := "FP Overflow";
   String_FP_Signaling_NAN                  : aliased constant String := "FP Signaling NAN";
   String_FP_Unimplemented_Data_Type        : aliased constant String := "FP Unimplemented Data Type";
   String_MMU_Configuration_Error           : aliased constant String := "MMU Configuration Error";
   String_MMU_Illegal_Operation_Error       : aliased constant String := "MMU Illegal Operation Error";
   String_MMU_Access_Level_Violation_Error  : aliased constant String := "MMU Access Level Violation Error";
   String_UNKNOWN_EXCEPTION                 : aliased constant String := "UNKNOWN EXCEPTION";

   MsgPtr_Access_Fault                      : constant access constant String := String_Access_Fault'Access;
   MsgPtr_Address_Error                     : constant access constant String := String_Address_Error'Access;
   MsgPtr_Illegal_Instruction               : constant access constant String := String_Illegal_Instruction'Access;
   MsgPtr_Integer_Divide_by_Zero            : constant access constant String := String_Integer_Divide_by_Zero'Access;
   MsgPtr_CHK_CHK2_Instruction              : constant access constant String := String_CHK_CHK2_Instruction'Access;
   MsgPtr_FTRAPcc_TRAPcc_TRAPV_Instructions : constant access constant String := String_FTRAPcc_TRAPcc_TRAPV_Instructions'Access;
   MsgPtr_Privilege_Violation               : constant access constant String := String_Privilege_Violation'Access;
   MsgPtr_Trace                             : constant access constant String := String_Trace'Access;
   MsgPtr_Line_1010_Emulator                : constant access constant String := String_Line_1010_Emulator'Access;
   MsgPtr_Line_1111_Emulator                : constant access constant String := String_Line_1111_Emulator'Access;
   MsgPtr_Unassigned_Reserved_1             : constant access constant String := String_Unassigned_Reserved_1'Access;
   MsgPtr_Coprocessor_Protocol_Violation    : constant access constant String := String_Coprocessor_Protocol_Violation'Access;
   MsgPtr_Format_Error                      : constant access constant String := String_Format_Error'Access;
   MsgPtr_Uninitialized_Interrupt           : constant access constant String := String_Uninitialized_Interrupt'Access;
   MsgPtr_FP_BrOrSet_on_Unordered_Condition : constant access constant String := String_FP_BrOrSet_on_Unordered_Condition'Access;
   MsgPtr_FP_Inexact_Result                 : constant access constant String := String_FP_Inexact_Result'Access;
   MsgPtr_FP_Divide_by_Zero                 : constant access constant String := String_FP_Divide_by_Zero'Access;
   MsgPtr_FP_Underflow                      : constant access constant String := String_FP_Underflow'Access;
   MsgPtr_FP_Operand_Error                  : constant access constant String := String_FP_Operand_Error'Access;
   MsgPtr_FP_Overflow                       : constant access constant String := String_FP_Overflow'Access;
   MsgPtr_FP_Signaling_NAN                  : constant access constant String := String_FP_Signaling_NAN'Access;
   MsgPtr_FP_Unimplemented_Data_Type        : constant access constant String := String_FP_Unimplemented_Data_Type'Access;
   MsgPtr_MMU_Configuration_Error           : constant access constant String := String_MMU_Configuration_Error'Access;
   MsgPtr_MMU_Illegal_Operation_Error       : constant access constant String := String_MMU_Illegal_Operation_Error'Access;
   MsgPtr_MMU_Access_Level_Violation_Error  : constant access constant String := String_MMU_Access_Level_Violation_Error'Access;
   MsgPtr_UNKNOWN_EXCEPTION                 : constant access constant String := String_UNKNOWN_EXCEPTION'Access;

   subtype Intcontext_Type is SR_Type;

   procedure Intcontext_Get
      (Intcontext : out Intcontext_Type)
      with Inline => True;
   procedure Intcontext_Set
      (Intcontext : in Intcontext_Type)
      with Inline => True;

   procedure Irq_Enable
      with Inline => True;
   procedure Irq_Disable
      with Inline => True;

pragma Style_Checks (On);

end M68k;

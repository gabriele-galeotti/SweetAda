-----------------------------------------------------------------------------------------------------------------------
--                                                     SweetAda                                                      --
-----------------------------------------------------------------------------------------------------------------------
-- __HDS__                                                                                                           --
-- __FLN__ c_wrappers.adb                                                                                            --
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

with Bits;

package body C_Wrappers
   is

   --========================================================================--
   --                                                                        --
   --                                                                        --
   --                           Local declarations                           --
   --                                                                        --
   --                                                                        --
   --========================================================================--

   use type Bits.Bits_8;
   use type Bits.C.int;

   type Ctype_Idx_Type is range 0 .. 256;

   UCASE : constant := 2#00000001#; -- UPPERCASE SYMBOL
   LCASE : constant := 2#00000010#; -- LOWERCASE SYMBOL
   DIGIT : constant := 2#00000100#; -- NUMERIC DIGIT
   SPACE : constant := 2#00001000#; -- "HARD" SPACE (0x20)
   PUNCT : constant := 2#00010000#; -- PUNCTUATION CHARACTER
   CNTRL : constant := 2#00100000#; -- CONTROL CHARACTER
   BLANK : constant := 2#01000000#; -- "C" LOCALE WHITE SPACE CHARACTER (HT/LF/VT/FF/CR/SP)
   DIGIX : constant := 2#10000000#; -- HEXADECIMAL DIGIT

   Ctype_Character_Table : array (Ctype_Idx_Type) of Bits.Bits_8 := [
        --                DEC  HEX |    |
        0,             --          |    | EOF
        CNTRL,         --   0 0x00 |  ^@| NUL
        CNTRL,         --   1 0x01 |  ^A| SOH
        CNTRL,         --   2 0x02 |  ^B| STX
        CNTRL,         --   3 0x03 |  ^C| ETX
        CNTRL,         --   4 0x04 |  ^D| EOT
        CNTRL,         --   5 0x05 |  ^E| ENQ
        CNTRL,         --   6 0x06 |  ^F| ACK
        CNTRL,         --   7 0x07 |  ^G| BEL
        CNTRL,         --   8 0x08 |  ^H| BS
        CNTRL + BLANK, --   9 0x09 |  ^I| HT
        CNTRL + BLANK, --  10 0x0A |  ^J| LF
        CNTRL + BLANK, --  11 0x0B |  ^K| VT
        CNTRL + BLANK, --  12 0x0C |  ^L| FF
        CNTRL + BLANK, --  13 0x0D |  ^M| CR
        CNTRL,         --  14 0x0E |  ^N| SO
        CNTRL,         --  15 0x0F |  ^O| SI
        CNTRL,         --  16 0x10 |  ^P| DLE
        CNTRL,         --  17 0x11 |  ^Q| DC1
        CNTRL,         --  18 0x12 |  ^R| DC2
        CNTRL,         --  19 0x13 |  ^S| DC3
        CNTRL,         --  20 0x14 |  ^T| DC4
        CNTRL,         --  21 0x15 |  ^U| NAK
        CNTRL,         --  22 0x16 |  ^V| SYN
        CNTRL,         --  23 0x17 |  ^W| ETB
        CNTRL,         --  24 0x18 |  ^X| CAN
        CNTRL,         --  25 0x19 |  ^Y| EM
        CNTRL,         --  26 0x1A |  ^Z| SUB
        CNTRL,         --  27 0x1B |  ^[| ESC
        CNTRL,         --  28 0x1C |  ^\| FS
        CNTRL,         --  29 0x1D |  ^]| GS
        CNTRL,         --  30 0x1E |  ^^| RS
        CNTRL,         --  31 0x1F |  ^_| US
        BLANK + SPACE, --  32 0x20 |    | SP
        PUNCT,         --  33 0x21 |   !|
        PUNCT,         --  34 0x22 |   "|
        PUNCT,         --  35 0x23 |   #|
        PUNCT,         --  36 0x24 |   $|
        PUNCT,         --  37 0x25 |   %|
        PUNCT,         --  38 0x26 |   &|
        PUNCT,         --  39 0x27 |   '|
        PUNCT,         --  40 0x28 |   (|
        PUNCT,         --  41 0x29 |   )|
        PUNCT,         --  42 0x2A |   *|
        PUNCT,         --  43 0x2B |   +|
        PUNCT,         --  44 0x2C |   ,|
        PUNCT,         --  45 0x2D |   -|
        PUNCT,         --  46 0x2E |   .|
        PUNCT,         --  47 0x2F |   /|
        DIGIT,         --  48 0x30 |   0|
        DIGIT,         --  49 0x31 |   1|
        DIGIT,         --  50 0x32 |   2|
        DIGIT,         --  51 0x33 |   3|
        DIGIT,         --  52 0x34 |   4|
        DIGIT,         --  53 0x35 |   5|
        DIGIT,         --  54 0x36 |   6|
        DIGIT,         --  55 0x37 |   7|
        DIGIT,         --  56 0x38 |   8|
        DIGIT,         --  57 0x39 |   9|
        PUNCT,         --  58 0x3A |   :|
        PUNCT,         --  59 0x3B |   ;|
        PUNCT,         --  60 0x3C |   <|
        PUNCT,         --  61 0x3D |   =|
        PUNCT,         --  62 0x3E |   >|
        PUNCT,         --  63 0x3F |   ?|
        PUNCT,         --  64 0x40 |   @|
        UCASE + DIGIX, --  65 0x41 |   A|
        UCASE + DIGIX, --  66 0x42 |   B|
        UCASE + DIGIX, --  67 0x43 |   C|
        UCASE + DIGIX, --  68 0x44 |   D|
        UCASE + DIGIX, --  69 0x45 |   E|
        UCASE + DIGIX, --  70 0x46 |   F|
        UCASE,         --  71 0x47 |   G|
        UCASE,         --  72 0x48 |   H|
        UCASE,         --  73 0x49 |   I|
        UCASE,         --  74 0x4A |   J|
        UCASE,         --  75 0x4B |   K|
        UCASE,         --  76 0x4C |   L|
        UCASE,         --  77 0x4D |   M|
        UCASE,         --  78 0x4E |   N|
        UCASE,         --  79 0x4F |   O|
        UCASE,         --  80 0x50 |   P|
        UCASE,         --  81 0x51 |   Q|
        UCASE,         --  82 0x52 |   R|
        UCASE,         --  83 0x53 |   S|
        UCASE,         --  84 0x54 |   T|
        UCASE,         --  85 0x55 |   U|
        UCASE,         --  86 0x56 |   V|
        UCASE,         --  87 0x57 |   W|
        UCASE,         --  88 0x58 |   X|
        UCASE,         --  89 0x59 |   Y|
        UCASE,         --  90 0x5A |   Z|
        PUNCT,         --  91 0x5B |   [|
        PUNCT,         --  92 0x5C |   \|
        PUNCT,         --  93 0x5D |   ]|
        PUNCT,         --  94 0x5E |   ^|
        PUNCT,         --  95 0x5F |   _|
        PUNCT,         --  96 0x60 |   `|
        LCASE + DIGIX, --  97 0x61 |   a|
        LCASE + DIGIX, --  98 0x62 |   b|
        LCASE + DIGIX, --  99 0x63 |   c|
        LCASE + DIGIX, -- 100 0x64 |   d|
        LCASE + DIGIX, -- 101 0x65 |   e|
        LCASE + DIGIX, -- 102 0x66 |   f|
        LCASE,         -- 103 0x67 |   g|
        LCASE,         -- 104 0x68 |   h|
        LCASE,         -- 105 0x69 |   i|
        LCASE,         -- 106 0x6A |   j|
        LCASE,         -- 107 0x6B |   k|
        LCASE,         -- 108 0x6C |   l|
        LCASE,         -- 109 0x6D |   m|
        LCASE,         -- 110 0x6E |   n|
        LCASE,         -- 111 0x6F |   o|
        LCASE,         -- 112 0x70 |   p|
        LCASE,         -- 113 0x71 |   q|
        LCASE,         -- 114 0x72 |   r|
        LCASE,         -- 115 0x73 |   s|
        LCASE,         -- 116 0x74 |   t|
        LCASE,         -- 117 0x75 |   u|
        LCASE,         -- 118 0x76 |   v|
        LCASE,         -- 119 0x77 |   w|
        LCASE,         -- 120 0x78 |   x|
        LCASE,         -- 121 0x79 |   y|
        LCASE,         -- 122 0x7A |   z|
        PUNCT,         -- 123 0x7B |   {|
        PUNCT,         -- 124 0x7C |   ||
        PUNCT,         -- 125 0x7D |   }|
        PUNCT,         -- 126 0x7E |   ~|
        CNTRL,         -- 127 0x7F |    | DEL
        0,             -- 128 0x80 |^M-@|
        0,             -- 129 0x81 |^M-A|
        0,             -- 130 0x82 |^M-B|
        0,             -- 131 0x83 |^M-C|
        0,             -- 132 0x84 |^M-D|
        0,             -- 133 0x85 |^M-E|
        0,             -- 134 0x86 |^M-F|
        0,             -- 135 0x87 |^M-G|
        0,             -- 136 0x88 |^M-H|
        0,             -- 137 0x89 |^M-I|
        0,             -- 138 0x8A |^M-J|
        0,             -- 139 0x8B |^M-K|
        0,             -- 140 0x8C |^M-L|
        0,             -- 141 0x8D |^M-M|
        0,             -- 142 0x8E |^M-N|
        0,             -- 143 0x8F |^M-O|
        0,             -- 144 0x90 |^M-P|
        0,             -- 145 0x91 |^M-Q|
        0,             -- 146 0x92 |^M-R|
        0,             -- 147 0x93 |^M-S|
        0,             -- 148 0x94 |^M-T|
        0,             -- 149 0x95 |^M-U|
        0,             -- 150 0x96 |^M-V|
        0,             -- 151 0x97 |^M-W|
        0,             -- 152 0x98 |^M-X|
        0,             -- 153 0x99 |^M-Y|
        0,             -- 154 0x9A |^M-Z|
        0,             -- 155 0x9B |^M-[|
        0,             -- 156 0x9C |^M-\|
        0,             -- 157 0x9D |^M-]|
        0,             -- 158 0x9E |^M-^|
        0,             -- 159 0x9F |^M-_|
        BLANK + SPACE, -- 160 0xA0 | M- | NON-BREAKING SPACE
        PUNCT,         -- 161 0xA1 | M-!| ¡
        PUNCT,         -- 162 0xA2 | M-"| ¢
        PUNCT,         -- 163 0xA3 | M-#| £
        PUNCT,         -- 164 0xA4 | M-$| ¤
        PUNCT,         -- 165 0xA5 | M-%| ¥
        PUNCT,         -- 166 0xA6 | M-&| ¦
        PUNCT,         -- 167 0xA7 | M-'| §
        PUNCT,         -- 168 0xA8 | M-(| ¨
        PUNCT,         -- 169 0xA9 | M-)| ©
        PUNCT,         -- 170 0xAA | M-*| ª
        PUNCT,         -- 171 0xAB | M-+| «
        PUNCT,         -- 172 0xAC | M-,| ¬
        PUNCT,         -- 173 0xAD | M--| SOFT HYPHEN
        PUNCT,         -- 174 0xAE | M-.| ®
        PUNCT,         -- 175 0xAF | M-/| ¯
        PUNCT,         -- 176 0xB0 | M-0| °
        PUNCT,         -- 177 0xB1 | M-1| ±
        PUNCT,         -- 178 0xB2 | M-2| ²
        PUNCT,         -- 179 0xB3 | M-3| ³
        PUNCT,         -- 180 0xB4 | M-4| ´
        PUNCT,         -- 181 0xB5 | M-5| µ
        PUNCT,         -- 182 0xB6 | M-6| ¶
        PUNCT,         -- 183 0xB7 | M-7| ·
        PUNCT,         -- 184 0xB8 | M-8| ¸
        PUNCT,         -- 185 0xB9 | M-9| ¹
        PUNCT,         -- 186 0xBA | M-:| º
        PUNCT,         -- 187 0xBB | M-;| »
        PUNCT,         -- 188 0xBC | M-<| ¼
        PUNCT,         -- 189 0xBD | M-=| ½
        PUNCT,         -- 190 0xBE | M->| ¾
        PUNCT,         -- 191 0xBF | M-?| ¿
        UCASE,         -- 192 0xC0 | M-@| À
        UCASE,         -- 193 0xC1 | M-A| Á
        UCASE,         -- 194 0xC2 | M-B| Â
        UCASE,         -- 195 0xC3 | M-C| Ã
        UCASE,         -- 196 0xC4 | M-D| Ä
        UCASE,         -- 197 0xC5 | M-E| Å
        UCASE,         -- 198 0xC6 | M-F| Æ
        UCASE,         -- 199 0xC7 | M-G| Ç
        UCASE,         -- 200 0xC8 | M-H| È
        UCASE,         -- 201 0xC9 | M-I| É
        UCASE,         -- 202 0xCA | M-J| Ê
        UCASE,         -- 203 0xCB | M-K| Ë
        UCASE,         -- 204 0xCC | M-L| Ì
        UCASE,         -- 205 0xCD | M-M| Í
        UCASE,         -- 206 0xCE | M-N| Î
        UCASE,         -- 207 0xCF | M-O| Ï
        UCASE,         -- 208 0xD0 | M-P| Ð
        UCASE,         -- 209 0xD1 | M-Q| Ñ
        UCASE,         -- 210 0xD2 | M-R| Ò
        UCASE,         -- 211 0xD3 | M-S| Ó
        UCASE,         -- 212 0xD4 | M-T| Ô
        UCASE,         -- 213 0xD5 | M-U| Õ
        UCASE,         -- 214 0xD6 | M-V| Ö
        PUNCT,         -- 215 0xD7 | M-W| × MULTIPLICATION SIGN
        UCASE,         -- 216 0xD8 | M-X| Ø
        UCASE,         -- 217 0xD9 | M-Y| Ù
        UCASE,         -- 218 0xDA | M-Z| Ú
        UCASE,         -- 219 0xDB | M-[| Û
        UCASE,         -- 220 0xDC | M-\| Ü
        UCASE,         -- 221 0xDD | M-]| Ý
        UCASE,         -- 222 0xDE | M-^| Þ
        LCASE,         -- 223 0xDF | M-_| ß
        LCASE,         -- 224 0xE0 | M-`| à
        LCASE,         -- 225 0xE1 | M-a| á
        LCASE,         -- 226 0xE2 | M-b| â
        LCASE,         -- 227 0xE3 | M-c| ã
        LCASE,         -- 228 0xE4 | M-d| ä
        LCASE,         -- 229 0xE5 | M-e| å
        LCASE,         -- 230 0xE6 | M-f| æ
        LCASE,         -- 231 0xE7 | M-g| ç
        LCASE,         -- 232 0xE8 | M-h| è
        LCASE,         -- 233 0xE9 | M-i| é
        LCASE,         -- 234 0xEA | M-j| ê
        LCASE,         -- 235 0xEB | M-k| ë
        LCASE,         -- 236 0xEC | M-l| ì
        LCASE,         -- 237 0xED | M-m| í
        LCASE,         -- 238 0xEE | M-n| î
        LCASE,         -- 239 0xEF | M-o| ï
        LCASE,         -- 240 0xF0 | M-p| ð
        LCASE,         -- 241 0xF1 | M-q| ñ
        LCASE,         -- 242 0xF2 | M-r| ò
        LCASE,         -- 243 0xF3 | M-s| ó
        LCASE,         -- 244 0xF4 | M-t| ô
        LCASE,         -- 245 0xF5 | M-u| õ
        LCASE,         -- 246 0xF6 | M-v| ö
        PUNCT,         -- 247 0xF7 | M-w| ÷ DIVISION SIGN
        LCASE,         -- 248 0xF8 | M-x| ø
        LCASE,         -- 249 0xF9 | M-y| ù
        LCASE,         -- 250 0xFA | M-z| ú
        LCASE,         -- 251 0xFB | M-{| û
        LCASE,         -- 252 0xFC | M-|| ü
        LCASE,         -- 253 0xFD | M-}| ý
        LCASE,         -- 254 0xFE | M-~| þ
        LCASE          -- 255 0xFF |    | ÿ
      ]
      with Export        => True,
           Convention    => C,
           External_Name => "_CTYPE_character_table";

   function To_CtypeIdx
      (c : Bits.C.int)
      return Ctype_Idx_Type
      with Inline => True;

   function Is_Something
      (c : Bits.C.int;
       x : Bits.Bits_8)
      return Bits.C.int
      with Inline => True;

   --========================================================================--
   --                                                                        --
   --                                                                        --
   --                           Package subprograms                          --
   --                                                                        --
   --                                                                        --
   --========================================================================--

   function To_CtypeIdx
      (c : Bits.C.int)
      return Ctype_Idx_Type
      is
   begin
      return (if c < 0 or else c > 255 then 0 else Ctype_Idx_Type (c + 1));
   end To_CtypeIdx;

   function Is_Something
      (c : Bits.C.int;
       x : Bits.Bits_8)
      return Bits.C.int
      is
   begin
      return Bits.C.int (Ctype_Character_Table (To_CtypeIdx (c)) and x);
   end Is_Something;

   ----------------------------------------------------------------------------
   -- CTYPE
   ----------------------------------------------------------------------------

   function Is_Alnum
      (c : Bits.C.int)
      return Bits.C.int
      is
   begin
      return Is_Something (c, Bits.Bits_8'(UCASE or LCASE or DIGIT));
   end Is_Alnum;

   function Is_Alpha
      (c : Bits.C.int)
      return Bits.C.int
      is
   begin
      return Is_Something (c, Bits.Bits_8'(UCASE or LCASE));
   end Is_Alpha;

   function Is_Cntrl
      (c : Bits.C.int)
      return Bits.C.int
      is
   begin
      return Is_Something (c, Bits.Bits_8'(CNTRL));
   end Is_Cntrl;

   function Is_Digit
      (c : Bits.C.int)
      return Bits.C.int
      is
   begin
      return Is_Something (c, Bits.Bits_8'(DIGIT));
   end Is_Digit;

   function Is_Graph
      (c : Bits.C.int)
      return Bits.C.int
      is
   begin
      return Is_Something (c, Bits.Bits_8'(UCASE or LCASE or DIGIT or PUNCT));
   end Is_Graph;

   function Is_Lower
      (c : Bits.C.int)
      return Bits.C.int
      is
   begin
      return Is_Something (c, Bits.Bits_8'(LCASE));
   end Is_Lower;

   function Is_Print
      (c : Bits.C.int)
      return Bits.C.int
      is
   begin
      return Is_Something (c, Bits.Bits_8'(UCASE or LCASE or DIGIT or SPACE or PUNCT));
   end Is_Print;

   function Is_Punct
      (c : Bits.C.int)
      return Bits.C.int
      is
   begin
      return Is_Something (c, Bits.Bits_8'(PUNCT));
   end Is_Punct;

   function Is_Space
      (c : Bits.C.int)
      return Bits.C.int
      is
   begin
      return Is_Something (c, Bits.Bits_8'(BLANK));
   end Is_Space;

   function Is_Upper
      (c : Bits.C.int)
      return Bits.C.int
      is
   begin
      return Is_Something (c, Bits.Bits_8'(UCASE));
   end Is_Upper;

   function Is_XDigit
      (c : Bits.C.int)
      return Bits.C.int
      is
   begin
      return Is_Something (c, Bits.Bits_8'(DIGIT or DIGIX));
   end Is_XDigit;

   function Is_ASCII
      (c : Bits.C.int)
      return Bits.C.int
      is
      Idx : Ctype_Idx_Type;
   begin
      Idx := To_CtypeIdx (c);
      return (if Idx > 0 and then Idx <= 16#80# then 1 else 0);
   end Is_ASCII;

   function To_ASCII
      (c : Bits.C.int)
      return Bits.C.int
      is
      Idx   : Ctype_Idx_Type;
      Value : Bits.C.int := c;
   begin
      Idx := To_CtypeIdx (c);
      if Idx > 16#80# then
         Value := @ - 16#80#;
      end if;
      return Value;
   end To_ASCII;

   function To_Lower
      (c : Bits.C.int)
      return Bits.C.int
      is
      Value : Bits.C.int := c;
   begin
      if Is_Upper (c) /= 0 then
         Value := @ + 16#20#;
      end if;
      return Value;
   end To_Lower;

   function To_Upper
      (c : Bits.C.int)
      return Bits.C.int
      is
      Value : Bits.C.int := c;
   begin
      if Is_Lower (c) /= 0 then
         Value := @ - 16#20#;
      end if;
      return Value;
   end To_Upper;

   ----------------------------------------------------------------------------
   -- STDIO
   ----------------------------------------------------------------------------

   procedure Ada_Print_Character
      (c : in Bits.C.char)
      is
      procedure Print
         (cc : in Bits.C.char)
         with Import        => True,
              Convention    => Ada,
              External_Name => "console__print__cchar";
   begin
      Print (c);
   end Ada_Print_Character;

   ----------------------------------------------------------------------------
   -- STDLIB
   ----------------------------------------------------------------------------

   procedure Ada_Abort
      is
      procedure System_Abort
         with Import        => True,
              Convention    => Ada,
              External_Name => "abort_library__system_abort_parameterless",
              No_Return     => True;
   begin
      System_Abort;
   end Ada_Abort;

   function Ada_Malloc
      (S : Bits.C.size_t)
      return System.Address
      is
      function Malloc
         (SS : Bits.C.size_t)
         return System.Address
         with Import        => True,
              Convention    => C,
              External_Name => "__gnat_malloc";
   begin
      return Malloc (S);
   end Ada_Malloc;

   procedure Ada_Free
      (A : in System.Address)
      is
      procedure Free
         (AA : in System.Address)
         with Import        => True,
              Convention    => C,
              External_Name => "__gnat_free";
   begin
      Free (A);
   end Ada_Free;

   function Ada_Calloc
      (N : Bits.C.size_t;
       S : Bits.C.size_t)
      return System.Address
      is
      function Calloc
         (NN : Bits.C.size_t;
          SS : Bits.C.size_t)
         return System.Address
         with Import        => True,
              Convention    => Ada,
              External_Name => "malloc__calloc";
   begin
      return Calloc (N, S);
   end Ada_Calloc;

   function Ada_Realloc
      (A : System.Address;
       S : Bits.C.size_t)
      return System.Address
      is
      function Realloc
         (AA : System.Address;
          SS : Bits.C.size_t)
         return System.Address
         with Import        => True,
              Convention    => Ada,
              External_Name => "malloc__realloc";
   begin
      return Realloc (A, S);
   end Ada_Realloc;

end C_Wrappers;

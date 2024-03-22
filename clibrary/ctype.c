
/*
 * ctype.c - CTYPE implementation library.
 *
 * Copyright (C) 2020-2024 Gabriele Galeotti
 *
 * This work is licensed under the terms of the MIT License.
 * Please consult the LICENSE.txt file located in the top-level directory.
 */

#include <ctype.h>

/*
 * ISO 8859-1 and MicrosoftÂ® WindowsÂ® Latin-1 increased characters.
 *
 * _CTYPE_U 0x01 UPPERCASE SYMBOL
 * _CTYPE_L 0x02 LOWERCASE SYMBOL
 * _CTYPE_D 0x04 NUMERIC DIGIT
 * _CTYPE_C 0x08 CONTROL CHARACTER
 * _CTYPE_P 0x10 PUNCTUATION CHARACTER
 * _CTYPE_W 0x20 "C" LOCALE WHITE SPACE CHARACTER (HT/LF/VT/FF/CR/SP)
 * _CTYPE_X 0x40 HEXADECIMAL DIGIT
 * _CTYPE_S 0x80 "HARD" SPACE (0x20)
 */

const unsigned char _CTYPE_character_table[] = {
                                /* DEC  HEX |    |     */
        0,                      /*          |    | EOF */
        _CTYPE_C,               /*   0 0x00 |  ^@| NUL */
        _CTYPE_C,               /*   1 0x01 |  ^A| SOH */
        _CTYPE_C,               /*   2 0x02 |  ^B| STX */
        _CTYPE_C,               /*   3 0x03 |  ^C| ETX */
        _CTYPE_C,               /*   4 0x04 |  ^D| EOT */
        _CTYPE_C,               /*   5 0x05 |  ^E| ENQ */
        _CTYPE_C,               /*   6 0x06 |  ^F| ACK */
        _CTYPE_C,               /*   7 0x07 |  ^G| BEL */
        _CTYPE_C,               /*   8 0x08 |  ^H| BS */
        _CTYPE_C | _CTYPE_W,    /*   9 0x09 |  ^I| HT */
        _CTYPE_C | _CTYPE_W,    /*  10 0x0A |  ^J| LF */
        _CTYPE_C | _CTYPE_W,    /*  11 0x0B |  ^K| VT */
        _CTYPE_C | _CTYPE_W,    /*  12 0x0C |  ^L| FF */
        _CTYPE_C | _CTYPE_W,    /*  13 0x0D |  ^M| CR */
        _CTYPE_C,               /*  14 0x0E |  ^N| SO */
        _CTYPE_C,               /*  15 0x0F |  ^O| SI */
        _CTYPE_C,               /*  16 0x10 |  ^P| DLE */
        _CTYPE_C,               /*  17 0x11 |  ^Q| DC1 */
        _CTYPE_C,               /*  18 0x12 |  ^R| DC2 */
        _CTYPE_C,               /*  19 0x13 |  ^S| DC3 */
        _CTYPE_C,               /*  20 0x14 |  ^T| DC4 */
        _CTYPE_C,               /*  21 0x15 |  ^U| NAK */
        _CTYPE_C,               /*  22 0x16 |  ^V| SYN */
        _CTYPE_C,               /*  23 0x17 |  ^W| ETB */
        _CTYPE_C,               /*  24 0x18 |  ^X| CAN */
        _CTYPE_C,               /*  25 0x19 |  ^Y| EM */
        _CTYPE_C,               /*  26 0x1A |  ^Z| SUB */
        _CTYPE_C,               /*  27 0x1B |  ^[| ESC */
        _CTYPE_C,               /*  28 0x1C |  ^\| FS */
        _CTYPE_C,               /*  29 0x1D |  ^]| GS */
        _CTYPE_C,               /*  30 0x1E |  ^^| RS */
        _CTYPE_C,               /*  31 0x1F |  ^_| US */
        _CTYPE_W | _CTYPE_S,    /*  32 0x20 |    | SP */
        _CTYPE_P,               /*  33 0x21 |   !| */
        _CTYPE_P,               /*  34 0x22 |   "| */
        _CTYPE_P,               /*  35 0x23 |   #| */
        _CTYPE_P,               /*  36 0x24 |   $| */
        _CTYPE_P,               /*  37 0x25 |   %| */
        _CTYPE_P,               /*  38 0x26 |   &| */
        _CTYPE_P,               /*  39 0x27 |   '| */
        _CTYPE_P,               /*  40 0x28 |   (| */
        _CTYPE_P,               /*  41 0x29 |   )| */
        _CTYPE_P,               /*  42 0x2A |   *| */
        _CTYPE_P,               /*  43 0x2B |   +| */
        _CTYPE_P,               /*  44 0x2C |   ,| */
        _CTYPE_P,               /*  45 0x2D |   -| */
        _CTYPE_P,               /*  46 0x2E |   .| */
        _CTYPE_P,               /*  47 0x2F |   /| */
        _CTYPE_D,               /*  48 0x30 |   0| */
        _CTYPE_D,               /*  49 0x31 |   1| */
        _CTYPE_D,               /*  50 0x32 |   2| */
        _CTYPE_D,               /*  51 0x33 |   3| */
        _CTYPE_D,               /*  52 0x34 |   4| */
        _CTYPE_D,               /*  53 0x35 |   5| */
        _CTYPE_D,               /*  54 0x36 |   6| */
        _CTYPE_D,               /*  55 0x37 |   7| */
        _CTYPE_D,               /*  56 0x38 |   8| */
        _CTYPE_D,               /*  57 0x39 |   9| */
        _CTYPE_P,               /*  58 0x3A |   :| */
        _CTYPE_P,               /*  59 0x3B |   ;| */
        _CTYPE_P,               /*  60 0x3C |   <| */
        _CTYPE_P,               /*  61 0x3D |   =| */
        _CTYPE_P,               /*  62 0x3E |   >| */
        _CTYPE_P,               /*  63 0x3F |   ?| */
        _CTYPE_P,               /*  64 0x40 |   @| */
        _CTYPE_U | _CTYPE_X,    /*  65 0x41 |   A| */
        _CTYPE_U | _CTYPE_X,    /*  66 0x42 |   B| */
        _CTYPE_U | _CTYPE_X,    /*  67 0x43 |   C| */
        _CTYPE_U | _CTYPE_X,    /*  68 0x44 |   D| */
        _CTYPE_U | _CTYPE_X,    /*  69 0x45 |   E| */
        _CTYPE_U | _CTYPE_X,    /*  70 0x46 |   F| */
        _CTYPE_U,               /*  71 0x47 |   G| */
        _CTYPE_U,               /*  72 0x48 |   H| */
        _CTYPE_U,               /*  73 0x49 |   I| */
        _CTYPE_U,               /*  74 0x4A |   J| */
        _CTYPE_U,               /*  75 0x4B |   K| */
        _CTYPE_U,               /*  76 0x4C |   L| */
        _CTYPE_U,               /*  77 0x4D |   M| */
        _CTYPE_U,               /*  78 0x4E |   N| */
        _CTYPE_U,               /*  79 0x4F |   O| */
        _CTYPE_U,               /*  80 0x50 |   P| */
        _CTYPE_U,               /*  81 0x51 |   Q| */
        _CTYPE_U,               /*  82 0x52 |   R| */
        _CTYPE_U,               /*  83 0x53 |   S| */
        _CTYPE_U,               /*  84 0x54 |   T| */
        _CTYPE_U,               /*  85 0x55 |   U| */
        _CTYPE_U,               /*  86 0x56 |   V| */
        _CTYPE_U,               /*  87 0x57 |   W| */
        _CTYPE_U,               /*  88 0x58 |   X| */
        _CTYPE_U,               /*  89 0x59 |   Y| */
        _CTYPE_U,               /*  90 0x5A |   Z| */
        _CTYPE_P,               /*  91 0x5B |   [| */
        _CTYPE_P,               /*  92 0x5C |   \| */
        _CTYPE_P,               /*  93 0x5D |   ]| */
        _CTYPE_P,               /*  94 0x5E |   ^| */
        _CTYPE_P,               /*  95 0x5F |   _| */
        _CTYPE_P,               /*  96 0x60 |   `| */
        _CTYPE_L | _CTYPE_X,    /*  97 0x61 |   a| */
        _CTYPE_L | _CTYPE_X,    /*  98 0x62 |   b| */
        _CTYPE_L | _CTYPE_X,    /*  99 0x63 |   c| */
        _CTYPE_L | _CTYPE_X,    /* 100 0x64 |   d| */
        _CTYPE_L | _CTYPE_X,    /* 101 0x65 |   e| */
        _CTYPE_L | _CTYPE_X,    /* 102 0x66 |   f| */
        _CTYPE_L,               /* 103 0x67 |   g| */
        _CTYPE_L,               /* 104 0x68 |   h| */
        _CTYPE_L,               /* 105 0x69 |   i| */
        _CTYPE_L,               /* 106 0x6A |   j| */
        _CTYPE_L,               /* 107 0x6B |   k| */
        _CTYPE_L,               /* 108 0x6C |   l| */
        _CTYPE_L,               /* 109 0x6D |   m| */
        _CTYPE_L,               /* 110 0x6E |   n| */
        _CTYPE_L,               /* 111 0x6F |   o| */
        _CTYPE_L,               /* 112 0x70 |   p| */
        _CTYPE_L,               /* 113 0x71 |   q| */
        _CTYPE_L,               /* 114 0x72 |   r| */
        _CTYPE_L,               /* 115 0x73 |   s| */
        _CTYPE_L,               /* 116 0x74 |   t| */
        _CTYPE_L,               /* 117 0x75 |   u| */
        _CTYPE_L,               /* 118 0x76 |   v| */
        _CTYPE_L,               /* 119 0x77 |   w| */
        _CTYPE_L,               /* 120 0x78 |   x| */
        _CTYPE_L,               /* 121 0x79 |   y| */
        _CTYPE_L,               /* 122 0x7A |   z| */
        _CTYPE_P,               /* 123 0x7B |   {| */
        _CTYPE_P,               /* 124 0x7C |   || */
        _CTYPE_P,               /* 125 0x7D |   }| */
        _CTYPE_P,               /* 126 0x7E |   ~| */
        _CTYPE_C,               /* 127 0x7F |    | DEL */
        0,                      /* 128 0x80 |^M-@| */
        0,                      /* 129 0x81 |^M-A| */
        0,                      /* 130 0x82 |^M-B| */
        0,                      /* 131 0x83 |^M-C| */
        0,                      /* 132 0x84 |^M-D| */
        0,                      /* 133 0x85 |^M-E| */
        0,                      /* 134 0x86 |^M-F| */
        0,                      /* 135 0x87 |^M-G| */
        0,                      /* 136 0x88 |^M-H| */
        0,                      /* 137 0x89 |^M-I| */
        0,                      /* 138 0x8A |^M-J| */
        0,                      /* 139 0x8B |^M-K| */
        0,                      /* 140 0x8C |^M-L| */
        0,                      /* 141 0x8D |^M-M| */
        0,                      /* 142 0x8E |^M-N| */
        0,                      /* 143 0x8F |^M-O| */
        0,                      /* 144 0x90 |^M-P| */
        0,                      /* 145 0x91 |^M-Q| */
        0,                      /* 146 0x92 |^M-R| */
        0,                      /* 147 0x93 |^M-S| */
        0,                      /* 148 0x94 |^M-T| */
        0,                      /* 149 0x95 |^M-U| */
        0,                      /* 150 0x96 |^M-V| */
        0,                      /* 151 0x97 |^M-W| */
        0,                      /* 152 0x98 |^M-X| */
        0,                      /* 153 0x99 |^M-Y| */
        0,                      /* 154 0x9A |^M-Z| */
        0,                      /* 155 0x9B |^M-[| */
        0,                      /* 156 0x9C |^M-\| */
        0,                      /* 157 0x9D |^M-]| */
        0,                      /* 158 0x9E |^M-^| */
        0,                      /* 159 0x9F |^M-_| */
        _CTYPE_W | _CTYPE_S,    /* 160 0xA0 | M- | NON-BREAKING SPACE */
        _CTYPE_P,               /* 161 0xA1 | M-!| ¡ */
        _CTYPE_P,               /* 162 0xA2 | M-"| ¢ */
        _CTYPE_P,               /* 163 0xA3 | M-#| £ */
        _CTYPE_P,               /* 164 0xA4 | M-$| ¤ */
        _CTYPE_P,               /* 165 0xA5 | M-%| ¥ */
        _CTYPE_P,               /* 166 0xA6 | M-&| ¦ */
        _CTYPE_P,               /* 167 0xA7 | M-'| § */
        _CTYPE_P,               /* 168 0xA8 | M-(| ¨ */
        _CTYPE_P,               /* 169 0xA9 | M-)| © */
        _CTYPE_P,               /* 170 0xAA | M-*| ª */
        _CTYPE_P,               /* 171 0xAB | M-+| « */
        _CTYPE_P,               /* 172 0xAC | M-,| ¬ */
        _CTYPE_P,               /* 173 0xAD | M--| SOFT HYPHEN */
        _CTYPE_P,               /* 174 0xAE | M-.| ® */
        _CTYPE_P,               /* 175 0xAF | M-/| ¯ */
        _CTYPE_P,               /* 176 0xB0 | M-0| ° */
        _CTYPE_P,               /* 177 0xB1 | M-1| ± */
        _CTYPE_P,               /* 178 0xB2 | M-2| ² */
        _CTYPE_P,               /* 179 0xB3 | M-3| ³ */
        _CTYPE_P,               /* 180 0xB4 | M-4| ´ */
        _CTYPE_P,               /* 181 0xB5 | M-5| µ */
        _CTYPE_P,               /* 182 0xB6 | M-6| ¶ */
        _CTYPE_P,               /* 183 0xB7 | M-7| · */
        _CTYPE_P,               /* 184 0xB8 | M-8| ¸ */
        _CTYPE_P,               /* 185 0xB9 | M-9| ¹ */
        _CTYPE_P,               /* 186 0xBA | M-:| º */
        _CTYPE_P,               /* 187 0xBB | M-;| » */
        _CTYPE_P,               /* 188 0xBC | M-<| ¼ */
        _CTYPE_P,               /* 189 0xBD | M-=| ½ */
        _CTYPE_P,               /* 190 0xBE | M->| ¾ */
        _CTYPE_P,               /* 191 0xBF | M-?| ¿ */
        _CTYPE_U,               /* 192 0xC0 | M-@| À */
        _CTYPE_U,               /* 193 0xC1 | M-A| Á */
        _CTYPE_U,               /* 194 0xC2 | M-B| Â */
        _CTYPE_U,               /* 195 0xC3 | M-C| Ã */
        _CTYPE_U,               /* 196 0xC4 | M-D| Ä */
        _CTYPE_U,               /* 197 0xC5 | M-E| Å */
        _CTYPE_U,               /* 198 0xC6 | M-F| Æ */
        _CTYPE_U,               /* 199 0xC7 | M-G| Ç */
        _CTYPE_U,               /* 200 0xC8 | M-H| È */
        _CTYPE_U,               /* 201 0xC9 | M-I| É */
        _CTYPE_U,               /* 202 0xCA | M-J| Ê */
        _CTYPE_U,               /* 203 0xCB | M-K| Ë */
        _CTYPE_U,               /* 204 0xCC | M-L| Ì */
        _CTYPE_U,               /* 205 0xCD | M-M| Í */
        _CTYPE_U,               /* 206 0xCE | M-N| Î */
        _CTYPE_U,               /* 207 0xCF | M-O| Ï */
        _CTYPE_U,               /* 208 0xD0 | M-P| Ð */
        _CTYPE_U,               /* 209 0xD1 | M-Q| Ñ */
        _CTYPE_U,               /* 210 0xD2 | M-R| Ò */
        _CTYPE_U,               /* 211 0xD3 | M-S| Ó */
        _CTYPE_U,               /* 212 0xD4 | M-T| Ô */
        _CTYPE_U,               /* 213 0xD5 | M-U| Õ */
        _CTYPE_U,               /* 214 0xD6 | M-V| Ö */
        _CTYPE_P,               /* 215 0xD7 | M-W| × MULTIPLICATION SIGN */
        _CTYPE_U,               /* 216 0xD8 | M-X| Ø */
        _CTYPE_U,               /* 217 0xD9 | M-Y| Ù */
        _CTYPE_U,               /* 218 0xDA | M-Z| Ú */
        _CTYPE_U,               /* 219 0xDB | M-[| Û */
        _CTYPE_U,               /* 220 0xDC | M-\| Ü */
        _CTYPE_U,               /* 221 0xDD | M-]| Ý */
        _CTYPE_U,               /* 222 0xDE | M-^| Þ */
        _CTYPE_L,               /* 223 0xDF | M-_| ß */
        _CTYPE_L,               /* 224 0xE0 | M-`| à */
        _CTYPE_L,               /* 225 0xE1 | M-a| á */
        _CTYPE_L,               /* 226 0xE2 | M-b| â */
        _CTYPE_L,               /* 227 0xE3 | M-c| ã */
        _CTYPE_L,               /* 228 0xE4 | M-d| ä */
        _CTYPE_L,               /* 229 0xE5 | M-e| å */
        _CTYPE_L,               /* 230 0xE6 | M-f| æ */
        _CTYPE_L,               /* 231 0xE7 | M-g| ç */
        _CTYPE_L,               /* 232 0xE8 | M-h| è */
        _CTYPE_L,               /* 233 0xE9 | M-i| é */
        _CTYPE_L,               /* 234 0xEA | M-j| ê */
        _CTYPE_L,               /* 235 0xEB | M-k| ë */
        _CTYPE_L,               /* 236 0xEC | M-l| ì */
        _CTYPE_L,               /* 237 0xED | M-m| í */
        _CTYPE_L,               /* 238 0xEE | M-n| î */
        _CTYPE_L,               /* 239 0xEF | M-o| ï */
        _CTYPE_L,               /* 240 0xF0 | M-p| ð */
        _CTYPE_L,               /* 241 0xF1 | M-q| ñ */
        _CTYPE_L,               /* 242 0xF2 | M-r| ò */
        _CTYPE_L,               /* 243 0xF3 | M-s| ó */
        _CTYPE_L,               /* 244 0xF4 | M-t| ô */
        _CTYPE_L,               /* 245 0xF5 | M-u| õ */
        _CTYPE_L,               /* 246 0xF6 | M-v| ö */
        _CTYPE_P,               /* 247 0xF7 | M-w| ÷ DIVISION SIGN */
        _CTYPE_L,               /* 248 0xF8 | M-x| ø */
        _CTYPE_L,               /* 249 0xF9 | M-y| ù */
        _CTYPE_L,               /* 250 0xFA | M-z| ú */
        _CTYPE_L,               /* 251 0xFB | M-{| û */
        _CTYPE_L,               /* 252 0xFC | M-|| ü */
        _CTYPE_L,               /* 253 0xFD | M-}| ý */
        _CTYPE_L,               /* 254 0xFE | M-~| þ */
        _CTYPE_L                /* 255 0xFF |    | ÿ */
        };

/*
 * Function names are parenthesized to protect them against macro expansion.
 */

int
(isalnum)(int c)
{
        return ((_CTYPE_character_table + 1)[(int)(unsigned char)c] & (_CTYPE_U | _CTYPE_L | _CTYPE_D)) != 0;
}

int
(isalpha)(int c)
{
        return ((_CTYPE_character_table + 1)[(int)(unsigned char)c] & (_CTYPE_U | _CTYPE_L)) != 0;
}

int
(iscntrl)(int c)
{
        return ((_CTYPE_character_table + 1)[(int)(unsigned char)c] & _CTYPE_C) != 0;
}

int
(isdigit)(int c)
{
        return ((_CTYPE_character_table + 1)[(int)(unsigned char)c] & _CTYPE_D) != 0;
}

int
(isgraph)(int c)
{
        return ((_CTYPE_character_table + 1)[(int)(unsigned char)c] & (_CTYPE_P | _CTYPE_U | _CTYPE_L | _CTYPE_D)) != 0;
}

int
(islower)(int c)
{
        return ((_CTYPE_character_table + 1)[(int)(unsigned char)c] & _CTYPE_L) != 0;
}

int
(isprint)(int c)
{
        return ((_CTYPE_character_table + 1)[(int)(unsigned char)c] & (_CTYPE_P | _CTYPE_U | _CTYPE_L | _CTYPE_D | _CTYPE_S)) != 0;
}

int
(ispunct)(int c)
{
        return ((_CTYPE_character_table + 1)[(int)(unsigned char)c] & _CTYPE_P) != 0;
}

int
(isspace)(int c)
{
        return ((_CTYPE_character_table + 1)[(int)(unsigned char)c] & _CTYPE_W) != 0;
}

int
(isupper)(int c)
{
        return ((_CTYPE_character_table + 1)[(int)(unsigned char)c] & _CTYPE_U) != 0;
}

int
(isxdigit)(int c)
{
        return ((_CTYPE_character_table + 1)[(int)(unsigned char)c] & (_CTYPE_D | _CTYPE_X)) != 0;
}

int
(isascii)(int c)
{
        return (unsigned char)c <= _CTYPE_ASCII_MASK;
}

int
(toascii)(int c)
{
        return (unsigned char)c & _CTYPE_ASCII_MASK;
}

int
(tolower)(int c)
{
        return isupper(c) != 0 ? c + _CTYPE_ASCII_U2L : c;
}

int
(toupper)(int c)
{
        return islower(c) != 0 ? c - _CTYPE_ASCII_U2L : c;
}


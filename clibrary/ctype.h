
/*
 * ctype.h - CTYPE library header.
 *
 * Copyright (C) 2020-2025 Gabriele Galeotti
 *
 * This work is licensed under the terms of the MIT License.
 * Please consult the LICENSE.txt file located in the top-level directory.
 */

/* __REF__ http://pubs.opengroup.org/onlinepubs/9699919799/basedefs/ctype.h.html */

#ifndef _CTYPE_H
#define _CTYPE_H 1

#ifdef __cplusplus
extern "C" {
#endif

#define _CTYPE_ASCII_MASK 0x7F
#define _CTYPE_ASCII_U2L  ('a' - 'A')

#define _CTYPE_U 0x01 /* UPPERCASE SYMBOL                                     */
#define _CTYPE_L 0x02 /* LOWERCASE SYMBOL                                     */
#define _CTYPE_D 0x04 /* NUMERIC DIGIT                                        */
#define _CTYPE_S 0x08 /* "HARD" SPACE (0x20)                                  */
#define _CTYPE_P 0x10 /* PUNCTUATION CHARACTER                                */
#define _CTYPE_C 0x20 /* CONTROL CHARACTER                                    */
#define _CTYPE_B 0x40 /* "C" LOCALE WHITE SPACE CHARACTER (HT/LF/VT/FF/CR/SP) */
#define _CTYPE_X 0x80 /* HEXADECIMAL DIGIT                                    */

extern const unsigned char _CTYPE_character_table[];

extern int isalnum(int);
extern int isalpha(int);
extern int iscntrl(int);
extern int isdigit(int);
extern int isgraph(int);
extern int islower(int);
extern int isprint(int);
extern int ispunct(int);
extern int isspace(int);
extern int isupper(int);
extern int isxdigit(int);
extern int isascii(int);
extern int toascii(int);
extern int tolower(int);
extern int toupper(int);

#define isalnum(c)  ((_CTYPE_character_table + 1)[(int)(unsigned char)(c)] & (_CTYPE_U | _CTYPE_L | _CTYPE_D))
#define isalpha(c)  ((_CTYPE_character_table + 1)[(int)(unsigned char)(c)] & (_CTYPE_U | _CTYPE_L))
#define iscntrl(c)  ((_CTYPE_character_table + 1)[(int)(unsigned char)(c)] & _CTYPE_C)
#define isdigit(c)  ((_CTYPE_character_table + 1)[(int)(unsigned char)(c)] & _CTYPE_D)
#define isgraph(c)  ((_CTYPE_character_table + 1)[(int)(unsigned char)(c)] & (_CTYPE_P | _CTYPE_U | _CTYPE_L | _CTYPE_D))
#define islower(c)  ((_CTYPE_character_table + 1)[(int)(unsigned char)(c)] & _CTYPE_L)
#define isprint(c)  ((_CTYPE_character_table + 1)[(int)(unsigned char)(c)] & (_CTYPE_P | _CTYPE_U | _CTYPE_L | _CTYPE_D | _CTYPE_S))
#define ispunct(c)  ((_CTYPE_character_table + 1)[(int)(unsigned char)(c)] & _CTYPE_P)
#define isspace(c)  ((_CTYPE_character_table + 1)[(int)(unsigned char)(c)] & _CTYPE_B)
#define isupper(c)  ((_CTYPE_character_table + 1)[(int)(unsigned char)(c)] & _CTYPE_U)
#define isxdigit(c) ((_CTYPE_character_table + 1)[(int)(unsigned char)(c)] & (_CTYPE_D | _CTYPE_X))
#define isascii(c)  ((int)((unsigned char)(c) <= _CTYPE_ASCII_MASK))
#define toascii(c)  ((int)((unsigned char)(c) & _CTYPE_ASCII_MASK))
#define tolower(c)  (isupper(c) != 0 ? (c) + _CTYPE_ASCII_U2L : (c))
#define toupper(c)  (islower(c) != 0 ? (c) - _CTYPE_ASCII_U2L : (c))

#ifdef __cplusplus
}
#endif

#endif /* _CTYPE_H */


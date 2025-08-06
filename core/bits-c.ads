-----------------------------------------------------------------------------------------------------------------------
--                                                     SweetAda                                                      --
-----------------------------------------------------------------------------------------------------------------------
-- __HDS__                                                                                                           --
-- __FLN__ bits-c.ads                                                                                                --
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

package Bits.C
   with Pure       => True,
        SPARK_Mode => On
   is

   --========================================================================--
   --                                                                        --
   --                                                                        --
   --                               Public part                              --
   --                                                                        --
   --                                                                        --
   --========================================================================--

   type int is new Integer;

   -- Bytesize is defined the same as Interfaces.C.size_t.
   subtype size_t is Bytesize;

   -- Declarations based on C's <limits.h>.
   CHAR_BIT  : constant := 8;
   SCHAR_MIN : constant := -128;
   SCHAR_MAX : constant := 127;
   UCHAR_MAX : constant := 255;

   type unsigned_char is mod (UCHAR_MAX + 1)
      with Size => CHAR_BIT;

   type signed_char is range SCHAR_MIN .. SCHAR_MAX
      with Size => CHAR_BIT;

   type char is new Character;

   nul : constant char := char'First;

   type char_array is array (size_t range <>) of aliased char
      with Component_Size => CHAR_BIT;

end Bits.C;

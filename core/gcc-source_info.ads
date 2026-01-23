-----------------------------------------------------------------------------------------------------------------------
--                                                     SweetAda                                                      --
-----------------------------------------------------------------------------------------------------------------------
-- __HDS__                                                                                                           --
-- __FLN__ gcc-source_info.ads                                                                                       --
-- __DSC__                                                                                                           --
-- __HSH__ e69de29bb2d1d6434b8b29ae775ad8c2e48c5391                                                                  --
-- __HDE__                                                                                                           --
-----------------------------------------------------------------------------------------------------------------------
-- Copyright (C) 2020-2026 Gabriele Galeotti                                                                         --
--                                                                                                                   --
-- SweetAda web page: http://sweetada.org                                                                            --
-- contact address: gabriele.galeotti@sweetada.org                                                                   --
-- This work is licensed under the terms of the MIT License.                                                         --
-- Please consult the LICENSE.txt file located in the top-level directory.                                           --
-----------------------------------------------------------------------------------------------------------------------

package GCC.Source_Info
   with Preelaborate => True,
        SPARK_Mode   => On
   is

   ----------------------------------------------------------------------------
   -- Return the basename of the current input source file.
   ----------------------------------------------------------------------------
   function File
      return String
      with Volatile_Function => True,
           Import            => True,
           Convention        => Intrinsic;

   ----------------------------------------------------------------------------
   -- Return the current line number of the current input source file.
   ----------------------------------------------------------------------------
   function Line
      return Positive
      with Volatile_Function => True,
           Import            => True,
           Convention        => Intrinsic;

   ----------------------------------------------------------------------------
   -- Return the concatenation "<file>:<line>", where <file> is the basename
   -- of the current input source file and <line> is the current line number.
   ----------------------------------------------------------------------------
   function Source_Location
      return String
      with Volatile_Function => True,
           Import            => True,
           Convention        => Intrinsic;

end GCC.Source_Info;

-----------------------------------------------------------------------------------------------------------------------
--                                                     SweetAda                                                      --
-----------------------------------------------------------------------------------------------------------------------
-- __HDS__                                                                                                           --
-- __FLN__ tca9555.adb                                                                                               --
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

with Ada.Unchecked_Conversion;

package body TCA9555
   is

   --========================================================================--
   --                                                                        --
   --                                                                        --
   --                           Package subprograms                          --
   --                                                                        --
   --                                                                        --
   --========================================================================--

pragma Style_Checks (Off);

   function To_INPUTPORT  (Value : Unsigned_8)      return INPUTPORT_Type
      is function Convert is new Ada.Unchecked_Conversion (Unsigned_8, INPUTPORT_Type);  begin return Convert (Value); end To_INPUTPORT;

   function To_U8         (Value : OUTPUTPORT_Type) return Unsigned_8
      is function Convert is new Ada.Unchecked_Conversion (OUTPUTPORT_Type, Unsigned_8); begin return Convert (Value); end To_U8;
   function To_OUTPUTPORT (Value : Unsigned_8)              return OUTPUTPORT_Type
      is function Convert is new Ada.Unchecked_Conversion (Unsigned_8, OUTPUTPORT_Type); begin return Convert (Value); end To_OUTPUTPORT;

   function To_U8         (Value : POLINVPORT_Type) return Unsigned_8
      is function Convert is new Ada.Unchecked_Conversion (POLINVPORT_Type, Unsigned_8); begin return Convert (Value); end To_U8;
   function To_POLINVPORT (Value : Unsigned_8)      return POLINVPORT_Type
      is function Convert is new Ada.Unchecked_Conversion (Unsigned_8, POLINVPORT_Type); begin return Convert (Value); end To_POLINVPORT;

   function To_U8         (Value : CONFIGPORT_Type) return Unsigned_8
      is function Convert is new Ada.Unchecked_Conversion (CONFIGPORT_Type, Unsigned_8); begin return Convert (Value); end To_U8;
   function To_CONFIGPORT (Value : Unsigned_8)      return CONFIGPORT_Type
      is function Convert is new Ada.Unchecked_Conversion (Unsigned_8, CONFIGPORT_Type); begin return Convert (Value); end To_CONFIGPORT;

pragma Style_Checks (On);

end TCA9555;

-----------------------------------------------------------------------------------------------------------------------
--                                                     SweetAda                                                      --
-----------------------------------------------------------------------------------------------------------------------
-- __HDS__                                                                                                           --
-- __FLN__ mvme162fx.ads                                                                                             --
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

with System.Storage_Elements;
with Interfaces;

package MVME162FX is

   --========================================================================--
   --                                                                        --
   --                                                                        --
   --                               Public part                              --
   --                                                                        --
   --                                                                        --
   --========================================================================--

   use System.Storage_Elements;
   use Interfaces;

   ----------------------------------------------------------------------------
   -- VMEchip2
   ----------------------------------------------------------------------------

   -- 2.22 LCSR Programming Model

   LCSR_ADDRESS : constant := 16#FFF4_0060#;

   LCSR : aliased Unsigned_32 with
      Address    => To_Address (LCSR_ADDRESS),
      Volatile   => True,
      Import     => True,
      Convention => Ada;

   -- 3.44 RESET Switch Control Register

   RESET_SCR_ADDRESS : constant := 16#FFF4_2044#;

   RESET_SCR : aliased Unsigned_8 with
      Address    => To_Address (RESET_SCR_ADDRESS),
      Volatile   => True,
      Import     => True,
      Convention => Ada;

   ----------------------------------------------------------------------------
   -- 3.9 MC2 chip
   ----------------------------------------------------------------------------

   MC2_BASEADDRESS : constant := 16#FFF4_2000#;
   SCC_BASEADDRESS : constant := MC2_BASEADDRESS + 16#0000_3001#;

   type MC2_Type is
   record
      ID              : Unsigned_8;
      Revision        : Unsigned_8;
      General_Control : Unsigned_8;
      Vector_Base     : Unsigned_8;
   end record with
      Size => 32;
   for MC2_Type use
   record
      ID              at 0 range 0 .. 7;
      Revision        at 1 range 0 .. 7;
      General_Control at 2 range 0 .. 7;
      Vector_Base     at 3 range 0 .. 7;
   end record;

   MC2 : aliased MC2_Type with
      Address    => To_Address (MC2_BASEADDRESS),
      Volatile   => True,
      Import     => True,
      Convention => Ada;

end MVME162FX;

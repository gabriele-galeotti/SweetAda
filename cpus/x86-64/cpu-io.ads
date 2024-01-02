-----------------------------------------------------------------------------------------------------------------------
--                                                     SweetAda                                                      --
-----------------------------------------------------------------------------------------------------------------------
-- __HDS__                                                                                                           --
-- __FLN__ cpu-io.ads                                                                                                --
-- __DSC__                                                                                                           --
-- __HSH__ e69de29bb2d1d6434b8b29ae775ad8c2e48c5391                                                                  --
-- __HDE__                                                                                                           --
-----------------------------------------------------------------------------------------------------------------------
-- Copyright (C) 2020-2024 Gabriele Galeotti                                                                         --
--                                                                                                                   --
-- SweetAda web page: http://sweetada.org                                                                            --
-- contact address: gabriele.galeotti@sweetada.org                                                                   --
-- This work is licensed under the terms of the MIT License.                                                         --
-- Please consult the LICENSE.txt file located in the top-level directory.                                           --
-----------------------------------------------------------------------------------------------------------------------

with System;
with Interfaces;

package CPU.IO
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

   ----------------------------------------------------------------------------
   -- PortIn/PortOut
   ----------------------------------------------------------------------------

   function PortIn
      (Port : Unsigned_16)
      return Unsigned_8
      with Inline => True;
   function PortIn
      (Port : Unsigned_16)
      return Unsigned_16
      with Inline => True;
   function PortIn
      (Port : Unsigned_16)
      return Unsigned_32
      with Inline => True;
   procedure PortOut
      (Port  : in Unsigned_16;
       Value : in Unsigned_8)
      with Inline => True;
   procedure PortOut
      (Port  : in Unsigned_16;
       Value : in Unsigned_16)
      with Inline => True;
   procedure PortOut
      (Port  : in Unsigned_16;
       Value : in Unsigned_32)
      with Inline => True;

   ----------------------------------------------------------------------------
   -- I/O operations referenced by address
   ----------------------------------------------------------------------------

   function IO_Read
      (Port_Address : Address)
      return Unsigned_8
      with Inline => True;
   function IO_Read
      (Port_Address : Address)
      return Unsigned_16
      with Inline => True;
   function IO_Read
      (Port_Address : Address)
      return Unsigned_32
      with Inline => True;
   procedure IO_Write
      (Port_Address : in Address;
       Value        : in Unsigned_8)
      with Inline => True;
   procedure IO_Write
      (Port_Address : in Address;
       Value        : in Unsigned_16)
      with Inline => True;
   procedure IO_Write
      (Port_Address : in Address;
       Value        : in Unsigned_32)
      with Inline => True;

end CPU.IO;

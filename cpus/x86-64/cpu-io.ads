-----------------------------------------------------------------------------------------------------------------------
--                                                     SweetAda                                                      --
-----------------------------------------------------------------------------------------------------------------------
-- __HDS__                                                                                                           --
-- __FLN__ cpu-io.ads                                                                                                --
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

pragma Restrictions (No_Elaboration_Code);

with System;
with Interfaces;

package CPU.IO
is

   --========================================================================--
   --                                                                        --
   --                                                                        --
   --                               Public part                              --
   --                                                                        --
   --                                                                        --
   --========================================================================--

   ----------------------------------------------------------------------------
   -- PortIn/PortOut
   ----------------------------------------------------------------------------

   function PortIn
      (Port : Interfaces.Unsigned_16)
      return Interfaces.Unsigned_8
      with Inline => True;
   function PortIn
      (Port : Interfaces.Unsigned_16)
      return Interfaces.Unsigned_16
      with Inline => True;
   function PortIn
      (Port : Interfaces.Unsigned_16)
      return Interfaces.Unsigned_32
      with Inline => True;
   procedure PortOut
      (Port  : in Interfaces.Unsigned_16;
       Value : in Interfaces.Unsigned_8)
      with Inline => True;
   procedure PortOut
      (Port  : in Interfaces.Unsigned_16;
       Value : in Interfaces.Unsigned_16)
      with Inline => True;
   procedure PortOut
      (Port  : in Interfaces.Unsigned_16;
       Value : in Interfaces.Unsigned_32)
      with Inline => True;

   ----------------------------------------------------------------------------
   -- I/O operations referenced by address
   ----------------------------------------------------------------------------

   function Read
      (Port_Address : System.Address)
      return Interfaces.Unsigned_8
      with Inline => True;
   function Read
      (Port_Address : System.Address)
      return Interfaces.Unsigned_16
      with Inline => True;
   function Read
      (Port_Address : System.Address)
      return Interfaces.Unsigned_32
      with Inline => True;
   procedure Write
      (Port_Address : in System.Address;
       Value        : in Interfaces.Unsigned_8)
      with Inline => True;
   procedure Write
      (Port_Address : in System.Address;
       Value        : in Interfaces.Unsigned_16)
      with Inline => True;
   procedure Write
      (Port_Address : in System.Address;
       Value        : in Interfaces.Unsigned_32)
      with Inline => True;

end CPU.IO;

-----------------------------------------------------------------------------------------------------------------------
--                                                     SweetAda                                                      --
-----------------------------------------------------------------------------------------------------------------------
-- __HDS__                                                                                                           --
-- __FLN__ cpu-io.ads                                                                                                --
-- __DSC__                                                                                                           --
-- __HSH__ e69de29bb2d1d6434b8b29ae775ad8c2e48c5391                                                                  --
-- __HDE__                                                                                                           --
-----------------------------------------------------------------------------------------------------------------------
-- Copyright (C) 2020, 2021, 2022 Gabriele Galeotti                                                                  --
--                                                                                                                   --
-- SweetAda web page: http://sweetada.org                                                                            --
-- contact address: gabriele.galeotti@sweetada.org                                                                   --
-- This work is licensed under the terms of the MIT License.                                                         --
-- Please consult the LICENSE.txt file located in the top-level directory.                                           --
-----------------------------------------------------------------------------------------------------------------------

with System;
with Interfaces;

package CPU.IO is

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

   function PortIn (Port : Unsigned_16) return Unsigned_8;
   function PortIn (Port : Unsigned_16) return Unsigned_16;
   function PortIn (Port : Unsigned_16) return Unsigned_32;
   procedure PortOut (Port : in Unsigned_16; Value : in Unsigned_8);
   procedure PortOut (Port : in Unsigned_16; Value : in Unsigned_16);
   procedure PortOut (Port : in Unsigned_16; Value : in Unsigned_32);

   ----------------------------------------------------------------------------
   -- I/O operations referenced with addresses
   ----------------------------------------------------------------------------

   function IO_Read (Port_Address : Address) return Unsigned_8;
   function IO_Read (Port_Address : Address) return Unsigned_16;
   function IO_Read (Port_Address : Address) return Unsigned_32;
   procedure IO_Write (Port_Address : in Address; Value : in Unsigned_8);
   procedure IO_Write (Port_Address : in Address; Value : in Unsigned_16);
   procedure IO_Write (Port_Address : in Address; Value : in Unsigned_32);

private

   --========================================================================--
   --                                                                        --
   --                                                                        --
   --                              Private part                              --
   --                                                                        --
   --                                                                        --
   --========================================================================--

   pragma Inline (PortIn);
   pragma Inline (PortOut);
   pragma Inline (IO_Read);
   pragma Inline (IO_Write);

end CPU.IO;

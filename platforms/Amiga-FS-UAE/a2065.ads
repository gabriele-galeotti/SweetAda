-----------------------------------------------------------------------------------------------------------------------
--                                                     SweetAda                                                      --
-----------------------------------------------------------------------------------------------------------------------
-- __HDS__                                                                                                           --
-- __FLN__ a2065.ads                                                                                                 --
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

with System;
with Interfaces;
with Bits;
with ZorroII;
with Am7990;
with Ethernet;
with PBUF;

package A2065 is

   --========================================================================--
   --                                                                        --
   --                                                                        --
   --                               Public part                              --
   --                                                                        --
   --                                                                        --
   --========================================================================--

   use System;
   use Interfaces;
   use Bits;

   A2065_MAC : Ethernet.MAC_Address_Type;

   Am7990_Descriptor             : aliased Am7990.Descriptor_Type := Am7990.DESCRIPTOR_INVALID;
   Am7990_Descriptor_Initialized : Boolean := False;

   ----------------------------------------------------------------------------
   -- A2065 Zorro II Ethernet Card
   ----------------------------------------------------------------------------

   A2065_BASEADDRESS : constant := 16#00EA_0000#;
   A2065_CHIP_OFFSET : constant := 16#0000_4000#;
   A2065_RAM_OFFSET  : constant := 16#0000_8000#;
   A2065_RAM_SIZE    : constant := 16#0000_8000#;

   ----------------------------------------------------------------------------
   -- subprograms
   ----------------------------------------------------------------------------

   procedure Probe (PIC : in ZorroII.PIC_Type; Success : out Boolean);
   procedure Init;
   function Receive return Boolean;
   procedure Transmit (Data_Address : in System.Address; P : in PBUF.Pbuf_Ptr);

end A2065;

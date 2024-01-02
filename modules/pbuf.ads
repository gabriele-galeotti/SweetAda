-----------------------------------------------------------------------------------------------------------------------
--                                                     SweetAda                                                      --
-----------------------------------------------------------------------------------------------------------------------
-- __HDS__                                                                                                           --
-- __FLN__ pbuf.ads                                                                                                  --
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
with Bits;

package PBUF
   is

   --========================================================================--
   --                                                                        --
   --                                                                        --
   --                               Public part                              --
   --                                                                        --
   --                                                                        --
   --========================================================================--

   PBUF_NUMS         : constant := 128;
   PBUF_PAYLOAD_SIZE : constant := 256;

   type Pbuf_Type;
   type Pbuf_Ptr is access all Pbuf_Type;

   type Pbuf_Type is record
      Payload         : Bits.Byte_A2Array (0 .. PBUF_PAYLOAD_SIZE - 1);
      Index           : Natural;
      Next            : Pbuf_Ptr;
      Size            : Natural;                                        -- u16_t len
      Total_Size      : Natural;                                        -- u16_t tot_len
      Offset          : Natural range 0 .. PBUF_PAYLOAD_SIZE - 1;
      Offset_Previous : Natural range 0 .. PBUF_PAYLOAD_SIZE - 1;
      Nref            : Natural;
   end record
      with Volatile                => True,
           Suppress_Initialization => True; -- pragma Restrictions (No_Implicit_Loops)

   procedure Init;
   function Allocate
      (Size : Natural)
      return Pbuf_Ptr;
   procedure Free
      (Item : in Pbuf_Ptr);
   procedure Payload_Adjust
      (P      : in Pbuf_Ptr;
       Adjust : in Integer);
   procedure Payload_Rewind
      (P : in Pbuf_Ptr);
   function Payload_Address
      (P      : Pbuf_Ptr;
       Offset : Natural := 0)
      return System.Address
      with Inline => True;
   function Payload_CurrentAddress
      (P : Pbuf_Ptr)
      return System.Address
      with Inline => True;

end PBUF;

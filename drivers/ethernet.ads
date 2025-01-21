-----------------------------------------------------------------------------------------------------------------------
--                                                     SweetAda                                                      --
-----------------------------------------------------------------------------------------------------------------------
-- __HDS__                                                                                                           --
-- __FLN__ ethernet.ads                                                                                              --
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

with System;
with Interfaces;
with Bits;
with TCPIP;
with PBUF;

package Ethernet
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
   use Bits;
   use TCPIP;
   use PBUF;

   ----------------------------------------------------------------------------
   -- Ethernet basic types
   ----------------------------------------------------------------------------

   subtype MAC_Address_Type is Byte_A2Array (0 .. 5);

   ----------------------------------------------------------------------------
   -- Type_or_Length semantics:
   --
   -- ...LLLLLLLLLLLLLLLLL](xxxxxxxxxxxxxxxxxxxx)[TTTTTTTTTTTTTTTTT...
   -- 0                 0x05dc                0x0600                ->
   --                   (1500)                (1536)
   --   IEEE 802.3 (length)      undefined      DIX Ethernet II (type)
   ----------------------------------------------------------------------------

   ETH_HDR_SIZE : constant := 14;
   type Ethernet_Header_Type is record
      MAC_Destination : MAC_Address_Type;
      MAC_Source      : MAC_Address_Type;
      Type_or_Length  : Unsigned_16;
   end record
      with Alignment => 2,
           Size      => ETH_HDR_SIZE * Storage_Unit;
   for Ethernet_Header_Type use record
      MAC_Destination at  0 range 0 .. 47;
      MAC_Source      at  6 range 0 .. 47;
      Type_or_Length  at 12 range 0 .. 15;
   end record;

   ----------------------------------------------------------------------------
   -- ARP
   ----------------------------------------------------------------------------
   -- __REF__ RFC 826
   ----------------------------------------------------------------------------

   ARP_HDR_SIZE : constant := 28;
   type ARP_Header_Type is record
      Htype : Unsigned_16;
      Ptype : Unsigned_16;
      Hlen  : Unsigned_8;
      Plen  : Unsigned_8;
      Oper  : Unsigned_16;
      Sha   : MAC_Address_Type;
      Spa   : IPv4_Address_Type;
      Tha   : MAC_Address_Type;
      Tpa   : IPv4_Address_Type;
   end record
      with Alignment => 2,
           Size      => ARP_HDR_SIZE * Storage_Unit;
   for ARP_Header_Type use record
      Htype at  0 range 0 .. 15;
      Ptype at  2 range 0 .. 15;
      Hlen  at  4 range 0 ..  7;
      Plen  at  5 range 0 ..  7;
      Oper  at  6 range 0 .. 15;
      Sha   at  8 range 0 .. 47;
      Spa   at 14 range 0 .. 31;
      Tha   at 18 range 0 .. 47;
      Tpa   at 24 range 0 .. 31;
   end record;

   ARP_REQUEST : constant := 16#0001#;
   ARP_REPLY   : constant := 16#0002#;

   ----------------------------------------------------------------------------
   -- ARP management
   ----------------------------------------------------------------------------

   ARP_NENTRIES : constant Natural := 16;

   type ARP_Entry_Type is record
      IP_Entry : Unsigned_32;
   end record;

   type ARP_Entry_Ptr is access all ARP_Entry_Type;

   ----------------------------------------------------------------------------
   -- Ethernet descriptor
   ----------------------------------------------------------------------------

   type RX_Ptr is access procedure (Data_Address : in Address);
   type TX_Ptr is access procedure (Data_Address : in Address; P : in Pbuf_Ptr);

   type Descriptor_Type is record
      Haddress     : MAC_Address_Type;  -- "hardware" address (MAC)
      Paddress     : IPv4_Address_Type; -- "protocol" address (IPv4)
      RX           : RX_Ptr;
      TX           : TX_Ptr;
      Data_Address : Address;
   end record;

   DESCRIPTOR_INVALID : constant Descriptor_Type :=
      (
       Haddress     => [0, 0, 0, 0, 0, 0],
       Paddress     => [0, 0, 0, 0],
       RX           => null,
       TX           => null,
       Data_Address => Null_Address
      );

   ----------------------------------------------------------------------------
   -- Package subprograms
   ----------------------------------------------------------------------------

   procedure Init
      (D : in Descriptor_Type);

   function Descriptor_Get
      return Descriptor_Type;

   procedure Packet_Handler
      (P : in Pbuf_Ptr);

   procedure TX
      (P : in Pbuf_Ptr);

   ----------------------------------------------------------------------------
   -- Packet Queue
   ----------------------------------------------------------------------------

   QUEUE_SIZE : constant := 32;

   type Queue_Index_Type is mod QUEUE_SIZE;

   type Queue_Array is array (Queue_Index_Type) of Pbuf_Ptr
      with Suppress_Initialization => True;

   type Queue_Type is record
      Queue : Queue_Array;
      Head  : Queue_Index_Type              := 0;
      Tail  : Queue_Index_Type              := 0;
      Count : Natural range 0 .. QUEUE_SIZE := 0;
   end record
      with Volatile => True;

   Packet_Queue : aliased Queue_Type := ([others => null], 0, 0, 0);

   function Nqueue
      (Q : access Queue_Type)
      return Natural;

   procedure Enqueue
      (Q       : access Queue_Type;
       P       : in     Pbuf_Ptr;
       Success :    out Boolean);

   procedure Dequeue
      (Q       : access Queue_Type;
       P       : out    Pbuf_Ptr;
       Success : out    Boolean);

end Ethernet;

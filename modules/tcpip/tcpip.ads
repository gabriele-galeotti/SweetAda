-----------------------------------------------------------------------------------------------------------------------
--                                                     SweetAda                                                      --
-----------------------------------------------------------------------------------------------------------------------
-- __HDS__                                                                                                           --
-- __FLN__ tcpip.ads                                                                                                 --
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
with PBUF;

package TCPIP
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
   use PBUF;

   -- BE layout
   subtype IPv4_Address_Type is Byte_Array (0 .. 3);

   ----------------------------------------------------------------------------
   -- IPv4
   ----------------------------------------------------------------------------

   IPv4_HDR_SIZE : constant := 20;
   type IPv4_Header_Type is record
      Version              : Bits_4;
      IHL                  : Bits_4;            -- header length in *32-bit* units (including Options)
      DSCP                 : Bits_6;            -- RFC 2474
      ECN                  : Bits_2;            -- RFC 3168
      Total_Length         : Unsigned_16;       -- total length: IHL*4 + payload
      Identification       : Unsigned_16;
      Flags                : Bits_3;
      Fragmentation_Offset : Bits_13;
      TTL                  : Unsigned_8;
      Protocol             : Unsigned_8;
      Header_Checksum      : Unsigned_16;       -- checksum, not including Options fields
      Src_Address          : IPv4_Address_Type;
      Dst_Address          : IPv4_Address_Type;
   end record
      with Alignment => 2,
           Bit_Order => High_Order_First,
           Size      => IPv4_HDR_SIZE * Storage_Unit;
   for IPv4_Header_Type use record
      Version              at  0 range 0 .. 3;
      IHL                  at  0 range 4 .. 7;
      DSCP                 at  1 range 0 .. 5;
      ECN                  at  1 range 6 .. 7;
      Total_Length         at  2 range 0 .. 15;
      Identification       at  4 range 0 .. 15;
      Flags                at  6 range 0 .. 2;
      Fragmentation_Offset at  6 range 3 .. 15;
      TTL                  at  8 range 0 .. 7;
      Protocol             at  9 range 0 .. 7;
      Header_Checksum      at 10 range 0 .. 15;
      Src_Address          at 12 range 0 .. 31;
      Dst_Address          at 16 range 0 .. 31;
   end record;

   ICMP : constant := 16#01#;
   IGMP : constant := 16#02#;
   TCP  : constant := 16#06#;
   UDP  : constant := 16#11#;

   ----------------------------------------------------------------------------
   -- ICMP
   ----------------------------------------------------------------------------

   ICMP_HDR_SIZE : constant := 8;
   type ICMP_Header_Type is record
      Typ          : Unsigned_8;
      Code         : Unsigned_8;
      Checksum     : Unsigned_16;
      Restofheader : Unsigned_32;
   end record
      with Alignment => 2,
           Size      => ICMP_HDR_SIZE * Storage_Unit;
   for ICMP_Header_Type use record
      Typ          at 0 range 0 .. 7;
      Code         at 1 range 0 .. 7;
      Checksum     at 2 range 0 .. 15;
      Restofheader at 4 range 0 .. 31;
   end record;

   ICMP_ECHO_REPLY       : constant := 16#00#;
   ICMP_PORT_UNREACHABLE : constant := 16#03#;
   ICMP_ECHO_REQUEST     : constant := 16#08#;

   ----------------------------------------------------------------------------
   -- UDP
   ----------------------------------------------------------------------------

   UDP_HDR_SIZE : constant := 8;
   type UDP_Header_Type is record
      Src_Port : Unsigned_16;
      Dst_Port : Unsigned_16;
      Length   : Unsigned_16; -- including this header, minimum 8
      Checksum : Unsigned_16;
   end record
      with Alignment => 2,
           Size      => UDP_HDR_SIZE * Storage_Unit;
   for UDP_Header_Type use record
      Src_Port at 0 range 0 .. 15;
      Dst_Port at 2 range 0 .. 15;
      Length   at 4 range 0 .. 15;
      Checksum at 6 range 0 .. 15;
   end record;

   UDP_IPv4_PseudoHeader_SIZE : constant := 12;
   type UDP_IPv4_PseudoHeader_Type is record
      Src_Address : IPv4_Address_Type; -- IP src address
      Dst_Address : IPv4_Address_Type; -- IP dst address
      Zeroes      : Unsigned_8 := 0;   -- 0
      Protocol    : Unsigned_8;        -- UDP
      Length      : Unsigned_16;       -- UDP header + data
   end record
      with Alignment => 2,
           Size      => UDP_IPv4_PseudoHeader_SIZE * Storage_Unit;
   for UDP_IPv4_PseudoHeader_Type use record
      Src_Address at  0 range 0 .. 31;
      Dst_Address at  4 range 0 .. 31;
      Zeroes      at  8 range 0 .. 7;
      Protocol    at  9 range 0 .. 7;
      Length      at 10 range 0 .. 15;
   end record;

   ----------------------------------------------------------------------------
   -- TCP
   ----------------------------------------------------------------------------

   TCP_HDR_SIZE : constant := 20;
   type TCP_Header_Type is record
      Src_Port       : Unsigned_16;
      Dst_Port       : Unsigned_16;
      Seq_Num        : Unsigned_32;
      Ack_Num        : Unsigned_32;
      HLen           : Bits_4;
      Reserved       : Bits_6;
      Urg            : Bits_1;
      Ack            : Bits_1;
      Psh            : Bits_1;
      Rst            : Bits_1;
      Syn            : Bits_1;
      Fin            : Bits_1;
      Window_Size    : Unsigned_16;
      Checksum       : Unsigned_16;
      Urgent_Pointer : Unsigned_16;
   end record
      with Alignment => 2,
           Bit_Order => High_Order_First,
           Size      => TCP_HDR_SIZE * Storage_Unit;
   for TCP_Header_Type use record
      Src_Port       at  0 range 0 .. 15;
      Dst_Port       at  2 range 0 .. 15;
      Seq_Num        at  4 range 0 .. 31;
      Ack_Num        at  8 range 0 .. 31;
      HLen           at 12 range 0 .. 3;
      Reserved       at 12 range 4 .. 9;
      Urg            at 12 range 10 .. 10;
      Ack            at 12 range 11 .. 11;
      Psh            at 12 range 12 .. 12;
      Rst            at 12 range 13 .. 13;
      Syn            at 12 range 14 .. 14;
      Fin            at 12 range 15 .. 15;
      Window_Size    at 14 range 0 .. 15;
      Checksum       at 16 range 0 .. 15;
      Urgent_Pointer at 18 range 0 .. 15;
   end record;

   ----------------------------------------------------------------------------
   -- Package subprograms
   ----------------------------------------------------------------------------

   procedure IPv4_Handler (P : in Pbuf_Ptr);

end TCPIP;

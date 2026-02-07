-----------------------------------------------------------------------------------------------------------------------
--                                                     SweetAda                                                      --
-----------------------------------------------------------------------------------------------------------------------
-- __HDS__                                                                                                           --
-- __FLN__ tcpip.adb                                                                                                 --
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

with Ethernet;
with Console;

package body TCPIP
   is

   --========================================================================--
   --                                                                        --
   --                                                                        --
   --                           Local declarations                           --
   --                                                                        --
   --                                                                        --
   --========================================================================--

   function Checksum_Core_U32
      (Data : Byte_A2Array)
      return Unsigned_32;
   function Checksum
      (Data        : Byte_A2Array;
       Sum_Initial : Unsigned_32 := 0)
      return Unsigned_16;

   procedure ICMP_Handler
      (P : in Pbuf_Ptr);
   procedure UDP_Handler
      (P : in Pbuf_Ptr);
   procedure TCP_Handler
      (P : in Pbuf_Ptr);

   --========================================================================--
   --                                                                        --
   --                                                                        --
   --                           Package subprograms                          --
   --                                                                        --
   --                                                                        --
   --========================================================================--

   ----------------------------------------------------------------------------
   -- Checksum_Core_U32
   ----------------------------------------------------------------------------
   -- Basic network-order 16-bit data checksum computation.
   -- __REF__ RFC 1071
   ----------------------------------------------------------------------------
   function Checksum_Core_U32
      (Data : Byte_A2Array)
      return Unsigned_32
      is
      Sum    : Unsigned_32 := 0;
      Length : Natural := Data'Length;
      Index  : Integer := Data'First;
      Data16 : U16_Array (Data'First .. Natural'Last)
         with Address => Data'Address;
   begin
      while Length > 1 loop
         Sum := @ + Unsigned_32 (Data16 (Index));
         Index := @ + 1;
         Length := @ - 2;
      end loop;
      if Length /= 0 then
         Sum := @ + Unsigned_32 (HToN (Unsigned_16 (Data (Data'Last)) * 2**8));
      end if;
      return Sum;
   end Checksum_Core_U32;

   ----------------------------------------------------------------------------
   -- Checksum
   ----------------------------------------------------------------------------
   -- Compute 1's-complement 16-bit IP checksum using Checksum_Core_U32.
   -- __REF__ RFC 1071
   ----------------------------------------------------------------------------
   function Checksum
      (Data        : Byte_A2Array;
       Sum_Initial : Unsigned_32 := 0)
      return Unsigned_16
      is
      Sum  : Unsigned_32;
      HSum : Unsigned_16;
   begin
      Sum := Sum_Initial + Checksum_Core_U32 (Data);
      loop
         HSum := HWord (Sum);
         if HSum /= 0 then
            Sum := Unsigned_32 (HSum) + Unsigned_32 (LWord (@));
         else
            exit;
         end if;
      end loop;
      return not LWord (Sum);
   end Checksum;

   ----------------------------------------------------------------------------
   -- ICMP_Handler
   ----------------------------------------------------------------------------
   -- __REF__ RFC 792
   ----------------------------------------------------------------------------
   procedure ICMP_Handler
      (P : in Pbuf_Ptr)
      is
      ICMP_Header : aliased ICMP_Header_Type
         with Address    => Payload_CurrentAddress (P),
              Import     => True,
              Convention => Ada;
   begin
      case ICMP_Header.Typ is
         when ICMP_ECHO_REQUEST =>
            if Checksum (P.all.Payload (P.all.Offset .. P.all.Offset + P.all.Total_Size - 1)) /= 0 then
               Console.Print ("ICMP packet checksum error", NL => True);
            end if;
            Console.Print (LWord (NToH (ICMP_Header.Restofheader)), Prefix => "ICMP sequence #", NL => True);
            ICMP_Header.Typ      := ICMP_ECHO_REPLY;
            ICMP_Header.Code     := 0;
            ICMP_Header.Checksum := 0;
            ICMP_Header.Checksum := Checksum (P.all.Payload (P.all.Offset .. P.all.Offset + P.all.Total_Size - 1));
            -- __FIX__ exploit received packet: change src/dst IP, compute checksum
            Payload_Rewind (P);
            declare
               IPv4_Header   : aliased IPv4_Header_Type
                  with Address    => Payload_CurrentAddress (P),
                       Import     => True,
                       Convention => Ada;
               Header_Length : Natural;
            begin
               IPv4_Header.Dst_Address     := IPv4_Header.Src_Address;
               IPv4_Header.Src_Address     := Ethernet.Descriptor_Get.Paddress;
               IPv4_Header.Header_Checksum := 0;
               Header_Length := Natural (IPv4_Header.IHL) * 4;
               IPv4_Header.Header_Checksum := Checksum (P.all.Payload (P.all.Offset .. P.all.Offset + Header_Length - 1));
            end;
            Payload_Adjust (P, +Ethernet.ETH_HDR_SIZE);
            P.all.Payload (0 .. 5)  := P.all.Payload (6 .. 11);          -- target MAC is sender MAC
            P.all.Payload (6 .. 11) := Ethernet.Descriptor_Get.Haddress; -- sender = myself
            Ethernet.TX (P);
         when ICMP_PORT_UNREACHABLE =>
            Console.Print ("ICMP: port unreachable", NL => True);
         when others =>
            Console.Print (ICMP_Header.Typ, Prefix => "ICMP: typ:  ", NL => True);
            Console.Print (ICMP_Header.Code, Prefix => "ICMP: code: ", NL => True);
      end case;
   end ICMP_Handler;

   ----------------------------------------------------------------------------
   -- UDP_Handler
   ----------------------------------------------------------------------------
   -- __REF__ RFC 768
   ----------------------------------------------------------------------------
   procedure UDP_Handler
      (P : in Pbuf_Ptr)
      is
      UDP_Header      : aliased UDP_Header_Type
         with Address    => Payload_CurrentAddress (P),
              Import     => True,
              Convention => Ada;
      Checksum_Header : Unsigned_32;
      Checksum_Total  : Unsigned_16;
   begin
      if UDP_Header.Checksum /= 0 then
         -- checksum was used : build an IPv4 "pseudo" header
         -- 1) build a "pseudo" header in memory
         -- 2) compute checksum of the "pseudo" header
         -- 3) compute a complete checksum
         Payload_Rewind (P); -- uncover IP header
         declare
            IPv4_Header      : aliased IPv4_Header_Type with
               Address    => Payload_CurrentAddress (P),
               Import     => True,
               Convention => Ada;
            Pseudo_Header    : aliased UDP_IPv4_PseudoHeader_Type;
            Pseudo_Header_BA : Byte_A2Array (1 .. UDP_IPv4_PseudoHeader_SIZE) with
               Address => Pseudo_Header'Address;
         begin
            Pseudo_Header.Src_Address := IPv4_Header.Src_Address;
            Pseudo_Header.Dst_Address := IPv4_Header.Dst_Address;
            Pseudo_Header.Zeroes      := 0;
            Pseudo_Header.Protocol    := IPv4_Header.Protocol;
            Pseudo_Header.Length      := UDP_Header.Length;
            Checksum_Header := Checksum_Core_U32 (Pseudo_Header_BA);
         end;
         Payload_Rewind (P); -- restore UDP header
         Checksum_Total := Checksum (
                              P.all.Payload (P.all.Offset .. P.all.Offset + P.all.Total_Size - 1),
                              Checksum_Header
                              );
         if Checksum_Total = 0 then
            Console.Print ("UDP checksum OK.", NL => True);
         else
            Console.Print (Checksum_Total, Prefix => "*** Error: UDP checksum:", NL => True);
         end if;
      end if;
      Console.Print (NToH (UDP_Header.Src_Port), Prefix => "SRC PORT: ", NL => True);
      Console.Print (NToH (UDP_Header.Dst_Port), Prefix => "DST PORT: ", NL => True);
      -------------------------------------------------------------------------
      -- TX a response
      -- __FIX__ exploit received packet: change src/dst IP, compute checksum
      -- dst port remains the same (we send to the dst of this message)
      Payload_Rewind (P); -- uncover IP header
      declare
         IPv4_Header      : aliased IPv4_Header_Type
            with Address    => Payload_CurrentAddress (P),
                 Import     => True,
                 Convention => Ada;
         IP_Header_Length : Natural;
         Pseudo_Header    : aliased UDP_IPv4_PseudoHeader_Type;
         Pseudo_Header_BA : aliased Byte_A2Array (1 .. UDP_IPv4_PseudoHeader_SIZE)
            with Address    => Pseudo_Header'Address,
                 Import     => True,
                 Convention => Ada;
      begin
         IPv4_Header.Dst_Address     := IPv4_Header.Src_Address;
         IPv4_Header.Src_Address     := Ethernet.Descriptor_Get.Paddress;
         IPv4_Header.Header_Checksum := 0;
         IP_Header_Length := Natural (IPv4_Header.IHL) * 4;
         IPv4_Header.Header_Checksum := Checksum (P.all.Payload (P.all.Offset .. P.all.Offset + IP_Header_Length - 1));
         Pseudo_Header.Src_Address := IPv4_Header.Src_Address;
         Pseudo_Header.Dst_Address := IPv4_Header.Dst_Address;
         Pseudo_Header.Zeroes      := 0;
         Pseudo_Header.Protocol    := IPv4_Header.Protocol;
         Pseudo_Header.Length      := UDP_Header.Length;
         Checksum_Header := Checksum_Core_U32 (Pseudo_Header_BA);
      end;
      Payload_Rewind (P); -- restore UDP header
      UDP_Header.Checksum := 0;
      Checksum_Total := Checksum (
                           P.all.Payload (P.all.Offset .. P.all.Offset + P.all.Total_Size - 1),
                           Checksum_Header
                           );
      UDP_Header.Checksum := Checksum_Total;
      Payload_Rewind (P);                                          -- uncover IP header
      Payload_Adjust (P, +Ethernet.ETH_HDR_SIZE);
      P.all.Payload (0 .. 5)  := P.all.Payload (6 .. 11);          -- target MAC is sender MAC
      P.all.Payload (6 .. 11) := Ethernet.Descriptor_Get.Haddress; -- sender = myself
      Ethernet.TX (P);
   end UDP_Handler;

   ----------------------------------------------------------------------------
   -- TCP_Handler
   ----------------------------------------------------------------------------
   -- __REF__ RFC 793
   ----------------------------------------------------------------------------
   procedure TCP_Handler
      (P : in Pbuf_Ptr)
      is
      TCP_Header : aliased TCP_Header_Type
         with Address    => Payload_CurrentAddress (P),
              Import     => True,
              Convention => Ada;
   begin
      Console.Print (NToH (TCP_Header.Src_Port), Prefix => "SRC PORT: ", NL => True);
      Console.Print (NToH (TCP_Header.Dst_Port), Prefix => "DST PORT: ", NL => True);
      Console.Print (NToH (TCP_Header.Seq_Num), Prefix => "SEQ: ", NL => True);
   end TCP_Handler;

   ----------------------------------------------------------------------------
   -- IPv4_Handler
   ----------------------------------------------------------------------------
   procedure IPv4_Handler
      (P : in Pbuf_Ptr)
      is
      IPv4_Header      : aliased IPv4_Header_Type
         with Address    => Payload_CurrentAddress (P),
              Import     => True,
              Convention => Ada;
      IP_Header_Length : Natural; -- i.e. offset to start of payload
   begin
      IP_Header_Length := Natural (IPv4_Header.IHL) * 4;
      if Checksum (P.all.Payload (P.all.Offset .. P.all.Offset + IP_Header_Length - 1)) /= 0 then
         Console.Print ("IP packet checksum error", NL => True);
         return;
      end if;
      if IPv4_Header.Version /= 4 then
         Console.Print ("IP packet version error", NL => True);
         return;
      end if;
      Payload_Adjust (P, -IP_Header_Length);
      case IPv4_Header.Protocol is
         when ICMP =>
            Console.Print ("ICMP", NL => True);
            ICMP_Handler (P);
         when IGMP =>
            Console.Print ("IGMP", NL => True);
         when UDP  =>
            Console.Print ("UDP", NL => True);
            UDP_Handler (P);
         when TCP  =>
            Console.Print ("TCP", NL => True);
            TCP_Handler (P);
         when others =>
            Console.Print ("UNKNOWN", NL => True);
      end case;
   end IPv4_Handler;

end TCPIP;

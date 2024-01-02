-----------------------------------------------------------------------------------------------------------------------
--                                                     SweetAda                                                      --
-----------------------------------------------------------------------------------------------------------------------
-- __HDS__                                                                                                           --
-- __FLN__ ethernet.adb                                                                                              --
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

with CPU;
with Console;

package body Ethernet
   is

   --========================================================================--
   --                                                                        --
   --                                                                        --
   --                           Local declarations                           --
   --                                                                        --
   --                                                                        --
   --========================================================================--

   IEEE8023_Max_Length : constant := 1500;

   EtherType_IPv4 : constant := 16#0800#;
   EtherType_ARP  : constant := 16#0806#;
   EtherType_RARP : constant := 16#8035#;
   EtherType_IPv6 : constant := 16#86DD#;

   The_Descriptor : Descriptor_Type := DESCRIPTOR_INVALID;

   -- renaming shortcuts
   function H2N (Value : Unsigned_16) return Unsigned_16 renames HostToNetwork;
   function N2H (Value : Unsigned_16) return Unsigned_16 renames NetworkToHost;
   function H2N (Value : Unsigned_32) return Unsigned_32 renames HostToNetwork;
   function N2H (Value : Unsigned_32) return Unsigned_32 renames NetworkToHost;

   procedure ARP_Handler
      (P : in Pbuf_Ptr);

   --========================================================================--
   --                                                                        --
   --                                                                        --
   --                           Package subprograms                          --
   --                                                                        --
   --                                                                        --
   --========================================================================--

   ----------------------------------------------------------------------------
   -- ARP_Handler
   ----------------------------------------------------------------------------
   procedure ARP_Handler
      (P : in Pbuf_Ptr)
      is
      ARP_Header : aliased ARP_Header_Type
         with Address    => Payload_CurrentAddress (P),
              Import     => True,
              Convention => Ada;
   begin
      case N2H (ARP_Header.Oper) is
         when ARP_REQUEST =>
            -- Console.Print ("ARP_REQUEST", NL => True);
            if ARP_Header.Tpa = The_Descriptor.Paddress then
               -- __FIX__ exploit received packet: change src/dst IP
               ARP_Header.Oper := H2N (ARP_REPLY);                 -- reply
               ARP_Header.Tha  := ARP_Header.Sha;                  -- target IP is sender IP
               ARP_Header.Tpa  := ARP_Header.Spa;
               ARP_Header.Sha  := The_Descriptor.Haddress;         -- sender = myself
               ARP_Header.Spa  := The_Descriptor.Paddress;
               Payload_Rewind (P);                                 -- uncover ETH header
               P.all.Payload (0 .. 5)  := P.all.Payload (6 .. 11); -- target MAC is sender MAC
               P.all.Payload (6 .. 11) := The_Descriptor.Haddress; -- sender = myself
               TX (P);
            end if;
         when ARP_REPLY =>
            -- "gratuitous" ARP, check for:
            -- sender's hardware and protocol addresses (SHA and SPA)
            -- duplicated in the target fields (TPA=SPA, THA=SHA)
            -- action: update ARP cache
            -- Console.Print ("ARP_REPLY (gratuitous ARP)", NL => True);
            null;
         when others =>
            -- Console.Print ("ARP unknown operation", NL => True);
            null;
      end case;
   end ARP_Handler;

   ----------------------------------------------------------------------------
   -- Init
   ----------------------------------------------------------------------------
   procedure Init
      (D : in Descriptor_Type) is
   begin
      PBUF.Init;
      The_Descriptor := D;
   end Init;

   ----------------------------------------------------------------------------
   -- Descriptor_Get
   ----------------------------------------------------------------------------
   function Descriptor_Get
      return Descriptor_Type
      is
   begin
      return The_Descriptor;
   end Descriptor_Get;

   ----------------------------------------------------------------------------
   -- Packet_Handler
   ----------------------------------------------------------------------------
   -- src/netif/ethernetif.c:ethernetif_input()
   ----------------------------------------------------------------------------
   procedure Packet_Handler
      (P : in Pbuf_Ptr)
      is
      ETH_Header : aliased Ethernet_Header_Type
         with Address    => Payload_CurrentAddress (P),
              Import     => True,
              Convention => Ada;
   begin
      -- Console.Print ("---------------------------------------------------------", NL => True);
      -- Console.Print (P.all.Total_Size, Prefix => "length: ", NL => True);
      -- Console.Print_Memory (Payload_Address (P), Bytelength (P.all.Size), 16);
      Payload_Adjust (P, -ETH_HDR_SIZE);
      case N2H (ETH_Header.Type_or_Length) is
         ---------------------
         when EtherType_ARP =>
            -- Console.Print ("ARP", NL => True);
            ARP_Handler (P);
         ----------------------
         when EtherType_IPv4 =>
            -- Console.Print ("IPv4", NL => True);
            IPv4_Handler (P);
         --------------
         when others =>
            -- Console.Print ("UNKNOWN", NL => True);
            null;
      end case;
   end Packet_Handler;

   ----------------------------------------------------------------------------
   -- TX
   ----------------------------------------------------------------------------
   procedure TX
      (P : in Pbuf_Ptr)
      is
   begin
      The_Descriptor.TX.all (The_Descriptor.Data_Address, P);
   end TX;

   ----------------------------------------------------------------------------
   -- Nqueue
   ----------------------------------------------------------------------------
   function Nqueue
      (Q : access Queue_Type)
      return Natural
      is
   begin
      return Q.all.Count;
   end Nqueue;

   ----------------------------------------------------------------------------
   -- Enqueue
   ----------------------------------------------------------------------------
   procedure Enqueue
      (Q       : access Queue_Type;
       P       : in     Pbuf_Ptr;
       Success :    out Boolean)
      is
      Irq_State : CPU.Irq_State_Type;
   begin
      Irq_State := CPU.Irq_State_Get;
      CPU.Irq_Disable;
      if (Q.all.Head + 1) = Q.all.Tail then
         Success := False;
      else
         Q.all.Queue (Q.all.Head) := P;
         Q.all.Head := Q.all.Head + 1;
         Q.all.Count := Q.all.Count + 1;
         Success := True;
      end if;
      CPU.Irq_State_Set (Irq_State);
   end Enqueue;

   ----------------------------------------------------------------------------
   -- Dequeue
   ----------------------------------------------------------------------------
   procedure Dequeue
      (Q       : access Queue_Type;
       P       : out    Pbuf_Ptr;
       Success : out    Boolean)
      is
      Irq_State : CPU.Irq_State_Type;
   begin
      Irq_State := CPU.Irq_State_Get;
      CPU.Irq_Disable;
      if Q.all.Tail = Q.all.Head then
         P := null;
         Success := False;
      else
         P := Q.all.Queue (Q.all.Tail);
         Q.all.Tail := Q.all.Tail + 1;
         Q.all.Count := Q.all.Count - 1;
         Success := True;
      end if;
      CPU.Irq_State_Set (Irq_State);
   end Dequeue;

end Ethernet;

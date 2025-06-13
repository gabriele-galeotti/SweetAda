-----------------------------------------------------------------------------------------------------------------------
--                                                     SweetAda                                                      --
-----------------------------------------------------------------------------------------------------------------------
-- __HDS__                                                                                                           --
-- __FLN__ a2065.adb                                                                                                 --
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

with System.Storage_Elements;
with Ada.Unchecked_Conversion;
with MMIO;
with LLutils;
with Memory_Functions;
with Amiga;
with Console;

package body A2065
   is

   --========================================================================--
   --                                                                        --
   --                                                                        --
   --                           Local declarations                           --
   --                                                                        --
   --                                                                        --
   --========================================================================--

   use System.Storage_Elements;
   use Amiga;
   use Am7990;
   use Ethernet;

   ----------------------------------------------------------------------------
   -- The Am7990 LANCE chip in the A2065 is wrapped with D0..D15 data lines
   -- (internally LE) connected to the D16..D31 data lines of the M68k
   -- processor (BE). The 16-bit halves of 32-bit values have to be swapped
   -- because memory is read differently on the two sides.
   ----------------------------------------------------------------------------

   Initialization_Done : Boolean := False
      with Atomic => True;

   ----------------------------------------------------------------------------
   -- Packet buffer
   ----------------------------------------------------------------------------

   PACKET_BUFFER_SIZE : constant := 2048; -- __FIX__

   subtype Packet_Buffer_Type is Byte_Array (0 .. PACKET_BUFFER_SIZE - 1);

   ----------------------------------------------------------------------------
   -- Receive ring
   ----------------------------------------------------------------------------

   RDR_ORDER : constant := 3; -- 2^3 = 8 entries

   -- size = 64 * 8 = 512 = 0x200
   Receive_Ring : aliased Receive_Ring_Type (0 .. 2**RDR_ORDER - 1)
      -- with Address    => To_Address (16#00EA_8100#),
      with Address    => To_Address (16#00E9_8100#),
           Volatile   => True,
           Import     => True,
           Convention => Ada;

   -- size = 2048 * 8 = 16384 = 0x4000
   Receive_Buffers : array (0 .. 2**RDR_ORDER - 1) of aliased Packet_Buffer_Type
      -- with Address    => To_Address (16#00EA_8800#),
      with Address    => To_Address (16#00E9_8800#),
           Volatile   => True,
           Import     => True,
           Convention => Ada;

   ----------------------------------------------------------------------------
   -- Transmit ring
   ----------------------------------------------------------------------------

   TDR_ORDER : constant := 0; -- 2^0 = 1 entry

   Transmit_Ring : aliased Transmit_Ring_Type (0 .. 2**TDR_ORDER - 1)
      -- with Address    => To_Address (16#00EA_E000#),
      with Address    => To_Address (16#00E9_E000#),
           Volatile   => True,
           Import     => True,
           Convention => Ada;

   Transmit_Buffers : array (0 .. 2**TDR_ORDER - 1) of aliased Packet_Buffer_Type
      -- with Address    => To_Address (16#00EA_E100#),
      with Address    => To_Address (16#00E9_E100#),
           Volatile   => True,
           Import     => True,
           Convention => Ada;

   ----------------------------------------------------------------------------
   -- Initialization block
   ----------------------------------------------------------------------------

   Initialization_Block : Initialization_Block_Type
      with Address    => To_Address (A2065_BASEADDRESS + A2065_RAM_OFFSET),
           Volatile   => True,
           Import     => True,
           Convention => Ada;

   -- starting RX buffer
   RX_Buffer_Index : Natural := 0;

   --========================================================================--
   --                                                                        --
   --                                                                        --
   --                           Package subprograms                          --
   --                                                                        --
   --                                                                        --
   --========================================================================--

   ----------------------------------------------------------------------------
   -- Probe
   ----------------------------------------------------------------------------
   procedure Probe
      (PIC     : in     ZorroII.PIC_Type;
       Success :    out Boolean)
      is
   begin
      -- MAC = 02-80-10 (Commodore OUI, locally administered) + last 24 bits of
      -- the board S/N offsets
      -- offsets 0x18/0x1A contain the first 8 bits of the board S/N and so are
      -- discarded
      A2065_MAC := [
         16#02#,
         16#80#,
         16#10#,
         NByte (PIC.Serial_Number),
         MByte (PIC.Serial_Number),
         LByte (PIC.Serial_Number)
         ];
      -- configure A2065 address
      ZorroII.Setup (A2065_BASEADDRESS);
      -- log informations
      Console.Print (Prefix => "A2065: Ethernet card @ ", Value => Unsigned_32'(A2065_BASEADDRESS), NL => True);
      Console.Print (Prefix => "A2065: MAC address ", ByteArray => Byte_Array (A2065_MAC), Separator => ':', NL => True);
      Success := True;
   end Probe;

   ----------------------------------------------------------------------------
   -- Init
   ----------------------------------------------------------------------------
   procedure Init
      is
      RDRA                : Ring_Descriptor_Pointer_Type;
      TDRA                : Ring_Descriptor_Pointer_Type;
      Ethernet_Descriptor : Ethernet.Descriptor_Type := Ethernet.DESCRIPTOR_INVALID;
      function To_U16 is new Ada.Unchecked_Conversion (CSR0_Type, Unsigned_16);
      function To_U16 is new Ada.Unchecked_Conversion (CSR3_Type, Unsigned_16);

      function To_R_RDP is new Ada.Unchecked_Conversion (Unsigned_32, Ring_Descriptor_Pointer_Type);
      function To_U32 is new Ada.Unchecked_Conversion (Ring_Descriptor_Pointer_Type, Unsigned_32);
   begin
      -- Am7990 ---------------------------------------------------------------
      Am7990_Descriptor := (
         Base_Address  => To_Address (A2065_BASEADDRESS + A2065_CHIP_OFFSET),
         Scale_Address => 0,
         Read_16       => MMIO.ReadA'Access,
         Write_16      => MMIO.WriteA'Access,
         others        => <>
         );
      Am7990_Descriptor_Initialized := True;
      -- begin initialization sequence by setting STOP bit
      Register_Write (
         Am7990_Descriptor,
         CSR0,
         To_U16 (CSR0_Type'(
            STOP   => True,
            others => False
            ))
         );
      -- once the STOP bit is set, other registers can be accessed
      -- setup Initialization Block address in CSR1,2
      Register_Write (
         Am7990_Descriptor,
         CSR1,
         LWord (Unsigned_32'(A2065_BASEADDRESS + A2065_RAM_OFFSET)) and 16#FFFE#
         );
      Register_Write (
         Am7990_Descriptor,
         CSR2,
         HWord (Unsigned_32'(A2065_BASEADDRESS + A2065_RAM_OFFSET)) and 16#00FF#
         );
      -- setup CSR3
      Register_Write (
         Am7990_Descriptor,
         CSR3,
         To_U16 (CSR3_Type'(
            BCON     => 0,
            ACON     => 0,
            BSWP     => 1,
            Reserved => 0
            ))
         );
      -- setup Receive Message Descriptors
      for Index in Receive_Ring'Range loop
         Receive_Ring (Index).RMD0 := (
            LADR => Bits_16 (LLutils.Select_Address_Bits (Receive_Buffers (Index)'Address, 0, 15))
            );
         Receive_Ring (Index).RMD1 := (
            HADR => Bits_8 (LLutils.Select_Address_Bits (Receive_Buffers (Index)'Address, 16, 23)),
            ENP  => False,
            STP  => False,
            BUFF => False,
            CRC  => False,
            OFLO => False,
            FRAM => False,
            ERR  => False,
            OWN  => False
            );
         Receive_Ring (Index).RMD2 := (BCNT => Bits_12'(-PACKET_BUFFER_SIZE), others => <>);
      end loop;
      -- Receive Message Descriptors ownership assigned to LANCE
      for Index in Receive_Ring'Range loop
         Receive_Ring (Index).RMD1.OWN := True;
      end loop;
      -- setup Transmit Message Descriptors
      for Index in Transmit_Ring'Range loop
         Transmit_Ring (Index).TMD0 := (
            LADR => Bits_16 (LLutils.Select_Address_Bits (Transmit_Buffers (Index)'Address, 0, 15))
            );
         Transmit_Ring (Index).TMD1 := (
            HADR => Bits_8 (LLutils.Select_Address_Bits (Transmit_Buffers (Index)'Address, 16, 23)),
            ENP  => False, STP => False, DEF => False, ONE => False,
            MORE => False, ADD_FCS => False, ERR => False, OWN => False
            );
         Transmit_Ring (Index).TMD2 := (BCNT => Bits_12'(-PACKET_BUFFER_SIZE), others => <>);
      end loop;
      -- Transmit Message Descriptors ownership assigned to HOST
      for Index in Transmit_Ring'Range loop
         Transmit_Ring (Index).TMD1.OWN := False;
      end loop;
      -- setup Initialization Block
      -- the Initialization Block will be read by LANCE when the INIT bit in
      -- CSR0 is set
      Initialization_Block.MODE := (
         DRX      => False,
         DTX      => False,
         LOOPB    => False,
         DTCR     => False,
         COLL     => False,
         DRTY     => False,
         INTL     => False,
         Reserved => 0,
         PROM     => True
         );
      MMIO.Write_U16 (Initialization_Block.PADR0'Address, MMIO.ReadS_U16 (A2065_MAC (0)'Address));
      MMIO.Write_U16 (Initialization_Block.PADR2'Address, MMIO.ReadS_U16 (A2065_MAC (2)'Address));
      MMIO.Write_U16 (Initialization_Block.PADR4'Address, MMIO.ReadS_U16 (A2065_MAC (4)'Address));
      -- RDRA
      RDRA.Ring_Pointer := Bits_21 (LLutils.Select_Address_Bits (Receive_Ring'Address, 3, 23));
      RDRA.Length       := RDR_ORDER;
      Initialization_Block.RDRA := To_R_RDP (Word_Swap (To_U32 (RDRA)));
      -- TDRA
      TDRA.Ring_Pointer := Bits_21 (LLutils.Select_Address_Bits (Transmit_Ring'Address, 3, 23));
      TDRA.Length       := TDR_ORDER;
      Initialization_Block.TDRA := To_R_RDP (Word_Swap (To_U32 (TDRA)));
      -- set INIT, clear STOP
      Register_Write (
         Am7990_Descriptor,
         CSR0,
         To_U16 (CSR0_Type'(
            INIT   => True,
            INEA   => True,
            others => False
            ))
         );
      -- wait for initialization done
      loop exit when Initialization_Done; end loop;
      -- enable LANCE to send and receive packets
      Register_Write (
         Am7990_Descriptor,
         CSR0,
         To_U16 (CSR0_Type'(
            STRT   => True,
            others => False
            ))
         );
   end Init;

   ----------------------------------------------------------------------------
   -- Receive
   ----------------------------------------------------------------------------
   function Receive
      return Boolean
      is
      Result       : Boolean;
      A2065_Status : CSR0_Type;
      P            : PBUF.Pbuf_Ptr;
      function To_U16 is new Ada.Unchecked_Conversion (CSR0_Type, Unsigned_16);
      function To_CSR0 is new Ada.Unchecked_Conversion (Unsigned_16, CSR0_Type);
   begin
      Result := False;
      if not Am7990_Descriptor_Initialized then
         return Result;
      end if;
      A2065_Status := To_CSR0 (Register_Read (Am7990_Descriptor, CSR0));
      if A2065_Status.INTR then
         if A2065_Status.IDON then
            -- initialization complete
            Register_Write (
               Am7990_Descriptor,
               CSR0,
               To_U16 (CSR0_Type'(
                  IDON   => True,
                  others => False
                  ))
               );
            Initialization_Done := True;
            Result := True;
            -- Console.Print ("A2065: Initialization done.", NL => True);
         elsif A2065_Status.RINT then
            loop
               exit when not Receive_Ring (RX_Buffer_Index).RMD1.OWN;
               RX_Buffer_Index := (RX_Buffer_Index + 1) mod 2**RDR_ORDER;
            end loop;
            -- __FIX__ check for errors
            Register_Write (
               Am7990_Descriptor,
               CSR0,
               To_U16 (CSR0_Type'(
                  TXON   => True,
                  RXON   => True,
                  BABL   => True,
                  MISS   => True,
                  MERR   => True,
                  TINT   => False,
                  RINT   => True,
                  others => False
                  ))
               );
            -- Console.Print (Natural (Receive_Ring (RX_Buffer_Index).RMD3.MCNT), Prefix => "RECEIVE = ", NL => True);
            P := PBUF.Allocate (Natural (Receive_Ring (RX_Buffer_Index).RMD3.MCNT) - 4); -- discard FCS
            Memory_Functions.Cpymem (
               Receive_Buffers (RX_Buffer_Index)'Address,
               PBUF.Payload_Address (P),
               Bytesize (Receive_Ring (RX_Buffer_Index).RMD3.MCNT - 4)
               );
            -- Receive_Ring (RX_Buffer_Index).RMD3.MCNT := 0; ???
            Receive_Ring (RX_Buffer_Index).RMD1.OWN := True;
            declare
               Success : Boolean;
            begin
               Enqueue (Packet_Queue'Access, P, Success);
            end;
            Result := True;
         elsif A2065_Status.TINT then
            Register_Write (
               Am7990_Descriptor,
               CSR0,
               To_U16 (CSR0_Type'(
                  TXON   => True,
                  RXON   => True,
                  BABL   => True,
                  MISS   => True,
                  MERR   => True,
                  TINT   => True,
                  RINT   => False,
                  others => False
                  ))
               );
            Transmit_Ring (0).TMD1.OWN := False;
            Result := True;
         end if;
      end if;
      return Result;
   end Receive;

   ----------------------------------------------------------------------------
   -- Transmit
   ----------------------------------------------------------------------------
   procedure Transmit
      (Data_Address : in System.Address;
       P            : in PBUF.Pbuf_Ptr)
      is
      pragma Unreferenced (Data_Address);
      function To_U16 is new Ada.Unchecked_Conversion (CSR0_Type, Unsigned_16);
   begin
      -- __FIX__
      if P.all.Size < 60 then
         P.all.Size := 60;
      end if;
      Console.Print (P.all.Size, Prefix => "TRANSMIT: ", NL => True);
      -- __FIX__ only one pbuf
      Memory_Functions.Cpymem (
         PBUF.Payload_Address (P),
         Transmit_Buffers (0)'Address,
         Bytesize (P.all.Size)
         );
      Transmit_Ring (0).TMD2 := (BCNT => -Bits_12 (P.all.Size), others => <>);
      Transmit_Ring (0).TMD1.ENP := True;
      Transmit_Ring (0).TMD1.STP := True;
      Transmit_Ring (0).TMD1.OWN := True;
      Register_Write (
         Am7990_Descriptor,
         CSR0,
         To_U16 (CSR0_Type'(
            TXON   => True,
            RXON   => True,
            BABL   => True,
            MISS   => True,
            MERR   => True,
            TINT   => True,
            RINT   => True,
            others => False
            ))
         );
   end Transmit;

end A2065;

-----------------------------------------------------------------------------------------------------------------------
--                                                     SweetAda                                                      --
-----------------------------------------------------------------------------------------------------------------------
-- __HDS__                                                                                                           --
-- __FLN__ a2065.adb                                                                                                 --
-- __DSC__                                                                                                           --
-- __HSH__ e69de29bb2d1d6434b8b29ae775ad8c2e48c5391                                                                  --
-- __HDE__                                                                                                           --
-----------------------------------------------------------------------------------------------------------------------
-- Copyright (C) 2020, 2021 Gabriele Galeotti                                                                        --
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
with ZorroII;
with Console;

package body A2065 is

   --========================================================================--
   --                                                                        --
   --                                                                        --
   --                           Local declarations                           --
   --                                                                        --
   --                                                                        --
   --========================================================================--

   use System.Storage_Elements;
   use Amiga;
   use PBUF;

   Initialization_Block : Initialization_Block_Type with
      Address    => To_Address (A2065_BASEADDRESS + A2065_RAM_OFFSET),
      Volatile   => True,
      Import     => True,
      Convention => Ada;

   Initialization_Done : Boolean := False with
      Atomic => True;

   ----------------------------------------------------------------------------
   -- Receive ring
   ----------------------------------------------------------------------------

   RDR_ORDER : constant := 3; -- 2^3 = 8 entries

   -- size = 64 * 8 = 512 = 0x200
   Receive_Ring : aliased Receive_Ring_Type (0 .. 2**RDR_ORDER - 1) with
      Address    => To_Address (16#00EA_8100#),
      Volatile   => True,
      Import     => True,
      Convention => Ada;

   -- size = 2048 * 8 = 16384 = 0x4000
   Receive_Buffers : array (0 .. 2**RDR_ORDER - 1) of aliased Packet_Buffer_Type with
      Address    => To_Address (16#00EA_8800#),
      Volatile   => True,
      Import     => True,
      Convention => Ada;

   ----------------------------------------------------------------------------
   -- Transmit ring
   ----------------------------------------------------------------------------

   TDR_ORDER : constant := 0; -- 2^0 = 1 entry

   Transmit_Ring : aliased Transmit_Ring_Type (0 .. 2**TDR_ORDER - 1) with
      Address    => To_Address (16#00EA_E000#),
      Volatile   => True,
      Import     => True,
      Convention => Ada;

   Transmit_Buffers : array (0 .. 2**TDR_ORDER - 1) of aliased Packet_Buffer_Type with
      Address    => To_Address (16#00EA_E100#),
      Volatile   => True,
      Import     => True,
      Convention => Ada;

   ----------------------------------------------------------------------------
   -- Local subprograms
   ----------------------------------------------------------------------------

   function CSRX_Read (Register_Number : Unsigned_16) return Unsigned_16;
   procedure CSRX_Write (Register_Number : in Unsigned_16; Value : in Unsigned_16);

   --========================================================================--
   --                                                                        --
   --                                                                        --
   --                           Package subprograms                          --
   --                                                                        --
   --                                                                        --
   --========================================================================--

   ----------------------------------------------------------------------------
   -- Am7990 register read/write
   ----------------------------------------------------------------------------

   function CSRX_Read (Register_Number : Unsigned_16) return Unsigned_16 is
      Result : Unsigned_16;
   begin
      -- __FIX__ lock
      MMIO.WriteA (To_Address (RAP), Register_Number);
      Result := MMIO.ReadA (To_Address (RDP));
      -- __FIX__ unlock
      return Result;
   end CSRX_Read;

   procedure CSRX_Write (Register_Number : in Unsigned_16; Value : in Unsigned_16) is
   begin
      -- __FIX__ lock
      MMIO.WriteA (To_Address (RAP), Register_Number);
      MMIO.WriteA (To_Address (RDP), Value);
      -- __FIX__ unlock
   end CSRX_Write;

   generic
      Register_Number : Unsigned_16;
      type Output_Register_Type is private;
   function CSR_Read return Output_Register_Type;
   pragma Inline (CSR_Read);
   function CSR_Read return Output_Register_Type is
      function Convert is new Ada.Unchecked_Conversion (Unsigned_16, Output_Register_Type);
   begin
      return Convert (CSRX_Read (Register_Number));
   end CSR_Read;

   generic
      Register_Number : in Unsigned_16;
      type Input_Register_Type is private;
   procedure CSR_Write (Value : in Input_Register_Type);
   pragma Inline (CSR_Write);
   procedure CSR_Write (Value : in Input_Register_Type) is
      function Convert is new Ada.Unchecked_Conversion (Input_Register_Type, Unsigned_16);
   begin
      CSRX_Write (Register_Number, Convert (Value));
   end CSR_Write;

   function CSR0_Read is new CSR_Read (CSR0, CSR0_Type);
   pragma Inline (CSR0_Read);
   procedure CSR0_Write is new CSR_Write (CSR0, CSR0_Type);
   pragma Inline (CSR0_Write);

   function CSR1_Read is new CSR_Read (CSR1, Unsigned_16);
   pragma Inline (CSR1_Read);
   procedure CSR1_Write is new CSR_Write (CSR1, Unsigned_16);
   pragma Inline (CSR1_Write);

   function CSR2_Read is new CSR_Read (CSR2, Unsigned_16);
   pragma Inline (CSR2_Read);
   procedure CSR2_Write is new CSR_Write (CSR2, Unsigned_16);
   pragma Inline (CSR2_Write);

   function CSR3_Read is new CSR_Read (CSR3, CSR3_Type);
   pragma Inline (CSR3_Read);
   procedure CSR3_Write is new CSR_Write (CSR3, CSR3_Type);
   pragma Inline (CSR3_Write);

   ----------------------------------------------------------------------------
   -- Probe
   ----------------------------------------------------------------------------
   -- __REF__ INSTALLING THE A2065.pdf
   ----------------------------------------------------------------------------
   procedure Probe (Success : out Boolean) is
      type Offset_Byte is
      record
         Offset : Storage_Offset;
         Value  : Unsigned_8;
      end record;
      -- A2065 Zorro II signature
      A2065_Pattern : constant array (Natural range <>) of Offset_Byte :=
         (
          (16#00#,     16#C1#), -- Type
          (16#04#, not 16#70#), -- Product
          (16#10#, not 16#02#), -- Manufacturer (HIGH)
          (16#14#, not 16#02#)  -- Manufacturer (LOW)
         );
   begin
      -- check for A2065 signature
      for Index in A2065_Pattern'Range loop
         if ZorroII.Signature_Read (A2065_Pattern (Index).Offset) /= A2065_Pattern (Index).Value then
            Success := False;
            return;
         end if;
      end loop;
      -- MAC = 02-80-10 (Commodore OUI, locally administered) + last 24 bits of
      -- the board S/N offsets
      -- offsets 0x18/0x1A contain the first 8 bits of the board S/N and so are
      -- discarded
      A2065_MAC (0) := 16#02#;
      A2065_MAC (1) := 16#80#;
      A2065_MAC (2) := 16#10#;
      A2065_MAC (3) := not ZorroII.Signature_Read (16#1C#);
      A2065_MAC (4) := not ZorroII.Signature_Read (16#20#);
      A2065_MAC (5) := not ZorroII.Signature_Read (16#24#);
      -- log informations
      Console.Print (Unsigned_32'(A2065_BASEADDRESS), Prefix => "A2065: Ethernet card @ ", NL => True);
      Console.Print (Byte_Array (A2065_MAC), Prefix => "A2065: MAC address ", Separator => ':', NL => True);
      -- configure A2065 address
      MMIO.Write (ZorroII.Cfg_Space'Address + 16#48#, NByte (Unsigned_32'(A2065_BASEADDRESS)));
      MMIO.Write (ZorroII.Cfg_Space'Address + 16#44#, HByte (Unsigned_32'(A2065_BASEADDRESS)));
      Success := True;
   end Probe;

   ----------------------------------------------------------------------------
   -- Init
   ----------------------------------------------------------------------------
   procedure Init is
      RDRA                : Ring_Descriptor_Pointer_Type;
      TDRA                : Ring_Descriptor_Pointer_Type;
      Ethernet_Descriptor : Ethernet_Descriptor_Type := Ethernet_DESCRIPTOR_INVALID;
      function To_RDP is new Ada.Unchecked_Conversion (Unsigned_32, Ring_Descriptor_Pointer_Type);
      function To_U32 is new Ada.Unchecked_Conversion (Ring_Descriptor_Pointer_Type, Unsigned_32);
   begin
      -- begin initialization sequence by setting STOP bit
      CSR0_Write ((STOP => True, others => False));
      -- once the STOP bit is set, other registers can be accessed
      -- setup Initialization Block address in CSR1,2
      CSR1_Write (LWord (Unsigned_32'(A2065_BASEADDRESS + A2065_RAM_OFFSET)) and 16#FFFE#);
      CSR2_Write (HWord (Unsigned_32'(A2065_BASEADDRESS + A2065_RAM_OFFSET)) and 16#00FF#);
      -- setup CSR3
      CSR3_Write ((BCON => 0, ACON => 0, BSWP => 1, Reserved => 0));
      -- setup Receive Message Descriptors
      for Index in Receive_Ring'Range loop
         Receive_Ring (Index).RMD0 :=
            (
             LADR => Bits_16 (LLutils.Select_Address_Bits (Receive_Buffers (Index)'Address, 31, 16))
            );
         Receive_Ring (Index).RMD1 :=
            (
             HADR => Bits_8 (LLutils.Select_Address_Bits (Receive_Buffers (Index)'Address, 8, 15)),
             ENP => False, STP => False, BUFF => False, CRC => False,
             OFLO => False, FRAM => False, ERR => False, OWN => False
            );
         Receive_Ring (Index).RMD2 :=
            (
             BCNT => -PACKET_BUFFER_SIZE,
             ONES => Bits_4_1
            );
      end loop;
      -- Receive Message Descriptors ownership assigned to LANCE
      for Index in Receive_Ring'Range loop
         Receive_Ring (Index).RMD1.OWN := True;
      end loop;
      -- setup Transmit Message Descriptors
      for Index in Transmit_Ring'Range loop
         Transmit_Ring (Index).TMD0 :=
            (
             LADR => Bits_16 (LLutils.Select_Address_Bits (Transmit_Buffers (Index)'Address, 31, 16))
            );
         Transmit_Ring (Index).TMD1 :=
            (
             HADR => Bits_8 (LLutils.Select_Address_Bits (Transmit_Buffers (Index)'Address, 8, 15)),
             ENP => False, STP => False, DEF => False, ONE => False,
             MORE => False, ADD_FCS => False, ERR => False, OWN => False
            );
         Transmit_Ring (Index).TMD2 :=
            (
             BCNT => -PACKET_BUFFER_SIZE,
             ONES => Bits_4_1
            );
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
      Initialization_Block.PADR0 := A2065_MAC (0);
      Initialization_Block.PADR1 := A2065_MAC (1);
      Initialization_Block.PADR2 := A2065_MAC (2);
      Initialization_Block.PADR3 := A2065_MAC (3);
      Initialization_Block.PADR4 := A2065_MAC (4);
      Initialization_Block.PADR5 := A2065_MAC (5);
      -- RDRA
      RDRA.Ring_Pointer := Bits_21 (LLutils.Select_Address_Bits (Receive_Ring'Address, 28, 8));
      RDRA.Length       := RDR_ORDER;
      Initialization_Block.RDRA := To_RDP (Word_Swap (To_U32 (RDRA)));
      -- TDRA
      TDRA.Ring_Pointer := Bits_21 (LLutils.Select_Address_Bits (Transmit_Ring'Address, 28, 8));
      TDRA.Length       := TDR_ORDER;
      Initialization_Block.TDRA := To_RDP (Word_Swap (To_U32 (TDRA)));
      -- set INIT, clear STOP
      CSR0_Write ((INIT => True, INEA => True, others => False));
      -- wait for initialization done
      loop
         exit when Initialization_Done;
      end loop;
      -- enable LANCE to send and receive packets
      CSR0_Write ((STRT => True, others => False));
   end Init;

   -- starting RX buffer
   RX_Buffer_Index : Natural := 0;

   ----------------------------------------------------------------------------
   -- Receive
   ----------------------------------------------------------------------------
   function Receive return Boolean is
      Result       : Boolean;
      A2065_Status : CSR0_Type;
      P            : Pbuf_Ptr;
   begin
      Result := False;
      A2065_Status := CSR0_Read;
      if A2065_Status.INTR then
         if A2065_Status.IDON then
            -- initialization complete
            CSR0_Write ((IDON => True, others => False)); -- clear IDON
            Initialization_Done := True;
            Result := True;
            -- Console.Print ("A2065: Initialization done.", NL => True);
         elsif A2065_Status.RINT then
            while True loop
               exit when not Receive_Ring (RX_Buffer_Index).RMD1.OWN;
               RX_Buffer_Index := (RX_Buffer_Index + 1) mod 2**RDR_ORDER;
            end loop;
            -- __FIX__ check for errors
            CSR0_Write ((
                         TXON   => True,
                         RXON   => True,
                         BABL   => True,
                         MISS   => True,
                         MERR   => True,
                         TINT   => False,
                         RINT   => True,
                         others => False
                       ));
            -- Console.Print (Natural (Receive_Ring (RX_Buffer_Index).RMD3.MCNT), Prefix => "RECEIVE = ", NL => True);
            P := Allocate (Natural (Receive_Ring (RX_Buffer_Index).RMD3.MCNT) - 4); -- discard FCS
            Memory_Functions.Cpymem (
                                     Receive_Buffers (RX_Buffer_Index)'Address,
                                     Payload_Address (P),
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
            CSR0_Write ((
                         TXON   => True,
                         RXON   => True,
                         BABL   => True,
                         MISS   => True,
                         MERR   => True,
                         TINT   => True,
                         RINT   => False,
                         others => False
                       ));
            Transmit_Ring (0).TMD1.OWN := False;
            Result := True;
         end if;
      end if;
      return Result;
   end Receive;

   ----------------------------------------------------------------------------
   -- Transmit
   ----------------------------------------------------------------------------
   procedure Transmit (Data_Address : in System.Address; P : in Pbuf_Ptr) is
      pragma Unreferenced (Data_Address);
   begin
      -- __FIX__
      if P.all.Size < 60 then
         P.all.Size := 60;
      end if;
      Console.Print (P.all.Size, Prefix => "TRANSMIT: ", NL => True);
      -- __FIX__ only one pbuf
      Memory_Functions.Cpymem (
                               Payload_Address (P),
                               Transmit_Buffers (0)'Address,
                               Bytesize (P.all.Size)
                              );
      Transmit_Ring (0).TMD2 := (BCNT => -Bits_12 (P.all.Size), ONES => Bits_4_1);
      Transmit_Ring (0).TMD1.ENP := True;
      Transmit_Ring (0).TMD1.STP := True;
      Transmit_Ring (0).TMD1.OWN := True;
      CSR0_Write ((
                   TXON   => True,
                   RXON   => True,
                   BABL   => True,
                   MISS   => True,
                   MERR   => True,
                   TINT   => True,
                   RINT   => True,
                   others => False
                 ));
   end Transmit;

end A2065;

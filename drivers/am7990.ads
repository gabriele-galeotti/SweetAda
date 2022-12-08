-----------------------------------------------------------------------------------------------------------------------
--                                                     SweetAda                                                      --
-----------------------------------------------------------------------------------------------------------------------
-- __HDS__                                                                                                           --
-- __FLN__ am7990.ads                                                                                                --
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
with System.Storage_Elements;
with Ada.Unchecked_Conversion;
with Interfaces;
with Bits;
with MMIO;

package Am7990 is

   --========================================================================--
   --                                                                        --
   --                                                                        --
   --                               Public part                              --
   --                                                                        --
   --                                                                        --
   --========================================================================--

   use System;
   use System.Storage_Elements;
   use Interfaces;
   use Bits;

   ----------------------------------------------------------------------------
   -- Am7990 Local Area Network Controller for Ethernet (LANCE)
   ----------------------------------------------------------------------------

   ----------------------------------------------------------------------------
   -- Register types
   ----------------------------------------------------------------------------

   RDP_OFFSET : constant := 0; -- Register Data Port
   RAP_OFFSET : constant := 2; -- Register Address Port

   type Am7990_Register_Type is (
                                 CSR0,
                                 CSR1,
                                 CSR2,
                                 CSR3
                                );
   for Am7990_Register_Type use (
                                 16#000#,
                                 16#001#,
                                 16#002#,
                                 16#003#
                                );

   ----------------------------------------------------------------------------
   -- CSRX register types
   ----------------------------------------------------------------------------

   type CSR0_Type is
   record
      INIT : Boolean;
      STRT : Boolean;
      STOP : Boolean;
      TDMD : Boolean;
      TXON : Boolean;
      RXON : Boolean;
      INEA : Boolean;
      INTR : Boolean;
      IDON : Boolean;
      TINT : Boolean;
      RINT : Boolean;
      MERR : Boolean;
      MISS : Boolean;
      CERR : Boolean;
      BABL : Boolean;
      ERR  : Boolean;
   end record with
      Bit_Order => Low_Order_First,
      Size      => 16;
   for CSR0_Type use
   record
      INIT at 0 range 0 .. 0;
      STRT at 0 range 1 .. 1;
      STOP at 0 range 2 .. 2;
      TDMD at 0 range 3 .. 3;
      TXON at 0 range 4 .. 4;
      RXON at 0 range 5 .. 5;
      INEA at 0 range 6 .. 6;
      INTR at 0 range 7 .. 7;
      IDON at 0 range 8 .. 8;
      TINT at 0 range 9 .. 9;
      RINT at 0 range 10 .. 10;
      MERR at 0 range 11 .. 11;
      MISS at 0 range 12 .. 12;
      CERR at 0 range 13 .. 13;
      BABL at 0 range 14 .. 14;
      ERR  at 0 range 15 .. 15;
   end record;

   function To_U16 is new Ada.Unchecked_Conversion (CSR0_Type, Unsigned_16);
   function To_CSR0 is new Ada.Unchecked_Conversion (Unsigned_16, CSR0_Type);

   type CSR3_Type is
   record
      BCON     : Bits_1;
      ACON     : Bits_1;
      BSWP     : Bits_1;
      Reserved : Bits_13;
   end record with
      Bit_Order => Low_Order_First,
      Size      => 16;
   for CSR3_Type use
   record
      BCON     at 0 range 0 .. 0;
      ACON     at 0 range 1 .. 1;
      BSWP     at 0 range 2 .. 2;
      Reserved at 0 range 3 .. 15;
   end record;

   function To_U16 is new Ada.Unchecked_Conversion (CSR3_Type, Unsigned_16);
   function To_CSR3 is new Ada.Unchecked_Conversion (Unsigned_16, CSR3_Type);

   ----------------------------------------------------------------------------
   -- Receive Message Descriptor
   ----------------------------------------------------------------------------

   type RMD0_Type is
   record
      LADR : Bits_16;
   end record with
      Bit_Order => Low_Order_First,
      Size      => 16;
   for RMD0_Type use
   record
      LADR at 0 range 0 .. 15;
   end record;

   type RMD1_Type is
   record
      HADR : Bits_8;
      ENP  : Boolean;
      STP  : Boolean;
      BUFF : Boolean;
      CRC  : Boolean;
      OFLO : Boolean;
      FRAM : Boolean;
      ERR  : Boolean;
      OWN  : Boolean;
   end record with
      Bit_Order => Low_Order_First,
      Size      => 16;
   for RMD1_Type use
   record
      HADR at 0 range 0 .. 7;
      ENP  at 0 range 8 .. 8;
      STP  at 0 range 9 .. 9;
      BUFF at 0 range 10 .. 10;
      CRC  at 0 range 11 .. 11;
      OFLO at 0 range 12 .. 12;
      FRAM at 0 range 13 .. 13;
      ERR  at 0 range 14 .. 14;
      OWN  at 0 range 15 .. 15;
   end record;

   type RMD2_Type is
   record
      BCNT : Bits_12;
      ONES : Bits_4 := 2#1111#;
   end record with
      Bit_Order => Low_Order_First,
      Size      => 16;
   for RMD2_Type use
   record
      BCNT at 0 range 0 .. 11;
      ONES at 0 range 12 .. 15;
   end record;

   type RMD3_Type is
   record
      MCNT     : Bits_12;
      Reserved : Bits_4;
   end record with
      Bit_Order => Low_Order_First,
      Size      => 16;
   for RMD3_Type use
   record
      MCNT     at 0 range 0 .. 11;
      Reserved at 0 range 12 .. 15;
   end record;

   -- Descriptor ring for incoming packets
   -- must start on a quadword boundary (A0 .. A2 = 0)
   type Receive_Message_Descriptor_Type is
   record
      RMD0 : RMD0_Type;
      RMD1 : RMD1_Type;
      RMD2 : RMD2_Type;
      RMD3 : RMD3_Type;
   end record with
      Alignment               => 2**3,
      Size                    => 16 * 4,
      Suppress_Initialization => True;
   for Receive_Message_Descriptor_Type use
   record
      RMD0 at 0 range 0 .. 15;
      RMD1 at 2 range 0 .. 15;
      RMD2 at 4 range 0 .. 15;
      RMD3 at 6 range 0 .. 15;
   end record;

   type Receive_Ring_Type is array (Natural range <>) of Receive_Message_Descriptor_Type with
      Pack => True;

   ----------------------------------------------------------------------------
   -- Transmit Message Descriptor
   ----------------------------------------------------------------------------

   type TMD0_Type is
   record
      LADR : Bits_16;
   end record with
      Bit_Order => Low_Order_First,
      Size      => 16;
   for TMD0_Type use
   record
      LADR at 0 range 0 .. 15;
   end record;

   type TMD1_Type is
   record
      HADR    : Bits_8;
      ENP     : Boolean;
      STP     : Boolean;
      DEF     : Boolean;
      ONE     : Boolean;
      MORE    : Boolean;
      ADD_FCS : Boolean;
      ERR     : Boolean;
      OWN     : Boolean;
   end record with
      Bit_Order => Low_Order_First,
      Size      => 16;
   for TMD1_Type use
   record
      HADR    at 0 range 0 .. 7;
      ENP     at 0 range 8 .. 8;
      STP     at 0 range 9 .. 9;
      DEF     at 0 range 10 .. 10;
      ONE     at 0 range 11 .. 11;
      MORE    at 0 range 12 .. 12;
      ADD_FCS at 0 range 13 .. 13;
      ERR     at 0 range 14 .. 14;
      OWN     at 0 range 15 .. 15;
   end record;

   type TMD2_Type is
   record
      BCNT : Bits_12;
      ONES : Bits_4 := 2#1111#;
   end record with
      Bit_Order => Low_Order_First,
      Size      => 16;
   for TMD2_Type use
   record
      BCNT at 0 range 0 .. 11;
      ONES at 0 range 12 .. 15;
   end record;

   type TMD3_Type is
   record
      TDR  : Bits_10;
      RTRY : Boolean;
      LCAR : Boolean;
      LCOL : Boolean;
      RES  : Bits_1;
      UFLO : Boolean;
      BUFF : Boolean;
   end record with
      Bit_Order => Low_Order_First,
      Size      => 16;
   for TMD3_Type use
   record
      TDR  at 0 range 0 .. 9;
      RTRY at 0 range 10 .. 10;
      LCAR at 0 range 11 .. 11;
      LCOL at 0 range 12 .. 12;
      RES  at 0 range 13 .. 13;
      UFLO at 0 range 14 .. 14;
      BUFF at 0 range 15 .. 15;
   end record;

   -- Descriptor ring for outgoing packets
   -- must start on a quadword boundary (A0 .. A2 = 0)
   type Transmit_Message_Descriptor_Type is
   record
      TMD0 : TMD0_Type;
      TMD1 : TMD1_Type;
      TMD2 : TMD2_Type;
      TMD3 : TMD3_Type;
   end record with
      Alignment               => 2**3,
      Size                    => 16 * 4,
      Suppress_Initialization => True;
   for Transmit_Message_Descriptor_Type use
   record
      TMD0 at 0 range 0 .. 15;
      TMD1 at 2 range 0 .. 15;
      TMD2 at 4 range 0 .. 15;
      TMD3 at 6 range 0 .. 15;
   end record;

   type Transmit_Ring_Type is array (Natural range <>) of Transmit_Message_Descriptor_Type with
      Pack => True;

   ----------------------------------------------------------------------------
   -- Initialization Block
   ----------------------------------------------------------------------------

   type Mode_Register_Type is
   record
      DRX      : Boolean;
      DTX      : Boolean;
      LOOPB    : Boolean;
      DTCR     : Boolean;
      COLL     : Boolean;
      DRTY     : Boolean;
      INTL     : Boolean;
      Reserved : Bits_8;
      PROM     : Boolean;
   end record with
      Alignment => 2,
      Bit_Order => Low_Order_First,
      Size      => 16;
   for Mode_Register_Type use
   record
      DRX      at 0 range 0 .. 0;
      DTX      at 0 range 1 .. 1;
      LOOPB    at 0 range 2 .. 2;
      DTCR     at 0 range 3 .. 3;
      COLL     at 0 range 4 .. 4;
      DRTY     at 0 range 5 .. 5;
      INTL     at 0 range 6 .. 6;
      Reserved at 0 range 7 .. 14;
      PROM     at 0 range 15 .. 15;
   end record;

   type Ring_Descriptor_Pointer_Type is
   record
      Reserved1    : Bits_3;
      Ring_Pointer : Bits_21;
      Reserved2    : Bits_5;
      Length       : Bits_3;
   end record with
      Bit_Order => Low_Order_First,
      Size      => 32;
   for Ring_Descriptor_Pointer_Type use
   record
      Reserved1    at 0 range 0 .. 2;
      Ring_Pointer at 0 range 3 .. 23;
      Reserved2    at 0 range 24 .. 28;
      Length       at 0 range 29 .. 31;
   end record;

   type Initialization_Block_Type is
   record
      MODE   : Mode_Register_Type;
      PADR0  : Unsigned_8;                   -- MAC byte0 (MSB)
      PADR1  : Unsigned_8;                   -- MAC byte1
      PADR2  : Unsigned_8;                   -- MAC byte2
      PADR3  : Unsigned_8;                   -- MAC byte3
      PADR4  : Unsigned_8;                   -- MAC byte4
      PADR5  : Unsigned_8;                   -- MAC byte5 (LSB)
      LADRF0 : Unsigned_8;
      LADRF1 : Unsigned_8;
      LADRF2 : Unsigned_8;
      LADRF3 : Unsigned_8;
      LADRF4 : Unsigned_8;
      LADRF5 : Unsigned_8;
      LADRF6 : Unsigned_8;
      LADRF7 : Unsigned_8;
      RDRA   : Ring_Descriptor_Pointer_Type;
      TDRA   : Ring_Descriptor_Pointer_Type;
   end record with
      Alignment => 2,
      Size      => 24 * 8;
   for Initialization_Block_Type use
   record
      MODE   at 0 range 0 .. 15;
      -- offset 2,3: seen as the U16 value MAC[0..1]
      PADR1  at 2 range 0 .. 7;   -- LE addressing: MAC[1] is at +0
      PADR0  at 3 range 0 .. 7;   -- LE addressing: MAC[0] is at +1
      -- offset 4,5: seen as the U16 value MAC[2..3]
      PADR3  at 4 range 0 .. 7;   -- LE addressing: MAC[3] is at +0
      PADR2  at 5 range 0 .. 7;   -- LE addressing: MAC[2] is at +1
      -- offset 6,7: seen as the U16 value MAC[4..5]
      PADR5  at 6 range 0 .. 7;   -- LE addressing: MAC[5] is at +0
      PADR4  at 7 range 0 .. 7;   -- LE addressing: MAC[4] is at +1
      LADRF1 at 8 range 0 .. 7;
      LADRF0 at 9 range 0 .. 7;
      LADRF3 at 10 range 0 .. 7;
      LADRF2 at 11 range 0 .. 7;
      LADRF5 at 12 range 0 .. 7;
      LADRF4 at 13 range 0 .. 7;
      LADRF7 at 14 range 0 .. 7;
      LADRF6 at 15 range 0 .. 7;
      RDRA   at 16 range 0 .. 31;
      TDRA   at 20 range 0 .. 31;
   end record;

   ----------------------------------------------------------------------------
   -- Am7990 descriptor
   ----------------------------------------------------------------------------

   type Am7990_Flags_Type is
   record
      null;
   end record;

   type Port_Read_16_Ptr is access function (Port : Address) return Unsigned_16;
   type Port_Write_16_Ptr is access procedure (Port : in Address; Value : in Unsigned_16);

   type Am7990_Descriptor_Type is
   record
      Base_Address  : Address;
      Scale_Address : Address_Shift;
      Flags         : Am7990_Flags_Type;
      Read_16       : not null Port_Read_16_Ptr := MMIO.ReadN_U16'Access;
      Write_16      : not null Port_Write_16_Ptr := MMIO.WriteN_U16'Access;
   end record;

   Am7990_DESCRIPTOR_INVALID : constant Am7990_Descriptor_Type :=
      (
       Base_Address  => Null_Address,
       Scale_Address => 0,
       Flags         => (null record),
       Read_16       => MMIO.ReadN_U16'Access,
       Write_16      => MMIO.WriteN_U16'Access
      );

   ----------------------------------------------------------------------------
   -- Am7990 register read/write
   ----------------------------------------------------------------------------

   function Register_Read (
                           Descriptor : Am7990_Descriptor_Type;
                           Register   : Am7990_Register_Type
                          ) return Unsigned_16 with
      Inline => True;

   procedure Register_Write (
                             Descriptor : in Am7990_Descriptor_Type;
                             Register   : in Am7990_Register_Type;
                             Value      : in Unsigned_16
                            ) with
      Inline => True;

end Am7990;

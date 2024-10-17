-----------------------------------------------------------------------------------------------------------------------
--                                                     SweetAda                                                      --
-----------------------------------------------------------------------------------------------------------------------
-- __HDS__                                                                                                           --
-- __FLN__ pl011.adb                                                                                                 --
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

with System.Storage_Elements;
with Ada.Unchecked_Conversion;
with Bits;

package body PL011
   is

   --========================================================================--
   --                                                                        --
   --                                                                        --
   --                           Local declarations                           --
   --                                                                        --
   --                                                                        --
   --========================================================================--

   use System.Storage_Elements;
   use Bits;

   ----------------------------------------------------------------------------
   -- Register types
   ----------------------------------------------------------------------------

   type Register_Type is
      (
       UARTDR, UARTRSR, UARTECR, UARTFR, UARTILPR, UARTIBRD, UARTFBRD,
       UARTLCR_H, UARTCR, UARTIFLS, UARTIMSC, UARTRIS, UARTMIS, UARTICR,
       UARTDMACR
      );

   Register_Offset : constant array (Register_Type) of Storage_Offset :=
      [
       UARTDR    => 16#00#,
       UARTRSR   => 16#04#,
       UARTECR   => 16#04#,
       UARTFR    => 16#18#,
       UARTILPR  => 16#20#,
       UARTIBRD  => 16#24#,
       UARTFBRD  => 16#28#,
       UARTLCR_H => 16#2C#,
       UARTCR    => 16#30#,
       UARTIFLS  => 16#34#,
       UARTIMSC  => 16#38#,
       UARTRIS   => 16#3C#,
       UARTMIS   => 16#40#,
       UARTICR   => 16#44#,
       UARTDMACR => 16#48#
      ];

   type UARTDR_Type is record
      DATA     : Unsigned_8; -- Receive (read) data character. Transmit (write) data character.
      FE       : Boolean;    -- Framing error.
      PE       : Boolean;    -- Parity error.
      BE       : Boolean;    -- Break error.
      OE       : Boolean;    -- Overrun error.
      Reserved : Bits_4;
   end record
      with Bit_Order => Low_Order_First,
           Size      => 16;
   for UARTDR_Type use record
      DATA     at 0 range  0 ..  7;
      FE       at 0 range  8 ..  8;
      PE       at 0 range  9 ..  9;
      BE       at 0 range 10 .. 10;
      OE       at 0 range 11 .. 11;
      Reserved at 0 range 12 .. 15;
   end record;

   function To_U16 is new Ada.Unchecked_Conversion (UARTDR_Type, Unsigned_16);
   function To_UARTDR is new Ada.Unchecked_Conversion (Unsigned_16, UARTDR_Type);

   type UARTFR_Type is record
      CTS      : Boolean; -- Clear to send.
      DSR      : Boolean; -- Data set ready.
      DCD      : Boolean; -- Data carrier detect.
      BUSY     : Boolean; -- UART busy.
      RXFE     : Boolean; -- Receive FIFO empty.
      TXFF     : Boolean; -- Transmit FIFO full.
      RXFF     : Boolean; -- Receive FIFO full.
      TXFE     : Boolean; -- Transmit FIFO empty.
      RI       : Boolean; -- Ring indicator.
      Reserved : Bits_7;
   end record
      with Bit_Order => Low_Order_First,
           Size      => 16;
   for UARTFR_Type use record
      CTS      at 0 range 0 ..  0;
      DSR      at 0 range 1 ..  1;
      DCD      at 0 range 2 ..  2;
      BUSY     at 0 range 3 ..  3;
      RXFE     at 0 range 4 ..  4;
      TXFF     at 0 range 5 ..  5;
      RXFF     at 0 range 6 ..  6;
      TXFE     at 0 range 7 ..  7;
      RI       at 0 range 8 ..  8;
      Reserved at 0 range 9 .. 15;
   end record;

   function To_U16 is new Ada.Unchecked_Conversion (UARTFR_Type, Unsigned_16);
   function To_UARTFR is new Ada.Unchecked_Conversion (Unsigned_16, UARTFR_Type);

   type UARTCR_Type is record
      UARTEN   : Boolean; -- UART enable.
      SIREN    : Boolean; -- SIR enable.
      SIRLP    : Boolean; -- SIR low-power IrDA mode.
      Reserved : Bits_4;
      LBE      : Boolean; -- Loopback enable.
      TXE      : Boolean; -- Transmit enable.
      RXE      : Boolean; -- Receive enable.
      DTR      : Boolean; -- Data transmit ready.
      RTS      : Boolean; -- Request to send.
      Out1     : Boolean; -- This bit is the complement of the UART Out1 (nUARTOut1) modem status output.
      Out2     : Boolean; -- This bit is the complement of the UART Out2 (nUARTOut2) modem status output.
      RTSEn    : Boolean; -- RTS hardware flow control enable
      CTSEn    : Boolean; -- CTS hardware flow control enable
   end record
      with Bit_Order => Low_Order_First,
           Size      => 16;
   for UARTCR_Type use record
      UARTEN   at 0 range  0 ..  0;
      SIREN    at 0 range  1 ..  1;
      SIRLP    at 0 range  2 ..  2;
      Reserved at 0 range  3 ..  6;
      LBE      at 0 range  7 ..  7;
      TXE      at 0 range  8 ..  8;
      RXE      at 0 range  9 ..  9;
      DTR      at 0 range 10 .. 10;
      RTS      at 0 range 11 .. 11;
      Out1     at 0 range 12 .. 12;
      Out2     at 0 range 13 .. 13;
      RTSEn    at 0 range 14 .. 14;
      CTSEn    at 0 range 15 .. 15;
   end record;

   function To_U16 is new Ada.Unchecked_Conversion (UARTCR_Type, Unsigned_16);
   function To_UARTCR is new Ada.Unchecked_Conversion (Unsigned_16, UARTCR_Type);

   -- Local subprograms

   function Register_Read
      (Descriptor : Descriptor_Type;
       Register   : Register_Type)
      return Unsigned_8
      with Inline => True;
   procedure Register_Write
      (Descriptor : in Descriptor_Type;
       Register   : in Register_Type;
       Value      : in Unsigned_8)
      with Inline => True;
   function Register_Read
      (Descriptor : Descriptor_Type;
       Register   : Register_Type)
      return Unsigned_16
      with Inline => True;
   procedure Register_Write
      (Descriptor : in Descriptor_Type;
       Register   : in Register_Type;
       Value      : in Unsigned_16)
      with Inline => True;

   --========================================================================--
   --                                                                        --
   --                                                                        --
   --                           Package subprograms                          --
   --                                                                        --
   --                                                                        --
   --========================================================================--

   ----------------------------------------------------------------------------
   -- Register_Read (8-bit)
   ----------------------------------------------------------------------------
   function Register_Read
      (Descriptor : Descriptor_Type;
       Register   : Register_Type)
      return Unsigned_8
      is
   begin
      return Descriptor.Read_8 (Descriptor.Base_Address + Register_Offset (Register));
   end Register_Read;

   ----------------------------------------------------------------------------
   -- Register_Write (8-bit)
   ----------------------------------------------------------------------------
   procedure Register_Write
      (Descriptor : in Descriptor_Type;
       Register   : in Register_Type;
       Value      : in Unsigned_8)
      is
   begin
      Descriptor.Write_8 (Descriptor.Base_Address + Register_Offset (Register), Value);
   end Register_Write;

   ----------------------------------------------------------------------------
   -- Register_Read (16-bit)
   ----------------------------------------------------------------------------
   function Register_Read
      (Descriptor : Descriptor_Type;
       Register   : Register_Type)
      return Unsigned_16
      is
   begin
      return Descriptor.Read_16 (Descriptor.Base_Address + Register_Offset (Register));
   end Register_Read;

   ----------------------------------------------------------------------------
   -- Register_Write (16-bit)
   ----------------------------------------------------------------------------
   procedure Register_Write
      (Descriptor : in Descriptor_Type;
       Register   : in Register_Type;
       Value      : in Unsigned_16)
      is
   begin
      Descriptor.Write_16 (Descriptor.Base_Address + Register_Offset (Register), Value);
   end Register_Write;

   ----------------------------------------------------------------------------
   -- Init
   ----------------------------------------------------------------------------
   procedure Init
      (Descriptor : in Descriptor_Type)
      is
   begin
      Register_Write
         (Descriptor,
          UARTCR,
          To_U16 (UARTCR_Type'(
             UARTEN => True,
             SIREN  => False,
             SIRLP  => False,
             LBE    => False,
             TXE    => True,
             RXE    => True,
             DTR    => False,
             RTS    => False,
             Out1   => False,
             Out2   => False,
             RTSEn  => False,
             CTSEn  => False,
             others => 0
             )));
   end Init;

   ----------------------------------------------------------------------------
   -- TX
   ----------------------------------------------------------------------------
   procedure TX
      (Descriptor : in Descriptor_Type;
       Data       : in Unsigned_8)
      is
   begin
      -- wait for transmitter available
      loop
         exit when not To_UARTFR (Register_Read (Descriptor, UARTFR)).TXFF;
      end loop;
      Register_Write (Descriptor, UARTDR, Data);
   end TX;

   ----------------------------------------------------------------------------
   -- RX
   ----------------------------------------------------------------------------
   procedure RX
      (Descriptor : in     Descriptor_Type;
       Data       :    out Unsigned_8)
      is
   begin
      -- wait for receiver available
      loop
         exit when To_UARTFR (Register_Read (Descriptor, UARTFR)).RXFF;
      end loop;
      Data := To_UARTDR (Register_Read (Descriptor, UARTDR)).DATA;
   end RX;

end PL011;

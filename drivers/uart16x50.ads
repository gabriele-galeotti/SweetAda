-----------------------------------------------------------------------------------------------------------------------
--                                                     SweetAda                                                      --
-----------------------------------------------------------------------------------------------------------------------
-- __HDS__                                                                                                           --
-- __FLN__ uart16x50.ads                                                                                             --
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
with MMIO;
with FIFO;

package UART16x50
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

   ----------------------------------------------------------------------------
   -- NS16C450 Universal Asynchronous Receiver/Transmitter
   -- Microcommunication Elements Databook 400066 Rev. 1
   ----------------------------------------------------------------------------

   type Model_Type is (UARTNONE, UART16450, UART16550, UART16650, UART16750);

   type Flags_Type is record
      PC_UART : Boolean;
   end record;

   type Port_Read_8_Ptr is access function (Port : in Address) return Unsigned_8;
   type Port_Write_8_Ptr is access procedure (Port : in Address; Value : in Unsigned_8);

   type Descriptor_Type is record
      Uart_Model    : Model_Type                := UARTNONE;
      Base_Address  : Address                   := Null_Address;
      Scale_Address : Address_Shift             := 0;
      Baud_Clock    : Positive                  := 1;
      Flags         : Flags_Type                := (PC_UART => False);
      Read_8        : not null Port_Read_8_Ptr  := MMIO.ReadN_U8'Access;
      Write_8       : not null Port_Write_8_Ptr := MMIO.WriteN_U8'Access;
      Data_Queue    : aliased FIFO.Queue_Type   := ([others => 0], 0, 0, 0) with Volatile => True;
   end record;

   DESCRIPTOR_INVALID : constant Descriptor_Type :=
      (
       Uart_Model    => UARTNONE,
       Base_Address  => Null_Address,
       Scale_Address => 0,
       Baud_Clock    => 1,
       Flags         => (PC_UART => False),
       Read_8        => MMIO.ReadN_U8'Access,
       Write_8       => MMIO.WriteN_U8'Access,
       -- Data_Queue    => FIFO.QUEUE_DEFAULT
       Data_Queue    => ([others => 0], 0, 0, 0)
      );

   procedure Baud_Rate_Set
      (D         : in Descriptor_Type;
       Baud_Rate : in Integer);

   procedure TX
      (D    : in out Descriptor_Type;
       Data : in     Unsigned_8);

   procedure RX
      (D    : in out Descriptor_Type;
       Data :    out Unsigned_8);

   procedure Receive
      (Descriptor_Address : in System.Address);

   procedure Init
      (D : in out Descriptor_Type);

end UART16x50;

-----------------------------------------------------------------------------------------------------------------------
--                                                     SweetAda                                                      --
-----------------------------------------------------------------------------------------------------------------------
-- __HDS__                                                                                                           --
-- __FLN__ uartioemu.adb                                                                                             --
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

with System.Storage_Elements;
with Ada.Unchecked_Conversion;
with LLutils;

package body UARTIOEMU is

   --========================================================================--
   --                                                                        --
   --                                                                        --
   --                           Local declarations                           --
   --                                                                        --
   --                                                                        --
   --========================================================================--

   use System.Storage_Elements;
   use LLutils;

   ----------------------------------------------------------------------------
   -- Register types
   ----------------------------------------------------------------------------

   type UartIOEMU_Register_Type is (RHR, THR, CR, SR);

   UartIOEMU_Register_Offset : constant array (UartIOEMU_Register_Type) of Storage_Offset :=
      [
       RHR => 0,
       THR => 0,
       CR  => 1,
       SR  => 2
      ];

   -- Control Register

   type CR_Type is
   record
      RXIRQENABLE : Boolean;
      TXIRQENABLE : Boolean;
      Unused      : Bits_6_Zeroes := Bits_6_0;
   end record with
      Bit_Order => Low_Order_First,
      Size      => 8;
   for CR_Type use
   record
      RXIRQENABLE at 0 range 0 .. 0;
      TXIRQENABLE at 0 range 1 .. 1;
      Unused      at 0 range 2 .. 7;
   end record;

   function To_U8 is new Ada.Unchecked_Conversion (CR_Type, Unsigned_8);
   function To_CR is new Ada.Unchecked_Conversion (Unsigned_8, CR_Type);

   -- Status Register

   type SR_Type is
   record
      RXREADY : Boolean;
      TXEMPTY : Boolean;
      Unused  : Bits_6_Zeroes := Bits_6_0;
   end record with
      Bit_Order => Low_Order_First,
      Size      => 8;
   for SR_Type use
   record
      RXREADY at 0 range 0 .. 0;
      TXEMPTY at 0 range 1 .. 1;
      Unused  at 0 range 2 .. 7;
   end record;

   function To_U8 is new Ada.Unchecked_Conversion (SR_Type, Unsigned_8);
   function To_SR is new Ada.Unchecked_Conversion (Unsigned_8, SR_Type);

   -- Local subprograms

   function Register_Read (
                           Descriptor : UartIOEMU_Descriptor_Type;
                           Register   : UartIOEMU_Register_Type
                          ) return Unsigned_8 with
      Inline => True;

   procedure Register_Write (
                             Descriptor : in UartIOEMU_Descriptor_Type;
                             Register   : in UartIOEMU_Register_Type;
                             Value      : in Unsigned_8
                            ) with
      Inline => True;

   --========================================================================--
   --                                                                        --
   --                                                                        --
   --                           Package subprograms                          --
   --                                                                        --
   --                                                                        --
   --========================================================================--

   ----------------------------------------------------------------------------
   -- Register_Read
   ----------------------------------------------------------------------------
   function Register_Read (
                           Descriptor : UartIOEMU_Descriptor_Type;
                           Register   : UartIOEMU_Register_Type
                          ) return Unsigned_8 is
   begin
      return Descriptor.Read (Build_Address (
                                             Descriptor.Base_Address,
                                             UartIOEMU_Register_Offset (Register),
                                             Descriptor.Scale_Address
                                            ));
   end Register_Read;

   ----------------------------------------------------------------------------
   -- Register_Write
   ----------------------------------------------------------------------------
   procedure Register_Write (
                             Descriptor : in UartIOEMU_Descriptor_Type;
                             Register   : in UartIOEMU_Register_Type;
                             Value      : in Unsigned_8
                            ) is
   begin
      Descriptor.Write (Build_Address (
                                       Descriptor.Base_Address,
                                       UartIOEMU_Register_Offset (Register),
                                       Descriptor.Scale_Address
                                      ), Value);
   end Register_Write;

   ----------------------------------------------------------------------------
   -- Init
   ----------------------------------------------------------------------------
   procedure Init (Descriptor : in UartIOEMU_Descriptor_Type) is
      RX_Irqenable : Boolean := False;
      TX_Irqenable : constant Boolean := False; -- __FIX__ constant to quit warning
   begin
      if Descriptor.Irq /= 0 then
         RX_Irqenable := True;
         -- TX_Irqenable := True;  __FIX__
      end if;
      Register_Write (Descriptor, CR, To_U8 (CR_Type'((
                                                       RXIRQENABLE => RX_Irqenable,
                                                       TXIRQENABLE => TX_Irqenable,
                                                       others      => 0
                                                      ))));
      Register_Write (Descriptor, SR, To_U8 (SR_Type'((
                                                       RXREADY => True,
                                                       TXEMPTY => True,
                                                       others  => 0
                                                      ))));
   end Init;

   ----------------------------------------------------------------------------
   -- TX
   ----------------------------------------------------------------------------
   procedure TX (Descriptor : in UartIOEMU_Descriptor_Type; Data : in Unsigned_8) is
   begin
      Register_Write (Descriptor, THR, Data);
   end TX;

   ----------------------------------------------------------------------------
   -- RX
   ----------------------------------------------------------------------------
   procedure RX (Descriptor : UartIOEMU_Descriptor_Type; Data : out Unsigned_8) is
   begin
      Data := Register_Read (Descriptor, RHR);
   end RX;

   ----------------------------------------------------------------------------
   -- RXIrqActive
   ----------------------------------------------------------------------------
   function RXIrqActive (Descriptor : UartIOEMU_Descriptor_Type) return Boolean is
   begin
      if
         To_CR (Register_Read (Descriptor, CR)).RXIRQENABLE and then
         To_SR (Register_Read (Descriptor, SR)).RXREADY
      then
         return True;
      else
         return False;
      end if;
   end RXIrqActive;

   ----------------------------------------------------------------------------
   -- RXClearIrq
   ----------------------------------------------------------------------------
   procedure RXClearIrq (Descriptor : in UartIOEMU_Descriptor_Type) is
      Status_Value : SR_Type;
   begin
      Status_Value.RXREADY := True;
      Register_Write (Descriptor, SR, To_U8 (Status_Value));
   end RXClearIrq;

end UARTIOEMU;

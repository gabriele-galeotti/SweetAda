-----------------------------------------------------------------------------------------------------------------------
--                                                     SweetAda                                                      --
-----------------------------------------------------------------------------------------------------------------------
-- __HDS__                                                                                                           --
-- __FLN__ uartioemu.adb                                                                                             --
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

   type UartIOEMU_Register_Type is (RHR, THR, CONTROL, STATUS);

   UartIOEMU_Register_Offset : constant array (UartIOEMU_Register_Type) of Storage_Offset :=
      (
       RHR     => 0,
       THR     => 0,
       CONTROL => 1,
       STATUS  => 2
      );

   -- Control Register

   type UartIOEMU_Control_Register_Type is
   record
      RXIRQENABLE : Boolean;
      TXIRQENABLE : Boolean;
      Unused      : Bits_6_Zeroes := Bits_6_0;
   end record with
      Bit_Order => Low_Order_First,
      Size      => 8;
   for UartIOEMU_Control_Register_Type use
   record
      RXIRQENABLE at 0 range 0 .. 0;
      TXIRQENABLE at 0 range 1 .. 1;
      Unused      at 0 range 2 .. 7;
   end record;

   -- Status Register

   type UartIOEMU_Status_Register_Type is
   record
      RXREADY : Boolean;
      TXEMPTY : Boolean;
      Unused  : Bits_6_Zeroes := Bits_6_0;
   end record with
      Bit_Order => Low_Order_First,
      Size      => 8;
   for UartIOEMU_Status_Register_Type use
   record
      RXREADY at 0 range 0 .. 0;
      TXEMPTY at 0 range 1 .. 1;
      Unused  at 0 range 2 .. 7;
   end record;

   function Register_Read (
                           Descriptor : UartIOEMU_Descriptor_Type;
                           Register   : UartIOEMU_Register_Type
                          ) return Unsigned_8;
   -- not inlined to avoid code bloating

   procedure Register_Write (
                             Descriptor : in UartIOEMU_Descriptor_Type;
                             Register   : in UartIOEMU_Register_Type;
                             Value      : in Unsigned_8
                            );
   -- not inlined to avoid code bloating

   --========================================================================--
   --                                                                        --
   --                                                                        --
   --                           Package subprograms                          --
   --                                                                        --
   --                                                                        --
   --========================================================================--

   function Register_Read (
                           Descriptor : UartIOEMU_Descriptor_Type;
                           Register   : UartIOEMU_Register_Type
                          ) return Unsigned_8 is
   begin
      return Descriptor.Read (
                              Build_Address (
                                             Descriptor.Base_Address,
                                             UartIOEMU_Register_Offset (Register),
                                             Descriptor.Scale_Address
                                            )
                             );
   end Register_Read;

   procedure Register_Write (
                             Descriptor : in UartIOEMU_Descriptor_Type;
                             Register   : in UartIOEMU_Register_Type;
                             Value      : in Unsigned_8
                            ) is
   begin
      Descriptor.Write (
                        Build_Address (
                                       Descriptor.Base_Address,
                                       UartIOEMU_Register_Offset (Register),
                                       Descriptor.Scale_Address
                                      ),
                        Value
                       );
   end Register_Write;

   ----------------------------------------------------------------------------
   -- Local Subprograms (generic)
   ----------------------------------------------------------------------------

   generic
      Register_Type : in UartIOEMU_Register_Type;
      type Output_Register_Type is private;
   function Typed_Register_Read (
                                 Descriptor : UartIOEMU_Descriptor_Type
                                ) return Output_Register_Type;
   pragma Inline (Typed_Register_Read);
   function Typed_Register_Read (
                                 Descriptor : UartIOEMU_Descriptor_Type
                                ) return Output_Register_Type is
      function Convert is new Ada.Unchecked_Conversion (Unsigned_8, Output_Register_Type);
   begin
      return Convert (Register_Read (Descriptor, Register_Type));
   end Typed_Register_Read;

   generic
      Register_Type : in UartIOEMU_Register_Type;
      type Input_Register_Type is private;
   procedure Typed_Register_Write (
                                   Descriptor : in UartIOEMU_Descriptor_Type;
                                   Value      : in Input_Register_Type
                                  );
   pragma Inline (Typed_Register_Write);
   procedure Typed_Register_Write (
                                   Descriptor : in UartIOEMU_Descriptor_Type;
                                   Value      : in Input_Register_Type
                                  ) is
      function Convert is new Ada.Unchecked_Conversion (Input_Register_Type, Unsigned_8);
   begin
      Register_Write (Descriptor, Register_Type, Convert (Value));
   end Typed_Register_Write;

   ----------------------------------------------------------------------------
   -- Registers Read/Write subprograms
   ----------------------------------------------------------------------------

   function RHR_Read (Descriptor : UartIOEMU_Descriptor_Type) return Unsigned_8;
   pragma Inline (RHR_Read);
   function RHR_Read (Descriptor : UartIOEMU_Descriptor_Type) return Unsigned_8 is
   begin
      return Register_Read (Descriptor, RHR);
   end RHR_Read;

   procedure THR_Write (Descriptor : in UartIOEMU_Descriptor_Type; Value : in Unsigned_8);
   pragma Inline (THR_Write);
   procedure THR_Write (Descriptor : in UartIOEMU_Descriptor_Type; Value : in Unsigned_8) is
   begin
      Register_Write (Descriptor, THR, Value);
   end THR_Write;

   function CONTROL_Read is new Typed_Register_Read (CONTROL, UartIOEMU_Control_Register_Type);
   pragma Inline (CONTROL_Read);

   procedure CONTROL_Write is new Typed_Register_Write (CONTROL, UartIOEMU_Control_Register_Type);
   pragma Inline (CONTROL_Write);

   function STATUS_Read is new Typed_Register_Read (STATUS, UartIOEMU_Status_Register_Type);
   pragma Inline (STATUS_Read);

   procedure STATUS_Write is new Typed_Register_Write (STATUS, UartIOEMU_Status_Register_Type);
   pragma Inline (STATUS_Write);

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
      CONTROL_Write (Descriptor, (RXIRQENABLE => RX_Irqenable, TXIRQENABLE => TX_Irqenable, others => 0));
      STATUS_Write (Descriptor, (RXREADY => True, TXEMPTY => True, others => 0));
   end Init;

   ----------------------------------------------------------------------------
   -- TX
   ----------------------------------------------------------------------------
   procedure TX (Descriptor : in UartIOEMU_Descriptor_Type; Data : in Unsigned_8) is
   begin
      THR_Write (Descriptor, Data);
   end TX;

   ----------------------------------------------------------------------------
   -- RX
   ----------------------------------------------------------------------------
   procedure RX (Descriptor : UartIOEMU_Descriptor_Type; Data : out Unsigned_8) is
   begin
      Data := RHR_Read (Descriptor);
   end RX;

   ----------------------------------------------------------------------------
   -- RXIrqActive
   ----------------------------------------------------------------------------
   function RXIrqActive (Descriptor : UartIOEMU_Descriptor_Type) return Boolean is
   begin
      if
         CONTROL_Read (Descriptor).RXIRQENABLE and then
         STATUS_Read (Descriptor).RXREADY
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
      Status_Value : UartIOEMU_Status_Register_Type;
   begin
      Status_Value.RXREADY := True;
      STATUS_Write (Descriptor, Status_Value);
   end RXClearIrq;

end UARTIOEMU;

-----------------------------------------------------------------------------------------------------------------------
--                                                     SweetAda                                                      --
-----------------------------------------------------------------------------------------------------------------------
-- __HDS__                                                                                                           --
-- __FLN__ leon3.ads                                                                                                 --
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
with Interfaces;
with Bits;

package LEON3 is

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
   -- Timer
   ----------------------------------------------------------------------------

   type GPTimer_Configuration_Type is
   record
      Timers    : Natural range 0 .. 7;
      IRQ       : Natural range 0 .. 31;
      SI        : Boolean;
      DF        : Boolean;
      Reserved1 : Bits_6;
      -- avoid "multi-byte field specified with non-standard Bit_Order"
      Reserved2 : Bits_8;
      Reserved3 : Bits_8;
   end record with
      Bit_Order => Low_Order_First,
      Size      => 32;
   for GPTimer_Configuration_Type use
   record
      Timers    at 3 range 0 .. 2;
      IRQ       at 3 range 3 .. 7;
      SI        at 2 range 0 .. 0;
      DF        at 2 range 1 .. 1;
      Reserved1 at 2 range 2 .. 7;
      Reserved2 at 1 range 0 .. 7;
      Reserved3 at 0 range 0 .. 7;
   end record;

   type GPTimer_Control_Register_Type is
   record
      EN        : Boolean;
      RS        : Boolean;
      LD        : Boolean;
      IE        : Boolean;
      IP        : Boolean;
      CH        : Boolean;
      DH        : Boolean;
      Reserved1 : Bits_1;
      -- avoid "multi-byte field specified with non-standard Bit_Order"
      Reserved2 : Bits_8;
      Reserved3 : Bits_8;
      Reserved4 : Bits_8;
   end record with
      Bit_Order => Low_Order_First,
      Size      => 32;
   for GPTimer_Control_Register_Type use
   record
      EN        at 3 range 0 .. 0;
      RS        at 3 range 1 .. 1;
      LD        at 3 range 2 .. 2;
      IE        at 3 range 3 .. 3;
      IP        at 3 range 4 .. 4;
      CH        at 3 range 5 .. 5;
      DH        at 3 range 6 .. 6;
      Reserved1 at 3 range 7 .. 7;
      Reserved2 at 2 range 0 .. 7;
      Reserved3 at 1 range 0 .. 7;
      Reserved4 at 0 range 0 .. 7;
   end record;

   type GPTimer_Type is
   record
      Scaler_Value        : Unsigned_32 range 0 .. 2**16 - 1;
      Scaler_Reload_Value : Unsigned_32 range 0 .. 2**16 - 1;
      Configuration       : Unsigned_32;
      Unused1             : Unsigned_32;
      Counter_1           : Unsigned_32;
      Reload_1            : Unsigned_32;
      Control_Register_1  : GPTimer_Control_Register_Type;
      Unused2             : Unsigned_32;
      Counter_2           : Unsigned_32;
      Reload_2            : Unsigned_32;
      Control_Register_2  : GPTimer_Control_Register_Type;
      Unused3             : Unsigned_32;
      Counter_3           : Unsigned_32;
      Reload_3            : Unsigned_32;
      Control_Register_3  : GPTimer_Control_Register_Type;
      Unused4             : Unsigned_32;
      Counter_4           : Unsigned_32;
      Reload_4            : Unsigned_32;
      Control_Register_4  : GPTimer_Control_Register_Type;
   end record with
      Alignment => 4,
      Size      => 19 * 32;
   for GPTimer_Type use
   record
      Scaler_Value        at 16#00# range 0 .. 31;
      Scaler_Reload_Value at 16#04# range 0 .. 31;
      Configuration       at 16#08# range 0 .. 31;
      Unused1             at 16#0C# range 0 .. 31;
      Counter_1           at 16#10# range 0 .. 31;
      Reload_1            at 16#14# range 0 .. 31;
      Control_Register_1  at 16#18# range 0 .. 31;
      Unused2             at 16#1C# range 0 .. 31;
      Counter_2           at 16#20# range 0 .. 31;
      Reload_2            at 16#24# range 0 .. 31;
      Control_Register_2  at 16#28# range 0 .. 31;
      Unused3             at 16#2C# range 0 .. 31;
      Counter_3           at 16#30# range 0 .. 31;
      Reload_3            at 16#34# range 0 .. 31;
      Control_Register_3  at 16#38# range 0 .. 31;
      Unused4             at 16#3C# range 0 .. 31;
      Counter_4           at 16#40# range 0 .. 31;
      Reload_4            at 16#44# range 0 .. 31;
      Control_Register_4  at 16#48# range 0 .. 31;
   end record;

   GPTIMER_BASEADDRESS   : constant := 16#8000_0300#;

   GPTIMER : aliased GPTimer_Type with
      Address    => To_Address (GPTIMER_BASEADDRESS),
      Volatile   => True,
      Import     => True,
      Convention => Ada;

   procedure Tclk_Init;

   ----------------------------------------------------------------------------
   -- APB UART
   ----------------------------------------------------------------------------

   type UART_Status_Register_Type is
   record
      DR       : Boolean;
      TS       : Boolean;
      TE       : Boolean;
      BR       : Boolean;
      OV       : Boolean;
      PE       : Boolean;
      FE       : Boolean;
      TH       : Boolean;
      RH       : Boolean;
      TF       : Boolean;
      RF       : Boolean;
      Reserved : Bits_9;
      TCNT     : Bits_6;
      RCNT     : Bits_6;
   end record with
      Bit_Order => Low_Order_First,
      Size      => 32;
   for UART_Status_Register_Type use
   record
      DR       at 0 range 0 .. 0;
      TS       at 0 range 1 .. 1;
      TE       at 0 range 2 .. 2;
      BR       at 0 range 3 .. 3;
      OV       at 0 range 4 .. 4;
      PE       at 0 range 5 .. 5;
      FE       at 0 range 6 .. 6;
      TH       at 0 range 7 .. 7;
      RH       at 0 range 8 .. 8;
      TF       at 0 range 9 .. 9;
      RF       at 0 range 10 .. 10;
      Reserved at 0 range 11 .. 19;
      TCNT     at 0 range 20 .. 25;
      RCNT     at 0 range 26 .. 31;
   end record;

   type UART_Control_Register_Type is
   record
      RE       : Boolean;
      TE       : Boolean;
      RI       : Boolean;
      TI       : Boolean;
      PS       : Bits_1;
      PE       : Boolean;
      Unused3  : Bits_1;
      LB       : Boolean;
      Unused2  : Bits_1;
      TF       : Boolean;
      RF       : Boolean;
      DB       : Boolean;
      Unused1  : Bits_1;
      Reserved : Bits_18;
      FA       : Boolean;
   end record with
      Bit_Order => Low_Order_First,
      Size      => 32;
   for UART_Control_Register_Type use
   record
      RE       at 0 range 0 .. 0;
      TE       at 0 range 1 .. 1;
      RI       at 0 range 2 .. 2;
      TI       at 0 range 3 .. 3;
      PS       at 0 range 4 .. 4;
      PE       at 0 range 5 .. 5;
      Unused3  at 0 range 6 .. 6;
      LB       at 0 range 7 .. 7;
      Unused2  at 0 range 8 .. 8;
      TF       at 0 range 9 .. 9;
      RF       at 0 range 10 .. 10;
      DB       at 0 range 11 .. 11;
      Unused1  at 0 range 12 .. 12;
      Reserved at 0 range 13 .. 30;
      FA       at 0 range 31 .. 31;
   end record;

   type APB_UART_Type is
   record
      Data_Register       : Unsigned_32;
      Status_Register     : UART_Status_Register_Type;
      Control_Register    : UART_Control_Register_Type;
      Scaler_Register     : Unsigned_32;
      FIFO_Debug_Register : Unsigned_32;
   end record with
      Alignment => 4,
      Bit_Order => High_Order_First,
      Size      => 5 * 32;
   for APB_UART_Type use
   record
      Data_Register       at 16#00# range 0 .. 31;
      Status_Register     at 16#04# range 0 .. 31;
      Control_Register    at 16#08# range 0 .. 31;
      Scaler_Register     at 16#0C# range 0 .. 31;
      FIFO_Debug_Register at 16#10# range 0 .. 31;
   end record;

   APB_UART1_BASEADDRESS : constant := 16#8000_0100#;

   UART1 : aliased APB_UART_Type with
      Address    => To_Address (APB_UART1_BASEADDRESS),
      Volatile   => True,
      Import     => True,
      Convention => Ada;

   procedure UART1_Init;
   procedure UART1_TX (Data : in Unsigned_8);
   procedure UART1_RX (Data : out Unsigned_8);

end LEON3;

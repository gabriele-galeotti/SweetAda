-----------------------------------------------------------------------------------------------------------------------
--                                                     SweetAda                                                      --
-----------------------------------------------------------------------------------------------------------------------
-- __HDS__                                                                                                           --
-- __FLN__ leon3.ads                                                                                                 --
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

with System;
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
   use Interfaces;
   use Bits;

   GPTIMER_BASEADDRESS   : constant := 16#8000_0300#;
   APB_UART1_BASEADDRESS : constant := 16#8000_0100#;

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

   ----------------------------------------------------------------------------
   -- APB UART
   ----------------------------------------------------------------------------

   type UART_Control_Register_Type is
   record
      FA       : Boolean;
      Reserved : Bits_18;
      Unused1  : Bits_1;
      DB       : Boolean;
      RF       : Boolean;
      TF       : Boolean;
      Unused2  : Bits_1;
      LB       : Boolean;
      Unused3  : Bits_1;
      PE       : Boolean;
      PS       : Bits_1;
      TI       : Boolean;
      RI       : Boolean;
      TE       : Boolean;
      RE       : Boolean;
   end record with
      Bit_Order => High_Order_First,
      Size      => 32;
   for UART_Control_Register_Type use
   record
      FA       at 0 range 0 .. 0;
      Reserved at 0 range 1 .. 18;
      Unused1  at 2 range 3 .. 3;
      DB       at 2 range 4 .. 4;
      RF       at 2 range 5 .. 5;
      TF       at 2 range 6 .. 6;
      Unused2  at 2 range 7 .. 7;
      LB       at 3 range 0 .. 0;
      Unused3  at 3 range 1 .. 1;
      PE       at 3 range 2 .. 2;
      PS       at 3 range 3 .. 3;
      TI       at 3 range 4 .. 4;
      RI       at 3 range 5 .. 5;
      TE       at 3 range 6 .. 6;
      RE       at 3 range 7 .. 7;
   end record;

   type UART_Status_Register_Type is
   record
      Reserved : Bits_25;
      FE       : Boolean;
      PE       : Boolean;
      OV       : Boolean;
      BR       : Boolean;
      TH       : Boolean;
      TS       : Boolean;
      DR       : Boolean;
   end record with
      Bit_Order => High_Order_First,
      Size      => 32;
   for UART_Status_Register_Type use
   record
      Reserved at 0 range 0 .. 24;
      FE       at 3 range 1 .. 1;
      PE       at 3 range 2 .. 2;
      OV       at 3 range 3 .. 3;
      BR       at 3 range 4 .. 4;
      TH       at 3 range 5 .. 5;
      TS       at 3 range 6 .. 6;
      DR       at 3 range 7 .. 7;
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

   procedure Tclk_Init;

end LEON3;

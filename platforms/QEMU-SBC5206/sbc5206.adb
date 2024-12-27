-----------------------------------------------------------------------------------------------------------------------
--                                                     SweetAda                                                      --
-----------------------------------------------------------------------------------------------------------------------
-- __HDS__                                                                                                           --
-- __FLN__ sbc5206.adb                                                                                               --
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

with System;
with Configure;
with LLutils;
with MMIO;
with CFPeripherals;

package body SBC5206
   is

   --========================================================================--
   --                                                                        --
   --                                                                        --
   --                           Local declarations                           --
   --                                                                        --
   --                                                                        --
   --========================================================================--

   use System;
   use CFPeripherals;

   -- Local subprograms

   function Register_Read
      (Register : UART_Register_Type)
      return Unsigned_8
      with Inline => True;
   procedure Register_Write
      (Register : in UART_Register_Type;
       Value    : in Unsigned_8)
      with Inline => True;

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
   function Register_Read
      (Register : UART_Register_Type)
      return Unsigned_8
      is
   begin
      return MMIO.Read_U8
         (LLutils.Build_Address
            (System'To_Address (Configure.MBAR_VALUE),
             UART_Register_Offset (Register),
             0));
   end Register_Read;

   ----------------------------------------------------------------------------
   -- Register_Write
   ----------------------------------------------------------------------------
   procedure Register_Write
      (Register : in UART_Register_Type;
       Value    : in Unsigned_8)
      is
   begin
      MMIO.Write_U8
         (LLutils.Build_Address
            (System'To_Address (Configure.MBAR_VALUE),
             UART_Register_Offset (Register),
             0), Value);
   end Register_Write;

   ----------------------------------------------------------------------------
   -- TX
   ----------------------------------------------------------------------------
   procedure TX
      (Data : in Unsigned_8)
      is
   begin
      -- wait for transmitter buffer empty
      loop
         exit when To_USR (Register_Read (USR)).TxRDY;
      end loop;
      Register_Write (UTB, Data);
   end TX;

   ----------------------------------------------------------------------------
   -- RX
   ----------------------------------------------------------------------------
   procedure RX
      (Data : out Unsigned_8)
      is
   begin
      -- wait for data available
      loop
         exit when To_USR (Register_Read (USR)).RxRDY;
      end loop;
      Data := Register_Read (URB);
   end RX;

   ----------------------------------------------------------------------------
   -- Init
   ----------------------------------------------------------------------------
   procedure Init
      is
   begin
      Register_Write (UCR, To_U8 (UCR_Type'(
         RC     => RC_NONE,
         TC     => TC_NONE,
         MISC   => MISC_RESET,
         others => <>
         )));
      Register_Write (UCR, To_U8 (UCR_Type'(
         RC     => RC_NONE,
         TC     => TC_NONE,
         MISC   => MISC_RxRESET,
         others => <>
         )));
      Register_Write (UCR, To_U8 (UCR_Type'(
         RC     => RC_NONE,
         TC     => TC_NONE,
         MISC   => MISC_TxRESET,
         others => <>
         )));
      Register_Write (UCR, To_U8 (UCR_Type'(
         RC     => RC_ENABLE,
         TC     => TC_ENABLE,
         MISC   => MISC_NONE,
         others => <>
         )));
   end Init;

end SBC5206;

-----------------------------------------------------------------------------------------------------------------------
--                                                     SweetAda                                                      --
-----------------------------------------------------------------------------------------------------------------------
-- __HDS__                                                                                                           --
-- __FLN__ neorv32.adb                                                                                               --
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

package body NEORV32
   is

   --========================================================================--
   --                                                                        --
   --                                                                        --
   --                           Package subprograms                          --
   --                                                                        --
   --                                                                        --
   --========================================================================--

   -- XIRQ module

   procedure EIE_Read
      (XIRQ_CH : out Bits_32)
      is
   begin
      XIRQ_CH := EIE;
   end EIE_Read;

   procedure EIE_Enable
      (XIRQ_CH : in Bits_32)
      is
   begin
      EIE := @ or XIRQ_CH;
   end EIE_Enable;

   procedure EIE_Disable
      (XIRQ_CH : in Bits_32)
      is
   begin
      EIE := @ and not XIRQ_CH;
   end EIE_Disable;

   procedure EIP_Read
      (XIRQ_CH : out Bits_32)
      is
   begin
      XIRQ_CH := EIP;
   end EIP_Read;

   procedure EIP_Clear
      (XIRQ_CH : in Bits_32)
      is
   begin
      EIP := not XIRQ_CH;
   end EIP_Clear;

   procedure ESC_Read
      (XIRQ_CH : out Bits_32)
      is
   begin
      XIRQ_CH := ESC;
   end ESC_Read;

   procedure ESC_Ack
      (XIRQ_CH : in Bits_32)
      is
   begin
      ESC := XIRQ_CH;
   end ESC_Ack;

end NEORV32;

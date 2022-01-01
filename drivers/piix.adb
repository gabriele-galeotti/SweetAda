-----------------------------------------------------------------------------------------------------------------------
--                                                     SweetAda                                                      --
-----------------------------------------------------------------------------------------------------------------------
-- __HDS__                                                                                                           --
-- __FLN__ piix.adb                                                                                                  --
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

with Interfaces;
with Bits;
with CPU.IO;

package body PIIX is

   --========================================================================--
   --                                                                        --
   --                                                                        --
   --                           Local declarations                           --
   --                                                                        --
   --                                                                        --
   --========================================================================--

   use Interfaces;
   use Bits;
   use CPU.IO;

   --========================================================================--
   --                                                                        --
   --                                                                        --
   --                           Package subprograms                          --
   --                                                                        --
   --                                                                        --
   --========================================================================--

   ----------------------------------------------------------------------------
   -- Probe
   ----------------------------------------------------------------------------
   function Probe return Boolean is
      Success       : Boolean;
      Device_Number : Device_Number_Type with Unreferenced => True;
   begin
      Cfg_Find_Device_By_Id (BUS0, VENDOR_ID_INTEL, DEVICE_ID_PIIX3, Device_Number, Success);
      return Success;
   end Probe;

   ----------------------------------------------------------------------------
   -- Init
   ----------------------------------------------------------------------------
   procedure Init is
   begin
      -- Bus_Number, Device_Number, Function_Number, Register_Number, Value
      Cfg_Write (BUS0, 1, 0, PIRQRCA, Unsigned_8'(16#80#));
      Cfg_Write (BUS0, 1, 0, PIRQRCB, Unsigned_8'(16#80#));
      Cfg_Write (BUS0, 1, 0, PIRQRCC, Unsigned_8'(16#80#));
      Cfg_Write (BUS0, 1, 0, PIRQRCD, Unsigned_8'(16#80#));
      -- PIC ELCR
      CPU.IO.PortOut (16#04D0#, Unsigned_8'(16#20#)); -- RTL8029 bit5, Irq5
      CPU.IO.PortOut (16#04D1#, Unsigned_8'(16#00#));
      -- QEMU RTL8029 Irq5
      Cfg_Write (BUS0, 1, 0, PIRQRCC, Unsigned_8'(16#05#));
   end Init;

   ----------------------------------------------------------------------------
   -- Interrupt_Set
   ----------------------------------------------------------------------------
   procedure Interrupt_Set is
   begin
      null;
   end Interrupt_Set;

end PIIX;

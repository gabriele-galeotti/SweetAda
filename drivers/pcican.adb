-----------------------------------------------------------------------------------------------------------------------
--                                                     SweetAda                                                      --
-----------------------------------------------------------------------------------------------------------------------
-- __HDS__                                                                                                           --
-- __FLN__ pcican.adb                                                                                                --
-- __DSC__                                                                                                           --
-- __HSH__ e69de29bb2d1d6434b8b29ae775ad8c2e48c5391                                                                  --
-- __HDE__                                                                                                           --
-----------------------------------------------------------------------------------------------------------------------
-- Copyright (C) 2020-2023 Gabriele Galeotti                                                                         --
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
with CPU.IO;
with Console;

package body PCICAN is

   --========================================================================--
   --                                                                        --
   --                                                                        --
   --                           Local declarations                           --
   --                                                                        --
   --                                                                        --
   --========================================================================--

   use System;
   use System.Storage_Elements;
   use Interfaces;
   use Bits;
   use CPU;

   type CR_Type is
   record
      RR       : Boolean;
      RIE      : Boolean;
      TIE      : Boolean;
      EIE      : Boolean;
      OIE      : Boolean;
      Reserved : Bits_3;
   end record with
      Bit_Order => Low_Order_First,
      Size      => 8;
   for CR_Type use
   record
      RR       at 0 range 0 .. 0;
      RIE      at 0 range 1 .. 1;
      TIE      at 0 range 2 .. 2;
      EIE      at 0 range 3 .. 3;
      OIE      at 0 range 4 .. 4;
      Reserved at 0 range 5 .. 7;
   end record;

   type CMR_Type is
   record
      TR       : Boolean;
      ABTTX    : Boolean; -- "AT" (Abort Transmission) conflicts with reserved word
      RRB      : Boolean;
      CDO      : Boolean;
      GTS      : Boolean;
      Reserved : Bits_3;
   end record with
      Bit_Order => Low_Order_First,
      Size      => 8;
   for CMR_Type use
   record
      TR       at 0 range 0 .. 0;
      ABTTX    at 0 range 1 .. 1;
      RRB      at 0 range 2 .. 2;
      CDO      at 0 range 3 .. 3;
      GTS      at 0 range 4 .. 4;
      Reserved at 0 range 5 .. 7;
   end record;

   type SR_Type is
   record
      RBS : Boolean;
      DOS : Boolean;
      TBS : Boolean;
      TCS : Boolean;
      RS  : Boolean;
      TS  : Boolean;
      ES  : Boolean;
      BS  : Boolean;
   end record with
      Bit_Order => Low_Order_First,
      Size      => 8;
   for SR_Type use
   record
      RBS at 0 range 0 .. 0;
      DOS at 0 range 1 .. 1;
      TBS at 0 range 2 .. 2;
      TCS at 0 range 3 .. 3;
      RS  at 0 range 4 .. 4;
      TS  at 0 range 5 .. 5;
      ES  at 0 range 6 .. 6;
      BS  at 0 range 7 .. 7;
   end record;

   type IR_Type is
   record
      RI       : Boolean;
      TI       : Boolean;
      EI       : Boolean;
      DOI      : Boolean;
      WUI      : Boolean;
      Reserved : Bits_3;
   end record with
      Bit_Order => Low_Order_First,
      Size      => 8;
   for IR_Type use
   record
      RI       at 0 range 0 .. 0;
      TI       at 0 range 1 .. 1;
      EI       at 0 range 2 .. 2;
      DOI      at 0 range 3 .. 3;
      WUI      at 0 range 4 .. 4;
      Reserved at 0 range 5 .. 7;
   end record;

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
   procedure Probe (Device_Number : out Device_Number_Type; Success : out Boolean) is
   begin
      Cfg_Find_Device_By_Id (BUS0, VENDOR_ID_AMCC, DEVICE_ID_PCICAN, Device_Number, Success);
      if Success then
         Console.Print (Unsigned_8 (Device_Number), Prefix => "AMCC PCIcanx/PCIcan @ PCI DevNum ", NL => True);
      end if;
   end Probe;

   ----------------------------------------------------------------------------
   -- Init
   ----------------------------------------------------------------------------
   procedure Init is
   begin
      -- initialize PCI interface, setup BAR __FIX__ device number hardwired @ 4
      Cfg_Write (BUS0, 4, 0, BAR0_Register_Offset, Unsigned_32'(16#D000#)); -- S5920
      Cfg_Write (BUS0, 4, 0, BAR1_Register_Offset, Unsigned_32'(16#D100#)); -- SJA100
      Cfg_Write (BUS0, 4, 0, BAR2_Register_Offset, Unsigned_32'(16#D200#)); -- Xilinx FPGA
      -- enable IOEN
      Cfg_Write (BUS0, 4, 0, CR_Register_Offset, Unsigned_8'(16#03#));
   end Init;

   ----------------------------------------------------------------------------
   -- TX
   ----------------------------------------------------------------------------
   -- __TBD__ stub for test, transmit something
   ----------------------------------------------------------------------------
   procedure TX is
      Data32 : Unsigned_32 with Unreferenced => True;
   begin
      Data32 := CPU.IO.PortIn (16#D038#);        -- D000+38 S5920+INTCSR
      CPU.IO.PortOut (16#D101#, Unsigned_8'(1)); -- D100+01 SJA1000+TX
   end TX;

end PCICAN;

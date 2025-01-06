-----------------------------------------------------------------------------------------------------------------------
--                                                     SweetAda                                                      --
-----------------------------------------------------------------------------------------------------------------------
-- __HDS__                                                                                                           --
-- __FLN__ qspi.adb                                                                                                  --
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

with Interfaces;
with CPU;
with HiFive1;
with Console;

package body QSPI
   is

   --========================================================================--
   --                                                                        --
   --                                                                        --
   --                           Local declarations                           --
   --                                                                        --
   --                                                                        --
   --========================================================================--

   use Interfaces;
   use HiFive1;
   use SPI;

   procedure Byte_Read
      (Byte    : out Unsigned_8;
       Success : out Boolean);

   procedure Byte_Write
      (Byte    : in     Unsigned_8;
       Success :    out Boolean);

   procedure Byte_Write_Read
      (TX      : in     Unsigned_8;
       RX      :    out Unsigned_8;
       Success :    out Boolean);

   --========================================================================--
   --                                                                        --
   --                                                                        --
   --                           Package subprograms                          --
   --                                                                        --
   --                                                                        --
   --========================================================================--

   procedure Byte_Read
      (Byte    : out Unsigned_8;
       Success : out Boolean)
      is
      Timeout    : Integer := 3_000_000;
      RxDataPoll : rxdata_Type;
   begin
      Byte := 0;
      Success := False;
      while Timeout > 0 loop
         RxDataPoll := QSPI0.rxdata;
         if not RxDataPoll.empty then
            Byte := RxDataPoll.rxdata;
            Success := True;
            return;
         end if;
         Timeout := @ - 1;
      end loop;
   end Byte_Read;

   procedure Byte_Write
      (Byte    : in     Unsigned_8;
       Success :    out Boolean)
      is
      Timeout : Integer := 3_000_000;
   begin
      Success := False;
      while Timeout > 0 loop
         if not QSPI0.txdata.full then
            QSPI0.txdata.txdata := Byte;
            Success := True;
            return;
         end if;
         Timeout := @ - 1;
      end loop;
   end Byte_Write;

   procedure Byte_Write_Read
      (TX      : in     Unsigned_8;
       RX      :    out Unsigned_8;
       Success :    out Boolean)
      is
   begin
      RX := 0;
      Byte_Write (TX, Success);
      if not Success then
         return;
      end if;
      Byte_Read (RX, Success);
   end Byte_Write_Read;

   ----------------------------------------------------------------------------
   -- Init
   ----------------------------------------------------------------------------
   procedure Init
      is
      Success : Boolean;
      RxByte  : Unsigned_8;
      Id1     : Unsigned_8;
      Id2     : Unsigned_8;
      Id3     : Unsigned_8;
   begin
      -- initialization
      QSPI0.fctrl.en      := False;
      QSPI0.csid          := 0;
      QSPI0.csdef         := 1;
      QSPI0.csmode.mode   := mode_HOLD;
      QSPI0.sckdiv.div    := 3;
      QSPI0.sckmode       := (pha => pha_SALSHT, pol => pol_INACTIVE0, others => <>);
      QSPI0.fmt           := (
                              proto =>  proto_SINGLE,
                              endian => endian_MSB,
                              dir    => dir_RX,
                              len    => 8,
                              others => <>
                             );
      QSPI0.ie            := (txwm => False, rxwm => False, others => <>);
      QSPI0.rxmark.rxmark := 1;
      QSPI0.txmark.txmark := 1;
      -- reset 66 + 99
      QSPI0.fmt.dir := dir_TX;
      QSPI0.csmode.mode := mode_AUTO;
      Byte_Write (16#66#, Success);
      if not Success then
         return;
      end if;
      Byte_Write (16#99#, Success);
      if not Success then
         return;
      end if;
      -- delay
      for Delay_Loop_Count in 1 .. 3_000_000 loop CPU.NOP; end loop;
      QSPI0.fmt.dir := dir_RX;
      -- RDJDID (Read JEDEC ID) Sequence In SPI Mode
      -- IS25LP032D = 9D 60 16
      Console.Print ("SPI identification: ");
      QSPI0.csmode.mode := mode_HOLD;
      -- command 9F
      Byte_Write_Read (16#9F#, RxByte, Success);
      if not Success then
         return;
      end if;
      -- 1st 00
      Byte_Write_Read (16#00#, Id1, Success);
      if not Success then
         return;
      end if;
      Console.Print (Id1, NL => False);
      -- 2nd 00
      Byte_Write_Read (16#00#, Id2, Success);
      if not Success then
         return;
      end if;
      Console.Print (Id2, NL => False);
      -- 3rd 00
      Byte_Write_Read (16#00#, Id3, Success);
      if not Success then
         return;
      end if;
      Console.Print (Id3, NL => False);
      QSPI0.csmode.mode := mode_AUTO;
      Console.Print_NewLine;
   end Init;

end QSPI;

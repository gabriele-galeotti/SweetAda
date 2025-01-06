-----------------------------------------------------------------------------------------------------------------------
--                                                     SweetAda                                                      --
-----------------------------------------------------------------------------------------------------------------------
-- __HDS__                                                                                                           --
-- __FLN__ w25q64fv.adb                                                                                              --
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
with S5D9;
with Console;

package body W25Q64FV
   is

   --========================================================================--
   --                                                                        --
   --                                                                        --
   --                           Local declarations                           --
   --                                                                        --
   --                                                                        --
   --========================================================================--

   use Interfaces;
   use S5D9;

   --========================================================================--
   --                                                                        --
   --                                                                        --
   --                           Package subprograms                          --
   --                                                                        --
   --                                                                        --
   --========================================================================--

   ----------------------------------------------------------------------------
   -- Device_Detect
   ----------------------------------------------------------------------------
   procedure Device_Detect
      is
      RDID  : constant := 16#9F#;
      mfid  : Unsigned_8;         -- “Manufacturer Identification”
      mtype : Unsigned_8;         -- “Memory Type”
      mcap  : Unsigned_8;         -- “Memory Capacity”
   begin
      -- QSPI Read Identification
      QSPI.SFMCMD := (DCOM => DCOM_DIRECT, others => <>);
      QSPI.SFMCOM := (SFMD => RDID, others => <>);
      mfid  := QSPI.SFMCOM.SFMD;
      mtype := QSPI.SFMCOM.SFMD;
      mcap  := QSPI.SFMCOM.SFMD;
      QSPI.SFMCMD := (DCOM => DCOM_DIRECT, others => <>);
      Console.Print (Prefix => "MFID  = 0x", Value => mfid, NL => True);
      Console.Print (Prefix => "MTYPE = 0x", Value => mtype, NL => True);
      Console.Print (Prefix => "MCAP  = 0x", Value => mcap, NL => True);
   end Device_Detect;

   ----------------------------------------------------------------------------
   -- Init
   ----------------------------------------------------------------------------
   procedure Init
      is
   begin
      -- pins 500..505 function = QSPI
      for P5x in P500 .. P505 loop
         PFSR (P5x) := (PMR => True, PSEL => PSEL_QSPI, others => <>);
      end loop;
   end Init;

end W25Q64FV;

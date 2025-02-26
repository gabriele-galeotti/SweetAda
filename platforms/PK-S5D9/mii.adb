-----------------------------------------------------------------------------------------------------------------------
--                                                     SweetAda                                                      --
-----------------------------------------------------------------------------------------------------------------------
-- __HDS__                                                                                                           --
-- __FLN__ mii.adb                                                                                                   --
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
with Bits;
with CPU;
with S5D9;
with Console;

package body MII
   is

   --========================================================================--
   --                                                                        --
   --                                                                        --
   --                           Local declarations                           --
   --                                                                        --
   --                                                                        --
   --========================================================================--

   use Interfaces;
   use Bits;
   use S5D9;

   --========================================================================--
   --                                                                        --
   --                                                                        --
   --                           Package subprograms                          --
   --                                                                        --
   --                                                                        --
   --========================================================================--

   function Bit_Read
      return Bits_1
      with Inline => True;
   procedure Bit_Send
      (Bit : in Bits_1)
      with Inline => True;
   procedure Bus_Release
      with Inline => True;

   MII_Delay : constant := 10_000;

   function Bit_Read
      return Bits_1
      is
      Bit : Bits_1;
   begin
      PIR := (MMD => 0, MDC => 1, others => <>);
      for Delay_Loop_Count in 1 .. MII_Delay loop CPU.NOP; end loop;
      Bit := PIR.MDI;
      PIR := (MMD => 0, MDC => 0, others => <>);
      for Delay_Loop_Count in 1 .. MII_Delay loop CPU.NOP; end loop;
      return Bit;
   end Bit_Read;

   procedure Bit_Send
      (Bit : in Bits_1)
      is
   begin
      PIR := (MMD => 1, MDC => 0, MDO => Bit, others => <>);
      for Delay_Loop_Count in 1 .. MII_Delay loop CPU.NOP; end loop;
      PIR := (MMD => 1, MDC => 1, MDO => Bit, others => <>);
      for Delay_Loop_Count in 1 .. MII_Delay loop CPU.NOP; end loop;
      PIR := (MMD => 1, MDC => 0, MDO => Bit, others => <>);
      for Delay_Loop_Count in 1 .. MII_Delay loop CPU.NOP; end loop;
   end Bit_Send;

   procedure Bus_Release
      is
   begin
      PIR := (MMD => 0, MDC => 0, others => <>);
      for Delay_Loop_Count in 1 .. MII_Delay loop CPU.NOP; end loop;
      PIR := (MMD => 0, MDC => 1, others => <>);
      for Delay_Loop_Count in 1 .. MII_Delay loop CPU.NOP; end loop;
      PIR := (MMD => 0, MDC => 0, others => <>);
      for Delay_Loop_Count in 1 .. MII_Delay loop CPU.NOP; end loop;
   end Bus_Release;

   ----------------------------------------------------------------------------
   -- Init
   ----------------------------------------------------------------------------
   procedure Init
      is
      Data : Unsigned_16;
   begin
      -- ETH_RESET# active low
      PFSR (P806).PMR := False;
      PORT (8).PODR (6) := False;
      PORT (8).PDR (6) := True;
--      loop
--         PORT (8).PODR (6) := False;
--         for Delay_Loop_Count in 1 .. 1_000_000 loop CPU.NOP; end loop;
--         PORT (8).PODR (6) := True;
--         for Delay_Loop_Count in 1 .. 1_000_000 loop CPU.NOP; end loop;
--      end loop;
      -- ETH (PHYAD[2])
      PFSR (P701).PMR := False;
      PORT (7).PODR (1) := False; -- PHYAD[2] = 0
      PORT (7).PDR (1) := True;
      -- ETH_CRS_DV (PHYAD[1:0])
      PFSR (P705).PMR := False;
      PORT (7).PODR (5) := False; -- PHYAD[1:0] = 00
      PORT (7).PDR (5) := True;
      -- ETH_MDC
      PFSR (P401) := (PMR => True, PSEL => PSEL_ETHERC_RMII, others => <>);
      -- ETH_MDIO
      PFSR (P402) := (PMR => True, PSEL => PSEL_ETHERC_RMII, others => <>);
      -- deactivate RESET#
      PORT (8).PODR (6) := True;

      for Delay_Loop_Count in 1 .. 1_000_000 loop CPU.NOP; end loop;

      -- preamble
      for N in 1 .. 32 loop Bit_Send (1); end loop;
      -- start of frame
      Bit_Send (0); Bit_Send (1);
      -- read operation
      Bit_Send (1); Bit_Send (0);
      -- PHY address
      -- for N in 1 .. 5 loop Bit_Send (0); end loop;
      Bit_Send (0); Bit_Send (0); Bit_Send (0); Bit_Send (0); Bit_Send (0);
      -- register address
      Bit_Send (0); Bit_Send (0); Bit_Send (0); Bit_Send (1); Bit_Send (0);
      -- turn-around
      Bus_Release; Bus_Release;
      -- read
      Data := 0;
      for N in 0 .. 15 loop
         Data := Shift_Left (@, 1) or Unsigned_16 (Bit_Read);
      end loop;
      Console.Print (Prefix => "MII: ", Value => Data, NL => True);

   end Init;

end MII;

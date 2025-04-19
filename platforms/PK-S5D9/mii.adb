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

   READ  : constant := 0;
   WRITE : constant := 1;

   procedure MII_Delay
      (Count : in Integer)
      with Inline => True;
   function Bit_Read
      return Bits_1
      with Inline => True;
   procedure Bit_Write
      (Bit : in Bits_1)
      with Inline => True;
   procedure Turn_Around
      with Inline => True;

   procedure ReadOrWrite
      (ReadWrite : in Integer);
   procedure AddressOrRegister
      (Value : in Unsigned_8);
   function RegisterRead
      return Unsigned_16;
   procedure RegisterWrite
      (Value : in Unsigned_16);

   --========================================================================--
   --                                                                        --
   --                                                                        --
   --                           Package subprograms                          --
   --                                                                        --
   --                                                                        --
   --========================================================================--

   ----------------------------------------------------------------------------
   -- MII_Delay
   ----------------------------------------------------------------------------
   procedure MII_Delay
      (Count : in Integer)
      is
   begin
      for Delay_Loop_Count in 1 .. Count loop CPU.NOP; end loop;
   end MII_Delay;

   ----------------------------------------------------------------------------
   -- Bit_Read
   ----------------------------------------------------------------------------
   function Bit_Read
      return Bits_1
      is
      Bit : Bits_1;
   begin
      Bit := PIR.MDI;
      PIR := (MMD => 0, MDC => 1, others => <>);
      MII_Delay (1_000);
      PIR := (MMD => 0, MDC => 0, others => <>);
      MII_Delay (1_000);
      return Bit;
   end Bit_Read;

   ----------------------------------------------------------------------------
   -- Bit_Write
   ----------------------------------------------------------------------------
   procedure Bit_Write
      (Bit : in Bits_1)
      is
   begin
      PIR := (MMD => 1, MDC => 1, MDO => Bit, others => <>);
      MII_Delay (1_000);
      PIR := (MMD => 1, MDC => 0, MDO => Bit, others => <>);
      MII_Delay (1_000);
   end Bit_Write;

   ----------------------------------------------------------------------------
   -- Turn_Around
   ----------------------------------------------------------------------------
   procedure Turn_Around
      is
   begin
      PIR := (MMD => 0, MDC => 1, others => <>);
      MII_Delay (1_000);
      PIR := (MMD => 0, MDC => 0, others => <>);
      MII_Delay (1_000);
      PIR := (MMD => 0, MDC => 1, others => <>);
      MII_Delay (1_000);
      PIR := (MMD => 0, MDC => 0, others => <>);
      MII_Delay (1_000);
   end Turn_Around;

   ----------------------------------------------------------------------------
   -- ReadOrWrite
   ----------------------------------------------------------------------------
   procedure ReadOrWrite
      (ReadWrite : in Integer)
      is
   begin
      for N in 1 .. 32 loop Bit_Write (1); end loop; -- preamble
      Bit_Write (0); Bit_Write (1);                  -- start of frame
      if ReadWrite = 0 then
         Bit_Write (1); Bit_Write (0);               -- read operation
      else
         Bit_Write (0); Bit_Write (1);               -- write operation
      end if;
   end ReadOrWrite;

   ----------------------------------------------------------------------------
   -- AddressOrRegister
   ----------------------------------------------------------------------------
   procedure AddressOrRegister
      (Value : in Unsigned_8)
      is
   begin
      for Bitshift in reverse 0 .. 4 loop
         Bit_Write (Bits_1 (Shift_Right (Value, Bitshift) and 1));
      end loop;
   end AddressOrRegister;

   ----------------------------------------------------------------------------
   -- RegisterRead
   ----------------------------------------------------------------------------
   function RegisterRead
      return Unsigned_16
      is
      Data : Unsigned_16 := 0;
   begin
      for Bitshift in 0 .. 15 loop
         Data := Shift_Left (@, 1) or Unsigned_16 (Bit_Read);
      end loop;
      return Data;
   end RegisterRead;

   ----------------------------------------------------------------------------
   -- RegisterWrite
   ----------------------------------------------------------------------------
   procedure RegisterWrite
      (Value : in Unsigned_16)
      is
   begin
      for Bitshift in reverse 0 .. 15 loop
         Bit_Write (Bits_1 (Shift_Right (Value, Bitshift) and 1));
      end loop;
   end RegisterWrite;

   ----------------------------------------------------------------------------
   -- Init
   ----------------------------------------------------------------------------
   procedure Init
      is
      Data : Unsigned_16;
   begin
      -- ETH_RESET# active low
      PFSR (P806).PMR := False;   -- GPIO
      PORT (8).PODR (6) := False; -- active low
      PORT (8).PDR (6) := True;   -- output
      -- ETH (PHYAD[2])
      PFSR (P701).PMR := False;   -- GPIO
      PORT (7).PODR (1) := False; -- PHYAD[2] = 0
      PORT (7).PDR (1) := True;   -- output
      -- ETH_CRS_DV (PHYAD[1:0])
      PFSR (P705).PMR := False;   -- GPIO
      PORT (7).PODR (5) := False; -- PHYAD[1:0] = 00
      PORT (7).PDR (5) := True;   -- output
      -- ETH_MDC
      PFSR (P401) := (PMR => True, PSEL => PSEL_ETHERC_RMII, others => <>);
      -- ETH_MDIO
      PFSR (P402) := (PMR => True, PSEL => PSEL_ETHERC_RMII, others => <>);
      -- deactivate RESET#
      PORT (8).PODR (6) := True;
      MII_Delay (1_000_000);
      -- read ID registers
      ReadOrWrite (READ);
      AddressOrRegister (0);
      AddressOrRegister (2);
      Turn_Around;
      Console.Print (Prefix => "MII reg2: ", Value => RegisterRead, NL => True);
      ReadOrWrite (READ);
      AddressOrRegister (0);
      AddressOrRegister (3);
      Turn_Around;
      Console.Print (Prefix => "MII reg3: ", Value => RegisterRead, NL => True);
   end Init;

end MII;

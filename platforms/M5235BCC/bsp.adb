-----------------------------------------------------------------------------------------------------------------------
--                                                     SweetAda                                                      --
-----------------------------------------------------------------------------------------------------------------------
-- __HDS__                                                                                                           --
-- __FLN__ bsp.adb                                                                                                   --
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

with System;
with System.Storage_Elements;
with Definitions;
with Configure;
with Bits;
with MMIO;
with Secondary_Stack;
with CPU;
with MCF523x;
with M5235BCC;
with Console;

package body BSP
   is

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
   use Definitions;
   use Bits;
   use MCF523x;
   use M5235BCC;

   procedure FlashROM_Detect;
   procedure MII_Detect;

   --========================================================================--
   --                                                                        --
   --                                                                        --
   --                           Package subprograms                          --
   --                                                                        --
   --                                                                        --
   --========================================================================--

   ----------------------------------------------------------------------------
   -- FlashROM_Detect
   ----------------------------------------------------------------------------
   procedure FlashROM_Detect
      is
      FlashROM_Address : constant Address := System'To_Address (FlashROM_BASEADDRESS);
      Address_Scale    : constant := 2; -- 16-bit mode
      Manufacturer     : Unsigned_16;
      DeviceCode       : Unsigned_16;
   begin
      Console.Print ("Detect Flash ROM ...", NL => True);
      -- Read/Reset
      MMIO.Write_U16 (FlashROM_Address, 16#F0#);
      -- Auto Select
      MMIO.Write_U16 (FlashROM_Address + 16#555# * Address_Scale, 16#AA#);
      MMIO.Write_U16 (FlashROM_Address + 16#2AA# * Address_Scale, 16#55#);
      MMIO.Write_U16 (FlashROM_Address + 16#555# * Address_Scale, 16#90#);
      -- Read Manufacturer/Device code
      Manufacturer := MMIO.Read_U16 (FlashROM_Address + 16#00# * Address_Scale);
      DeviceCode   := MMIO.Read_U16 (FlashROM_Address + 16#01# * Address_Scale);
      Console.Print (Prefix => "Manufacturer: ", Value => Manufacturer, NL => True);
      Console.Print (Prefix => "Device Code:  ", Value => DeviceCode, NL => True);
      if Manufacturer = 16#0020# and then DeviceCode = 16#2249# then
         Console.Print ("STM29W160EB Flash ROM", NL => True);
      end if;
      -- Read/Reset
      MMIO.Write_U16 (FlashROM_Address, 16#F0#);
   end FlashROM_Detect;

   ----------------------------------------------------------------------------
   -- MII_Detect
   ----------------------------------------------------------------------------
   procedure MII_Detect
      is
      MII_FREQUENCY : constant := 2_500 * kHz1; -- MII speed must be 2.5 MHz
      KS8721BLSL_ID : constant := 16#0022_1619#; -- Micrel KS8721BL/SL
      MII_PHYID1    : constant := 2;
      MII_PHYID2    : constant := 3;
      DATA          : Unsigned_16;
      MII_ID        : Unsigned_32;
   begin
      MSCR := (MII_SPEED => Bits_6 (Configure.FSYS_FREQUENCY / (2 * MII_FREQUENCY)), others => <>);
      EIMR.MII := False;
      MMFR := (RA => MII_PHYID1, PA => Configure.MII_ADDRESS, OP => OP_READ, others => <>);
      loop exit when EIR.MII; end loop;
      EIR.MII := True;
      DATA := Unsigned_16 (MMFR.DATA);
      MMFR := (RA => MII_PHYID2, PA => Configure.MII_ADDRESS, OP => OP_READ, others => <>);
      loop exit when EIR.MII; end loop;
      EIR.MII := True;
      MII_ID := Make_Word (DATA, Unsigned_16 (MMFR.DATA));
      Console.Print (Prefix => "MII id: ", Value => MII_ID, NL => True);
      if MII_ID = KS8721BLSL_ID then
         Console.Print ("Micrel KS8721BL/SL", NL => True);
      end if;
   end MII_Detect;

   ----------------------------------------------------------------------------
   -- Console wrappers
   ----------------------------------------------------------------------------

   procedure Console_Putchar
      (C : in Character)
      is
   begin
      -- wait for transmitter available
      loop exit when USR0.TXRDY; end loop;
      UTB0 := To_U8 (C);
   end Console_Putchar;

   procedure Console_Getchar
      (C : out Character)
      is
      Data : Unsigned_8;
   begin
      -- wait for receiver available
      loop exit when USR0.RXRDY; end loop;
      Data := URB0;
      C := To_Ch (Data);
   end Console_Getchar;

   ----------------------------------------------------------------------------
   -- Setup
   ----------------------------------------------------------------------------
   procedure Setup
      is
   begin
      -------------------------------------------------------------------------
      Secondary_Stack.Init;
      -- Console --------------------------------------------------------------
      Console.Console_Descriptor := (
         Write => Console_Putchar'Access,
         Read  => Console_Getchar'Access
         );
      Console.Print (ANSI_CLS & ANSI_CUPHOME & VT100_LINEWRAP);
      -------------------------------------------------------------------------
      Console.Print ("M5235BCC", NL => True);
      Console.Print (Prefix => "PIN:    ", Value => Unsigned_32 (CIR.PIN), NL => True);
      Console.Print (Prefix => "PRN:    ", Value => Unsigned_32 (CIR.PRN), NL => True);
      pragma Warnings (Off, "volatile actual passed by copy");
      Console.Print (Prefix => "IPSBAR: ", Value => To_U32 (IPSBAR) and 16#FFFF_FFFE#, NL => True);
      Console.Print (Prefix => "SYNCR:  ", Value => To_U32 (SYNCR), NL => True);
      Console.Print (Prefix => "SYNSR:  ", Value => To_U32 (SYNSR), NL => True);
      pragma Warnings (On, "volatile actual passed by copy");
      -------------------------------------------------------------------------
      FlashROM_Detect;
      MII_Detect;
      -------------------------------------------------------------------------
   end Setup;

end BSP;

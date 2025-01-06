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
with Definitions;
with Secondary_Stack;
with Bits;
with MMIO;
with MIPS;
with R3000;
with KN02BA;
with Exceptions;
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

   use Interfaces;
   use Definitions;
   use Bits;
   use KN02BA;

   --========================================================================--
   --                                                                        --
   --                                                                        --
   --                           Package subprograms                          --
   --                                                                        --
   --                                                                        --
   --========================================================================--

   ----------------------------------------------------------------------------
   -- Console wrappers
   ----------------------------------------------------------------------------

   procedure Console_Putchar
      (C : in Character)
      is
   begin
      -- Z8530.TX (SCC_Descriptor1, Z8530.CHANNELB, To_U8 (C)); -- SCC0 serial port "2"
      Z8530.TX (SCC_Descriptor2, Z8530.CHANNELB, To_U8 (C)); -- SCC1 serial port "3"
   end Console_Putchar;

   procedure Console_Getchar
      (C : out Character)
      is
      Data : Unsigned_8;
   begin
      -- Z8530.RX (SCC_Descriptor1, Z8530.CHANNELB, Data); -- SCC0 serial port "2"
      Z8530.RX (SCC_Descriptor2, Z8530.CHANNELB, Data); -- SCC1 serial port "3"
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
      -------------------------------------------------------------------------
      Exceptions.Init;
      -------------------------------------------------------------------------
      IOASIC_SSR := (
         LED0        => False, -- ON
         LED1        => False, -- ON
         LED2        => False, -- ON
         LED3        => False, -- ON
         LED4        => False, -- ON
         LED5        => False, -- ON
         LED6        => False, -- ON
         LED7        => False, -- ON
         LANCE_RESET => True,  -- bring out of reset
         SCSI_RESET  => True,  -- bring out of reset
         RTC_RESET   => True,  -- bring out of reset
         SCC_RESET   => True,  -- bring out of reset
         TXDIS0      => False, -- enable SCC EIA drivers
         TXDIS1      => False, -- enable SCC EIA drivers
         others      => <>
         );
      -- RTC ------------------------------------------------------------------
      RTC_Descriptor := (
         Base_Address  => System'To_Address (MIPS.KSEG1_ADDRESS + RTC_BASEADDRESS),
         Scale_Address => 2,
         Flags         => (null record),
         Read_8        => MMIO.Read'Access,
         Write_8       => MMIO.Write'Access
         );
      MC146818A.Init (RTC_Descriptor);
      -- SCCs -----------------------------------------------------------------
      SCC_Descriptor1 := (
         Base_Address   => System'To_Address (MIPS.KSEG1_ADDRESS + SCC0_BASEADDRESS),
         AB_Address_Bit => 3,
         CD_Address_Bit => 2,
         Baud_Clock     => CLK_UART7M3,
         Flags          => (DECstation5000133 => True),
         Read_8         => MMIO.Read'Access,
         Write_8        => MMIO.Write'Access,
         others         => <>
         );
      Z8530.Init (SCC_Descriptor1, Z8530.CHANNELA);
      Z8530.Init (SCC_Descriptor1, Z8530.CHANNELB);
      SCC_Descriptor2 := (
         Base_Address   => System'To_Address (MIPS.KSEG1_ADDRESS + SCC1_BASEADDRESS),
         AB_Address_Bit => 3,
         CD_Address_Bit => 2,
         Baud_Clock     => CLK_UART7M3,
         Flags          => (DECstation5000133 => True),
         Read_8         => MMIO.Read'Access,
         Write_8        => MMIO.Write'Access,
         others         => <>
         );
      Z8530.Init (SCC_Descriptor2, Z8530.CHANNELA);
      Z8530.Init (SCC_Descriptor2, Z8530.CHANNELB);
      -- Console --------------------------------------------------------------
      Console.Console_Descriptor := (
         Write => Console_Putchar'Access,
         Read  => Console_Getchar'Access
         );
      Console.Print (ANSI_CLS & ANSI_CUPHOME & VT100_LINEWRAP);
      -------------------------------------------------------------------------
      Console.Print ("DECstation 5000/133", NL => True);
      -------------------------------------------------------------------------
      declare
         PRId : R3000.PRId_Type;
      begin
         PRId := R3000.CP0_PRId_Read;
         case PRId.Imp is
            -- some datasheets indicate "3" as the value for an R3000A
            when 2      => Console.Print ("R3000/R3000A", NL => True);
            when 3      => Console.Print ("R3000A/R3051/R3052/R3071/R3081", NL => True);
            when 7      => Console.Print ("R3041", NL => True);
            when others => Console.Print ("CPU unknown", NL => True);
         end case;
         Console.Print ("PRId: " & PRId.Imp'Image & "." & PRId.Rev'Image, NL => True);
         Console.Print (
            Prefix => "D cache size (kB): ",
            Value  => Natural (R3000.Cache_Size (ICache => False) / 1024),
            NL     => True
            );
         Console.Print (
            Prefix => "I cache size (kB): ",
            Value  => Natural (R3000.Cache_Size (ICache => True) / 1024),
            NL     => True
            );
      end;
      -------------------------------------------------------------------------
      declare
         S : R3000.Status_Type;
      begin
         S := R3000.CP0_SR_Read;
         S.IM5 := True; -- I/O ASIC cascade
         R3000.CP0_SR_Write (S);
      end;
      IOASIC_SIMR := (
         PBNO      => False,
         PBNC      => False,
         SCSI_FIFO => False,
         PSU       => False,
         RTC       => True,
         SCC0      => False,
         SCC1      => True,
         LANCE     => False,
         SCSI      => False,
         NRMOD     => False,
         BUS       => False,
         NVRAM     => False,
         others    => <>
         );
      -------------------------------------------------------------------------
      R3000.Irq_Enable;
      -------------------------------------------------------------------------
   end Setup;

end BSP;

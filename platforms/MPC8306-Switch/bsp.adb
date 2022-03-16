-----------------------------------------------------------------------------------------------------------------------
--                                                     SweetAda                                                      --
-----------------------------------------------------------------------------------------------------------------------
-- __HDS__                                                                                                           --
-- __FLN__ bsp.adb                                                                                                   --
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
with Definitions;
with Bits;
with PowerPC;
with e300;
with MPC8306;
with Switch;
with Console;

package body BSP is

   --========================================================================--
   --                                                                        --
   --                                                                        --
   --                           Local declarations                           --
   --                                                                        --
   --                                                                        --
   --========================================================================--

   use Interfaces;
   use Bits;

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

   procedure Console_Putchar (C : in Character) is
   begin
      loop
         exit when (MPC8306.UART1_ULSR and 16#20#) /= 0;
      end loop;
      MPC8306.UART1_UTHR := To_U8 (C);
   end Console_Putchar;

   procedure Console_Getchar (C : out Character) is
   begin
      loop
         exit when (MPC8306.UART1_ULSR and 16#01#) /= 0;
      end loop;
      C := To_Ch (MPC8306.UART1_URBR);
   end Console_Getchar;

   ----------------------------------------------------------------------------
   -- BSP_Setup
   ----------------------------------------------------------------------------
   procedure BSP_Setup is
      BAUDRATE_DIVISOR : constant := Switch.SYSTEM_CLOCK / (Definitions.Baud_Rate_Type'Enum_Rep (Definitions.BR_115200) * 16);
      CPU_PVR          : PowerPC.PVR_Register_Type;
   begin
      -- 6.3.2.5 System I/O Configuration Register 1 (SICR_1) -----------------
      MPC8306.SICR_1 := 16#0001_165F#; -- UART1 mapped on I/O pads
      -- 6.3.2.6 System I/O Configuration Register 2 (SICR_2) -----------------
      MPC8306.SICR_2 := 16#A005_0475#; -- GPIO22 function
      -- 21.3.1 GPIOn Direction Register (GP1DIR–GP2DIR) ----------------------
      MPC8306.GP1DIR := 16#0000_0200#; -- GPIO22 = output
      -- 21.3.2 GPIOn Open Drain Register (GP1ODR–GP2ODR) ---------------------
      MPC8306.GP1ODR := 16#FFFF_FDFF#; -- GPIO22 = actively driven
      -- UART1 ----------------------------------------------------------------
      MPC8306.UART1_ULCR := 16#83#;                                 -- access UDLB, UDMB
      MPC8306.UART1_UDLB := Unsigned_8 (BAUDRATE_DIVISOR mod 2**8);
      MPC8306.UART1_UDMB := Unsigned_8 (BAUDRATE_DIVISOR / 2**8);
      MPC8306.UART1_ULCR := 16#03#;                                 -- 8-bit
      -- Console --------------------------------------------------------------
      Console.Console_Descriptor.Write := Console_Putchar'Access;
      Console.Console_Descriptor.Read  := Console_Getchar'Access;
      Console.TTY_Setup;
      -------------------------------------------------------------------------
      Console.Print ("MPC8306 Switch", NL => True);
      -------------------------------------------------------------------------
      CPU_PVR := PowerPC.PVR_Read;
      Console.Print (CPU_PVR.Version, Prefix => "PVR (ver): ", NL => True);
      Console.Print (CPU_PVR.Revision, Prefix => "PVR (rev): ", NL => True);
      Console.Print (e300.SVR_Read, Prefix => "SVR: ", NL => True);
      Console.Print (MPC8306.RCWLR, Prefix => "RCWLR: ", NL => True);
      Console.Print (MPC8306.RCWHR, Prefix => "RCWHR: ", NL => True);
      -------------------------------------------------------------------------
   end BSP_Setup;

end BSP;

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
with SOM;
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
         exit when (MPC8306.UART2_ULSR and 16#20#) /= 0;
      end loop;
      MPC8306.UART2_UTHR := To_U8 (C);
   end Console_Putchar;

   procedure Console_Getchar (C : out Character) is
   begin
      loop
         exit when (MPC8306.UART2_ULSR and 16#01#) /= 0;
      end loop;
      C := To_Ch (MPC8306.UART2_URBR);
   end Console_Getchar;

   ----------------------------------------------------------------------------
   -- BSP_Setup
   ----------------------------------------------------------------------------
   procedure BSP_Setup is
      BAUDRATE_DIVISOR : constant := SOM.SYSTEM_CLOCK / (Definitions.Baud_Rate_Type'Enum_Rep (Definitions.BR_115200) * 16);
      CPU_PVR          : PowerPC.PVR_Register_Type;
   begin
      -- 6.3.2.5 System I/O Configuration Register 1 (SICR_1) -----------------
      -- MPC8306.SICR_1 := 16#2A81_5657#; -- UART2 mapped on I/O pads
      MPC8306.SICR_1 := 16#0001_565F#; -- UART2 mapped on I/O pads
      -- UART2 ----------------------------------------------------------------
      MPC8306.UART2_ULCR := 16#83#;                                 -- access UDLB, UDMB
      MPC8306.UART2_UDLB := Unsigned_8 (BAUDRATE_DIVISOR mod 2**8);
      MPC8306.UART2_UDMB := Unsigned_8 (BAUDRATE_DIVISOR / 2**8);
      MPC8306.UART2_ULCR := 16#03#;                                 -- 8-bit
      -- Console --------------------------------------------------------------
      Console.Console_Descriptor.Write := Console_Putchar'Access;
      Console.Console_Descriptor.Read  := Console_Getchar'Access;
      Console.TTY_Setup;
      -------------------------------------------------------------------------
      Console.Print ("MPC8306 SOM", NL => True);
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

-----------------------------------------------------------------------------------------------------------------------
--                                                     SweetAda                                                      --
-----------------------------------------------------------------------------------------------------------------------
-- __HDS__                                                                                                           --
-- __FLN__ bsp.adb                                                                                                   --
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

with System.Storage_Elements;
with Definitions;
with MMIO;
with Bits;
with PowerPC;
with e300;
with MPC83XX;
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

   use System.Storage_Elements;
   use Interfaces;
   use Definitions;
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
      UART16x50.TX (UART1_Descriptor, To_U8 (C));
   end Console_Putchar;

   procedure Console_Getchar (C : out Character) is
      Data : Unsigned_8;
   begin
      UART16x50.RX (UART1_Descriptor, Data);
      C := To_Ch (Data);
   end Console_Getchar;

   ----------------------------------------------------------------------------
   -- Setup
   ----------------------------------------------------------------------------
   procedure Setup is
      BAUDRATE_DIVISOR : constant := Switch.SYSTEM_CLOCK / (Baud_Rate_Type'Enum_Rep (BR_115200) * 16);
      CPU_PVR          : PowerPC.PVR_Type;
   begin
      -- 6.3.2.5 System I/O Configuration Register 1 (SICR_1) -----------------
      MPC83XX.SICR_1 := 16#0001_165F#; -- UART1 mapped on I/O pads
      -- 6.3.2.6 System I/O Configuration Register 2 (SICR_2) -----------------
      MPC83XX.SICR_2 := 16#A005_0475#; -- GPIO22 function
      -- 21.3.1 GPIOn Direction Register (GP1DIR–GP2DIR) ----------------------
      MPC83XX.GP1DIR := 16#0000_0200#; -- GPIO22 = output
      -- 21.3.2 GPIOn Open Drain Register (GP1ODR–GP2ODR) ---------------------
      MPC83XX.GP1ODR := 16#FFFF_FDFF#; -- GPIO22 = actively driven
      -- UARTs ----------------------------------------------------------------
      UART1_Descriptor.Base_Address  := To_Address (MPC83XX.UART1_BASEADDRESS);
      UART1_Descriptor.Scale_Address := 0;
      UART1_Descriptor.Baud_Clock    := Switch.SYSTEM_CLOCK;
      UART1_Descriptor.Read_8        := MMIO.Read'Access;
      UART1_Descriptor.Write_8       := MMIO.Write'Access;
      UART1_Descriptor.Data_Queue    := ([others => 0], 0, 0, 0);
      UART16x50.Init (UART1_Descriptor);
      UART16x50.Baud_Rate_Set (UART1_Descriptor, Baud_Rate_Type'Enum_Rep (BR_115200));
      UART2_Descriptor.Base_Address  := To_Address (MPC83XX.UART2_BASEADDRESS);
      UART2_Descriptor.Scale_Address := 0;
      UART2_Descriptor.Baud_Clock    := Switch.SYSTEM_CLOCK;
      UART2_Descriptor.Read_8        := MMIO.Read'Access;
      UART2_Descriptor.Write_8       := MMIO.Write'Access;
      UART2_Descriptor.Data_Queue    := ([others => 0], 0, 0, 0);
      UART16x50.Init (UART2_Descriptor);
      UART16x50.Baud_Rate_Set (UART2_Descriptor, Baud_Rate_Type'Enum_Rep (BR_115200));
      -- Console --------------------------------------------------------------
      Console.Console_Descriptor.Write := Console_Putchar'Access;
      Console.Console_Descriptor.Read  := Console_Getchar'Access;
      Console.Print (ANSI_CLS & ANSI_CUPHOME & VT100_LINEWRAP);
      -------------------------------------------------------------------------
      Console.Print ("MPC8306 Switch", NL => True);
      -------------------------------------------------------------------------
      CPU_PVR := PowerPC.PVR_Read;
      Console.Print (CPU_PVR.Version, Prefix => "PVR (ver): ", NL => True);
      Console.Print (CPU_PVR.Revision, Prefix => "PVR (rev): ", NL => True);
      Console.Print (e300.SVR_Read, Prefix => "SVR: ", NL => True);
      Console.Print (MPC83XX.RCWLR, Prefix => "RCWLR: ", NL => True);
      Console.Print (MPC83XX.RCWHR, Prefix => "RCWHR: ", NL => True);
      -------------------------------------------------------------------------
   end Setup;

end BSP;

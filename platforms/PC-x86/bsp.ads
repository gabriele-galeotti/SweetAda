-----------------------------------------------------------------------------------------------------------------------
--                                                     SweetAda                                                      --
-----------------------------------------------------------------------------------------------------------------------
-- __HDS__                                                                                                           --
-- __FLN__ bsp.ads                                                                                                   --
-- __DSC__                                                                                                           --
-- __HSH__ e69de29bb2d1d6434b8b29ae775ad8c2e48c5391                                                                  --
-- __HDE__                                                                                                           --
-----------------------------------------------------------------------------------------------------------------------
-- Copyright (C) 2020-2024 Gabriele Galeotti                                                                         --
--                                                                                                                   --
-- SweetAda web page: http://sweetada.org                                                                            --
-- contact address: gabriele.galeotti@sweetada.org                                                                   --
-- This work is licensed under the terms of the MIT License.                                                         --
-- Please consult the LICENSE.txt file located in the top-level directory.                                           --
-----------------------------------------------------------------------------------------------------------------------

with Interfaces;
with MC146818A;
with UART16x50;
with IDE;
with NE2000;
with Ethernet;

package BSP is

   --========================================================================--
   --                                                                        --
   --                                                                        --
   --                               Public part                              --
   --                                                                        --
   --                                                                        --
   --========================================================================--

   Tick_Count : aliased Interfaces.Unsigned_32 := 0 with
      Atomic        => True,
      Export        => True,
      Convention    => Asm,
      External_Name => "tick_count";

   RTC_Descriptor      : aliased MC146818A.Descriptor_Type := MC146818A.DESCRIPTOR_INVALID;
   UART_Descriptors    : array (1 .. 2) of aliased UART16x50.Descriptor_Type :=
                         [others => UART16x50.DESCRIPTOR_INVALID];
   IDE_Descriptors     : array (1 .. 1) of aliased IDE.Descriptor_Type :=
                         [others => IDE.DESCRIPTOR_INVALID];
   NE2000_Descriptors  : array (1 .. 1) of aliased NE2000.Descriptor_Type :=
                         [others => NE2000.DESCRIPTOR_INVALID];
   Ethernet_Descriptor : aliased Ethernet.Descriptor_Type := Ethernet.DESCRIPTOR_INVALID;

   QEMU : Boolean := False;

   procedure Tclk_Init;
   procedure Console_Putchar (C : in Character);
   procedure Console_Getchar (C : out Character);
   procedure Setup;
   procedure Reset;

end BSP;

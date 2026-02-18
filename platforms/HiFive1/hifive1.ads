-----------------------------------------------------------------------------------------------------------------------
--                                                     SweetAda                                                      --
-----------------------------------------------------------------------------------------------------------------------
-- __HDS__                                                                                                           --
-- __FLN__ hifive1.ads                                                                                               --
-- __DSC__                                                                                                           --
-- __HSH__ e69de29bb2d1d6434b8b29ae775ad8c2e48c5391                                                                  --
-- __HDE__                                                                                                           --
-----------------------------------------------------------------------------------------------------------------------
-- Copyright (C) 2020-2026 Gabriele Galeotti                                                                         --
--                                                                                                                   --
-- SweetAda web page: http://sweetada.org                                                                            --
-- contact address: gabriele.galeotti@sweetada.org                                                                   --
-- This work is licensed under the terms of the MIT License.                                                         --
-- Please consult the LICENSE.txt file located in the top-level directory.                                           --
-----------------------------------------------------------------------------------------------------------------------

with System;
with Interfaces;
with Bits;
with RISCV;

package HiFive1
   with Preelaborate => True
   is

   --========================================================================--
   --                                                                        --
   --                                                                        --
   --                               Public part                              --
   --                                                                        --
   --                                                                        --
   --========================================================================--

   -- PLIC.priority clashes with System.Priority, so we use a renaming on
   -- System.Low_Order_First, which is the only object imported from the unit,
   -- avoiding a use clause
   -- use System;
   Low_Order_First : System.Bit_Order renames System.Low_Order_First;
   use Interfaces;
   use Bits;

pragma Style_Checks (Off);

   ----------------------------------------------------------------------------
   -- SiFive FE310-G002 Manual v1p0
   ----------------------------------------------------------------------------

   ----------------------------------------------------------------------------
   -- 6 Clock Generation (PRCI)
   ----------------------------------------------------------------------------

   package PRCI
      is

      PRCI_BASEADDRESS : constant := 16#1000_8000#;

      -- 6.3 Internal Trimmable Programmable 72 MHz Oscillator (HFROSC)

      hfroscdiv_div1  : constant := 0;  hfroscdiv_div2  : constant := 1;  hfroscdiv_div3  : constant := 2;  hfroscdiv_div4  : constant := 3;
      hfroscdiv_div5  : constant := 4;  hfroscdiv_div6  : constant := 5;  hfroscdiv_div7  : constant := 6;  hfroscdiv_div8  : constant := 7;
      hfroscdiv_div9  : constant := 8;  hfroscdiv_div10 : constant := 9;  hfroscdiv_div11 : constant := 10; hfroscdiv_div12 : constant := 11;
      hfroscdiv_div13 : constant := 12; hfroscdiv_div14 : constant := 13; hfroscdiv_div15 : constant := 14; hfroscdiv_div16 : constant := 15;
      hfroscdiv_div17 : constant := 16; hfroscdiv_div18 : constant := 17; hfroscdiv_div19 : constant := 18; hfroscdiv_div20 : constant := 19;
      hfroscdiv_div21 : constant := 20; hfroscdiv_div22 : constant := 21; hfroscdiv_div23 : constant := 22; hfroscdiv_div24 : constant := 23;
      hfroscdiv_div25 : constant := 24; hfroscdiv_div26 : constant := 25; hfroscdiv_div27 : constant := 26; hfroscdiv_div28 : constant := 27;
      hfroscdiv_div29 : constant := 28; hfroscdiv_div30 : constant := 29; hfroscdiv_div31 : constant := 30; hfroscdiv_div32 : constant := 31;
      hfroscdiv_div33 : constant := 32; hfroscdiv_div34 : constant := 33; hfroscdiv_div35 : constant := 34; hfroscdiv_div36 : constant := 35;
      hfroscdiv_div37 : constant := 36; hfroscdiv_div38 : constant := 37; hfroscdiv_div39 : constant := 38; hfroscdiv_div40 : constant := 39;
      hfroscdiv_div41 : constant := 40; hfroscdiv_div42 : constant := 41; hfroscdiv_div43 : constant := 42; hfroscdiv_div44 : constant := 43;
      hfroscdiv_div45 : constant := 44; hfroscdiv_div46 : constant := 45; hfroscdiv_div47 : constant := 46; hfroscdiv_div48 : constant := 47;
      hfroscdiv_div49 : constant := 48; hfroscdiv_div50 : constant := 49; hfroscdiv_div51 : constant := 50; hfroscdiv_div52 : constant := 51;
      hfroscdiv_div53 : constant := 52; hfroscdiv_div54 : constant := 53; hfroscdiv_div55 : constant := 54; hfroscdiv_div56 : constant := 55;
      hfroscdiv_div57 : constant := 56; hfroscdiv_div58 : constant := 57; hfroscdiv_div59 : constant := 58; hfroscdiv_div60 : constant := 59;
      hfroscdiv_div61 : constant := 60; hfroscdiv_div62 : constant := 61; hfroscdiv_div63 : constant := 62; hfroscdiv_div64 : constant := 63;

      type hfrosccfg_Type is record
         hfroscdiv  : Bits_6  := hfroscdiv_div5; -- Ring Oscillator Divider Register
         Reserved1  : Bits_10 := 0;
         hfrosctrim : Bits_5  := 16#10#;         -- Ring Oscillator Trim Register
         Reserved2  : Bits_9  := 0;
         hfroscen   : Boolean := True;           -- Ring Oscillator Enable
         hfroscrdy  : Boolean := False;          -- Ring Oscillator Ready
      end record
         with Bit_Order   => Low_Order_First,
              Object_Size => 32;
      for hfrosccfg_Type use record
         hfroscdiv  at 0 range  0 ..  5;
         Reserved1  at 0 range  6 .. 15;
         hfrosctrim at 0 range 16 .. 20;
         Reserved2  at 0 range 21 .. 29;
         hfroscen   at 0 range 30 .. 30;
         hfroscrdy  at 0 range 31 .. 31;
      end record;

      -- 6.4 External 16 MHz Crystal Oscillator (HFXOSC)

      type hfxosccfg_Type is record
         Reserved  : Bits_30 := 0;
         hfxoscen  : Boolean := True;  -- Crystal Oscillator Enable
         hfxoscrdy : Boolean := False; -- Crystal Oscillator Ready
      end record
         with Bit_Order   => Low_Order_First,
              Object_Size => 32;
      for hfxosccfg_Type use record
         Reserved  at 0 range  0 .. 29;
         hfxoscen  at 0 range 30 .. 30;
         hfxoscrdy at 0 range 31 .. 31;
      end record;

      -- 6.5 Internal High-Frequency PLL (HFPLL)

      pllr_div1 : constant := 2#00#;
      pllr_div2 : constant := 2#01#;
      pllr_div3 : constant := 2#10#;
      pllr_div4 : constant := 2#11#;

      pllf_x2   : constant := 16#00#; pllf_x4   : constant := 16#01#; pllf_x6   : constant := 16#02#; pllf_x8   : constant := 16#03#;
      pllf_x10  : constant := 16#04#; pllf_x12  : constant := 16#05#; pllf_x14  : constant := 16#06#; pllf_x16  : constant := 16#07#;
      pllf_x18  : constant := 16#08#; pllf_x20  : constant := 16#09#; pllf_x22  : constant := 16#0A#; pllf_x24  : constant := 16#0B#;
      pllf_x26  : constant := 16#0C#; pllf_x28  : constant := 16#0D#; pllf_x30  : constant := 16#0E#; pllf_x32  : constant := 16#0F#;
      pllf_x34  : constant := 16#10#; pllf_x36  : constant := 16#11#; pllf_x38  : constant := 16#12#; pllf_x40  : constant := 16#13#;
      pllf_x42  : constant := 16#14#; pllf_x44  : constant := 16#15#; pllf_x46  : constant := 16#16#; pllf_x48  : constant := 16#17#;
      pllf_x50  : constant := 16#18#; pllf_x52  : constant := 16#19#; pllf_x54  : constant := 16#1A#; pllf_x56  : constant := 16#1B#;
      pllf_x58  : constant := 16#1C#; pllf_x60  : constant := 16#1D#; pllf_x62  : constant := 16#1E#; pllf_x64  : constant := 16#1F#;
      pllf_x66  : constant := 16#20#; pllf_x68  : constant := 16#21#; pllf_x70  : constant := 16#22#; pllf_x72  : constant := 16#23#;
      pllf_x74  : constant := 16#24#; pllf_x76  : constant := 16#25#; pllf_x78  : constant := 16#26#; pllf_x80  : constant := 16#27#;
      pllf_x82  : constant := 16#28#; pllf_x84  : constant := 16#29#; pllf_x86  : constant := 16#2A#; pllf_x88  : constant := 16#2B#;
      pllf_x90  : constant := 16#2C#; pllf_x92  : constant := 16#2D#; pllf_x94  : constant := 16#2E#; pllf_x96  : constant := 16#2F#;
      pllf_x98  : constant := 16#30#; pllf_x100 : constant := 16#31#; pllf_x102 : constant := 16#32#; pllf_x104 : constant := 16#33#;
      pllf_x106 : constant := 16#34#; pllf_x108 : constant := 16#35#; pllf_x110 : constant := 16#36#; pllf_x112 : constant := 16#37#;
      pllf_x114 : constant := 16#38#; pllf_x116 : constant := 16#39#; pllf_x118 : constant := 16#3A#; pllf_x120 : constant := 16#3B#;
      pllf_x122 : constant := 16#3C#; pllf_x124 : constant := 16#3D#; pllf_x126 : constant := 16#3E#; pllf_x128 : constant := 16#3F#;

      pllq_div2 : constant := 2#01#;
      pllq_div4 : constant := 2#10#;
      pllq_div8 : constant := 2#11#;

      pllsel_HFROSC : constant := 0; -- hfroscclk directly drives hfclk
      pllsel_PLL    : constant := 1; -- PLL drives hfclk

      pllrefsel_HFROSC : constant := 0; -- PLL driven by HFROSC
      pllrefsel_HFXOSC : constant := 1; -- PLL driven by HFXOSC

      type pllcfg_Type is record
         pllr      : Bits_3  := pllr_div2;        -- PLL R Value
         Reserved1 : Bits_1  := 0;
         pllf      : Bits_6  := pllf_x64;         -- PLL F Value
         pllq      : Bits_2  := pllq_div8;        -- PLL Q Value
         Reserved2 : Bits_4  := 0;
         pllsel    : Bits_1  := pllsel_HFROSC;    -- PLL Select
         pllrefsel : Bits_1  := pllrefsel_HFXOSC; -- PLL Reference Select
         pllbypass : Boolean := True;             -- PLL Bypass
         Reserved3 : Bits_12 := 0;
         plllock   : Boolean := False;            -- PLL Lock (RO)
      end record
         with Bit_Order   => Low_Order_First,
              Object_Size => 32;
      for pllcfg_Type use record
         pllr      at 0 range  0 ..  2;
         Reserved1 at 0 range  3 ..  3;
         pllf      at 0 range  4 ..  9;
         pllq      at 0 range 10 .. 11;
         Reserved2 at 0 range 12 .. 15;
         pllsel    at 0 range 16 .. 16;
         pllrefsel at 0 range 17 .. 17;
         pllbypass at 0 range 18 .. 18;
         Reserved3 at 0 range 19 .. 30;
         plllock   at 0 range 31 .. 31;
      end record;

      -- 6.6 PLL Output Divider

      plloutdiv_div2   : constant := 16#00#; plloutdiv_div4   : constant := 16#01#; plloutdiv_div6   : constant := 16#02#; plloutdiv_div8   : constant := 16#03#;
      plloutdiv_div10  : constant := 16#04#; plloutdiv_div12  : constant := 16#05#; plloutdiv_div14  : constant := 16#06#; plloutdiv_div16  : constant := 16#07#;
      plloutdiv_div18  : constant := 16#08#; plloutdiv_div20  : constant := 16#09#; plloutdiv_div22  : constant := 16#0A#; plloutdiv_div24  : constant := 16#0B#;
      plloutdiv_div26  : constant := 16#0C#; plloutdiv_div28  : constant := 16#0D#; plloutdiv_div30  : constant := 16#0E#; plloutdiv_div32  : constant := 16#0F#;
      plloutdiv_div34  : constant := 16#10#; plloutdiv_div36  : constant := 16#11#; plloutdiv_div38  : constant := 16#12#; plloutdiv_div40  : constant := 16#13#;
      plloutdiv_div42  : constant := 16#14#; plloutdiv_div44  : constant := 16#15#; plloutdiv_div46  : constant := 16#16#; plloutdiv_div48  : constant := 16#17#;
      plloutdiv_div50  : constant := 16#18#; plloutdiv_div52  : constant := 16#19#; plloutdiv_div54  : constant := 16#1A#; plloutdiv_div56  : constant := 16#1B#;
      plloutdiv_div58  : constant := 16#1C#; plloutdiv_div60  : constant := 16#1D#; plloutdiv_div62  : constant := 16#1E#; plloutdiv_div64  : constant := 16#1F#;
      plloutdiv_div66  : constant := 16#20#; plloutdiv_div68  : constant := 16#21#; plloutdiv_div70  : constant := 16#22#; plloutdiv_div72  : constant := 16#23#;
      plloutdiv_div74  : constant := 16#24#; plloutdiv_div76  : constant := 16#25#; plloutdiv_div78  : constant := 16#26#; plloutdiv_div80  : constant := 16#27#;
      plloutdiv_div82  : constant := 16#28#; plloutdiv_div84  : constant := 16#29#; plloutdiv_div86  : constant := 16#2A#; plloutdiv_div88  : constant := 16#2B#;
      plloutdiv_div90  : constant := 16#2C#; plloutdiv_div92  : constant := 16#2D#; plloutdiv_div94  : constant := 16#2E#; plloutdiv_div96  : constant := 16#2F#;
      plloutdiv_div98  : constant := 16#30#; plloutdiv_div100 : constant := 16#31#; plloutdiv_div102 : constant := 16#32#; plloutdiv_div104 : constant := 16#33#;
      plloutdiv_div106 : constant := 16#34#; plloutdiv_div108 : constant := 16#35#; plloutdiv_div110 : constant := 16#36#; plloutdiv_div112 : constant := 16#37#;
      plloutdiv_div114 : constant := 16#38#; plloutdiv_div116 : constant := 16#39#; plloutdiv_div118 : constant := 16#3A#; plloutdiv_div120 : constant := 16#3B#;
      plloutdiv_div122 : constant := 16#3C#; plloutdiv_div124 : constant := 16#3D#; plloutdiv_div126 : constant := 16#3E#; plloutdiv_div128 : constant := 16#3F#;

      plloutdivby1_CLR : constant := 0; -- PLL Final Divide By plloutdiv_...
      plloutdivby1_SET : constant := 1; -- PLL Final Divide By 1

      type plloutdiv_Type is record
         plloutdiv    : Bits_6  := plloutdiv_div2;   -- PLL Final Divider Value
         Reserved1    : Bits_2  := 0;
         plloutdivby1 : Bits_6  := plloutdivby1_SET; -- PLL Final Divide By 1
         Reserved2    : Bits_18 := 0;
      end record
         with Bit_Order   => Low_Order_First,
              Object_Size => 32;
      for plloutdiv_Type use record
         plloutdiv    at 0 range  0 ..  5;
         Reserved1    at 0 range  6 ..  7;
         plloutdivby1 at 0 range  8 .. 13;
         Reserved2    at 0 range 14 .. 31;
      end record;

      -- 6.7 Internal Programmable Low-Frequency Ring Oscillator (LFROSC)

      lfroscdiv_div1  : constant := 16#00#; lfroscdiv_div2  : constant := 16#01#; lfroscdiv_div3  : constant := 16#02#; lfroscdiv_div4  : constant := 16#03#;
      lfroscdiv_div5  : constant := 16#04#; lfroscdiv_div6  : constant := 16#05#; lfroscdiv_div7  : constant := 16#06#; lfroscdiv_div8  : constant := 16#07#;
      lfroscdiv_div9  : constant := 16#08#; lfroscdiv_div10 : constant := 16#09#; lfroscdiv_div11 : constant := 16#0A#; lfroscdiv_div12 : constant := 16#0B#;
      lfroscdiv_div13 : constant := 16#0C#; lfroscdiv_div14 : constant := 16#0D#; lfroscdiv_div15 : constant := 16#0E#; lfroscdiv_div16 : constant := 16#0F#;
      lfroscdiv_div17 : constant := 16#10#; lfroscdiv_div18 : constant := 16#11#; lfroscdiv_div19 : constant := 16#12#; lfroscdiv_div20 : constant := 16#13#;
      lfroscdiv_div21 : constant := 16#14#; lfroscdiv_div22 : constant := 16#15#; lfroscdiv_div23 : constant := 16#16#; lfroscdiv_div24 : constant := 16#17#;
      lfroscdiv_div25 : constant := 16#18#; lfroscdiv_div26 : constant := 16#19#; lfroscdiv_div27 : constant := 16#1A#; lfroscdiv_div28 : constant := 16#1B#;
      lfroscdiv_div29 : constant := 16#1C#; lfroscdiv_div30 : constant := 16#1D#; lfroscdiv_div31 : constant := 16#1E#; lfroscdiv_div32 : constant := 16#1F#;
      lfroscdiv_div33 : constant := 16#20#; lfroscdiv_div34 : constant := 16#21#; lfroscdiv_div35 : constant := 16#22#; lfroscdiv_div36 : constant := 16#23#;
      lfroscdiv_div37 : constant := 16#24#; lfroscdiv_div38 : constant := 16#25#; lfroscdiv_div39 : constant := 16#26#; lfroscdiv_div40 : constant := 16#27#;
      lfroscdiv_div41 : constant := 16#28#; lfroscdiv_div42 : constant := 16#29#; lfroscdiv_div43 : constant := 16#2A#; lfroscdiv_div44 : constant := 16#2B#;
      lfroscdiv_div45 : constant := 16#2C#; lfroscdiv_div46 : constant := 16#2D#; lfroscdiv_div47 : constant := 16#2E#; lfroscdiv_div48 : constant := 16#2F#;
      lfroscdiv_div49 : constant := 16#30#; lfroscdiv_div50 : constant := 16#31#; lfroscdiv_div51 : constant := 16#32#; lfroscdiv_div52 : constant := 16#33#;
      lfroscdiv_div53 : constant := 16#34#; lfroscdiv_div54 : constant := 16#35#; lfroscdiv_div55 : constant := 16#36#; lfroscdiv_div56 : constant := 16#37#;
      lfroscdiv_div57 : constant := 16#38#; lfroscdiv_div58 : constant := 16#39#; lfroscdiv_div59 : constant := 16#3A#; lfroscdiv_div60 : constant := 16#3B#;
      lfroscdiv_div61 : constant := 16#3C#; lfroscdiv_div62 : constant := 16#3D#; lfroscdiv_div63 : constant := 16#3E#; lfroscdiv_div64 : constant := 16#3F#;

      type lfrosccfg_Type is record
         lfroscdiv  : Bits_6  := lfroscdiv_div5; -- Ring Oscillator Divider Register
         Reserved1  : Bits_10 := 0;
         lfrosctrim : Bits_5  := 16#10#;         -- Ring Oscillator Trim Register
         Reserved2  : Bits_9  := 0;
         lfroscen   : Boolean := True;           -- Ring Oscillator Enable
         lfroscrdy  : Boolean := False;          -- Ring Oscillator Ready
      end record
         with Bit_Order   => Low_Order_First,
              Object_Size => 32;
      for lfrosccfg_Type use record
         lfroscdiv  at 0 range  0 ..  5;
         Reserved1  at 0 range  6 .. 15;
         lfrosctrim at 0 range 16 .. 20;
         Reserved2  at 0 range 21 .. 29;
         lfroscen   at 0 range 30 .. 30;
         lfroscrdy  at 0 range 31 .. 31;
      end record;

      -- 6.8 Alternate Low-Frequency Clock (LFALTCLK)

      lfextclk_sel_LFROSC : constant := 0; -- low-frequency clock source = LFROSC
      lfextclk_sel_EXT    : constant := 1; -- low-frequency clock source = psdlfaltclk pad

      type lfclkmux_Type is record
         lfextclk_sel        : Bits_1  := lfextclk_sel_LFROSC; -- Low Frequency Clock Source Selector
         Reserved            : Bits_30 := 0;
         lfextclk_mux_status : Boolean := False;               -- Setting of the aon_lfclksel pin (RO)
      end record
         with Bit_Order   => Low_Order_First,
              Object_Size => 32;
      for lfclkmux_Type use record
         lfextclk_sel        at 0 range  0 ..  0;
         Reserved            at 0 range  1 .. 30;
         lfextclk_mux_status at 0 range 31 .. 31;
      end record;

      hfrosccfg : aliased hfrosccfg_Type
         with Address              => System'To_Address (PRCI_BASEADDRESS + 16#00#),
              Volatile_Full_Access => True,
              Import               => True,
              Convention           => Ada;

      hfxosccfg : aliased hfxosccfg_Type
         with Address              => System'To_Address (PRCI_BASEADDRESS + 16#04#),
              Volatile_Full_Access => True,
              Import               => True,
              Convention           => Ada;

      pllcfg : aliased pllcfg_Type
         with Address              => System'To_Address (PRCI_BASEADDRESS + 16#08#),
              Volatile_Full_Access => True,
              Import               => True,
              Convention           => Ada;

      plloutdiv : aliased plloutdiv_Type
         with Address              => System'To_Address (PRCI_BASEADDRESS + 16#0C#),
              Volatile_Full_Access => True,
              Import               => True,
              Convention           => Ada;

      lfrosccfg : aliased lfrosccfg_Type
         with Address              => System'To_Address (PRCI_BASEADDRESS + 16#70#),
              Volatile_Full_Access => True,
              Import               => True,
              Convention           => Ada;

      lfclkmux : aliased lfclkmux_Type
         with Address              => System'To_Address (PRCI_BASEADDRESS + 16#7C#),
              Volatile_Full_Access => True,
              Import               => True,
              Convention           => Ada;

   end PRCI;

   ----------------------------------------------------------------------------
   -- 9 Core-Local Interruptor (CLINT)
   ----------------------------------------------------------------------------

   package CLINT
      is

      -- 9.2 MSIP Registers

      type msip_Type is record
         MSIP     : Boolean;      -- Machine-mode software interrupt
         Reserved : Bits_31 := 0;
      end record
         with Bit_Order   => Low_Order_First,
              Object_Size => 32;
      for msip_Type use record
         MSIP     at 0 range 0 ..  0;
         Reserved at 0 range 1 .. 31;
      end record;

      msip_ADDRESS : constant := 16#0200_0000#;

      msip : aliased msip_Type
         with Address              => System'To_Address (msip_ADDRESS),
              Volatile_Full_Access => True,
              Import               => True,
              Convention           => Ada;

      -- 9.3 Timer Registers

      mtime : aliased RISCV.mtime_Type
         with Volatile      => True,
              Import        => True,
              Convention    => Ada,
              External_Name => "_riscv_mtime_mmap";

      mtimecmp : aliased RISCV.mtime_Type
         with Volatile      => True,
              Import        => True,
              Convention    => Ada,
              External_Name => "_riscv_mtimecmp_mmap";

   end CLINT;

   ----------------------------------------------------------------------------
   -- 10 Platform-Level Interrupt Controller (PLIC)
   ----------------------------------------------------------------------------

   package PLIC
      is

      PLIC_BASEADDRESS : constant := 16#0C00_0000#;

      -- 10.2 Interrupt Sources

      IntID_NONE         : constant := 0;
      IntID_AON_Watchdog : constant := 1;
      IntID_AON_RTC      : constant := 2;
      IntID_UART0        : constant := 3;
      IntID_UART1        : constant := 4;
      IntID_QSPI0        : constant := 5;
      IntID_SPI1         : constant := 6;
      IntID_SPI2         : constant := 7;
      IntID_GPIO0        : constant := 8;
      IntID_GPIO1        : constant := 9;
      IntID_GPIO2        : constant := 10;
      IntID_GPIO3        : constant := 11;
      IntID_GPIO4        : constant := 12;
      IntID_GPIO5        : constant := 13;
      IntID_GPIO6        : constant := 14;
      IntID_GPIO7        : constant := 15;
      IntID_GPIO8        : constant := 16;
      IntID_GPIO9        : constant := 17;
      IntID_GPIO10       : constant := 18;
      IntID_GPIO11       : constant := 19;
      IntID_GPIO12       : constant := 20;
      IntID_GPIO13       : constant := 21;
      IntID_GPIO14       : constant := 22;
      IntID_GPIO15       : constant := 23;
      IntID_GPIO16       : constant := 24;
      IntID_GPIO17       : constant := 25;
      IntID_GPIO18       : constant := 26;
      IntID_GPIO19       : constant := 27;
      IntID_GPIO20       : constant := 28;
      IntID_GPIO21       : constant := 29;
      IntID_GPIO22       : constant := 30;
      IntID_GPIO23       : constant := 31;
      IntID_GPIO24       : constant := 32;
      IntID_GPIO25       : constant := 33;
      IntID_GPIO26       : constant := 34;
      IntID_GPIO27       : constant := 35;
      IntID_GPIO28       : constant := 36;
      IntID_GPIO29       : constant := 37;
      IntID_GPIO30       : constant := 38;
      IntID_GPIO31       : constant := 39;
      IntID_PWM00        : constant := 40;
      IntID_PWM01        : constant := 41;
      IntID_PWM02        : constant := 42;
      IntID_PWM03        : constant := 43;
      IntID_PWM10        : constant := 44;
      IntID_PWM11        : constant := 45;
      IntID_PWM12        : constant := 46;
      IntID_PWM13        : constant := 47;
      IntID_PWM20        : constant := 48;
      IntID_PWM21        : constant := 49;
      IntID_PWM22        : constant := 50;
      IntID_PWM23        : constant := 51;
      IntID_I2C          : constant := 52;

      -- 10.3 Interrupt Priorities

      type priority_Type is record
         Priority : Bits_3;       -- Sets the priority for a given global interrupt.
         Reserved : Bits_29 := 0;
      end record
         with Bit_Order            => Low_Order_First,
              Object_Size          => 32,
              Volatile_Full_Access => True;
      for priority_Type use record
         Priority at 0 range 0 ..  2;
         Reserved at 0 range 3 .. 31;
      end record;

      priority : aliased array (0 .. 52) of priority_Type
         with Address    => System'To_Address (PLIC_BASEADDRESS + 16#0000_0000#),
              Volatile   => True,
              Import     => True,
              Convention => Ada;

      -- 10.4 Interrupt Pending Bits

      pending1 : aliased Bitmap_32
         with Address    => System'To_Address (PLIC_BASEADDRESS + 16#0000_1000#),
              Volatile   => True,
              Import     => True,
              Convention => Ada;

      pending2 : aliased Bitmap_32
         with Address    => System'To_Address (PLIC_BASEADDRESS + 16#0000_1004#),
              Volatile   => True,
              Import     => True,
              Convention => Ada;

      -- 10.5 Interrupt Enables

      enable1 : aliased Bitmap_32
         with Address    => System'To_Address (PLIC_BASEADDRESS + 16#0000_2000#),
              Volatile   => True,
              Import     => True,
              Convention => Ada;

      enable2 : aliased Bitmap_32
         with Address    => System'To_Address (PLIC_BASEADDRESS + 16#0000_2004#),
              Volatile   => True,
              Import     => True,
              Convention => Ada;

      -- 10.6 Priority Thresholds

      type threshold_Type is record
         Threshold : Bits_3;       -- Sets the priority threshold
         Reserved  : Bits_29 := 0;
      end record
         with Bit_Order   => Low_Order_First,
              Object_Size => 32;
      for threshold_Type use record
         Threshold at 0 range 0 ..  2;
         Reserved  at 0 range 3 .. 31;
      end record;

      threshold : aliased threshold_Type
         with Address              => System'To_Address (PLIC_BASEADDRESS + 16#0020_0000#),
              Volatile_Full_Access => True,
              Import               => True,
              Convention           => Ada;

      -- 10.7 Interrupt Claim Process
      -- 10.8 Interrupt Completion

      claim : aliased Unsigned_32
         with Address              => System'To_Address (PLIC_BASEADDRESS + 16#0020_0004#),
              Volatile_Full_Access => True,
              Import               => True,
              Convention           => Ada;

   end PLIC;

   ----------------------------------------------------------------------------
   -- 12 One-Time Programmable Memory (OTP) Peripheral
   ----------------------------------------------------------------------------

   package OTP
      is

      OTP_BASEADDRESS : constant := 16#1001_0000#;

      -- 12.4 Read sequencer control register (otp_rsctrl)

      scale_1   : constant := 2#000#; -- The number of clock cycles in each phase = 1
      scale_2   : constant := 2#001#; -- The number of clock cycles in each phase = 2
      scale_4   : constant := 2#010#; -- The number of clock cycles in each phase = 4
      scale_8   : constant := 2#011#; -- The number of clock cycles in each phase = 8
      scale_16  : constant := 2#100#; -- The number of clock cycles in each phase = 16
      scale_32  : constant := 2#101#; -- The number of clock cycles in each phase = 32
      scale_64  : constant := 2#110#; -- The number of clock cycles in each phase = 64
      scale_128 : constant := 2#111#; -- The number of clock cycles in each phase = 128

      type rsctrl_Type is record
         scale    : Bits_3  := scale_2; -- OTP timescale
         tas      : Boolean := False;   -- Address setup time
         trp      : Boolean := False;   -- Read pulse time
         tacc     : Boolean := False;   -- Read access time
         Reserved : Bits_26 := 0;
      end record
         with Bit_Order   => Low_Order_First,
              Object_Size => 32;
      for rsctrl_Type use record
         scale    at 0 range 0 ..  2;
         tas      at 0 range 3 ..  3;
         trp      at 0 range 4 ..  4;
         tacc     at 0 range 5 ..  5;
         Reserved at 0 range 6 .. 31;
      end record;

      -- 12.1 Memory Map

      -- Programmed-I/O lock register
      lock   : aliased Unsigned_32 with Address => System'To_Address (OTP_BASEADDRESS + 16#00#), Volatile_Full_Access => True, Import => True, Convention => Ada;
      -- OTP device output-enable signal
      ck     : aliased Unsigned_32 with Address => System'To_Address (OTP_BASEADDRESS + 16#04#), Volatile_Full_Access => True, Import => True, Convention => Ada;
      -- OTP device output-enable signal
      oe     : aliased Unsigned_32 with Address => System'To_Address (OTP_BASEADDRESS + 16#08#), Volatile_Full_Access => True, Import => True, Convention => Ada;
      -- OTP device chip-select signal
      sel    : aliased Unsigned_32 with Address => System'To_Address (OTP_BASEADDRESS + 16#0C#), Volatile_Full_Access => True, Import => True, Convention => Ada;
      -- OTP device write-enable signal
      we     : aliased Unsigned_32 with Address => System'To_Address (OTP_BASEADDRESS + 16#10#), Volatile_Full_Access => True, Import => True, Convention => Ada;
      -- OTP device mode register
      mr     : aliased Unsigned_32 with Address => System'To_Address (OTP_BASEADDRESS + 16#14#), Volatile_Full_Access => True, Import => True, Convention => Ada;
      -- OTP read-voltage regulator control
      mrr    : aliased Unsigned_32 with Address => System'To_Address (OTP_BASEADDRESS + 16#18#), Volatile_Full_Access => True, Import => True, Convention => Ada;
      -- OTP write-voltage charge pump control
      mpp    : aliased Unsigned_32 with Address => System'To_Address (OTP_BASEADDRESS + 16#1C#), Volatile_Full_Access => True, Import => True, Convention => Ada;
      -- OTP read-voltage enable
      vrren  : aliased Unsigned_32 with Address => System'To_Address (OTP_BASEADDRESS + 16#20#), Volatile_Full_Access => True, Import => True, Convention => Ada;
      -- OTP write-voltage enable
      vppen  : aliased Unsigned_32 with Address => System'To_Address (OTP_BASEADDRESS + 16#24#), Volatile_Full_Access => True, Import => True, Convention => Ada;
      -- OTP device address
      otp_a  : aliased Unsigned_32 with Address => System'To_Address (OTP_BASEADDRESS + 16#28#), Volatile_Full_Access => True, Import => True, Convention => Ada;
      -- OTP device data input
      otp_d  : aliased Unsigned_32 with Address => System'To_Address (OTP_BASEADDRESS + 16#2C#), Volatile_Full_Access => True, Import => True, Convention => Ada;
      -- OTP device data output
      otp_q  : aliased Unsigned_32 with Address => System'To_Address (OTP_BASEADDRESS + 16#30#), Volatile_Full_Access => True, Import => True, Convention => Ada;
      -- OTP read sequencer control
      rsctrl : aliased rsctrl_Type with Address => System'To_Address (OTP_BASEADDRESS + 16#34#), Volatile_Full_Access => True, Import => True, Convention => Ada;

   end OTP;

   ----------------------------------------------------------------------------
   -- 13 Always-On (AON) Domain
   ----------------------------------------------------------------------------

   package AON
      is

      AON_BASEADDRESS : constant := 16#1000_0000#;

      -- 13.9 Backup Registers

      type backup_Type is new Bits_32
         with Volatile_Full_Access => True;

      backup : aliased array (0 .. 15) of backup_Type
         with Address    => System'To_Address (AON.AON_BASEADDRESS + 16#80#),
              Volatile   => True,
              Import     => True,
              Convention => Ada;

   end AON;

   ----------------------------------------------------------------------------
   -- 14 Watchdog Timer (WDT)
   ----------------------------------------------------------------------------

   package WDT
      is

      wdogkey_Value  : constant := 16#0051_F15E#;
      wdogfeed_Value : constant := 16#0D09_F00D#;

      -- 14.3 Watchdog Configuration Register (wdogcfg)

      wdogscale_NOSCALING : constant := 0;  -- scales the watchdog counter value by 2^0
      wdogscale_SCALE2    : constant := 1;  -- scales the watchdog counter value by 2^1
      wdogscale_SCALE4    : constant := 2;  -- scales the watchdog counter value by 2^2
      wdogscale_SCALE8    : constant := 3;  -- scales the watchdog counter value by 2^3
      wdogscale_SCALE16   : constant := 4;  -- scales the watchdog counter value by 2^4
      wdogscale_SCALE32   : constant := 5;  -- scales the watchdog counter value by 2^5
      wdogscale_SCALE64   : constant := 6;  -- scales the watchdog counter value by 2^6
      wdogscale_SCALE128  : constant := 7;  -- scales the watchdog counter value by 2^7
      wdogscale_SCALE256  : constant := 8;  -- scales the watchdog counter value by 2^8
      wdogscale_SCALE512  : constant := 9;  -- scales the watchdog counter value by 2^9
      wdogscale_SCALE1k   : constant := 10; -- scales the watchdog counter value by 2^10
      wdogscale_SCALE2k   : constant := 11; -- scales the watchdog counter value by 2^11
      wdogscale_SCALE4k   : constant := 12; -- scales the watchdog counter value by 2^12
      wdogscale_SCALE8k   : constant := 13; -- scales the watchdog counter value by 2^13
      wdogscale_SCALE16k  : constant := 14; -- scales the watchdog counter value by 2^14
      wdogscale_SCALE32k  : constant := 15; -- scales the watchdog counter value by 2^15

      type wdogcfg_Type is record
         wdogscale     : Bits_4;           -- Counter scale value.
         Reserved1     : Bits_4  := 0;
         wdogrsten     : Boolean := False; -- Controls whether the comp output can set the wdogrst bit and hence cause a full reset.
         wdogzerocmp   : Boolean;
         Reserved2     : Bits_2  := 0;
         wdogenalways  : Boolean := False; -- Enable Always - run continuously
         wdogcoreawake : Boolean := False; -- Increment the watchdog counter if the processor is not asleep
         Reserved3     : Bits_14 := 0;
         wdogip0       : Boolean;          -- Interrupt 0 Pending
         Reserved4     : Bits_3  := 0;
      end record
         with Bit_Order   => Low_Order_First,
              Object_Size => 32;
      for wdogcfg_Type use record
         wdogscale     at 0 range  0 ..  3;
         Reserved1     at 0 range  4 ..  7;
         wdogrsten     at 0 range  8 ..  8;
         wdogzerocmp   at 0 range  9 ..  9;
         Reserved2     at 0 range 10 .. 11;
         wdogenalways  at 0 range 12 .. 12;
         wdogcoreawake at 0 range 13 .. 13;
         Reserved3     at 0 range 14 .. 27;
         wdogip0       at 0 range 28 .. 28;
         Reserved4     at 0 range 29 .. 31;
      end record;

      -- 14.4 Watchdog Compare Register (wdogcmp)

      type wdogcmp_Type is record
         wdogcmp0 : Unsigned_16;      -- Comparator 0
         Reserved : Bits_16     := 0;
      end record
         with Bit_Order   => Low_Order_First,
              Object_Size => 32;
      for wdogcmp_Type use record
         wdogcmp0 at 0 range  0 .. 15;
         Reserved at 0 range 16 .. 31;
      end record;

      wdogcfg : aliased wdogcfg_Type
         with Address              => System'To_Address (AON.AON_BASEADDRESS + 16#00#),
              Volatile_Full_Access => True,
              Import               => True,
              Convention           => Ada;

      wdogcount : aliased Unsigned_32
         with Address              => System'To_Address (AON.AON_BASEADDRESS + 16#08#),
              Volatile_Full_Access => True,
              Import               => True,
              Convention           => Ada;

      wdogs : aliased Unsigned_16
         with Address              => System'To_Address (AON.AON_BASEADDRESS + 16#10#),
              Volatile_Full_Access => True,
              Import               => True,
              Convention           => Ada;

      wdogfeed : aliased Unsigned_32
         with Address              => System'To_Address (AON.AON_BASEADDRESS + 16#18#),
              Volatile_Full_Access => True,
              Import               => True,
              Convention           => Ada;

      wdogkey : aliased Unsigned_32
         with Address              => System'To_Address (AON.AON_BASEADDRESS + 16#1C#),
              Volatile_Full_Access => True,
              Import               => True,
              Convention           => Ada;

      wdogcmp0 : aliased wdogcmp_Type
         with Address              => System'To_Address (AON.AON_BASEADDRESS + 16#20#),
              Volatile_Full_Access => True,
              Import               => True,
              Convention           => Ada;

   end WDT;

   ----------------------------------------------------------------------------
   -- 15 Power-Management Unit (PMU)
   ----------------------------------------------------------------------------

   package PMU
      is

      -- 15.3 PMU Key Register (pmukey)

      pmukey_Value : constant := 16#0051_F15E#;

      pmukey : aliased Bits_32
         with Address              => System'To_Address (AON.AON_BASEADDRESS + 16#14C#),
              Volatile_Full_Access => True,
              Import               => True,
              Convention           => Ada;

      -- 15.4 PMU Program

      type pmu_sleep_wakeup_iX_Type is record
         delaym       : Bits_4;       -- delay multiplier
         pmu_out_0_en : Boolean;      -- Drive PMU Output En 0 High
         pmu_out_1_en : Boolean;      -- Drive PMU Output En 1 High
         corerst      : Boolean;      -- Core Reset
         hfclkrst     : Boolean;      -- High-Frequency Clock Reset
         isolate      : Boolean;      -- Isolate MOFF-to-AON Power Domains
         Reserved     : Bits_23 := 0;
      end record
         with Bit_Order            => Low_Order_First,
              Object_Size          => 32,
              Volatile_Full_Access => True;
      for pmu_sleep_wakeup_iX_Type use record
         delaym       at 0 range 0 ..  3;
         pmu_out_0_en at 0 range 4 ..  4;
         pmu_out_1_en at 0 range 5 ..  5;
         corerst      at 0 range 6 ..  6;
         hfclkrst     at 0 range 7 ..  7;
         isolate      at 0 range 8 ..  8;
         Reserved     at 0 range 9 .. 31;
      end record;

      pmuwakeupi : aliased array (0 .. 7) of pmu_sleep_wakeup_iX_Type
         with Address    => System'To_Address (AON.AON_BASEADDRESS + 16#100#),
              Volatile   => True,
              Import     => True,
              Convention => Ada;

      pmusleepi : aliased array (0 .. 7) of pmu_sleep_wakeup_iX_Type
         with Address    => System'To_Address (AON.AON_BASEADDRESS + 16#120#),
              Volatile   => True,
              Import     => True,
              Convention => Ada;

      -- 15.5 Initiate Sleep Sequence Register (pmusleep)

      pmusleep : aliased Bits_32
         with Address              => System'To_Address (AON.AON_BASEADDRESS + 16#148#),
              Volatile_Full_Access => True,
              Import               => True,
              Convention           => Ada;

      -- 15.7 PMU Interrupt Enables (pmuie) and Wakeup Cause (pmucause)

      type pmuie_Type is record
         rtc      : Boolean;      -- RTC wakeup
         dwakeup  : Boolean;      -- Digital input wakeup
         awakeup  : Boolean;      -- ??? Analog input wakeup
         Reserved : Bits_29 := 0;
      end record
         with Bit_Order   => Low_Order_First,
              Object_Size => 32;
      for pmuie_Type use record
         rtc      at 0 range 0 ..  0;
         dwakeup  at 0 range 1 ..  1;
         awakeup  at 0 range 2 ..  2;
         Reserved at 0 range 3 .. 31;
      end record;

      pmuie : aliased pmuie_Type
         with Address              => System'To_Address (AON.AON_BASEADDRESS + 16#140#),
              Volatile_Full_Access => True,
              Import               => True,
              Convention           => Ada;

      type pmucause_Type is record
         reset     : Boolean; -- Reset
         rtc       : Boolean; -- RTC wakeup
         dwakeup   : Boolean; -- Digital input wakeup
         Reserved1 : Bits_5;
         ponreset  : Boolean; -- Power-on reset
         extreset  : Boolean; -- External reset
         wdogreset : Boolean; -- Watchdog timer reset
         Reserved2 : Bits_21;
      end record
         with Bit_Order   => Low_Order_First,
              Object_Size => 32;
      for pmucause_Type use record
         reset     at 0 range  0 ..  0;
         rtc       at 0 range  1 ..  1;
         dwakeup   at 0 range  2 ..  2;
         Reserved1 at 0 range  3 ..  7;
         ponreset  at 0 range  8 ..  8;
         extreset  at 0 range  9 ..  9;
         wdogreset at 0 range 10 .. 10;
         Reserved2 at 0 range 11 .. 31;
      end record;

      pmucause : aliased pmucause_Type
         with Address              => System'To_Address (AON.AON_BASEADDRESS + 16#144#),
              Volatile_Full_Access => True,
              Import               => True,
              Convention           => Ada;

   end PMU;

   ----------------------------------------------------------------------------
   -- 16 Real-Time Clock (RTC)
   ----------------------------------------------------------------------------

   package RTC
      is

      rtcscale_DIVNONE : constant := 2#0000#;
      rtcscale_DIV2    : constant := 2#0001#;
      rtcscale_DIV4    : constant := 2#0010#;
      rtcscale_DIV8    : constant := 2#0011#;
      rtcscale_DIV16   : constant := 2#0100#;
      rtcscale_DIV32   : constant := 2#0101#;
      rtcscale_DIV64   : constant := 2#0110#;
      rtcscale_DIV128  : constant := 2#0111#;
      rtcscale_DIV256  : constant := 2#1000#;
      rtcscale_DIV512  : constant := 2#1001#;
      rtcscale_DIV1k   : constant := 2#1010#;
      rtcscale_DIV2k   : constant := 2#1011#;
      rtcscale_DIV4k   : constant := 2#1100#;
      rtcscale_DIV8k   : constant := 2#1101#;
      rtcscale_DIV16k  : constant := 2#1110#;
      rtcscale_DIV32k  : constant := 2#1111#;

      type rtccfg_Type is record
         rtcscale    : Bits_4;       -- Counter scale value.
         Reserved1   : Bits_8  := 0;
         rtcenalways : Boolean;      -- Enable Always - run continuously
         Reserved2   : Bits_15 := 0;
         rtcip0      : Boolean;      -- Interrupt 0 Pending
         Reserved3   : Bits_3  := 0;
      end record
         with Bit_Order   => Low_Order_First,
              Object_Size => 32;
      for rtccfg_Type use record
         rtcscale    at 0 range  0 ..  3;
         Reserved1   at 0 range  4 .. 11;
         rtcenalways at 0 range 12 .. 12;
         Reserved2   at 0 range 13 .. 27;
         rtcip0      at 0 range 28 .. 28;
         Reserved3   at 0 range 29 .. 31;
      end record;

      rtccfg : aliased rtccfg_Type
         with Address              => System'To_Address (AON.AON_BASEADDRESS + 16#40#),
              Volatile_Full_Access => True,
              Import               => True,
              Convention           => Ada;

      rtccountlo : aliased Unsigned_32
         with Address              => System'To_Address (AON.AON_BASEADDRESS + 16#48#),
              Volatile_Full_Access => True,
              Import               => True,
              Convention           => Ada;

      rtccounthi : aliased Unsigned_32
         with Address              => System'To_Address (AON.AON_BASEADDRESS + 16#4C#),
              Volatile_Full_Access => True,
              Import               => True,
              Convention           => Ada;

      rtcs : aliased Unsigned_32
         with Address              => System'To_Address (AON.AON_BASEADDRESS + 16#50#),
              Volatile_Full_Access => True,
              Import               => True,
              Convention           => Ada;

      rtccmp0 : aliased Unsigned_32
         with Address              => System'To_Address (AON.AON_BASEADDRESS + 16#60#),
              Volatile_Full_Access => True,
              Import               => True,
              Convention           => Ada;

   end RTC;

   ----------------------------------------------------------------------------
   -- 17 General Purpose Input/Output Controller (GPIO)
   ----------------------------------------------------------------------------

   package GPIO
      is

      GPIO_BASEADDRESS : constant := 16#1001_2000#;

      -- Pin value
      input_val : aliased Bitmap_32
         with Address              => System'To_Address (GPIO_BASEADDRESS + 16#00#),
              Volatile_Full_Access => True,
              Import               => True,
              Convention           => Ada;

      -- Pin input enable
      input_en : aliased Bitmap_32
         with Address              => System'To_Address (GPIO_BASEADDRESS + 16#04#),
              Volatile_Full_Access => True,
              Import               => True,
              Convention           => Ada;

      -- Pin output enable
      output_en : aliased Bitmap_32
         with Address              => System'To_Address (GPIO_BASEADDRESS + 16#08#),
              Volatile_Full_Access => True,
              Import               => True,
              Convention           => Ada;

      -- Output value
      output_val : aliased Bitmap_32
         with Address              => System'To_Address (GPIO_BASEADDRESS + 16#0C#),
              Volatile_Full_Access => True,
              Import               => True,
              Convention           => Ada;

      -- Internal pull-up enable
      pue : aliased Bitmap_32
         with Address              => System'To_Address (GPIO_BASEADDRESS + 16#10#),
              Volatile_Full_Access => True,
              Import               => True,
              Convention           => Ada;

      -- Pin drive strength
      ds : aliased Bitmap_32
         with Address              => System'To_Address (GPIO_BASEADDRESS + 16#14#),
              Volatile_Full_Access => True,
              Import               => True,
              Convention           => Ada;

      -- Rise interrupt enable
      rise_ie : aliased Bitmap_32
         with Address              => System'To_Address (GPIO_BASEADDRESS + 16#18#),
              Volatile_Full_Access => True,
              Import               => True,
              Convention           => Ada;

      -- Rise interrupt pending
      rise_ip : aliased Bitmap_32
         with Address              => System'To_Address (GPIO_BASEADDRESS + 16#1C#),
              Volatile_Full_Access => True,
              Import               => True,
              Convention           => Ada;

      -- Fall interrupt enable
      fall_ie : aliased Bitmap_32
         with Address              => System'To_Address (GPIO_BASEADDRESS + 16#20#),
              Volatile_Full_Access => True,
              Import               => True,
              Convention           => Ada;

      -- Fall interrupt pending
      fall_ip : aliased Bitmap_32
         with Address              => System'To_Address (GPIO_BASEADDRESS + 16#24#),
              Volatile_Full_Access => True,
              Import               => True,
              Convention           => Ada;

      -- High interrupt enable
      high_ie : aliased Bitmap_32
         with Address              => System'To_Address (GPIO_BASEADDRESS + 16#28#),
              Volatile_Full_Access => True,
              Import               => True,
              Convention           => Ada;

      -- High interrupt pending
      high_ip : aliased Bitmap_32
         with Address              => System'To_Address (GPIO_BASEADDRESS + 16#2C#),
              Volatile_Full_Access => True,
              Import               => True,
              Convention           => Ada;

      -- Low interrupt enable
      low_ie : aliased Bitmap_32
         with Address              => System'To_Address (GPIO_BASEADDRESS + 16#30#),
              Volatile_Full_Access => True,
              Import               => True,
              Convention           => Ada;

      -- Low interrupt pending
      low_ip : aliased Bitmap_32
         with Address              => System'To_Address (GPIO_BASEADDRESS + 16#34#),
              Volatile_Full_Access => True,
              Import               => True,
              Convention           => Ada;

      -- I/O function enable
      iof_en : aliased Bitmap_32
         with Address              => System'To_Address (GPIO_BASEADDRESS + 16#38#),
              Volatile_Full_Access => True,
              Import               => True,
              Convention           => Ada;

      -- I/O function select
      iof_sel : aliased Bitmap_32
         with Address              => System'To_Address (GPIO_BASEADDRESS + 16#3C#),
              Volatile_Full_Access => True,
              Import               => True,
              Convention           => Ada;

      -- Output XOR (invert)
      out_xor : aliased Bitmap_32
         with Address              => System'To_Address (GPIO_BASEADDRESS + 16#40#),
              Volatile_Full_Access => True,
              Import               => True,
              Convention           => Ada;

      -- Pass-through active-high interrupt enable
      passthru_high_ie : aliased Bitmap_32
         with Address              => System'To_Address (GPIO_BASEADDRESS + 16#44#),
              Volatile_Full_Access => True,
              Import               => True,
              Convention           => Ada;

      -- Pass-through active-low interrupt enable
      passthru_low_ie : aliased Bitmap_32
         with Address              => System'To_Address (GPIO_BASEADDRESS + 16#48#),
              Volatile_Full_Access => True,
              Import               => True,
              Convention           => Ada;

   end GPIO;

   ----------------------------------------------------------------------------
   -- 18 Universal Asynchronous Receiver/Transmitter (UART)
   ----------------------------------------------------------------------------

   package UART
      is

      UART0_BASEADDRESS : constant := 16#1001_3000#;
      UART1_BASEADDRESS : constant := 16#1002_3000#;

      -- 18.4 Transmit Data Register (txdata)

      type txdata_Type is record
         txdata   : Unsigned_8;          -- Transmit data
         Reserved : Bits_23    := 0;
         full     : Boolean    := False; -- Transmit FIFO full (RO)
      end record
         with Bit_Order   => Low_Order_First,
              Object_Size => 32;
      for txdata_Type use record
         txdata   at 0 range  0 ..  7;
         Reserved at 0 range  8 .. 30;
         full     at 0 range 31 .. 31;
      end record;

      -- 18.5 Receive Data Register (rxdata)

      type rxdata_Type is record
         rxdata   : Unsigned_8;          -- Received data (RO)
         Reserved : Bits_23    := 0;
         empty    : Boolean    := False; -- Receive FIFO empty (RO)
      end record
         with Bit_Order   => Low_Order_First,
              Object_Size => 32;
      for rxdata_Type use record
         rxdata   at 0 range  0 ..  7;
         Reserved at 0 range  8 .. 30;
         empty    at 0 range 31 .. 31;
      end record;

      -- 18.6 Transmit Control Register (txctrl)

      nstop_1 : constant := 0; -- one stop bit
      nstop_2 : constant := 1; -- two stop bits

      type txctrl_Type is record
         txen      : Boolean;      -- Transmit enable
         nstop     : Bits_1;       -- Number of stop bits
         Reserved1 : Bits_14 := 0;
         txcnt     : Bits_3;       -- Transmit watermark level
         Reserved2 : Bits_13 := 0;
      end record
         with Bit_Order   => Low_Order_First,
              Object_Size => 32;
      for txctrl_Type use record
         txen      at 0 range  0 ..  0;
         nstop     at 0 range  1 ..  1;
         Reserved1 at 0 range  2 .. 15;
         txcnt     at 0 range 16 .. 18;
         Reserved2 at 0 range 19 .. 31;
      end record;

      -- 18.7 Receive Control Register (rxctrl)

      type rxctrl_Type is record
         rxen      : Boolean;      -- Receive enable
         Reserved1 : Bits_15 := 0;
         rxcnt     : Bits_3;       -- Receive watermark level
         Reserved2 : Bits_13 := 0;
      end record
         with Bit_Order   => Low_Order_First,
              Object_Size => 32;
      for rxctrl_Type use record
         rxen      at 0 range  0 ..  0;
         Reserved1 at 0 range  1 .. 15;
         rxcnt     at 0 range 16 .. 18;
         Reserved2 at 0 range 19 .. 31;
      end record;

      -- 18.8 Interrupt Registers (ip and ie)

      type ie_Type is record
         txwm     : Boolean;      -- Transmit watermark interrupt enable
         rxwm     : Boolean;      -- Receive watermark interrupt enable
         Reserved : Bits_30 := 0;
      end record
         with Bit_Order   => Low_Order_First,
              Object_Size => 32;
      for ie_Type use record
         txwm     at 0 range 0 ..  0;
         rxwm     at 0 range 1 ..  1;
         Reserved at 0 range 2 .. 31;
      end record;

      type ip_Type is record
         txwm     : Boolean;      -- Transmit watermark interrupt pending
         rxwm     : Boolean;      -- Receive watermark interrupt pending
         Reserved : Bits_30 := 0;
      end record
         with Bit_Order   => Low_Order_First,
              Object_Size => 32;
      for ip_Type use record
         txwm     at 0 range 0 ..  0;
         rxwm     at 0 range 1 ..  1;
         Reserved at 0 range 2 .. 31;
      end record;

      -- 18.9 Baud Rate Divisor Register (div)

      type div_Type is record
         div      : Unsigned_16;      -- Baud rate divisor.
         Reserved : Bits_16     := 0;
      end record
         with Bit_Order   => Low_Order_First,
              Object_Size => 32;
      for div_Type use record
         div      at 0 range  0 .. 15;
         Reserved at 0 range 16 .. 31;
      end record;

      -- 18.3 Memory Map

      type UART_Type is record
         txdata : txdata_Type with Volatile_Full_Access => True;
         rxdata : rxdata_Type with Volatile_Full_Access => True;
         txctrl : txctrl_Type with Volatile_Full_Access => True;
         rxctrl : rxctrl_Type with Volatile_Full_Access => True;
         ie     : ie_Type     with Volatile_Full_Access => True;
         ip     : ip_Type     with Volatile_Full_Access => True;
         div    : div_Type    with Volatile_Full_Access => True;
      end record
         with Object_Size => 7 * 32;
      for UART_Type use record
         txdata at 16#00# range 0 .. 31;
         rxdata at 16#04# range 0 .. 31;
         txctrl at 16#08# range 0 .. 31;
         rxctrl at 16#0C# range 0 .. 31;
         ie     at 16#10# range 0 .. 31;
         ip     at 16#14# range 0 .. 31;
         div    at 16#18# range 0 .. 31;
      end record;

      UART0 : aliased UART_Type
         with Address    => System'To_Address (UART0_BASEADDRESS),
              Volatile   => True,
              Import     => True,
              Convention => Ada;

      UART1 : aliased UART_Type
         with Address    => System'To_Address (UART1_BASEADDRESS),
              Volatile   => True,
              Import     => True,
              Convention => Ada;

   end UART;

   ----------------------------------------------------------------------------
   -- 19 Serial Peripheral Interface (SPI)
   ----------------------------------------------------------------------------

   package SPI
      is

      QSPI0_BASEADDRESS : constant := 16#1001_4000#;
      SPI1_BASEADDRESS  : constant := 16#1002_4000#;
      SPI2_BASEADDRESS  : constant := 16#1003_4000#;

      -- protocol definitions for
      -- fmt.proto
      -- ffmt.[cmd_proto|addr_proto|data_proto]

      type proto_Type is new Bits_2 range 0 .. 2#10#;
      proto_SINGLE : constant proto_Type := 2#00#; -- DQ0 (MOSI), DQ1 (MISO)
      proto_DUAL   : constant proto_Type := 2#01#; -- DQ0, DQ1
      proto_QUAD   : constant proto_Type := 2#10#; -- DQ0, DQ1, DQ2, DQ3

      -- 19.4 Serial Clock Divisor Register (sckdiv)

      sckdiv_div8 : constant := 3;

      type sckdiv_Type is record
         div      : Bits_12 := sckdiv_div8;
         Reserved : Bits_20 := 0;
      end record
         with Bit_Order   => Low_Order_First,
              Object_Size => 32;
      for sckdiv_Type use record
         div      at 0 range  0 .. 11;
         Reserved at 0 range 12 .. 31;
      end record;

      type sckdiv_divisor_Type is range 2 .. 8192;

      function sckdiv
         (Divisor : sckdiv_divisor_Type)
         return Bits_12
         with Inline => True;

      -- 19.5 Serial Clock Mode Register (sckmode)

      pha_SALSHT : constant := 0; -- Data is sampled on the leading edge of SCK and shifted on the trailing edge of SCK
      pha_SHLSAT : constant := 1; -- Data is shifted on the leading edge of SCK and sampled on the trailing edge of SCK

      pol_INACTIVE0 : constant := 0; -- Inactive state of SCK is logical 0
      pol_INACTIVE1 : constant := 1; -- Inactive state of SCK is logical 1

      type sckmode_Type is record
         pha      : Bits_1  := 0; -- Serial clock phase
         pol      : Bits_1  := 0; -- Serial clock polarity
         Reserved : Bits_30 := 0;
      end record
         with Bit_Order   => Low_Order_First,
              Object_Size => 32;
      for sckmode_Type use record
         pha      at 0 range 0 ..  0;
         pol      at 0 range 1 ..  1;
         Reserved at 0 range 2 .. 31;
      end record;

      -- 19.8 Chip Select Mode Register (csmode)

      mode_AUTO : constant := 2#00#; -- Assert/deassert CS at the beginning/end of each frame
      mode_HOLD : constant := 2#10#; -- Keep CS continuously asserted after the initial frame
      mode_OFF  : constant := 2#11#; -- Disable hardware control of the CS pin

      type csmode_Type is record
         mode     : Bits_2  := 0; -- Chip select mode
         Reserved : Bits_30 := 0;
      end record
         with Bit_Order   => Low_Order_First,
              Object_Size => 32;
      for csmode_Type use record
         mode     at 0 range 0 ..  1;
         Reserved at 0 range 2 .. 31;
      end record;

      -- 19.9 Delay Control Registers (delay0 and delay1)

      type delay0_Type is record
         cssck     : Unsigned_8 := 1; -- CS to SCK Delay
         Reserved1 : Bits_8     := 0;
         sckcs     : Unsigned_8 := 1; -- SCK to CS Delay
         Reserved2 : Bits_8     := 0;
      end record
         with Bit_Order   => Low_Order_First,
              Object_Size => 32;
      for delay0_Type use record
         cssck     at 0 range  0 ..  7;
         Reserved1 at 0 range  8 .. 15;
         sckcs     at 0 range 16 .. 23;
         Reserved2 at 0 range 24 .. 31;
      end record;

      type delay1_Type is record
         intercs   : Unsigned_8 := 1; -- Minimum CS inactive time
         Reserved1 : Bits_8     := 0;
         interxfr  : Unsigned_8 := 0; -- Maximum interframe delay
         Reserved2 : Bits_8     := 0;
      end record
         with Bit_Order   => Low_Order_First,
              Object_Size => 32;
      for delay1_Type use record
         intercs   at 0 range  0 ..  7;
         Reserved1 at 0 range  8 .. 15;
         interxfr  at 0 range 16 .. 23;
         Reserved2 at 0 range 24 .. 31;
      end record;

      -- 19.10 Frame Format Register (fmt)

      endian_MSB : constant := 0; -- Transmit most-significant bit (MSB) first
      endian_LSB : constant := 1; -- Transmit least-significant bit (LSB) first

      dir_RX : constant := 0; -- dual, quad -> DQ tri-stated. single -> DQ0 transmit data.
      dir_TX : constant := 1; -- The receive FIFO is not populated.

      type fmt_Type is record
         proto     : proto_Type := proto_SINGLE; -- SPI protocol
         endian    : Bits_1     := endian_MSB;   -- SPI endianness
         dir       : Bits_1     := dir_RX;       -- SPI I/O direction.
         Reserved1 : Bits_12    := 0;
         len       : Bits_4     := 8;            -- Number of bits per frame
         Reserved2 : Bits_12    := 0;
      end record
         with Bit_Order   => Low_Order_First,
              Object_Size => 32;
      for fmt_Type use record
         proto     at 0 range  0 ..  1;
         endian    at 0 range  2 ..  2;
         dir       at 0 range  3 ..  3;
         Reserved1 at 0 range  4 .. 15;
         len       at 0 range 16 .. 19;
         Reserved2 at 0 range 20 .. 31;
      end record;

      -- 19.11 Transmit Data Register (txdata)

      type txdata_Type is record
         txdata   : Unsigned_8;          -- Transmit data
         Reserved : Bits_23    := 0;
         full     : Boolean    := False; -- FIFO full flag (RO)
      end record
         with Bit_Order   => Low_Order_First,
              Object_Size => 32;
      for txdata_Type use record
         txdata   at 0 range  0 ..  7;
         Reserved at 0 range  8 .. 30;
         full     at 0 range 31 .. 31;
      end record;

      -- 19.12 Receive Data Register (rxdata)

      type rxdata_Type is record
         rxdata   : Unsigned_8;          -- Received data (RO)
         Reserved : Bits_23    := 0;
         empty    : Boolean    := False; -- FIFO empty flag (RO)
      end record
         with Bit_Order   => Low_Order_First,
              Object_Size => 32;
      for rxdata_Type use record
         rxdata   at 0 range  0 ..  7;
         Reserved at 0 range  8 .. 30;
         empty    at 0 range 31 .. 31;
      end record;

      -- 19.13 Transmit Watermark Register (txmark)

      type txmark_Type is record
         txmark   : Bits_3  := 0; -- Transmit watermark.
         Reserved : Bits_29 := 0;
      end record
         with Bit_Order   => Low_Order_First,
              Object_Size => 32;
      for txmark_Type use record
         txmark   at 0 range 0 ..  2;
         Reserved at 0 range 3 .. 31;
      end record;

      -- 19.14 Receive Watermark Register (rxmark)

      type rxmark_Type is record
         rxmark   : Bits_3  := 0; -- Receive watermark
         Reserved : Bits_29 := 0;
      end record
         with Bit_Order   => Low_Order_First,
              Object_Size => 32;
      for rxmark_Type use record
         rxmark   at 0 range 0 ..  2;
         Reserved at 0 range 3 .. 31;
      end record;

      -- 19.15 SPI Interrupt Registers (ie and ip)

      type ie_Type is record
         txwm     : Boolean := False; -- Transmit watermark enable
         rxwm     : Boolean := False; -- Receive watermark enable
         Reserved : Bits_30 := 0;
      end record
         with Bit_Order   => Low_Order_First,
              Object_Size => 32;
      for ie_Type use record
         txwm     at 0 range 0 ..  0;
         rxwm     at 0 range 1 ..  1;
         Reserved at 0 range 2 .. 31;
      end record;

      type ip_Type is record
         txwm     : Boolean := False; -- Transmit watermark pending
         rxwm     : Boolean := False; -- Receive watermark pending
         Reserved : Bits_30 := 0;
      end record
         with Bit_Order   => Low_Order_First,
              Object_Size => 32;
      for ip_Type use record
         txwm     at 0 range 0 ..  0;
         rxwm     at 0 range 1 ..  1;
         Reserved at 0 range 2 .. 31;
      end record;

      -- 19.16 SPI Flash Interface Control Register (fctrl)

      type fctrl_Type is record
         en       : Boolean := True; -- SPI Flash Mode Select
         Reserved : Bits_31 := 0;
      end record
         with Bit_Order   => Low_Order_First,
              Object_Size => 32;
      for fctrl_Type use record
         en       at 0 range 0 ..  0;
         Reserved at 0 range 1 .. 31;
      end record;

      -- 19.17 SPI Flash Instruction Format Register (ffmt)

      type ffmt_Type is record
         cmd_en     : Boolean    := True;         -- Enable sending of command
         addr_len   : Bits_3     := 3;            -- Number of address bytes (0 to 4)
         pad_cnt    : Bits_4     := 0;            -- Number of dummy cycles
         cmd_proto  : proto_Type := proto_SINGLE; -- Protocol for transmitting command
         addr_proto : proto_Type := proto_SINGLE; -- Protocol for transmitting address and padding
         data_proto : proto_Type := proto_SINGLE; -- Protocol for receiving data bytes
         Reserved   : Bits_2     := 0;
         cmd_code   : Unsigned_8 := 3;            -- Value of command byte
         pad_code   : Unsigned_8 := 0;            -- First 8 bits to transmit during dummy cycles
      end record
         with Bit_Order   => Low_Order_First,
              Object_Size => 32;
      for ffmt_Type use record
         cmd_en     at 0 range  0 ..  0;
         addr_len   at 0 range  1 ..  3;
         pad_cnt    at 0 range  4 ..  7;
         cmd_proto  at 0 range  8 ..  9;
         addr_proto at 0 range 10 .. 11;
         data_proto at 0 range 12 .. 13;
         Reserved   at 0 range 14 .. 15;
         cmd_code   at 0 range 16 .. 23;
         pad_code   at 0 range 24 .. 31;
      end record;

      -- 19.3 Memory Map

      type SPI_Type is record
         sckdiv  : sckdiv_Type  with Volatile_Full_Access => True;
         sckmode : sckmode_Type with Volatile_Full_Access => True;
         csid    : Unsigned_32  with Volatile_Full_Access => True;
         csdef   : Unsigned_32  with Volatile_Full_Access => True;
         csmode  : csmode_Type  with Volatile_Full_Access => True;
         delay0  : delay0_Type  with Volatile_Full_Access => True;
         delay1  : delay1_Type  with Volatile_Full_Access => True;
         fmt     : fmt_Type     with Volatile_Full_Access => True;
         txdata  : txdata_Type  with Volatile_Full_Access => True;
         rxdata  : rxdata_Type  with Volatile_Full_Access => True;
         txmark  : txmark_Type  with Volatile_Full_Access => True;
         rxmark  : rxmark_Type  with Volatile_Full_Access => True;
         fctrl   : fctrl_Type   with Volatile_Full_Access => True;
         ffmt    : ffmt_Type    with Volatile_Full_Access => True;
         ie      : ie_Type      with Volatile_Full_Access => True;
         ip      : ip_Type      with Volatile_Full_Access => True;
      end record
         with Object_Size => 16#78# * 8;
      for SPI_Type use record
         sckdiv  at 16#00# range 0 .. 31;
         sckmode at 16#04# range 0 .. 31;
         csid    at 16#10# range 0 .. 31;
         csdef   at 16#14# range 0 .. 31;
         csmode  at 16#18# range 0 .. 31;
         delay0  at 16#28# range 0 .. 31;
         delay1  at 16#2C# range 0 .. 31;
         fmt     at 16#40# range 0 .. 31;
         txdata  at 16#48# range 0 .. 31;
         rxdata  at 16#4C# range 0 .. 31;
         txmark  at 16#50# range 0 .. 31;
         rxmark  at 16#54# range 0 .. 31;
         fctrl   at 16#60# range 0 .. 31;
         ffmt    at 16#64# range 0 .. 31;
         ie      at 16#70# range 0 .. 31;
         ip      at 16#74# range 0 .. 31;
      end record;

      -- QSPI0: Flash Controller = Y, cs_width = 1, div_width = 12

      QSPI0 : aliased SPI_Type
         with Address    => System'To_Address (QSPI0_BASEADDRESS),
              Volatile   => True,
              Import     => True,
              Convention => Ada;

      -- SPI1: Flash Controller = N, cs_width = 4, div_width = 12

      SPI1 : aliased SPI_Type
         with Address    => System'To_Address (SPI1_BASEADDRESS),
              Volatile   => True,
              Import     => True,
              Convention => Ada;

      -- SPI2: Flash Controller = N, cs_width = 1, div_width = 12

      SPI2 : aliased SPI_Type
         with Address    => System'To_Address (SPI2_BASEADDRESS),
              Volatile   => True,
              Import     => True,
              Convention => Ada;

   end SPI;

   ----------------------------------------------------------------------------
   -- 20 Pulse Width Modulator (PWM)
   ----------------------------------------------------------------------------

   package PWM
      is

      PWM0_BASEADDRESS : constant := 16#1001_5000#;
      PWM1_BASEADDRESS : constant := 16#1002_5000#;
      PWM2_BASEADDRESS : constant := 16#1003_5000#;

      -- 20.4 PWM Count Register (pwmcount)

      type pwmcount8_Type is record
         pwmcount : Bits_23;      -- PWM count register. cmpwidth + 15 bits wide.
         Reserved : Bits_9  := 0;
      end record
         with Bit_Order   => Low_Order_First,
              Object_Size => 32;
      for pwmcount8_Type use record
         pwmcount at 0 range  0 .. 22;
         Reserved at 0 range 23 .. 31;
      end record;

      type pwmcount16_Type is record
         pwmcount : Bits_31;      -- PWM count register. cmpwidth + 15 bits wide.
         Reserved : Bits_1  := 0;
      end record
         with Bit_Order   => Low_Order_First,
              Object_Size => 32;
      for pwmcount16_Type use record
         pwmcount at 0 range  0 .. 30;
         Reserved at 0 range 31 .. 31;
      end record;

      -- 20.5 PWM Configuration Register (pwmcfg)

      type pwmcfg_Type is record
         pwmscale      : Bits_4;       -- PWM Counter scale
         Reserved1     : Bits_4  := 0;
         pwmsticky     : Boolean;      -- PWM Sticky - disallow clearing pwmcmp ip bits
         pwmzerocmp    : Boolean;      -- PWM Zero - counter resets to zero after match
         pwmdeglitch   : Boolean;      -- PWM Deglitch - latch pwmcmp ip within same cycle
         Reserved2     : Bits_1  := 0;
         pwmenalways   : Boolean;      -- PWM enable always - run continuously
         pwmenoneshot  : Boolean;      -- PWM enable one shot - run one cycle
         Reserved3     : Bits_2  := 0;
         pwmcmp0center : Boolean;      -- PWM0 Compare Center
         pwmcmp1center : Boolean;      -- PWM1 Compare Center
         pwmcmp2center : Boolean;      -- PWM2 Compare Center
         pwmcmp3center : Boolean;      -- PWM3 Compare Center
         Reserved4     : Bits_4  := 0;
         pwmcmp0gang   : Boolean;      -- PWM0/PWM1 Compare Gang
         pwmcmp1gang   : Boolean;      -- PWM1/PWM2 Compare Gang
         pwmcmp2gang   : Boolean;      -- PWM2/PWM3 Compare Gang
         pwmcmp3gang   : Boolean;      -- PWM3/PWM0 Compare Gang
         pwmcmp0ip     : Boolean;      -- PWM0 Interrupt Pending
         pwmcmp1ip     : Boolean;      -- PWM1 Interrupt Pending
         pwmcmp2ip     : Boolean;      -- PWM2 Interrupt Pending
         pwmcmp3ip     : Boolean;      -- PWM3 Interrupt Pending
      end record
         with Bit_Order   => Low_Order_First,
              Object_Size => 32;
      for pwmcfg_Type use record
         pwmscale      at 0 range  0 ..  3;
         Reserved1     at 0 range  4 ..  7;
         pwmsticky     at 0 range  8 ..  8;
         pwmzerocmp    at 0 range  9 ..  9;
         pwmdeglitch   at 0 range 10 .. 10;
         Reserved2     at 0 range 11 .. 11;
         pwmenalways   at 0 range 12 .. 12;
         pwmenoneshot  at 0 range 13 .. 13;
         Reserved3     at 0 range 14 .. 15;
         pwmcmp0center at 0 range 16 .. 16;
         pwmcmp1center at 0 range 17 .. 17;
         pwmcmp2center at 0 range 18 .. 18;
         pwmcmp3center at 0 range 19 .. 19;
         Reserved4     at 0 range 20 .. 23;
         pwmcmp0gang   at 0 range 24 .. 24;
         pwmcmp1gang   at 0 range 25 .. 25;
         pwmcmp2gang   at 0 range 26 .. 26;
         pwmcmp3gang   at 0 range 27 .. 27;
         pwmcmp0ip     at 0 range 28 .. 28;
         pwmcmp1ip     at 0 range 29 .. 29;
         pwmcmp2ip     at 0 range 30 .. 30;
         pwmcmp3ip     at 0 range 31 .. 31;
      end record;

      -- 20.6 Scaled PWM Count Register (pwms)

      type pwms8_Type is record
         pwms     : Bits_8;       -- Scaled PWM count register. cmpwidth bits wide.
         Reserved : Bits_24 := 0;
      end record
         with Bit_Order   => Low_Order_First,
              Object_Size => 32;
      for pwms8_Type use record
         pwms     at 0 range 0 ..  7;
         Reserved at 0 range 8 .. 31;
      end record;

      type pwms16_Type is record
         pwms     : Bits_16;      -- Scaled PWM count register. cmpwidth bits wide.
         Reserved : Bits_16 := 0;
      end record
         with Bit_Order   => Low_Order_First,
              Object_Size => 32;
      for pwms16_Type use record
         pwms     at 0 range  0 .. 15;
         Reserved at 0 range 16 .. 31;
      end record;

      -- 20.7 PWM Compare Registers (pwmcmp0–pwmcmp3)

      type pwmcmp8_Type is record
         pwmcmp   : Bits_8;       -- PWM [0 .. 3] Compare Value
         Reserved : Bits_24 := 0;
      end record
         with Bit_Order   => Low_Order_First,
              Object_Size => 32;
      for pwmcmp8_Type use record
         pwmcmp   at 0 range 0 ..  7;
         Reserved at 0 range 8 .. 31;
      end record;

      type pwmcmp16_Type is record
         pwmcmp   : Bits_16;      -- PWM [0 .. 3] Compare Value
         Reserved : Bits_16 := 0;
      end record
         with Bit_Order   => Low_Order_First,
              Object_Size => 32;
      for pwmcmp16_Type use record
         pwmcmp   at 0 range  0 .. 15;
         Reserved at 0 range 16 .. 31;
      end record;

      -- 20.3 PWM Memory Map

      type pwm_cmpwidth8_Type is record
         pwmcfg    : pwmcfg_Type    with Volatile_Full_Access => True;
         Reserved1 : Bits_32;
         pwmcount  : pwmcount8_Type with Volatile_Full_Access => True;
         Reserved2 : Bits_32;
         pwms      : pwms8_Type     with Volatile_Full_Access => True;
         Reserved3 : Bits_32;
         Reserved4 : Bits_32;
         Reserved5 : Bits_32;
         pwmcmp0   : pwmcmp8_Type   with Volatile_Full_Access => True;
         pwmcmp1   : pwmcmp8_Type   with Volatile_Full_Access => True;
         pwmcmp2   : pwmcmp8_Type   with Volatile_Full_Access => True;
         pwmcmp3   : pwmcmp8_Type   with Volatile_Full_Access => True;
      end record
         with Object_Size => 16#30# * 8;
      for pwm_cmpwidth8_Type use record
         pwmcfg    at 16#00# range 0 .. 31;
         Reserved1 at 16#04# range 0 .. 31;
         pwmcount  at 16#08# range 0 .. 31;
         Reserved2 at 16#0C# range 0 .. 31;
         pwms      at 16#10# range 0 .. 31;
         Reserved3 at 16#14# range 0 .. 31;
         Reserved4 at 16#18# range 0 .. 31;
         Reserved5 at 16#1C# range 0 .. 31;
         pwmcmp0   at 16#20# range 0 .. 31;
         pwmcmp1   at 16#24# range 0 .. 31;
         pwmcmp2   at 16#28# range 0 .. 31;
         pwmcmp3   at 16#2C# range 0 .. 31;
      end record;

      PWM0 : aliased pwm_cmpwidth8_Type
         with Address    => System'To_Address (PWM0_BASEADDRESS),
              Volatile   => True,
              Import     => True,
              Convention => Ada;

      type pwm_cmpwidth16_Type is record
         pwmcfg    : pwmcfg_Type     with Volatile_Full_Access => True;
         Reserved1 : Bits_32;
         pwmcount  : pwmcount16_Type with Volatile_Full_Access => True;
         Reserved2 : Bits_32;
         pwms      : pwms16_Type     with Volatile_Full_Access => True;
         Reserved3 : Bits_32;
         Reserved4 : Bits_32;
         Reserved5 : Bits_32;
         pwmcmp0   : pwmcmp16_Type   with Volatile_Full_Access => True;
         pwmcmp1   : pwmcmp16_Type   with Volatile_Full_Access => True;
         pwmcmp2   : pwmcmp16_Type   with Volatile_Full_Access => True;
         pwmcmp3   : pwmcmp16_Type   with Volatile_Full_Access => True;
      end record
         with Object_Size => 16#30# * 8;
      for pwm_cmpwidth16_Type use record
         pwmcfg    at 16#00# range 0 .. 31;
         Reserved1 at 16#04# range 0 .. 31;
         pwmcount  at 16#08# range 0 .. 31;
         Reserved2 at 16#0C# range 0 .. 31;
         pwms      at 16#10# range 0 .. 31;
         Reserved3 at 16#14# range 0 .. 31;
         Reserved4 at 16#18# range 0 .. 31;
         Reserved5 at 16#1C# range 0 .. 31;
         pwmcmp0   at 16#20# range 0 .. 31;
         pwmcmp1   at 16#24# range 0 .. 31;
         pwmcmp2   at 16#28# range 0 .. 31;
         pwmcmp3   at 16#2C# range 0 .. 31;
      end record;

      PWM1 : aliased pwm_cmpwidth16_Type
         with Address    => System'To_Address (PWM1_BASEADDRESS),
              Volatile   => True,
              Import     => True,
              Convention => Ada;

      PWM2 : aliased pwm_cmpwidth16_Type
         with Address    => System'To_Address (PWM2_BASEADDRESS),
              Volatile   => True,
              Import     => True,
              Convention => Ada;

   end PWM;

pragma Style_Checks (On);

end HiFive1;

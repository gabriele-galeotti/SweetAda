-----------------------------------------------------------------------------------------------------------------------
--                                                     SweetAda                                                      --
-----------------------------------------------------------------------------------------------------------------------
-- __HDS__                                                                                                           --
-- __FLN__ clocks.adb                                                                                                --
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

with Definitions;
with CPU;
with HiFive1;

package body Clocks
   is

   --========================================================================--
   --                                                                        --
   --                                                                        --
   --                           Local declarations                           --
   --                                                                        --
   --                                                                        --
   --========================================================================--

   --========================================================================--
   --                                                                        --
   --                                                                        --
   --                           Package subprograms                          --
   --                                                                        --
   --                                                                        --
   --========================================================================--

   ----------------------------------------------------------------------------
   -- Init
   ----------------------------------------------------------------------------
   procedure Init
      is
      use Definitions;
      use HiFive1.PRCI;
   begin
      -- external clock frequency = 16 MHz
      plloutdiv := (
         plloutdivby1 => plloutdivby1_SET, -- PLL Final Divide By 1
         others       => <>
         );
      pllcfg := (
         pllr      => pllr_div2,        -- divide by 2, PLL drive = 8 MHz
         -- pllf      => pllf_x8,          -- x8 multiply factor = 64 MHz --> 16 MHz
         -- pllf      => pllf_x16,         -- x16 multiply factor = 128 MHz --> 32 MHz
         pllf      => pllf_x32,         -- x32 multiply factor = 256 MHz --> 64 MHz
         pllq      => pllq_div4,        -- divide by 4
         pllsel    => pllsel_PLL,
         pllrefsel => pllrefsel_HFXOSC, -- PLL driven by external clock
         pllbypass => False,            -- enable PLL
         others    => <>
         );
      -- wait for PLL to settle down
      loop
         exit when pllcfg.plllock;
         for D3lay in 1 .. 2**20 loop CPU.NOP; end loop;
      end loop;
      -- setup values
      case pllcfg.pllf is
         when pllf_x8  => CLK_Core := 16 * MHz1;
         when pllf_x16 => CLK_Core := 32 * MHz1;
         when pllf_x32 => CLK_Core := 64 * MHz1;
         when others   => raise Constraint_Error;
      end case;
   end Init;

end Clocks;

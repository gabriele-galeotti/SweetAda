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
      hfxosccfg.hfxoscen := True;
      loop exit when hfxosccfg.hfxoscrdy; end loop;
      pllcfg := (
         --
         pllr      => pllr_div2,        -- divide by 2, PLL drive = 8 MHz
         -- Note: the reference manual is ambiguous in that it specifies no
         -- clear maximum value for the PLL frequency; it reports a VCO output
         -- range 384..768 MHz (Figure 3: "Controlling the FE310-G002 PLL
         -- output frequency."), but a previous diagram (Figure 2: "FE310-G002
         -- clock generation scheme") labels the VCO in the range 50..400 MHz
         -- pllf      => pllf_x16,         -- x16 multiply factor -> vco = 128 MHz -> (pllq_div2) pllout = 64 MHz
         -- pllf      => pllf_x32,         -- x32 multiply factor -> vco = 256 MHz -> (pllq_div2) pllout = 128 MHz
         pllf      => pllf_x48,         -- x48 multiply factor -> vco = 384 MHz -> (pllq_div2) pllout = 192 MHz
         -- pllf      => pllf_x64,         -- x64 multiply factor -> vco = 512 MHz -> (pllq_div2) pllout = 256 MHz
         -- pllf      => pllf_x96,         -- x96 multiply factor -> vco = 768 MHz -> (pllq_div2) pllout = 384 MHz
         pllq      => pllq_div2,        -- divide by 2
         pllrefsel => pllrefsel_HFXOSC, -- PLL driven by external clock
         pllbypass => False,            -- enable PLL
         others    => <>
         );
      -- PLL Final Divide By 1
      plloutdiv.plloutdivby1 := plloutdivby1_SET;
      -- wait for PLL to settle down
      declare
         locks : Integer := 0;
      begin
         loop
            for D3lay in 0 .. 2**16 loop CPU.NOP; end loop;
            if pllcfg.plllock then
               locks := @ + 1;
            else
               locks := 0;
            end if;
            exit when locks > 3;
         end loop;
      end;
      -- enable PLL
      pllcfg.pllsel := pllsel_PLL;
      -- setup values
      case pllcfg.pllf is
         when pllf_x16 => CLK_Core := 64 * MHz1;
         when pllf_x32 => CLK_Core := 128 * MHz1;
         when pllf_x48 => CLK_Core := 192 * MHz1;
         when pllf_x64 => CLK_Core := 256 * MHz1;
         when pllf_x96 => CLK_Core := 384 * MHz1;
         when others   => raise Constraint_Error;
      end case;
      -- disable hfrosc to save power
      hfrosccfg.hfroscen := False;
   end Init;

end Clocks;

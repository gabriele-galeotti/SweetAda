
with Interfaces;
with Bits;
with STM32F769I;
with CPU;

package body Application is

   --========================================================================--
   --                                                                        --
   --                                                                        --
   --                           Local declarations                           --
   --                                                                        --
   --                                                                        --
   --========================================================================--

   use Interfaces;
   use Bits;
   use STM32F769I;

   --========================================================================--
   --                                                                        --
   --                                                                        --
   --                           Package subprograms                          --
   --                                                                        --
   --                                                                        --
   --========================================================================--

   ----------------------------------------------------------------------------
   -- Run
   ----------------------------------------------------------------------------
   procedure Run is
      Delay_Count : constant := 50_000_000;
   begin
      -- blink user LEDs LD1 & LD2 --------------------------------------------
      GPIOJ.MODER  := [5 | 13 => GPIO_OUT, others => <>];
      GPIOJ.OTYPER := [5 | 13 => GPIO_PP, others => <>];
      GPIOJ.PUPDR  := [others => GPIO_NOPUPD];
      while True loop
         if False then
            -- direct output values
            GPIOJ.ODR := [5 | 13 => BITON, others => <>];
            for Delay_Loop_Count in 1 .. Delay_Count loop CPU.NOP; end loop;
            GPIOJ.ODR := [5 | 13 => BITOFF, others => <>];
            for Delay_Loop_Count in 1 .. Delay_Count loop CPU.NOP; end loop;
         else
            -- set/reset
            GPIOJ.BSRR.SET := [5 | 13 => True, others => <>];
            for Delay_Loop_Count in 1 .. Delay_Count loop CPU.NOP; end loop;
            GPIOJ.BSRR.RST := [5 | 13 => True, others => <>];
            for Delay_Loop_Count in 1 .. Delay_Count loop CPU.NOP; end loop;
         end if;
      end loop;
      -------------------------------------------------------------------------
      loop null; end loop;
      -------------------------------------------------------------------------
   end Run;

end Application;

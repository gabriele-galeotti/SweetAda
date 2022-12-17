
with Interfaces;
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
      dummy       : Unsigned_32;
   begin
      -- blink the two user LEDs LD1 & LD2
      --                           15 14 13 12 11 10  9  8  7  6  5  4  3  2  1  0
      PORT_GPIOJ.MODER.Value  := 2#00_00_01_00_00_00_00_00_00_00_01_00_00_00_00_00#;
      --                           10 98 76 54 32 10 98 76 54 32 10 98 76 54 32 10
      PORT_GPIOJ.OTYPER.Value := 2#00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00#;
      -- PORT_GPIOJ.OTYPER.Value := 2#00_00_00_00_00_00_00_00_00_10_00_00_00_10_00_00#;
      PORT_GPIOJ.PUPDR := 0;
      while True loop
         dummy := PORT_GPIOJ.ODR.Value;
         PORT_GPIOJ.ODR.Value := dummy or 16#0000_2020#;
         for Delay_Loop_Count in 1 .. Delay_Count loop CPU.NOP; end loop;
         PORT_GPIOJ.ODR.Value := dummy and 16#0000_DFDF#;
         for Delay_Loop_Count in 1 .. Delay_Count loop CPU.NOP; end loop;
      end loop;
      -------------------------------------------------------------------------
      loop null; end loop;
      -------------------------------------------------------------------------
   end Run;

end Application;

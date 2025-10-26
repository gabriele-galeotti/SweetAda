
with Interfaces;
with Bits;
with CPU;
with STM32F769I;
with Console;

package body Application
   is

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
   procedure Run
      is
   begin
      -------------------------------------------------------------------------
      if True then
         -- blink user LED LD2
         while True loop
            -- 1) toggle by using SET/RESET registers
            if GPIOJ.ODR (5) /= 0 then
               GPIOJ.BSRR.RST (5) := True;
            else
               GPIOJ.BSRR.SET (5) := True;
            end if;
            -- 2) toggle by reading back
            -- GPIOJ.ODR (5) := not @;
            Console.Print ("hello, SweetAda", NL => True);
            for Count in 1 .. 100_000_000 loop CPU.NOP; end loop;
         end loop;
      end if;
      -------------------------------------------------------------------------
      loop null; end loop;
      -------------------------------------------------------------------------
   end Run;

end Application;

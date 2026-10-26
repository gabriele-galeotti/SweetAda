
with CPU;
with MTIME;
with NEORV32;
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

   use NEORV32;

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
      if False then
         GPTMR.CSR1.PRSC.PRSC := PRSC_DIV64;
         GPTMR.CSR0.MODE (0) := MODE_CONTINUOUS;
         GPTMR.SLICE (0).THR := 16#0000_1000#;
         GPTMR.CSR0.ENABLE (0) := True;
         loop
            loop
               if GPTMR.CSR1.IRQ (0) then
                  Console.Print (Value => GPTMR.SLICE (0).CNT, NL => True);
                  GPTMR.CSR1.IRQ (0) := False;
                  exit;
               end if;
            end loop;
         end loop;
      end if;
      -------------------------------------------------------------------------
      if True then
         declare
            Delay_Count : constant := 500;
         begin
            loop
               Console.Print (Value => MTIME.mtime_Read, NL => True);
               for Delay_Loop_Count in 1 .. Delay_Count loop CPU.NOP; end loop;
            end loop;
         end;
      end if;
      -------------------------------------------------------------------------
      loop null; end loop;
      -------------------------------------------------------------------------
   end Run;

end Application;

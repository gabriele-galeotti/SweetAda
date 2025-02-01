
with CPU;
with MCF5373;
with ZOOM;
with Console;

package body Application
   is

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
         MCF5373.PAR_TIMER := (
            PAR_T0IN => MCF5373.PAR_T0IN_T0IN,
            PAR_T1IN => MCF5373.PAR_T1IN_T1IN,
            PAR_T2IN => MCF5373.PAR_T2IN_T2IN,
            PAR_T3IN => MCF5373.PAR_T3IN_GPIO  -- MFP9 - TIN3/TOUT3 mapped on LATCH U7 /2OE
            );
         MCF5373.PDDR_TIMER := (
            PDDR_0 => False,
            PDDR_1 => False,
            PDDR_2 => False,
            PDDR_3 => True,  -- drive LATCH U7 2/OE
            others => 0
            );
         MCF5373.PODR_TIMER := (
            PODR_0 => False,
            PODR_1 => False,
            PODR_2 => False,
            PODR_3 => False, -- LATCH U7 /2OE active low
            others => 0
            );
         loop
            Console.Print ("hello, SweetAda", NL => True);
            for Delay_Loop_Count in 1 .. 1_000_000 loop CPU.NOP; end loop;
            ZOOM.LATCH_U7.WRITE := (
               USB1_PWR_EN => True,
               USB2_PWR_EN => True,
               STATUS_1    => True,
               STATUS_2    => False,
               others      => False
               );
            for Delay_Loop_Count in 1 .. 1_000_000 loop CPU.NOP; end loop;
            ZOOM.LATCH_U7.WRITE := (
               USB1_PWR_EN => True,
               USB2_PWR_EN => True,
               STATUS_1    => False,
               STATUS_2    => True,
               others      => False
               );
         end loop;
      end if;
      -------------------------------------------------------------------------
      loop null; end loop;
      -------------------------------------------------------------------------
   end Run;

end Application;

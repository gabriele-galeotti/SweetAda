
with Interfaces;
with Bits;
with CPU;
with VMIPS;
with BSP;
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
         declare
            Seconds     : Unsigned_32;
            Delay_Count : constant := 1_000_000;
            -- C           : Character;
         begin
            loop
               -- BSP.Console_Getchar (C);
               -- BSP.Console_Putchar (C);
               Seconds := VMIPS.CLOCK.SECONDS_RT;
               if BigEndian then
                  Seconds := Byte_Swap (@);
               end if;
               Console.Print (Seconds, Prefix => "clock: ", NL => True);
               for Delay_Loop_Count in 1 .. Delay_Count loop CPU.NOP; end loop;
            end loop;
         end;
      end if;
      -------------------------------------------------------------------------
      loop null; end loop;
      -------------------------------------------------------------------------
   end Run;

end Application;

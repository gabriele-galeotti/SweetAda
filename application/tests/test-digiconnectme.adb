
with System.Storage_Elements;
with Interfaces;
with Bits;
with CPU;
with NETARM;
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

   use System.Storage_Elements;
   use Interfaces;
   use NETARM;

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
         --- RJ45 LED port enable ------------------------------------------------
         -- C6: CSF = 0, CDIR = 1 (OUT), CMODE = 0
         PORTC.CSF (bi6) := False;
         PORTC.CDIR (bi6) := True;
         PORTC.CMODE (bi6) := False;
         declare
            Delay_Count : constant := 1_000_000;
         begin
            loop
               PORTC.CDATA (bi6) := False;
               for Delay_Loop_Count in 1 .. Delay_Count loop CPU.NOP; end loop;
               PORTC.CDATA (bi6) := True;
               for Delay_Loop_Count in 1 .. Delay_Count loop CPU.NOP; end loop;
            end loop;
         end;
      end if;
      -------------------------------------------------------------------------
      if True then
         declare
            Delay_Count : constant := 1_000_000;
         begin
            loop
               Console.Print ("hello, SweetAda", NL => True);
               for Delay_Loop_Count in 1 .. Delay_Count loop CPU.NOP; end loop;
            end loop;
         end;
      end if;
      -------------------------------------------------------------------------
      loop null; end loop;
      -------------------------------------------------------------------------
   end Run;

end Application;

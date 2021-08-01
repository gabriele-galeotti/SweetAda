
with Interfaces;
with GHRD;

package body Application is

   --========================================================================--
   --                                                                        --
   --                                                                        --
   --                           Local declarations                           --
   --                                                                        --
   --                                                                        --
   --========================================================================--

   use Interfaces;
   use GHRD;

   --========================================================================--
   --                                                                        --
   --                                                                        --
   --                           Package subprograms                          --
   --                                                                        --
   --                                                                        --
   --========================================================================--

   procedure Run is
   begin
      -------------------------------------------------------------------------
      if True then
         declare
            Delay_Count : constant := 100_000_000;
            Dummy       : Unsigned_32 with Volatile => True;
         begin
            IOEMU_IO1 := 0;
            loop
               -- IOEMU GPIO test
               IOEMU_IO1 := IOEMU_IO1 + 1;
               for Delay_Loop_Count in 1 .. Delay_Count loop Dummy := Dummy + 1; end loop;
            end loop;
         end;
      end if;
      -------------------------------------------------------------------------
      loop null; end loop;
      -------------------------------------------------------------------------
   end Run;

end Application;
